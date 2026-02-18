import fs from "node:fs";
import path from "node:path";
import assert from "node:assert/strict";
import crypto from "node:crypto";
import { spawnSync } from "node:child_process";

const CWD = process.cwd();
const DIST_DIR = path.join(CWD, "dist");
const CANONICAL_SOURCE = path.join(CWD, "data", "canonical", "index.json");

function loadJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

function assertHasKeys(target, keys, label) {
  for (const key of keys) {
    assert.ok(key in target, `${label} missing key: ${key}`);
  }
}

function hashDistFiles() {
  const files = fs
    .readdirSync(DIST_DIR)
    .filter((file) => file.endsWith(".json"))
    .sort((a, b) => a.localeCompare(b));

  const hashMap = {};
  for (const file of files) {
    const hash = crypto
      .createHash("sha256")
      .update(fs.readFileSync(path.join(DIST_DIR, file)))
      .digest("hex");
    hashMap[file] = hash;
  }
  return hashMap;
}

function runBuild(args = []) {
  const result = spawnSync(process.execPath, ["scripts/build.mjs", ...args], {
    cwd: CWD,
    stdio: "inherit",
  });

  if (result.status !== 0) {
    throw new Error(`build failed: ${args.join(" ")}`);
  }
}

function testContractCompatibility() {
  const baseline = loadJson(path.join(CWD, "tests", "fixtures", "contract-baseline.json"));
  const index = loadJson(path.join(DIST_DIR, "index.json"));
  const categories = loadJson(path.join(DIST_DIR, "categories.json"));
  const searchIndex = loadJson(path.join(DIST_DIR, "search-index.json"));

  assertHasKeys(index, baseline.indexTopKeys, "index");
  assert.ok(index.brands.length > 0, "brands must not be empty");
  assert.ok(index.types.length > 0, "types must not be empty");
  assert.ok(index.models.length > 0, "models must not be empty");

  assertHasKeys(index.brands[0], baseline.brandKeys, "brand");
  assertHasKeys(index.types[0], baseline.typeKeys, "type");
  assertHasKeys(index.models[0], baseline.modelKeys, "model");

  assertHasKeys(categories, baseline.categoriesTopKeys, "categories");
  assertHasKeys(searchIndex, baseline.searchTopKeys, "search-index");
  assertHasKeys(searchIndex.entries[0], baseline.searchEntryKeys, "search entry");
}

function testCanonicalParity() {
  const canonical = loadJson(CANONICAL_SOURCE);
  const built = loadJson(path.join(DIST_DIR, "index.json"));

  assert.equal(built.totalBrands, canonical.brands.length, "brand count mismatch against canonical source");
  assert.equal(built.totalTypes, canonical.types.length, "type count mismatch against canonical source");
  assert.equal(built.totalModels, canonical.models.length, "model count mismatch against canonical source");
}

function testDeterministicBuild() {
  runBuild(["--clean"]);
  const firstHash = hashDistFiles();

  runBuild();
  const secondHash = hashDistFiles();

  assert.deepEqual(secondHash, firstHash, "dist artifacts are not deterministic");
}

function main() {
  testContractCompatibility();
  testCanonicalParity();
  testDeterministicBuild();
  console.log("All tests passed");
}

main();
