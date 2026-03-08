# Plan: BAS Atlas Admin App

## Overview
A browser-based admin UI for managing all BAS Atlas data directly in the SQLite database. Launch with `npm run admin`, opens on `localhost:3000`.

---

## Tech Stack

| Layer | Choice | Why |
|-------|--------|-----|
| Server | **Express** | Minimal, well-known, no learning curve |
| Database | **better-sqlite3** | Already installed, synchronous = simple |
| Templating | **EJS** | Server-rendered HTML, no frontend build step |
| Interactivity | **htmx** | Rich UX (inline editing, search, modals) without writing JS |
| Styling | **Pico CSS** | Clean default styling, classless, zero config |
| Search | **FTS5** | Already built into the SQLite schema |

No frontend build step. No React/Vue/Webpack. Just Express serving EJS templates with htmx for dynamic behavior.

---

## File Structure

```
admin/
├── server.ts                 # Express app entry point
├── db.ts                     # Database connection + helper queries
├── routes/
│   ├── dashboard.ts          # GET /
│   ├── points.ts             # CRUD /points/*
│   ├── equipment.ts          # CRUD /equipment/*
│   ├── brands.ts             # CRUD /brands/*
│   ├── types.ts              # CRUD /types/*
│   ├── models.ts             # CRUD /models/*
│   ├── search.ts             # GET /search
│   └── export.ts             # POST /export (DB → YAML/JSON)
├── views/
│   ├── layout.ejs            # Base HTML layout (nav, head, footer)
│   ├── dashboard.ejs         # Overview/stats page
│   ├── points/
│   │   ├── list.ejs          # Filterable point table
│   │   ├── detail.ejs        # View/edit single point
│   │   └── _form.ejs         # Reusable form partial
│   ├── equipment/
│   │   ├── list.ejs          # Equipment table
│   │   ├── detail.ejs        # View/edit with typical_points picker
│   │   └── _form.ejs
│   ├── catalog/
│   │   ├── brands.ejs        # Brand list + inline edit
│   │   ├── types.ejs         # Type list + inline edit
│   │   ├── models-list.ejs   # Model list
│   │   └── model-detail.ejs  # Model edit with brand/type dropdowns
│   ├── search.ejs            # Global search results
│   └── partials/
│       ├── nav.ejs           # Sidebar navigation
│       ├── flash.ejs         # Success/error messages
│       ├── alias-editor.ejs  # Reusable alias add/remove widget
│       ├── tag-list.ejs      # Haystack tag display
│       └── point-picker.ejs  # Multi-select point picker (for equipment)
└── public/
    └── app.css               # Minimal custom styles (mostly Pico does the work)
```

---

## Pages & UI Design

### 1. Dashboard (`GET /`)
- **Counts cards**: Points (259), Equipment (55), Brands (10), Types (19), Models (3)
- **Quick actions**: Add new point, Add new equipment, Add new model
- **Recent activity**: Last 10 modified entries (from meta or timestamp)
- **Global search bar** at the top (persistent across all pages via layout)

### 2. Points List (`GET /points`)
- **Table columns**: Name, Category, Kind, Function, # Aliases, # Related
- **Filters** (sidebar or top bar):
  - Category dropdown (temperatures, commands, alarms, etc.)
  - Kind toggle (Number / Bool / All)
  - Function dropdown (sensor, command, setpoint, etc.)
  - Text search (uses FTS5)
- **Bulk actions**: Delete selected
- **"+ New Point"** button → goes to blank form
- Clicking a row → detail page

### 3. Point Detail/Edit (`GET /points/:id`)
A single page showing everything about a point, all editable inline:

- **Core fields** (text inputs):
  - ID (read-only after creation), Name, Category (dropdown), Subcategory
  - Description (textarea), Brick class, Kind (Number/Bool radio)
  - Point Function (dropdown: sensor/command/setpoint/status/alarm/enable/mode/schedule/calculated)
  - Haystack tag string (text input)

- **Units** (for Number points):
  - Tag-style chips: `°F` `°C` with × to remove
  - "Add unit" input + button

- **States** (for Bool points):
  - Two rows: State 0 labels, State 1 labels
  - Each row has tag-style chips with × to remove, plus "Add" input

- **Aliases section**:
  - Two groups: Common, Misspellings
  - Each shows tag-style chips with × to remove
  - "Add alias" input + button per group
  - htmx: POST to `/points/:id/aliases` → re-renders alias section

- **Notes section**:
  - List of note strings, each with × to remove
  - "Add note" textarea + button

- **Related Points**:
  - List of linked point names (clickable → their detail page)
  - "Add related" — searchable dropdown of all points (htmx autocomplete)
  - × to remove a relationship

- **Haystack Tags** (read-only display):
  - Parsed from the tag string, shown as colored chips by kind

- **Used by Equipment** (read-only):
  - Table of equipment that have this as a typical_point
  - Each row links to that equipment's detail page

- **Save** button → POST `/points/:id` → updates DB → redirects back
- **Delete** button → confirms → DELETE `/points/:id` → redirects to list

### 4. Equipment List (`GET /equipment`)
- **Table columns**: Name, Abbreviation, Category, # Typical Points, # Subtypes
- **Filters**: Category dropdown, text search
- **"+ New Equipment"** button

### 5. Equipment Detail/Edit (`GET /equipment/:id`)
- **Core fields**: ID, Name, Full Name, Abbreviation, Category (dropdown), Description, Brick, Haystack tag string
- **Aliases section**: Same widget as points (common + misspellings)
- **Subtypes section**:
  - List with × to remove
  - "Add subtype" form (id + name, or just string)
- **Typical Points** (the key relationship):
  - Current points shown as a list with name, category badge, × to remove
  - **"Add Points" button** → opens a searchable multi-select picker:
    - Search box filters points in real-time (htmx)
    - Checkboxes next to each point
    - Points grouped by category with collapsible sections
    - "Add Selected" button → POST → re-renders the list
  - This is the most important UI interaction — it must be fast and intuitive
- **Haystack Tags** (read-only, parsed)
- **Save / Delete** buttons

### 6. Brands (`GET /brands`)
- Simple table with inline editing (htmx `hx-put`):
  - Click a cell → becomes editable → blur/enter saves
- Columns: Name, Slug, Website, # Models
- "Add Brand" row at bottom
- Click brand name → filters Models page by that brand

### 7. Types (`GET /types`)
- Same inline-edit table as Brands
- Columns: Name, Slug, # Models
- "Add Type" row at bottom

### 8. Models List (`GET /models`)
- Table: Name, Brand (linked), Type (linked), Status, # Model Numbers
- Filters: Brand dropdown, Type dropdown
- Click → model detail

### 9. Model Detail (`GET /models/:id`)
- Core fields: ID, Name, Slug, Description, Status (dropdown: current/discontinued)
- **Brand** (dropdown of all brands)
- **Type** (dropdown of all types)
- **Model Numbers**: chip list with add/remove
- **Protocols**: chip list with add/remove
- Manufacturer URL, Image URL, Added At (date picker)
- Save / Delete

### 10. Search (`GET /search?q=...`)
- Uses FTS5 `search_index` table
- Groups results by type: Points, Equipment, Brands, Types, Models
- Each result links to its detail page
- Accessible from the global search bar in the nav

### 11. Export (`POST /export`)
- Button in the nav or dashboard: "Export to YAML/JSON"
- Reads all data from SQLite
- Writes back to the source YAML/JSON files in `data/`
- Then runs `npm run build` to regenerate `dist/` outputs
- Shows progress/result in a modal or flash message

---

## API Routes

### Points
| Method | Route | Action |
|--------|-------|--------|
| GET | `/points` | List with filters |
| GET | `/points/new` | New point form |
| POST | `/points` | Create point |
| GET | `/points/:id` | Detail/edit page |
| POST | `/points/:id` | Update point |
| DELETE | `/points/:id` | Delete point + all related rows |
| POST | `/points/:id/aliases` | Add alias |
| DELETE | `/points/:id/aliases/:alias` | Remove alias |
| POST | `/points/:id/units` | Add unit |
| DELETE | `/points/:id/units/:unit` | Remove unit |
| POST | `/points/:id/notes` | Add note |
| DELETE | `/points/:id/notes/:index` | Remove note |
| POST | `/points/:id/states` | Add/update state |
| DELETE | `/points/:id/states/:key` | Remove state |
| POST | `/points/:id/related` | Add related point |
| DELETE | `/points/:id/related/:relatedId` | Remove related point |

### Equipment
| Method | Route | Action |
|--------|-------|--------|
| GET | `/equipment` | List with filters |
| GET | `/equipment/new` | New equipment form |
| POST | `/equipment` | Create equipment |
| GET | `/equipment/:id` | Detail/edit page |
| POST | `/equipment/:id` | Update equipment |
| DELETE | `/equipment/:id` | Delete equipment + related rows |
| POST | `/equipment/:id/aliases` | Add alias |
| DELETE | `/equipment/:id/aliases/:alias` | Remove alias |
| POST | `/equipment/:id/typical-points` | Add typical point(s) |
| DELETE | `/equipment/:id/typical-points/:pointId` | Remove typical point |
| POST | `/equipment/:id/subtypes` | Add subtype |
| DELETE | `/equipment/:id/subtypes/:subtypeId` | Remove subtype |

### Catalog
| Method | Route | Action |
|--------|-------|--------|
| GET | `/brands` | List (inline editable) |
| POST | `/brands` | Create brand |
| PUT | `/brands/:id` | Update brand (inline) |
| DELETE | `/brands/:id` | Delete brand |
| GET | `/types` | List (inline editable) |
| POST | `/types` | Create type |
| PUT | `/types/:id` | Update type (inline) |
| DELETE | `/types/:id` | Delete type |
| GET | `/models` | List with filters |
| GET | `/models/new` | New model form |
| POST | `/models` | Create model |
| GET | `/models/:id` | Detail/edit page |
| POST | `/models/:id` | Update model |
| DELETE | `/models/:id` | Delete model |
| POST | `/models/:id/model-numbers` | Add model number |
| DELETE | `/models/:id/model-numbers/:num` | Remove model number |
| POST | `/models/:id/protocols` | Add protocol |
| DELETE | `/models/:id/protocols/:protocol` | Remove protocol |

### Utility
| Method | Route | Action |
|--------|-------|--------|
| GET | `/search?q=` | Full-text search |
| GET | `/api/points/search?q=` | JSON point search (for pickers) |
| POST | `/export` | Export DB → YAML/JSON + rebuild |

---

## Key UI Interactions

### Typical Points Picker (Equipment Detail)
The most complex widget. Uses htmx for seamless UX:

1. Equipment detail page shows current typical points as a list
2. "Add Points" button triggers `hx-get="/api/points/search"` → renders a panel
3. Panel has a search input that fires `hx-get` on keyup (debounced 300ms)
4. Results show as checkboxes grouped by category
5. "Add Selected" button POSTs checked point IDs → server inserts into `equipment_typical_points` → htmx swaps the typical points list

### Alias Editor (Reusable)
Used on both point and equipment detail pages:

1. Existing aliases shown as dismissible chips/badges
2. × click → `hx-delete="/points/:id/aliases/the-alias"` → chip disappears
3. Text input + "Add" button → `hx-post` → new chip appears in the list
4. Two tab-like sections: Common / Misspellings

### Inline Table Editing (Brands, Types)
Simple entities edited right in the table:

1. Table cell shows text value
2. Click → cell becomes `<input>` (htmx `hx-trigger="blur, keyup[key=='Enter']"`)
3. On blur/enter → `hx-put="/brands/:id"` with field name + value
4. Server updates DB, returns updated cell HTML

---

## Implementation Steps

### Phase 1: Server Skeleton (Step 1)
- Install Express + EJS
- Create `admin/server.ts` with basic Express setup
- Create `admin/db.ts` with database connection
- Create `admin/views/layout.ejs` with nav + Pico CSS + htmx CDN
- Create dashboard route with counts from DB
- Add `"admin": "tsx admin/server.ts"` to package.json
- **Milestone**: `npm run admin` → browser shows dashboard with real counts

### Phase 2: Points CRUD (Steps 2-3)
- Points list page with table + category/kind/function filters
- Point detail page with all fields editable
- Create + Update + Delete for core point fields
- Alias editor widget (add/remove)
- Units, States, Notes editors
- Related points with searchable add
- **Milestone**: Full point lifecycle works

### Phase 3: Equipment CRUD (Steps 4-5)
- Equipment list page with table + filters
- Equipment detail page with all fields
- Alias editor (reuse from points)
- Subtypes editor
- Typical points picker (the key feature)
- **Milestone**: Can assign/remove typical points from equipment

### Phase 4: Catalog CRUD (Steps 6-7)
- Brands inline table
- Types inline table
- Models list + detail with brand/type dropdowns
- Model numbers + protocols editors
- **Milestone**: Full catalog management

### Phase 5: Search + Export (Steps 8-9)
- Global FTS5 search across all entity types
- Export: DB → YAML/JSON source files
- Rebuild trigger after export
- **Milestone**: Complete admin workflow

---

## Data Flow

```
Browser (htmx)
    ↕ HTTP (HTML fragments)
Express Server (EJS templates)
    ↕ better-sqlite3 (synchronous)
dist/bas-atlas.db
    ↓ (on Export)
data/*.yaml, data/catalog/*.json
    ↓ (on Rebuild)
dist/atlas/*.json, dist/catalog/*.json
```

---

## What stays the same
- All existing YAML/JSON source files (untouched until Export)
- All existing build scripts
- All existing tests
- The SQLite build pipeline
- CI/CD workflow
