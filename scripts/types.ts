// BAS Babel Type Definitions

export interface TypicalRange {
  min: number;
  max: number;
}

export interface BabelAliases {
  common: string[];
  misspellings?: string[];
}

// BACnet engineering units structure
export interface BACnetUnits {
  symbol: string;
  bacnet_unit: number;
  description: string;
}

// Point function types
export type PointFunction = "sensor" | "setpoint" | "command" | "status" | "alarm" | "enable" | "mode" | "schedule" | "calculated";

// BACnet object types
export type ObjectType = "analogInput" | "analogOutput" | "analogValue" | "binaryInput" | "binaryOutput" | "binaryValue" | "multiStateInput" | "multiStateOutput" | "multiStateValue";

// Point concept definition
export interface PointConcept {
  id: string;
  name: string;
  category: string;
  subcategory?: string;
  description: string;
  haystack?: string;
  brick?: string;
  units?: BACnetUnits;
  unit?: string; // Legacy field
  typical_range?: TypicalRange;
  object_type?: ObjectType | string;
  point_function?: PointFunction;
  states?: Record<string, string>;
  typical_equipment?: string[];
  engineering_units?: string;
}

export interface PointEntry {
  concept: PointConcept;
  aliases: BabelAliases;
  notes?: string[];
  related?: string[];
}

// Equipment definition
export interface EquipmentSubtype {
  id: string;
  name: string;
  aliases?: string[];
  description?: string;
}

export interface EquipmentEntry {
  id: string;
  name: string;
  full_name?: string;
  abbreviation?: string;
  category: string;
  description: string;
  haystack?: string;
  brick?: string;
  aliases: BabelAliases;
  subtypes?: EquipmentSubtype[];
  typical_points?: string[];
  related_equipment?: string[];
}

// Category structure for navigation
export interface BabelCategory {
  id: string;
  name: string;
  type: "points" | "equipment";
  count: number;
  subcategories?: BabelCategory[];
}

// Search index entry
export interface SearchIndexEntry {
  id: string;
  type: "point" | "equipment";
  name: string;
  tokens: string[]; // Pre-computed lowercase search tokens
}

// Full data structure
export interface BabelData {
  version: string;
  lastUpdated: string;
  totalPoints: number;
  totalEquipment: number;
  points: PointEntry[];
  equipment: EquipmentEntry[];
}

// Categories structure
export interface CategoriesData {
  version: string;
  categories: BabelCategory[];
}

// Search index structure
export interface SearchIndexData {
  version: string;
  entries: SearchIndexEntry[];
}

// YAML file structures (what we read from disk)
export interface PointYamlFile {
  concept: PointConcept;
  aliases: BabelAliases;
  notes?: string[];
  related?: string[];
}

export interface EquipmentYamlFile {
  equipment: EquipmentEntry | EquipmentEntry[];
}
