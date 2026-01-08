import * as fs from "fs";
import * as path from "path";
import { stringify as stringifyYaml } from "yaml";
import type { PointYamlFile, EquipmentYamlFile, EquipmentEntry, EquipmentSubtype } from "./types.js";

const CSV_PATH = path.join(process.cwd(), "haystack naming - Sheet1.csv");
const DATA_DIR = path.join(process.cwd(), "data");

// Map CSV categories to our structure
const categoryMapping: Record<string, { type: "point" | "equipment"; category: string; subcategory?: string }> = {
  Meters: { type: "equipment", category: "metering" },
  AHUs: { type: "equipment", category: "air-handling" },
  VAVs: { type: "equipment", category: "terminal-units" },
  Plants: { type: "equipment", category: "central-plant" },
  Motors: { type: "equipment", category: "motors" },
  VRF: { type: "equipment", category: "vrf" },
  Points: { type: "point", category: "general" },
};

// Map point names to subcategories
function getPointSubcategory(name: string): string {
  const lowerName = name.toLowerCase();

  // Fan points
  if (lowerName.includes("fan")) return "fans";

  // Damper points
  if (lowerName.includes("damper")) return "dampers";

  // Valve points
  if (lowerName.includes("valve") || lowerName.includes("vlv")) return "valves";

  // Temperature points
  if (lowerName.includes("temperature") || lowerName.includes("temp") || lowerName.endsWith("-t")) return "temperatures";

  // Pressure points
  if (lowerName.includes("pressure") || lowerName.includes("press")) return "pressures";

  // Setpoint points
  if (lowerName.includes("setpoint") || lowerName.includes("stpt") || lowerName.endsWith("-sp")) return "setpoints";

  // Flow points
  if (lowerName.includes("flow")) return "flows";

  // Humidity points
  if (lowerName.includes("humid") || lowerName.includes("hum")) return "humidity";

  // Alarm points
  if (lowerName.includes("alarm") || lowerName.includes("alm")) return "alarms";

  // Status points
  if (lowerName.includes("status") || lowerName.includes("sts") || lowerName.endsWith("-s")) return "status";

  // Command/enable points
  if (
    lowerName.includes("command") ||
    lowerName.includes("cmd") ||
    lowerName.includes("enable") ||
    lowerName.endsWith("-c") ||
    lowerName.endsWith("-en")
  )
    return "commands";

  // Output points
  if (lowerName.includes("output") || lowerName.endsWith("-o")) return "commands";

  // Default
  return "status";
}

// Convert name to slug ID
function toSlug(name: string): string {
  return name
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}

// Parse CSV line (handles quoted fields)
function parseCSVLine(line: string): string[] {
  const result: string[] = [];
  let current = "";
  let inQuotes = false;

  for (let i = 0; i < line.length; i++) {
    const char = line[i];

    if (char === '"') {
      inQuotes = !inQuotes;
    } else if (char === "," && !inQuotes) {
      result.push(current.trim());
      current = "";
    } else {
      current += char;
    }
  }

  result.push(current.trim());
  return result;
}

async function migrate() {
  console.log("Migrating CSV data to YAML...\n");

  if (!fs.existsSync(CSV_PATH)) {
    console.error(`CSV file not found: ${CSV_PATH}`);
    process.exit(1);
  }

  const content = fs.readFileSync(CSV_PATH, "utf-8");
  const lines = content.split("\n").filter((line) => line.trim());

  // Skip header
  const dataLines = lines.slice(1);

  // Group by category
  const pointEntries: Map<string, PointYamlFile[]> = new Map();
  const equipmentEntries: Map<string, EquipmentEntry[]> = new Map();

  for (const line of dataLines) {
    const fields = parseCSVLine(line);
    if (fields.length < 2) continue;

    const [csvCategory, haystackName, ...altNames] = fields;
    const mapping = categoryMapping[csvCategory];

    if (!mapping) {
      console.warn(`Unknown category: ${csvCategory}`);
      continue;
    }

    // Filter out empty alt names
    const aliases = altNames.filter((n) => n && n.trim());

    if (mapping.type === "equipment") {
      // Equipment entry
      const entry: EquipmentEntry = {
        id: toSlug(haystackName),
        name: haystackName,
        full_name: aliases[0] || haystackName,
        category: mapping.category,
        description: `${aliases[0] || haystackName}`,
        aliases: {
          common: aliases.slice(0, 5),
          abbreviated: aliases.slice(5).filter((a) => a.length <= 5),
        },
      };

      if (!equipmentEntries.has(mapping.category)) {
        equipmentEntries.set(mapping.category, []);
      }
      equipmentEntries.get(mapping.category)!.push(entry);
    } else {
      // Point entry
      const subcategory = getPointSubcategory(haystackName);

      const entry: PointYamlFile = {
        concept: {
          id: toSlug(haystackName),
          name: haystackName,
          category: subcategory,
          description: `${haystackName} point`,
          haystack: haystackName.toLowerCase().replace(/-/g, " "),
        },
        aliases: {
          common: aliases.filter((a) => a.length > 3),
          abbreviated: aliases.filter((a) => a.length <= 3),
        },
      };

      if (!pointEntries.has(subcategory)) {
        pointEntries.set(subcategory, []);
      }
      pointEntries.get(subcategory)!.push(entry);
    }
  }

  // Write point YAML files
  console.log("Writing point YAML files...");
  for (const [subcategory, entries] of pointEntries) {
    const dir = path.join(DATA_DIR, "points", subcategory);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }

    for (const entry of entries) {
      const filename = `${entry.concept.id}.yaml`;
      const filepath = path.join(dir, filename);
      fs.writeFileSync(filepath, stringifyYaml(entry));
    }
    console.log(`  ${subcategory}: ${entries.length} files`);
  }

  // Write equipment YAML files
  console.log("\nWriting equipment YAML files...");
  for (const [category, entries] of equipmentEntries) {
    const dir = path.join(DATA_DIR, "equipment");
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }

    // Group related equipment together in one file
    const filename = `${category}.yaml`;
    const filepath = path.join(dir, filename);

    const yamlContent: EquipmentYamlFile = {
      equipment: entries,
    };

    fs.writeFileSync(filepath, stringifyYaml(yamlContent));
    console.log(`  ${category}: ${entries.length} entries`);
  }

  console.log("\nMigration complete!");
}

migrate().catch(console.error);
