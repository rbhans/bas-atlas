import { score, printScore, type ScorerTask } from "./scorer.ts";
import { research, closeBrowser } from "./researcher.ts";
import {
  validateChangeset,
  applyChanges,
  createBackup,
  rollback,
} from "./validator.ts";
import type { ProposedChange } from "./researcher.ts";
import { execSync } from "child_process";
import fs from "fs";
import path from "path";

const LOGS_DIR = path.join(process.cwd(), "research", "logs");

// --- CLI args ---
const args = process.argv.slice(2);
const overnight = args.includes("--overnight");
const verifyOnly = args.includes("--verify-only");
const targetArg = args.find((a) => a.startsWith("--target="));
const target = targetArg?.split("=")[1] as string | undefined;
const maxIterations = overnight ? Infinity : 1;

// --- Logging ---

interface LogEntry {
  timestamp: string;
  task: string;
  score_before: number;
  score_after: number;
  applied: number;
  review_count: number;
  rejected: number;
  source_urls: string[];
}

function ensureLogsDir(): void {
  if (!fs.existsSync(LOGS_DIR)) {
    fs.mkdirSync(LOGS_DIR, { recursive: true });
  }
}

function getLogPath(): string {
  const now = new Date();
  const dateStr = now.toISOString().slice(0, 13).replace(/[T:]/g, "-");
  return path.join(LOGS_DIR, `${dateStr}.json`);
}

function getReviewPath(): string {
  const now = new Date();
  const dateStr = now.toISOString().slice(0, 13).replace(/[T:]/g, "-");
  return path.join(LOGS_DIR, `${dateStr}-review.json`);
}

function appendLog(entry: LogEntry): void {
  ensureLogsDir();
  const logPath = getLogPath();
  let logs: LogEntry[] = [];
  if (fs.existsSync(logPath)) {
    logs = JSON.parse(fs.readFileSync(logPath, "utf-8"));
  }
  logs.push(entry);
  fs.writeFileSync(logPath, JSON.stringify(logs, null, 2));
}

function appendReview(task: string, changes: ProposedChange[]): void {
  if (changes.length === 0) return;
  ensureLogsDir();
  const reviewPath = getReviewPath();
  let reviews: Array<{ task: string; changes: ProposedChange[] }> = [];
  if (fs.existsSync(reviewPath)) {
    reviews = JSON.parse(fs.readFileSync(reviewPath, "utf-8"));
  }
  reviews.push({ task, changes });
  fs.writeFileSync(reviewPath, JSON.stringify(reviews, null, 2));
}

// --- Git ---

function gitCommit(message: string): boolean {
  try {
    execSync("git add dist/bas-atlas.db", { cwd: process.cwd(), stdio: "pipe" });
    execSync(`git commit -m "${message}"`, {
      cwd: process.cwd(),
      stdio: "pipe",
    });
    console.log(`[runner] Committed: ${message}`);
    return true;
  } catch {
    console.log("[runner] Git commit failed (no changes?)");
    return false;
  }
}

// --- Main loop ---

async function run(): Promise<void> {
  console.log("=".repeat(60));
  console.log("  BAS Atlas Research Pipeline");
  console.log(
    `  Mode: ${overnight ? "overnight (loop)" : "single pass"}${verifyOnly ? " [verify-only]" : ""}${target ? ` [target: ${target}]` : ""}`
  );
  console.log("=".repeat(60));

  // Initial score
  let result = score();
  printScore(result);

  let iteration = 0;

  while (iteration < maxIterations) {
    iteration++;
    console.log(`\n${"─".repeat(60)}`);
    console.log(`  Iteration ${iteration}`);
    console.log(`${"─".repeat(60)}`);

    // Filter tasks by target if specified
    let tasks = result.tasks;
    if (target) {
      tasks = tasks.filter((t) => t.category === target);
    }
    if (verifyOnly) {
      tasks = tasks.filter(
        (t) =>
          t.id.startsWith("verify-") ||
          t.id.startsWith("fix-") ||
          t.description.toLowerCase().includes("verify")
      );
    }

    if (tasks.length === 0) {
      console.log("\n[runner] No tasks available. Done!");
      break;
    }

    // Pick top task
    const task = tasks[0];
    console.log(`\n[runner] Task: ${task.description}`);
    console.log(`[runner] Category: ${task.category}, Priority: ${task.priority.toFixed(1)}`);

    // Create backup
    const backupPath = createBackup();
    const scoreBefore = result.overallScore;

    // Research
    const researchResult = await research(task);

    if (researchResult.error) {
      console.log(`[runner] Research failed: ${researchResult.error}`);
      if (!overnight) break;
      continue;
    }

    // Validate
    const allChanges = [...researchResult.apply, ...researchResult.review];
    if (allChanges.length === 0) {
      console.log("[runner] No changes proposed. Skipping.");
      if (!overnight) break;
      continue;
    }

    const validated = validateChangeset(allChanges);
    console.log(
      `[runner] Validated: ${validated.apply.length} to apply, ${validated.review.length} for review, ${validated.rejected.length} rejected`
    );

    // Log rejected
    if (validated.rejected.length > 0) {
      for (const r of validated.rejected) {
        console.log(`  [rejected] ${r.error}: ${r.sql.slice(0, 80)}...`);
      }
    }

    // Save review items
    appendReview(task.id, validated.review);
    if (validated.review.length > 0) {
      console.log(
        `[runner] ${validated.review.length} changes saved for review → ${getReviewPath()}`
      );
    }

    // Apply changes
    if (validated.apply.length > 0) {
      const { applied, errors } = applyChanges(validated.apply);
      console.log(`[runner] Applied ${applied} changes`);
      for (const err of errors) {
        console.log(`  [error] ${err}`);
      }

      // Re-score
      result = score();
      const scoreAfter = result.overallScore;
      const delta = scoreAfter - scoreBefore;

      console.log(
        `[runner] Score: ${scoreBefore.toFixed(1)} → ${scoreAfter.toFixed(1)} (${delta >= 0 ? "+" : ""}${delta.toFixed(1)})`
      );

      if (delta >= 0) {
        // Score improved or stayed same — commit
        gitCommit(
          `research: ${task.description} (+${applied} changes, score ${scoreBefore.toFixed(1)}→${scoreAfter.toFixed(1)})`
        );
      } else {
        // Score dropped — rollback
        console.log("[runner] Score dropped! Rolling back.");
        rollback(backupPath);
        result = score(); // re-score after rollback
      }

      // Log
      appendLog({
        timestamp: new Date().toISOString(),
        task: task.id,
        score_before: scoreBefore,
        score_after: scoreAfter,
        applied,
        review_count: validated.review.length,
        rejected: validated.rejected.length,
        source_urls: researchResult.source_urls,
      });
    }

    if (!overnight) break;

    // Brief pause between iterations to be kind to APIs
    console.log("[runner] Waiting 5s before next iteration...");
    await new Promise((resolve) => setTimeout(resolve, 5000));
  }

  // Final score
  console.log(`\n${"=".repeat(60)}`);
  console.log("  Final Score");
  console.log("=".repeat(60));
  result = score();
  printScore(result);

  // Cleanup
  await closeBrowser();

  // Show review file location if any reviews exist
  const reviewPath = getReviewPath();
  if (fs.existsSync(reviewPath)) {
    const reviews = JSON.parse(fs.readFileSync(reviewPath, "utf-8"));
    const totalReview = reviews.reduce(
      (sum: number, r: { changes: unknown[] }) => sum + r.changes.length,
      0
    );
    if (totalReview > 0) {
      console.log(`\n📋 ${totalReview} changes need your review: ${reviewPath}`);
    }
  }
}

run().catch((e) => {
  console.error("[runner] Fatal error:", e);
  closeBrowser().finally(() => process.exit(1));
});
