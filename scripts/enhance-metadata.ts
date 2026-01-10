import * as fs from "fs";
import * as path from "path";
import { parse as parseYaml, stringify as stringifyYaml } from "yaml";

const DATA_DIR = path.join(process.cwd(), "data");

// ============================================================================
// BACnet Engineering Units (from ASHRAE 135)
// ============================================================================
const UNITS = {
  // Temperature
  degF: { symbol: "°F", bacnet_unit: 64, description: "degrees Fahrenheit" },
  degC: { symbol: "°C", bacnet_unit: 62, description: "degrees Celsius" },

  // Pressure
  inH2O: { symbol: "in. W.C.", bacnet_unit: 58, description: "inches of water column" },
  psi: { symbol: "PSI", bacnet_unit: 56, description: "pounds per square inch" },
  kPa: { symbol: "kPa", bacnet_unit: 54, description: "kilopascals" },
  Pa: { symbol: "Pa", bacnet_unit: 53, description: "pascals" },

  // Flow
  cfm: { symbol: "CFM", bacnet_unit: 84, description: "cubic feet per minute" },
  gpm: { symbol: "GPM", bacnet_unit: 89, description: "US gallons per minute" },
  lps: { symbol: "L/s", bacnet_unit: 87, description: "liters per second" },

  // Humidity
  percentRH: { symbol: "%RH", bacnet_unit: 29, description: "percent relative humidity" },

  // Percentage
  percent: { symbol: "%", bacnet_unit: 98, description: "percent" },

  // Electrical
  kW: { symbol: "kW", bacnet_unit: 47, description: "kilowatts" },
  kWh: { symbol: "kWh", bacnet_unit: 19, description: "kilowatt-hours" },
  amps: { symbol: "A", bacnet_unit: 3, description: "amperes" },
  volts: { symbol: "V", bacnet_unit: 5, description: "volts" },

  // Speed
  rpm: { symbol: "RPM", bacnet_unit: 104, description: "revolutions per minute" },
  hz: { symbol: "Hz", bacnet_unit: 27, description: "hertz" },

  // Volume
  gallons: { symbol: "gal", bacnet_unit: 82, description: "US gallons" },
  liters: { symbol: "L", bacnet_unit: 76, description: "liters" },
  cf: { symbol: "ft³", bacnet_unit: 79, description: "cubic feet" },
  ccf: { symbol: "CCF", bacnet_unit: 254, description: "hundred cubic feet" },
  therms: { symbol: "therms", bacnet_unit: 21, description: "therms" },

  // Time
  seconds: { symbol: "s", bacnet_unit: 73, description: "seconds" },
  minutes: { symbol: "min", bacnet_unit: 72, description: "minutes" },
  hours: { symbol: "hr", bacnet_unit: 71, description: "hours" },

  // No unit
  noUnit: { symbol: "", bacnet_unit: 95, description: "no units" },
  boolean: { symbol: "", bacnet_unit: 95, description: "boolean (on/off)" },
  state: { symbol: "", bacnet_unit: 95, description: "state enumeration" },
};

// ============================================================================
// Point Function Classifications
// ============================================================================
type PointFunction = "sensor" | "setpoint" | "command" | "status" | "alarm" | "enable" | "mode" | "schedule" | "calculated";

// ============================================================================
// BACnet Object Types
// ============================================================================
type ObjectType = "analogInput" | "analogOutput" | "analogValue" | "binaryInput" | "binaryOutput" | "binaryValue" | "multiStateInput" | "multiStateOutput" | "multiStateValue";

// ============================================================================
// Point Metadata Definitions
// ============================================================================
interface PointMetadata {
  units: typeof UNITS[keyof typeof UNITS];
  object_type: ObjectType;
  point_function: PointFunction;
  states?: Record<number, string>;
  typical_range?: { min: number; max: number };
  typical_equipment?: string[];
}

// Define metadata for each point pattern
const pointMetadata: Record<string, Partial<PointMetadata>> = {
  // ==================== TEMPERATURES ====================
  "zone-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 55, max: 85 },
    typical_equipment: ["air-handling-unit", "rooftop-unit", "variable-air-volume-box", "fan-coil-unit"],
  },
  "supply-air-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 45, max: 120 },
    typical_equipment: ["air-handling-unit", "rooftop-unit", "makeup-air-unit"],
  },
  "return-air-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 55, max: 85 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "discharge-air-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 45, max: 120 },
    typical_equipment: ["air-handling-unit", "rooftop-unit", "variable-air-volume-box"],
  },
  "mixed-air-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 35, max: 95 },
    typical_equipment: ["air-handling-unit", "rooftop-unit", "makeup-air-unit"],
  },
  "outdoor-air-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: -20, max: 120 },
    typical_equipment: ["air-handling-unit", "rooftop-unit", "dedicated-outdoor-air-system"],
  },
  "exhaust-air-temperaure": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 55, max: 95 },
    typical_equipment: ["energy-recovery-ventilator", "heat-recovery-ventilator"],
  },
  "chilled-water-supply-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 38, max: 55 },
    typical_equipment: ["chiller", "air-handling-unit"],
  },
  "chilled-water-return-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 48, max: 65 },
    typical_equipment: ["chiller", "air-handling-unit"],
  },
  "hot-water-supply-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 120, max: 200 },
    typical_equipment: ["boiler", "air-handling-unit"],
  },
  "hot-water-return-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 100, max: 180 },
    typical_equipment: ["boiler", "air-handling-unit"],
  },
  "condenser-water-supply-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 65, max: 95 },
    typical_equipment: ["chiller", "cooling-tower"],
  },
  "condenser-water-return-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 75, max: 105 },
    typical_equipment: ["chiller", "cooling-tower"],
  },
  "cooling-tower-basin-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 40, max: 100 },
    typical_equipment: ["cooling-tower"],
  },
  "chiller-entering-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 48, max: 65 },
    typical_equipment: ["chiller"],
  },
  "chiller-leaving-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 38, max: 55 },
    typical_equipment: ["chiller"],
  },
  "city-water-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 40, max: 80 },
    typical_equipment: ["cooling-tower"],
  },
  "domestic-hot-water-supply-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 110, max: 140 },
    typical_equipment: ["boiler", "heat-exchanger"],
  },
  "domestic-hot-water-return-temperature": {
    units: UNITS.degF,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 95, max: 130 },
    typical_equipment: ["boiler", "heat-exchanger"],
  },

  // ==================== SETPOINTS ====================
  "discharge-air-temperature-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "setpoint",
    typical_range: { min: 50, max: 75 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "effective-discharge-air-temperature-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "calculated",
    typical_range: { min: 50, max: 75 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "mixed-air-temperature-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "setpoint",
    typical_range: { min: 45, max: 65 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "occupied-cooling-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "setpoint",
    typical_range: { min: 70, max: 78 },
    typical_equipment: ["variable-air-volume-box", "fan-coil-unit", "rooftop-unit"],
  },
  "occupied-heating-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "setpoint",
    typical_range: { min: 65, max: 72 },
    typical_equipment: ["variable-air-volume-box", "fan-coil-unit", "rooftop-unit"],
  },
  "unoccupied-cooling-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "setpoint",
    typical_range: { min: 80, max: 90 },
    typical_equipment: ["variable-air-volume-box", "fan-coil-unit", "rooftop-unit"],
  },
  "unoccupied-heating-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "setpoint",
    typical_range: { min: 55, max: 65 },
    typical_equipment: ["variable-air-volume-box", "fan-coil-unit", "rooftop-unit"],
  },
  "standby-cooling-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "setpoint",
    typical_range: { min: 75, max: 85 },
    typical_equipment: ["variable-air-volume-box", "fan-coil-unit"],
  },
  "standby-heating-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "setpoint",
    typical_range: { min: 60, max: 68 },
    typical_equipment: ["variable-air-volume-box", "fan-coil-unit"],
  },
  "effective-cooling-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "calculated",
    typical_range: { min: 70, max: 85 },
    typical_equipment: ["variable-air-volume-box", "fan-coil-unit"],
  },
  "effective-heating-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "calculated",
    typical_range: { min: 55, max: 72 },
    typical_equipment: ["variable-air-volume-box", "fan-coil-unit"],
  },
  "cooling-outdoor-air-lockout-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "setpoint",
    typical_range: { min: 55, max: 75 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "heating-outdoor-air-lockout-setpoint": {
    units: UNITS.degF,
    object_type: "analogValue",
    point_function: "setpoint",
    typical_range: { min: 55, max: 75 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "discharge-air-pressure-setpoint": {
    units: UNITS.inH2O,
    object_type: "analogValue",
    point_function: "setpoint",
    typical_range: { min: 0.5, max: 3.0 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "return-air-pressure-setpoint": {
    units: UNITS.inH2O,
    object_type: "analogValue",
    point_function: "setpoint",
    typical_range: { min: -0.1, max: 0.1 },
    typical_equipment: ["air-handling-unit"],
  },

  // ==================== PRESSURES ====================
  "discharge-air-pressure": {
    units: UNITS.inH2O,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 5 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "return-air-pressure": {
    units: UNITS.inH2O,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: -1, max: 1 },
    typical_equipment: ["air-handling-unit"],
  },
  "space-pressure": {
    units: UNITS.inH2O,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: -0.1, max: 0.15 },
    typical_equipment: ["air-handling-unit", "variable-air-volume-box"],
  },
  "building-pressure": {
    units: UNITS.inH2O,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: -0.1, max: 0.15 },
    typical_equipment: ["air-handling-unit"],
  },
  "chilled-water-differential-pressure": {
    units: UNITS.psi,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 50 },
    typical_equipment: ["pump", "chiller"],
  },
  "hot-water-differential-pressure": {
    units: UNITS.psi,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 50 },
    typical_equipment: ["pump", "boiler"],
  },

  // ==================== FLOWS ====================
  "supply-air-flow": {
    units: UNITS.cfm,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 50000 },
    typical_equipment: ["air-handling-unit", "variable-air-volume-box"],
  },
  "return-air-flow": {
    units: UNITS.cfm,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 50000 },
    typical_equipment: ["air-handling-unit"],
  },
  "outdoor-air-flow": {
    units: UNITS.cfm,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 20000 },
    typical_equipment: ["air-handling-unit", "dedicated-outdoor-air-system"],
  },
  "exhaust-air-flow": {
    units: UNITS.cfm,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 20000 },
    typical_equipment: ["air-handling-unit"],
  },
  "discharge-air-flow": {
    units: UNITS.cfm,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 5000 },
    typical_equipment: ["variable-air-volume-box"],
  },

  // ==================== HUMIDITY ====================
  "zone-humidity": {
    units: UNITS.percentRH,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 20, max: 80 },
    typical_equipment: ["air-handling-unit", "variable-air-volume-box"],
  },
  "return-air-humidity": {
    units: UNITS.percentRH,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 20, max: 80 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "outdoor-air-humidity": {
    units: UNITS.percentRH,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 10, max: 100 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "discharge-air-humidity": {
    units: UNITS.percentRH,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 30, max: 90 },
    typical_equipment: ["air-handling-unit"],
  },

  // ==================== VALVES ====================
  "cooling-valve-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "fan-coil-unit", "variable-air-volume-box"],
  },
  "cooling-valve-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "fan-coil-unit"],
  },
  "heating-valve-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "fan-coil-unit", "variable-air-volume-box"],
  },
  "heating-valve-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "fan-coil-unit"],
  },
  "bypass-valve-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["chiller", "boiler"],
  },
  "bypass-valve-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["chiller", "boiler"],
  },
  "mixing-valve-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["boiler", "heat-exchanger"],
  },
  "mixing-valve-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["boiler", "heat-exchanger"],
  },
  "isolation-valve-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["chiller", "boiler", "cooling-tower"],
  },
  "isolation-valve-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["chiller", "boiler", "cooling-tower"],
  },
  "cooling-tower-isolation-valve": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["cooling-tower"],
  },

  // ==================== DAMPERS ====================
  "outside-air-damper-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "rooftop-unit", "dedicated-outdoor-air-system"],
  },
  "outside-air-damper-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "outside-air-damper-position": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "mixed-air-damper-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "mixed-air-damper-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "mixed-air-damper-position": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "return-air-damper-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "return-air-damper-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "exhaust-air-damper-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "energy-recovery-ventilator"],
  },
  "exhaust-air-damper-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "exhaust-air-damper-position": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "relief-air-damper-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "relief-air-damper-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "relief-air-damper-position": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "face-bypass-damper-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "face-bypass-damper-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },

  // Damper end switches (binary)
  "outside-air-damper-open": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Closed", 1: "Open" },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "outside-air-damper-closed": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Not Closed", 1: "Closed" },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "mixed-air-damper-open": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Closed", 1: "Open" },
    typical_equipment: ["air-handling-unit"],
  },
  "mixed-air-damper-closed": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Not Closed", 1: "Closed" },
    typical_equipment: ["air-handling-unit"],
  },
  "exhaust-air-damper-open": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Closed", 1: "Open" },
    typical_equipment: ["air-handling-unit"],
  },
  "exhaust-air-damper-closed": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Not Closed", 1: "Closed" },
    typical_equipment: ["air-handling-unit"],
  },
  "relief-air-damper-open": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Closed", 1: "Open" },
    typical_equipment: ["air-handling-unit"],
  },
  "relief-air-damper-closed": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Not Closed", 1: "Closed" },
    typical_equipment: ["air-handling-unit"],
  },
  "smoke-damper-open": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Closed", 1: "Open" },
    typical_equipment: ["air-handling-unit"],
  },

  // ==================== FANS ====================
  "supply-fan-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["air-handling-unit", "rooftop-unit", "makeup-air-unit"],
  },
  "supply-fan-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["air-handling-unit", "rooftop-unit", "makeup-air-unit"],
  },
  "supply-fan-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "supply-fan-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "supply-fan-speed": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "supply-fan-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "supply-fan-fault": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Fault" },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "return-fan-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["air-handling-unit"],
  },
  "return-fan-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["air-handling-unit"],
  },
  "return-fan-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "return-fan-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "return-fan-speed": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "return-fan-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["air-handling-unit"],
  },
  "return-fan-fault": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Fault" },
    typical_equipment: ["air-handling-unit"],
  },
  "exhaust-fan-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["air-handling-unit", "energy-recovery-ventilator"],
  },
  "exhaust-fan-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["air-handling-unit", "energy-recovery-ventilator"],
  },
  "exhaust-fan-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "exhaust-fan-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "exhaust-fan-speed": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "exhaust-fan-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["air-handling-unit"],
  },
  "exhaust-fan-fault": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Fault" },
    typical_equipment: ["air-handling-unit"],
  },
  "relief-fan-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["air-handling-unit"],
  },
  "relief-fan-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["air-handling-unit"],
  },
  "relief-fan-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "relief-fan-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "relief-fan-speed": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "relief-fan-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["air-handling-unit"],
  },
  "relief-fan-fault": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Fault" },
    typical_equipment: ["air-handling-unit"],
  },

  // ==================== COMMANDS / ENABLES ====================
  "system-enable": {
    units: UNITS.boolean,
    object_type: "binaryValue",
    point_function: "enable",
    states: { 0: "Disabled", 1: "Enabled" },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "cooling-enable": {
    units: UNITS.boolean,
    object_type: "binaryValue",
    point_function: "enable",
    states: { 0: "Disabled", 1: "Enabled" },
    typical_equipment: ["air-handling-unit", "rooftop-unit", "chiller"],
  },
  "heating-enable": {
    units: UNITS.boolean,
    object_type: "binaryValue",
    point_function: "enable",
    states: { 0: "Disabled", 1: "Enabled" },
    typical_equipment: ["air-handling-unit", "rooftop-unit", "boiler"],
  },
  "economizer-enable": {
    units: UNITS.boolean,
    object_type: "binaryValue",
    point_function: "enable",
    states: { 0: "Disabled", 1: "Enabled" },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "humidifier-enable": {
    units: UNITS.boolean,
    object_type: "binaryValue",
    point_function: "enable",
    states: { 0: "Disabled", 1: "Enabled" },
    typical_equipment: ["air-handling-unit"],
  },
  "occupied-command": {
    units: UNITS.boolean,
    object_type: "binaryValue",
    point_function: "command",
    states: { 0: "Unoccupied", 1: "Occupied" },
    typical_equipment: ["air-handling-unit", "rooftop-unit", "variable-air-volume-box"],
  },
  "unit-enable-mode": {
    units: UNITS.state,
    object_type: "multiStateValue",
    point_function: "mode",
    states: { 0: "Off", 1: "Auto", 2: "On" },
    typical_equipment: ["air-handling-unit", "rooftop-unit", "fan-coil-unit"],
  },

  // Chiller commands
  "chiller-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["chiller"],
  },
  "chiller-enable": {
    units: UNITS.boolean,
    object_type: "binaryValue",
    point_function: "enable",
    states: { 0: "Disabled", 1: "Enabled" },
    typical_equipment: ["chiller"],
  },
  "chiller-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["chiller"],
  },
  "chiller-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["chiller"],
  },

  // Boiler commands
  "boiler-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["boiler"],
  },
  "boiler-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["boiler"],
  },
  "boiler-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["boiler"],
  },
  "boiler-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["boiler"],
  },
  "boiler-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["boiler"],
  },

  // Cooling tower commands
  "cooling-tower-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["cooling-tower"],
  },
  "cooling-tower-enable": {
    units: UNITS.boolean,
    object_type: "binaryValue",
    point_function: "enable",
    states: { 0: "Disabled", 1: "Enabled" },
    typical_equipment: ["cooling-tower"],
  },
  "cooling-tower-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["cooling-tower"],
  },
  "cooling-tower-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["cooling-tower"],
  },
  "cooling-tower-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["cooling-tower"],
  },
  "cooling-tower-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["cooling-tower"],
  },

  // Pump commands
  "chilled-water-pump-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["pump"],
  },
  "chilled-water-pump-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["pump", "variable-frequency-drive"],
  },
  "chilled-water-pump-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["pump", "variable-frequency-drive"],
  },
  "chilled-water-pump-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["pump"],
  },
  "chilled-water-pump-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["pump"],
  },
  "hot-water-pump-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["pump"],
  },
  "hot-water-pump-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["pump", "variable-frequency-drive"],
  },
  "hot-water-pump-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["pump", "variable-frequency-drive"],
  },
  "hot-water-pump-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["pump"],
  },
  "hot-water-pump-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["pump"],
  },
  "condenser-water-pump-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["pump"],
  },
  "condenser-water-pump-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["pump", "variable-frequency-drive"],
  },
  "condenser-water-pump-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["pump", "variable-frequency-drive"],
  },
  "condenser-water-pump-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["pump"],
  },
  "condenser-water-pump-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["pump"],
  },
  "boiler-pump-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["pump", "boiler"],
  },
  "boiler-pump-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["pump", "boiler"],
  },
  "boiler-pump-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["pump", "boiler"],
  },
  "boiler-pump-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["pump", "boiler"],
  },
  "boiler-pump-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["pump", "boiler"],
  },
  "primary-chilled-water-pump-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["pump"],
  },
  "primary-chilled-water-pump-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["pump", "variable-frequency-drive"],
  },
  "primary-chilled-water-pump-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["pump", "variable-frequency-drive"],
  },
  "primary-chilled-water-pump-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["pump"],
  },
  "primary-chilled-water-pump-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["pump"],
  },
  "secondary-chilled-water-pump-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["pump"],
  },
  "secondary-chilled-water-pump-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["pump", "variable-frequency-drive"],
  },
  "secondary-chilled-water-pump-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["pump", "variable-frequency-drive"],
  },
  "secondary-chilled-water-pump-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["pump"],
  },
  "secondary-chilled-water-pump-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["pump"],
  },

  // Heat wheel
  "heat-wheel-command": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["energy-recovery-ventilator", "heat-recovery-ventilator"],
  },
  "heat-wheel-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["energy-recovery-ventilator", "heat-recovery-ventilator"],
  },
  "heat-wheel-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["energy-recovery-ventilator", "heat-recovery-ventilator"],
  },
  "heat-wheel-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Off", 1: "Running" },
    typical_equipment: ["energy-recovery-ventilator", "heat-recovery-ventilator"],
  },

  // Humidifier
  "humidifier-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "humidifier-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },

  // Steam and gas heat
  "steam-heating-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "steam-heating-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["air-handling-unit"],
  },
  "gas-fired-heat-output": {
    units: UNITS.percent,
    object_type: "analogOutput",
    point_function: "command",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["rooftop-unit", "unit-heater"],
  },
  "gas-fired-heat-feedback": {
    units: UNITS.percent,
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 0, max: 100 },
    typical_equipment: ["rooftop-unit", "unit-heater"],
  },

  // ==================== ALARMS ====================
  "smoke-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "low-limit-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Alarm" },
    typical_equipment: ["air-handling-unit"],
  },
  "filter-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Dirty" },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "prefilter-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Dirty" },
    typical_equipment: ["air-handling-unit"],
  },
  "final-filter-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Dirty" },
    typical_equipment: ["air-handling-unit"],
  },
  "discharge-air-high-pressure-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "High Pressure" },
    typical_equipment: ["air-handling-unit"],
  },
  "discharge-air-low-pressure-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Low Pressure" },
    typical_equipment: ["air-handling-unit"],
  },
  "return-air-high-pressure-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "High Pressure" },
    typical_equipment: ["air-handling-unit"],
  },
  "return-air-low-pressure-alarm": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "alarm",
    states: { 0: "Normal", 1: "Low Pressure" },
    typical_equipment: ["air-handling-unit"],
  },

  // ==================== STATUS ====================
  "filter-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Clean", 1: "Dirty" },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "prefilter-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Clean", 1: "Dirty" },
    typical_equipment: ["air-handling-unit"],
  },
  "final-filter-status": {
    units: UNITS.boolean,
    object_type: "binaryInput",
    point_function: "status",
    states: { 0: "Clean", 1: "Dirty" },
    typical_equipment: ["air-handling-unit"],
  },
  "effective-occupancy": {
    units: UNITS.boolean,
    object_type: "binaryValue",
    point_function: "calculated",
    states: { 0: "Unoccupied", 1: "Occupied" },
    typical_equipment: ["air-handling-unit", "variable-air-volume-box"],
  },
  "occupancy-schedule": {
    units: UNITS.boolean,
    object_type: "binaryValue",
    point_function: "schedule",
    states: { 0: "Unoccupied", 1: "Occupied" },
    typical_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "return-air-co2": {
    units: { symbol: "ppm", bacnet_unit: 96, description: "parts per million" },
    object_type: "analogInput",
    point_function: "sensor",
    typical_range: { min: 400, max: 2000 },
    typical_equipment: ["air-handling-unit", "dedicated-outdoor-air-system"],
  },

  // DX and electric heat stages
  "dx-cooling-stage": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["rooftop-unit", "packaged-terminal-air-conditioner"],
  },
  "electric-heat-stage": {
    units: UNITS.boolean,
    object_type: "binaryOutput",
    point_function: "command",
    states: { 0: "Off", 1: "On" },
    typical_equipment: ["rooftop-unit", "air-handling-unit", "unit-heater"],
  },
};

// ============================================================================
// Equipment typical points and relationships
// ============================================================================
const equipmentData: Record<string, { typical_points: string[]; related_equipment: string[] }> = {
  "air-handling-unit": {
    typical_points: [
      "supply-air-temperature", "return-air-temperature", "mixed-air-temperature", "outdoor-air-temperature", "discharge-air-temperature",
      "discharge-air-temperature-setpoint", "supply-fan-command", "supply-fan-status", "supply-fan-speed", "supply-fan-output",
      "return-fan-command", "return-fan-status", "return-fan-speed", "return-fan-output",
      "outside-air-damper-output", "outside-air-damper-position", "mixed-air-damper-output", "return-air-damper-output",
      "relief-air-damper-output", "exhaust-air-damper-output",
      "cooling-valve-output", "cooling-valve-feedback", "heating-valve-output", "heating-valve-feedback",
      "discharge-air-pressure", "discharge-air-pressure-setpoint",
      "filter-status", "prefilter-status", "final-filter-status", "smoke-alarm", "low-limit-alarm",
      "system-enable", "cooling-enable", "heating-enable", "economizer-enable",
      "supply-fan-alarm", "return-fan-alarm", "chilled-water-supply-temperature", "hot-water-supply-temperature",
    ],
    related_equipment: ["variable-air-volume-box", "chiller", "boiler", "pump", "cooling-tower", "variable-frequency-drive"],
  },
  "rooftop-unit": {
    typical_points: [
      "supply-air-temperature", "return-air-temperature", "mixed-air-temperature", "outdoor-air-temperature", "discharge-air-temperature",
      "discharge-air-temperature-setpoint", "supply-fan-command", "supply-fan-status", "supply-fan-speed",
      "outside-air-damper-output", "outside-air-damper-position",
      "dx-cooling-stage", "gas-fired-heat-output", "electric-heat-stage",
      "filter-status", "smoke-alarm", "low-limit-alarm",
      "system-enable", "cooling-enable", "heating-enable", "economizer-enable",
      "zone-temperature", "occupied-cooling-setpoint", "occupied-heating-setpoint",
    ],
    related_equipment: ["variable-air-volume-box", "variable-frequency-drive"],
  },
  "variable-air-volume-box": {
    typical_points: [
      "zone-temperature", "discharge-air-temperature", "discharge-air-flow",
      "occupied-cooling-setpoint", "occupied-heating-setpoint", "unoccupied-cooling-setpoint", "unoccupied-heating-setpoint",
      "effective-cooling-setpoint", "effective-heating-setpoint",
      "heating-valve-output", "cooling-valve-output",
      "occupied-command", "effective-occupancy",
    ],
    related_equipment: ["air-handling-unit", "rooftop-unit"],
  },
  "fan-coil-unit": {
    typical_points: [
      "zone-temperature", "discharge-air-temperature",
      "occupied-cooling-setpoint", "occupied-heating-setpoint",
      "cooling-valve-output", "heating-valve-output",
      "supply-fan-command", "supply-fan-status",
      "unit-enable-mode",
    ],
    related_equipment: ["chiller", "boiler", "pump"],
  },
  "chiller": {
    typical_points: [
      "chiller-command", "chiller-enable", "chiller-status", "chiller-alarm",
      "chilled-water-supply-temperature", "chilled-water-return-temperature",
      "chiller-entering-temperature", "chiller-leaving-temperature",
      "condenser-water-supply-temperature", "condenser-water-return-temperature",
    ],
    related_equipment: ["cooling-tower", "pump", "air-handling-unit"],
  },
  "boiler": {
    typical_points: [
      "boiler-command", "boiler-output", "boiler-feedback", "boiler-status", "boiler-alarm",
      "hot-water-supply-temperature", "hot-water-return-temperature",
      "boiler-pump-command", "boiler-pump-status",
    ],
    related_equipment: ["pump", "air-handling-unit", "heat-exchanger"],
  },
  "cooling-tower": {
    typical_points: [
      "cooling-tower-command", "cooling-tower-enable", "cooling-tower-output", "cooling-tower-feedback", "cooling-tower-status", "cooling-tower-alarm",
      "cooling-tower-basin-temperature", "condenser-water-supply-temperature", "condenser-water-return-temperature",
      "cooling-tower-isolation-valve", "city-water-temperature",
    ],
    related_equipment: ["chiller", "pump"],
  },
  "pump": {
    typical_points: [
      "chilled-water-pump-command", "chilled-water-pump-output", "chilled-water-pump-feedback", "chilled-water-pump-status", "chilled-water-pump-alarm",
      "hot-water-pump-command", "hot-water-pump-output", "hot-water-pump-feedback", "hot-water-pump-status", "hot-water-pump-alarm",
      "condenser-water-pump-command", "condenser-water-pump-output", "condenser-water-pump-feedback", "condenser-water-pump-status", "condenser-water-pump-alarm",
      "chilled-water-differential-pressure", "hot-water-differential-pressure",
    ],
    related_equipment: ["chiller", "boiler", "cooling-tower", "variable-frequency-drive"],
  },
  "variable-frequency-drive": {
    typical_points: [
      "supply-fan-output", "supply-fan-feedback", "supply-fan-speed",
      "return-fan-output", "return-fan-feedback", "return-fan-speed",
      "chilled-water-pump-output", "chilled-water-pump-feedback",
      "hot-water-pump-output", "hot-water-pump-feedback",
      "condenser-water-pump-output", "condenser-water-pump-feedback",
    ],
    related_equipment: ["air-handling-unit", "pump", "fan-motor"],
  },
  "energy-recovery-ventilator": {
    typical_points: [
      "supply-air-temperature", "outdoor-air-temperature", "exhaust-air-temperaure",
      "supply-fan-command", "supply-fan-status", "exhaust-fan-command", "exhaust-fan-status",
      "heat-wheel-command", "heat-wheel-output", "heat-wheel-feedback", "heat-wheel-status",
      "outside-air-damper-output", "exhaust-air-damper-output",
    ],
    related_equipment: ["air-handling-unit", "dedicated-outdoor-air-system"],
  },
  "heat-recovery-ventilator": {
    typical_points: [
      "supply-air-temperature", "outdoor-air-temperature", "exhaust-air-temperaure",
      "supply-fan-command", "supply-fan-status", "exhaust-fan-command", "exhaust-fan-status",
      "heat-wheel-command", "heat-wheel-output", "heat-wheel-feedback", "heat-wheel-status",
    ],
    related_equipment: ["air-handling-unit"],
  },
  "makeup-air-unit": {
    typical_points: [
      "supply-air-temperature", "outdoor-air-temperature", "mixed-air-temperature", "discharge-air-temperature",
      "supply-fan-command", "supply-fan-status", "supply-fan-speed",
      "heating-valve-output", "gas-fired-heat-output",
      "filter-status", "smoke-alarm",
    ],
    related_equipment: ["boiler"],
  },
  "dedicated-outdoor-air-system": {
    typical_points: [
      "supply-air-temperature", "outdoor-air-temperature", "discharge-air-temperature",
      "supply-fan-command", "supply-fan-status", "supply-fan-speed",
      "cooling-valve-output", "heating-valve-output",
      "outdoor-air-flow", "return-air-co2",
      "system-enable",
    ],
    related_equipment: ["chiller", "boiler", "energy-recovery-ventilator"],
  },
  "unit-heater": {
    typical_points: [
      "zone-temperature", "occupied-heating-setpoint",
      "supply-fan-command", "supply-fan-status",
      "heating-valve-output", "gas-fired-heat-output", "electric-heat-stage",
    ],
    related_equipment: ["boiler"],
  },
  "heat-exchanger": {
    typical_points: [
      "hot-water-supply-temperature", "hot-water-return-temperature",
      "mixing-valve-output", "mixing-valve-feedback",
    ],
    related_equipment: ["boiler", "pump"],
  },
};

// ============================================================================
// Processing Functions
// ============================================================================

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

function getBasePointId(id: string): string {
  // Remove numbered suffixes like -1, -2, etc.
  return id.replace(/-\d+$/, "");
}

function processPointFile(filePath: string): boolean {
  const content = fs.readFileSync(filePath, "utf-8");
  const data = parseYaml(content);

  if (!data.concept || !data.concept.id) return false;

  const id = data.concept.id;
  const baseId = getBasePointId(id);
  const metadata = pointMetadata[baseId] || pointMetadata[id];

  if (!metadata) {
    // Try to infer from patterns
    const inferred = inferMetadata(id);
    if (inferred) {
      applyMetadata(data, inferred);
      const yamlContent = stringifyYaml(data, { lineWidth: 0 });
      fs.writeFileSync(filePath, yamlContent);
      console.log(`  ${path.basename(filePath)}: inferred metadata`);
      return true;
    }
    return false;
  }

  applyMetadata(data, metadata);
  const yamlContent = stringifyYaml(data, { lineWidth: 0 });
  fs.writeFileSync(filePath, yamlContent);
  console.log(`  ${path.basename(filePath)}: updated`);
  return true;
}

function applyMetadata(data: any, metadata: Partial<PointMetadata>): void {
  if (metadata.units) {
    data.concept.units = {
      symbol: metadata.units.symbol,
      bacnet_unit: metadata.units.bacnet_unit,
      description: metadata.units.description,
    };
  }

  if (metadata.object_type) {
    data.concept.object_type = metadata.object_type;
  }

  if (metadata.point_function) {
    data.concept.point_function = metadata.point_function;
  }

  if (metadata.states) {
    data.concept.states = metadata.states;
  }

  if (metadata.typical_range) {
    data.concept.typical_range = metadata.typical_range;
  }

  if (metadata.typical_equipment) {
    data.concept.typical_equipment = metadata.typical_equipment;
  }
}

function inferMetadata(id: string): Partial<PointMetadata> | null {
  const result: Partial<PointMetadata> = {};

  // Infer from name patterns
  if (id.includes("temperature") || id.includes("-temp")) {
    result.units = UNITS.degF;
    result.object_type = "analogInput";
    result.point_function = "sensor";
    result.typical_range = { min: 32, max: 120 };
  } else if (id.includes("setpoint") || id.includes("-sp")) {
    result.object_type = "analogValue";
    result.point_function = "setpoint";
    if (id.includes("temperature") || id.includes("cooling") || id.includes("heating")) {
      result.units = UNITS.degF;
      result.typical_range = { min: 55, max: 85 };
    } else if (id.includes("pressure")) {
      result.units = UNITS.inH2O;
    }
  } else if (id.includes("-output") || id.includes("-cmd")) {
    result.units = UNITS.percent;
    result.object_type = "analogOutput";
    result.point_function = "command";
    result.typical_range = { min: 0, max: 100 };
  } else if (id.includes("-feedback") || id.includes("-fb")) {
    result.units = UNITS.percent;
    result.object_type = "analogInput";
    result.point_function = "sensor";
    result.typical_range = { min: 0, max: 100 };
  } else if (id.includes("-position") || id.includes("-pos")) {
    result.units = UNITS.percent;
    result.object_type = "analogInput";
    result.point_function = "sensor";
    result.typical_range = { min: 0, max: 100 };
  } else if (id.includes("-speed") || id.includes("-spd")) {
    result.units = UNITS.percent;
    result.object_type = "analogInput";
    result.point_function = "sensor";
    result.typical_range = { min: 0, max: 100 };
  } else if (id.includes("-command")) {
    result.units = UNITS.boolean;
    result.object_type = "binaryOutput";
    result.point_function = "command";
    result.states = { 0: "Off", 1: "On" };
  } else if (id.includes("-status") || id.includes("-sts")) {
    result.units = UNITS.boolean;
    result.object_type = "binaryInput";
    result.point_function = "status";
    result.states = { 0: "Off", 1: "Running" };
  } else if (id.includes("-alarm") || id.includes("-alm")) {
    result.units = UNITS.boolean;
    result.object_type = "binaryInput";
    result.point_function = "alarm";
    result.states = { 0: "Normal", 1: "Alarm" };
  } else if (id.includes("-enable") || id.includes("-en")) {
    result.units = UNITS.boolean;
    result.object_type = "binaryValue";
    result.point_function = "enable";
    result.states = { 0: "Disabled", 1: "Enabled" };
  } else if (id.includes("humidity") || id.includes("-rh")) {
    result.units = UNITS.percentRH;
    result.object_type = "analogInput";
    result.point_function = "sensor";
    result.typical_range = { min: 0, max: 100 };
  } else if (id.includes("pressure")) {
    result.units = UNITS.inH2O;
    result.object_type = "analogInput";
    result.point_function = "sensor";
  } else if (id.includes("flow")) {
    result.units = UNITS.cfm;
    result.object_type = "analogInput";
    result.point_function = "sensor";
    result.typical_range = { min: 0, max: 10000 };
  } else if (id.includes("-open") || id.includes("-closed")) {
    result.units = UNITS.boolean;
    result.object_type = "binaryInput";
    result.point_function = "status";
    result.states = id.includes("-open") ? { 0: "Closed", 1: "Open" } : { 0: "Not Closed", 1: "Closed" };
  } else if (id.includes("stage")) {
    result.units = UNITS.boolean;
    result.object_type = "binaryOutput";
    result.point_function = "command";
    result.states = { 0: "Off", 1: "On" };
  } else if (id.includes("-fault")) {
    result.units = UNITS.boolean;
    result.object_type = "binaryInput";
    result.point_function = "alarm";
    result.states = { 0: "Normal", 1: "Fault" };
  } else {
    return null;
  }

  return result;
}

function processEquipmentFile(filePath: string): number {
  const content = fs.readFileSync(filePath, "utf-8");
  const data = parseYaml(content);

  if (!data.equipment || !Array.isArray(data.equipment)) return 0;

  let updated = 0;

  for (const equip of data.equipment) {
    const equipData = equipmentData[equip.id];
    if (equipData) {
      equip.typical_points = equipData.typical_points;
      equip.related_equipment = equipData.related_equipment;
      console.log(`  ${equip.id}: added ${equipData.typical_points.length} typical points, ${equipData.related_equipment.length} related equipment`);
      updated++;
    }
  }

  if (updated > 0) {
    const yamlContent = stringifyYaml(data, { lineWidth: 0 });
    fs.writeFileSync(filePath, yamlContent);
  }

  return updated;
}

// ============================================================================
// Main
// ============================================================================

console.log("Enhancing metadata for all points and equipment...\n");

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

// Process equipment
console.log("Processing equipment:");
const equipDir = path.join(DATA_DIR, "equipment");
const equipFiles = findYamlFiles(equipDir);
let equipUpdated = 0;
for (const file of equipFiles) {
  equipUpdated += processEquipmentFile(file);
}
console.log(`\nUpdated ${equipUpdated} equipment entries\n`);

console.log("Done!");
