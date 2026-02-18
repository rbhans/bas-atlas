import path from "node:path";
import fs from "node:fs";
import {
  buildCategories,
  buildGraphData,
  buildSearchIndex,
  buildTemplatesData,
  cleanDirectory,
  deterministicTimestamp,
  loadSourceData,
  loadTemplates,
  validateTemplateReferences,
  writeJsonFile,
  type BabelData,
} from "../src/core.ts";

const CWD = process.cwd();
const DATA_DIR = path.join(CWD, "data");
const DIST_DIR = path.join(CWD, "dist");
const PACKAGE_JSON_PATH = path.join(CWD, "package.json");

const CLEAN = process.argv.includes("--clean");

interface PackageJson {
  version?: string;
}

function readDatasetVersion(): string {
  try {
    const packageJson = JSON.parse(fs.readFileSync(PACKAGE_JSON_PATH, "utf8")) as PackageJson;
    return packageJson.version ?? "1.0.0";
  } catch {
    return "1.0.0";
  }
}

async function main(): Promise<void> {
  const version = readDatasetVersion();
  const lastUpdated = deterministicTimestamp(CWD);

  if (CLEAN) {
    cleanDirectory(DIST_DIR);
  }
  if (!CLEAN && !fs.existsSync(DIST_DIR)) {
    fs.mkdirSync(DIST_DIR, { recursive: true });
  }

  const { points, equipment } = loadSourceData(DATA_DIR);

  const index: BabelData = {
    version,
    lastUpdated,
    totalPoints: points.length,
    totalEquipment: equipment.length,
    points,
    equipment,
  };

  const categories = buildCategories(points, equipment, version);
  const searchIndex = buildSearchIndex(index);
  const templates = loadTemplates(DATA_DIR);
  const templateReferenceErrors = validateTemplateReferences(templates, index);

  if (templateReferenceErrors.length > 0) {
    throw new Error(`Template reference validation failed:\n${templateReferenceErrors.join("\n")}`);
  }

  const templatesData = buildTemplatesData(templates, version, lastUpdated);
  const graphData = buildGraphData(index, templates, version, lastUpdated);

  writeJsonFile(path.join(DIST_DIR, "index.json"), index);
  writeJsonFile(path.join(DIST_DIR, "categories.json"), categories);
  writeJsonFile(path.join(DIST_DIR, "search-index.json"), searchIndex);
  writeJsonFile(path.join(DIST_DIR, "templates.json"), templatesData);
  writeJsonFile(path.join(DIST_DIR, "graph.json"), graphData);

  console.log("Build complete:");
  console.log(`  version: ${version}`);
  console.log(`  lastUpdated: ${lastUpdated}`);
  console.log(`  points: ${points.length}`);
  console.log(`  equipment: ${equipment.length}`);
  console.log(`  templates: ${templates.length}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
