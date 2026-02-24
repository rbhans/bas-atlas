import * as fs from "fs";
import * as path from "path";

interface CatalogBrand {
  id: string;
  name: string;
  slug?: string;
}

interface CatalogType {
  id: string;
  name: string;
  slug?: string;
}

interface CatalogAliases {
  common?: string[];
  misspellings?: string[];
}

interface CatalogModel {
  id: string;
  brand: string;
  type: string;
  name: string;
  slug?: string;
  model_numbers?: string[];
  protocols?: string[];
  aliases?: CatalogAliases;
}

interface CatalogSearchEntry {
  id: string;
  type: "brand" | "type" | "model";
  name: string;
  brand?: string;
  model_numbers?: string[];
  tokens: string[];
}

const DATA_DIR = path.join(process.cwd(), "data", "catalog");
const DIST_DIR = path.join(process.cwd(), "dist", "catalog");
const VALIDATE_ONLY = process.argv.includes("--validate");

function readJsonFiles(dir: string): Array<{ file: string; data: unknown }> {
  const results: Array<{ file: string; data: unknown }> = [];

  if (!fs.existsSync(dir)) {
    return results;
  }

  const items = fs.readdirSync(dir, { withFileTypes: true });

  for (const item of items) {
    const fullPath = path.join(dir, item.name);
    if (item.isDirectory()) {
      results.push(...readJsonFiles(fullPath));
    } else if (item.name.endsWith(".json")) {
      const content = fs.readFileSync(fullPath, "utf-8");
      const parsed = JSON.parse(content) as unknown;
      results.push({ file: fullPath, data: parsed });
    }
  }

  return results;
}

function tokenize(value: unknown): string[] {
  if (!value) {
    return [];
  }

  return value
    .toString()
    .toLowerCase()
    .split(/\s+/)
    .map((token) => token.trim())
    .filter(Boolean);
}

function unique(values: string[]): string[] {
  return Array.from(new Set(values));
}

function build() {
  console.log("Building BAS Atlas catalog data...\n");

  const files = readJsonFiles(DATA_DIR);
  const brands: CatalogBrand[] = [];
  const types: CatalogType[] = [];
  const models: CatalogModel[] = [];

  for (const { file, data } of files) {
    const record = data as {
      brand?: CatalogBrand;
      type?: CatalogType;
      model?: CatalogModel;
    };

    if (record.brand) {
      brands.push(record.brand);
    } else if (record.type) {
      types.push(record.type);
    } else if (record.model) {
      models.push(record.model);
    } else {
      console.warn(`Skipping ${file}: missing brand/type/model root key`);
    }
  }

  const brandIds = new Set<string>();
  for (const brand of brands) {
    if (!brand.id) {
      throw new Error("Brand missing id");
    }
    if (brandIds.has(brand.id)) {
      throw new Error(`Duplicate brand id: ${brand.id}`);
    }
    brandIds.add(brand.id);
  }

  const typeIds = new Set<string>();
  for (const type of types) {
    if (!type.id) {
      throw new Error("Type missing id");
    }
    if (typeIds.has(type.id)) {
      throw new Error(`Duplicate type id: ${type.id}`);
    }
    typeIds.add(type.id);
  }

  const modelIds = new Set<string>();
  const referentialErrors: string[] = [];
  for (const model of models) {
    if (!model.id) {
      throw new Error("Model missing id");
    }
    if (modelIds.has(model.id)) {
      throw new Error(`Duplicate model id: ${model.id}`);
    }
    modelIds.add(model.id);

    if (!brandIds.has(model.brand)) {
      referentialErrors.push(`Model ${model.id} references missing brand: ${model.brand}`);
    }
    if (!typeIds.has(model.type)) {
      referentialErrors.push(`Model ${model.id} references missing type: ${model.type}`);
    }
  }

  if (referentialErrors.length > 0) {
    throw new Error(`Catalog referential integrity failed:\n${referentialErrors.join("\n")}`);
  }

  const brandsById = Object.fromEntries(brands.map((brand) => [brand.id, brand] as const));
  const typesById = Object.fromEntries(types.map((type) => [type.id, type] as const));

  const brandCounts = new Map<string, number>();
  const typeCounts = new Map<string, number>();

  for (const model of models) {
    brandCounts.set(model.brand, (brandCounts.get(model.brand) || 0) + 1);
    typeCounts.set(model.type, (typeCounts.get(model.type) || 0) + 1);
  }

  const brandCategories = brands
    .map((brand) => {
      const modelCount = brandCounts.get(brand.id) || 0;
      const brandModels = models.filter((model) => model.brand === brand.id);
      const typeMap = new Map<string, number>();

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

  const searchEntries: CatalogSearchEntry[] = [];

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

  const indexData = {
    version: "1.0.0",
    lastUpdated: new Date().toISOString(),
    totalBrands: brands.length,
    totalTypes: types.length,
    totalModels: models.length,
    brands,
    types,
    models,
  };

  const categoriesData = {
    version: "1.0.0",
    brands: brandCategories,
    types: typeCategories,
  };

  const searchData = {
    version: "1.0.0",
    entries: searchEntries,
  };

  if (!VALIDATE_ONLY) {
    fs.writeFileSync(path.join(DIST_DIR, "index.json"), JSON.stringify(indexData, null, 2));
    fs.writeFileSync(path.join(DIST_DIR, "categories.json"), JSON.stringify(categoriesData, null, 2));
    fs.writeFileSync(path.join(DIST_DIR, "search-index.json"), JSON.stringify(searchData, null, 2));
    console.log("Generated dist/catalog/index.json");
    console.log("Generated dist/catalog/categories.json");
    console.log("Generated dist/catalog/search-index.json");
  }

  console.log(`\nFound ${brands.length} brands, ${types.length} types, ${models.length} models`);
  console.log("Build complete!\n");
}

try {
  build();
} catch (error) {
  console.error(error);
  process.exit(1);
}
