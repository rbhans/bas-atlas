import { spawnSync } from "node:child_process";

const npmCommand = process.platform === "win32" ? "npm.cmd" : "npm";
const passthroughArgs = process.argv.slice(2);

function runScript(scriptName: string) {
  const args = ["run", scriptName];
  if (passthroughArgs.length > 0) {
    args.push("--", ...passthroughArgs);
  }

  const result = spawnSync(npmCommand, args, { stdio: "inherit" });

  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }
}

console.log("Running Atlas core build...\n");
runScript("build:atlas");

console.log("\nRunning catalog build...\n");
runScript("build:catalog");
