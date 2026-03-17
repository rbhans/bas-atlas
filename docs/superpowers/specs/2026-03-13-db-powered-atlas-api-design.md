# DB-Powered Atlas API + Relationship Graph

## Problem

The basidekick website fetches flat JSON files from the bas-atlas GitHub repo. This throws away the relational data in the SQLite database — equipment-to-point relationships, aliases, subtypes, haystack tags — and limits what the site can show. The switch to SQLite was specifically to enable these relationships, but the website doesn't use them yet.

## Solution

Add API route handlers to the basidekick Next.js app that query `bas-atlas.db` directly. Replace the existing JSON-fetching data layer with calls to these APIs. Add new pages that surface equipment-point relationships. Build an interactive React Flow graph visualization as a showcase piece.

## Architecture

```
bas-atlas repo (GitHub)
  └── dist/bas-atlas.db
        │
        ▼ downloaded during `next build` on Vercel
basidekick deployment (Vercel)
  └── data/bas-atlas.db (bundled at build time, gitignored)
        │
        ▼ queried by serverless functions
  └── /api/atlas/* route handlers
        │
        ▼ called by React components
  └── Pages + Graph visualization
```

### Data Update Flow

1. Edit data via admin tool — changes written to `bas-atlas.db`
2. Push updated `.db` to bas-atlas GitHub repo
3. Trigger Vercel redeploy (manual or webhook)
4. Build step downloads fresh `.db`, deploys with it

## Build Step

A prebuild script in basidekick downloads the DB from GitHub:

```bash
curl -L -o data/bas-atlas.db \
  "https://github.com/rbhans/bas-atlas/raw/main/dist/bas-atlas.db"
```

The `data/` directory is gitignored. The DB is always fetched fresh at build time. This replaces the existing local JSON files in `public/data/atlas/` and `public/data/babel/`.

## API Endpoints

All endpoints live under `app/api/atlas/` in the basidekick repo. All return JSON.

### Points

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/atlas/points` | List points. Query params: `category`, `kind`, `point_function`, `q` (search), `limit`, `offset` |
| GET | `/api/atlas/points/[id]` | Full point detail: core fields, aliases, units, haystack tags, states, notes, related points, and list of equipment that uses this point |

### Equipment

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/atlas/equipment` | List equipment. Query params: `category`, `q`, `limit`, `offset` |
| GET | `/api/atlas/equipment/[id]` | Full equipment detail: core fields, aliases, subtypes, haystack tags, and typical points with their names and categories |

### Catalog

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/atlas/brands` | All brands with model counts |
| GET | `/api/atlas/types` | All equipment types with model counts |
| GET | `/api/atlas/models` | Models list. Query params: `brand`, `type` |
| GET | `/api/atlas/models/[id]` | Model detail with model numbers and protocols |

### Search & Utility

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/atlas/search` | FTS5 full-text search across all entity types. Query param: `q` |
| GET | `/api/atlas/stats` | Counts for points, equipment, brands, types, models |
| GET | `/api/atlas/graph` | Nodes and edges for React Flow. Query params: `root` (center on entity), `depth` (neighborhood radius) |

## DB Module

A shared module at `lib/data/atlas-db.ts` that:

- Opens `bas-atlas.db` from the `data/` directory using better-sqlite3
- Returns a singleton connection (one open per cold start)
- Sets WAL mode and foreign keys on
- Exports typed query helpers

```typescript
import Database from "better-sqlite3";
import path from "path";

let db: Database.Database | null = null;

export function getAtlasDb(): Database.Database {
  if (!db) {
    const dbPath = path.join(process.cwd(), "data", "bas-atlas.db");
    db = new Database(dbPath, { readonly: true });
    db.pragma("journal_mode = WAL");
    db.pragma("foreign_keys = ON");
  }
  return db;
}
```

## Page Changes

### Existing Pages (updated to use API)

- `/atlas` — tabbed browse view calls `/api/atlas/points` and `/api/atlas/equipment` instead of fetching JSON
- `/atlas/[id]` — point detail page calls `/api/atlas/points/[id]`
- `/atlas/equipment/[brand]` — brand page calls `/api/atlas/brands` + filtered models
- `/atlas/equipment/[brand]/[type]` — type page
- `/atlas/equipment/[brand]/[type]/[model]` — model detail page calls `/api/atlas/models/[id]`

### New Pages

- `/atlas/equipment/[id]` — equipment detail page showing typical points as linked cards, aliases, subtypes, haystack tags
- `/atlas/points/[id]` — enhanced point detail showing which equipment uses this point, with links to each
- `/atlas/graph` — full-page interactive relationship graph

## Graph Visualization

### Technology

React Flow (`@xyflow/react`) — React-native graph library with built-in pan, zoom, drag, and customizable node rendering.

### Data

The `/api/atlas/graph` endpoint returns:

```typescript
{
  nodes: Array<{
    id: string;
    type: "equipment" | "point";
    label: string;
    category: string;
  }>;
  edges: Array<{
    source: string;  // equipment ID
    target: string;  // point ID
  }>;
}
```

With `root` param: returns only the specified entity and its direct connections (and optionally their connections, controlled by `depth`).

### Layout

- Equipment nodes and point nodes have distinct visual styles (color, shape, size)
- Category-based coloring provides visual clustering
- Force-directed layout positions connected nodes near each other
- Initial view shows all entities; URL param `?root=chiller` focuses on a neighborhood

### Interaction

- Click equipment node: highlights its points, shows detail in a sidebar panel
- Click point node: highlights all equipment that uses it
- Search bar to jump to any entity by name
- Clicking a node in the sidebar navigates to `/atlas/graph?root=[id]`
- Double-click node to navigate to its full detail page

### Performance

~73 equipment + ~295 points + ~403 edges is well within React Flow's comfortable range (handles thousands of nodes). No virtualization or lazy loading needed.

## Dependencies Added to basidekick

| Package | Purpose |
|---------|---------|
| `better-sqlite3` | SQLite queries in serverless functions |
| `@types/better-sqlite3` | TypeScript types |
| `@xyflow/react` | React Flow graph visualization |

## Migration Path

1. Add DB module and API routes — site continues working on JSON during development
2. Switch data-fetching layer to call API routes instead of JSON
3. Remove old JSON files from `public/data/` and old fetch logic
4. Add new relationship pages and graph
5. Update `next.config.ts` to remove GitHub raw URL CSP entries (no longer needed)

## Files Changed in basidekick

### New Files
- `lib/data/atlas-db.ts` — DB singleton module
- `app/api/atlas/points/route.ts` — points list endpoint
- `app/api/atlas/points/[id]/route.ts` — point detail endpoint
- `app/api/atlas/equipment/route.ts` — equipment list endpoint
- `app/api/atlas/equipment/[id]/route.ts` — equipment detail endpoint
- `app/api/atlas/brands/route.ts` — brands endpoint
- `app/api/atlas/types/route.ts` — types endpoint
- `app/api/atlas/models/route.ts` — models list endpoint
- `app/api/atlas/models/[id]/route.ts` — model detail endpoint
- `app/api/atlas/search/route.ts` — FTS search endpoint
- `app/api/atlas/stats/route.ts` — stats endpoint
- `app/api/atlas/graph/route.ts` — graph data endpoint
- `app/(main)/atlas/graph/page.tsx` — graph visualization page
- `components/atlas/atlas-graph.tsx` — React Flow graph component
- `components/atlas/graph-node.tsx` — custom node renderer
- `components/atlas/graph-sidebar.tsx` — detail sidebar for selected node
- `scripts/fetch-atlas-db.sh` — build step script

### Modified Files
- `package.json` — add dependencies, update build script
- `lib/data/atlas.ts` — switch from JSON fetch to API calls
- `lib/data/babel.ts` — switch from JSON fetch to API calls
- `components/atlas/use-atlas-data.ts` — update to call API routes
- `components/atlas/atlas-tabbed-view.tsx` — update data source
- `next.config.ts` — update CSP headers, add prebuild step
- `.gitignore` — add `data/bas-atlas.db`

### Removed Files
- `public/data/atlas/index.json`
- `public/data/atlas/categories.json`
- `public/data/atlas/search-index.json`
- `public/data/babel/index.json`
- `public/data/babel/categories.json`
- `public/data/babel/search-index.json`
- `public/data/atlas-terms/index.json`
