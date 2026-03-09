import { Router } from "express";
import * as fs from "fs";
import * as path from "path";
import { spawnSync } from "child_process";
import { stringify as yamlStringify } from "yaml";
import { all, get, run } from "../db.js";

export const exportRoutes = Router();

const DATA_DIR = path.join(process.cwd(), "data");

exportRoutes.get("/", (_req, res) => {
  const counts = {
    points: get<{ count: number }>(`SELECT COUNT(*) as count FROM points`)!.count,
    equipment: get<{ count: number }>(`SELECT COUNT(*) as count FROM equipment`)!.count,
    brands: get<{ count: number }>(`SELECT COUNT(*) as count FROM brands`)!.count,
    types: get<{ count: number }>(`SELECT COUNT(*) as count FROM types`)!.count,
    models: get<{ count: number }>(`SELECT COUNT(*) as count FROM models`)!.count,
  };

  res.render("export", { pageTitle: "Export", counts, log: null });
});

exportRoutes.post("/", (req, res) => {
  const log: string[] = [];
  const rebuild = req.body.rebuild === "on";

  try {
    // Export points
    exportPoints(log);

    // Export equipment
    exportEquipment(log);

    // Export catalog
    exportBrands(log);
    exportTypes(log);
    exportModels(log);

    // Update meta
    run(`UPDATE meta SET value = ? WHERE key = 'lastUpdated'`, new Date().toISOString());
    log.push("Updated meta.lastUpdated");

    // Optionally rebuild
    if (rebuild) {
      log.push("Running npm run build...");
      const result = spawnSync("npm", ["run", "build"], {
        cwd: process.cwd(),
        stdio: "pipe",
        encoding: "utf-8",
      });
      if (result.status === 0) {
        log.push("Build completed successfully");
      } else {
        log.push(`Build failed: ${result.stderr || result.stdout}`);
      }
    }
  } catch (err: any) {
    log.push(`ERROR: ${err.message}`);
  }

  const counts = {
    points: get<{ count: number }>(`SELECT COUNT(*) as count FROM points`)!.count,
    equipment: get<{ count: number }>(`SELECT COUNT(*) as count FROM equipment`)!.count,
    brands: get<{ count: number }>(`SELECT COUNT(*) as count FROM brands`)!.count,
    types: get<{ count: number }>(`SELECT COUNT(*) as count FROM types`)!.count,
    models: get<{ count: number }>(`SELECT COUNT(*) as count FROM models`)!.count,
  };

  res.render("export", { pageTitle: "Export", counts, log });
});

function exportPoints(log: string[]) {
  const points = all<Record<string, any>>(`SELECT * FROM points ORDER BY category, id`);
  const writtenPaths = new Set<string>();

  for (const point of points) {
    const aliases = all<{ alias: string; alias_group: string }>(
      `SELECT alias, alias_group FROM point_aliases WHERE point_id = ? ORDER BY alias_group, alias`,
      point.id,
    );
    const units = all<{ unit: string }>(
      `SELECT unit FROM point_units WHERE point_id = ?`,
      point.id,
    );
    const notes = all<{ note: string }>(
      `SELECT note FROM point_notes WHERE point_id = ?`,
      point.id,
    );
    const states = all<{ state_key: string; state_value: string }>(
      `SELECT state_key, state_value FROM point_states WHERE point_id = ? ORDER BY state_key`,
      point.id,
    );
    const related = all<{ related_point_id: string }>(
      `SELECT related_point_id FROM point_related WHERE point_id = ? ORDER BY related_point_id`,
      point.id,
    );

    const yamlObj: any = {
      concept: {
        id: point.id,
        name: point.name,
        category: point.category,
      },
    };

    if (point.subcategory) yamlObj.concept.subcategory = point.subcategory;
    yamlObj.concept.description = point.description;

    if (point.haystack_tag_string) {
      yamlObj.concept.haystack = point.haystack_tag_string
        .split(" ")
        .filter((t: string) => t !== "point")
        .join(" ");
    }

    if (point.brick) yamlObj.concept.brick = point.brick;
    if (units.length > 0) yamlObj.concept.unit = units.map((u) => u.unit);
    if (point.point_function) yamlObj.concept.point_function = point.point_function;

    if (states.length > 0) {
      yamlObj.concept.states = {};
      for (const s of states) {
        yamlObj.concept.states[s.state_key] = s.state_value;
      }
    }

    const commonAliases = aliases.filter((a) => a.alias_group === "common").map((a) => a.alias);
    const misspellingAliases = aliases.filter((a) => a.alias_group === "misspellings").map((a) => a.alias);

    yamlObj.aliases = { common: commonAliases };
    if (misspellingAliases.length > 0) yamlObj.aliases.misspellings = misspellingAliases;

    if (notes.length > 0) yamlObj.notes = notes.map((n) => n.note);
    if (related.length > 0) yamlObj.related = related.map((r) => r.related_point_id);

    const dir = path.join(DATA_DIR, "points", point.category);
    fs.mkdirSync(dir, { recursive: true });
    const filePath = path.join(dir, `${point.id}.yaml`);
    fs.writeFileSync(filePath, yamlStringify(yamlObj, { lineWidth: 0 }));
    writtenPaths.add(filePath);
  }

  // Clean up orphan files
  const pointsDir = path.join(DATA_DIR, "points");
  if (fs.existsSync(pointsDir)) {
    cleanOrphanFiles(pointsDir, writtenPaths, ".yaml", log);
  }

  log.push(`Exported ${points.length} points`);
}

function exportEquipment(log: string[]) {
  const equipment = all<Record<string, any>>(
    `SELECT * FROM equipment ORDER BY category, name`,
  );

  // Group by category
  const byCategory = new Map<string, any[]>();
  for (const equip of equipment) {
    if (!byCategory.has(equip.category)) byCategory.set(equip.category, []);
    byCategory.get(equip.category)!.push(equip);
  }

  const writtenPaths = new Set<string>();

  for (const [category, entries] of byCategory) {
    const equipList = entries.map((equip: any) => {
      const aliases = all<{ alias: string; alias_group: string }>(
        `SELECT alias, alias_group FROM equipment_aliases WHERE equipment_id = ? ORDER BY alias_group, alias`,
        equip.id,
      );
      const subtypes = all<{ subtype_id: string; subtype_name: string; description: string }>(
        `SELECT subtype_id, subtype_name, description FROM equipment_subtypes WHERE equipment_id = ?`,
        equip.id,
      );
      const typicalPoints = all<{ point_id: string }>(
        `SELECT point_id FROM equipment_typical_points WHERE equipment_id = ? ORDER BY point_id`,
        equip.id,
      );

      const entry: any = {
        id: equip.id,
        name: equip.name,
      };

      if (equip.full_name) entry.full_name = equip.full_name;
      if (equip.abbreviation) entry.abbreviation = equip.abbreviation;
      entry.category = equip.category;
      entry.description = equip.description;

      if (equip.haystack_tag_string) {
        entry.haystack = equip.haystack_tag_string
          .split(" ")
          .filter((t: string) => t !== "equip")
          .join(" ");
      }

      if (equip.brick) entry.brick = equip.brick;

      if (subtypes.length > 0) {
        entry.subtypes = subtypes.map((st: any) => {
          const stAliases = all<{ alias: string }>(
            `SELECT alias FROM equipment_subtype_aliases WHERE equipment_id = ? AND subtype_id = ?`,
            equip.id,
            st.subtype_id,
          );

          if (!st.description && st.subtype_name === st.subtype_id && stAliases.length === 0) {
            return st.subtype_id;
          }

          const obj: any = { id: st.subtype_id, name: st.subtype_name };
          if (st.description) obj.description = st.description;
          if (stAliases.length > 0) obj.aliases = stAliases.map((a: any) => a.alias);
          return obj;
        });
      }

      const commonAliases = aliases.filter((a) => a.alias_group === "common").map((a) => a.alias);
      const misspellings = aliases.filter((a) => a.alias_group === "misspellings").map((a) => a.alias);
      entry.aliases = { common: commonAliases };
      if (misspellings.length > 0) entry.aliases.misspellings = misspellings;

      if (typicalPoints.length > 0) {
        entry.typical_points = typicalPoints.map((tp) => tp.point_id);
      }

      return entry;
    });

    const yamlObj = { equipment: equipList };
    const filePath = path.join(DATA_DIR, "equipment", `${category}.yaml`);
    fs.mkdirSync(path.dirname(filePath), { recursive: true });
    fs.writeFileSync(filePath, yamlStringify(yamlObj, { lineWidth: 0 }));
    writtenPaths.add(filePath);
  }

  // Clean up orphan category files
  const equipDir = path.join(DATA_DIR, "equipment");
  if (fs.existsSync(equipDir)) {
    for (const file of fs.readdirSync(equipDir)) {
      if (file.endsWith(".yaml")) {
        const fullPath = path.join(equipDir, file);
        if (!writtenPaths.has(fullPath)) {
          fs.unlinkSync(fullPath);
          log.push(`Deleted orphan: equipment/${file}`);
        }
      }
    }
  }

  log.push(`Exported ${equipment.length} equipment entries across ${byCategory.size} categories`);
}

function exportBrands(log: string[]) {
  const brands = all<Record<string, any>>(`SELECT * FROM brands ORDER BY name`);
  const dir = path.join(DATA_DIR, "catalog", "brands");
  fs.mkdirSync(dir, { recursive: true });
  const writtenPaths = new Set<string>();

  for (const b of brands) {
    const obj = {
      brand: {
        id: b.id,
        name: b.name,
        slug: b.slug || b.id,
        logo_url: b.logo_url || "",
        website: b.website || "",
        description: b.description || "",
      },
    };
    const filePath = path.join(dir, `${b.slug || b.id}.json`);
    fs.writeFileSync(filePath, JSON.stringify(obj, null, 2) + "\n");
    writtenPaths.add(filePath);
  }

  cleanOrphanFiles(dir, writtenPaths, ".json", log);
  log.push(`Exported ${brands.length} brands`);
}

function exportTypes(log: string[]) {
  const types = all<Record<string, any>>(`SELECT * FROM types ORDER BY name`);
  const dir = path.join(DATA_DIR, "catalog", "types");
  fs.mkdirSync(dir, { recursive: true });
  const writtenPaths = new Set<string>();

  for (const t of types) {
    const obj = {
      type: {
        id: t.id,
        name: t.name,
        slug: t.slug || t.id,
        description: t.description || "",
      },
    };
    const filePath = path.join(dir, `${t.slug || t.id}.json`);
    fs.writeFileSync(filePath, JSON.stringify(obj, null, 2) + "\n");
    writtenPaths.add(filePath);
  }

  cleanOrphanFiles(dir, writtenPaths, ".json", log);
  log.push(`Exported ${types.length} types`);
}

function exportModels(log: string[]) {
  const models = all<Record<string, any>>(`SELECT * FROM models ORDER BY name`);
  const dir = path.join(DATA_DIR, "catalog", "models");
  fs.mkdirSync(dir, { recursive: true });
  const writtenPaths = new Set<string>();

  for (const m of models) {
    const modelNumbers = all<{ model_number: string }>(
      `SELECT model_number FROM model_numbers WHERE model_id = ?`,
      m.id,
    );
    const protocols = all<{ protocol: string }>(
      `SELECT protocol FROM model_protocols WHERE model_id = ?`,
      m.id,
    );

    const obj = {
      model: {
        id: m.id,
        brand: m.brand_id,
        type: m.type_id,
        name: m.name,
        slug: m.slug || m.id,
        model_numbers: modelNumbers.map((mn) => mn.model_number),
        protocols: protocols.map((p) => p.protocol),
        status: m.status || "current",
        description: m.description || "",
        manufacturer_url: m.manufacturer_url || "",
        image_url: m.image_url || "",
        added_at: m.added_at || "",
      },
    };
    const filePath = path.join(dir, `${m.slug || m.id}.json`);
    fs.writeFileSync(filePath, JSON.stringify(obj, null, 2) + "\n");
    writtenPaths.add(filePath);
  }

  cleanOrphanFiles(dir, writtenPaths, ".json", log);
  log.push(`Exported ${models.length} models`);
}

function cleanOrphanFiles(
  dir: string,
  writtenPaths: Set<string>,
  ext: string,
  log: string[],
) {
  const items = fs.readdirSync(dir, { withFileTypes: true });
  for (const item of items) {
    const fullPath = path.join(dir, item.name);
    if (item.isDirectory()) {
      cleanOrphanFiles(fullPath, writtenPaths, ext, log);
      // Remove empty directories
      try {
        const remaining = fs.readdirSync(fullPath);
        if (remaining.length === 0) {
          fs.rmdirSync(fullPath);
          log.push(`Removed empty directory: ${path.relative(DATA_DIR, fullPath)}`);
        }
      } catch {}
    } else if (item.name.endsWith(ext) && !writtenPaths.has(fullPath)) {
      fs.unlinkSync(fullPath);
      log.push(`Deleted orphan: ${path.relative(DATA_DIR, fullPath)}`);
    }
  }
}
