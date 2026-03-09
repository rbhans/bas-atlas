import { Router } from "express";
import { get } from "../db.js";

export const dashboardRoutes = Router();

dashboardRoutes.get("/", (_req, res) => {
  const counts = {
    points: get<{ count: number }>(`SELECT COUNT(*) as count FROM points`)!
      .count,
    equipment: get<{ count: number }>(
      `SELECT COUNT(*) as count FROM equipment`,
    )!.count,
    brands: get<{ count: number }>(`SELECT COUNT(*) as count FROM brands`)!
      .count,
    types: get<{ count: number }>(`SELECT COUNT(*) as count FROM types`)!
      .count,
    models: get<{ count: number }>(`SELECT COUNT(*) as count FROM models`)!
      .count,
    pointCategories: get<{ count: number }>(
      `SELECT COUNT(DISTINCT category) as count FROM points`,
    )!.count,
    equipCategories: get<{ count: number }>(
      `SELECT COUNT(DISTINCT category) as count FROM equipment`,
    )!.count,
  };
  const meta = get<{ value: string }>(
    `SELECT value FROM meta WHERE key = 'lastUpdated'`,
  );

  res.render("dashboard", {
    pageTitle: "Dashboard",
    counts,
    lastUpdated: meta?.value || "Unknown",
  });
});
