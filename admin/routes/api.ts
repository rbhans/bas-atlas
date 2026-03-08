import { Router } from "express";
import { all } from "../db.js";

export const apiRoutes = Router();

apiRoutes.get("/points-search", (req, res) => {
  const q = (req.query.q as string) || "";
  const exclude = ((req.query.exclude as string) || "").split(",").filter(Boolean);
  const contextType = req.query.context_type as string;
  const contextId = req.query.context_id as string;

  if (!q.trim()) return res.send("");

  let points: { id: string; name: string; category: string }[];
  try {
    points = all<{ id: string; name: string; category: string }>(
      `SELECT p.id, p.name, p.category FROM points p
       JOIN search_index si ON si.entry_id = p.id AND si.entry_type = 'point'
       WHERE search_index MATCH ? || '*'
       ORDER BY si.rank LIMIT 20`,
      q.trim(),
    );
  } catch {
    points = all<{ id: string; name: string; category: string }>(
      `SELECT id, name, category FROM points
       WHERE name LIKE '%' || ? || '%' OR id LIKE '%' || ? || '%'
       ORDER BY name LIMIT 20`,
      q.trim(),
      q.trim(),
    );
  }

  const filtered = points.filter((p) => !exclude.includes(p.id));

  let html = "";
  for (const p of filtered) {
    if (contextType === "typical") {
      html += `<div class="search-result"
        hx-post="/equipment/${contextId}/typical-points"
        hx-vals='{"point_id":"${p.id}"}'
        hx-target="#typical-points">
        ${escapeHtml(p.name)} <small class="muted">(${escapeHtml(p.category)})</small>
      </div>`;
    } else if (contextType === "related") {
      html += `<div class="search-result"
        hx-post="/points/${contextId}/related"
        hx-vals='{"point_id":"${p.id}"}'
        hx-target="#point-related">
        ${escapeHtml(p.name)} <small class="muted">(${escapeHtml(p.category)})</small>
      </div>`;
    }
  }

  if (filtered.length === 0) {
    html = '<div style="padding:0.5rem;"><small class="muted">No results</small></div>';
  }

  res.send(html);
});

function escapeHtml(str: string): string {
  return str
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}
