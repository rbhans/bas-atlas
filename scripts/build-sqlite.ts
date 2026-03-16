import * as fs from "fs";
import * as path from "path";
import Database from "better-sqlite3";
import { parse as parseYaml } from "yaml";
import type {
  PointYamlFile,
  EquipmentYamlFile,
  PointEntry,
  EquipmentEntry,
  EquipmentEntryYaml,
  PointConceptYaml,
  PointHaystackData,
  EquipmentHaystackData,
  HaystackTag,
  HaystackTagKind,
  TagDictEntry,
  UnitMapEntry,
} from "./types.js";

const DATA_DIR = path.join(process.cwd(), "data");
const DIST_DIR = path.join(process.cwd(), "dist");
const DB_PATH = path.join(DIST_DIR, "bas-atlas.db");

// --- Reuse build helpers (same logic as build.ts) ---

interface TagDict {
  [tagName: string]: TagDictEntry;
}
interface UnitMap {
  [symbol: string]: UnitMapEntry;
}

function loadTagDict(): TagDict {
  const raw = parseYaml(
    fs.readFileSync(path.join(DATA_DIR, "haystack-tags.yaml"), "utf-8"),
  ) as { tags: Record<string, TagDictEntry> };
  return raw.tags;
}

function loadUnitMap(): UnitMap {
  const raw = parseYaml(
    fs.readFileSync(path.join(DATA_DIR, "haystack-units.yaml"), "utf-8"),
  ) as { units: Record<string, UnitMapEntry> };
  return raw.units;
}

function parseHaystackString(
  raw: string,
  entityType: "point" | "equip",
  tagDict: TagDict,
  unitMap: UnitMap,
  units?: string[],
  kind?: "Number" | "Bool",
): PointHaystackData | EquipmentHaystackData {
  const normalized = raw.trim().replace(/-/g, " ");
  const tokens = normalized.split(/\s+/).filter(Boolean);

  const tags: HaystackTag[] = tokens.map((token) => ({
    name: token,
    kind: (tagDict[token]?.kind ?? "Marker") as HaystackTagKind,
  }));

  const tagNames = new Set(tags.map((t) => t.name));
  if (entityType === "point" && !tagNames.has("point")) {
    tags.push({ name: "point", kind: "Marker" });
  }
  if (entityType === "equip" && !tagNames.has("equip")) {
    tags.push({ name: "equip", kind: "Marker" });
  }

  const markers = tags.filter((t) => t.kind === "Marker").map((t) => t.name);
  const tagString = tags.map((t) => t.name).join(" ");

  if (entityType === "point") {
    const result: PointHaystackData = { tags, tagString, markers };
    if (units && units.length > 0) {
      for (const u of units) {
        const mapped = unitMap[u];
        if (mapped) {
          result.unit = mapped.haystack;
          break;
        }
      }
    }
    if (kind) result.kind = kind;
    return result;
  }

  return { tags, tagString, markers } as EquipmentHaystackData;
}

function inferPointKind(point: PointConceptYaml): "Number" | "Bool" {
  if (Array.isArray(point.unit) && point.unit.length > 0) return "Number";
  if (
    point.states &&
    typeof point.states === "object" &&
    "0" in point.states &&
    "1" in point.states
  )
    return "Bool";
  const fn = point.point_function;
  if (fn === "alarm" || fn === "status" || fn === "enable" || fn === "schedule")
    return "Bool";
  return "Bool";
}

function readYamlFiles<T>(dir: string): T[] {
  const results: T[] = [];
  if (!fs.existsSync(dir)) return results;
  const items = fs.readdirSync(dir, { withFileTypes: true });
  for (const item of items) {
    const fullPath = path.join(dir, item.name);
    if (item.isDirectory()) {
      results.push(...readYamlFiles<T>(fullPath));
    } else if (item.name.endsWith(".yaml") || item.name.endsWith(".yml")) {
      try {
        const content = fs.readFileSync(fullPath, "utf-8");
        const parsed = parseYaml(content) as T;
        if (parsed) results.push(parsed);
      } catch (error) {
        console.error(`Error parsing ${fullPath}:`, error);
      }
    }
  }
  return results;
}

function readJsonFiles(dir: string): Array<{ file: string; data: unknown }> {
  const results: Array<{ file: string; data: unknown }> = [];
  if (!fs.existsSync(dir)) return results;
  const items = fs.readdirSync(dir, { withFileTypes: true });
  for (const item of items) {
    const fullPath = path.join(dir, item.name);
    if (item.isDirectory()) {
      results.push(...readJsonFiles(fullPath));
    } else if (item.name.endsWith(".json")) {
      const content = fs.readFileSync(fullPath, "utf-8");
      results.push({ file: fullPath, data: JSON.parse(content) as unknown });
    }
  }
  return results;
}

// --- Search token extraction ---

function extractPointTokens(point: PointEntry): string[] {
  const tokens: string[] = [];
  tokens.push(point.concept.name.toLowerCase());
  tokens.push(point.concept.id.toLowerCase());
  if (point.concept.description)
    tokens.push(...point.concept.description.toLowerCase().split(/\s+/));
  if (point.concept.haystack)
    tokens.push(...point.concept.haystack.markers.map((m) => m.toLowerCase()));
  if (point.aliases) {
    tokens.push(...(point.aliases.common || []).map((a) => a.toLowerCase()));
    tokens.push(
      ...(point.aliases.misspellings || []).map((a) => a.toLowerCase()),
    );
  }
  return [...new Set(tokens.filter((t) => t.length > 0))];
}

function extractEquipTokens(equip: EquipmentEntry): string[] {
  const tokens: string[] = [];
  tokens.push(equip.name.toLowerCase());
  tokens.push(equip.id.toLowerCase());
  if (equip.full_name) tokens.push(equip.full_name.toLowerCase());
  if (equip.abbreviation) tokens.push(equip.abbreviation.toLowerCase());
  if (equip.description)
    tokens.push(...equip.description.toLowerCase().split(/\s+/));
  if (equip.haystack)
    tokens.push(...equip.haystack.markers.map((m) => m.toLowerCase()));
  if (equip.aliases) {
    tokens.push(...(equip.aliases.common || []).map((a) => a.toLowerCase()));
    tokens.push(
      ...(equip.aliases.misspellings || []).map((a) => a.toLowerCase()),
    );
  }
  return [...new Set(tokens.filter((t) => t.length > 0))];
}

// --- Schema ---

const SCHEMA = `
-- Core point concepts
CREATE TABLE points (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  subcategory TEXT,
  description TEXT,
  brick TEXT,
  kind TEXT,
  point_function TEXT,
  haystack_tag_string TEXT,
  haystack_unit TEXT,
  haystack_kind TEXT
);

-- Point units (multi-value)
CREATE TABLE point_units (
  point_id TEXT NOT NULL REFERENCES points(id),
  unit TEXT NOT NULL,
  PRIMARY KEY (point_id, unit)
);

-- Point aliases
CREATE TABLE point_aliases (
  point_id TEXT NOT NULL REFERENCES points(id),
  alias TEXT NOT NULL,
  alias_group TEXT NOT NULL DEFAULT 'common'
);

-- Haystack tags per point
CREATE TABLE point_haystack_tags (
  point_id TEXT NOT NULL REFERENCES points(id),
  tag_name TEXT NOT NULL,
  tag_kind TEXT NOT NULL
);

-- Point notes
CREATE TABLE point_notes (
  point_id TEXT NOT NULL REFERENCES points(id),
  note TEXT NOT NULL
);

-- Point states (for Bool/enum points)
CREATE TABLE point_states (
  point_id TEXT NOT NULL REFERENCES points(id),
  state_key TEXT NOT NULL,
  state_value TEXT NOT NULL
);

-- Related points
CREATE TABLE point_related (
  point_id TEXT NOT NULL REFERENCES points(id),
  related_point_id TEXT NOT NULL,
  PRIMARY KEY (point_id, related_point_id)
);

-- Equipment
CREATE TABLE equipment (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  full_name TEXT,
  abbreviation TEXT,
  category TEXT NOT NULL,
  description TEXT,
  brick TEXT,
  haystack_tag_string TEXT,
  parent_id TEXT REFERENCES equipment(id)
);

-- Equipment aliases
CREATE TABLE equipment_aliases (
  equipment_id TEXT NOT NULL REFERENCES equipment(id),
  alias TEXT NOT NULL,
  alias_group TEXT NOT NULL DEFAULT 'common'
);

-- Equipment haystack tags
CREATE TABLE equipment_haystack_tags (
  equipment_id TEXT NOT NULL REFERENCES equipment(id),
  tag_name TEXT NOT NULL,
  tag_kind TEXT NOT NULL
);

-- Equipment subtypes
CREATE TABLE equipment_subtypes (
  equipment_id TEXT NOT NULL REFERENCES equipment(id),
  subtype_id TEXT NOT NULL,
  subtype_name TEXT NOT NULL,
  description TEXT
);

-- Equipment subtype aliases
CREATE TABLE equipment_subtype_aliases (
  equipment_id TEXT NOT NULL REFERENCES equipment(id),
  subtype_id TEXT NOT NULL,
  alias TEXT NOT NULL
);

-- Equipment ↔ Points (the key relationship table)
CREATE TABLE equipment_typical_points (
  equipment_id TEXT NOT NULL REFERENCES equipment(id),
  point_id TEXT NOT NULL REFERENCES points(id),
  PRIMARY KEY (equipment_id, point_id)
);

-- Categories
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  count INTEGER DEFAULT 0
);

-- Catalog: Brands
CREATE TABLE brands (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT,
  logo_url TEXT,
  website TEXT,
  description TEXT
);

-- Catalog: Types
CREATE TABLE types (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT,
  description TEXT
);

-- Catalog: Models (FK → brands, types)
CREATE TABLE models (
  id TEXT PRIMARY KEY,
  brand_id TEXT NOT NULL REFERENCES brands(id),
  type_id TEXT NOT NULL REFERENCES types(id),
  name TEXT NOT NULL,
  slug TEXT,
  description TEXT,
  status TEXT,
  manufacturer_url TEXT,
  image_url TEXT,
  added_at TEXT
);

CREATE TABLE model_numbers (
  model_id TEXT NOT NULL REFERENCES models(id),
  model_number TEXT NOT NULL
);

CREATE TABLE model_protocols (
  model_id TEXT NOT NULL REFERENCES models(id),
  protocol TEXT NOT NULL
);

-- Model ↔ Equipment (which equipment a model is used with)
CREATE TABLE model_equipment (
  model_id TEXT NOT NULL REFERENCES models(id),
  equipment_id TEXT NOT NULL REFERENCES equipment(id),
  PRIMARY KEY (model_id, equipment_id)
);

-- FTS5 search index
CREATE VIRTUAL TABLE search_index USING fts5(
  entry_id,
  entry_type,
  name,
  tokens
);

-- Metadata
CREATE TABLE meta (
  key TEXT PRIMARY KEY,
  value TEXT
);

-- Indexes for common queries
CREATE INDEX idx_points_category ON points(category);
CREATE INDEX idx_points_kind ON points(kind);
CREATE INDEX idx_points_function ON points(point_function);
CREATE INDEX idx_equipment_category ON equipment(category);
CREATE INDEX idx_equipment_parent ON equipment(parent_id);
CREATE INDEX idx_equipment_typical_points_point ON equipment_typical_points(point_id);
CREATE INDEX idx_equipment_typical_points_equip ON equipment_typical_points(equipment_id);
CREATE INDEX idx_models_brand ON models(brand_id);
CREATE INDEX idx_models_type ON models(type_id);
CREATE INDEX idx_model_equipment_model ON model_equipment(model_id);
CREATE INDEX idx_model_equipment_equip ON model_equipment(equipment_id);
CREATE INDEX idx_point_aliases_alias ON point_aliases(alias);
CREATE INDEX idx_equipment_aliases_alias ON equipment_aliases(alias);
`;

// --- Main build ---

function build() {
  console.log("Building BAS Atlas SQLite database...\n");

  // Load dictionaries
  const tagDict = loadTagDict();
  const unitMap = loadUnitMap();
  console.log(
    `Loaded ${Object.keys(tagDict).length} tags, ${Object.keys(unitMap).length} units`,
  );

  // Load points
  const pointFiles = readYamlFiles<PointYamlFile>(
    path.join(DATA_DIR, "points"),
  );
  const points: PointEntry[] = pointFiles.map((f) => {
    const kind = inferPointKind(f.concept);
    return {
      concept: {
        id: f.concept.id,
        name: f.concept.name,
        category: f.concept.category,
        ...(f.concept.subcategory && { subcategory: f.concept.subcategory }),
        description: f.concept.description,
        haystack: f.concept.haystack
          ? (parseHaystackString(
              f.concept.haystack,
              "point",
              tagDict,
              unitMap,
              f.concept.unit,
              kind,
            ) as PointHaystackData)
          : undefined,
        ...(f.concept.brick && { brick: f.concept.brick }),
        kind,
        ...(f.concept.unit && { unit: f.concept.unit }),
        ...(f.concept.point_function && {
          point_function: f.concept.point_function,
        }),
        ...(f.concept.states && { states: f.concept.states }),
      },
      aliases: f.aliases,
      notes: f.notes,
      related: f.related,
    };
  });
  console.log(`Loaded ${points.length} points`);

  // Load equipment
  const equipFiles = readYamlFiles<EquipmentYamlFile>(
    path.join(DATA_DIR, "equipment"),
  );
  const equipment: EquipmentEntry[] = [];
  for (const file of equipFiles) {
    const entries: EquipmentEntryYaml[] = Array.isArray(file.equipment)
      ? file.equipment
      : file.equipment
        ? [file.equipment]
        : [];
    for (const entry of entries) {
      equipment.push({
        ...entry,
        haystack: entry.haystack
          ? (parseHaystackString(
              entry.haystack,
              "equip",
              tagDict,
              unitMap,
            ) as EquipmentHaystackData)
          : undefined,
      });
    }
  }
  console.log(`Loaded ${equipment.length} equipment entries`);

  // Load catalog data
  const catalogDir = path.join(DATA_DIR, "catalog");
  const catalogFiles = readJsonFiles(catalogDir);

  interface BrandData {
    id: string;
    name: string;
    slug?: string;
    logo_url?: string;
    website?: string;
    description?: string;
  }
  interface TypeData {
    id: string;
    name: string;
    slug?: string;
    description?: string;
  }
  interface ModelData {
    id: string;
    brand: string;
    type: string;
    name: string;
    slug?: string;
    model_numbers?: string[];
    protocols?: string[];
    status?: string;
    description?: string;
    manufacturer_url?: string;
    image_url?: string;
    added_at?: string;
  }

  const brands: BrandData[] = [];
  const types: TypeData[] = [];
  const models: ModelData[] = [];

  for (const { data } of catalogFiles) {
    const record = data as {
      brand?: BrandData;
      type?: TypeData;
      model?: ModelData;
    };
    if (record.brand) brands.push(record.brand);
    else if (record.type) types.push(record.type);
    else if (record.model) models.push(record.model);
  }
  console.log(
    `Loaded ${brands.length} brands, ${types.length} types, ${models.length} models`,
  );

  // Build point ID set for FK validation
  const pointIds = new Set(points.map((p) => p.concept.id));

  // Create database
  if (!fs.existsSync(DIST_DIR)) {
    fs.mkdirSync(DIST_DIR, { recursive: true });
  }
  if (fs.existsSync(DB_PATH)) {
    fs.unlinkSync(DB_PATH);
  }

  const db = new Database(DB_PATH);
  db.pragma("journal_mode = WAL");
  db.pragma("foreign_keys = ON");

  // Create schema
  db.exec(SCHEMA);
  console.log("\nSchema created");

  // --- Populate data inside a transaction ---
  const populate = db.transaction(() => {
    // Points
    const insertPoint = db.prepare(`
      INSERT INTO points (id, name, category, subcategory, description, brick, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);
    const insertPointUnit = db.prepare(
      `INSERT INTO point_units (point_id, unit) VALUES (?, ?)`,
    );
    const insertPointAlias = db.prepare(
      `INSERT INTO point_aliases (point_id, alias, alias_group) VALUES (?, ?, ?)`,
    );
    const insertPointTag = db.prepare(
      `INSERT INTO point_haystack_tags (point_id, tag_name, tag_kind) VALUES (?, ?, ?)`,
    );
    const insertPointNote = db.prepare(
      `INSERT INTO point_notes (point_id, note) VALUES (?, ?)`,
    );
    const insertPointState = db.prepare(
      `INSERT INTO point_states (point_id, state_key, state_value) VALUES (?, ?, ?)`,
    );
    const insertPointRelated = db.prepare(
      `INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES (?, ?)`,
    );

    for (const point of points) {
      const c = point.concept;
      const hs = c.haystack;

      insertPoint.run(
        c.id,
        c.name,
        c.category,
        c.subcategory ?? null,
        c.description ?? null,
        c.brick ?? null,
        c.kind ?? null,
        c.point_function ?? null,
        hs?.tagString ?? null,
        hs?.unit ?? null,
        hs?.kind ?? null,
      );

      if (c.unit) {
        for (const u of c.unit) {
          insertPointUnit.run(c.id, u);
        }
      }

      if (point.aliases?.common) {
        for (const alias of point.aliases.common) {
          insertPointAlias.run(c.id, alias, "common");
        }
      }
      if (point.aliases?.misspellings) {
        for (const alias of point.aliases.misspellings) {
          insertPointAlias.run(c.id, alias, "misspellings");
        }
      }

      if (hs?.tags) {
        for (const tag of hs.tags) {
          insertPointTag.run(c.id, tag.name, tag.kind);
        }
      }

      if (point.notes) {
        for (const note of point.notes) {
          insertPointNote.run(c.id, note);
        }
      }

      if (c.states) {
        for (const [key, value] of Object.entries(c.states)) {
          insertPointState.run(c.id, key, String(value));
        }
      }

      if (point.related) {
        for (const relId of point.related) {
          insertPointRelated.run(c.id, relId);
        }
      }
    }

    // Equipment
    const insertEquip = db.prepare(`
      INSERT INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);
    const insertEquipAlias = db.prepare(
      `INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES (?, ?, ?)`,
    );
    const insertEquipTag = db.prepare(
      `INSERT INTO equipment_haystack_tags (equipment_id, tag_name, tag_kind) VALUES (?, ?, ?)`,
    );
    const insertSubtype = db.prepare(
      `INSERT INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES (?, ?, ?, ?)`,
    );
    const insertSubtypeAlias = db.prepare(
      `INSERT INTO equipment_subtype_aliases (equipment_id, subtype_id, alias) VALUES (?, ?, ?)`,
    );
    const insertTypicalPoint = db.prepare(
      `INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES (?, ?)`,
    );

    let typicalPointWarnings = 0;

    for (const equip of equipment) {
      const hs = equip.haystack;

      insertEquip.run(
        equip.id,
        equip.name,
        equip.full_name ?? null,
        equip.abbreviation ?? null,
        equip.category,
        equip.description ?? null,
        equip.brick ?? null,
        hs?.tagString ?? null,
        null, // parent_id (top-level)
      );

      if (equip.aliases?.common) {
        for (const alias of equip.aliases.common) {
          insertEquipAlias.run(equip.id, alias, "common");
        }
      }
      if (equip.aliases?.misspellings) {
        for (const alias of equip.aliases.misspellings) {
          insertEquipAlias.run(equip.id, alias, "misspellings");
        }
      }

      if (hs?.tags) {
        for (const tag of hs.tags) {
          insertEquipTag.run(equip.id, tag.name, tag.kind);
        }
      }

      if (equip.subtypes) {
        for (const sub of equip.subtypes) {
          if (typeof sub === "string") {
            // Plain string subtypes (e.g. "electric-water-heater")
            insertSubtype.run(equip.id, sub, sub, null);
          } else {
            insertSubtype.run(
              equip.id,
              sub.id,
              sub.name,
              sub.description ?? null,
            );
            if (sub.aliases) {
              for (const alias of sub.aliases) {
                insertSubtypeAlias.run(equip.id, sub.id, alias);
              }
            }
          }
        }
      }

      if (equip.typical_points) {
        for (const pointId of equip.typical_points) {
          if (pointIds.has(pointId)) {
            insertTypicalPoint.run(equip.id, pointId);
          } else {
            typicalPointWarnings++;
          }
        }
      }
    }

    if (typicalPointWarnings > 0) {
      console.warn(
        `  WARN: ${typicalPointWarnings} typical_point references skipped (point not found)`,
      );
    }

    // Categories
    const insertCategory = db.prepare(
      `INSERT INTO categories (id, name, type, count) VALUES (?, ?, ?, ?)`,
    );

    const pointCats = new Map<string, number>();
    for (const p of points) {
      pointCats.set(
        p.concept.category,
        (pointCats.get(p.concept.category) || 0) + 1,
      );
    }
    for (const [catId, count] of pointCats) {
      insertCategory.run(catId, catId, "point", count);
    }

    const equipCats = new Map<string, number>();
    for (const e of equipment) {
      equipCats.set(e.category, (equipCats.get(e.category) || 0) + 1);
    }
    for (const [catId, count] of equipCats) {
      insertCategory.run(catId, catId, "equipment", count);
    }

    // Brands
    const insertBrand = db.prepare(`
      INSERT INTO brands (id, name, slug, logo_url, website, description)
      VALUES (?, ?, ?, ?, ?, ?)
    `);
    for (const b of brands) {
      insertBrand.run(
        b.id,
        b.name,
        b.slug ?? null,
        b.logo_url ?? null,
        b.website ?? null,
        b.description ?? null,
      );
    }

    // Types
    const insertType = db.prepare(`
      INSERT INTO types (id, name, slug, description)
      VALUES (?, ?, ?, ?)
    `);
    for (const t of types) {
      insertType.run(t.id, t.name, t.slug ?? null, t.description ?? null);
    }

    // Models
    const insertModel = db.prepare(`
      INSERT INTO models (id, brand_id, type_id, name, slug, description, status, manufacturer_url, image_url, added_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);
    const insertModelNumber = db.prepare(
      `INSERT INTO model_numbers (model_id, model_number) VALUES (?, ?)`,
    );
    const insertModelProtocol = db.prepare(
      `INSERT INTO model_protocols (model_id, protocol) VALUES (?, ?)`,
    );

    for (const m of models) {
      insertModel.run(
        m.id,
        m.brand,
        m.type,
        m.name,
        m.slug ?? null,
        m.description ?? null,
        m.status ?? null,
        m.manufacturer_url ?? null,
        m.image_url ?? null,
        m.added_at ?? null,
      );
      if (m.model_numbers) {
        for (const mn of m.model_numbers) {
          insertModelNumber.run(m.id, mn);
        }
      }
      if (m.protocols) {
        for (const p of m.protocols) {
          insertModelProtocol.run(m.id, p);
        }
      }
    }

    // Model ↔ Equipment mapping (based on catalog type → equipment)
    const typeToEquipment: Record<string, string[]> = {
      "vav-controllers": [
        "variable-air-volume-box",
        "constant-air-volume-box",
        "parallel-fan-powered-box",
        "series-fan-powered-box",
      ],
      "unitary-controllers": [
        "air-handling-unit",
        "rooftop-unit",
        "makeup-air-unit",
        "dedicated-outdoor-air-system",
        "fan-coil-unit",
        "unit-ventilator",
        "computer-room-air-conditioner",
        "computer-room-air-handler",
      ],
      "zone-controllers": [
        "variable-air-volume-box",
        "fan-coil-unit",
        "chilled-beam",
        "radiant-panel",
        "baseboard-heater",
      ],
      "thermostats": [
        "fan-coil-unit",
        "unit-ventilator",
        "rooftop-unit",
        "packaged-terminal-air-conditioner",
        "packaged-terminal-heat-pump",
        "water-source-heat-pump",
        "ductless-mini-split",
      ],
      "temperature-sensors": [
        "air-handling-unit",
        "rooftop-unit",
        "chiller",
        "boiler",
        "cooling-tower",
        "fan-coil-unit",
        "unit-ventilator",
        "variable-air-volume-box",
      ],
      "valve-actuators": [
        "air-handling-unit",
        "fan-coil-unit",
        "chiller",
        "boiler",
        "unit-ventilator",
        "chilled-beam",
        "heat-exchanger",
      ],
      "damper-actuators": [
        "air-handling-unit",
        "rooftop-unit",
        "variable-air-volume-box",
        "dedicated-outdoor-air-system",
        "makeup-air-unit",
        "energy-recovery-ventilator",
        "parallel-fan-powered-box",
        "series-fan-powered-box",
        "constant-air-volume-box",
      ],
      "pressure-sensors": [
        "air-handling-unit",
        "rooftop-unit",
        "variable-air-volume-box",
        "chiller",
        "boiler",
      ],
      "humidity-sensors": [
        "air-handling-unit",
        "rooftop-unit",
        "dedicated-outdoor-air-system",
        "energy-recovery-ventilator",
      ],
      "co2-sensors": [
        "air-handling-unit",
        "variable-air-volume-box",
        "rooftop-unit",
        "dedicated-outdoor-air-system",
      ],
      "air-quality-sensors": [
        "air-handling-unit",
        "rooftop-unit",
        "dedicated-outdoor-air-system",
      ],
      "meters": [
        "electric-meter",
        "btu-meter",
        "natural-gas-meter",
        "water-meter",
        "steam-meter",
      ],
      "vfds-drives": [
        "variable-frequency-drive",
        "pump",
        "exhaust-fan",
        "cooling-tower",
      ],
      "occupancy-sensors": [
        "variable-air-volume-box",
        "rooftop-unit",
        "fan-coil-unit",
      ],
    };

    const equipIds = new Set(equipment.map((e) => e.id));
    const insertModelEquip = db.prepare(
      `INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES (?, ?)`,
    );
    let modelEquipCount = 0;

    for (const m of models) {
      const equipList = typeToEquipment[m.type] || [];
      for (const eqId of equipList) {
        if (equipIds.has(eqId)) {
          insertModelEquip.run(m.id, eqId);
          modelEquipCount++;
        }
      }
    }
    console.log(
      `  Linked ${modelEquipCount} model↔equipment relationships`,
    );

    // FTS search index
    const insertSearch = db.prepare(`
      INSERT INTO search_index (entry_id, entry_type, name, tokens)
      VALUES (?, ?, ?, ?)
    `);

    for (const point of points) {
      const tokens = extractPointTokens(point);
      insertSearch.run(
        point.concept.id,
        "point",
        point.concept.name,
        tokens.join(" "),
      );
    }

    for (const equip of equipment) {
      const tokens = extractEquipTokens(equip);
      insertSearch.run(equip.id, "equipment", equip.name, tokens.join(" "));
    }

    for (const b of brands) {
      insertSearch.run(b.id, "brand", b.name, b.name.toLowerCase());
    }

    for (const t of types) {
      insertSearch.run(t.id, "type", t.name, t.name.toLowerCase());
    }

    for (const m of models) {
      const tokens = [
        m.name.toLowerCase(),
        m.id,
        ...(m.model_numbers || []).map((n) => n.toLowerCase()),
        ...(m.protocols || []).map((p) => p.toLowerCase()),
      ];
      insertSearch.run(m.id, "model", m.name, tokens.join(" "));
    }

    // Metadata
    const insertMeta = db.prepare(
      `INSERT INTO meta (key, value) VALUES (?, ?)`,
    );
    insertMeta.run("version", "2.0.0");
    insertMeta.run("lastUpdated", new Date().toISOString());
    insertMeta.run("totalPoints", String(points.length));
    insertMeta.run("totalEquipment", String(equipment.length));
    insertMeta.run("totalBrands", String(brands.length));
    insertMeta.run("totalTypes", String(types.length));
    insertMeta.run("totalModels", String(models.length));
  });

  populate();
  console.log("Data populated");

  // Vacuum for minimal file size
  db.exec("VACUUM");
  db.close();

  const stats = fs.statSync(DB_PATH);
  const sizeKB = (stats.size / 1024).toFixed(1);
  console.log(`\nGenerated dist/bas-atlas.db (${sizeKB} KB)`);
  console.log("SQLite build complete!");
}

try {
  build();
} catch (error) {
  console.error(error);
  process.exit(1);
}
