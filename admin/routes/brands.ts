import { Router } from "express";
import { all, get, run } from "../db.js";
import { flashRedirect } from "../helpers/flash.js";
import { updateSearchEntry, deleteSearchEntry } from "../helpers/search-index.js";

export const brandsRoutes = Router();

brandsRoutes.get("/", (_req, res) => {
  const brands = all<Record<string, unknown>>(
    `SELECT b.*, (SELECT COUNT(*) FROM models WHERE brand_id = b.id) as model_count
     FROM brands b ORDER BY b.name`,
  );
  res.render("catalog/brands-list", { pageTitle: "Brands", brands });
});

brandsRoutes.get("/new", (_req, res) => {
  res.render("catalog/brand-new", {
    pageTitle: "New Brand",
    values: {},
    errors: [],
  });
});

brandsRoutes.post("/", (req, res) => {
  const { id, name, slug, website, description } = req.body;
  const errors: string[] = [];
  if (!id || !id.match(/^[a-z0-9-]+$/)) errors.push("ID is required");
  if (!name) errors.push("Name is required");
  const existing = get<{ id: string }>(`SELECT id FROM brands WHERE id = ?`, id);
  if (existing) errors.push("Brand with this ID already exists");

  if (errors.length > 0) {
    return res.render("catalog/brand-new", {
      pageTitle: "New Brand",
      values: req.body,
      errors,
    });
  }

  run(
    `INSERT INTO brands (id, name, slug, logo_url, website, description) VALUES (?, ?, ?, ?, ?, ?)`,
    id, name, slug || id, null, website || null, description || null,
  );
  updateSearchEntry(id, "brand", name, [name.toLowerCase()]);
  res.redirect(flashRedirect(`/brands/${id}`, "success", "Brand created"));
});

brandsRoutes.get("/:id", (req, res) => {
  const brand = get<Record<string, unknown>>(
    `SELECT * FROM brands WHERE id = ?`, req.params.id,
  );
  if (!brand) return res.status(404).send("Brand not found");

  const models = all<Record<string, unknown>>(
    `SELECT * FROM models WHERE brand_id = ? ORDER BY name`, req.params.id,
  );
  res.render("catalog/brand-detail", {
    pageTitle: brand.name as string,
    brand,
    models,
  });
});

brandsRoutes.put("/:id", (req, res) => {
  const { name, slug, website, description } = req.body;
  run(
    `UPDATE brands SET name=?, slug=?, website=?, description=? WHERE id=?`,
    name, slug || req.params.id, website || null, description || null, req.params.id,
  );
  updateSearchEntry(req.params.id, "brand", name, [name.toLowerCase()]);
  res.redirect(flashRedirect(`/brands/${req.params.id}`, "success", "Brand updated"));
});

brandsRoutes.delete("/:id", (req, res) => {
  const modelCount = get<{ count: number }>(
    `SELECT COUNT(*) as count FROM models WHERE brand_id = ?`, req.params.id,
  )!.count;

  if (modelCount > 0) {
    if (res.locals.isHtmx) {
      res.set("HX-Redirect", flashRedirect(`/brands/${req.params.id}`, "error", `Cannot delete: ${modelCount} models reference this brand`));
      return res.send("");
    }
    return res.redirect(flashRedirect(`/brands/${req.params.id}`, "error", `Cannot delete: ${modelCount} models reference this brand`));
  }

  deleteSearchEntry(req.params.id, "brand");
  run(`DELETE FROM brands WHERE id = ?`, req.params.id);

  if (res.locals.isHtmx) {
    res.set("HX-Redirect", "/brands?flash_type=success&flash_msg=Brand+deleted");
    return res.send("");
  }
  res.redirect(flashRedirect("/brands", "success", "Brand deleted"));
});
