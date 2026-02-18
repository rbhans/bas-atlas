import fs from "node:fs";
import path from "node:path";
import Ajv2020 from "ajv/dist/2020";
import addFormats from "ajv-formats";
import {
  validateTemplateReferences,
  type BabelData,
  type GraphData,
  type TemplatesData,
} from "../src/core.ts";

const CWD = process.cwd();
const DIST_DIR = path.join(CWD, "dist");
const SCHEMAS_DIR = path.join(CWD, "schemas");

function loadJson<T>(filePath: string): T {
  return JSON.parse(fs.readFileSync(filePath, "utf8")) as T;
}

function validateFile(
  ajv: Ajv2020,
  schemaFileName: string,
  dataFileName: string,
): void {
  const schemaPath = path.join(SCHEMAS_DIR, schemaFileName);
  const dataPath = path.join(DIST_DIR, dataFileName);
  const schema = loadJson<Record<string, unknown>>(schemaPath);
  const data = loadJson<Record<string, unknown>>(dataPath);
  const validate = ajv.compile(schema);

  if (!validate(data)) {
    throw new Error(
      `Schema validation failed for ${dataFileName} with ${schemaFileName}: ${ajv.errorsText(validate.errors)}`,
    );
  }
}

function validateEntries(
  ajv: Ajv2020,
  schemaFileName: string,
  entries: unknown[],
  label: string,
): void {
  const schemaPath = path.join(SCHEMAS_DIR, schemaFileName);
  const schema = loadJson<Record<string, unknown>>(schemaPath);
  const validate = ajv.compile(schema);

  entries.forEach((entry, index) => {
    if (!validate(entry)) {
      throw new Error(
        `${label}[${index}] failed ${schemaFileName}: ${ajv.errorsText(validate.errors)}`,
      );
    }
  });
}

function validateGraphReferences(graph: GraphData, data: BabelData, templatesData: TemplatesData): void {
  const pointIds = new Set(data.points.map((point) => point.concept.id));
  const equipmentIds = new Set(data.equipment.map((equipment) => equipment.id));
  const templateIds = new Set(templatesData.templates.map((template) => template.id));
  const allowedIds = new Set<string>([...pointIds, ...equipmentIds, ...templateIds]);

  for (const edge of graph.edges) {
    if (!allowedIds.has(edge.from)) {
      throw new Error(`graph edge.from references unknown node: ${edge.from}`);
    }
    if (!allowedIds.has(edge.to)) {
      throw new Error(`graph edge.to references unknown node: ${edge.to}`);
    }
  }
}

async function main(): Promise<void> {
  const ajv = new Ajv2020({ allErrors: true, strict: false });
  addFormats(ajv);

  validateFile(ajv, "index.schema.json", "index.json");
  validateFile(ajv, "categories.schema.json", "categories.json");
  validateFile(ajv, "search-index.schema.json", "search-index.json");
  validateFile(ajv, "templates.schema.json", "templates.json");
  validateFile(ajv, "graph.schema.json", "graph.json");

  const index = loadJson<BabelData>(path.join(DIST_DIR, "index.json"));
  const templates = loadJson<TemplatesData>(path.join(DIST_DIR, "templates.json"));
  const graph = loadJson<GraphData>(path.join(DIST_DIR, "graph.json"));

  validateEntries(ajv, "point.schema.json", index.points, "points");
  validateEntries(ajv, "equipment.schema.json", index.equipment, "equipment");

  const templateErrors = validateTemplateReferences(templates.templates, index);
  if (templateErrors.length > 0) {
    throw new Error(`Template reference validation failed:\n${templateErrors.join("\n")}`);
  }

  validateGraphReferences(graph, index, templates);

  console.log("Validation successful");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
