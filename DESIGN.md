# BAS Babel Resource Elevation Design

## Scope
This design document defines the additive, backward-compatible upgrade path for BAS Babel data artifacts, search behavior, templates, graph relationships, validator logic, and API integration touchpoints with BASidekick.

## Current Schema Overview
Current public artifacts:
- `dist/index.json`: canonical points + equipment
- `dist/search-index.json`: tokenized search entries
- `dist/categories.json`: category metadata

Current baseline contract (preserved):
- `index`: `version`, `lastUpdated`, `totalPoints`, `totalEquipment`, `points`, `equipment`
- point entries include `concept`, `aliases`, optional `notes`, optional `related`
- equipment entries include `id`, `name`, `category`, `description`, `aliases`, optional `typical_points`
- search entries include `id`, `type`, `name`, `tokens`

## Proposed Schema Additions (Additive)
### Points
Add under `point.concept`:
- `kind: "point"`
- `type: "sensor" | "command" | "setpoint" | "alarm" | "status" | "calc"`
- `unitsNormalized: string[]`
- `statesNormalized?: { "0": string, "1": string }`
- `tags: { haystack: string[], brick?: string }`

Add under `point.aliases`:
- `variants: { value: string, type: "abbrev" | "expanded" | "misspelling" | "format" | "vendor" }[]`

### Equipment
Add under `equipment`:
- `concept: { kind: "equipment", system?: string, synonyms: string[] }`

### New Artifacts
- `dist/templates.json`
- `dist/graph.json`

### Search Index Enhancements
Preserve `tokens`; add:
- `weightedTokens: { token, weight, source }[]`
- `ngrams?: string[]`

## Migration Strategy
1. No field removals or renames in existing artifacts.
2. Additive fields generated from source during build.
3. JSON Schemas validate all artifacts and entry-level contracts.
4. Deterministic build output by:
- stable file traversal and sorting
- stable token ordering
- deterministic `lastUpdated` derived from `SOURCE_DATE_EPOCH` or git commit timestamp
5. Compatibility tests assert legacy key presence.

## Endpoints: Existing vs New
### Existing (today)
- Static JSON only (raw GitHub hosted dist files)
- No logic API for normalize/validate/templates/graph traversal

### New (implemented in `basidekick-site`)
- `GET /api/meta`
- `GET /api/points/:id`
- `GET /api/equipment/:id`
- `GET /api/search?q=`
- `POST /api/normalize`
- `POST /api/validate`
- `GET /api/templates/:equipmentTypeId`

## Risks and Regression Controls
### Risk: Legacy client breakage
- Mitigation: contract baseline tests and additive-only schema changes.

### Risk: Non-reproducible dist artifacts
- Mitigation: deterministic timestamp strategy and build determinism test (clean build vs rebuild hash check).

### Risk: Template references drift from concept IDs
- Mitigation: referential integrity checks in validation and tests.

### Risk: Search regressions
- Mitigation: preserve legacy `tokens`, add weighted/ngram fields without removing old behavior.

### Risk: Normalization quality variance
- Mitigation: >=30 fixture-based normalization test cases with confidence thresholds.

### Risk: Graph traversal blow-up
- Mitigation: bounded traversal depth defaults and max depth cap.

## Regression Test Plan
- Schema validation (`dist/*.json` + point/equipment entry schemas)
- Contract compatibility keys test
- Deterministic output hash test
- Template and graph referential tests
- Normalization fixtures test (30+)
- Validator output shape + behavior test
