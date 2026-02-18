import fs from "node:fs";
import path from "node:path";
import { execSync } from "node:child_process";
import { parse as parseYaml } from "yaml";

export type PointConceptType = "sensor" | "command" | "setpoint" | "alarm" | "status" | "calc";
export type AliasVariantType = "abbrev" | "expanded" | "misspelling" | "format" | "vendor";

export interface AliasVariant {
  value: string;
  type: AliasVariantType;
}

export interface LegacyAliases {
  common: string[];
  abbreviated?: string[];
  verbose?: string[];
  misspellings?: string[];
}

export interface PointConcept {
  id: string;
  name: string;
  category: string;
  subcategory?: string;
  description: string;
  haystack?: string;
  brick?: string;
  unit?: string | string[];
  point_function?: string;
  states?: Record<string, string | string[]>;
  kind: "point";
  type: PointConceptType;
  unitsNormalized: string[];
  statesNormalized?: Record<string, string>;
  tags: {
    haystack: string[];
    brick?: string;
  };
}

export interface PointEntry {
  concept: PointConcept;
  aliases: LegacyAliases & { variants: AliasVariant[] };
  notes?: string[];
  related?: string[];
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
  aliases: LegacyAliases;
  subtypes?: Array<{ id: string; name: string; aliases?: string[]; description?: string }>;
  typical_points?: string[];
  concept: {
    kind: "equipment";
    system?: string;
    synonyms: string[];
  };
}

export interface BabelData {
  version: string;
  lastUpdated: string;
  totalPoints: number;
  totalEquipment: number;
  points: PointEntry[];
  equipment: EquipmentEntry[];
}

export interface Category {
  id: string;
  name: string;
  type: "points" | "equipment";
  count: number;
}

export interface CategoriesData {
  version: string;
  categories: Category[];
}

export interface WeightedToken {
  token: string;
  weight: number;
  source: string;
}

export interface SearchIndexEntry {
  id: string;
  type: "point" | "equipment";
  name: string;
  tokens: string[];
  weightedTokens: WeightedToken[];
  ngrams?: string[];
}

export interface SearchIndexData {
  version: string;
  entries: SearchIndexEntry[];
}

export interface TemplateRelationship {
  from: string;
  rel: "feeds" | "controls" | "depends_on" | "measures" | "commands";
  to: string;
}

export interface EquipmentTemplate {
  id: string;
  equipmentTypeId: string;
  version: string;
  requiredPoints: string[];
  optionalPoints: string[];
  recommendedPoints: string[];
  relationships: TemplateRelationship[];
  notes: string[];
}

export interface TemplatesData {
  version: string;
  lastUpdated: string;
  templates: EquipmentTemplate[];
}

export interface GraphNode {
  id: string;
  type: "point" | "equipment" | "template";
  name?: string;
}

export interface GraphEdge {
  from: string;
  rel: string;
  to: string;
  source: "point-related" | "template";
}

export interface GraphData {
  version: string;
  lastUpdated: string;
  nodes: GraphNode[];
  edges: GraphEdge[];
  adjacency: Record<string, Array<{ to: string; rel: string }>>;
}

export interface NormalizerResult {
  matchedConceptId: string | null;
  confidence: number;
  matchType: "exact" | "alias" | "token" | "ngram" | "none";
  normalizedName: string;
  suggestedHaystackTags: string[];
}

export interface ValidatorResult {
  matched: Array<{ input: string; pointId: string; confidence: number }>;
  missingRequired: string[];
  missingRecommended: string[];
  unknown: string[];
  suggestions: Array<{ input: string; candidates: Array<{ pointId: string; confidence: number }> }>;
}

interface PointYamlFile {
  concept: Omit<PointConcept, "kind" | "type" | "unitsNormalized" | "statesNormalized" | "tags">;
  aliases: LegacyAliases;
  notes?: string[];
  related?: string[];
}

interface EquipmentYamlFile {
  equipment:
    | Array<Omit<EquipmentEntry, "concept">>
    | Omit<EquipmentEntry, "concept">;
}

interface TemplateYamlFile {
  templates: EquipmentTemplate[];
}

const VENDOR_WORDS = [
  "trane",
  "carrier",
  "honeywell",
  "johnson",
  "jci",
  "siemens",
  "schneider",
  "delta",
  "belimo",
  "distech",
  "veris",
  "automated logic",
  "alerton",
  "metasys",
  "niagara",
  "bacnet",
  "modbus",
];

const POINT_CATEGORY_DEFAULT_TYPE: Record<string, PointConceptType> = {
  alarms: "alarm",
  setpoints: "setpoint",
  commands: "command",
  status: "status",
};

const EQUIPMENT_CATEGORY_SYSTEM: Record<string, string> = {
  "air-handling": "air-handling",
  "central-plant": "central-plant",
  "terminal-units": "terminal-units",
  vrf: "vrf",
  metering: "metering",
  "domestic-water": "domestic-water",
  "power-distribution": "power-distribution",
  "life-safety": "life-safety",
  "standalone-fans": "air-handling",
};

const CATEGORY_DISPLAY_NAMES: Record<string, string> = {
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
  electrical: "Electrical",
  iaq: "IAQ",
  lighting: "Lighting",
  maintenance: "Maintenance",
  "air-handling": "Air Handling",
  "terminal-units": "Terminal Units",
  "central-plant": "Central Plant",
  metering: "Metering",
  motors: "Motors",
  vrf: "VRF",
  "power-distribution": "Power Distribution",
  "domestic-water": "Domestic Water",
  "life-safety": "Life Safety",
  "standalone-fans": "Standalone Fans",
};

export function normalizeText(input: string): string {
  return input
    .toLowerCase()
    .replace(/([a-z])([A-Z])/g, "$1 $2")
    .replace(/[._/\\-]+/g, " ")
    .replace(/\s+/g, " ")
    .trim();
}

export function tokenize(input: string): string[] {
  return normalizeText(input)
    .split(" ")
    .map((token) => token.trim())
    .filter(Boolean);
}

function readFilesRecursive(dir: string, matcher: (name: string) => boolean): string[] {
  if (!fs.existsSync(dir)) {
    return [];
  }

  const entries = fs
    .readdirSync(dir, { withFileTypes: true })
    .sort((a, b) => a.name.localeCompare(b.name));

  const results: string[] = [];
  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...readFilesRecursive(fullPath, matcher));
      continue;
    }

    if (matcher(entry.name)) {
      results.push(fullPath);
    }
  }

  return results.sort((a, b) => a.localeCompare(b));
}

function readYamlFiles<T>(dir: string): T[] {
  const files = readFilesRecursive(dir, (name) => name.endsWith(".yaml") || name.endsWith(".yml"));
  const results: T[] = [];

  for (const file of files) {
    const content = fs.readFileSync(file, "utf8");
    const parsed = parseYaml(content) as T;
    if (parsed) {
      results.push(parsed);
    }
  }

  return results;
}

function dedupeAndSort(values: string[]): string[] {
  return [...new Set(values.map((v) => v.trim()).filter(Boolean))].sort((a, b) => a.localeCompare(b));
}

function normalizedCompareValue(value: string): string {
  return value.toLowerCase().replace(/[^a-z0-9]/g, "");
}

function classifyVariant(
  value: string,
  canonicalName: string,
  canonicalId: string,
  misspellings: Set<string>,
): AliasVariantType {
  const lower = value.toLowerCase();

  if (misspellings.has(lower)) {
    return "misspelling";
  }

  if (VENDOR_WORDS.some((vendorWord) => lower.includes(vendorWord))) {
    return "vendor";
  }

  const compact = normalizedCompareValue(lower);
  const canonicalCompactName = normalizedCompareValue(canonicalName);
  const canonicalCompactId = normalizedCompareValue(canonicalId);

  if (compact === canonicalCompactName || compact === canonicalCompactId) {
    if (lower !== canonicalName.toLowerCase() && lower !== canonicalId.toLowerCase()) {
      return "format";
    }
  }

  if (!lower.includes(" ") && lower.length <= 6) {
    return "abbrev";
  }

  if (lower.split(" ").length >= 2) {
    return "expanded";
  }

  return "format";
}

export function buildAliasVariants(
  aliases: LegacyAliases,
  canonicalName: string,
  canonicalId: string,
): AliasVariant[] {
  const misspellings = new Set((aliases.misspellings ?? []).map((alias) => alias.toLowerCase()));

  const candidateValues = dedupeAndSort([
    ...(aliases.common ?? []),
    ...(aliases.abbreviated ?? []),
    ...(aliases.verbose ?? []),
    ...(aliases.misspellings ?? []),
  ]);

  return candidateValues
    .map((value) => ({
      value,
      type: classifyVariant(value, canonicalName, canonicalId, misspellings),
    }))
    .sort((a, b) => {
      const valueCompare = a.value.localeCompare(b.value);
      if (valueCompare !== 0) {
        return valueCompare;
      }
      return a.type.localeCompare(b.type);
    });
}

function normalizeUnit(rawUnit: string): string {
  const normalized = rawUnit.trim().toLowerCase();

  const directMap: Record<string, string> = {
    "\u00b0f": "degF",
    "\u00b0c": "degC",
    f: "degF",
    c: "degC",
    "deg f": "degF",
    "deg c": "degC",
    "%": "%",
    percent: "%",
    pct: "%",
    ppm: "ppm",
    ppb: "ppb",
    psi: "psi",
    "in wc": "inH2O",
    "in. wc": "inH2O",
    "in h2o": "inH2O",
    "inh2o": "inH2O",
    cfm: "ft3/min",
    gpm: "gal/min",
    kw: "kW",
    kwh: "kW.h",
    hz: "Hz",
    v: "V",
    a: "A",
  };

  return directMap[normalized] ?? rawUnit.trim();
}

export function normalizeUnits(unitValue: string | string[] | undefined): string[] {
  if (!unitValue) {
    return [];
  }

  const values = Array.isArray(unitValue) ? unitValue : [unitValue];
  return dedupeAndSort(values.map((value) => normalizeUnit(value)));
}

function normalizeBinaryLabel(label: string, key: string): string {
  const normalized = label.toLowerCase();

  const contains = (...values: string[]) => values.some((value) => normalized.includes(value));

  if (contains("alarm", "fault", "trip", "alert", "active")) {
    return key === "0" ? "normal" : "alarm";
  }

  if (contains("normal", "ok", "clear", "healthy")) {
    return "normal";
  }

  if (contains("open")) {
    return "open";
  }

  if (contains("closed")) {
    return "closed";
  }

  if (contains("enable", "enabled")) {
    return "enabled";
  }

  if (contains("disable", "disabled")) {
    return "disabled";
  }

  if (contains("run", "running", "start", "started", "on", "occupied")) {
    return "on";
  }

  if (contains("off", "stop", "stopped", "unoccupied")) {
    return "off";
  }

  if (key === "0") {
    return "off";
  }

  if (key === "1") {
    return "on";
  }

  return normalized.replace(/\s+/g, " ").trim();
}

export function normalizeStates(
  states: Record<string, string | string[]> | undefined,
): Record<string, string> | undefined {
  if (!states) {
    return undefined;
  }

  const zero = states["0"];
  const one = states["1"];

  if (zero === undefined || one === undefined) {
    return undefined;
  }

  const firstLabel = (value: string | string[]) =>
    Array.isArray(value) ? value[0] ?? "" : value;

  return {
    "0": normalizeBinaryLabel(firstLabel(zero), "0"),
    "1": normalizeBinaryLabel(firstLabel(one), "1"),
  };
}

function mapPointType(pointFunction: string | undefined, category: string): PointConceptType {
  const source = (pointFunction ?? "").toLowerCase();

  const directMap: Record<string, PointConceptType> = {
    sensor: "sensor",
    command: "command",
    setpoint: "setpoint",
    alarm: "alarm",
    status: "status",
    calculated: "calc",
    enable: "command",
    mode: "status",
    schedule: "status",
  };

  if (source in directMap) {
    return directMap[source];
  }

  return POINT_CATEGORY_DEFAULT_TYPE[category] ?? "sensor";
}

function haystackTokens(haystack: string | undefined): string[] {
  if (!haystack || haystack === "-") {
    return [];
  }

  return dedupeAndSort(
    haystack
      .split(/\s+/)
      .map((token) => token.trim().toLowerCase())
      .filter(Boolean),
  );
}

function equipmentSynonyms(equipment: Omit<EquipmentEntry, "concept">): string[] {
  return dedupeAndSort([
    equipment.name,
    equipment.full_name ?? "",
    equipment.abbreviation ?? "",
    ...(equipment.aliases?.common ?? []),
  ]);
}

export function deterministicTimestamp(cwd: string): string {
  const epochFromEnv = process.env.SOURCE_DATE_EPOCH;
  if (epochFromEnv && /^\d+$/.test(epochFromEnv)) {
    return new Date(Number(epochFromEnv) * 1000).toISOString();
  }

  try {
    const output = execSync("git log -1 --format=%ct", {
      cwd,
      stdio: ["ignore", "pipe", "ignore"],
    })
      .toString("utf8")
      .trim();

    if (/^\d+$/.test(output)) {
      return new Date(Number(output) * 1000).toISOString();
    }
  } catch {
    // fall through to deterministic fallback
  }

  return "1970-01-01T00:00:00.000Z";
}

export function loadSourceData(dataDir: string): {
  points: PointEntry[];
  equipment: EquipmentEntry[];
} {
  const pointFiles = readYamlFiles<PointYamlFile>(path.join(dataDir, "points"));
  const equipmentFiles = readYamlFiles<EquipmentYamlFile>(path.join(dataDir, "equipment"));

  const points: PointEntry[] = pointFiles
    .map((file) => {
      const variants = buildAliasVariants(file.aliases, file.concept.name, file.concept.id);
      const enrichedConcept: PointConcept = {
        ...file.concept,
        kind: "point",
        type: mapPointType(file.concept.point_function, file.concept.category),
        unitsNormalized: normalizeUnits(file.concept.unit),
        statesNormalized: normalizeStates(file.concept.states),
        tags: {
          haystack: haystackTokens(file.concept.haystack),
          brick:
            file.concept.brick && file.concept.brick !== "-"
              ? file.concept.brick
              : undefined,
        },
      };

      return {
        concept: enrichedConcept,
        aliases: {
          ...file.aliases,
          variants,
        },
        notes: file.notes,
        related: file.related,
      };
    })
    .sort((a, b) => a.concept.id.localeCompare(b.concept.id));

  const equipmentRaw: Array<Omit<EquipmentEntry, "concept">> = [];

  for (const file of equipmentFiles) {
    if (Array.isArray(file.equipment)) {
      equipmentRaw.push(...file.equipment);
    } else if (file.equipment) {
      equipmentRaw.push(file.equipment);
    }
  }

  const equipment = equipmentRaw
    .map((entry) => ({
      ...entry,
      concept: {
        kind: "equipment" as const,
        system: EQUIPMENT_CATEGORY_SYSTEM[entry.category],
        synonyms: equipmentSynonyms(entry),
      },
    }))
    .sort((a, b) => a.id.localeCompare(b.id));

  return { points, equipment };
}

function pushWeightedToken(
  target: Map<string, WeightedToken>,
  token: string,
  weight: number,
  source: string,
): void {
  if (!token.trim()) {
    return;
  }

  const normalizedToken = normalizeText(token);
  if (!normalizedToken) {
    return;
  }

  const existing = target.get(normalizedToken);
  if (!existing || existing.weight < weight) {
    target.set(normalizedToken, { token: normalizedToken, weight, source });
  }
}

function tokenNgrams(token: string, n = 3): string[] {
  const compact = token.replace(/\s+/g, "");
  if (compact.length <= n) {
    return [];
  }

  const grams: string[] = [];
  for (let index = 0; index <= compact.length - n; index += 1) {
    grams.push(compact.slice(index, index + n));
  }

  return grams;
}

export function buildSearchIndex(data: BabelData): SearchIndexData {
  const entries: SearchIndexEntry[] = [];

  const addEntry = (
    id: string,
    type: "point" | "equipment",
    name: string,
    input: {
      description?: string;
      haystack?: string;
      commonAliases?: string[];
      misspellings?: string[];
      variants?: AliasVariant[];
      extra?: string[];
    },
  ) => {
    const weightedMap = new Map<string, WeightedToken>();

    pushWeightedToken(weightedMap, id, 10, "id");
    pushWeightedToken(weightedMap, name, 9, "name");
    for (const token of tokenize(name)) {
      pushWeightedToken(weightedMap, token, 8, "name-token");
    }

    for (const alias of input.commonAliases ?? []) {
      pushWeightedToken(weightedMap, alias, 7, "alias-common");
      for (const token of tokenize(alias)) {
        pushWeightedToken(weightedMap, token, 6, "alias-common-token");
      }
    }

    for (const misspelling of input.misspellings ?? []) {
      pushWeightedToken(weightedMap, misspelling, 3, "alias-misspelling");
    }

    for (const variant of input.variants ?? []) {
      const weightByType: Record<AliasVariantType, number> = {
        abbrev: 7,
        expanded: 6,
        vendor: 5,
        format: 5,
        misspelling: 3,
      };
      pushWeightedToken(weightedMap, variant.value, weightByType[variant.type], `alias-variant-${variant.type}`);
    }

    for (const token of tokenize(input.description ?? "")) {
      pushWeightedToken(weightedMap, token, 2, "description");
    }

    for (const tag of tokenize(input.haystack ?? "")) {
      pushWeightedToken(weightedMap, tag, 5, "haystack");
    }

    for (const extra of input.extra ?? []) {
      pushWeightedToken(weightedMap, extra, 4, "extra");
    }

    const weightedTokens = [...weightedMap.values()].sort((a, b) => {
      if (a.weight !== b.weight) {
        return b.weight - a.weight;
      }
      return a.token.localeCompare(b.token);
    });

    const tokens = weightedTokens.map((token) => token.token);
    const ngrams = dedupeAndSort(tokens.flatMap((token) => tokenNgrams(token))).slice(0, 300);

    entries.push({
      id,
      type,
      name,
      tokens,
      weightedTokens,
      ngrams,
    });
  };

  for (const point of data.points) {
    addEntry(point.concept.id, "point", point.concept.name, {
      description: point.concept.description,
      haystack: point.concept.haystack,
      commonAliases: point.aliases.common,
      misspellings: point.aliases.misspellings,
      variants: point.aliases.variants,
      extra: point.concept.tags.haystack,
    });
  }

  for (const equipment of data.equipment) {
    addEntry(equipment.id, "equipment", equipment.name, {
      description: equipment.description,
      haystack: equipment.haystack,
      commonAliases: equipment.aliases.common,
      misspellings: equipment.aliases.misspellings,
      variants: buildAliasVariants(equipment.aliases, equipment.name, equipment.id),
      extra: equipment.concept.synonyms,
    });
  }

  return {
    version: data.version,
    entries: entries.sort((a, b) => a.id.localeCompare(b.id)),
  };
}

export function buildCategories(points: PointEntry[], equipment: EquipmentEntry[], version: string): CategoriesData {
  const pointCounts = new Map<string, number>();
  const equipmentCounts = new Map<string, number>();

  for (const point of points) {
    pointCounts.set(point.concept.category, (pointCounts.get(point.concept.category) ?? 0) + 1);
  }

  for (const entry of equipment) {
    equipmentCounts.set(entry.category, (equipmentCounts.get(entry.category) ?? 0) + 1);
  }

  const categories: Category[] = [];

  for (const [id, count] of pointCounts.entries()) {
    categories.push({
      id,
      name: CATEGORY_DISPLAY_NAMES[id] ?? id,
      type: "points",
      count,
    });
  }

  for (const [id, count] of equipmentCounts.entries()) {
    categories.push({
      id,
      name: CATEGORY_DISPLAY_NAMES[id] ?? id,
      type: "equipment",
      count,
    });
  }

  categories.sort((a, b) => {
    if (a.type !== b.type) {
      return a.type === "equipment" ? -1 : 1;
    }
    return a.name.localeCompare(b.name);
  });

  return {
    version,
    categories,
  };
}

export function loadTemplates(dataDir: string): EquipmentTemplate[] {
  const templateFiles = readYamlFiles<TemplateYamlFile>(path.join(dataDir, "templates"));
  const templates = templateFiles
    .flatMap((file) => file.templates ?? [])
    .map((template) => ({
      ...template,
      requiredPoints: dedupeAndSort(template.requiredPoints ?? []),
      optionalPoints: dedupeAndSort(template.optionalPoints ?? []),
      recommendedPoints: dedupeAndSort(template.recommendedPoints ?? []),
      relationships: [...(template.relationships ?? [])].sort((a, b) => {
        const first = `${a.from}:${a.rel}:${a.to}`;
        const second = `${b.from}:${b.rel}:${b.to}`;
        return first.localeCompare(second);
      }),
      notes: dedupeAndSort(template.notes ?? []),
    }))
    .sort((a, b) => a.id.localeCompare(b.id));

  return templates;
}

export function buildTemplatesData(
  templates: EquipmentTemplate[],
  version: string,
  lastUpdated: string,
): TemplatesData {
  return {
    version,
    lastUpdated,
    templates,
  };
}

export function validateTemplateReferences(
  templates: EquipmentTemplate[],
  data: BabelData,
): string[] {
  const errors: string[] = [];
  const equipmentIds = new Set(data.equipment.map((entry) => entry.id));
  const pointIds = new Set(data.points.map((point) => point.concept.id));

  for (const template of templates) {
    if (!equipmentIds.has(template.equipmentTypeId)) {
      errors.push(`Template ${template.id} references unknown equipmentTypeId: ${template.equipmentTypeId}`);
    }

    const referencedPoints = [
      ...template.requiredPoints,
      ...template.optionalPoints,
      ...template.recommendedPoints,
      ...template.relationships.flatMap((relationship) => [relationship.from, relationship.to]),
    ];

    for (const pointId of referencedPoints) {
      if (!pointIds.has(pointId)) {
        errors.push(`Template ${template.id} references unknown pointId: ${pointId}`);
      }
    }
  }

  return errors;
}

export function buildGraphData(
  data: BabelData,
  templates: EquipmentTemplate[],
  version: string,
  lastUpdated: string,
): GraphData {
  const nodes = new Map<string, GraphNode>();
  const edges: GraphEdge[] = [];

  for (const point of data.points) {
    nodes.set(point.concept.id, {
      id: point.concept.id,
      type: "point",
      name: point.concept.name,
    });

    for (const relatedPointId of point.related ?? []) {
      edges.push({
        from: point.concept.id,
        rel: "related",
        to: relatedPointId,
        source: "point-related",
      });
    }
  }

  for (const equipment of data.equipment) {
    nodes.set(equipment.id, {
      id: equipment.id,
      type: "equipment",
      name: equipment.name,
    });
  }

  for (const template of templates) {
    nodes.set(template.id, {
      id: template.id,
      type: "template",
      name: template.id,
    });

    edges.push({
      from: template.equipmentTypeId,
      rel: "has_template",
      to: template.id,
      source: "template",
    });

    for (const pointId of template.requiredPoints) {
      edges.push({
        from: template.id,
        rel: "requires",
        to: pointId,
        source: "template",
      });
    }

    for (const pointId of template.optionalPoints) {
      edges.push({
        from: template.id,
        rel: "optional",
        to: pointId,
        source: "template",
      });
    }

    for (const pointId of template.recommendedPoints) {
      edges.push({
        from: template.id,
        rel: "recommends",
        to: pointId,
        source: "template",
      });
    }

    for (const relationship of template.relationships) {
      edges.push({
        from: relationship.from,
        rel: relationship.rel,
        to: relationship.to,
        source: "template",
      });
    }
  }

  const dedupedEdges = dedupeAndSort(edges.map((edge) => JSON.stringify(edge))).map((edge) =>
    JSON.parse(edge) as GraphEdge,
  );
  const validEdges = dedupedEdges.filter((edge) => nodes.has(edge.from) && nodes.has(edge.to));

  const adjacency: GraphData["adjacency"] = {};

  for (const edge of validEdges) {
    adjacency[edge.from] ??= [];
    adjacency[edge.from].push({ to: edge.to, rel: edge.rel });
  }

  for (const key of Object.keys(adjacency)) {
    adjacency[key].sort((a, b) => {
      const relCompare = a.rel.localeCompare(b.rel);
      if (relCompare !== 0) {
        return relCompare;
      }
      return a.to.localeCompare(b.to);
    });
  }

  return {
    version,
    lastUpdated,
    nodes: [...nodes.values()].sort((a, b) => a.id.localeCompare(b.id)),
    edges: validEdges.sort((a, b) => {
      const first = `${a.from}:${a.rel}:${a.to}`;
      const second = `${b.from}:${b.rel}:${b.to}`;
      return first.localeCompare(second);
    }),
    adjacency,
  };
}

function computeTokenScore(inputTokens: string[], candidateTokens: string[]): number {
  if (inputTokens.length === 0 || candidateTokens.length === 0) {
    return 0;
  }

  const inputSet = new Set(inputTokens);
  const candidateSet = new Set(candidateTokens);

  let matches = 0;
  for (const token of inputSet) {
    if (candidateSet.has(token)) {
      matches += 1;
      continue;
    }

    const partialMatch = [...candidateSet].some((candidateToken) =>
      candidateToken.length >= 3 && token.length >= 3
        ? candidateToken.includes(token) || token.includes(candidateToken)
        : false,
    );

    if (partialMatch) {
      matches += 0.6;
    }
  }

  return matches / Math.max(inputSet.size, 1);
}

export function normalizePointName(input: string, data: BabelData): NormalizerResult {
  const normalizedName = normalizeText(input);
  if (!normalizedName) {
    return {
      matchedConceptId: null,
      confidence: 0,
      matchType: "none",
      normalizedName,
      suggestedHaystackTags: [],
    };
  }

  const compactInput = normalizedCompareValue(normalizedName);

  let best: {
    pointId: string;
    score: number;
    matchType: NormalizerResult["matchType"];
    tags: string[];
  } | null = null;

  for (const point of data.points) {
    const inputTokens = tokenize(normalizedName);
    const aliases = dedupeAndSort([
      point.concept.id,
      point.concept.name,
      ...(point.aliases.common ?? []),
      ...(point.aliases.misspellings ?? []),
      ...point.aliases.variants.map((variant) => variant.value),
    ]);

    const normalizedAliases = aliases.map((alias) => normalizeText(alias));
    const compactAliases = normalizedAliases.map((alias) => normalizedCompareValue(alias));

    let score = 0;
    let matchType: NormalizerResult["matchType"] = "none";

    if (normalizeText(point.concept.id) === normalizedName || normalizedCompareValue(point.concept.id) === compactInput) {
      score = 1;
      matchType = "exact";
    } else if (
      normalizeText(point.concept.name) === normalizedName ||
      normalizedCompareValue(point.concept.name) === compactInput
    ) {
      score = 0.98;
      matchType = "exact";
    } else if (compactAliases.includes(compactInput)) {
      const nameTokenScore = computeTokenScore(tokenize(normalizedName), tokenize(point.concept.name));
      score = 0.93 + nameTokenScore * 0.05;
      matchType = "alias";
    } else {
      const candidateTokens = dedupeAndSort(
        normalizedAliases.flatMap((value) => tokenize(value)).concat(point.concept.tags.haystack),
      );
      const rawTokenScore = computeTokenScore(inputTokens, candidateTokens);
      if (rawTokenScore >= 0.5) {
        score = rawTokenScore * 0.82;
        matchType = "token";
      } else {
        score = rawTokenScore * 0.65;
        matchType = "ngram";
      }
    }

    if (inputTokens.includes("setpoint") || inputTokens.includes("sp")) {
      if (point.concept.type === "setpoint") {
        score += 0.04;
      }
    } else if (inputTokens.includes("temp") || inputTokens.includes("temperature")) {
      if (point.concept.type === "sensor") {
        score += 0.03;
      } else if (point.concept.type === "setpoint") {
        score -= 0.05;
      }
    }

    if (!best || score > best.score) {
      best = {
        pointId: point.concept.id,
        score,
        matchType,
        tags: point.concept.tags.haystack,
      };
    }
  }

  if (!best || best.score < 0.35) {
    return {
      matchedConceptId: null,
      confidence: best?.score ?? 0,
      matchType: "none",
      normalizedName,
      suggestedHaystackTags: [],
    };
  }

  return {
    matchedConceptId: best.pointId,
    confidence: Number(best.score.toFixed(4)),
    matchType: best.matchType,
    normalizedName,
    suggestedHaystackTags: best.tags,
  };
}

export function findPointCandidates(
  input: string,
  data: BabelData,
  maxCandidates = 3,
): Array<{ pointId: string; confidence: number }> {
  const normalizedName = normalizeText(input);
  const inputTokens = tokenize(normalizedName);

  const candidates = data.points
    .map((point) => {
      const candidateTokens = dedupeAndSort([
        ...tokenize(point.concept.id),
        ...tokenize(point.concept.name),
        ...(point.aliases.common ?? []).flatMap((alias) => tokenize(alias)),
        ...(point.aliases.variants ?? []).flatMap((variant) => tokenize(variant.value)),
      ]);

      const score = computeTokenScore(inputTokens, candidateTokens);
      return {
        pointId: point.concept.id,
        confidence: Number(score.toFixed(4)),
      };
    })
    .filter((candidate) => candidate.confidence > 0.2)
    .sort((a, b) => b.confidence - a.confidence)
    .slice(0, maxCandidates);

  return candidates;
}

function resolveEquipmentId(equipmentTypeId: string, data: BabelData): string | null {
  const normalized = normalizeText(equipmentTypeId);

  for (const equipment of data.equipment) {
    const aliases = dedupeAndSort([
      equipment.id,
      equipment.name,
      equipment.abbreviation ?? "",
      ...(equipment.aliases.common ?? []),
    ]);

    const matches = aliases.some((alias) => normalizedCompareValue(alias) === normalizedCompareValue(normalized));
    if (matches) {
      return equipment.id;
    }
  }

  return null;
}

export function validatePointList(
  equipmentTypeId: string,
  pointNamesOrIds: string[],
  data: BabelData,
  templatesData: TemplatesData,
): ValidatorResult {
  const resolvedEquipmentTypeId = resolveEquipmentId(equipmentTypeId, data) ?? equipmentTypeId;
  const template = templatesData.templates.find((entry) => entry.equipmentTypeId === resolvedEquipmentTypeId);

  if (!template) {
    return {
      matched: [],
      missingRequired: [],
      missingRecommended: [],
      unknown: pointNamesOrIds,
      suggestions: pointNamesOrIds.map((input) => ({
        input,
        candidates: findPointCandidates(input, data),
      })),
    };
  }

  const knownPointIds = new Set(data.points.map((point) => point.concept.id));
  const matched: ValidatorResult["matched"] = [];
  const unknown: string[] = [];
  const suggestions: ValidatorResult["suggestions"] = [];
  const matchedIds = new Set<string>();

  for (const input of pointNamesOrIds) {
    const normalizedInput = normalizeText(input);
    if (knownPointIds.has(normalizedInput)) {
      matched.push({ input, pointId: normalizedInput, confidence: 1 });
      matchedIds.add(normalizedInput);
      continue;
    }

    const normalizedResult = normalizePointName(input, data);
    if (normalizedResult.matchedConceptId && normalizedResult.confidence >= 0.45) {
      matched.push({
        input,
        pointId: normalizedResult.matchedConceptId,
        confidence: normalizedResult.confidence,
      });
      matchedIds.add(normalizedResult.matchedConceptId);
      continue;
    }

    unknown.push(input);
    suggestions.push({
      input,
      candidates: findPointCandidates(input, data),
    });
  }

  const missingRequired = template.requiredPoints.filter((pointId) => !matchedIds.has(pointId));
  const missingRecommended = template.recommendedPoints.filter((pointId) => !matchedIds.has(pointId));

  return {
    matched,
    missingRequired,
    missingRecommended,
    unknown,
    suggestions,
  };
}

export function relatedPoints(
  graph: GraphData,
  pointId: string,
  relTypes?: string[],
): string[] {
  const relSet = relTypes ? new Set(relTypes) : null;
  const outgoing = graph.adjacency[pointId] ?? [];
  return outgoing
    .filter((edge) => (relSet ? relSet.has(edge.rel) : true))
    .map((edge) => edge.to)
    .sort((a, b) => a.localeCompare(b));
}

export function traverseGraph(
  graph: GraphData,
  startId: string,
  options?: { depth?: number; relTypes?: string[] },
): string[] {
  const maxDepth = Math.min(Math.max(options?.depth ?? 2, 1), 5);
  const relSet = options?.relTypes ? new Set(options.relTypes) : null;

  const visited = new Set<string>([startId]);
  const output = new Set<string>();
  const queue: Array<{ id: string; depth: number }> = [{ id: startId, depth: 0 }];

  while (queue.length > 0) {
    const current = queue.shift()!;

    if (current.depth >= maxDepth) {
      continue;
    }

    const outgoing = graph.adjacency[current.id] ?? [];
    for (const edge of outgoing) {
      if (relSet && !relSet.has(edge.rel)) {
        continue;
      }

      if (!visited.has(edge.to)) {
        visited.add(edge.to);
        output.add(edge.to);
        queue.push({ id: edge.to, depth: current.depth + 1 });
      }
    }
  }

  return [...output].sort((a, b) => a.localeCompare(b));
}

export function writeJsonFile(filePath: string, data: unknown): void {
  fs.writeFileSync(filePath, JSON.stringify(data, null, 2) + "\n", "utf8");
}

export function cleanDirectory(dirPath: string): void {
  if (fs.existsSync(dirPath)) {
    fs.rmSync(dirPath, { recursive: true, force: true });
  }
  fs.mkdirSync(dirPath, { recursive: true });
}
