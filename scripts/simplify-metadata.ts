import * as fs from "fs";
import * as path from "path";
import { parse as parseYaml, stringify as stringifyYaml } from "yaml";

const DATA_DIR = path.join(process.cwd(), "data");

// Simple units - just the symbols that could apply
const unitMappings: Record<string, string[]> = {
  // Temperatures
  "temperature": ["°F", "°C"],
  "setpoint": ["°F", "°C"],

  // Percentages
  "output": ["%"],
  "feedback": ["%"],
  "position": ["%"],
  "speed": ["%"],
  "humidity": ["%", "%RH"],

  // Pressure
  "pressure": ["in. W.C.", "Pa", "PSI"],

  // Flow
  "flow": ["CFM", "L/s", "GPM"],

  // CO2
  "co2": ["ppm"],
};

// Point functions
type PointFunction = "sensor" | "setpoint" | "command" | "status" | "alarm" | "enable" | "mode" | "schedule" | "calculated";

function findYamlFiles(dir: string): string[] {
  const results: string[] = [];
  if (!fs.existsSync(dir)) return results;

  const items = fs.readdirSync(dir, { withFileTypes: true });
  for (const item of items) {
    const fullPath = path.join(dir, item.name);
    if (item.isDirectory()) {
      results.push(...findYamlFiles(fullPath));
    } else if (item.name.endsWith(".yaml")) {
      results.push(fullPath);
    }
  }
  return results;
}

function getUnits(id: string, category: string): string[] | null {
  // Temperature points
  if (id.includes("temperature") || category === "temperatures") {
    return ["°F", "°C"];
  }

  // Setpoints (most are temperature)
  if (id.includes("setpoint") && (id.includes("cooling") || id.includes("heating") || id.includes("temperature"))) {
    return ["°F", "°C"];
  }

  // Pressure setpoints
  if (id.includes("setpoint") && id.includes("pressure")) {
    return ["in. W.C.", "Pa"];
  }

  // Humidity
  if (id.includes("humidity") || category === "humidity") {
    return ["%RH"];
  }

  // Pressure
  if (id.includes("pressure") || category === "pressures") {
    if (id.includes("differential")) {
      return ["PSI", "ft. H2O", "kPa"];
    }
    return ["in. W.C.", "Pa"];
  }

  // Flow
  if (id.includes("flow") || category === "flows") {
    return ["CFM", "L/s"];
  }

  // Percentage outputs/positions
  if (id.includes("output") || id.includes("feedback") || id.includes("position") || id.includes("speed")) {
    return ["%"];
  }

  // CO2
  if (id.includes("co2")) {
    return ["ppm"];
  }

  // Binary points don't have units
  return null;
}

function getPointFunction(id: string): PointFunction {
  if (id.includes("setpoint") || id.includes("-sp")) {
    if (id.includes("effective")) return "calculated";
    return "setpoint";
  }
  if (id.includes("-output") || id.includes("-command") || id.includes("-cmd")) {
    return "command";
  }
  if (id.includes("-status") || id.includes("-sts")) {
    return "status";
  }
  if (id.includes("-alarm") || id.includes("-alm") || id.includes("-fault")) {
    return "alarm";
  }
  if (id.includes("-enable") || id.includes("-en")) {
    return "enable";
  }
  if (id.includes("mode")) {
    return "mode";
  }
  if (id.includes("schedule")) {
    return "schedule";
  }
  if (id.includes("effective-")) {
    return "calculated";
  }
  // Default to sensor for most inputs
  return "sensor";
}

function getStates(id: string): Record<number, string> | null {
  // Command points
  if (id.includes("-command") || id.includes("-cmd")) {
    return { 0: "Off", 1: "On" };
  }

  // Status points
  if (id.includes("-status") || id.includes("-sts")) {
    return { 0: "Off", 1: "Running" };
  }

  // Alarm points
  if (id.includes("-alarm") || id.includes("-alm")) {
    if (id.includes("filter")) {
      return { 0: "Clean", 1: "Dirty" };
    }
    if (id.includes("pressure")) {
      if (id.includes("high")) return { 0: "Normal", 1: "High Pressure" };
      if (id.includes("low")) return { 0: "Normal", 1: "Low Pressure" };
    }
    return { 0: "Normal", 1: "Alarm" };
  }

  // Fault points
  if (id.includes("-fault")) {
    return { 0: "Normal", 1: "Fault" };
  }

  // Enable points
  if (id.includes("-enable") || id.includes("-en")) {
    return { 0: "Disabled", 1: "Enabled" };
  }

  // Open/closed points
  if (id.includes("-open")) {
    return { 0: "Closed", 1: "Open" };
  }
  if (id.includes("-closed")) {
    return { 0: "Not Closed", 1: "Closed" };
  }

  // Occupancy
  if (id.includes("occupancy") || id.includes("occupied")) {
    return { 0: "Unoccupied", 1: "Occupied" };
  }

  // Filter status
  if (id.includes("filter-status")) {
    return { 0: "Clean", 1: "Dirty" };
  }

  // Stage points
  if (id.includes("stage")) {
    return { 0: "Off", 1: "On" };
  }

  // Mode points (multistate)
  if (id.includes("mode")) {
    return { 0: "Off", 1: "Auto", 2: "On" };
  }

  return null;
}

function processPointFile(filePath: string): boolean {
  const content = fs.readFileSync(filePath, "utf-8");
  const data = parseYaml(content);

  if (!data.concept || !data.concept.id) return false;

  const id = data.concept.id;
  const category = data.concept.category;
  let modified = false;

  // Remove unwanted fields that I added
  if (data.concept.units) {
    delete data.concept.units;
    modified = true;
  }
  if (data.concept.object_type) {
    delete data.concept.object_type;
    modified = true;
  }
  if (data.concept.typical_range) {
    delete data.concept.typical_range;
    modified = true;
  }
  if (data.concept.typical_equipment) {
    delete data.concept.typical_equipment;
    modified = true;
  }
  // Keep legacy unit field if it exists but remove bacnet stuff
  if (data.concept.engineering_units) {
    delete data.concept.engineering_units;
    modified = true;
  }

  // Add simple unit field (array of possible units)
  const units = getUnits(id, category);
  if (units) {
    data.concept.unit = units;
    modified = true;
  } else if (data.concept.unit && typeof data.concept.unit === 'string') {
    // Remove old string unit if it was there
    delete data.concept.unit;
    modified = true;
  }

  // Add point_function
  const pointFunction = getPointFunction(id);
  data.concept.point_function = pointFunction;
  modified = true;

  // Add states for non-analog points
  const states = getStates(id);
  if (states) {
    data.concept.states = states;
    modified = true;
  } else if (data.concept.states) {
    delete data.concept.states;
    modified = true;
  }

  if (modified) {
    const yamlContent = stringifyYaml(data, { lineWidth: 0 });
    fs.writeFileSync(filePath, yamlContent);
    console.log(`  ${path.basename(filePath)}: simplified`);
  }

  return modified;
}

function processEquipmentFile(filePath: string): number {
  const content = fs.readFileSync(filePath, "utf-8");
  const data = parseYaml(content);

  if (!data.equipment || !Array.isArray(data.equipment)) return 0;

  let updated = 0;

  for (const equip of data.equipment) {
    let modified = false;

    // Remove fields I added that weren't requested
    if (equip.typical_points) {
      delete equip.typical_points;
      modified = true;
    }
    if (equip.related_equipment) {
      delete equip.related_equipment;
      modified = true;
    }

    if (modified) {
      console.log(`  ${equip.id}: removed extra fields`);
      updated++;
    }
  }

  if (updated > 0) {
    const yamlContent = stringifyYaml(data, { lineWidth: 0 });
    fs.writeFileSync(filePath, yamlContent);
  }

  return updated;
}

// Main
console.log("Simplifying metadata to only requested fields...\n");

// Process points
console.log("Processing points:");
const pointsDir = path.join(DATA_DIR, "points");
const pointFiles = findYamlFiles(pointsDir);
let pointsUpdated = 0;
for (const file of pointFiles) {
  if (processPointFile(file)) {
    pointsUpdated++;
  }
}
console.log(`\nUpdated ${pointsUpdated} point files\n`);

// Process equipment - remove the extra fields I added
console.log("Processing equipment (removing extra fields):");
const equipDir = path.join(DATA_DIR, "equipment");
const equipFiles = findYamlFiles(equipDir);
let equipUpdated = 0;
for (const file of equipFiles) {
  equipUpdated += processEquipmentFile(file);
}
console.log(`\nUpdated ${equipUpdated} equipment entries\n`);

console.log("Done!");
