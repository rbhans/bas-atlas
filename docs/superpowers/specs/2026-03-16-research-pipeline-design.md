# BAS Atlas Research Pipeline — Design Spec

## Purpose

Autonomous data enrichment pipeline for bas-atlas. Iteratively improves the SQLite database by researching manufacturer sites, BAS standards, and ontologies. Modeled after Karpathy's autoresearch pattern: score → research → validate → commit → repeat.

## Architecture

```
pnpm run research [--overnight] [--verify-only] [--target brands|models|equipment|points]
```

Three components + prompt templates:

### Scorer (`research/scorer.ts`)

Reads DB, computes completeness score (0-100), returns prioritized task queue.

Weighted metrics:
- Models per brand (target 15+) — weight 10
- Equipment count (target 100+) — weight 10
- Point count (target 500+) — weight 10
- Typical points per equipment (target 8+) — weight 10
- Brand descriptions — weight 5
- Model protocols — weight 5
- Model↔equipment links — weight 5
- Equipment subtypes — weight 5
- Brand logos — weight 3
- Point aliases — weight 5
- Related points — weight 3

Output: ranked task list with current score percentage per metric.

### Researcher (`research/researcher.ts`)

Given a task from scorer:
1. Playwright scrapes relevant pages (max 10 per iteration)
2. Claude API structures scraped content into SQL changes
3. Returns structured JSON:

```json
{
  "task": "enrich-models-honeywell",
  "source_urls": ["https://..."],
  "apply": [
    { "sql": "INSERT INTO ...", "confidence": "high", "reason": "From product catalog" }
  ],
  "review": [
    { "sql": "DELETE FROM ...", "confidence": "low", "reason": "Link seems incorrect" }
  ]
}
```

Confidence levels:
- **high** — sourced from manufacturer site (URL logged)
- **medium** — from standards doc (Haystack, BRICK, ASHRAE)
- **low** — inferred by Claude

### Validator (`research/validator.ts`)

Validates proposed SQL before execution:
- Foreign keys exist (brand_id, type_id, equipment_id are real)
- No duplicate primary keys
- Strings non-empty
- SQL syntactically valid (dry-run against DB copy)
- Rejects anything that fails

### Runner (`research/runner.ts`)

The loop:
1. Score DB, get task queue
2. Pick highest-priority task
3. Research (Playwright + Claude API)
4. Validate proposed changes
5. Apply `high` and `medium` confidence changes to DB
6. Route `low` confidence + all deletes to review file
7. Re-score — if improved, git commit. If not, rollback.
8. Log everything
9. Repeat (or stop if `--overnight` not set)

### Guardrails

- **ADD** — applied automatically (high/medium confidence)
- **UPDATE** — applied automatically only if sourced (URL required)
- **DELETE** — always routed to review file, never auto-applied
- **LOW confidence** — routed to review file

### Prompt Templates (`research/prompts/`)

- `catalog.md` — brand/model enrichment (product lines, protocols, model numbers)
- `equipment.md` — equipment types, subtypes, aliases, Haystack/BRICK tags
- `points.md` — point concepts, aliases, units, typical_points relationships
- `program.md` — top-level objectives and constraints

Each template includes the DB schema so Claude outputs valid SQL.

## File Structure

```
bas-atlas/
  research/
    program.md
    runner.ts
    scorer.ts
    researcher.ts
    validator.ts
    prompts/
      catalog.md
      equipment.md
      points.md
    logs/
      YYYY-MM-DD-HH.json          (applied changes)
      YYYY-MM-DD-HH-review.json   (proposed deletes + low-confidence)
```

## Dependencies

- `playwright` — headless browser for manufacturer sites
- `@anthropic-ai/sdk` — Claude API for reasoning
- `better-sqlite3` — already in project
- `ANTHROPIC_API_KEY` — from environment

## Usage

```bash
# Single pass — score, research top gap, apply, stop
pnpm run research

# Keep looping until stopped (Ctrl+C)
pnpm run research --overnight

# Verify/correct existing data only, no additions
pnpm run research --verify-only

# Focus on a specific area
pnpm run research --target models
pnpm run research --target equipment
pnpm run research --target points

# Review proposed deletes and low-confidence changes
cat research/logs/*-review.json
```

## Cost

~1-2 Claude API calls per iteration (sonnet for speed). Roughly $0.01-0.05 per iteration depending on scraped content size. An overnight run of 100 iterations: ~$1-5.
