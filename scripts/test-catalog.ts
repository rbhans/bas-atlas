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

interface CatalogModel {
  id: string;
  brand: string;
  type: string;
  name: string;
}

interface CatalogIndexData {
  totalBrands: number;
  totalTypes: number;
  totalModels: number;
  brands: CatalogBrand[];
  types: CatalogType[];
  models: CatalogModel[];
}

interface BrandCategoryType {
  id: string;
  name: string;
  slug: string;
  count: number;
}

interface BrandCategory {
  id: string;
  name: string;
  slug: string;
  count: number;
  types: BrandCategoryType[];
}

interface TypeCategory {
  id: string;
  name: string;
  slug: string;
  count: number;
}

interface CatalogCategoriesData {
  brands: BrandCategory[];
  types: TypeCategory[];
}

interface CatalogSearchEntry {
  id: string;
  type: "brand" | "type" | "model";
  name: string;
  tokens: string[];
}

interface CatalogSearchData {
  entries: CatalogSearchEntry[];
}

const DIST_DIR = path.join(process.cwd(), "dist", "catalog");

let passed = 0;
let failed = 0;

function assert(condition: boolean, message: string): void {
  if (condition) {
    passed++;
    console.log(`  PASS: ${message}`);
  } else {
    failed++;
    console.error(`  FAIL: ${message}`);
  }
}

function readJson<T>(fileName: string): T {
  const fullPath = path.join(DIST_DIR, fileName);
  return JSON.parse(fs.readFileSync(fullPath, "utf-8")) as T;
}

function testIndexIntegrity(data: CatalogIndexData): void {
  console.log("\n--- Index integrity ---");

  assert(data.brands.length === data.totalBrands, "totalBrands matches brands length");
  assert(data.types.length === data.totalTypes, "totalTypes matches types length");
  assert(data.models.length === data.totalModels, "totalModels matches models length");

  const brandIds = new Set<string>();
  for (const brand of data.brands) {
    brandIds.add(brand.id);
  }
  assert(brandIds.size === data.brands.length, "brand IDs are unique");

  const typeIds = new Set<string>();
  for (const type of data.types) {
    typeIds.add(type.id);
  }
  assert(typeIds.size === data.types.length, "type IDs are unique");

  const modelIds = new Set<string>();
  for (const model of data.models) {
    modelIds.add(model.id);
  }
  assert(modelIds.size === data.models.length, "model IDs are unique");

  const allRefsValid = data.models.every((model) => brandIds.has(model.brand) && typeIds.has(model.type));
  assert(allRefsValid, "all models reference existing brand and type IDs");
}

function testCategories(data: CatalogIndexData, categories: CatalogCategoriesData): void {
  console.log("\n--- Category structure ---");

  assert(categories.brands.length === data.totalBrands, "brand categories count matches total brands");
  assert(categories.types.length === data.totalTypes, "type categories count matches total types");

  const modelCountByBrand = new Map<string, number>();
  const modelCountByType = new Map<string, number>();

  for (const model of data.models) {
    modelCountByBrand.set(model.brand, (modelCountByBrand.get(model.brand) || 0) + 1);
    modelCountByType.set(model.type, (modelCountByType.get(model.type) || 0) + 1);
  }

  const brandCountsCorrect = categories.brands.every(
    (brand) => brand.count === (modelCountByBrand.get(brand.id) || 0),
  );
  assert(brandCountsCorrect, "brand category counts match model distribution");

  const typeCountsCorrect = categories.types.every(
    (type) => type.count === (modelCountByType.get(type.id) || 0),
  );
  assert(typeCountsCorrect, "type category counts match model distribution");
}

function testSearchIndex(data: CatalogIndexData, search: CatalogSearchData): void {
  console.log("\n--- Search index ---");

  const expectedEntries = data.totalBrands + data.totalTypes + data.totalModels;
  assert(search.entries.length === expectedEntries, "search entries cover all brands/types/models");

  const uniqueEntryKeys = new Set<string>();
  for (const entry of search.entries) {
    uniqueEntryKeys.add(`${entry.type}:${entry.id}`);
  }
  assert(uniqueEntryKeys.size === search.entries.length, "search entries are unique by type:id");

  const hasValidTokens = search.entries.every(
    (entry) => Array.isArray(entry.tokens) && entry.tokens.length > 0 && entry.tokens.every((token) => token.length > 0),
  );
  assert(hasValidTokens, "every search entry has at least one non-empty token");
}

console.log("Running catalog tests...");

const indexData = readJson<CatalogIndexData>("index.json");
const categoriesData = readJson<CatalogCategoriesData>("categories.json");
const searchData = readJson<CatalogSearchData>("search-index.json");

testIndexIntegrity(indexData);
testCategories(indexData, categoriesData);
testSearchIndex(indexData, searchData);

console.log("\n========================================");
console.log(`Results: ${passed} passed, ${failed} failed`);
console.log("========================================");

if (failed > 0) {
  process.exit(1);
}
