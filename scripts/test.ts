import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";
import { spawnSync } from "node:child_process";
import assert from "node:assert/strict";
import {
  normalizePointName,
  relatedPoints,
  traverseGraph,
  validatePointList,
  type BabelData,
  type GraphData,
  type TemplatesData,
} from "../src/core.ts";

const CWD = process.cwd();
const DIST_DIR = path.join(CWD, "dist");

function loadJson<T>(filePath: string): T {
  return JSON.parse(fs.readFileSync(filePath, "utf8")) as T;
}

function assertHasKeys(target: Record<string, unknown>, keys: string[], label: string): void {
  keys.forEach((key) => {
    assert.ok(key in target, `${label} must include key: ${key}`);
  });
}

function hashFile(filePath: string): string {
  return crypto
    .createHash("sha256")
    .update(fs.readFileSync(filePath))
    .digest("hex");
}

function distManifestHashes(): Record<string, string> {
  const files = fs
    .readdirSync(DIST_DIR)
    .filter((file) => file.endsWith(".json"))
    .sort((a, b) => a.localeCompare(b));

  const hashMap: Record<string, string> = {};
  for (const file of files) {
    hashMap[file] = hashFile(path.join(DIST_DIR, file));
  }
  return hashMap;
}

function runBuild(args: string[]): void {
  const result = spawnSync(process.execPath, ["--import", "tsx", "scripts/build.ts", ...args], {
    cwd: CWD,
    stdio: "inherit",
  });

  if (result.status !== 0) {
    throw new Error(`build failed with args: ${args.join(" ")}`);
  }
}

function testContractCompatibility(): void {
  const baseline = loadJson<{
    indexTopKeys: string[];
    pointEntryKeys: string[];
    pointConceptLegacyKeys: string[];
    equipmentLegacyKeys: string[];
    searchIndexTopKeys: string[];
    searchEntryLegacyKeys: string[];
    categoriesTopKeys: string[];
  }>(path.join(CWD, "tests", "fixtures", "contract-baseline.json"));

  const index = loadJson<BabelData>(path.join(DIST_DIR, "index.json"));
  const categories = loadJson<Record<string, unknown>>(path.join(DIST_DIR, "categories.json"));
  const searchIndex = loadJson<{ entries: Array<Record<string, unknown>> } & Record<string, unknown>>(
    path.join(DIST_DIR, "search-index.json"),
  );

  assertHasKeys(index as unknown as Record<string, unknown>, baseline.indexTopKeys, "index");
  assert.ok(index.points.length > 0, "index.points must not be empty");
  assert.ok(index.equipment.length > 0, "index.equipment must not be empty");

  assertHasKeys(index.points[0] as unknown as Record<string, unknown>, baseline.pointEntryKeys, "point");
  assertHasKeys(
    index.points[0].concept as unknown as Record<string, unknown>,
    baseline.pointConceptLegacyKeys,
    "point.concept",
  );
  assertHasKeys(
    index.equipment[0] as unknown as Record<string, unknown>,
    baseline.equipmentLegacyKeys,
    "equipment",
  );

  assertHasKeys(categories, baseline.categoriesTopKeys, "categories");
  assertHasKeys(searchIndex, baseline.searchIndexTopKeys, "search-index");
  assertHasKeys(searchIndex.entries[0], baseline.searchEntryLegacyKeys, "search-index entry");
}

function testNormalizerCases(): void {
  const index = loadJson<BabelData>(path.join(DIST_DIR, "index.json"));
  const cases = loadJson<Array<{ input: string; expectedId: string; minConfidence: number }>>(
    path.join(CWD, "tests", "fixtures", "normalization-cases.json"),
  );

  assert.ok(cases.length >= 30, "normalization fixture must include at least 30 cases");

  for (const testCase of cases) {
    const result = normalizePointName(testCase.input, index);
    assert.equal(result.matchedConceptId, testCase.expectedId, `normalizer mismatch for input: ${testCase.input}`);
    assert.ok(
      result.confidence >= testCase.minConfidence,
      `normalizer confidence too low for ${testCase.input}: ${result.confidence}`,
    );
  }
}

function testDeterministicBuild(): void {
  runBuild(["--clean"]);
  const firstManifest = distManifestHashes();

  runBuild([]);
  const secondManifest = distManifestHashes();

  assert.deepEqual(secondManifest, firstManifest, "dist files are not deterministic across builds");
}

function testTemplateAndGraphIntegrity(): void {
  const index = loadJson<BabelData>(path.join(DIST_DIR, "index.json"));
  const templates = loadJson<TemplatesData>(path.join(DIST_DIR, "templates.json"));
  const graph = loadJson<GraphData>(path.join(DIST_DIR, "graph.json"));

  const pointIds = new Set(index.points.map((point) => point.concept.id));
  const equipmentIds = new Set(index.equipment.map((entry) => entry.id));

  assert.ok(templates.templates.length >= 5, "templates dataset must include at least 5 templates");

  for (const template of templates.templates) {
    assert.ok(equipmentIds.has(template.equipmentTypeId), `unknown equipmentTypeId in template ${template.id}`);

    for (const pointId of [
      ...template.requiredPoints,
      ...template.optionalPoints,
      ...template.recommendedPoints,
    ]) {
      assert.ok(pointIds.has(pointId), `unknown pointId ${pointId} in template ${template.id}`);
    }
  }

  const outbound = relatedPoints(graph, "ahu-v1");
  assert.ok(outbound.length > 0, "template node should have graph edges");

  const traversed = traverseGraph(graph, "ahu-v1", { depth: 2 });
  assert.ok(traversed.length > 0, "graph traversal should return related nodes");
}

function testValidatorOutput(): void {
  const index = loadJson<BabelData>(path.join(DIST_DIR, "index.json"));
  const templates = loadJson<TemplatesData>(path.join(DIST_DIR, "templates.json"));

  const result = validatePointList(
    "ahu",
    [
      "supply fan command",
      "supply fan status",
      "supply air temperature",
      "return air temperature",
      "outside air damper output",
      "cooling valve output",
      "random-unmapped-point",
    ],
    index,
    templates,
  );

  assert.ok(Array.isArray(result.matched), "validator matched list missing");
  assert.ok(Array.isArray(result.missingRequired), "validator missingRequired list missing");
  assert.ok(Array.isArray(result.missingRecommended), "validator missingRecommended list missing");
  assert.ok(Array.isArray(result.unknown), "validator unknown list missing");
  assert.ok(Array.isArray(result.suggestions), "validator suggestions list missing");
  assert.ok(result.unknown.includes("random-unmapped-point"), "validator should report unknown input");
}

async function main(): Promise<void> {
  testContractCompatibility();
  testNormalizerCases();
  testTemplateAndGraphIntegrity();
  testValidatorOutput();
  testDeterministicBuild();
  console.log("All tests passed");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
