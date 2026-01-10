import * as fs from "fs";
import * as path from "path";
import { parse as parseYaml, stringify as stringifyYaml } from "yaml";

const DATA_DIR = path.join(process.cwd(), "data");

// Common word abbreviations used in BAS
const abbreviations: Record<string, string[]> = {
  // Temperature related
  temperature: ["temp", "t", "tmp"],
  temp: ["temperature", "t", "tmp"],

  // Air related
  air: ["a", "ar"],
  supply: ["sup", "sa", "s", "sply"],
  return: ["ret", "ra", "r", "rtn"],
  outside: ["oa", "out", "outdoor", "o", "otsd"],
  outdoor: ["oa", "out", "outside", "o", "otsd"],
  mixed: ["ma", "mix", "m", "mxd"],
  exhaust: ["exh", "ea", "ex", "e"],
  relief: ["rel", "ra", "rlf"],
  discharge: ["da", "dis", "disch", "dschg"],

  // Equipment
  fan: ["f", "fn"],
  pump: ["p", "pmp"],
  valve: ["vlv", "v", "vv"],
  damper: ["dmp", "dmpr", "d"],
  coil: ["cl", "c"],
  motor: ["mtr", "m"],
  unit: ["u", "unt"],

  // System types
  chilled: ["chl", "ch", "chw", "cld"],
  chiller: ["chl", "ch", "chlr"],
  hot: ["ht", "hw", "h"],
  heating: ["htg", "heat", "ht", "h"],
  cooling: ["clg", "cool", "cl", "c"],
  condenser: ["cnd", "cw", "cond", "cdw"],
  boiler: ["blr", "b", "boil"],
  water: ["w", "wtr"],
  steam: ["stm", "st", "s"],

  // Control points
  setpoint: ["sp", "stpt", "set", "spt"],
  command: ["cmd", "c", "com"],
  status: ["sts", "stat", "st", "s"],
  enable: ["en", "enbl", "e"],
  output: ["out", "o", "op"],
  feedback: ["fb", "fdbk", "fdbck"],
  alarm: ["alm", "al", "a"],

  // Position/state
  position: ["pos", "p", "psn"],
  speed: ["spd", "s", "sp"],
  frequency: ["freq", "frq", "f", "hz"],

  // Measurements
  pressure: ["press", "prs", "p", "pr"],
  differential: ["diff", "dif", "d", "dp"],
  static: ["stat", "stc", "st", "s"],
  humidity: ["hum", "rh", "h"],
  relative: ["rel", "r"],
  dewpoint: ["dp", "dew", "dwpt"],
  enthalpy: ["enth", "ent", "h"],
  flow: ["flw", "fl", "f"],
  level: ["lvl", "lv", "l"],
  current: ["cur", "amp", "a", "i"],
  voltage: ["volt", "v", "vlt"],
  power: ["pwr", "pw", "p", "kw"],
  energy: ["nrg", "e", "kwh"],

  // Zones and spaces
  zone: ["zn", "z"],
  room: ["rm", "r"],
  space: ["spc", "sp", "s"],
  building: ["bldg", "bld", "b"],
  floor: ["flr", "fl", "f"],

  // Time/modes
  occupied: ["occ", "oc", "o"],
  unoccupied: ["unocc", "unoc", "un", "u"],
  standby: ["stby", "sby", "sb"],

  // Equipment types
  handling: ["hndl", "hnd", "h"],
  rooftop: ["rt", "rtu", "roof"],
  variable: ["var", "v", "vr"],
  constant: ["const", "con", "c"],
  primary: ["pri", "prim", "p"],
  secondary: ["sec", "scnd", "s"],
  tertiary: ["ter", "tert", "t"],

  // Components
  economizer: ["econ", "eco", "e"],
  humidifier: ["hum", "humid", "h"],
  dehumidifier: ["dehum", "dh"],
  filter: ["flt", "fil", "f"],
  wheel: ["whl", "wh", "w"],
  heat: ["ht", "h"],

  // Locations
  entering: ["ent", "entr", "e", "in"],
  leaving: ["lvg", "leav", "lv", "l", "out"],
  inlet: ["in", "inlt", "i"],
  outlet: ["out", "outlt", "o"],
  basin: ["bsn", "bas", "b"],

  // Actions
  run: ["r", "rn"],
  start: ["str", "st", "s"],
  stop: ["stp", "st", "s"],
  reset: ["rst", "res", "r"],

  // Tower/plant
  tower: ["twr", "tw", "t"],
  plant: ["plt", "pl", "p"],

  // Misc
  electric: ["elec", "el", "e"],
  gas: ["g", "gs"],
  fired: ["frd", "fr", "f"],
  isolation: ["iso", "isol", "i"],
  bypass: ["byp", "bp", "b"],
  mixing: ["mix", "mx", "m"],
  face: ["fc", "f"],
  stage: ["stg", "stge", "st"],
};

// Verbose expansions
const verboseExpansions: Record<string, string[]> = {
  temp: ["temperature"],
  t: ["temperature", "temp"],
  sa: ["supply air"],
  ra: ["return air", "relief air"],
  oa: ["outside air", "outdoor air"],
  ma: ["mixed air"],
  ea: ["exhaust air"],
  da: ["discharge air"],
  sp: ["setpoint", "static pressure"],
  dp: ["differential pressure", "dewpoint"],
  rh: ["relative humidity"],
  chw: ["chilled water"],
  hw: ["hot water"],
  cw: ["condenser water"],
  ahu: ["air handling unit", "air handler"],
  rtu: ["rooftop unit"],
  vav: ["variable air volume"],
  fcu: ["fan coil unit"],
  vrf: ["variable refrigerant flow"],
  cmd: ["command"],
  sts: ["status"],
  fb: ["feedback"],
  alm: ["alarm"],
  vlv: ["valve"],
  dmp: ["damper"],
  pmp: ["pump"],
  mtr: ["motor"],
};

// Generate all variations of a name
function generateVariations(name: string, existingAliases: string[]): string[] {
  const variations = new Set<string>();
  const nameLower = name.toLowerCase();
  const words = nameLower.split(/[\s-]+/);

  // Add the full name
  variations.add(nameLower);

  // Generate abbreviated versions
  generateAbbreviatedVersions(words, variations);

  // Generate hyphenated versions
  generateHyphenatedVersions(words, variations);

  // Generate verbose versions (expand abbreviations)
  generateVerboseVersions(words, variations);

  // Generate mixed versions (some abbreviated, some not)
  generateMixedVersions(words, variations);

  // Add existing aliases and their variations
  for (const alias of existingAliases) {
    variations.add(alias.toLowerCase());
    const aliasWords = alias.toLowerCase().split(/[\s-]+/);
    generateAbbreviatedVersions(aliasWords, variations);
  }

  // Remove the original name and empty strings
  variations.delete(nameLower);
  variations.delete("");

  // Filter out single character aliases (too ambiguous) unless they're common like "t" for temp
  const filtered = Array.from(variations).filter(v => {
    if (v.length <= 1) return false;
    if (v.length === 2 && !["sa", "ra", "oa", "ma", "ea", "da", "sp", "dp", "rh", "hw", "cw", "fb"].includes(v)) {
      return false;
    }
    return true;
  });

  return filtered.sort();
}

function generateAbbreviatedVersions(words: string[], variations: Set<string>): void {
  // Full abbreviation (first letters)
  const initials = words.map(w => w[0]).join("");
  if (initials.length >= 2) {
    variations.add(initials);
    variations.add(initials.split("").join("-")); // e.g., "s-a-t"
  }

  // Replace each word with its abbreviations
  const abbrevCombos = generateWordCombinations(words, abbreviations);
  for (const combo of abbrevCombos) {
    variations.add(combo.join(" "));
    variations.add(combo.join("-"));
    variations.add(combo.join(""));
  }
}

function generateHyphenatedVersions(words: string[], variations: Set<string>): void {
  // Hyphenated full
  variations.add(words.join("-"));

  // Hyphenated with common abbreviations
  const abbrevWords = words.map(w => {
    const abbrevs = abbreviations[w];
    return abbrevs && abbrevs.length > 0 ? abbrevs[0] : w;
  });
  variations.add(abbrevWords.join("-"));
}

function generateVerboseVersions(words: string[], variations: Set<string>): void {
  // Expand any abbreviations to verbose forms
  for (let i = 0; i < words.length; i++) {
    const word = words[i];
    const expansions = verboseExpansions[word];
    if (expansions) {
      for (const expansion of expansions) {
        const newWords = [...words];
        newWords[i] = expansion;
        variations.add(newWords.join(" "));
      }
    }
  }
}

function generateMixedVersions(words: string[], variations: Set<string>): void {
  if (words.length < 2) return;

  // First word abbreviated, rest full
  const firstAbbrev = abbreviations[words[0]];
  if (firstAbbrev && firstAbbrev.length > 0) {
    variations.add([firstAbbrev[0], ...words.slice(1)].join(" "));
    variations.add([firstAbbrev[0], ...words.slice(1)].join("-"));
  }

  // Last word abbreviated, rest full
  const lastAbbrev = abbreviations[words[words.length - 1]];
  if (lastAbbrev && lastAbbrev.length > 0) {
    variations.add([...words.slice(0, -1), lastAbbrev[0]].join(" "));
    variations.add([...words.slice(0, -1), lastAbbrev[0]].join("-"));
  }

  // Common pairs abbreviated
  if (words.length >= 2) {
    const first = words[0];
    const second = words[1];

    // Common two-word abbreviations
    const twoWordAbbrevs: Record<string, string> = {
      "supply air": "sa",
      "return air": "ra",
      "outside air": "oa",
      "outdoor air": "oa",
      "mixed air": "ma",
      "exhaust air": "ea",
      "discharge air": "da",
      "chilled water": "chw",
      "hot water": "hw",
      "condenser water": "cw",
      "static pressure": "sp",
      "differential pressure": "dp",
      "relative humidity": "rh",
      "air handling": "ah",
      "fan coil": "fc",
      "heat wheel": "hw",
      "cooling tower": "ct",
    };

    const twoWord = `${first} ${second}`;
    const abbrev = twoWordAbbrevs[twoWord];
    if (abbrev && words.length > 2) {
      variations.add([abbrev, ...words.slice(2)].join(" "));
      variations.add([abbrev, ...words.slice(2)].join("-"));
    }
  }
}

function generateWordCombinations(words: string[], abbrevMap: Record<string, string[]>): string[][] {
  const results: string[][] = [];

  // Generate a few key combinations (not all permutations to avoid explosion)
  // All abbreviated (first abbreviation of each)
  const allAbbrev = words.map(w => {
    const abbrevs = abbrevMap[w];
    return abbrevs && abbrevs.length > 0 ? abbrevs[0] : w;
  });
  results.push(allAbbrev);

  // All abbreviated (second abbreviation if available)
  const allAbbrev2 = words.map(w => {
    const abbrevs = abbrevMap[w];
    return abbrevs && abbrevs.length > 1 ? abbrevs[1] : (abbrevs && abbrevs.length > 0 ? abbrevs[0] : w);
  });
  if (allAbbrev2.join("") !== allAbbrev.join("")) {
    results.push(allAbbrev2);
  }

  return results;
}

// Process a single point file
function processPointFile(filePath: string): boolean {
  const content = fs.readFileSync(filePath, "utf-8");
  const data = parseYaml(content);

  if (!data.concept || !data.concept.name) {
    return false;
  }

  const name = data.concept.name;
  const existingAliases = data.aliases?.common || [];

  const newAliases = generateVariations(name, existingAliases);

  // Merge with existing, removing duplicates
  const mergedAliases = [...new Set([...existingAliases, ...newAliases])];

  // Sort: shorter aliases first, then alphabetically
  mergedAliases.sort((a, b) => {
    if (a.length !== b.length) return a.length - b.length;
    return a.localeCompare(b);
  });

  // Only update if we added new aliases
  if (mergedAliases.length > existingAliases.length) {
    data.aliases = data.aliases || {};
    data.aliases.common = mergedAliases;

    const yamlContent = stringifyYaml(data, { lineWidth: 0 });
    fs.writeFileSync(filePath, yamlContent);

    console.log(`  ${path.basename(filePath)}: ${existingAliases.length} → ${mergedAliases.length} aliases`);
    return true;
  }

  return false;
}

// Process equipment files (multiple entries per file)
function processEquipmentFile(filePath: string): number {
  const content = fs.readFileSync(filePath, "utf-8");
  const data = parseYaml(content);

  if (!data.equipment || !Array.isArray(data.equipment)) {
    return 0;
  }

  let updatedCount = 0;

  for (const equip of data.equipment) {
    if (!equip.name) continue;

    const name = equip.name;
    const existingAliases = equip.aliases?.common || [];

    // Include abbreviation in variations
    const extraAliases = equip.abbreviation ? [equip.abbreviation.toLowerCase()] : [];
    const newAliases = generateVariations(name, [...existingAliases, ...extraAliases]);

    const mergedAliases = [...new Set([...existingAliases, ...newAliases])];
    mergedAliases.sort((a, b) => {
      if (a.length !== b.length) return a.length - b.length;
      return a.localeCompare(b);
    });

    if (mergedAliases.length > existingAliases.length) {
      equip.aliases = equip.aliases || {};
      equip.aliases.common = mergedAliases;
      updatedCount++;
      console.log(`  ${equip.id}: ${existingAliases.length} → ${mergedAliases.length} aliases`);
    }
  }

  if (updatedCount > 0) {
    const yamlContent = stringifyYaml(data, { lineWidth: 0 });
    fs.writeFileSync(filePath, yamlContent);
  }

  return updatedCount;
}

// Find all YAML files recursively
function findYamlFiles(dir: string): string[] {
  const results: string[] = [];
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

// Main
console.log("Expanding aliases for all points and equipment...\n");

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
