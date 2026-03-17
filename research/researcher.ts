import { execSync } from "child_process";
import { chromium, type Browser, type Page } from "playwright";
import fs from "fs";
import path from "path";
import Database from "better-sqlite3";
import type { ScorerTask } from "./scorer.ts";

const DB_PATH = path.join(process.cwd(), "dist", "bas-atlas.db");

export interface ProposedChange {
  sql: string;
  confidence: "high" | "medium" | "low";
  reason: string;
  source_url?: string;
}

export interface ResearchResult {
  task: string;
  source_urls: string[];
  apply: ProposedChange[];
  review: ProposedChange[];
  error?: string;
}

// --- Manufacturer site URLs by brand ---
const BRAND_URLS: Record<string, string[]> = {
  "automated-logic": [
    "https://www.automatedlogic.com/en/products/",
  ],
  belimo: [
    "https://www.belimo.com/us/en_US/products/",
  ],
  "delta-controls": [
    "https://www.deltacontrols.com/products/",
  ],
  "distech-controls": [
    "https://www.distech-controls.com/products/",
  ],
  honeywell: [
    "https://buildings.honeywell.com/us/en/products/by-category",
  ],
  "johnson-controls": [
    "https://www.johnsoncontrols.com/building-automation-and-controls",
  ],
  "schneider-electric": [
    "https://www.se.com/us/en/product-category/building-management/",
  ],
  siemens: [
    "https://www.siemens.com/global/en/products/buildings.html",
  ],
  trane: [
    "https://www.trane.com/commercial/north-america/us/en/controls.html",
  ],
  veris: [
    "https://www.veris.com/Category/702-sensors.aspx",
  ],
};

// --- Standards/ontology URLs ---
const STANDARDS_URLS: Record<string, string[]> = {
  haystack: [
    "https://project-haystack.org/doc/docHaystack/Equips",
    "https://project-haystack.org/doc/docHaystack/Points",
  ],
  brick: [
    "https://brickschema.org/ontology",
  ],
};

// --- Playwright scraping ---

let browser: Browser | null = null;

async function getBrowser(): Promise<Browser> {
  if (!browser) {
    browser = await chromium.launch({ headless: true });
  }
  return browser;
}

export async function closeBrowser(): Promise<void> {
  if (browser) {
    await browser.close();
    browser = null;
  }
}

async function scrapePage(url: string, timeoutMs = 15000): Promise<string> {
  const b = await getBrowser();
  const page: Page = await b.newPage();
  try {
    await page.goto(url, { waitUntil: "domcontentloaded", timeout: timeoutMs });
    // Wait a bit for JS rendering
    await page.waitForTimeout(2000);
    // Extract text content, trimming nav/footer noise
    const content = await page.evaluate(() => {
      // Try to get main content area
      const main =
        document.querySelector("main") ||
        document.querySelector('[role="main"]') ||
        document.querySelector("#content") ||
        document.querySelector(".content") ||
        document.body;
      return main?.innerText?.slice(0, 15000) || "";
    });
    return content;
  } catch (e) {
    return `[Failed to scrape ${url}: ${e instanceof Error ? e.message : String(e)}]`;
  } finally {
    await page.close();
  }
}

async function scrapeMultiple(
  urls: string[],
  maxPages = 10
): Promise<{ url: string; content: string }[]> {
  const results: { url: string; content: string }[] = [];
  for (const url of urls.slice(0, maxPages)) {
    const content = await scrapePage(url);
    if (content && !content.startsWith("[Failed")) {
      results.push({ url, content });
    }
  }
  return results;
}

// --- Current DB state extraction ---

function getCurrentData(
  task: ScorerTask
): { summary: string; details: string } {
  const db = new Database(DB_PATH, { readonly: true });
  try {
    switch (task.category) {
      case "brands": {
        const brands = db
          .prepare("SELECT * FROM brands ORDER BY name")
          .all() as Record<string, unknown>[];
        const models = db
          .prepare(
            "SELECT m.*, b.name as brand_name FROM models m JOIN brands b ON b.id = m.brand_id ORDER BY b.name, m.name"
          )
          .all() as Record<string, unknown>[];
        return {
          summary: `${brands.length} brands, ${models.length} models`,
          details: JSON.stringify({ brands, models }, null, 2).slice(0, 8000),
        };
      }
      case "models": {
        const brandId = task.context.brand_id as string;
        const brand = db
          .prepare("SELECT * FROM brands WHERE id = ?")
          .get(brandId) as Record<string, unknown>;
        const models = db
          .prepare(
            `SELECT m.*, t.name as type_name FROM models m
             JOIN types t ON t.id = m.type_id WHERE m.brand_id = ?`
          )
          .all(brandId) as Record<string, unknown>[];
        const types = db
          .prepare("SELECT * FROM types ORDER BY name")
          .all() as Record<string, unknown>[];
        const protocols = db
          .prepare(
            `SELECT mp.* FROM model_protocols mp
             JOIN models m ON m.id = mp.model_id WHERE m.brand_id = ?`
          )
          .all(brandId) as Record<string, unknown>[];
        return {
          summary: `Brand: ${brand?.name}, ${models.length} models`,
          details: JSON.stringify({ brand, models, types, protocols }, null, 2).slice(0, 8000),
        };
      }
      case "equipment": {
        const equipment = db
          .prepare("SELECT * FROM equipment ORDER BY category, name")
          .all() as Record<string, unknown>[];
        const subtypes = db
          .prepare("SELECT * FROM equipment_subtypes")
          .all() as Record<string, unknown>[];
        return {
          summary: `${equipment.length} equipment types, ${subtypes.length} subtypes`,
          details: JSON.stringify({ equipment, subtypes }, null, 2).slice(0, 8000),
        };
      }
      case "points": {
        const points = db
          .prepare(
            "SELECT id, name, category, kind, point_function, haystack_tag_string FROM points ORDER BY category, name"
          )
          .all() as Record<string, unknown>[];
        const categories = db
          .prepare(
            "SELECT category, COUNT(*) as count FROM points GROUP BY category ORDER BY count DESC"
          )
          .all() as Record<string, unknown>[];
        return {
          summary: `${points.length} points across ${categories.length} categories`,
          details: JSON.stringify({ categories, points: points.slice(0, 100) }, null, 2).slice(
            0,
            8000
          ),
        };
      }
      case "relationships": {
        const unlinked = db
          .prepare(
            `SELECT m.id, m.name, b.name as brand_name, t.name as type_name
             FROM models m
             JOIN brands b ON b.id = m.brand_id
             JOIN types t ON t.id = m.type_id
             WHERE NOT EXISTS (SELECT 1 FROM model_equipment WHERE model_id = m.id)`
          )
          .all() as Record<string, unknown>[];
        const equipment = db
          .prepare("SELECT id, name, category FROM equipment ORDER BY category, name")
          .all() as Record<string, unknown>[];
        return {
          summary: `${unlinked.length} models without equipment links`,
          details: JSON.stringify({ unlinked_models: unlinked, equipment }, null, 2).slice(
            0,
            8000
          ),
        };
      }
      default:
        return { summary: "Unknown category", details: "{}" };
    }
  } finally {
    db.close();
  }
}

// --- Prompt loading ---

function loadPrompt(category: string): string {
  const promptMap: Record<string, string> = {
    brands: "catalog.md",
    models: "catalog.md",
    relationships: "catalog.md",
    equipment: "equipment.md",
    points: "points.md",
  };
  const filename = promptMap[category] || "catalog.md";
  const promptPath = path.join(process.cwd(), "research", "prompts", filename);
  if (fs.existsSync(promptPath)) {
    return fs.readFileSync(promptPath, "utf-8");
  }
  return "You are a BAS (Building Automation Systems) data expert. Output valid SQL.";
}

// --- Claude CLI ---

async function callClaude(prompt: string): Promise<string> {
  // Write prompt to temp file to avoid shell escaping issues
  const tmpFile = path.join(process.cwd(), "research", ".prompt-tmp.txt");
  fs.writeFileSync(tmpFile, prompt);
  try {
    const result = execSync(`cat "${tmpFile}" | claude -p --output-format text`, {
      encoding: "utf-8",
      timeout: 120000, // 2 min
      maxBuffer: 10 * 1024 * 1024,
    });
    return result;
  } catch (e) {
    throw new Error(
      `Claude CLI failed: ${e instanceof Error ? e.message : String(e)}`
    );
  } finally {
    if (fs.existsSync(tmpFile)) fs.unlinkSync(tmpFile);
  }
}

function parseClaudeResponse(response: string): {
  apply: ProposedChange[];
  review: ProposedChange[];
} {
  // Try to extract JSON from the response
  const jsonMatch = response.match(/```json\s*([\s\S]*?)```/);
  const jsonStr = jsonMatch ? jsonMatch[1] : response;

  try {
    const parsed = JSON.parse(jsonStr);
    return {
      apply: Array.isArray(parsed.apply) ? parsed.apply : [],
      review: Array.isArray(parsed.review) ? parsed.review : [],
    };
  } catch {
    // Try to find JSON object in the response
    const objMatch = response.match(/\{[\s\S]*"apply"[\s\S]*\}/);
    if (objMatch) {
      try {
        const parsed = JSON.parse(objMatch[0]);
        return {
          apply: Array.isArray(parsed.apply) ? parsed.apply : [],
          review: Array.isArray(parsed.review) ? parsed.review : [],
        };
      } catch {
        // Fall through
      }
    }
    console.error("[researcher] Failed to parse Claude response as JSON");
    return { apply: [], review: [] };
  }
}

// --- Main research function ---

export async function research(task: ScorerTask): Promise<ResearchResult> {
  console.log(`\n[researcher] Starting: ${task.description}`);

  // 1. Get current DB state
  const currentData = getCurrentData(task);
  console.log(`[researcher] Current data: ${currentData.summary}`);

  // 2. Scrape relevant pages
  let scrapedContent: { url: string; content: string }[] = [];
  const sourceUrls: string[] = [];

  if (task.category === "brands" || task.category === "models") {
    const brandId = (task.context.brand_id as string) || "";
    const urls = BRAND_URLS[brandId] || [];
    if (urls.length > 0) {
      console.log(`[researcher] Scraping ${urls.length} manufacturer pages...`);
      scrapedContent = await scrapeMultiple(urls);
      sourceUrls.push(...scrapedContent.map((s) => s.url));
    }
  } else if (task.category === "equipment" || task.category === "points") {
    const allUrls = [
      ...STANDARDS_URLS.haystack,
      ...STANDARDS_URLS.brick,
    ];
    console.log(`[researcher] Scraping ${allUrls.length} standards pages...`);
    scrapedContent = await scrapeMultiple(allUrls);
    sourceUrls.push(...scrapedContent.map((s) => s.url));
  }

  // 3. Build prompt
  const promptTemplate = loadPrompt(task.category);
  const scrapedText = scrapedContent
    .map((s) => `--- Source: ${s.url} ---\n${s.content}`)
    .join("\n\n");

  const fullPrompt = promptTemplate
    .replace("{{TASK}}", task.description)
    .replace("{{CURRENT_DATA}}", currentData.details)
    .replace("{{SCRAPED_CONTENT}}", scrapedText || "(No scraped content available — use your knowledge of BAS industry products and standards)");

  // 4. Call Claude
  console.log("[researcher] Calling Claude API...");
  let response: string;
  try {
    response = await callClaude(fullPrompt);
  } catch (e) {
    const errMsg = e instanceof Error ? e.message : String(e);
    console.error(`[researcher] Claude API error: ${errMsg}`);
    return {
      task: task.id,
      source_urls: sourceUrls,
      apply: [],
      review: [],
      error: errMsg,
    };
  }

  // 5. Parse response
  const { apply, review } = parseClaudeResponse(response);
  console.log(
    `[researcher] Got ${apply.length} changes to apply, ${review.length} for review`
  );

  // Tag source URLs
  for (const change of [...apply, ...review]) {
    if (!change.source_url && sourceUrls.length > 0) {
      change.source_url = sourceUrls[0];
    }
  }

  return {
    task: task.id,
    source_urls: sourceUrls,
    apply,
    review,
  };
}
