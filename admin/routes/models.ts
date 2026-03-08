import { Router } from "express";
import { all, get, run, transaction } from "../db.js";
import { flashRedirect } from "../helpers/flash.js";
import { updateSearchEntry, deleteSearchEntry } from "../helpers/search-index.js";

export const modelsRoutes = Router();

modelsRoutes.get("/", (req, res) => {
  const { brand, type } = req.query as Record<string, string>;
  let sql = `SELECT m.*, b.name as brand_name, t.name as type_name
     FROM models m
     JOIN brands b ON m.brand_id = b.id
     JOIN types t ON m.type_id = t.id
     WHERE 1=1`;
  const params: unknown[] = [];

  if (brand) { sql += ` AND m.brand_id = ?`; params.push(brand); }
  if (type) { sql += ` AND m.type_id = ?`; params.push(type); }
  sql += ` ORDER BY m.name`;

  const models = all<Record<string, unknown>>(sql, ...params);
  const brands = all<{ id: string; name: string }>(`SELECT id, name FROM brands ORDER BY name`);
  const types = all<{ id: string; name: string }>(`SELECT id, name FROM types ORDER BY name`);

  res.render("catalog/models-list", {
    pageTitle: "Models",
    models,
    brands,
    types,
    filters: { brand, type },
  });
});

modelsRoutes.get("/new", (req, res) => {
  const brands = all<{ id: string; name: string }>(`SELECT id, name FROM brands ORDER BY name`);
  const types = all<{ id: string; name: string }>(`SELECT id, name FROM types ORDER BY name`);
  res.render("catalog/model-new", {
    pageTitle: "New Model",
    brands,
    types,
    values: { brand_id: req.query.brand || "", type_id: req.query.type || "" },
    errors: [],
  });
});

modelsRoutes.post("/", (req, res) => {
  const { id, name, slug, brand_id, type_id, description, status, manufacturer_url, image_url, added_at } = req.body;
  const errors: string[] = [];
  if (!id || !id.match(/^[a-z0-9-]+$/)) errors.push("ID is required");
  if (!name) errors.push("Name is required");
  if (!brand_id) errors.push("Brand is required");
  if (!type_id) errors.push("Type is required");

  const existing = get<{ id: string }>(`SELECT id FROM models WHERE id = ?`, id);
  if (existing) errors.push("Model with this ID already exists");

  if (errors.length > 0) {
    return res.render("catalog/model-new", {
      pageTitle: "New Model",
      brands: all<{ id: string; name: string }>(`SELECT id, name FROM brands ORDER BY name`),
      types: all<{ id: string; name: string }>(`SELECT id, name FROM types ORDER BY name`),
      values: req.body,
      errors,
    });
  }

  run(
    `INSERT INTO models (id, brand_id, type_id, name, slug, description, status, manufacturer_url, image_url, added_at)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    id, brand_id, type_id, name, slug || id, description || null,
    status || "current", manufacturer_url || null, image_url || null,
    added_at || new Date().toISOString().split("T")[0],
  );

  updateSearchEntry(id, "model", name, [name.toLowerCase(), id]);
  res.redirect(flashRedirect(`/models/${id}`, "success", "Model created"));
});

modelsRoutes.get("/:id", (req, res) => {
  const model = get<Record<string, unknown>>(
    `SELECT * FROM models WHERE id = ?`, req.params.id,
  );
  if (!model) return res.status(404).send("Model not found");

  const modelNumbers = all<{ model_number: string }>(
    `SELECT model_number FROM model_numbers WHERE model_id = ?`, req.params.id,
  );
  const protocols = all<{ protocol: string }>(
    `SELECT protocol FROM model_protocols WHERE model_id = ?`, req.params.id,
  );
  const brands = all<{ id: string; name: string }>(`SELECT id, name FROM brands ORDER BY name`);
  const types = all<{ id: string; name: string }>(`SELECT id, name FROM types ORDER BY name`);

  res.render("catalog/model-detail", {
    pageTitle: model.name as string,
    model,
    modelNumbers,
    protocols,
    brands,
    types,
  });
});

modelsRoutes.put("/:id", (req, res) => {
  const { name, slug, brand_id, type_id, description, status, manufacturer_url, image_url, added_at } = req.body;
  run(
    `UPDATE models SET name=?, slug=?, brand_id=?, type_id=?, description=?, status=?, manufacturer_url=?, image_url=?, added_at=? WHERE id=?`,
    name, slug || req.params.id, brand_id, type_id, description || null,
    status || "current", manufacturer_url || null, image_url || null,
    added_at || null, req.params.id,
  );

  const tokens = [name.toLowerCase(), req.params.id];
  const mns = all<{ model_number: string }>(`SELECT model_number FROM model_numbers WHERE model_id = ?`, req.params.id);
  const prots = all<{ protocol: string }>(`SELECT protocol FROM model_protocols WHERE model_id = ?`, req.params.id);
  tokens.push(...mns.map(m => m.model_number.toLowerCase()));
  tokens.push(...prots.map(p => p.protocol.toLowerCase()));
  updateSearchEntry(req.params.id, "model", name, tokens);

  res.redirect(flashRedirect(`/models/${req.params.id}`, "success", "Model updated"));
});

modelsRoutes.delete("/:id", (req, res) => {
  transaction(() => {
    run(`DELETE FROM model_numbers WHERE model_id = ?`, req.params.id);
    run(`DELETE FROM model_protocols WHERE model_id = ?`, req.params.id);
    deleteSearchEntry(req.params.id, "model");
    run(`DELETE FROM models WHERE id = ?`, req.params.id);
  });

  if (res.locals.isHtmx) {
    res.set("HX-Redirect", "/models?flash_type=success&flash_msg=Model+deleted");
    return res.send("");
  }
  res.redirect(flashRedirect("/models", "success", "Model deleted"));
});

// Model numbers
modelsRoutes.post("/:id/model-numbers", (req, res) => {
  const { model_number } = req.body;
  if (model_number) {
    run(`INSERT INTO model_numbers (model_id, model_number) VALUES (?, ?)`, req.params.id, model_number.trim());
  }
  renderModelNumbers(req, res);
});

modelsRoutes.delete("/:id/model-numbers", (req, res) => {
  const { model_number } = req.body;
  run(`DELETE FROM model_numbers WHERE model_id = ? AND model_number = ?`, req.params.id, model_number);
  renderModelNumbers(req, res);
});

function renderModelNumbers(req: any, res: any) {
  const modelNumbers = all<{ model_number: string }>(
    `SELECT model_number FROM model_numbers WHERE model_id = ?`, req.params.id,
  );
  res.render("catalog/_model_numbers", { model: { id: req.params.id }, modelNumbers });
}

// Protocols
modelsRoutes.post("/:id/protocols", (req, res) => {
  const { protocol } = req.body;
  if (protocol) {
    run(`INSERT INTO model_protocols (model_id, protocol) VALUES (?, ?)`, req.params.id, protocol.trim());
  }
  renderProtocols(req, res);
});

modelsRoutes.delete("/:id/protocols", (req, res) => {
  const { protocol } = req.body;
  run(`DELETE FROM model_protocols WHERE model_id = ? AND protocol = ?`, req.params.id, protocol);
  renderProtocols(req, res);
});

function renderProtocols(req: any, res: any) {
  const protocols = all<{ protocol: string }>(
    `SELECT protocol FROM model_protocols WHERE model_id = ?`, req.params.id,
  );
  res.render("catalog/_protocols", { model: { id: req.params.id }, protocols });
}
