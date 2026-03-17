import Database from "better-sqlite3";
import path from "path";

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

export interface Metric {
  name: string;
  weight: number;
  score: number; // 0-1
  current: number; // current value
  target: number; // target value
  description: string; // human readable
}

export interface ScorerTask {
  id: string; // e.g. "add-models-honeywell"
  category: "brands" | "models" | "equipment" | "points" | "relationships";
  priority: number; // higher = more important
  description: string; // what to do
  context: Record<string, unknown>; // data the researcher needs
}

export interface ScoreResult {
  overallScore: number; // 0-100
  metrics: Metric[];
  tasks: ScorerTask[];
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function cap(value: number, max: number = 1): number {
  return Math.min(value, max);
}

function slugify(text: string): string {
  return text.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, "");
}

// ---------------------------------------------------------------------------
// Scorer
// ---------------------------------------------------------------------------

export function score(): ScoreResult {
  const dbPath = path.join(process.cwd(), "dist", "bas-atlas.db");
  const db = new Database(dbPath, { readonly: true });
  db.pragma("foreign_keys = ON");

  try {
    const metrics: Metric[] = [];
    const tasks: ScorerTask[] = [];

    // -----------------------------------------------------------------------
    // 1. brand_descriptions (weight 5)
    // -----------------------------------------------------------------------
    const totalBrands = (db.prepare(`SELECT COUNT(*) as c FROM brands`).get() as { c: number }).c;
    const brandsWithDesc = (db.prepare(
      `SELECT COUNT(*) as c FROM brands WHERE description IS NOT NULL AND description != ''`,
    ).get() as { c: number }).c;
    const brandDescScore = totalBrands > 0 ? brandsWithDesc / totalBrands : 0;
    metrics.push({
      name: "brand_descriptions",
      weight: 5,
      score: brandDescScore,
      current: brandsWithDesc,
      target: totalBrands,
      description: `${brandsWithDesc}/${totalBrands} brands have descriptions`,
    });

    if (brandDescScore < 1 && totalBrands > 0) {
      const missing = db.prepare(
        `SELECT id, name FROM brands WHERE description IS NULL OR description = '' ORDER BY name`,
      ).all() as { id: string; name: string }[];
      tasks.push({
        id: "add-brand-descriptions",
        category: "brands",
        priority: 5 * (1 - brandDescScore),
        description: `Add descriptions to ${missing.length} brand(s)`,
        context: { brands: missing },
      });
    }

    // -----------------------------------------------------------------------
    // 2. brand_logos (weight 3)
    // -----------------------------------------------------------------------
    const brandsWithLogo = (db.prepare(
      `SELECT COUNT(*) as c FROM brands WHERE logo_url IS NOT NULL AND logo_url != ''`,
    ).get() as { c: number }).c;
    const brandLogoScore = totalBrands > 0 ? brandsWithLogo / totalBrands : 0;
    metrics.push({
      name: "brand_logos",
      weight: 3,
      score: brandLogoScore,
      current: brandsWithLogo,
      target: totalBrands,
      description: `${brandsWithLogo}/${totalBrands} brands have logos`,
    });

    if (brandLogoScore < 1 && totalBrands > 0) {
      const missing = db.prepare(
        `SELECT id, name FROM brands WHERE logo_url IS NULL OR logo_url = '' ORDER BY name`,
      ).all() as { id: string; name: string }[];
      tasks.push({
        id: "add-brand-logos",
        category: "brands",
        priority: 3 * (1 - brandLogoScore),
        description: `Add logo URLs to ${missing.length} brand(s)`,
        context: { brands: missing },
      });
    }

    // -----------------------------------------------------------------------
    // 3. models_per_brand (weight 10)
    // -----------------------------------------------------------------------
    const TARGET_MODELS_PER_BRAND = 15;
    const totalModels = (db.prepare(`SELECT COUNT(*) as c FROM models`).get() as { c: number }).c;
    const avgModelsPerBrand = totalBrands > 0 ? totalModels / totalBrands : 0;
    const modelsPerBrandScore = cap(avgModelsPerBrand / TARGET_MODELS_PER_BRAND);
    metrics.push({
      name: "models_per_brand",
      weight: 10,
      score: modelsPerBrandScore,
      current: Math.round(avgModelsPerBrand * 10) / 10,
      target: TARGET_MODELS_PER_BRAND,
      description: `Avg ${(avgModelsPerBrand).toFixed(1)} models/brand (target: ${TARGET_MODELS_PER_BRAND})`,
    });

    const brandModelCounts = db.prepare(
      `SELECT b.id, b.name, COUNT(m.id) as model_count
       FROM brands b LEFT JOIN models m ON m.brand_id = b.id
       GROUP BY b.id ORDER BY model_count ASC`,
    ).all() as { id: string; name: string; model_count: number }[];

    for (const b of brandModelCounts) {
      if (b.model_count < TARGET_MODELS_PER_BRAND) {
        tasks.push({
          id: `add-models-${slugify(b.name)}`,
          category: "models",
          priority: 10 * ((TARGET_MODELS_PER_BRAND - b.model_count) / TARGET_MODELS_PER_BRAND),
          description: `Add models for ${b.name} (currently ${b.model_count}/${TARGET_MODELS_PER_BRAND})`,
          context: { brand_id: b.id, brand_name: b.name, current_count: b.model_count },
        });
      }
    }

    // -----------------------------------------------------------------------
    // 4. model_protocols (weight 5)
    // -----------------------------------------------------------------------
    const modelsWithProtocol = (db.prepare(
      `SELECT COUNT(DISTINCT model_id) as c FROM model_protocols`,
    ).get() as { c: number }).c;
    const modelProtocolScore = totalModels > 0 ? modelsWithProtocol / totalModels : 0;
    metrics.push({
      name: "model_protocols",
      weight: 5,
      score: modelProtocolScore,
      current: modelsWithProtocol,
      target: totalModels,
      description: `${modelsWithProtocol}/${totalModels} models have protocols`,
    });

    if (modelProtocolScore < 1 && totalModels > 0) {
      const missing = db.prepare(
        `SELECT m.id, m.name, b.name as brand_name
         FROM models m
         JOIN brands b ON b.id = m.brand_id
         WHERE m.id NOT IN (SELECT DISTINCT model_id FROM model_protocols)
         ORDER BY b.name, m.name`,
      ).all() as { id: string; name: string; brand_name: string }[];
      if (missing.length > 0) {
        tasks.push({
          id: "add-model-protocols",
          category: "models",
          priority: 5 * (1 - modelProtocolScore),
          description: `Add protocols to ${missing.length} model(s)`,
          context: { models: missing.slice(0, 50) }, // cap context size
        });
      }
    }

    // -----------------------------------------------------------------------
    // 5. model_equipment_links (weight 5)
    // -----------------------------------------------------------------------
    const modelsWithEquipLink = (db.prepare(
      `SELECT COUNT(DISTINCT model_id) as c FROM model_equipment`,
    ).get() as { c: number }).c;
    const modelEquipLinkScore = totalModels > 0 ? modelsWithEquipLink / totalModels : 0;
    metrics.push({
      name: "model_equipment_links",
      weight: 5,
      score: modelEquipLinkScore,
      current: modelsWithEquipLink,
      target: totalModels,
      description: `${modelsWithEquipLink}/${totalModels} models linked to equipment`,
    });

    if (modelEquipLinkScore < 1 && totalModels > 0) {
      const missing = db.prepare(
        `SELECT m.id, m.name, b.name as brand_name, t.name as type_name
         FROM models m
         JOIN brands b ON b.id = m.brand_id
         JOIN types t ON t.id = m.type_id
         WHERE m.id NOT IN (SELECT DISTINCT model_id FROM model_equipment)
         ORDER BY b.name, m.name`,
      ).all() as { id: string; name: string; brand_name: string; type_name: string }[];
      if (missing.length > 0) {
        tasks.push({
          id: "add-model-equipment-links",
          category: "relationships",
          priority: 5 * (1 - modelEquipLinkScore),
          description: `Link ${missing.length} model(s) to equipment types`,
          context: { models: missing.slice(0, 50) },
        });
      }
    }

    // -----------------------------------------------------------------------
    // 6. equipment_count (weight 10)
    // -----------------------------------------------------------------------
    const TARGET_EQUIPMENT = 100;
    const totalEquipment = (db.prepare(`SELECT COUNT(*) as c FROM equipment`).get() as { c: number }).c;
    const equipCountScore = cap(totalEquipment / TARGET_EQUIPMENT);
    metrics.push({
      name: "equipment_count",
      weight: 10,
      score: equipCountScore,
      current: totalEquipment,
      target: TARGET_EQUIPMENT,
      description: `${totalEquipment}/${TARGET_EQUIPMENT} equipment types`,
    });

    if (totalEquipment < TARGET_EQUIPMENT) {
      const existingCategories = db.prepare(
        `SELECT category, COUNT(*) as cnt FROM equipment GROUP BY category ORDER BY cnt DESC`,
      ).all() as { category: string; cnt: number }[];
      tasks.push({
        id: "add-equipment-types",
        category: "equipment",
        priority: 10 * (1 - equipCountScore),
        description: `Add ${TARGET_EQUIPMENT - totalEquipment} more equipment types (current: ${totalEquipment})`,
        context: { current_categories: existingCategories },
      });
    }

    // -----------------------------------------------------------------------
    // 7. equipment_subtypes (weight 5)
    // -----------------------------------------------------------------------
    const equipWithSubtypes = (db.prepare(
      `SELECT COUNT(DISTINCT equipment_id) as c FROM equipment_subtypes`,
    ).get() as { c: number }).c;
    const equipSubtypeScore = totalEquipment > 0 ? equipWithSubtypes / totalEquipment : 0;
    metrics.push({
      name: "equipment_subtypes",
      weight: 5,
      score: equipSubtypeScore,
      current: equipWithSubtypes,
      target: totalEquipment,
      description: `${equipWithSubtypes}/${totalEquipment} equipment have subtypes`,
    });

    if (equipSubtypeScore < 0.5 && totalEquipment > 0) {
      const missing = db.prepare(
        `SELECT e.id, e.name, e.category
         FROM equipment e
         WHERE e.id NOT IN (SELECT DISTINCT equipment_id FROM equipment_subtypes)
         ORDER BY e.category, e.name`,
      ).all() as { id: string; name: string; category: string }[];
      if (missing.length > 0) {
        tasks.push({
          id: "add-equipment-subtypes",
          category: "equipment",
          priority: 5 * (1 - equipSubtypeScore),
          description: `Add subtypes to ${missing.length} equipment type(s)`,
          context: { equipment: missing.slice(0, 50) },
        });
      }
    }

    // -----------------------------------------------------------------------
    // 8. typical_points_coverage (weight 10)
    // -----------------------------------------------------------------------
    const TARGET_AVG_TYPICAL_POINTS = 8;
    const totalTypicalPoints = (db.prepare(
      `SELECT COUNT(*) as c FROM equipment_typical_points`,
    ).get() as { c: number }).c;
    const avgTypicalPoints = totalEquipment > 0 ? totalTypicalPoints / totalEquipment : 0;
    const typicalPointsScore = cap(avgTypicalPoints / TARGET_AVG_TYPICAL_POINTS);
    metrics.push({
      name: "typical_points_coverage",
      weight: 10,
      score: typicalPointsScore,
      current: Math.round(avgTypicalPoints * 10) / 10,
      target: TARGET_AVG_TYPICAL_POINTS,
      description: `Avg ${avgTypicalPoints.toFixed(1)} typical points/equipment (target: ${TARGET_AVG_TYPICAL_POINTS})`,
    });

    if (avgTypicalPoints < TARGET_AVG_TYPICAL_POINTS && totalEquipment > 0) {
      const underserved = db.prepare(
        `SELECT e.id, e.name, e.category, COUNT(etp.point_id) as tp_count
         FROM equipment e
         LEFT JOIN equipment_typical_points etp ON etp.equipment_id = e.id
         GROUP BY e.id
         HAVING tp_count < ?
         ORDER BY tp_count ASC`,
      ).all(TARGET_AVG_TYPICAL_POINTS) as { id: string; name: string; category: string; tp_count: number }[];
      if (underserved.length > 0) {
        tasks.push({
          id: "improve-typical-points",
          category: "relationships",
          priority: 10 * (1 - typicalPointsScore),
          description: `Improve typical points for ${underserved.length} equipment type(s) below target of ${TARGET_AVG_TYPICAL_POINTS}`,
          context: { equipment: underserved.slice(0, 50) },
        });
      }
    }

    // -----------------------------------------------------------------------
    // 9. point_count (weight 10)
    // -----------------------------------------------------------------------
    const TARGET_POINTS = 500;
    const totalPoints = (db.prepare(`SELECT COUNT(*) as c FROM points`).get() as { c: number }).c;
    const pointCountScore = cap(totalPoints / TARGET_POINTS);
    metrics.push({
      name: "point_count",
      weight: 10,
      score: pointCountScore,
      current: totalPoints,
      target: TARGET_POINTS,
      description: `${totalPoints}/${TARGET_POINTS} point definitions`,
    });

    if (totalPoints < TARGET_POINTS) {
      const pointCategories = db.prepare(
        `SELECT category, COUNT(*) as cnt FROM points GROUP BY category ORDER BY cnt DESC`,
      ).all() as { category: string; cnt: number }[];
      tasks.push({
        id: "add-point-definitions",
        category: "points",
        priority: 10 * (1 - pointCountScore),
        description: `Add ${TARGET_POINTS - totalPoints} more point definitions (current: ${totalPoints})`,
        context: { current_categories: pointCategories },
      });
    }

    // -----------------------------------------------------------------------
    // 10. point_aliases (weight 5)
    // -----------------------------------------------------------------------
    const TARGET_ALIASES_PER_POINT = 5;
    const pointsWithEnoughAliases = (db.prepare(
      `SELECT COUNT(*) as c FROM (
         SELECT point_id FROM point_aliases GROUP BY point_id HAVING COUNT(*) >= ?
       )`,
    ).get(TARGET_ALIASES_PER_POINT) as { c: number }).c;
    const pointAliasScore = totalPoints > 0 ? pointsWithEnoughAliases / totalPoints : 0;
    metrics.push({
      name: "point_aliases",
      weight: 5,
      score: pointAliasScore,
      current: pointsWithEnoughAliases,
      target: totalPoints,
      description: `${pointsWithEnoughAliases}/${totalPoints} points have ${TARGET_ALIASES_PER_POINT}+ aliases`,
    });

    if (pointAliasScore < 1 && totalPoints > 0) {
      const underAliased = db.prepare(
        `SELECT p.id, p.name, p.category, COALESCE(ac.cnt, 0) as alias_count
         FROM points p
         LEFT JOIN (SELECT point_id, COUNT(*) as cnt FROM point_aliases GROUP BY point_id) ac
           ON ac.point_id = p.id
         WHERE COALESCE(ac.cnt, 0) < ?
         ORDER BY alias_count ASC, p.name`,
      ).all(TARGET_ALIASES_PER_POINT) as { id: string; name: string; category: string; alias_count: number }[];
      if (underAliased.length > 0) {
        tasks.push({
          id: "add-point-aliases",
          category: "points",
          priority: 5 * (1 - pointAliasScore),
          description: `Add aliases to ${underAliased.length} point(s) with fewer than ${TARGET_ALIASES_PER_POINT}`,
          context: { points: underAliased.slice(0, 50) },
        });
      }
    }

    // -----------------------------------------------------------------------
    // 11. point_related (weight 3)
    // -----------------------------------------------------------------------
    const pointsWithRelated = (db.prepare(
      `SELECT COUNT(DISTINCT point_id) as c FROM point_related`,
    ).get() as { c: number }).c;
    const pointRelatedScore = totalPoints > 0 ? pointsWithRelated / totalPoints : 0;
    metrics.push({
      name: "point_related",
      weight: 3,
      score: pointRelatedScore,
      current: pointsWithRelated,
      target: totalPoints,
      description: `${pointsWithRelated}/${totalPoints} points have related points`,
    });

    if (pointRelatedScore < 1 && totalPoints > 0) {
      const missing = db.prepare(
        `SELECT p.id, p.name, p.category
         FROM points p
         WHERE p.id NOT IN (SELECT DISTINCT point_id FROM point_related)
         ORDER BY p.category, p.name`,
      ).all() as { id: string; name: string; category: string }[];
      if (missing.length > 0) {
        tasks.push({
          id: "add-point-related",
          category: "relationships",
          priority: 3 * (1 - pointRelatedScore),
          description: `Add related points to ${missing.length} point(s)`,
          context: { points: missing.slice(0, 50) },
        });
      }
    }

    // -----------------------------------------------------------------------
    // 12. model_equipment_total (weight 5)
    // -----------------------------------------------------------------------
    const TARGET_MODEL_EQUIP_LINKS = 500;
    const totalModelEquipLinks = (db.prepare(
      `SELECT COUNT(*) as c FROM model_equipment`,
    ).get() as { c: number }).c;
    const modelEquipTotalScore = cap(totalModelEquipLinks / TARGET_MODEL_EQUIP_LINKS);
    metrics.push({
      name: "model_equipment_total",
      weight: 5,
      score: modelEquipTotalScore,
      current: totalModelEquipLinks,
      target: TARGET_MODEL_EQUIP_LINKS,
      description: `${totalModelEquipLinks}/${TARGET_MODEL_EQUIP_LINKS} model-equipment links`,
    });

    if (totalModelEquipLinks < TARGET_MODEL_EQUIP_LINKS) {
      tasks.push({
        id: "add-model-equipment-total",
        category: "relationships",
        priority: 5 * (1 - modelEquipTotalScore),
        description: `Add ${TARGET_MODEL_EQUIP_LINKS - totalModelEquipLinks} more model-equipment links (current: ${totalModelEquipLinks})`,
        context: { current: totalModelEquipLinks, target: TARGET_MODEL_EQUIP_LINKS },
      });
    }

    // -----------------------------------------------------------------------
    // Verification tasks (always present, low priority)
    // -----------------------------------------------------------------------
    const pointsWithHaystack = (db.prepare(
      `SELECT COUNT(*) as c FROM points WHERE haystack_tag_string IS NOT NULL AND haystack_tag_string != ''`,
    ).get() as { c: number }).c;
    const pointsWithBrick = (db.prepare(
      `SELECT COUNT(*) as c FROM points WHERE brick IS NOT NULL AND brick != ''`,
    ).get() as { c: number }).c;
    const equipWithHaystack = (db.prepare(
      `SELECT COUNT(*) as c FROM equipment WHERE haystack_tag_string IS NOT NULL AND haystack_tag_string != ''`,
    ).get() as { c: number }).c;
    const equipWithBrick = (db.prepare(
      `SELECT COUNT(*) as c FROM equipment WHERE brick IS NOT NULL AND brick != ''`,
    ).get() as { c: number }).c;

    tasks.push({
      id: "verify-haystack-tags",
      category: "points",
      priority: 2,
      description: `Verify Haystack tags: ${pointsWithHaystack}/${totalPoints} points, ${equipWithHaystack}/${totalEquipment} equipment tagged`,
      context: {
        points_with_haystack: pointsWithHaystack,
        points_total: totalPoints,
        equipment_with_haystack: equipWithHaystack,
        equipment_total: totalEquipment,
      },
    });

    tasks.push({
      id: "verify-brick-refs",
      category: "equipment",
      priority: 1.5,
      description: `Verify BRICK references: ${pointsWithBrick}/${totalPoints} points, ${equipWithBrick}/${totalEquipment} equipment have BRICK classes`,
      context: {
        points_with_brick: pointsWithBrick,
        points_total: totalPoints,
        equipment_with_brick: equipWithBrick,
        equipment_total: totalEquipment,
      },
    });

    // -----------------------------------------------------------------------
    // Compute overall score
    // -----------------------------------------------------------------------
    const totalWeight = metrics.reduce((sum, m) => sum + m.weight, 0);
    const weightedSum = metrics.reduce((sum, m) => sum + m.weight * m.score, 0);
    const overallScore = totalWeight > 0 ? Math.round((weightedSum / totalWeight) * 1000) / 10 : 0;

    // Sort tasks by priority descending
    tasks.sort((a, b) => b.priority - a.priority);

    return { overallScore, metrics, tasks };
  } finally {
    db.close();
  }
}

// ---------------------------------------------------------------------------
// Pretty printer
// ---------------------------------------------------------------------------

const ANSI = {
  reset: "\x1b[0m",
  bold: "\x1b[1m",
  dim: "\x1b[2m",
  red: "\x1b[31m",
  green: "\x1b[32m",
  yellow: "\x1b[33m",
  blue: "\x1b[34m",
  magenta: "\x1b[35m",
  cyan: "\x1b[36m",
  white: "\x1b[37m",
  bgRed: "\x1b[41m",
  bgGreen: "\x1b[42m",
  bgYellow: "\x1b[43m",
  bgBlue: "\x1b[44m",
};

function scoreColor(score: number): string {
  if (score >= 0.8) return ANSI.green;
  if (score >= 0.5) return ANSI.yellow;
  return ANSI.red;
}

function overallColor(score: number): string {
  if (score >= 80) return ANSI.green;
  if (score >= 50) return ANSI.yellow;
  return ANSI.red;
}

function progressBar(score: number, width: number = 30): string {
  const filled = Math.round(score * width);
  const empty = width - filled;
  const color = scoreColor(score);
  return `${color}${"█".repeat(filled)}${ANSI.dim}${"░".repeat(empty)}${ANSI.reset}`;
}

function padRight(str: string, len: number): string {
  return str.length >= len ? str.slice(0, len) : str + " ".repeat(len - str.length);
}

export function printScore(): void {
  const result = score();

  console.log();
  console.log(`${ANSI.bold}${ANSI.cyan}╔══════════════════════════════════════════════════════════════╗${ANSI.reset}`);
  console.log(`${ANSI.bold}${ANSI.cyan}║            BAS Atlas Completeness Score                     ║${ANSI.reset}`);
  console.log(`${ANSI.bold}${ANSI.cyan}╚══════════════════════════════════════════════════════════════╝${ANSI.reset}`);
  console.log();

  // Overall score
  const oc = overallColor(result.overallScore);
  console.log(`  ${ANSI.bold}Overall Score: ${oc}${result.overallScore}${ANSI.reset}${ANSI.bold} / 100${ANSI.reset}`);
  console.log(`  ${progressBar(result.overallScore / 100, 50)}`);
  console.log();

  // Metrics table
  console.log(`${ANSI.bold}${ANSI.blue}  Metrics:${ANSI.reset}`);
  console.log(`${ANSI.dim}  ${"─".repeat(60)}${ANSI.reset}`);

  for (const m of result.metrics) {
    const pct = Math.round(m.score * 100);
    const color = scoreColor(m.score);
    const nameStr = padRight(m.name, 28);
    const bar = progressBar(m.score, 20);
    const pctStr = padRight(`${pct}%`, 5);
    const weightStr = `w:${m.weight}`;
    console.log(`  ${ANSI.bold}${nameStr}${ANSI.reset} ${bar} ${color}${pctStr}${ANSI.reset} ${ANSI.dim}${weightStr}${ANSI.reset}`);
    console.log(`  ${ANSI.dim}  ${m.description}${ANSI.reset}`);
  }

  console.log();

  // Top tasks
  const topTasks = result.tasks.slice(0, 5);
  console.log(`${ANSI.bold}${ANSI.magenta}  Top ${topTasks.length} Tasks:${ANSI.reset}`);
  console.log(`${ANSI.dim}  ${"─".repeat(60)}${ANSI.reset}`);

  for (let i = 0; i < topTasks.length; i++) {
    const t = topTasks[i];
    const priColor = t.priority >= 5 ? ANSI.red : t.priority >= 2 ? ANSI.yellow : ANSI.dim;
    const catColor = {
      brands: ANSI.blue,
      models: ANSI.cyan,
      equipment: ANSI.green,
      points: ANSI.magenta,
      relationships: ANSI.yellow,
    }[t.category];
    console.log(
      `  ${ANSI.bold}${i + 1}.${ANSI.reset} ${catColor}[${t.category}]${ANSI.reset} ${t.description} ${priColor}(pri: ${t.priority.toFixed(1)})${ANSI.reset}`,
    );
  }

  if (result.tasks.length > 5) {
    console.log(`${ANSI.dim}  ... and ${result.tasks.length - 5} more tasks${ANSI.reset}`);
  }

  console.log();
}

// ---------------------------------------------------------------------------
// CLI entry point
// ---------------------------------------------------------------------------

const isMainModule =
  process.argv[1] &&
  (process.argv[1].endsWith("scorer.ts") || process.argv[1].endsWith("scorer.js"));

if (isMainModule) {
  printScore();
}
