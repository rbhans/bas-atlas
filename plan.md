# Plan: SQLite Version of BAS Atlas

## Goal
Add a SQLite build output alongside the existing JSON, so the frontend can fetch a single `.db` file and query it client-side with sql.js. The existing JSON pipeline remains untouched as a backup.

---

## Database Schema

```sql
-- Core point concepts
CREATE TABLE points (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  description TEXT,
  brick TEXT,
  kind TEXT,            -- "Number" or "Bool"
  point_function TEXT,  -- "sensor", "command", "setpoint", etc.
  haystack_tag_string TEXT,
  haystack_unit TEXT,
  haystack_kind TEXT
);

-- Point units (multi-value)
CREATE TABLE point_units (
  point_id TEXT NOT NULL REFERENCES points(id),
  unit TEXT NOT NULL,
  PRIMARY KEY (point_id, unit)
);

-- Point aliases
CREATE TABLE point_aliases (
  point_id TEXT NOT NULL REFERENCES points(id),
  alias TEXT NOT NULL,
  alias_group TEXT NOT NULL DEFAULT 'common'  -- "common", "regional", etc.
);

-- Haystack tags per point
CREATE TABLE point_haystack_tags (
  point_id TEXT NOT NULL REFERENCES points(id),
  tag_name TEXT NOT NULL,
  tag_kind TEXT NOT NULL  -- "Marker", "Str", etc.
);

-- Point notes
CREATE TABLE point_notes (
  point_id TEXT NOT NULL REFERENCES points(id),
  note TEXT NOT NULL
);

-- Point states (for Bool/enum points)
CREATE TABLE point_states (
  point_id TEXT NOT NULL REFERENCES points(id),
  state_key TEXT NOT NULL,
  state_value TEXT NOT NULL
);

-- Equipment
CREATE TABLE equipment (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  abbreviation TEXT,
  category TEXT NOT NULL,
  description TEXT,
  brick TEXT,
  haystack_tag_string TEXT,
  parent_id TEXT REFERENCES equipment(id)
);

-- Equipment aliases
CREATE TABLE equipment_aliases (
  equipment_id TEXT NOT NULL REFERENCES equipment(id),
  alias TEXT NOT NULL,
  alias_group TEXT NOT NULL DEFAULT 'common'
);

-- Equipment haystack tags
CREATE TABLE equipment_haystack_tags (
  equipment_id TEXT NOT NULL REFERENCES equipment(id),
  tag_name TEXT NOT NULL,
  tag_kind TEXT NOT NULL
);

-- Equipment subtypes
CREATE TABLE equipment_subtypes (
  equipment_id TEXT NOT NULL REFERENCES equipment(id),
  subtype_id TEXT NOT NULL,
  subtype_name TEXT NOT NULL,
  abbreviation TEXT,
  haystack_tag_string TEXT
);

-- Equipment typical points (links equipment to points)
CREATE TABLE equipment_typical_points (
  equipment_id TEXT NOT NULL REFERENCES equipment(id),
  point_id TEXT NOT NULL REFERENCES points(id)
);

-- Categories (for both points and equipment)
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,  -- "point" or "equipment"
  point_count INTEGER DEFAULT 0,
  equipment_count INTEGER DEFAULT 0
);

-- Catalog: Brands
CREATE TABLE brands (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT,
  logo_url TEXT,
  website TEXT,
  description TEXT
);

-- Catalog: Types
CREATE TABLE types (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT,
  category TEXT,
  description TEXT
);

-- Catalog: Models
CREATE TABLE models (
  id TEXT PRIMARY KEY,
  brand_id TEXT NOT NULL REFERENCES brands(id),
  type_id TEXT NOT NULL REFERENCES types(id),
  name TEXT NOT NULL,
  description TEXT,
  status TEXT  -- "current", "discontinued", etc.
);

CREATE TABLE model_numbers (
  model_id TEXT NOT NULL REFERENCES models(id),
  model_number TEXT NOT NULL
);

CREATE TABLE model_protocols (
  model_id TEXT NOT NULL REFERENCES models(id),
  protocol TEXT NOT NULL
);

-- FTS virtual table for search
CREATE VIRTUAL TABLE search_index USING fts5(
  entry_id,
  entry_type,  -- "point", "equipment", "brand", "type", "model"
  name,
  tokens       -- flattened search tokens (aliases, tags, descriptions)
);

-- Metadata
CREATE TABLE meta (
  key TEXT PRIMARY KEY,
  value TEXT
);
-- INSERT INTO meta VALUES ('version', '2.0.0');
-- INSERT INTO meta VALUES ('lastUpdated', '2026-03-08T...');
```

---

## Implementation Steps

### Step 1: Add `better-sqlite3` dependency
- `npm install better-sqlite3 @types/better-sqlite3`
- This runs natively in Node (fast, synchronous) for the build step

### Step 2: Create `scripts/build-sqlite.ts`
New script that:
1. Reuses existing build logic from `build.ts` and `build-catalog.ts` (imports their data-loading functions)
2. Creates `dist/bas-atlas.db` with the schema above
3. Populates all tables from the same YAML/JSON source data
4. Builds the FTS5 search index
5. Runs `VACUUM` to minimize file size

### Step 3: Add npm scripts
```json
"build:sqlite": "tsx scripts/build-sqlite.ts",
"build:all": "tsx scripts/build-all.ts"  // updated to also run build:sqlite
```

### Step 4: Update `build-all.ts`
Add `build-sqlite` as a third build step after atlas + catalog.

### Step 5: Add test for SQLite output
Create `scripts/test-sqlite.ts`:
- Verify the `.db` file exists
- Query point/equipment/catalog counts
- Verify FTS search works
- Compare counts against JSON output for consistency

### Step 6: Update CI workflow
Add verification that `dist/bas-atlas.db` exists and is valid after build.

### Step 7: Update `.gitignore`
Ensure `.db` files in `dist/` are NOT ignored (they need to be served from GitHub).

---

## What stays the same
- All existing YAML/JSON source files
- All existing build scripts (`build.ts`, `build-catalog.ts`)
- All existing JSON dist output (`dist/atlas/`, `dist/catalog/`)
- All existing tests
- The existing CI workflow (additive changes only)

## File changes summary
| File | Action |
|------|--------|
| `package.json` | Add `better-sqlite3` dep + `build:sqlite` script |
| `scripts/build-sqlite.ts` | **NEW** — SQLite build script |
| `scripts/build-all.ts` | Update to include SQLite build |
| `scripts/test-sqlite.ts` | **NEW** — SQLite validation tests |
| `.github/workflows/build.yml` | Add `.db` file verification |
| `dist/bas-atlas.db` | **NEW** — Generated SQLite database |
