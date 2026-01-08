import * as fs from "fs";
import * as path from "path";
import { parse as parseYaml } from "yaml";
import type {
  BabelData,
  CategoriesData,
  SearchIndexData,
  PointEntry,
  EquipmentEntry,
  BabelCategory,
  SearchIndexEntry,
  PointYamlFile,
  EquipmentYamlFile,
} from "./types.js";

const DATA_DIR = path.join(process.cwd(), "data");
const DIST_DIR = path.join(process.cwd(), "dist");

// Read all YAML files from a directory recursively
function readYamlFiles<T>(dir: string): T[] {
  const results: T[] = [];

  if (!fs.existsSync(dir)) {
    return results;
  }

  const items = fs.readdirSync(dir, { withFileTypes: true });

  for (const item of items) {
    const fullPath = path.join(dir, item.name);

    if (item.isDirectory()) {
      results.push(...readYamlFiles<T>(fullPath));
    } else if (item.name.endsWith(".yaml") || item.name.endsWith(".yml")) {
      try {
        const content = fs.readFileSync(fullPath, "utf-8");
        const parsed = parseYaml(content) as T;
        if (parsed) {
          results.push(parsed);
        }
      } catch (error) {
        console.error(`Error parsing ${fullPath}:`, error);
      }
    }
  }

  return results;
}

// Extract all aliases as search tokens
function extractTokens(entry: PointEntry | EquipmentEntry): string[] {
  const tokens: string[] = [];

  if ("concept" in entry) {
    // Point entry
    const point = entry as PointEntry;
    tokens.push(point.concept.name.toLowerCase());
    tokens.push(point.concept.id.toLowerCase());
    if (point.concept.description) {
      tokens.push(...point.concept.description.toLowerCase().split(/\s+/));
    }
    if (point.concept.haystack) {
      tokens.push(...point.concept.haystack.toLowerCase().split(/\s+/));
    }
  } else {
    // Equipment entry
    const equip = entry as EquipmentEntry;
    tokens.push(equip.name.toLowerCase());
    tokens.push(equip.id.toLowerCase());
    if (equip.full_name) {
      tokens.push(equip.full_name.toLowerCase());
    }
    if ((equip as any).abbreviation) {
      tokens.push((equip as any).abbreviation.toLowerCase());
    }
    if (equip.description) {
      tokens.push(...equip.description.toLowerCase().split(/\s+/));
    }
  }

  // Add all aliases
  const aliases = "concept" in entry ? (entry as PointEntry).aliases : (entry as EquipmentEntry).aliases;
  if (aliases) {
    tokens.push(...(aliases.common || []).map((a) => a.toLowerCase()));
    tokens.push(...(aliases.misspellings || []).map((a) => a.toLowerCase()));
  }

  // Deduplicate and filter empty
  return [...new Set(tokens.filter((t) => t.length > 0))];
}

// Build category tree from points
function buildCategoryTree(points: PointEntry[], equipment: EquipmentEntry[]): BabelCategory[] {
  const categories: BabelCategory[] = [];

  // Group points by category
  const pointCategories = new Map<string, PointEntry[]>();
  for (const point of points) {
    const cat = point.concept.category;
    if (!pointCategories.has(cat)) {
      pointCategories.set(cat, []);
    }
    pointCategories.get(cat)!.push(point);
  }

  // Create point categories
  const pointCategoryNames: Record<string, string> = {
    fans: "Fans",
    dampers: "Dampers",
    valves: "Valves",
    temperatures: "Temperatures",
    pressures: "Pressures",
    setpoints: "Setpoints",
    flows: "Flows",
    humidity: "Humidity",
    alarms: "Alarms",
    status: "Status",
    commands: "Commands",
  };

  for (const [catId, catPoints] of pointCategories) {
    categories.push({
      id: catId,
      name: pointCategoryNames[catId] || catId,
      type: "points",
      count: catPoints.length,
    });
  }

  // Group equipment by category
  const equipCategories = new Map<string, EquipmentEntry[]>();
  for (const equip of equipment) {
    const cat = equip.category;
    if (!equipCategories.has(cat)) {
      equipCategories.set(cat, []);
    }
    equipCategories.get(cat)!.push(equip);
  }

  const equipCategoryNames: Record<string, string> = {
    "air-handling": "Air Handling",
    "terminal-units": "Terminal Units",
    "central-plant": "Central Plant",
    metering: "Metering",
    motors: "Motors",
    vrf: "VRF",
  };

  for (const [catId, catEquip] of equipCategories) {
    categories.push({
      id: catId,
      name: equipCategoryNames[catId] || catId,
      type: "equipment",
      count: catEquip.length,
    });
  }

  // Sort categories
  return categories.sort((a, b) => {
    // Equipment first, then points
    if (a.type !== b.type) {
      return a.type === "equipment" ? -1 : 1;
    }
    return a.name.localeCompare(b.name);
  });
}

async function build() {
  console.log("Building BAS Babel data...\n");

  // Read points
  console.log("Reading points...");
  const pointFiles = readYamlFiles<PointYamlFile>(path.join(DATA_DIR, "points"));
  const points: PointEntry[] = pointFiles.map((f) => ({
    concept: f.concept,
    aliases: f.aliases,
    notes: f.notes,
    related: f.related,
  }));
  console.log(`  Found ${points.length} points`);

  // Read equipment
  console.log("Reading equipment...");
  const equipFiles = readYamlFiles<EquipmentYamlFile>(path.join(DATA_DIR, "equipment"));
  const equipment: EquipmentEntry[] = [];
  for (const file of equipFiles) {
    if (Array.isArray(file.equipment)) {
      equipment.push(...file.equipment);
    } else if (file.equipment) {
      equipment.push(file.equipment);
    }
  }
  console.log(`  Found ${equipment.length} equipment entries`);

  // Ensure dist directory exists
  if (!fs.existsSync(DIST_DIR)) {
    fs.mkdirSync(DIST_DIR, { recursive: true });
  }

  // Generate main data file
  const data: BabelData = {
    version: "1.0.0",
    lastUpdated: new Date().toISOString(),
    totalPoints: points.length,
    totalEquipment: equipment.length,
    points,
    equipment,
  };

  fs.writeFileSync(path.join(DIST_DIR, "index.json"), JSON.stringify(data, null, 2));
  console.log("\nGenerated dist/index.json");

  // Generate categories file
  const categories: CategoriesData = {
    version: "1.0.0",
    categories: buildCategoryTree(points, equipment),
  };

  fs.writeFileSync(path.join(DIST_DIR, "categories.json"), JSON.stringify(categories, null, 2));
  console.log("Generated dist/categories.json");

  // Generate search index
  const searchEntries: SearchIndexEntry[] = [];

  for (const point of points) {
    searchEntries.push({
      id: point.concept.id,
      type: "point",
      name: point.concept.name,
      tokens: extractTokens(point),
    });
  }

  for (const equip of equipment) {
    searchEntries.push({
      id: equip.id,
      type: "equipment",
      name: equip.name,
      tokens: extractTokens(equip),
    });
  }

  const searchIndex: SearchIndexData = {
    version: "1.0.0",
    entries: searchEntries,
  };

  fs.writeFileSync(path.join(DIST_DIR, "search-index.json"), JSON.stringify(searchIndex, null, 2));
  console.log("Generated dist/search-index.json");

  console.log("\nBuild complete!");
  console.log(`  Total entries: ${points.length + equipment.length}`);
}

build().catch(console.error);
