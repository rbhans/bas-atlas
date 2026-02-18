# BAS Babel Data Model

## Core Artifacts
- `dist/index.json`: canonical points + equipment.
- `dist/categories.json`: category metadata.
- `dist/search-index.json`: searchable tokens and weighted token metadata.
- `dist/templates.json`: equipment-point templates.
- `dist/graph.json`: relationship graph generated from point links + templates.

## Point Concept (Additive)
Legacy keys are preserved. Additions:
- `concept.kind = "point"`
- `concept.type` normalized to: `sensor | command | setpoint | alarm | status | calc`
- `concept.unitsNormalized: string[]`
- `concept.statesNormalized?: { "0": string, "1": string }`
- `concept.tags.haystack: string[]`
- `concept.tags.brick?: string`
- `aliases.variants: { value, type }[]`

## Equipment Concept (Additive)
Legacy keys are preserved. Additions:
- `concept.kind = "equipment"`
- `concept.system?: string`
- `concept.synonyms: string[]`

## Schemas
Schemas live in `schemas/`:
- `point.schema.json`
- `equipment.schema.json`
- `index.schema.json`
- `search-index.schema.json`
- `categories.schema.json`
- `templates.schema.json`
- `graph.schema.json`

## Validation
Run:
- `npm run build:clean`
- `npm run validate`
- `npm run test`
