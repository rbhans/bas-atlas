import fs from "node:fs";
import path from "node:path";
import { execSync } from "node:child_process";

const CWD = process.cwd();
const DATA_DIR = path.join(CWD, "data");
const CANONICAL_INDEX_PATH = path.join(DATA_DIR, "canonical", "index.json");
const DIST_DIR = path.join(CWD, "dist");
const PACKAGE_JSON_PATH = path.join(CWD, "package.json");

const CLEAN = process.argv.includes("--clean");

function readPackageVersion() {
  try {
    const pkg = JSON.parse(fs.readFileSync(PACKAGE_JSON_PATH, "utf8"));
    return pkg.version || "0.1.0";
  } catch {
    return "0.1.0";
  }
}

function deterministicTimestamp(preferred) {
  const envEpoch = process.env.SOURCE_DATE_EPOCH;
  if (envEpoch && /^\d+$/.test(envEpoch)) {
    return new Date(Number(envEpoch) * 1000).toISOString();
  }

  if (preferred && !Number.isNaN(Date.parse(preferred))) {
    return new Date(preferred).toISOString();
  }

  try {
    const gitEpoch = execSync("git log -1 --format=%ct", {
      cwd: CWD,
      stdio: ["ignore", "pipe", "ignore"],
    })
      .toString("utf8")
      .trim();

    if (/^\d+$/.test(gitEpoch)) {
      return new Date(Number(gitEpoch) * 1000).toISOString();
    }
  } catch {
    // use deterministic fallback
  }

  return "1970-01-01T00:00:00.000Z";
}

function unique(values) {
  return [...new Set(values.filter(Boolean))].sort((a, b) => a.localeCompare(b));
}

function tokenize(value) {
  if (!value) return [];
  return value
    .toString()
    .toLowerCase()
    .split(/\s+/)
    .map((token) => token.trim())
    .filter(Boolean);
}

function readJsonFiles(dir) {
  if (!fs.existsSync(dir)) return [];

  const entries = fs
    .readdirSync(dir, { withFileTypes: true })
    .sort((a, b) => a.name.localeCompare(b.name));

  const files = [];
  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);

    if (entry.isDirectory()) {
      if (entry.name === "canonical") continue;
      files.push(...readJsonFiles(fullPath));
      continue;
    }

    if (entry.name.endsWith(".json")) {
      files.push(fullPath);
    }
  }

  return files.sort((a, b) => a.localeCompare(b));
}

function loadCanonicalData() {
  if (!fs.existsSync(CANONICAL_INDEX_PATH)) {
    return null;
  }
  return JSON.parse(fs.readFileSync(CANONICAL_INDEX_PATH, "utf8"));
}

function loadGranularData() {
  const files = readJsonFiles(DATA_DIR);

  const brands = [];
  const types = [];
  const models = [];

  for (const file of files) {
    const data = JSON.parse(fs.readFileSync(file, "utf8"));
    if (data.brand) {
      brands.push(data.brand);
      continue;
    }
    if (data.type) {
      types.push(data.type);
      continue;
    }
    if (data.model) {
      models.push(data.model);
      continue;
    }
  }

  return {
    version: readPackageVersion(),
    lastUpdated: deterministicTimestamp(),
    totalBrands: brands.length,
    totalTypes: types.length,
    totalModels: models.length,
    brands,
    types,
    models,
  };
}

function normalizeData(inputData) {
  const brands = [...(inputData.brands || [])].sort((a, b) => a.id.localeCompare(b.id));
  const types = [...(inputData.types || [])].sort((a, b) => a.id.localeCompare(b.id));
  const models = [...(inputData.models || [])].sort((a, b) => a.id.localeCompare(b.id));

  return {
    version: inputData.version || readPackageVersion(),
    lastUpdated: deterministicTimestamp(inputData.lastUpdated),
    totalBrands: brands.length,
    totalTypes: types.length,
    totalModels: models.length,
    brands,
    types,
    models,
  };
}

function validateCoreData(data) {
  const brandIds = new Set();
  for (const brand of data.brands) {
    if (!brand.id) throw new Error("Brand missing id");
    if (brandIds.has(brand.id)) throw new Error(`Duplicate brand id: ${brand.id}`);
    brandIds.add(brand.id);
  }

  const typeIds = new Set();
  for (const type of data.types) {
    if (!type.id) throw new Error("Type missing id");
    if (typeIds.has(type.id)) throw new Error(`Duplicate type id: ${type.id}`);
    typeIds.add(type.id);
  }

  const modelIds = new Set();
  for (const model of data.models) {
    if (!model.id) throw new Error("Model missing id");
    if (modelIds.has(model.id)) throw new Error(`Duplicate model id: ${model.id}`);
    modelIds.add(model.id);

    if (!brandIds.has(model.brand)) {
      throw new Error(`Model ${model.id} references missing brand: ${model.brand}`);
    }
    if (!typeIds.has(model.type)) {
      throw new Error(`Model ${model.id} references missing type: ${model.type}`);
    }
  }
}

function buildCategories(data) {
  const brandsById = Object.fromEntries(data.brands.map((brand) => [brand.id, brand]));
  const typesById = Object.fromEntries(data.types.map((type) => [type.id, type]));

  const brandCounts = new Map();
  const typeCounts = new Map();

  for (const model of data.models) {
    brandCounts.set(model.brand, (brandCounts.get(model.brand) || 0) + 1);
    typeCounts.set(model.type, (typeCounts.get(model.type) || 0) + 1);
  }

  const brands = data.brands
    .map((brand) => {
      const brandModels = data.models.filter((model) => model.brand === brand.id);
      const typeMap = new Map();
      for (const model of brandModels) {
        typeMap.set(model.type, (typeMap.get(model.type) || 0) + 1);
      }

      const types = [...typeMap.entries()]
        .map(([typeId, count]) => ({
          id: typeId,
          name: typesById[typeId]?.name || typeId,
          slug: typesById[typeId]?.slug || typeId,
          count,
        }))
        .sort((a, b) => a.name.localeCompare(b.name));

      return {
        id: brand.id,
        name: brand.name,
        slug: brand.slug || brand.id,
        count: brandCounts.get(brand.id) || 0,
        types,
      };
    })
    .sort((a, b) => a.name.localeCompare(b.name));

  const types = data.types
    .map((type) => ({
      id: type.id,
      name: type.name,
      slug: type.slug || type.id,
      count: typeCounts.get(type.id) || 0,
    }))
    .sort((a, b) => a.name.localeCompare(b.name));

  return {
    version: data.version,
    brands,
    types,
  };
}

function buildSearchIndex(data) {
  const brandsById = Object.fromEntries(data.brands.map((brand) => [brand.id, brand]));
  const typesById = Object.fromEntries(data.types.map((type) => [type.id, type]));

  const entries = [];

  for (const brand of data.brands) {
    entries.push({
      id: brand.id,
      type: "brand",
      name: brand.name,
      tokens: unique([...tokenize(brand.id), ...tokenize(brand.name), ...tokenize(brand.slug)]),
    });
  }

  for (const type of data.types) {
    entries.push({
      id: type.id,
      type: "type",
      name: type.name,
      tokens: unique([...tokenize(type.id), ...tokenize(type.name), ...tokenize(type.slug)]),
    });
  }

  for (const model of data.models) {
    const brand = brandsById[model.brand];
    const type = typesById[model.type];

    entries.push({
      id: model.id,
      type: "model",
      name: model.name,
      brand: model.brand,
      model_numbers: model.model_numbers || [],
      tokens: unique([
        ...tokenize(model.id),
        ...tokenize(model.name),
        ...tokenize(model.slug),
        ...(model.model_numbers || []).flatMap((value) => tokenize(value)),
        ...(model.protocols || []).flatMap((value) => tokenize(value)),
        ...(model.aliases?.common || []).flatMap((value) => tokenize(value)),
        ...(model.aliases?.misspellings || []).flatMap((value) => tokenize(value)),
        ...tokenize(brand?.name),
        ...tokenize(type?.name),
      ]),
    });
  }

  return {
    version: data.version,
    entries: entries.sort((a, b) => a.id.localeCompare(b.id)),
  };
}

function writeJson(filePath, value) {
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`, "utf8");
}

function cleanDist() {
  if (fs.existsSync(DIST_DIR)) {
    fs.rmSync(DIST_DIR, { recursive: true, force: true });
  }
  fs.mkdirSync(DIST_DIR, { recursive: true });
}

function ensureDist() {
  if (!fs.existsSync(DIST_DIR)) {
    fs.mkdirSync(DIST_DIR, { recursive: true });
  }
}

function build() {
  if (CLEAN) {
    cleanDist();
  } else {
    ensureDist();
  }

  const canonicalData = loadCanonicalData();
  const sourceData = canonicalData || loadGranularData();
  const data = normalizeData(sourceData);

  validateCoreData(data);

  const categories = buildCategories(data);
  const searchIndex = buildSearchIndex(data);

  writeJson(path.join(DIST_DIR, "index.json"), data);
  writeJson(path.join(DIST_DIR, "categories.json"), categories);
  writeJson(path.join(DIST_DIR, "search-index.json"), searchIndex);

  console.log("Build complete:");
  console.log(`  source: ${canonicalData ? "data/canonical/index.json" : "data/*"}`);
  console.log(`  lastUpdated: ${data.lastUpdated}`);
  console.log(`  brands: ${data.totalBrands}`);
  console.log(`  types: ${data.totalTypes}`);
  console.log(`  models: ${data.totalModels}`);
}

build();
