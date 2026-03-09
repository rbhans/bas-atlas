import { Router } from "express";
import { all } from "../db.js";

export const searchRoutes = Router();

searchRoutes.get("/", (req, res) => {
  const q = (req.query.q as string) || "";
  let results: Record<string, unknown>[] = [];

  if (q.trim()) {
    try {
      results = all<Record<string, unknown>>(
        `SELECT entry_id, entry_type, name, rank
         FROM search_index
         WHERE search_index MATCH ? || '*'
         ORDER BY rank
         LIMIT 50`,
        q.trim(),
      );
    } catch {
      // FTS5 query syntax error — fall back to empty results
      results = [];
    }
  }

  if (res.locals.isHtmx) {
    return res.render("search/_results", { results, q });
  }

  res.render("search", { pageTitle: "Search", results, q });
});
