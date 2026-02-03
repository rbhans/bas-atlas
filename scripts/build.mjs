import fs from "fs";
import path from "path";

const DATA_DIR = path.join(process.cwd(), "data");
const DIST_DIR = path.join(process.cwd(), "dist");
const VALIDATE_ONLY = process.argv.includes("--validate");

function readJsonFiles(dir) {
  const results = [];
  if (!fs.existsSync(dir)) return results;

  const items = fs.readdirSync(dir, { withFileTypes: true });
  for (const item of items) {
    const fullPath = path.join(dir, item.name);
    if (item.isDirectory()) {
      results.push(...readJsonFiles(fullPath));
    } else if (item.name.endsWith(".json")) {
      try {
        const content = fs.readFileSync(fullPath, "utf-8");
        const parsed = JSON.parse(content);
        if (parsed) {
          results.push({ file: fullPath, data: parsed });
        }
      } catch (err) {
        console.error(`Error parsing ${fullPath}:`, err);
      }
    }
  }

  return results;
}

function tokenize(value) {
  if (!value) return [];
  return value
    .toString()
    .toLowerCase()
    .split(/\s+/)
    .map((t) => t.trim())
    .filter(Boolean);
}

function unique(values) {
  return Array.from(new Set(values));
}

function build() {
  console.log("Building BAS Atlas data...\n");

  const files = readJsonFiles(DATA_DIR);

  const brands = [];
  const types = [];
  const models = [];

  for (const { file, data } of files) {
    if (data.brand) {
      brands.push(data.brand);
    } else if (data.type) {
      types.push(data.type);
    } else if (data.model) {
      models.push(data.model);
    } else {
      console.warn(`Skipping ${file}: missing brand/type/model root key`);
    }
  }

  const brandIds = new Set();
  for (const brand of brands) {
    if (!brand.id) throw new Error("Brand missing id");
    if (brandIds.has(brand.id)) throw new Error(`Duplicate brand id: ${brand.id}`);
    brandIds.add(brand.id);
  }

  const typeIds = new Set();
  for (const type of types) {
    if (!type.id) throw new Error("Type missing id");
    if (typeIds.has(type.id)) throw new Error(`Duplicate type id: ${type.id}`);
    typeIds.add(type.id);
  }

  const modelIds = new Set();
  for (const model of models) {
    if (!model.id) throw new Error("Model missing id");
    if (modelIds.has(model.id)) throw new Error(`Duplicate model id: ${model.id}`);
    modelIds.add(model.id);

    if (!brandIds.has(model.brand)) {
      console.warn(`Model ${model.id} references missing brand: ${model.brand}`);
    }
    if (!typeIds.has(model.type)) {
      console.warn(`Model ${model.id} references missing type: ${model.type}`);
    }
  }

  const brandsById = Object.fromEntries(brands.map((b) => [b.id, b]));
  const typesById = Object.fromEntries(types.map((t) => [t.id, t]));

  const brandCounts = new Map();
  const typeCounts = new Map();

  for (const model of models) {
    brandCounts.set(model.brand, (brandCounts.get(model.brand) || 0) + 1);
    typeCounts.set(model.type, (typeCounts.get(model.type) || 0) + 1);
  }

  const brandCategories = brands
    .map((brand) => {
      const modelCount = brandCounts.get(brand.id) || 0;
      const brandModels = models.filter((m) => m.brand === brand.id);
      const typeMap = new Map();
      for (const model of brandModels) {
        typeMap.set(model.type, (typeMap.get(model.type) || 0) + 1);
      }
      const typesForBrand = Array.from(typeMap.entries()).map(([typeId, count]) => {
        const type = typesById[typeId];
        return {
          id: typeId,
          name: type?.name || typeId,
          slug: type?.slug || typeId,
          count,
        };
      });
      typesForBrand.sort((a, b) => a.name.localeCompare(b.name));
      return {
        id: brand.id,
        name: brand.name,
        slug: brand.slug || brand.id,
        count: modelCount,
        types: typesForBrand,
      };
    })
    .sort((a, b) => a.name.localeCompare(b.name));

  const typeCategories = types
    .map((type) => ({
      id: type.id,
      name: type.name,
      slug: type.slug || type.id,
      count: typeCounts.get(type.id) || 0,
    }))
    .sort((a, b) => a.name.localeCompare(b.name));

  const searchEntries = [];

  for (const brand of brands) {
    const tokens = unique([
      ...tokenize(brand.name),
      ...tokenize(brand.id),
      ...tokenize(brand.slug),
    ]);
    searchEntries.push({
      id: brand.id,
      type: "brand",
      name: brand.name,
      tokens,
    });
  }

  for (const type of types) {
    const tokens = unique([
      ...tokenize(type.name),
      ...tokenize(type.id),
      ...tokenize(type.slug),
    ]);
    searchEntries.push({
      id: type.id,
      type: "type",
      name: type.name,
      tokens,
    });
  }

  for (const model of models) {
    const brand = brandsById[model.brand];
    const type = typesById[model.type];

    const tokens = unique([
      ...tokenize(model.name),
      ...tokenize(model.id),
      ...tokenize(model.slug),
      ...(model.model_numbers || []).flatMap(tokenize),
      ...(model.protocols || []).flatMap(tokenize),
      ...(model.aliases?.common || []).flatMap(tokenize),
      ...(model.aliases?.misspellings || []).flatMap(tokenize),
      ...tokenize(brand?.name),
      ...tokenize(type?.name),
    ]);

    searchEntries.push({
      id: model.id,
      type: "model",
      name: model.name,
      brand: model.brand,
      model_numbers: model.model_numbers || [],
      tokens,
    });
  }

  if (!fs.existsSync(DIST_DIR) && !VALIDATE_ONLY) {
    fs.mkdirSync(DIST_DIR, { recursive: true });
  }

  const data = {
    version: "1.0.0",
    lastUpdated: new Date().toISOString(),
    totalBrands: brands.length,
    totalTypes: types.length,
    totalModels: models.length,
    brands,
    types,
    models,
  };

  const categories = {
    version: "1.0.0",
    brands: brandCategories,
    types: typeCategories,
  };

  const searchIndex = {
    version: "1.0.0",
    entries: searchEntries,
  };

  if (!VALIDATE_ONLY) {
    fs.writeFileSync(path.join(DIST_DIR, "index.json"), JSON.stringify(data, null, 2));
    fs.writeFileSync(path.join(DIST_DIR, "categories.json"), JSON.stringify(categories, null, 2));
    fs.writeFileSync(path.join(DIST_DIR, "search-index.json"), JSON.stringify(searchIndex, null, 2));
    console.log("Generated dist/index.json");
    console.log("Generated dist/categories.json");
    console.log("Generated dist/search-index.json");
  }

  console.log(`\nFound ${brands.length} brands, ${types.length} types, ${models.length} models`);
  console.log("Build complete!\n");
}

build();
