#!/usr/bin/env node
import { spawnSync } from "node:child_process";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const rootDir = path.resolve(__dirname, "..");

const result = spawnSync(
  process.execPath,
  ["--import", "tsx", path.join(rootDir, "scripts", "cli.ts"), ...process.argv.slice(2)],
  {
    cwd: rootDir,
    stdio: "inherit",
  },
);

process.exit(result.status ?? 1);
