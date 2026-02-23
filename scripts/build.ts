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
  PointConceptYaml,
  EquipmentEntryYaml,
  PointHaystackData,
  EquipmentHaystackData,
  HaystackTag,
  HaystackTagKind,
  TagDictEntry,
  UnitMapEntry,
} from "./types.js";

const DATA_DIR = path.join(process.cwd(), "data");
const DIST_DIR = path.join(process.cwd(), "dist");
const ALLOWED_POINT_KINDS = new Set(["Number", "Bool"]);

// --- Tag dictionary & unit mapping ---

interface TagDict {
  [tagName: string]: TagDictEntry;
}

interface UnitMap {
  [symbol: string]: UnitMapEntry;
}

function loadTagDict(): TagDict {
  const filePath = path.join(DATA_DIR, "haystack-tags.yaml");
  const raw = parseYaml(fs.readFileSync(filePath, "utf-8")) as {
    tags: Record<string, TagDictEntry>;
  };
  return raw.tags;
}

function loadUnitMap(): UnitMap {
  const filePath = path.join(DATA_DIR, "haystack-units.yaml");
  const raw = parseYaml(fs.readFileSync(filePath, "utf-8")) as {
    units: Record<string, UnitMapEntry>;
  };
  return raw.units;
}

// --- Haystack string parsing ---

function parseHaystackString(
  raw: string,
  entityType: "point" | "equip",
  tagDict: TagDict,
  unitMap: UnitMap,
  units?: string[],
  kind?: "Number" | "Bool",
): PointHaystackData | EquipmentHaystackData {
  // Split on whitespace; normalize hyphens to spaces for equipment like "elec-meter"
  const normalized = raw.trim().replace(/-/g, " ");
  const tokens = normalized.split(/\s+/).filter(Boolean);

  // Resolve each token against the dictionary
  const tags: HaystackTag[] = tokens.map((token) => ({
    name: token,
    kind: (tagDict[token]?.kind ?? "Marker") as HaystackTagKind,
  }));

  // Add entity type marker if not already present
  const tagNames = new Set(tags.map((t) => t.name));
  if (entityType === "point" && !tagNames.has("point")) {
    tags.push({ name: "point", kind: "Marker" });
  }
  if (entityType === "equip" && !tagNames.has("equip")) {
    tags.push({ name: "equip", kind: "Marker" });
  }

  const markers = tags.filter((t) => t.kind === "Marker").map((t) => t.name);
  const tagString = tags.map((t) => t.name).join(" ");

  if (entityType === "point") {
    const result: PointHaystackData = { tags, tagString, markers };

    // Resolve first mappable unit from the list
    if (units && units.length > 0) {
      for (const u of units) {
        const mapped = unitMap[u];
        if (mapped) {
          result.unit = mapped.haystack;
          break;
        }
      }
    }

    if (kind) {
      result.kind = kind;
    }

    return result;
  }

  return { tags, tagString, markers } as EquipmentHaystackData;
}

// --- Kind inference ---

function hasUnits(unit: unknown): boolean {
  if (Array.isArray(unit)) return unit.length > 0;
  return typeof unit === "string" && unit.trim().length > 0;
}

function hasBinaryStates(states: unknown): boolean {
  if (!states || typeof states !== "object") return false;
  const stateMap = states as Record<string, unknown>;
  return Object.prototype.hasOwnProperty.call(stateMap, "0")
    && Object.prototype.hasOwnProperty.call(stateMap, "1");
}

function inferPointKind(point: PointConceptYaml): "Number" | "Bool" {
  if (hasUnits(point.unit)) return "Number";
  if (hasBinaryStates(point.states)) return "Bool";

  const fn = point.point_function;
  if (fn === "alarm" || fn === "status" || fn === "enable" || fn === "schedule") {
    return "Bool";
  }

  return "Bool";
}

// --- Validation ---

function validatePointKinds(points: PointEntry[]) {
  const missing: string[] = [];
  const invalid: string[] = [];

  for (const point of points) {
    const id = point.concept.id || "<unknown>";
    const kind = point.concept.kind;
    if (!kind) {
      missing.push(id);
      continue;
    }

    if (!ALLOWED_POINT_KINDS.has(kind)) {
      invalid.push(`${id}:${kind}`);
    }
  }

  if (missing.length || invalid.length) {
    const details = [
      missing.length ? `missing kind (${missing.length}): ${missing.slice(0, 10).join(", ")}` : "",
      invalid.length ? `invalid kind (${invalid.length}): ${invalid.slice(0, 10).join(", ")}` : "",
    ]
      .filter(Boolean)
      .join(" | ");
    throw new Error(`Point kind validation failed: ${details}`);
  }
}

function validateHaystackTags(
  points: PointEntry[],
  equipment: EquipmentEntry[],
  tagDict: TagDict,
) {
  const errors: string[] = [];
  const warnings: string[] = [];

  for (const point of points) {
    const hs = point.concept.haystack;
    if (!hs) {
      warnings.push(`Point ${point.concept.id}: missing haystack data`);
      continue;
    }

    for (const tag of hs.tags) {
      if (!tagDict[tag.name]) {
        errors.push(`Point ${point.concept.id}: unknown tag "${tag.name}"`);
      }
    }

    // Cross-check point_function with haystack function tags
    const fn = point.concept.point_function;
    const tagNames = new Set(hs.markers);
    if (fn === "sensor" && !tagNames.has("sensor")) {
      warnings.push(`Point ${point.concept.id}: point_function is "sensor" but haystack lacks "sensor" tag`);
    }
    if (fn === "command" && !tagNames.has("cmd")) {
      warnings.push(`Point ${point.concept.id}: point_function is "command" but haystack lacks "cmd" tag`);
    }
    if (fn === "setpoint" && !tagNames.has("sp")) {
      warnings.push(`Point ${point.concept.id}: point_function is "setpoint" but haystack lacks "sp" tag`);
    }

    // Warn on Number points with units but no resolved haystack unit
    if (hs.kind === "Number" && point.concept.unit && point.concept.unit.length > 0 && !hs.unit) {
      warnings.push(`Point ${point.concept.id}: has units [${point.concept.unit.join(", ")}] but none map to a Haystack unit`);
    }
  }

  for (const equip of equipment) {
    const hs = equip.haystack;
    if (!hs) {
      warnings.push(`Equipment ${equip.id}: missing haystack data`);
      continue;
    }

    for (const tag of hs.tags) {
      if (!tagDict[tag.name]) {
        errors.push(`Equipment ${equip.id}: unknown tag "${tag.name}"`);
      }
    }
  }

  if (warnings.length) {
    console.warn(`\nHaystack warnings (${warnings.length}):`);
    warnings.forEach((w) => console.warn(`  WARN: ${w}`));
  }

  if (errors.length) {
    console.error(`\nHaystack errors (${errors.length}):`);
    errors.slice(0, 20).forEach((e) => console.error(`  ERROR: ${e}`));
    if (errors.length > 20) {
      console.error(`  ... and ${errors.length - 20} more`);
    }
    throw new Error(`Haystack validation failed with ${errors.length} errors`);
  }
}

// --- File reading ---

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

// --- Search token extraction ---

function extractTokens(entry: PointEntry | EquipmentEntry): string[] {
  const tokens: string[] = [];

  if ("concept" in entry) {
    const point = entry as PointEntry;
    tokens.push(point.concept.name.toLowerCase());
    tokens.push(point.concept.id.toLowerCase());
    if (point.concept.description) {
      tokens.push(...point.concept.description.toLowerCase().split(/\s+/));
    }
    if (point.concept.haystack) {
      tokens.push(...point.concept.haystack.markers.map((m) => m.toLowerCase()));
    }
  } else {
    const equip = entry as EquipmentEntry;
    tokens.push(equip.name.toLowerCase());
    tokens.push(equip.id.toLowerCase());
    if (equip.full_name) {
      tokens.push(equip.full_name.toLowerCase());
    }
    if (equip.abbreviation) {
      tokens.push(equip.abbreviation.toLowerCase());
    }
    if (equip.description) {
      tokens.push(...equip.description.toLowerCase().split(/\s+/));
    }
    if (equip.haystack) {
      tokens.push(...equip.haystack.markers.map((m) => m.toLowerCase()));
    }
  }

  const aliases = "concept" in entry ? (entry as PointEntry).aliases : (entry as EquipmentEntry).aliases;
  if (aliases) {
    tokens.push(...(aliases.common || []).map((a) => a.toLowerCase()));
    tokens.push(...(aliases.misspellings || []).map((a) => a.toLowerCase()));
  }

  return [...new Set(tokens.filter((t) => t.length > 0))];
}

// --- Category tree ---

function buildCategoryTree(points: PointEntry[], equipment: EquipmentEntry[]): BabelCategory[] {
  const categories: BabelCategory[] = [];

  const pointCategories = new Map<string, PointEntry[]>();
  for (const point of points) {
    const cat = point.concept.category;
    if (!pointCategories.has(cat)) {
      pointCategories.set(cat, []);
    }
    pointCategories.get(cat)!.push(point);
  }

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

  return categories.sort((a, b) => {
    if (a.type !== b.type) {
      return a.type === "equipment" ? -1 : 1;
    }
    return a.name.localeCompare(b.name);
  });
}

// --- Main build ---

async function build() {
  console.log("Building BAS Babel data...\n");
  const shouldValidate = process.argv.includes("--validate");

  // Load Haystack dictionaries
  console.log("Loading Haystack tag dictionary...");
  const tagDict = loadTagDict();
  console.log(`  Loaded ${Object.keys(tagDict).length} tags`);

  console.log("Loading Haystack unit mapping...");
  const unitMap = loadUnitMap();
  console.log(`  Loaded ${Object.keys(unitMap).length} unit mappings`);

  // Read points
  console.log("Reading points...");
  const pointFiles = readYamlFiles<PointYamlFile>(path.join(DATA_DIR, "points"));
  const points: PointEntry[] = pointFiles.map((f) => {
    const kind = inferPointKind(f.concept);
    return {
      concept: {
        id: f.concept.id,
        name: f.concept.name,
        category: f.concept.category,
        ...(f.concept.subcategory && { subcategory: f.concept.subcategory }),
        description: f.concept.description,
        haystack: f.concept.haystack
          ? parseHaystackString(f.concept.haystack, "point", tagDict, unitMap, f.concept.unit, kind) as PointHaystackData
          : undefined,
        ...(f.concept.brick && { brick: f.concept.brick }),
        kind,
        ...(f.concept.unit && { unit: f.concept.unit }),
        ...(f.concept.point_function && { point_function: f.concept.point_function }),
        ...(f.concept.states && { states: f.concept.states }),
      },
      aliases: f.aliases,
      notes: f.notes,
      related: f.related,
    };
  });
  console.log(`  Found ${points.length} points`);

  // Read equipment
  console.log("Reading equipment...");
  const equipFiles = readYamlFiles<EquipmentYamlFile>(path.join(DATA_DIR, "equipment"));
  const equipment: EquipmentEntry[] = [];
  for (const file of equipFiles) {
    const entries: EquipmentEntryYaml[] = Array.isArray(file.equipment)
      ? file.equipment
      : file.equipment
        ? [file.equipment]
        : [];
    for (const entry of entries) {
      equipment.push({
        ...entry,
        haystack: entry.haystack
          ? parseHaystackString(entry.haystack, "equip", tagDict, unitMap) as EquipmentHaystackData
          : undefined,
      });
    }
  }
  console.log(`  Found ${equipment.length} equipment entries`);

  // Ensure dist directory exists
  if (!fs.existsSync(DIST_DIR)) {
    fs.mkdirSync(DIST_DIR, { recursive: true });
  }

  // Generate main data file
  // v2.0.0: haystack field changed from flat string to structured object
  const data: BabelData = {
    version: "2.0.0",
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
    version: "2.0.0",
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
    version: "2.0.0",
    entries: searchEntries,
  };

  fs.writeFileSync(path.join(DIST_DIR, "search-index.json"), JSON.stringify(searchIndex, null, 2));
  console.log("Generated dist/search-index.json");

  if (shouldValidate) {
    console.log("\nRunning validation...");
    validatePointKinds(points);
    validateHaystackTags(points, equipment, tagDict);
    console.log("Validation successful!");
  }

  console.log("\nBuild complete!");
  console.log(`  Total entries: ${points.length + equipment.length}`);
}

build().catch(console.error);
