import * as fs from "fs";
import * as path from "path";
import { parse as parseYaml, stringify as stringifyYaml } from "yaml";

const DATA_DIR = path.join(process.cwd(), "data");

// Expanded state names for different point types
const stateExpansions: Record<string, Record<string, string[]>> = {
  // Status points - equipment running/not running
  status_default: {
    "0": ["Off", "Stopped", "Not Running", "Inactive", "Idle"],
    "1": ["Running", "On", "Active", "Started", "Energized"],
  },

  // Command points - on/off commands
  command_default: {
    "0": ["Off", "Stop", "Disable", "De-energize"],
    "1": ["On", "Start", "Enable", "Energize", "Run"],
  },

  // Alarm points
  alarm_default: {
    "0": ["Normal", "OK", "Clear", "No Alarm", "Healthy"],
    "1": ["Alarm", "Fault", "Alert", "Tripped", "Active"],
  },

  // Fault points
  fault: {
    "0": ["Normal", "OK", "No Fault", "Healthy"],
    "1": ["Fault", "Faulted", "Error", "Failed"],
  },

  // Filter status/alarm
  filter: {
    "0": ["Clean", "OK", "Good", "Normal"],
    "1": ["Dirty", "Clogged", "Replace", "Alarm"],
  },

  // Enable points
  enable: {
    "0": ["Disabled", "Off", "Locked Out", "Inhibited"],
    "1": ["Enabled", "On", "Unlocked", "Active"],
  },

  // Occupancy
  occupancy: {
    "0": ["Unoccupied", "Vacant", "Empty", "Standby"],
    "1": ["Occupied", "Present", "In Use", "Active"],
  },

  // Valve/damper open
  open: {
    "0": ["Not Open", "Closed", "Shut"],
    "1": ["Open", "Opened", "Full Open"],
  },

  // Valve/damper closed
  closed: {
    "0": ["Not Closed", "Open", "Ajar"],
    "1": ["Closed", "Shut", "Full Closed"],
  },

  // Smoke alarm
  smoke: {
    "0": ["Normal", "Clear", "No Smoke", "OK"],
    "1": ["Smoke Detected", "Alarm", "Smoke", "Tripped"],
  },

  // Low limit alarm
  low_limit: {
    "0": ["Normal", "OK", "Above Limit"],
    "1": ["Low Limit", "Low Limit Alarm", "Below Threshold", "Tripped"],
  },

  // High/low pressure alarms
  high_pressure: {
    "0": ["Normal", "OK", "Normal Pressure"],
    "1": ["High Pressure", "Over Pressure", "Pressure Alarm"],
  },
  low_pressure: {
    "0": ["Normal", "OK", "Normal Pressure"],
    "1": ["Low Pressure", "Under Pressure", "Pressure Alarm"],
  },

  // Mode (multi-state)
  mode: {
    "0": ["Off", "Standby", "Disabled"],
    "1": ["Auto", "Automatic", "Schedule"],
    "2": ["On", "Manual", "Hand", "Override"],
  },

  // DX/Electric staging
  stage: {
    "0": ["Off", "Inactive", "Disabled"],
    "1": ["On", "Active", "Staged", "Energized"],
  },

  // Shutdown
  shutdown: {
    "0": ["Normal", "Running", "Operational"],
    "1": ["Shutdown", "Tripped", "Safety Shutdown", "Emergency Stop"],
  },
};

function getExpansionKey(id: string, pointFunction: string): string {
  // Determine which expansion to use based on ID and point_function

  if (id.includes("filter")) return "filter";
  if (id.includes("smoke")) return "smoke";
  if (id.includes("low-limit")) return "low_limit";
  if (id.includes("high-pressure")) return "high_pressure";
  if (id.includes("low-pressure")) return "low_pressure";
  if (id.includes("fault")) return "fault";
  if (id.includes("shutdown")) return "shutdown";
  if (id.includes("occupancy") || id.includes("occupied")) return "occupancy";
  if (id.includes("-open")) return "open";
  if (id.includes("-closed")) return "closed";
  if (id.includes("stage")) return "stage";

  if (pointFunction === "alarm") return "alarm_default";
  if (pointFunction === "enable") return "enable";
  if (pointFunction === "mode") return "mode";
  if (pointFunction === "command") return "command_default";
  if (pointFunction === "status") return "status_default";

  return "status_default";
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

function expandStates(): number {
  const pointsDir = path.join(DATA_DIR, "points");
  const files = findYamlFiles(pointsDir);
  let updated = 0;

  for (const file of files) {
    const content = fs.readFileSync(file, "utf-8");
    const data = parseYaml(content);

    if (!data.concept) continue;

    const { id, point_function, states } = data.concept;

    // Skip if no states or states is already expanded (arrays)
    if (!states) continue;

    // Check if already expanded (first value is an array)
    const firstValue = Object.values(states)[0];
    if (Array.isArray(firstValue)) continue;

    // Get the appropriate expansion
    const expansionKey = getExpansionKey(id, point_function);
    const expansion = stateExpansions[expansionKey];

    if (!expansion) continue;

    // Create new states with arrays
    const newStates: Record<string, string[]> = {};
    for (const [key, value] of Object.entries(states)) {
      if (expansion[key]) {
        // Use expansion but ensure the original value is first if it's different
        const expandedValues = [...expansion[key]];
        if (!expandedValues.includes(value as string)) {
          expandedValues.unshift(value as string);
        } else {
          // Move the original value to front
          const idx = expandedValues.indexOf(value as string);
          if (idx > 0) {
            expandedValues.splice(idx, 1);
            expandedValues.unshift(value as string);
          }
        }
        newStates[key] = expandedValues;
      } else {
        // Keep as single-item array if no expansion available
        newStates[key] = [value as string];
      }
    }

    data.concept.states = newStates;
    const yamlContent = stringifyYaml(data, { lineWidth: 0 });
    fs.writeFileSync(file, yamlContent);
    console.log(`  ${id}: expanded states`);
    updated++;
  }

  return updated;
}

// Main
console.log("Expanding state names with alternatives...\n");
const updated = expandStates();
console.log(`\nExpanded states for ${updated} points`);
