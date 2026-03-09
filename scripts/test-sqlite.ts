import * as fs from "fs";
import * as path from "path";
import Database from "better-sqlite3";

const DB_PATH = path.join(process.cwd(), "dist", "bas-atlas.db");

let passed = 0;
let failed = 0;

function assert(condition: boolean, message: string) {
  if (condition) {
    console.log(`  PASS: ${message}`);
    passed++;
  } else {
    console.error(`  FAIL: ${message}`);
    failed++;
  }
}

function test() {
  console.log("Testing SQLite database...\n");

  // File existence
  assert(fs.existsSync(DB_PATH), "Database file exists");

  const db = new Database(DB_PATH, { readonly: true });
  db.pragma("foreign_keys = ON");

  // --- Table counts ---
  console.log("\nTable counts:");

  const pointCount = (
    db.prepare("SELECT COUNT(*) as c FROM points").get() as { c: number }
  ).c;
  assert(pointCount > 0, `Points: ${pointCount} rows`);

  const equipCount = (
    db.prepare("SELECT COUNT(*) as c FROM equipment").get() as { c: number }
  ).c;
  assert(equipCount > 0, `Equipment: ${equipCount} rows`);

  const brandCount = (
    db.prepare("SELECT COUNT(*) as c FROM brands").get() as { c: number }
  ).c;
  assert(brandCount > 0, `Brands: ${brandCount} rows`);

  const typeCount = (
    db.prepare("SELECT COUNT(*) as c FROM types").get() as { c: number }
  ).c;
  assert(typeCount > 0, `Types: ${typeCount} rows`);

  const modelCount = (
    db.prepare("SELECT COUNT(*) as c FROM models").get() as { c: number }
  ).c;
  assert(modelCount > 0, `Models: ${modelCount} rows`);

  // --- Metadata consistency ---
  console.log("\nMetadata consistency:");

  const metaPoints = (
    db.prepare("SELECT value FROM meta WHERE key = 'totalPoints'").get() as {
      value: string;
    }
  ).value;
  assert(
    Number(metaPoints) === pointCount,
    `Meta totalPoints (${metaPoints}) matches actual (${pointCount})`,
  );

  const metaEquip = (
    db.prepare("SELECT value FROM meta WHERE key = 'totalEquipment'").get() as {
      value: string;
    }
  ).value;
  assert(
    Number(metaEquip) === equipCount,
    `Meta totalEquipment (${metaEquip}) matches actual (${equipCount})`,
  );

  // --- Relationship integrity ---
  console.log("\nRelationship integrity:");

  const typicalPointCount = (
    db
      .prepare("SELECT COUNT(*) as c FROM equipment_typical_points")
      .get() as { c: number }
  ).c;
  assert(
    typicalPointCount > 0,
    `Equipment-Point links: ${typicalPointCount} rows`,
  );

  // All equipment_typical_points reference valid points
  const orphanEquipPoints = (
    db
      .prepare(
        `SELECT COUNT(*) as c FROM equipment_typical_points etp
       WHERE NOT EXISTS (SELECT 1 FROM points p WHERE p.id = etp.point_id)`,
      )
      .get() as { c: number }
  ).c;
  assert(
    orphanEquipPoints === 0,
    `No orphan equipment→point references (${orphanEquipPoints} found)`,
  );

  // All equipment_typical_points reference valid equipment
  const orphanPointEquip = (
    db
      .prepare(
        `SELECT COUNT(*) as c FROM equipment_typical_points etp
       WHERE NOT EXISTS (SELECT 1 FROM equipment e WHERE e.id = etp.equipment_id)`,
      )
      .get() as { c: number }
  ).c;
  assert(
    orphanPointEquip === 0,
    `No orphan point→equipment references (${orphanPointEquip} found)`,
  );

  // All models reference valid brands
  const orphanModelBrands = (
    db
      .prepare(
        `SELECT COUNT(*) as c FROM models m
       WHERE NOT EXISTS (SELECT 1 FROM brands b WHERE b.id = m.brand_id)`,
      )
      .get() as { c: number }
  ).c;
  assert(
    orphanModelBrands === 0,
    `No orphan model→brand references (${orphanModelBrands} found)`,
  );

  // All models reference valid types
  const orphanModelTypes = (
    db
      .prepare(
        `SELECT COUNT(*) as c FROM models m
       WHERE NOT EXISTS (SELECT 1 FROM types t WHERE t.id = m.type_id)`,
      )
      .get() as { c: number }
  ).c;
  assert(
    orphanModelTypes === 0,
    `No orphan model→type references (${orphanModelTypes} found)`,
  );

  // --- FTS search ---
  console.log("\nFTS search:");

  const ftsCount = (
    db.prepare("SELECT COUNT(*) as c FROM search_index").get() as { c: number }
  ).c;
  assert(ftsCount > 0, `Search index: ${ftsCount} entries`);

  const searchResult = db
    .prepare(
      `SELECT entry_id, entry_type, name FROM search_index WHERE search_index MATCH 'temperature' LIMIT 5`,
    )
    .all() as Array<{ entry_id: string; entry_type: string; name: string }>;
  assert(
    searchResult.length > 0,
    `FTS search for 'temperature' returns ${searchResult.length} results`,
  );

  // --- Sample relationship queries ---
  console.log("\nSample queries:");

  // Points for an AHU
  const ahuPoints = db
    .prepare(
      `SELECT p.name FROM points p
     JOIN equipment_typical_points etp ON p.id = etp.point_id
     WHERE etp.equipment_id = 'air-handling-unit'
     LIMIT 5`,
    )
    .all() as Array<{ name: string }>;
  if (ahuPoints.length > 0) {
    assert(true, `AHU has ${ahuPoints.length}+ typical points`);
  } else {
    // AHU may not exist in data, skip gracefully
    console.log("  SKIP: No air-handling-unit found (may not exist in data)");
  }

  // Equipment that uses a temperature point
  const tempEquip = db
    .prepare(
      `SELECT DISTINCT e.name FROM equipment e
     JOIN equipment_typical_points etp ON e.id = etp.equipment_id
     JOIN points p ON p.id = etp.point_id
     WHERE p.category = 'temperatures'
     LIMIT 5`,
    )
    .all() as Array<{ name: string }>;
  assert(
    tempEquip.length > 0,
    `${tempEquip.length} equipment types use temperature points`,
  );

  // Models by brand (cross-table join)
  const brandModels = db
    .prepare(
      `SELECT b.name as brand, m.name as model FROM models m
     JOIN brands b ON m.brand_id = b.id
     LIMIT 5`,
    )
    .all() as Array<{ brand: string; model: string }>;
  assert(
    brandModels.length > 0,
    `Brand→Model join works (${brandModels.length} results)`,
  );

  // --- JSON output comparison ---
  console.log("\nJSON parity check:");

  const atlasPath = path.join(process.cwd(), "dist", "atlas", "index.json");
  if (fs.existsSync(atlasPath)) {
    const atlas = JSON.parse(fs.readFileSync(atlasPath, "utf-8")) as {
      totalPoints: number;
      totalEquipment: number;
    };
    assert(
      pointCount === atlas.totalPoints,
      `Point count matches JSON (${pointCount} = ${atlas.totalPoints})`,
    );
    assert(
      equipCount === atlas.totalEquipment,
      `Equipment count matches JSON (${equipCount} = ${atlas.totalEquipment})`,
    );
  } else {
    console.log("  SKIP: dist/atlas/index.json not found for comparison");
  }

  const catalogPath = path.join(
    process.cwd(),
    "dist",
    "catalog",
    "index.json",
  );
  if (fs.existsSync(catalogPath)) {
    const catalog = JSON.parse(fs.readFileSync(catalogPath, "utf-8")) as {
      totalBrands: number;
      totalTypes: number;
      totalModels: number;
    };
    assert(
      brandCount === catalog.totalBrands,
      `Brand count matches JSON (${brandCount} = ${catalog.totalBrands})`,
    );
    assert(
      typeCount === catalog.totalTypes,
      `Type count matches JSON (${typeCount} = ${catalog.totalTypes})`,
    );
    assert(
      modelCount === catalog.totalModels,
      `Model count matches JSON (${modelCount} = ${catalog.totalModels})`,
    );
  } else {
    console.log("  SKIP: dist/catalog/index.json not found for comparison");
  }

  db.close();

  // --- Summary ---
  console.log(`\n${passed} passed, ${failed} failed`);
  if (failed > 0) {
    process.exit(1);
  }
}

try {
  test();
} catch (error) {
  console.error(error);
  process.exit(1);
}
