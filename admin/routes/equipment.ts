import { Router } from "express";
import { all, get, run, transaction } from "../db.js";
import { flashRedirect } from "../helpers/flash.js";
import {
  updateSearchEntry,
  deleteSearchEntry,
  extractEquipTokensFromDb,
} from "../helpers/search-index.js";

export const equipmentRoutes = Router();

function getEquipCategories(): string[] {
  return all<{ category: string }>(
    `SELECT DISTINCT category FROM equipment ORDER BY category`,
  ).map((r) => r.category);
}

// List
equipmentRoutes.get("/", (req, res) => {
  const { category, q } = req.query as Record<string, string>;
  let sql = `SELECT e.*,
    (SELECT COUNT(*) FROM equipment_typical_points WHERE equipment_id = e.id) as tp_count
    FROM equipment e WHERE 1=1`;
  const params: unknown[] = [];

  if (category) {
    sql += ` AND e.category = ?`;
    params.push(category);
  }
  if (q) {
    sql += ` AND (e.name LIKE '%' || ? || '%' OR e.id LIKE '%' || ? || '%')`;
    params.push(q, q);
  }
  sql += ` ORDER BY e.category, e.name`;

  const equipment = all<Record<string, unknown>>(sql, ...params);
  const categories = getEquipCategories();

  if (res.locals.isHtmx) {
    return res.render("equipment/_rows", { equipment });
  }

  res.render("equipment/list", {
    pageTitle: "Equipment",
    equipment,
    categories,
    filters: { category, q },
  });
});

// New form
equipmentRoutes.get("/new", (_req, res) => {
  const categories = getEquipCategories();
  const allEquip = all<{ id: string; name: string }>(
    `SELECT id, name FROM equipment ORDER BY name`,
  );
  res.render("equipment/new", {
    pageTitle: "New Equipment",
    categories,
    allEquip,
    values: {},
    errors: [],
  });
});

// Create
equipmentRoutes.post("/", (req, res) => {
  const { id, name, full_name, abbreviation, category, description, brick, haystack, parent_id } =
    req.body;
  const errors: string[] = [];

  if (!id || !id.match(/^[a-z0-9-]+$/))
    errors.push("ID must be lowercase alphanumeric with dashes");
  if (!name) errors.push("Name is required");
  if (!category) errors.push("Category is required");

  const existing = get<{ id: string }>(`SELECT id FROM equipment WHERE id = ?`, id);
  if (existing) errors.push("Equipment with this ID already exists");

  if (errors.length > 0) {
    return res.render("equipment/new", {
      pageTitle: "New Equipment",
      categories: getEquipCategories(),
      allEquip: all<{ id: string; name: string }>(
        `SELECT id, name FROM equipment ORDER BY name`,
      ),
      values: req.body,
      errors,
    });
  }

  const tagString = haystack
    ? (haystack.trim().includes("equip") ? haystack.trim() : haystack.trim() + " equip")
    : null;

  run(
    `INSERT INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    id,
    name,
    full_name || null,
    abbreviation || null,
    category,
    description || null,
    brick || null,
    tagString,
    parent_id || null,
  );

  const equip = get<Record<string, unknown>>(`SELECT * FROM equipment WHERE id = ?`, id)!;
  const tokens = extractEquipTokensFromDb(equip as any);
  updateSearchEntry(id, "equipment", name, tokens);

  res.redirect(flashRedirect(`/equipment/${id}`, "success", "Equipment created"));
});

// Detail
equipmentRoutes.get("/:id", (req, res) => {
  const equip = get<Record<string, unknown>>(
    `SELECT * FROM equipment WHERE id = ?`,
    req.params.id,
  );
  if (!equip) return res.status(404).send("Equipment not found");

  const aliases = all<{ alias: string; alias_group: string }>(
    `SELECT alias, alias_group FROM equipment_aliases WHERE equipment_id = ? ORDER BY alias_group, alias`,
    req.params.id,
  );
  const subtypes = all<{
    subtype_id: string;
    subtype_name: string;
    description: string;
  }>(
    `SELECT subtype_id, subtype_name, description FROM equipment_subtypes WHERE equipment_id = ?`,
    req.params.id,
  );
  const subtypeAliases = all<{
    subtype_id: string;
    alias: string;
  }>(
    `SELECT subtype_id, alias FROM equipment_subtype_aliases WHERE equipment_id = ?`,
    req.params.id,
  );
  const typicalPoints = all<{ id: string; name: string; category: string; point_function: string }>(
    `SELECT p.id, p.name, p.category, p.point_function FROM points p
     JOIN equipment_typical_points etp ON p.id = etp.point_id
     WHERE etp.equipment_id = ? ORDER BY p.category, p.name`,
    req.params.id,
  );
  const tags = all<{ tag_name: string; tag_kind: string }>(
    `SELECT tag_name, tag_kind FROM equipment_haystack_tags WHERE equipment_id = ?`,
    req.params.id,
  );
  const allEquip = all<{ id: string; name: string }>(
    `SELECT id, name FROM equipment WHERE id != ? ORDER BY name`,
    req.params.id,
  );

  res.render("equipment/detail", {
    pageTitle: equip.name as string,
    equip,
    aliases,
    subtypes,
    subtypeAliases,
    typicalPoints,
    tags,
    categories: getEquipCategories(),
    allEquip,
  });
});

// Update
equipmentRoutes.put("/:id", (req, res) => {
  const { name, full_name, abbreviation, category, description, brick, haystack, parent_id } =
    req.body;

  const tagString = haystack
    ? (haystack.trim().includes("equip") ? haystack.trim() : haystack.trim() + " equip")
    : null;

  run(
    `UPDATE equipment SET name=?, full_name=?, abbreviation=?, category=?, description=?, brick=?, haystack_tag_string=?, parent_id=? WHERE id=?`,
    name,
    full_name || null,
    abbreviation || null,
    category,
    description || null,
    brick || null,
    tagString,
    parent_id || null,
    req.params.id,
  );

  run(`DELETE FROM equipment_haystack_tags WHERE equipment_id = ?`, req.params.id);
  if (tagString) {
    for (const tag of tagString.split(/\s+/)) {
      if (tag)
        run(
          `INSERT INTO equipment_haystack_tags (equipment_id, tag_name, tag_kind) VALUES (?, ?, 'Marker')`,
          req.params.id,
          tag,
        );
    }
  }

  const equip = get<Record<string, unknown>>(
    `SELECT * FROM equipment WHERE id = ?`,
    req.params.id,
  )!;
  const tokens = extractEquipTokensFromDb(equip as any);
  updateSearchEntry(req.params.id, "equipment", name, tokens);

  res.redirect(
    flashRedirect(`/equipment/${req.params.id}`, "success", "Equipment updated"),
  );
});

// Delete
equipmentRoutes.delete("/:id", (req, res) => {
  transaction(() => {
    run(`DELETE FROM equipment_aliases WHERE equipment_id = ?`, req.params.id);
    run(`DELETE FROM equipment_haystack_tags WHERE equipment_id = ?`, req.params.id);
    run(`DELETE FROM equipment_subtypes WHERE equipment_id = ?`, req.params.id);
    run(`DELETE FROM equipment_subtype_aliases WHERE equipment_id = ?`, req.params.id);
    run(`DELETE FROM equipment_typical_points WHERE equipment_id = ?`, req.params.id);
    deleteSearchEntry(req.params.id, "equipment");
    run(`DELETE FROM equipment WHERE id = ?`, req.params.id);
  });

  if (res.locals.isHtmx) {
    res.set("HX-Redirect", "/equipment?flash_type=success&flash_msg=Equipment+deleted");
    return res.send("");
  }
  res.redirect(flashRedirect("/equipment", "success", "Equipment deleted"));
});

// --- Child data routes ---

// Aliases
equipmentRoutes.post("/:id/aliases", (req, res) => {
  const { alias, group } = req.body;
  if (alias) {
    run(
      `INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES (?, ?, ?)`,
      req.params.id,
      alias.trim(),
      group || "common",
    );
  }
  renderEquipAliases(req, res);
});

equipmentRoutes.delete("/:id/aliases", (req, res) => {
  const { alias, group } = req.body;
  run(
    `DELETE FROM equipment_aliases WHERE equipment_id = ? AND alias = ? AND alias_group = ?`,
    req.params.id,
    alias,
    group,
  );
  renderEquipAliases(req, res);
});

function renderEquipAliases(req: any, res: any) {
  const aliases = all<{ alias: string; alias_group: string }>(
    `SELECT alias, alias_group FROM equipment_aliases WHERE equipment_id = ? ORDER BY alias_group, alias`,
    req.params.id,
  );
  res.render("equipment/_aliases", { equip: { id: req.params.id }, aliases });
}

// Typical points
equipmentRoutes.post("/:id/typical-points", (req, res) => {
  const { point_id } = req.body;
  if (point_id) {
    run(
      `INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES (?, ?)`,
      req.params.id,
      point_id,
    );
  }
  renderTypicalPoints(req, res);
});

equipmentRoutes.delete("/:id/typical-points", (req, res) => {
  const { point_id } = req.body;
  run(
    `DELETE FROM equipment_typical_points WHERE equipment_id = ? AND point_id = ?`,
    req.params.id,
    point_id,
  );
  renderTypicalPoints(req, res);
});

function renderTypicalPoints(req: any, res: any) {
  const typicalPoints = all<{
    id: string;
    name: string;
    category: string;
    point_function: string;
  }>(
    `SELECT p.id, p.name, p.category, p.point_function FROM points p
     JOIN equipment_typical_points etp ON p.id = etp.point_id
     WHERE etp.equipment_id = ? ORDER BY p.category, p.name`,
    req.params.id,
  );
  res.render("equipment/_typical_points", {
    equip: { id: req.params.id },
    typicalPoints,
  });
}

// Subtypes
equipmentRoutes.post("/:id/subtypes", (req, res) => {
  const { subtype_id, subtype_name, description } = req.body;
  if (subtype_id && subtype_name) {
    run(
      `INSERT INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES (?, ?, ?, ?)`,
      req.params.id,
      subtype_id,
      subtype_name,
      description || null,
    );
  }
  renderSubtypes(req, res);
});

equipmentRoutes.delete("/:id/subtypes/:subtypeId", (req, res) => {
  run(
    `DELETE FROM equipment_subtype_aliases WHERE equipment_id = ? AND subtype_id = ?`,
    req.params.id,
    req.params.subtypeId,
  );
  run(
    `DELETE FROM equipment_subtypes WHERE equipment_id = ? AND subtype_id = ?`,
    req.params.id,
    req.params.subtypeId,
  );
  renderSubtypes(req, res);
});

function renderSubtypes(req: any, res: any) {
  const subtypes = all<{
    subtype_id: string;
    subtype_name: string;
    description: string;
  }>(
    `SELECT subtype_id, subtype_name, description FROM equipment_subtypes WHERE equipment_id = ?`,
    req.params.id,
  );
  const subtypeAliases = all<{ subtype_id: string; alias: string }>(
    `SELECT subtype_id, alias FROM equipment_subtype_aliases WHERE equipment_id = ?`,
    req.params.id,
  );
  res.render("equipment/_subtypes", {
    equip: { id: req.params.id },
    subtypes,
    subtypeAliases,
  });
}
