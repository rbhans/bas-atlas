import * as fs from "fs";
import * as path from "path";
import { parse as parseYaml, stringify as stringifyYaml } from "yaml";

const DATA_DIR = path.join(process.cwd(), "data");

// Map equipment IDs to their typical points
const typicalPointsMap: Record<string, string[]> = {
  // Air Handling
  "air-handling-unit": [
    "supply-fan-command",
    "supply-fan-status",
    "supply-fan-speed",
    "return-fan-command",
    "return-fan-status",
    "return-fan-speed",
    "supply-air-temperature",
    "return-air-temperature",
    "mixed-air-temperature",
    "outside-air-temperature",
    "discharge-air-temperature",
    "outside-air-damper-output",
    "return-air-damper-output",
    "mixed-air-damper-output",
    "cooling-valve-output",
    "heating-valve-output",
    "filter-alarm",
    "low-limit-alarm",
    "smoke-alarm",
  ],
  "rooftop-unit": [
    "supply-fan-command",
    "supply-fan-status",
    "supply-fan-speed",
    "supply-air-temperature",
    "return-air-temperature",
    "mixed-air-temperature",
    "outside-air-temperature",
    "discharge-air-temperature",
    "outside-air-damper-output",
    "cooling-valve-output",
    "heating-valve-output",
    "dx-cooling-stage",
    "gas-fired-heat-output",
    "filter-alarm",
    "economizer-enable",
  ],
  "makeup-air-unit": [
    "supply-fan-command",
    "supply-fan-status",
    "supply-fan-speed",
    "supply-air-temperature",
    "discharge-air-temperature",
    "outside-air-temperature",
    "heating-valve-output",
    "gas-fired-heat-output",
    "filter-alarm",
  ],
  "dedicated-outdoor-air-system": [
    "supply-fan-command",
    "supply-fan-status",
    "supply-fan-speed",
    "supply-air-temperature",
    "outside-air-temperature",
    "discharge-air-temperature",
    "cooling-valve-output",
    "heating-valve-output",
    "heat-wheel-output",
    "filter-alarm",
  ],
  "fan-coil-unit": [
    "supply-fan-command",
    "supply-fan-status",
    "discharge-air-temperature",
    "zone-temperature",
    "cooling-valve-output",
    "heating-valve-output",
    "cooling-setpoint",
    "heating-setpoint",
  ],
  "computer-room-air-conditioner": [
    "supply-fan-command",
    "supply-fan-status",
    "supply-air-temperature",
    "return-air-temperature",
    "discharge-air-temperature",
    "cooling-valve-output",
    "filter-alarm",
  ],
  "computer-room-air-handler": [
    "supply-fan-command",
    "supply-fan-status",
    "supply-air-temperature",
    "return-air-temperature",
    "discharge-air-temperature",
    "cooling-valve-output",
    "filter-alarm",
  ],
  "unit-ventilator": [
    "supply-fan-command",
    "supply-fan-status",
    "discharge-air-temperature",
    "zone-temperature",
    "outside-air-damper-output",
    "heating-valve-output",
    "cooling-valve-output",
  ],
  "packaged-terminal-air-conditioner": [
    "supply-fan-command",
    "supply-fan-status",
    "discharge-air-temperature",
    "zone-temperature",
    "cooling-setpoint",
    "heating-setpoint",
  ],
  "packaged-terminal-heat-pump": [
    "supply-fan-command",
    "supply-fan-status",
    "discharge-air-temperature",
    "zone-temperature",
    "cooling-setpoint",
    "heating-setpoint",
  ],
  "water-source-heat-pump": [
    "supply-fan-command",
    "supply-fan-status",
    "discharge-air-temperature",
    "zone-temperature",
    "entering-water-temperature",
    "leaving-water-temperature",
  ],
  "air-source-heat-pump": [
    "supply-fan-command",
    "supply-fan-status",
    "discharge-air-temperature",
    "zone-temperature",
    "outside-air-temperature",
    "cooling-setpoint",
    "heating-setpoint",
  ],
  "energy-recovery-ventilator": [
    "supply-fan-command",
    "supply-fan-status",
    "exhaust-fan-command",
    "exhaust-fan-status",
    "supply-air-temperature",
    "exhaust-air-temperature",
    "outside-air-temperature",
    "heat-wheel-output",
  ],
  "heat-recovery-ventilator": [
    "supply-fan-command",
    "supply-fan-status",
    "exhaust-fan-command",
    "exhaust-fan-status",
    "supply-air-temperature",
    "exhaust-air-temperature",
    "outside-air-temperature",
  ],
  "air-turnover-unit": [
    "supply-fan-command",
    "supply-fan-status",
    "supply-fan-speed",
    "discharge-air-temperature",
    "zone-temperature",
    "heating-valve-output",
    "gas-fired-heat-output",
  ],

  // Terminal Units
  "variable-air-volume-box": [
    "zone-temperature",
    "discharge-air-temperature",
    "damper-position",
    "damper-output",
    "airflow",
    "airflow-setpoint",
    "heating-valve-output",
    "cooling-setpoint",
    "heating-setpoint",
  ],
  "constant-air-volume-box": [
    "zone-temperature",
    "discharge-air-temperature",
    "heating-valve-output",
    "cooling-setpoint",
    "heating-setpoint",
  ],
  "parallel-fan-powered-box": [
    "zone-temperature",
    "discharge-air-temperature",
    "damper-position",
    "damper-output",
    "supply-fan-command",
    "supply-fan-status",
    "airflow",
    "heating-valve-output",
    "cooling-setpoint",
    "heating-setpoint",
  ],
  "series-fan-powered-box": [
    "zone-temperature",
    "discharge-air-temperature",
    "damper-position",
    "damper-output",
    "supply-fan-command",
    "supply-fan-status",
    "airflow",
    "heating-valve-output",
    "cooling-setpoint",
    "heating-setpoint",
  ],
  "chilled-beam": [
    "zone-temperature",
    "cooling-valve-output",
    "cooling-setpoint",
  ],
  "radiant-panel": [
    "zone-temperature",
    "heating-valve-output",
    "cooling-valve-output",
    "cooling-setpoint",
    "heating-setpoint",
  ],
  "baseboard-heater": [
    "zone-temperature",
    "heating-valve-output",
    "heating-setpoint",
  ],
  "unit-heater": [
    "zone-temperature",
    "supply-fan-command",
    "supply-fan-status",
    "heating-valve-output",
    "gas-fired-heat-output",
    "heating-setpoint",
  ],
  "induction-unit": [
    "zone-temperature",
    "discharge-air-temperature",
    "cooling-valve-output",
    "heating-valve-output",
  ],
  "blower-coil-unit": [
    "zone-temperature",
    "discharge-air-temperature",
    "supply-fan-command",
    "supply-fan-status",
    "cooling-valve-output",
    "heating-valve-output",
  ],

  // Central Plant
  "chiller": [
    "chiller-command",
    "chiller-enable",
    "chiller-status",
    "chiller-alarm",
    "chiller-entering-temperature",
    "chiller-leaving-temperature",
  ],
  "boiler": [
    "boiler-command",
    "boiler-output",
    "boiler-status",
    "boiler-alarm",
    "hot-water-supply-temperature",
    "hot-water-return-temperature",
  ],
  "cooling-tower": [
    "cooling-tower-command",
    "cooling-tower-enable",
    "cooling-tower-output",
    "cooling-tower-status",
    "cooling-tower-alarm",
    "cooling-tower-basin-temperature",
    "condenser-water-supply-temperature",
    "condenser-water-return-temperature",
    "cooling-tower-isolation-valve",
  ],
  "heat-exchanger": [
    "entering-water-temperature",
    "leaving-water-temperature",
  ],
  "pump": [
    "chilled-water-pump-command",
    "chilled-water-pump-output",
    "chilled-water-pump-status",
    "chilled-water-pump-alarm",
    "hot-water-pump-command",
    "hot-water-pump-output",
    "hot-water-pump-status",
    "hot-water-pump-alarm",
    "differential-pressure",
  ],
  "variable-frequency-drive": [
    "supply-fan-speed",
    "supply-fan-command",
    "supply-fan-status",
  ],
  "expansion-tank": [],
  "air-separator": [],
  "steam-to-hot-water-converter": [
    "hot-water-supply-temperature",
    "steam-heating-output",
  ],

  // Metering
  "electric-meter": [],
  "natural-gas-meter": [],
  "water-meter": [],
  "steam-meter": [],
  "btu-meter": [],

  // VRF
  "vrf-outdoor-unit": [
    "outside-air-temperature",
  ],
  "vrf-indoor-unit": [
    "zone-temperature",
    "discharge-air-temperature",
    "supply-fan-command",
    "supply-fan-status",
    "cooling-setpoint",
    "heating-setpoint",
  ],
  "vrf-branch-selector-box": [],
};

function processEquipmentFile(filePath: string): number {
  const content = fs.readFileSync(filePath, "utf-8");
  const data = parseYaml(content);

  if (!data.equipment || !Array.isArray(data.equipment)) return 0;

  let updated = 0;

  for (const equip of data.equipment) {
    const typicalPoints = typicalPointsMap[equip.id];

    if (typicalPoints && typicalPoints.length > 0) {
      equip.typical_points = typicalPoints;
      console.log(`  ${equip.id}: added ${typicalPoints.length} typical points`);
      updated++;
    } else if (typicalPoints && typicalPoints.length === 0) {
      // Explicitly empty - remove if exists
      if (equip.typical_points) {
        delete equip.typical_points;
      }
    }
  }

  if (updated > 0) {
    const yamlContent = stringifyYaml(data, { lineWidth: 0 });
    fs.writeFileSync(filePath, yamlContent);
  }

  return updated;
}

// Main
console.log("Adding typical_points to equipment...\n");

const equipDir = path.join(DATA_DIR, "equipment");
const files = fs.readdirSync(equipDir).filter(f => f.endsWith(".yaml"));
let total = 0;

for (const file of files) {
  console.log(`Processing ${file}:`);
  total += processEquipmentFile(path.join(equipDir, file));
}

console.log(`\nUpdated ${total} equipment entries with typical_points`);
