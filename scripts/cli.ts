import fs from "node:fs";
import path from "node:path";
import {
  normalizePointName,
  validatePointList,
  type BabelData,
  type TemplatesData,
} from "../src/core.ts";

function loadJson<T>(filePath: string): T {
  return JSON.parse(fs.readFileSync(filePath, "utf8")) as T;
}

function usage(): void {
  console.log(`bas-babel CLI

Commands:
  validate --equipment <equipmentTypeId> --file <path-to-point-list>
  normalize --name <point-name>
`);
}

function parseArg(flag: string): string | null {
  const index = process.argv.findIndex((arg) => arg === flag);
  if (index < 0) {
    return null;
  }
  return process.argv[index + 1] ?? null;
}

async function run(): Promise<void> {
  const command = process.argv[2];
  const distDir = path.join(process.cwd(), "dist");
  const index = loadJson<BabelData>(path.join(distDir, "index.json"));
  const templates = loadJson<TemplatesData>(path.join(distDir, "templates.json"));

  if (!command || command === "--help" || command === "-h") {
    usage();
    return;
  }

  if (command === "validate") {
    const equipment = parseArg("--equipment");
    const filePath = parseArg("--file");

    if (!equipment || !filePath) {
      throw new Error("validate requires --equipment and --file");
    }

    const fileContent = fs.readFileSync(path.resolve(filePath), "utf8");
    const points = fileContent
      .split(/\r?\n/)
      .map((line) => line.trim())
      .filter(Boolean);

    const result = validatePointList(equipment, points, index, templates);
    console.log(JSON.stringify(result, null, 2));
    return;
  }

  if (command === "normalize") {
    const pointName = parseArg("--name");
    if (!pointName) {
      throw new Error("normalize requires --name");
    }

    const result = normalizePointName(pointName, index);
    console.log(JSON.stringify(result, null, 2));
    return;
  }

  usage();
  process.exitCode = 1;
}

run().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
