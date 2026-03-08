import { Router } from "express";
import { all, get, run } from "../db.js";
import { flashRedirect } from "../helpers/flash.js";
import { updateSearchEntry, deleteSearchEntry } from "../helpers/search-index.js";

export const typesRoutes = Router();

typesRoutes.get("/", (_req, res) => {
  const types = all<Record<string, unknown>>(
    `SELECT t.*, (SELECT COUNT(*) FROM models WHERE type_id = t.id) as model_count
     FROM types t ORDER BY t.name`,
  );
  res.render("catalog/types-list", { pageTitle: "Types", types });
});

typesRoutes.get("/new", (_req, res) => {
  res.render("catalog/type-new", {
    pageTitle: "New Type",
    values: {},
    errors: [],
  });
});

typesRoutes.post("/", (req, res) => {
  const { id, name, slug, description } = req.body;
  const errors: string[] = [];
  if (!id || !id.match(/^[a-z0-9-]+$/)) errors.push("ID is required");
  if (!name) errors.push("Name is required");
  const existing = get<{ id: string }>(`SELECT id FROM types WHERE id = ?`, id);
  if (existing) errors.push("Type with this ID already exists");

  if (errors.length > 0) {
    return res.render("catalog/type-new", {
      pageTitle: "New Type",
      values: req.body,
      errors,
    });
  }

  run(
    `INSERT INTO types (id, name, slug, description) VALUES (?, ?, ?, ?)`,
    id, name, slug || id, description || null,
  );
  updateSearchEntry(id, "type", name, [name.toLowerCase()]);
  res.redirect(flashRedirect(`/types/${id}`, "success", "Type created"));
});

typesRoutes.get("/:id", (req, res) => {
  const type = get<Record<string, unknown>>(
    `SELECT * FROM types WHERE id = ?`, req.params.id,
  );
  if (!type) return res.status(404).send("Type not found");

  const models = all<Record<string, unknown>>(
    `SELECT * FROM models WHERE type_id = ? ORDER BY name`, req.params.id,
  );
  res.render("catalog/type-detail", {
    pageTitle: type.name as string,
    type,
    models,
  });
});

typesRoutes.put("/:id", (req, res) => {
  const { name, slug, description } = req.body;
  run(
    `UPDATE types SET name=?, slug=?, description=? WHERE id=?`,
    name, slug || req.params.id, description || null, req.params.id,
  );
  updateSearchEntry(req.params.id, "type", name, [name.toLowerCase()]);
  res.redirect(flashRedirect(`/types/${req.params.id}`, "success", "Type updated"));
});

typesRoutes.delete("/:id", (req, res) => {
  const modelCount = get<{ count: number }>(
    `SELECT COUNT(*) as count FROM models WHERE type_id = ?`, req.params.id,
  )!.count;

  if (modelCount > 0) {
    if (res.locals.isHtmx) {
      res.set("HX-Redirect", flashRedirect(`/types/${req.params.id}`, "error", `Cannot delete: ${modelCount} models reference this type`));
      return res.send("");
    }
    return res.redirect(flashRedirect(`/types/${req.params.id}`, "error", `Cannot delete: ${modelCount} models reference this type`));
  }

  deleteSearchEntry(req.params.id, "type");
  run(`DELETE FROM types WHERE id = ?`, req.params.id);

  if (res.locals.isHtmx) {
    res.set("HX-Redirect", "/types?flash_type=success&flash_msg=Type+deleted");
    return res.send("");
  }
  res.redirect(flashRedirect("/types", "success", "Type deleted"));
});
