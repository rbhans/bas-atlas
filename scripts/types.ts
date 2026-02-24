// BAS Atlas Type Definitions

export interface TypicalRange {
  min: number;
  max: number;
}

export interface AtlasAliases {
  common: string[];
  misspellings?: string[];
}

// Point function types
export type PointFunction = "sensor" | "setpoint" | "command" | "status" | "alarm" | "enable" | "mode" | "schedule" | "calculated";

// --- Haystack tag types ---

/** Haystack 4 tag value types */
export type HaystackTagKind = "Marker" | "Str" | "Number" | "Bool" | "Ref";

/** Tag category in the tag dictionary */
export type HaystackTagCategory =
  | "entityType"
  | "pointFunction"
  | "substance"
  | "measurement"
  | "qualifier"
  | "equipType"
  | "state";

/** A single resolved Haystack tag */
export interface HaystackTag {
  name: string;
  kind: HaystackTagKind;
}

/** Structured Haystack data for a point (build output) */
export interface PointHaystackData {
  tags: HaystackTag[];
  tagString: string;     // normalized space-delimited canonical form
  markers: string[];     // convenience: just the marker tag names
  unit?: string;         // Haystack-normalized unit (e.g., "°F")
  kind?: string;         // Haystack kind (e.g., "Number", "Bool")
}

/** Structured Haystack data for equipment (build output) */
export interface EquipmentHaystackData {
  tags: HaystackTag[];
  tagString: string;
  markers: string[];
}

/** Tag dictionary entry (from haystack-tags.yaml) */
export interface TagDictEntry {
  kind: HaystackTagKind;
  category: HaystackTagCategory;
}

/** Unit mapping entry (from haystack-units.yaml) */
export interface UnitMapEntry {
  haystack: string;
  quantity: string;
}

// --- Point concept definition ---

/** YAML source: haystack is a flat string */
export interface PointConceptYaml {
  id: string;
  name: string;
  category: string;
  subcategory?: string;
  description: string;
  haystack?: string;
  brick?: string;
  kind?: "Number" | "Bool";
  unit?: string[]; // Possible units (e.g., ["°F", "°C"])
  point_function?: PointFunction;
  states?: Record<string, string>; // For binary/multistate (e.g., {0: "Off", 1: "On"})
}

/** Build output: haystack is a structured object */
export interface PointConcept {
  id: string;
  name: string;
  category: string;
  subcategory?: string;
  description: string;
  haystack?: PointHaystackData;
  brick?: string;
  kind?: "Number" | "Bool";
  unit?: string[];
  point_function?: PointFunction;
  states?: Record<string, string>;
}

export interface PointEntry {
  concept: PointConcept;
  aliases: AtlasAliases;
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

/** YAML source: haystack is a flat string */
export interface EquipmentEntryYaml {
  id: string;
  name: string;
  full_name?: string;
  abbreviation?: string;
  category: string;
  description: string;
  haystack?: string;
  brick?: string;
  aliases: AtlasAliases;
  subtypes?: EquipmentSubtype[];
  typical_points?: string[];
}

/** Build output: haystack is a structured object */
export interface EquipmentEntry {
  id: string;
  name: string;
  full_name?: string;
  abbreviation?: string;
  category: string;
  description: string;
  haystack?: EquipmentHaystackData;
  brick?: string;
  aliases: AtlasAliases;
  subtypes?: EquipmentSubtype[];
  typical_points?: string[];
}

// Category structure for navigation
export interface AtlasCategory {
  id: string;
  name: string;
  type: "points" | "equipment";
  count: number;
  subcategories?: AtlasCategory[];
}

// Search index entry
export interface SearchIndexEntry {
  id: string;
  type: "point" | "equipment";
  name: string;
  tokens: string[]; // Pre-computed lowercase search tokens
}

// Full data structure
export interface AtlasData {
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
  categories: AtlasCategory[];
}

// Search index structure
export interface SearchIndexData {
  version: string;
  entries: SearchIndexEntry[];
}

// YAML file structures (what we read from disk)
export interface PointYamlFile {
  concept: PointConceptYaml;
  aliases: AtlasAliases;
  notes?: string[];
  related?: string[];
}

export interface EquipmentYamlFile {
  equipment: EquipmentEntryYaml | EquipmentEntryYaml[];
}
