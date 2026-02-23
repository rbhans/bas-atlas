import * as fs from "fs";
import * as path from "path";
import type { BabelData, PointEntry, EquipmentEntry } from "./types.js";

const DIST_DIR = path.join(process.cwd(), "dist");

let passed = 0;
let failed = 0;

function assert(condition: boolean, message: string) {
  if (condition) {
    passed++;
    console.log(`  PASS: ${message}`);
  } else {
    failed++;
    console.error(`  FAIL: ${message}`);
  }
}

function loadData(): BabelData {
  const raw = fs.readFileSync(path.join(DIST_DIR, "index.json"), "utf-8");
  return JSON.parse(raw) as BabelData;
}

// --- Tests ---

function testPointHaystackStructure() {
  console.log("\n--- Point haystack structure ---");
  const data = loadData();
  const zt = data.points.find((p) => p.concept.id === "zone-temperature");

  assert(zt !== undefined, "zone-temperature point exists");
  assert(zt!.concept.haystack !== undefined, "haystack field is present");
  assert(typeof zt!.concept.haystack === "object", "haystack is an object (not a string)");
  assert(Array.isArray(zt!.concept.haystack!.tags), "haystack.tags is an array");
  assert(typeof zt!.concept.haystack!.tagString === "string", "haystack.tagString is a string");
  assert(Array.isArray(zt!.concept.haystack!.markers), "haystack.markers is an array");

  const markers = zt!.concept.haystack!.markers;
  assert(markers.includes("zone"), "markers include 'zone'");
  assert(markers.includes("air"), "markers include 'air'");
  assert(markers.includes("temp"), "markers include 'temp'");
  assert(markers.includes("sensor"), "markers include 'sensor'");
  assert(markers.includes("point"), "markers include auto-added 'point'");
  assert(zt!.concept.haystack!.unit === "°F", "unit resolved to Haystack unit");
  assert(zt!.concept.haystack!.kind === "Number", "kind is Number");
}

function testEquipmentHaystackStructure() {
  console.log("\n--- Equipment haystack structure ---");
  const data = loadData();
  const ahu = data.equipment.find((e) => e.id === "air-handling-unit");

  assert(ahu !== undefined, "air-handling-unit equipment exists");
  assert(ahu!.haystack !== undefined, "haystack field is present");
  assert(typeof ahu!.haystack === "object", "haystack is an object");

  const markers = ahu!.haystack!.markers;
  assert(markers.includes("ahu"), "markers include 'ahu'");
  assert(markers.includes("equip"), "markers include auto-added 'equip'");
}

function testHyphenNormalization() {
  console.log("\n--- Hyphen normalization for equipment ---");
  const data = loadData();
  const em = data.equipment.find((e) => e.id === "electric-meter");

  assert(em !== undefined, "electric-meter equipment exists");
  const markers = em!.haystack!.markers;
  assert(markers.includes("elec"), "elec parsed from 'elec-meter'");
  assert(markers.includes("meter"), "meter parsed from 'elec-meter'");
  assert(markers.includes("equip"), "equip auto-added");
  assert(!markers.includes("elec-meter"), "hyphenated form not in markers");
}

function testPointMarkerAutoAdded() {
  console.log("\n--- Point marker auto-added ---");
  const data = loadData();
  const pointsWithHaystack = data.points.filter((p) => p.concept.haystack);
  const allHavePoint = pointsWithHaystack.every((p) =>
    p.concept.haystack!.markers.includes("point"),
  );
  assert(allHavePoint, `all ${pointsWithHaystack.length} points with haystack have 'point' marker`);
}

function testEquipMarkerAutoAdded() {
  console.log("\n--- Equip marker auto-added ---");
  const data = loadData();
  const equipWithHaystack = data.equipment.filter((e) => e.haystack);
  const allHaveEquip = equipWithHaystack.every((e) =>
    e.haystack!.markers.includes("equip"),
  );
  assert(allHaveEquip, `all ${equipWithHaystack.length} equipment with haystack have 'equip' marker`);
}

function testNoDuplicateEntityMarkers() {
  console.log("\n--- No duplicate entity markers ---");
  const data = loadData();

  // Check equipment that already had "equip" in their YAML string
  const exhaust = data.equipment.find((e) => e.id === "exhaust-fan");
  assert(exhaust !== undefined, "exhaust-fan exists");
  const equipCount = exhaust!.haystack!.markers.filter((m) => m === "equip").length;
  assert(equipCount === 1, `equip marker appears exactly once (found ${equipCount})`);
}

function testTagsHaveValidKind() {
  console.log("\n--- All tags have valid kind ---");
  const data = loadData();
  const validKinds = new Set(["Marker", "Str", "Number", "Bool", "Ref"]);

  let allValid = true;
  for (const point of data.points) {
    if (!point.concept.haystack) continue;
    for (const tag of point.concept.haystack.tags) {
      if (!validKinds.has(tag.kind)) {
        allValid = false;
        console.error(`    Invalid kind "${tag.kind}" on tag "${tag.name}" in point ${point.concept.id}`);
      }
    }
  }
  for (const equip of data.equipment) {
    if (!equip.haystack) continue;
    for (const tag of equip.haystack.tags) {
      if (!validKinds.has(tag.kind)) {
        allValid = false;
        console.error(`    Invalid kind "${tag.kind}" on tag "${tag.name}" in equipment ${equip.id}`);
      }
    }
  }
  assert(allValid, "all tags across all entries have valid kind values");
}

function testAllEntriesHaveHaystack() {
  console.log("\n--- Coverage check ---");
  const data = loadData();
  const pointsWithHs = data.points.filter((p) => p.concept.haystack);
  const equipWithHs = data.equipment.filter((e) => e.haystack);

  assert(
    pointsWithHs.length === data.points.length,
    `${pointsWithHs.length}/${data.points.length} points have haystack data`,
  );
  assert(
    equipWithHs.length === data.equipment.length,
    `${equipWithHs.length}/${data.equipment.length} equipment have haystack data`,
  );
}

function testBoolPointHasNoUnit() {
  console.log("\n--- Bool points have no haystack unit ---");
  const data = loadData();
  const occ = data.points.find((p) => p.concept.id === "occupancy");
  assert(occ !== undefined, "occupancy point exists");
  assert(occ!.concept.haystack!.kind === "Bool", "occupancy kind is Bool");
  assert(occ!.concept.haystack!.unit === undefined, "occupancy has no haystack unit");
}

function testTagStringMatchesTags() {
  console.log("\n--- tagString is consistent with tags ---");
  const data = loadData();
  let allMatch = true;

  for (const point of data.points) {
    if (!point.concept.haystack) continue;
    const expected = point.concept.haystack.tags.map((t) => t.name).join(" ");
    if (point.concept.haystack.tagString !== expected) {
      allMatch = false;
      console.error(`    Mismatch for ${point.concept.id}: tagString="${point.concept.haystack.tagString}" expected="${expected}"`);
    }
  }
  for (const equip of data.equipment) {
    if (!equip.haystack) continue;
    const expected = equip.haystack.tags.map((t) => t.name).join(" ");
    if (equip.haystack.tagString !== expected) {
      allMatch = false;
      console.error(`    Mismatch for ${equip.id}: tagString="${equip.haystack.tagString}" expected="${expected}"`);
    }
  }
  assert(allMatch, "tagString matches tags array for all entries");
}

// --- Run all tests ---

console.log("Running Haystack compliance tests...");

testPointHaystackStructure();
testEquipmentHaystackStructure();
testHyphenNormalization();
testPointMarkerAutoAdded();
testEquipMarkerAutoAdded();
testNoDuplicateEntityMarkers();
testTagsHaveValidKind();
testAllEntriesHaveHaystack();
testBoolPointHasNoUnit();
testTagStringMatchesTags();

console.log(`\n========================================`);
console.log(`Results: ${passed} passed, ${failed} failed`);
console.log(`========================================`);

if (failed > 0) {
  process.exit(1);
}
