// Import a combined index.json and generate dist files
import fs from "fs";
import path from "path";

const DIST_DIR = path.join(process.cwd(), "dist");
const inputFile = process.argv[2];

if (!inputFile) {
  console.error("Usage: node scripts/import-combined.mjs <path-to-index.json>");
  process.exit(1);
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

const content = fs.readFileSync(inputFile, "utf-8");
const data = JSON.parse(content);

const { brands, types, models } = data;

const brandsById = Object.fromEntries(brands.map((b) => [b.id, b]));
const typesById = Object.fromEntries(types.map((t) => [t.id, t]));

// Build categories
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

// Build search index
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

// Update data with fresh timestamp
const outputData = {
  ...data,
  lastUpdated: new Date().toISOString(),
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

// Write files
if (!fs.existsSync(DIST_DIR)) {
  fs.mkdirSync(DIST_DIR, { recursive: true });
}

fs.writeFileSync(path.join(DIST_DIR, "index.json"), JSON.stringify(outputData, null, 2));
fs.writeFileSync(path.join(DIST_DIR, "categories.json"), JSON.stringify(categories, null, 2));
fs.writeFileSync(path.join(DIST_DIR, "search-index.json"), JSON.stringify(searchIndex, null, 2));

console.log(`Imported ${brands.length} brands, ${types.length} types, ${models.length} models`);
console.log("Generated dist/index.json");
console.log("Generated dist/categories.json");
console.log("Generated dist/search-index.json");
