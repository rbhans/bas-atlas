import fs from "node:fs";
import path from "node:path";
import Ajv2020 from "ajv/dist/2020.js";
import addFormats from "ajv-formats";

const CWD = process.cwd();
const DIST_DIR = path.join(CWD, "dist");
const SCHEMAS_DIR = path.join(CWD, "schemas");

function loadJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function compileSchema(ajv, schemaName) {
  const schema = loadJson(path.join(SCHEMAS_DIR, schemaName));
  return ajv.compile(schema);
}

function ensureValid(validate, value, label, ajv) {
  if (!validate(value)) {
    throw new Error(`${label} invalid: ${ajv.errorsText(validate.errors)}`);
  }
}

function main() {
  const ajv = new Ajv2020({ allErrors: true, strict: false });
  addFormats(ajv);

  const index = loadJson(path.join(DIST_DIR, "index.json"));
  const categories = loadJson(path.join(DIST_DIR, "categories.json"));
  const searchIndex = loadJson(path.join(DIST_DIR, "search-index.json"));

  const validateIndex = compileSchema(ajv, "index.schema.json");
  const validateCategories = compileSchema(ajv, "categories.schema.json");
  const validateSearch = compileSchema(ajv, "search-index.schema.json");
  const validateBrand = compileSchema(ajv, "brand.schema.json");
  const validateType = compileSchema(ajv, "type.schema.json");
  const validateModel = compileSchema(ajv, "model.schema.json");

  ensureValid(validateIndex, index, "dist/index.json", ajv);
  ensureValid(validateCategories, categories, "dist/categories.json", ajv);
  ensureValid(validateSearch, searchIndex, "dist/search-index.json", ajv);

  index.brands.forEach((brand, indexNumber) => {
    ensureValid(validateBrand, brand, `brand[${indexNumber}]`, ajv);
  });

  index.types.forEach((type, indexNumber) => {
    ensureValid(validateType, type, `type[${indexNumber}]`, ajv);
  });

  const brandIds = new Set(index.brands.map((brand) => brand.id));
  const typeIds = new Set(index.types.map((type) => type.id));

  index.models.forEach((model, indexNumber) => {
    ensureValid(validateModel, model, `model[${indexNumber}]`, ajv);

    if (!brandIds.has(model.brand)) {
      throw new Error(`model[${indexNumber}] brand not found: ${model.brand}`);
    }
    if (!typeIds.has(model.type)) {
      throw new Error(`model[${indexNumber}] type not found: ${model.type}`);
    }
  });

  console.log("Validation successful");
}

main();
