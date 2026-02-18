import fs from "node:fs";
import path from "node:path";
import { normalizePointName } from "../src/core.ts";

const distPath = path.join(process.cwd(), "dist", "index.json");
const data = JSON.parse(fs.readFileSync(distPath, "utf8"));

const input = process.argv.slice(2).join(" ") || "AHU-1 SAT";
const result = normalizePointName(input, data);

console.log(JSON.stringify({ input, ...result }, null, 2));
