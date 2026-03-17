import Database from "better-sqlite3";
import path from "path";
import fs from "fs";

const DB_PATH = path.join(process.cwd(), "dist", "bas-atlas.db");

// ---------------------------------------------------------------------------
// Interfaces
// ---------------------------------------------------------------------------

export interface ProposedChange {
  sql: string;
  confidence: "high" | "medium" | "low";
  reason: string;
  source_url?: string;
}

export interface ValidationResult {
  valid: boolean;
  error?: string;
}

export interface ValidatedChangeset {
  apply: ProposedChange[];
  review: ProposedChange[];
  rejected: Array<ProposedChange & { error: string }>;
}

// ---------------------------------------------------------------------------
// Regex helpers
// ---------------------------------------------------------------------------

/** Extract the target table name from an INSERT, UPDATE, or DELETE statement. */
function parseTableName(sql: string): string | null {
  const insertMatch = sql.match(/INSERT\s+(?:OR\s+\w+\s+)?INTO\s+(\w+)/i);
  if (insertMatch) return insertMatch[1];

  const updateMatch = sql.match(/UPDATE\s+(?:OR\s+\w+\s+)?(\w+)\s+SET/i);
  if (updateMatch) return updateMatch[1];

  const deleteMatch = sql.match(/DELETE\s+FROM\s+(\w+)/i);
  if (deleteMatch) return deleteMatch[1];

  return null;
}

/** Return true when the SQL is a DELETE statement. */
function isDelete(sql: string): boolean {
  return /^\s*DELETE\s/i.test(sql);
}

/** Return true when the SQL is an UPDATE statement. */
function isUpdate(sql: string): boolean {
  return /^\s*UPDATE\s/i.test(sql);
}

/** Return true when the SQL is an INSERT statement. */
function isInsert(sql: string): boolean {
  return /^\s*INSERT\s/i.test(sql);
}

/**
 * Extract column names and their literal values from a simple INSERT statement.
 *
 * Handles the form:
 *   INSERT INTO table (col1, col2, ...) VALUES ('val1', 'val2', ...)
 *   INSERT INTO table (col1, col2, ...) VALUES (?, ?, ...)  — ignored (parameterised)
 *
 * Returns a map of column -> value (strings unquoted, NULLs as null).
 */
function parseInsertValues(sql: string): Map<string, string | null> | null {
  const colsMatch = sql.match(
    /INSERT\s+(?:OR\s+\w+\s+)?INTO\s+\w+\s*\(([^)]+)\)/i,
  );
  const valsMatch = sql.match(/VALUES\s*\(([^)]+)\)/i);

  if (!colsMatch || !valsMatch) return null;

  const columns = colsMatch[1].split(",").map((c) => c.trim().replace(/["`]/g, ""));
  const rawValues = splitValues(valsMatch[1]);

  if (columns.length !== rawValues.length) return null;

  const map = new Map<string, string | null>();
  for (let i = 0; i < columns.length; i++) {
    const raw = rawValues[i].trim();
    if (/^NULL$/i.test(raw)) {
      map.set(columns[i], null);
    } else if (/^'.*'$/.test(raw)) {
      map.set(columns[i], raw.slice(1, -1).replace(/''/g, "'"));
    } else {
      // Could be a number or a parameter placeholder — store as-is
      map.set(columns[i], raw);
    }
  }
  return map;
}

/**
 * Split a comma-separated value list, respecting single-quoted strings.
 * e.g.  "'hello, world', 42, NULL"  ->  ["'hello, world'", "42", "NULL"]
 */
function splitValues(raw: string): string[] {
  const parts: string[] = [];
  let current = "";
  let inQuote = false;

  for (let i = 0; i < raw.length; i++) {
    const ch = raw[i];
    if (ch === "'" && !inQuote) {
      inQuote = true;
      current += ch;
    } else if (ch === "'" && inQuote) {
      // Check for escaped quote ('')
      if (i + 1 < raw.length && raw[i + 1] === "'") {
        current += "''";
        i++;
      } else {
        inQuote = false;
        current += ch;
      }
    } else if (ch === "," && !inQuote) {
      parts.push(current.trim());
      current = "";
    } else {
      current += ch;
    }
  }
  if (current.trim().length > 0) {
    parts.push(current.trim());
  }
  return parts;
}

// ---------------------------------------------------------------------------
// Foreign-key lookup helpers
// ---------------------------------------------------------------------------

/** Return true when a row with the given id exists in `table`. */
function rowExists(db: Database.Database, table: string, id: string): boolean {
  const row = db.prepare(`SELECT 1 FROM "${table}" WHERE id = ?`).get(id);
  return row !== undefined;
}

// ---------------------------------------------------------------------------
// Foreign key validation rules keyed by target table
// ---------------------------------------------------------------------------

interface FKRule {
  column: string;
  refTable: string;
}

const FK_RULES: Record<string, FKRule[]> = {
  models: [
    { column: "brand_id", refTable: "brands" },
    { column: "type_id", refTable: "types" },
  ],
  model_equipment: [
    { column: "model_id", refTable: "models" },
    { column: "equipment_id", refTable: "equipment" },
  ],
  model_protocols: [{ column: "model_id", refTable: "models" }],
  model_numbers: [{ column: "model_id", refTable: "models" }],
  equipment_aliases: [{ column: "equipment_id", refTable: "equipment" }],
  equipment_haystack_tags: [{ column: "equipment_id", refTable: "equipment" }],
  equipment_subtypes: [{ column: "equipment_id", refTable: "equipment" }],
  equipment_typical_points: [{ column: "equipment_id", refTable: "equipment" }],
  point_aliases: [{ column: "point_id", refTable: "points" }],
  point_haystack_tags: [{ column: "point_id", refTable: "points" }],
  point_units: [{ column: "point_id", refTable: "points" }],
  point_states: [{ column: "point_id", refTable: "points" }],
  point_related: [{ column: "point_id", refTable: "points" }],
};

// ---------------------------------------------------------------------------
// Primary key columns for duplicate checking
// ---------------------------------------------------------------------------

const PK_COLUMNS: Record<string, string[]> = {
  points: ["id"],
  equipment: ["id"],
  brands: ["id"],
  types: ["id"],
  models: ["id"],
  categories: ["id"],
  point_units: ["point_id", "unit"],
  point_related: ["point_id", "related_point_id"],
  equipment_typical_points: ["equipment_id", "point_id"],
  model_equipment: ["model_id", "equipment_id"],
  meta: ["key"],
};

// ---------------------------------------------------------------------------
// Fields that should never be empty strings
// ---------------------------------------------------------------------------

const NON_EMPTY_FIELDS = new Set([
  "name",
  "description",
  "full_name",
  "abbreviation",
  "alias",
  "note",
  "subtype_name",
  "unit",
  "tag_name",
  "protocol",
  "model_number",
  "state_key",
  "state_value",
]);

// ---------------------------------------------------------------------------
// Core validation
// ---------------------------------------------------------------------------

export function validateChange(
  change: ProposedChange,
  db: Database.Database,
): ValidationResult {
  const { sql, confidence, source_url } = change;
  const trimmed = sql.trim();

  // 1. SQL syntax — attempt to prepare the statement
  try {
    db.prepare(trimmed);
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : String(err);
    return { valid: false, error: `SQL syntax error: ${message}` };
  }

  // 2. DELETE — always valid but will be routed to review by the changeset sorter
  //    (we still run the remaining checks so we can reject obviously broken deletes)

  // 3. UPDATE must have a source_url when confidence is "high"
  if (isUpdate(trimmed) && confidence === "high" && !source_url) {
    return {
      valid: false,
      error: 'UPDATE with confidence "high" requires a source_url',
    };
  }

  // For INSERTs, run FK, duplicate, and non-empty checks
  if (isInsert(trimmed)) {
    const table = parseTableName(trimmed);
    const values = parseInsertValues(trimmed);

    if (table && values) {
      // 4. Foreign key checks
      const fkRules = FK_RULES[table];
      if (fkRules) {
        for (const rule of fkRules) {
          const fkValue = values.get(rule.column);
          if (fkValue !== null && fkValue !== undefined) {
            if (!rowExists(db, rule.refTable, fkValue)) {
              return {
                valid: false,
                error: `Foreign key violation: ${rule.column}='${fkValue}' not found in ${rule.refTable}`,
              };
            }
          }
        }
      }

      // 5. Duplicate check — only for tables with known PKs
      const pkCols = PK_COLUMNS[table];
      if (pkCols) {
        const pkValues = pkCols.map((col) => values.get(col));
        const allPresent = pkValues.every(
          (v) => v !== null && v !== undefined,
        );

        if (allPresent) {
          const whereClauses = pkCols.map((col) => `"${col}" = ?`).join(" AND ");
          const exists = db
            .prepare(`SELECT 1 FROM "${table}" WHERE ${whereClauses}`)
            .get(...(pkValues as string[]));
          if (exists) {
            return {
              valid: false,
              error: `Duplicate: row already exists in ${table} (${pkCols.map((c, i) => `${c}='${pkValues[i]}'`).join(", ")})`,
            };
          }
        }
      }

      // 6. Non-empty string check
      for (const [col, val] of values) {
        if (NON_EMPTY_FIELDS.has(col) && val !== null && val === "") {
          return {
            valid: false,
            error: `Empty string not allowed for column '${col}' in table '${table}'`,
          };
        }
      }
    }
  }

  return { valid: true };
}

// ---------------------------------------------------------------------------
// Changeset validation
// ---------------------------------------------------------------------------

export function validateChangeset(changes: ProposedChange[]): ValidatedChangeset {
  const result: ValidatedChangeset = {
    apply: [],
    review: [],
    rejected: [],
  };

  const db = new Database(DB_PATH, { readonly: true });
  db.pragma("foreign_keys = ON");

  try {
    for (const change of changes) {
      const validation = validateChange(change, db);

      if (!validation.valid) {
        result.rejected.push({ ...change, error: validation.error! });
        continue;
      }

      // Valid — sort into apply or review
      const needsReview =
        isDelete(change.sql.trim()) || change.confidence === "low";

      if (needsReview) {
        result.review.push(change);
      } else {
        result.apply.push(change);
      }
    }
  } finally {
    db.close();
  }

  return result;
}

// ---------------------------------------------------------------------------
// Apply changes
// ---------------------------------------------------------------------------

export function applyChanges(
  changes: ProposedChange[],
): { applied: number; errors: string[] } {
  const errors: string[] = [];
  let applied = 0;

  const db = new Database(DB_PATH);
  db.pragma("journal_mode = WAL");
  db.pragma("foreign_keys = ON");

  try {
    const txn = db.transaction(() => {
      for (const change of changes) {
        try {
          db.exec(change.sql);
          applied++;
        } catch (err: unknown) {
          const message = err instanceof Error ? err.message : String(err);
          errors.push(`Failed: ${change.sql.slice(0, 120)} — ${message}`);
          throw err; // abort the entire transaction
        }
      }
    });

    txn();
  } catch {
    // Transaction was rolled back — applied count is 0
    applied = 0;
  } finally {
    db.close();
  }

  return { applied, errors };
}

// ---------------------------------------------------------------------------
// Backup & rollback
// ---------------------------------------------------------------------------

export function createBackup(): string {
  if (!fs.existsSync(DB_PATH)) {
    throw new Error(`Database not found at ${DB_PATH}`);
  }

  const timestamp = new Date()
    .toISOString()
    .replace(/[:.]/g, "-")
    .replace("T", "_")
    .replace("Z", "");
  const backupPath = `${DB_PATH}.bak.${timestamp}`;

  fs.copyFileSync(DB_PATH, backupPath);
  return backupPath;
}

export function rollback(backupPath: string): void {
  if (!fs.existsSync(backupPath)) {
    throw new Error(`Backup file not found: ${backupPath}`);
  }

  fs.copyFileSync(backupPath, DB_PATH);
}
