# BAS Atlas Data Model

## Core Artifacts
- `dist/index.json`
- `dist/categories.json`
- `dist/search-index.json`

## Canonical Source
- Current canonical source is `data/canonical/index.json`.
- This keeps model coverage stable while future granular sources are reconciled.

## Schema Validation
Schemas in `schemas/`:
- `brand.schema.json`
- `type.schema.json`
- `model.schema.json`
- `index.schema.json`
- `categories.schema.json`
- `search-index.schema.json`

## Validation Commands
- `npm run build:clean`
- `npm run validate`
- `npm run test`
- `npm run check`
