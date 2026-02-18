import fs from "node:fs";
import path from "node:path";

const distPath = path.join(process.cwd(), "dist", "search-index.json");
const searchIndex = JSON.parse(fs.readFileSync(distPath, "utf8"));

const query = (process.argv.slice(2).join(" ") || "zone temp").toLowerCase();
const queryTokens = query.split(/\s+/).filter(Boolean);

const scored = searchIndex.entries
  .map((entry) => {
    const tokenSet = new Set(entry.tokens);
    const score = queryTokens.reduce((count, token) => count + (tokenSet.has(token) ? 1 : 0), 0);
    return { id: entry.id, type: entry.type, name: entry.name, score };
  })
  .filter((entry) => entry.score > 0)
  .sort((a, b) => b.score - a.score)
  .slice(0, 10);

console.log(JSON.stringify({ query, results: scored }, null, 2));
