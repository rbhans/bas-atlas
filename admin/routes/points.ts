import { Router } from "express";
import { all, get, run, transaction } from "../db.js";
import { flashRedirect } from "../helpers/flash.js";
import {
  updateSearchEntry,
  deleteSearchEntry,
  extractPointTokensFromDb,
} from "../helpers/search-index.js";

export const pointsRoutes = Router();

const POINT_FUNCTIONS = [
  "sensor",
  "setpoint",
  "command",
  "status",
  "alarm",
  "enable",
  "mode",
  "schedule",
  "calculated",
];

function getPointCategories(): string[] {
  return all<{ category: string }>(
    `SELECT DISTINCT category FROM points ORDER BY category`,
  ).map((r) => r.category);
}

// List
pointsRoutes.get("/", (req, res) => {
  const { category, kind, point_function, q } = req.query as Record<
    string,
    string
  >;

  let sql = `SELECT p.*,
    (SELECT COUNT(*) FROM point_aliases WHERE point_id = p.id) as alias_count,
    (SELECT COUNT(*) FROM equipment_typical_points WHERE point_id = p.id) as equip_count
    FROM points p WHERE 1=1`;
  const params: unknown[] = [];

  if (category) {
    sql += ` AND p.category = ?`;
    params.push(category);
  }
  if (kind) {
    sql += ` AND p.kind = ?`;
    params.push(kind);
  }
  if (point_function) {
    sql += ` AND p.point_function = ?`;
    params.push(point_function);
  }
  if (q) {
    sql += ` AND (p.name LIKE '%' || ? || '%' OR p.id LIKE '%' || ? || '%')`;
    params.push(q, q);
  }
  sql += ` ORDER BY p.category, p.name`;

  const points = all<Record<string, unknown>>(sql, ...params);
  const categories = getPointCategories();

  if (res.locals.isHtmx) {
    return res.render("points/_rows", { points });
  }

  res.render("points/list", {
    pageTitle: "Points",
    points,
    categories,
    functions: POINT_FUNCTIONS,
    filters: { category, kind, point_function, q },
  });
});

// New form
pointsRoutes.get("/new", (_req, res) => {
  res.render("points/new", {
    pageTitle: "New Point",
    categories: getPointCategories(),
    functions: POINT_FUNCTIONS,
    values: {},
    errors: [],
  });
});

// Create
pointsRoutes.post("/", (req, res) => {
  const { id, name, category, subcategory, description, brick, point_function, kind, haystack } =
    req.body;
  const errors: string[] = [];

  if (!id || !id.match(/^[a-z0-9-]+$/))
    errors.push("ID must be lowercase alphanumeric with dashes");
  if (!name) errors.push("Name is required");
  if (!category) errors.push("Category is required");
  if (!description) errors.push("Description is required");

  const existing = get<{ id: string }>(`SELECT id FROM points WHERE id = ?`, id);
  if (existing) errors.push("A point with this ID already exists");

  if (errors.length > 0) {
    return res.render("points/new", {
      pageTitle: "New Point",
      categories: getPointCategories(),
      functions: POINT_FUNCTIONS,
      values: req.body,
      errors,
    });
  }

  const tagString = haystack
    ? (haystack.trim().includes("point") ? haystack.trim() : haystack.trim() + " point")
    : null;

  run(
    `INSERT INTO points (id, name, category, subcategory, description, brick, kind, point_function, haystack_tag_string)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    id,
    name,
    category,
    subcategory || null,
    description,
    brick || null,
    kind || "Bool",
    point_function || null,
    tagString,
  );

  const point = get<Record<string, unknown>>(`SELECT * FROM points WHERE id = ?`, id)!;
  const tokens = extractPointTokensFromDb(point as any);
  updateSearchEntry(id, "point", name, tokens);

  res.redirect(flashRedirect(`/points/${id}`, "success", "Point created"));
});

// Detail
pointsRoutes.get("/:id", (req, res) => {
  const point = get<Record<string, unknown>>(
    `SELECT * FROM points WHERE id = ?`,
    req.params.id,
  );
  if (!point) return res.status(404).send("Point not found");

  const aliases = all<{ alias: string; alias_group: string }>(
    `SELECT alias, alias_group FROM point_aliases WHERE point_id = ? ORDER BY alias_group, alias`,
    req.params.id,
  );
  const units = all<{ unit: string }>(
    `SELECT unit FROM point_units WHERE point_id = ?`,
    req.params.id,
  );
  const notes = all<{ note: string }>(
    `SELECT note FROM point_notes WHERE point_id = ?`,
    req.params.id,
  );
  const states = all<{ state_key: string; state_value: string }>(
    `SELECT state_key, state_value FROM point_states WHERE point_id = ? ORDER BY state_key`,
    req.params.id,
  );
  const related = all<{ related_point_id: string }>(
    `SELECT related_point_id FROM point_related WHERE point_id = ? ORDER BY related_point_id`,
    req.params.id,
  );
  const relatedNames = related.map((r) => {
    const p = get<{ name: string }>(`SELECT name FROM points WHERE id = ?`, r.related_point_id);
    return { id: r.related_point_id, name: p?.name || r.related_point_id };
  });
  const usedByEquip = all<{ id: string; name: string }>(
    `SELECT e.id, e.name FROM equipment e JOIN equipment_typical_points etp ON e.id = etp.equipment_id WHERE etp.point_id = ?`,
    req.params.id,
  );
  const tags = all<{ tag_name: string; tag_kind: string }>(
    `SELECT tag_name, tag_kind FROM point_haystack_tags WHERE point_id = ?`,
    req.params.id,
  );

  res.render("points/detail", {
    pageTitle: point.name as string,
    point,
    aliases,
    units,
    notes,
    states,
    related: relatedNames,
    usedByEquip,
    tags,
    categories: getPointCategories(),
    functions: POINT_FUNCTIONS,
  });
});

// Update
pointsRoutes.put("/:id", (req, res) => {
  const { name, category, subcategory, description, brick, point_function, kind, haystack } =
    req.body;

  const tagString = haystack
    ? (haystack.trim().includes("point") ? haystack.trim() : haystack.trim() + " point")
    : null;

  run(
    `UPDATE points SET name=?, category=?, subcategory=?, description=?, brick=?, kind=?, point_function=?, haystack_tag_string=? WHERE id=?`,
    name,
    category,
    subcategory || null,
    description,
    brick || null,
    kind || "Bool",
    point_function || null,
    tagString,
    req.params.id,
  );

  // Rebuild haystack tags
  run(`DELETE FROM point_haystack_tags WHERE point_id = ?`, req.params.id);
  if (tagString) {
    for (const tag of tagString.split(/\s+/)) {
      if (tag) run(`INSERT INTO point_haystack_tags (point_id, tag_name, tag_kind) VALUES (?, ?, 'Marker')`, req.params.id, tag);
    }
  }

  const point = get<Record<string, unknown>>(`SELECT * FROM points WHERE id = ?`, req.params.id)!;
  const tokens = extractPointTokensFromDb(point as any);
  updateSearchEntry(req.params.id, "point", name, tokens);

  res.redirect(
    flashRedirect(`/points/${req.params.id}`, "success", "Point updated"),
  );
});

// Delete
pointsRoutes.delete("/:id", (req, res) => {
  transaction(() => {
    run(`DELETE FROM point_aliases WHERE point_id = ?`, req.params.id);
    run(`DELETE FROM point_units WHERE point_id = ?`, req.params.id);
    run(`DELETE FROM point_haystack_tags WHERE point_id = ?`, req.params.id);
    run(`DELETE FROM point_notes WHERE point_id = ?`, req.params.id);
    run(`DELETE FROM point_states WHERE point_id = ?`, req.params.id);
    run(
      `DELETE FROM point_related WHERE point_id = ? OR related_point_id = ?`,
      req.params.id,
      req.params.id,
    );
    run(
      `DELETE FROM equipment_typical_points WHERE point_id = ?`,
      req.params.id,
    );
    deleteSearchEntry(req.params.id, "point");
    run(`DELETE FROM points WHERE id = ?`, req.params.id);
  });

  if (res.locals.isHtmx) {
    res.set("HX-Redirect", "/points?flash_type=success&flash_msg=Point+deleted");
    return res.send("");
  }
  res.redirect(flashRedirect("/points", "success", "Point deleted"));
});

// --- Child data routes ---

// Aliases
pointsRoutes.post("/:id/aliases", (req, res) => {
  const { alias, group } = req.body;
  if (alias) {
    run(
      `INSERT INTO point_aliases (point_id, alias, alias_group) VALUES (?, ?, ?)`,
      req.params.id,
      alias.trim(),
      group || "common",
    );
  }
  renderAliasesFragment(req, res);
});

pointsRoutes.delete("/:id/aliases", (req, res) => {
  const { alias, group } = req.body;
  run(
    `DELETE FROM point_aliases WHERE point_id = ? AND alias = ? AND alias_group = ?`,
    req.params.id,
    alias,
    group,
  );
  renderAliasesFragment(req, res);
});

function renderAliasesFragment(req: any, res: any) {
  const aliases = all<{ alias: string; alias_group: string }>(
    `SELECT alias, alias_group FROM point_aliases WHERE point_id = ? ORDER BY alias_group, alias`,
    req.params.id,
  );
  res.render("points/_aliases", { point: { id: req.params.id }, aliases });
}

// Units
pointsRoutes.post("/:id/units", (req, res) => {
  const { unit } = req.body;
  if (unit) {
    run(
      `INSERT OR IGNORE INTO point_units (point_id, unit) VALUES (?, ?)`,
      req.params.id,
      unit.trim(),
    );
  }
  renderUnitsFragment(req, res);
});

pointsRoutes.delete("/:id/units", (req, res) => {
  const { unit } = req.body;
  run(
    `DELETE FROM point_units WHERE point_id = ? AND unit = ?`,
    req.params.id,
    unit,
  );
  renderUnitsFragment(req, res);
});

function renderUnitsFragment(req: any, res: any) {
  const units = all<{ unit: string }>(
    `SELECT unit FROM point_units WHERE point_id = ?`,
    req.params.id,
  );
  res.render("points/_units", { point: { id: req.params.id }, units });
}

// Notes
pointsRoutes.post("/:id/notes", (req, res) => {
  const { note } = req.body;
  if (note) {
    run(
      `INSERT INTO point_notes (point_id, note) VALUES (?, ?)`,
      req.params.id,
      note.trim(),
    );
  }
  renderNotesFragment(req, res);
});

pointsRoutes.delete("/:id/notes", (req, res) => {
  const { note } = req.body;
  run(
    `DELETE FROM point_notes WHERE point_id = ? AND note = ?`,
    req.params.id,
    note,
  );
  renderNotesFragment(req, res);
});

function renderNotesFragment(req: any, res: any) {
  const notes = all<{ note: string }>(
    `SELECT note FROM point_notes WHERE point_id = ?`,
    req.params.id,
  );
  res.render("points/_notes", { point: { id: req.params.id }, notes });
}

// States
pointsRoutes.post("/:id/states", (req, res) => {
  const { state_key, state_value } = req.body;
  if (state_key !== undefined && state_value) {
    run(
      `INSERT OR REPLACE INTO point_states (point_id, state_key, state_value) VALUES (?, ?, ?)`,
      req.params.id,
      state_key,
      state_value.trim(),
    );
  }
  renderStatesFragment(req, res);
});

pointsRoutes.delete("/:id/states", (req, res) => {
  const { state_key } = req.body;
  run(
    `DELETE FROM point_states WHERE point_id = ? AND state_key = ?`,
    req.params.id,
    state_key,
  );
  renderStatesFragment(req, res);
});

function renderStatesFragment(req: any, res: any) {
  const states = all<{ state_key: string; state_value: string }>(
    `SELECT state_key, state_value FROM point_states WHERE point_id = ? ORDER BY state_key`,
    req.params.id,
  );
  res.render("points/_states", { point: { id: req.params.id }, states });
}

// Related
pointsRoutes.post("/:id/related", (req, res) => {
  const { point_id: relatedId } = req.body;
  if (relatedId) {
    run(
      `INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES (?, ?)`,
      req.params.id,
      relatedId,
    );
  }
  renderRelatedFragment(req, res);
});

pointsRoutes.delete("/:id/related", (req, res) => {
  const { related_id } = req.body;
  run(
    `DELETE FROM point_related WHERE point_id = ? AND related_point_id = ?`,
    req.params.id,
    related_id,
  );
  renderRelatedFragment(req, res);
});

function renderRelatedFragment(req: any, res: any) {
  const related = all<{ related_point_id: string }>(
    `SELECT related_point_id FROM point_related WHERE point_id = ? ORDER BY related_point_id`,
    req.params.id,
  );
  const relatedNames = related.map((r) => {
    const p = get<{ name: string }>(`SELECT name FROM points WHERE id = ?`, r.related_point_id);
    return { id: r.related_point_id, name: p?.name || r.related_point_id };
  });
  res.render("points/_related", {
    point: { id: req.params.id },
    related: relatedNames,
  });
}
