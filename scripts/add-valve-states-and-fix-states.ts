import * as fs from "fs";
import * as path from "path";
import { parse as parseYaml, stringify as stringifyYaml } from "yaml";

const DATA_DIR = path.join(process.cwd(), "data");
const VALVES_DIR = path.join(DATA_DIR, "points", "valves");

// Valve types to create open/closed points for
const valveTypes = [
  { base: "cooling-valve", name: "Cooling Valve" },
  { base: "heating-valve", name: "Heating Valve" },
  { base: "bypass-valve", name: "Bypass Valve" },
  { base: "isolation-valve", name: "Isolation Valve" },
  { base: "mixing-valve", name: "Mixing Valve" },
  { base: "chilled-water-valve", name: "Chilled Water Valve" },
  { base: "hot-water-valve", name: "Hot Water Valve" },
  { base: "condenser-water-valve", name: "Condenser Water Valve" },
  { base: "steam-valve", name: "Steam Valve" },
  { base: "outside-air-damper", name: "Outside Air Damper" },
  { base: "return-air-damper", name: "Return Air Damper" },
  { base: "exhaust-air-damper", name: "Exhaust Air Damper" },
  { base: "relief-air-damper", name: "Relief Air Damper" },
  { base: "mixed-air-damper", name: "Mixed Air Damper" },
];

function generateAliases(base: string, suffix: string): string[] {
  // Generate aliases for valve open/closed points
  const parts = base.split("-");
  const aliases: string[] = [];

  // Common abbreviations
  const abbrevMap: Record<string, string[]> = {
    "cooling": ["clg", "cool", "c"],
    "heating": ["htg", "heat", "ht", "h"],
    "bypass": ["byp", "bp"],
    "isolation": ["iso", "isol"],
    "mixing": ["mix", "mx"],
    "chilled": ["chl", "ch", "chw"],
    "hot": ["ht", "hw"],
    "condenser": ["cnd", "cw"],
    "steam": ["stm", "st"],
    "water": ["wtr", "w"],
    "valve": ["vlv", "v"],
    "damper": ["dmp", "dmpr", "d"],
    "outside": ["oa", "out", "o"],
    "return": ["ret", "ra", "r"],
    "exhaust": ["exh", "ea", "e"],
    "relief": ["rel", "relf"],
    "mixed": ["ma", "mix"],
    "air": ["a", "ar"],
    "open": ["opn", "op"],
    "closed": ["cls", "cl", "cld"],
  };

  const suffixAbbrevs = abbrevMap[suffix] || [suffix.substring(0, 2)];

  // Build various alias combinations
  if (suffix === "open") {
    aliases.push(`${parts[0].substring(0, 1)}-${suffix.substring(0, 1)}`);
    aliases.push(`${parts[0].substring(0, 3)} ${suffix}`);
    aliases.push(`${parts[0].substring(0, 3)}-${suffix}`);
    aliases.push(`${base.replace(/-/g, " ")} ${suffix}`);
    aliases.push(`${base}-${suffix}`);
    for (const sa of suffixAbbrevs) {
      aliases.push(`${parts[0].substring(0, 3)} vlv ${sa}`);
      aliases.push(`${parts[0].substring(0, 3)}-vlv-${sa}`);
    }
  } else {
    aliases.push(`${parts[0].substring(0, 1)}-${suffix.substring(0, 2)}`);
    aliases.push(`${parts[0].substring(0, 3)} ${suffix}`);
    aliases.push(`${parts[0].substring(0, 3)}-${suffix}`);
    aliases.push(`${base.replace(/-/g, " ")} ${suffix}`);
    aliases.push(`${base}-${suffix}`);
    for (const sa of suffixAbbrevs) {
      aliases.push(`${parts[0].substring(0, 3)} vlv ${sa}`);
      aliases.push(`${parts[0].substring(0, 3)}-vlv-${sa}`);
    }
  }

  return [...new Set(aliases)];
}

function createValvePoint(base: string, name: string, suffix: "open" | "closed"): void {
  const id = `${base}-${suffix}`;
  const pointName = `${name} ${suffix.charAt(0).toUpperCase() + suffix.slice(1)}`;
  const filePath = path.join(VALVES_DIR, `${id}.yaml`);

  // Skip if file already exists
  if (fs.existsSync(filePath)) {
    console.log(`  ${id}: already exists, skipping`);
    return;
  }

  const haystackTag = base.includes("damper")
    ? `${base.replace(/-/g, " ")} ${suffix} sensor`
    : `${base.replace(/-/g, " ")} ${suffix} sensor`;

  const brickClass = pointName.replace(/ /g, "_") + "_Sensor";

  const states = suffix === "open"
    ? { "0": "Not Open", "1": "Open" }
    : { "0": "Not Closed", "1": "Closed" };

  const data = {
    concept: {
      id,
      name: pointName,
      category: "valves",
      description: `Binary status indicating if ${name.toLowerCase()} is ${suffix}`,
      haystack: haystackTag,
      brick: brickClass,
      point_function: "status",
      states,
    },
    aliases: {
      common: generateAliases(base, suffix),
    },
  };

  const yamlContent = stringifyYaml(data, { lineWidth: 0 });
  fs.writeFileSync(filePath, yamlContent);
  console.log(`  ${id}: created`);
}

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

function getStatesForPoint(id: string, pointFunction: string): Record<string, string> | null {
  // Commands - binary on/off
  if (pointFunction === "command") {
    if (id.includes("occupied")) {
      return { "0": "Unoccupied", "1": "Occupied" };
    }
    return { "0": "Off", "1": "On" };
  }

  // Status - binary running/not running
  if (pointFunction === "status") {
    if (id.includes("filter")) {
      return { "0": "Clean", "1": "Dirty" };
    }
    if (id.includes("open")) {
      return { "0": "Not Open", "1": "Open" };
    }
    if (id.includes("closed")) {
      return { "0": "Not Closed", "1": "Closed" };
    }
    if (id.includes("occupancy") || id.includes("occupied")) {
      return { "0": "Unoccupied", "1": "Occupied" };
    }
    return { "0": "Off", "1": "Running" };
  }

  // Alarms
  if (pointFunction === "alarm") {
    if (id.includes("filter")) {
      return { "0": "Clean", "1": "Dirty" };
    }
    if (id.includes("smoke")) {
      return { "0": "Normal", "1": "Smoke Detected" };
    }
    if (id.includes("low-limit")) {
      return { "0": "Normal", "1": "Low Limit" };
    }
    if (id.includes("high-pressure")) {
      return { "0": "Normal", "1": "High Pressure" };
    }
    if (id.includes("low-pressure")) {
      return { "0": "Normal", "1": "Low Pressure" };
    }
    if (id.includes("fault")) {
      return { "0": "Normal", "1": "Fault" };
    }
    return { "0": "Normal", "1": "Alarm" };
  }

  // Enable
  if (pointFunction === "enable") {
    return { "0": "Disabled", "1": "Enabled" };
  }

  // Faults
  if (id.includes("fault")) {
    return { "0": "Normal", "1": "Fault" };
  }

  // Mode (multistate)
  if (pointFunction === "mode") {
    if (id.includes("unit-enable")) {
      return { "0": "Off", "1": "Auto", "2": "On" };
    }
    return { "0": "Off", "1": "Auto", "2": "On" };
  }

  return null;
}

function fixMissingStates(): number {
  const pointsDir = path.join(DATA_DIR, "points");
  const files = findYamlFiles(pointsDir);
  let fixed = 0;

  for (const file of files) {
    const content = fs.readFileSync(file, "utf-8");
    const data = parseYaml(content);

    if (!data.concept) continue;

    const { id, point_function, unit, states } = data.concept;

    // Skip if it has units (numeric point) or already has states
    if (unit || states) continue;

    // Skip if it's a sensor (typically analog)
    if (point_function === "sensor" || point_function === "setpoint" || point_function === "calculated") continue;

    // Get appropriate states
    const newStates = getStatesForPoint(id, point_function);
    if (newStates) {
      data.concept.states = newStates;
      const yamlContent = stringifyYaml(data, { lineWidth: 0 });
      fs.writeFileSync(file, yamlContent);
      console.log(`  ${id}: added states (${point_function})`);
      fixed++;
    }
  }

  return fixed;
}

// Main
console.log("Creating valve open/closed points...\n");

// Only create for actual valves (not dampers which already have them)
const actualValves = valveTypes.filter(v => v.base.includes("valve"));

for (const valve of actualValves) {
  createValvePoint(valve.base, valve.name, "open");
  createValvePoint(valve.base, valve.name, "closed");
}

console.log("\nFixing missing states on non-numeric points...\n");
const fixed = fixMissingStates();
console.log(`\nFixed ${fixed} points with missing states`);
