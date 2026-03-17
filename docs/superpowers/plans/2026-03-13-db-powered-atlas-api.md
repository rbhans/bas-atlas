# DB-Powered Atlas API Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace basidekick's JSON-file data layer with serverless API routes that query bas-atlas.db directly, add equipment↔point relationship pages, and build an interactive React Flow graph visualization.

**Architecture:** The bas-atlas.db file is downloaded from GitHub during Vercel build and queried by Next.js API route handlers using better-sqlite3. Existing pages switch from fetching flat JSON to calling these APIs. A new graph page visualizes relationships with React Flow.

**Tech Stack:** Next.js 16 (App Router), better-sqlite3, @xyflow/react, TypeScript

**Repos:**
- `bas-atlas` — `/Users/benhansen/github/bas-atlas/` (DB source)
- `basidekick-site` — `/Users/benhansen/github/basidekick-site/` (website)

---

## File Structure

### New Files (in basidekick-site)

| File | Responsibility |
|------|---------------|
| `scripts/fetch-atlas-db.sh` | Build-time script to download bas-atlas.db from GitHub |
| `lib/data/atlas-db.ts` | SQLite singleton module — opens DB, exports query helpers |
| `app/api/atlas/points/route.ts` | GET /api/atlas/points — list/search/filter points |
| `app/api/atlas/points/[id]/route.ts` | GET /api/atlas/points/[id] — point detail with relationships |
| `app/api/atlas/equipment/route.ts` | GET /api/atlas/equipment — list/search/filter equipment |
| `app/api/atlas/equipment-detail/[id]/route.ts` | GET /api/atlas/equipment-detail/[id] — equipment with typical points |
| `app/api/atlas/brands/route.ts` | GET /api/atlas/brands — all brands with model counts |
| `app/api/atlas/types/route.ts` | GET /api/atlas/types — all types with model counts |
| `app/api/atlas/models/route.ts` | GET /api/atlas/models — filtered model list |
| `app/api/atlas/models/[id]/route.ts` | GET /api/atlas/models/[id] — model detail |
| `app/api/atlas/search/route.ts` | GET /api/atlas/search — FTS5 search |
| `app/api/atlas/stats/route.ts` | GET /api/atlas/stats — entity counts |
| `app/api/atlas/graph/route.ts` | GET /api/atlas/graph — nodes + edges for React Flow |
| `app/(main)/atlas/graph/page.tsx` | Graph visualization page |
| `components/atlas/atlas-graph.tsx` | React Flow graph component |
| `components/atlas/graph-equipment-node.tsx` | Custom equipment node renderer |
| `components/atlas/graph-point-node.tsx` | Custom point node renderer |
| `components/atlas/graph-sidebar.tsx` | Detail sidebar for selected node |

### Modified Files (in basidekick-site)

| File | Change |
|------|--------|
| `package.json` | Add better-sqlite3, @xyflow/react; update build script |
| `.gitignore` | Add `data/bas-atlas.db` |
| `next.config.ts` | Add prebuild step; update CSP if needed |
| `lib/data/atlas.ts` | Rewrite to call /api/atlas/* instead of reading JSON |
| `lib/data/babel.ts` | Rewrite to call /api/atlas/* instead of reading JSON |
| `components/atlas/use-atlas-data.ts` | Update to call API routes |
| `lib/types.ts` | Add new types for API responses with relationships |

### Removed Files (in basidekick-site)

| File | Reason |
|------|--------|
| `public/data/atlas/index.json` | Replaced by DB |
| `public/data/atlas/categories.json` | Replaced by DB |
| `public/data/atlas/search-index.json` | Replaced by DB |
| `public/data/babel/index.json` | Replaced by DB |
| `public/data/babel/categories.json` | Replaced by DB |
| `public/data/babel/search-index.json` | Replaced by DB |
| `public/data/atlas-terms/index.json` | Replaced by DB |
| `public/data/atlas-terms/categories.json` | Replaced by DB |
| `public/data/atlas-terms/search-index.json` | Replaced by DB |

---

## Chunk 1: Foundation (DB module + build step)

### Task 1: Add dependencies and build script

**Files:**
- Modify: `basidekick-site/package.json`
- Create: `basidekick-site/scripts/fetch-atlas-db.sh`
- Modify: `basidekick-site/.gitignore`

- [ ] **Step 1: Install dependencies**

```bash
cd /Users/benhansen/github/basidekick-site
pnpm add better-sqlite3
pnpm add -D @types/better-sqlite3
pnpm add @xyflow/react
```

- [ ] **Step 2: Create fetch script**

Create `scripts/fetch-atlas-db.sh`:

```bash
#!/bin/bash
set -e

DB_DIR="data"
DB_PATH="$DB_DIR/bas-atlas.db"
REMOTE_URL="https://github.com/rbhans/bas-atlas/raw/main/dist/bas-atlas.db"

mkdir -p "$DB_DIR"

if [ -f "$DB_PATH" ] && [ "$SKIP_DB_FETCH" = "true" ]; then
  echo "Skipping DB fetch (SKIP_DB_FETCH=true)"
  exit 0
fi

echo "Downloading bas-atlas.db from GitHub..."
curl -L -f -o "$DB_PATH" "$REMOTE_URL"
echo "Downloaded bas-atlas.db ($(wc -c < "$DB_PATH") bytes)"
```

- [ ] **Step 3: Make script executable**

```bash
chmod +x scripts/fetch-atlas-db.sh
```

- [ ] **Step 4: Update package.json build script**

Change the `build` script to fetch DB first:

```json
"prebuild": "bash scripts/fetch-atlas-db.sh",
"dev:fetch-db": "bash scripts/fetch-atlas-db.sh"
```

- [ ] **Step 5: Add data/ to .gitignore**

Append to `.gitignore`:

```
# Atlas database (fetched at build time)
/data/
```

- [ ] **Step 6: Fetch DB locally for development**

```bash
bash scripts/fetch-atlas-db.sh
```

- [ ] **Step 7: Commit**

```bash
git add package.json pnpm-lock.yaml scripts/fetch-atlas-db.sh .gitignore
git commit -m "feat: add build step to fetch bas-atlas.db from GitHub"
```

---

### Task 2: Create DB module

**Files:**
- Create: `basidekick-site/lib/data/atlas-db.ts`

- [ ] **Step 1: Write the DB module**

Create `lib/data/atlas-db.ts`:

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

// Typed query helpers
export function dbAll<T>(sql: string, ...params: unknown[]): T[] {
  return getAtlasDb().prepare(sql).all(...params) as T[];
}

export function dbGet<T>(sql: string, ...params: unknown[]): T | undefined {
  return getAtlasDb().prepare(sql).get(...params) as T | undefined;
}
```

- [ ] **Step 2: Verify it compiles**

```bash
cd /Users/benhansen/github/basidekick-site
npx tsc --noEmit lib/data/atlas-db.ts 2>&1 || echo "Check errors"
```

- [ ] **Step 3: Commit**

```bash
git add lib/data/atlas-db.ts
git commit -m "feat: add SQLite DB module for atlas data"
```

---

## Chunk 2: Core API Routes

### Task 3: Stats endpoint

**Files:**
- Create: `basidekick-site/app/api/atlas/stats/route.ts`

- [ ] **Step 1: Create stats route**

Create `app/api/atlas/stats/route.ts`:

```typescript
import { NextResponse } from "next/server";
import { dbGet } from "@/lib/data/atlas-db";

export async function GET() {
  const stats = {
    totalPoints: dbGet<{ c: number }>("SELECT COUNT(*) as c FROM points")?.c ?? 0,
    totalEquipment: dbGet<{ c: number }>("SELECT COUNT(*) as c FROM equipment")?.c ?? 0,
    totalBrands: dbGet<{ c: number }>("SELECT COUNT(*) as c FROM brands")?.c ?? 0,
    totalTypes: dbGet<{ c: number }>("SELECT COUNT(*) as c FROM types")?.c ?? 0,
    totalModels: dbGet<{ c: number }>("SELECT COUNT(*) as c FROM models")?.c ?? 0,
    totalLinks: dbGet<{ c: number }>("SELECT COUNT(*) as c FROM equipment_typical_points")?.c ?? 0,
  };

  return NextResponse.json(stats);
}
```

- [ ] **Step 2: Test endpoint**

```bash
cd /Users/benhansen/github/basidekick-site
pnpm dev &
sleep 3
curl -s http://localhost:3000/api/atlas/stats | jq .
```

Expected: JSON with counts matching the DB.

- [ ] **Step 3: Commit**

```bash
git add app/api/atlas/stats/route.ts
git commit -m "feat: add /api/atlas/stats endpoint"
```

---

### Task 4: Points list endpoint

**Files:**
- Create: `basidekick-site/app/api/atlas/points/route.ts`

- [ ] **Step 1: Create points list route**

Create `app/api/atlas/points/route.ts`:

```typescript
import { NextRequest, NextResponse } from "next/server";
import { dbAll, dbGet } from "@/lib/data/atlas-db";

interface PointRow {
  id: string;
  name: string;
  category: string;
  subcategory: string | null;
  description: string | null;
  kind: string | null;
  point_function: string | null;
  haystack_tag_string: string | null;
  brick: string | null;
}

export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl;
  const category = searchParams.get("category");
  const kind = searchParams.get("kind");
  const pointFunction = searchParams.get("point_function");
  const q = searchParams.get("q");
  const limit = Math.min(parseInt(searchParams.get("limit") || "500"), 1000);
  const offset = parseInt(searchParams.get("offset") || "0");

  let sql = "SELECT * FROM points WHERE 1=1";
  const params: unknown[] = [];

  if (category) {
    sql += " AND category = ?";
    params.push(category);
  }
  if (kind) {
    sql += " AND kind = ?";
    params.push(kind);
  }
  if (pointFunction) {
    sql += " AND point_function = ?";
    params.push(pointFunction);
  }
  if (q) {
    sql += " AND (name LIKE ? OR id LIKE ?)";
    params.push(`%${q}%`, `%${q}%`);
  }

  const total = dbGet<{ c: number }>(
    sql.replace("SELECT *", "SELECT COUNT(*) as c"),
    ...params
  )?.c ?? 0;

  sql += " ORDER BY name LIMIT ? OFFSET ?";
  params.push(limit, offset);

  const points = dbAll<PointRow>(sql, ...params);

  return NextResponse.json({ points, total, limit, offset });
}
```

- [ ] **Step 2: Test endpoint**

```bash
curl -s "http://localhost:3000/api/atlas/points?limit=3" | jq '.points | length'
curl -s "http://localhost:3000/api/atlas/points?category=temperatures" | jq '.total'
curl -s "http://localhost:3000/api/atlas/points?q=chiller" | jq '.points[].id'
```

- [ ] **Step 3: Commit**

```bash
git add app/api/atlas/points/route.ts
git commit -m "feat: add /api/atlas/points list endpoint with filters"
```

---

### Task 5: Point detail endpoint

**Files:**
- Create: `basidekick-site/app/api/atlas/points/[id]/route.ts`

- [ ] **Step 1: Create point detail route**

Create `app/api/atlas/points/[id]/route.ts`:

```typescript
import { NextRequest, NextResponse } from "next/server";
import { dbAll, dbGet } from "@/lib/data/atlas-db";

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;

  const point = dbGet<Record<string, unknown>>(
    "SELECT * FROM points WHERE id = ?",
    id
  );
  if (!point) {
    return NextResponse.json({ error: "Point not found" }, { status: 404 });
  }

  const aliases = dbAll<{ alias: string; alias_group: string }>(
    "SELECT alias, alias_group FROM point_aliases WHERE point_id = ?",
    id
  );

  const units = dbAll<{ unit: string }>(
    "SELECT unit FROM point_units WHERE point_id = ?",
    id
  );

  const tags = dbAll<{ tag_name: string; tag_kind: string }>(
    "SELECT tag_name, tag_kind FROM point_haystack_tags WHERE point_id = ?",
    id
  );

  const states = dbAll<{ state_key: string; state_value: string }>(
    "SELECT state_key, state_value FROM point_states WHERE point_id = ?",
    id
  );

  const notes = dbAll<{ note: string }>(
    "SELECT note FROM point_notes WHERE point_id = ?",
    id
  );

  const related = dbAll<{ related_point_id: string }>(
    "SELECT related_point_id FROM point_related WHERE point_id = ?",
    id
  );

  // Equipment that uses this point
  const equipment = dbAll<{ equipment_id: string; name: string; category: string }>(
    `SELECT e.id as equipment_id, e.name, e.category
     FROM equipment_typical_points etp
     JOIN equipment e ON e.id = etp.equipment_id
     WHERE etp.point_id = ?
     ORDER BY e.name`,
    id
  );

  return NextResponse.json({
    ...point,
    aliases,
    units: units.map((u) => u.unit),
    tags,
    states,
    notes: notes.map((n) => n.note),
    related: related.map((r) => r.related_point_id),
    equipment,
  });
}
```

- [ ] **Step 2: Test endpoint**

```bash
curl -s "http://localhost:3000/api/atlas/points/chiller-alarm" | jq '{id: .id, name: .name, equipment: [.equipment[].equipment_id]}'
```

Expected: chiller-alarm with equipment including "chiller" and "hot-water-boiler" and "steam-boiler".

- [ ] **Step 3: Commit**

```bash
git add app/api/atlas/points/\[id\]/route.ts
git commit -m "feat: add /api/atlas/points/[id] detail endpoint with relationships"
```

---

### Task 6: Equipment list endpoint

**Files:**
- Create: `basidekick-site/app/api/atlas/equipment/route.ts`

- [ ] **Step 1: Create equipment list route**

Create `app/api/atlas/equipment/route.ts`:

```typescript
import { NextRequest, NextResponse } from "next/server";
import { dbAll, dbGet } from "@/lib/data/atlas-db";

interface EquipRow {
  id: string;
  name: string;
  full_name: string | null;
  abbreviation: string | null;
  category: string;
  description: string | null;
  haystack_tag_string: string | null;
  brick: string | null;
  parent_id: string | null;
}

export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl;
  const category = searchParams.get("category");
  const q = searchParams.get("q");
  const limit = Math.min(parseInt(searchParams.get("limit") || "500"), 1000);
  const offset = parseInt(searchParams.get("offset") || "0");

  let sql = "SELECT * FROM equipment WHERE 1=1";
  const params: unknown[] = [];

  if (category) {
    sql += " AND category = ?";
    params.push(category);
  }
  if (q) {
    sql += " AND (name LIKE ? OR id LIKE ? OR abbreviation LIKE ?)";
    params.push(`%${q}%`, `%${q}%`, `%${q}%`);
  }

  const total = dbGet<{ c: number }>(
    sql.replace("SELECT *", "SELECT COUNT(*) as c"),
    ...params
  )?.c ?? 0;

  sql += " ORDER BY name LIMIT ? OFFSET ?";
  params.push(limit, offset);

  const equipment = dbAll<EquipRow>(sql, ...params);

  // Add point count for each
  const withCounts = equipment.map((e) => ({
    ...e,
    typical_point_count: dbGet<{ c: number }>(
      "SELECT COUNT(*) as c FROM equipment_typical_points WHERE equipment_id = ?",
      e.id
    )?.c ?? 0,
  }));

  return NextResponse.json({ equipment: withCounts, total, limit, offset });
}
```

- [ ] **Step 2: Test endpoint**

```bash
curl -s "http://localhost:3000/api/atlas/equipment?limit=5" | jq '.equipment[] | {id, name, typical_point_count}'
```

- [ ] **Step 3: Commit**

```bash
git add app/api/atlas/equipment/route.ts
git commit -m "feat: add /api/atlas/equipment list endpoint"
```

---

### Task 7: Equipment detail endpoint

**Files:**
- Create: `basidekick-site/app/api/atlas/equipment-detail/[id]/route.ts`

- [ ] **Step 1: Create equipment detail route**

Create `app/api/atlas/equipment-detail/[id]/route.ts`:

```typescript
import { NextRequest, NextResponse } from "next/server";
import { dbAll, dbGet } from "@/lib/data/atlas-db";

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;

  const equip = dbGet<Record<string, unknown>>(
    "SELECT * FROM equipment WHERE id = ?",
    id
  );
  if (!equip) {
    return NextResponse.json({ error: "Equipment not found" }, { status: 404 });
  }

  const aliases = dbAll<{ alias: string; alias_group: string }>(
    "SELECT alias, alias_group FROM equipment_aliases WHERE equipment_id = ?",
    id
  );

  const tags = dbAll<{ tag_name: string; tag_kind: string }>(
    "SELECT tag_name, tag_kind FROM equipment_haystack_tags WHERE equipment_id = ?",
    id
  );

  const subtypes = dbAll<{
    id: string;
    name: string;
    description: string | null;
  }>(
    "SELECT id, name, description FROM equipment_subtypes WHERE equipment_id = ?",
    id
  );

  // Typical points with full detail
  const typicalPoints = dbAll<{
    id: string;
    name: string;
    category: string;
    kind: string | null;
    point_function: string | null;
    haystack_tag_string: string | null;
    description: string | null;
  }>(
    `SELECT p.id, p.name, p.category, p.kind, p.point_function,
            p.haystack_tag_string, p.description
     FROM equipment_typical_points etp
     JOIN points p ON p.id = etp.point_id
     WHERE etp.equipment_id = ?
     ORDER BY p.category, p.name`,
    id
  );

  return NextResponse.json({
    ...equip,
    aliases,
    tags,
    subtypes,
    typical_points: typicalPoints,
  });
}
```

- [ ] **Step 2: Test endpoint**

```bash
curl -s "http://localhost:3000/api/atlas/equipment-detail/chiller" | jq '{id: .id, name: .name, point_count: (.typical_points | length), points: [.typical_points[].id]}'
```

Expected: chiller with 23 typical points.

- [ ] **Step 3: Commit**

```bash
git add app/api/atlas/equipment-detail/\[id\]/route.ts
git commit -m "feat: add /api/atlas/equipment-detail/[id] with typical points"
```

---

### Task 8: Catalog endpoints (brands, types, models)

**Files:**
- Create: `basidekick-site/app/api/atlas/brands/route.ts`
- Create: `basidekick-site/app/api/atlas/types/route.ts`
- Create: `basidekick-site/app/api/atlas/models/route.ts`
- Create: `basidekick-site/app/api/atlas/models/[id]/route.ts`

- [ ] **Step 1: Create brands route**

Create `app/api/atlas/brands/route.ts`:

```typescript
import { NextResponse } from "next/server";
import { dbAll } from "@/lib/data/atlas-db";

export async function GET() {
  const brands = dbAll<Record<string, unknown>>(
    `SELECT b.*, COUNT(m.id) as model_count
     FROM brands b
     LEFT JOIN models m ON m.brand_id = b.id
     GROUP BY b.id
     ORDER BY b.name`
  );
  return NextResponse.json({ brands });
}
```

- [ ] **Step 2: Create types route**

Create `app/api/atlas/types/route.ts`:

```typescript
import { NextResponse } from "next/server";
import { dbAll } from "@/lib/data/atlas-db";

export async function GET() {
  const types = dbAll<Record<string, unknown>>(
    `SELECT t.*, COUNT(m.id) as model_count
     FROM types t
     LEFT JOIN models m ON m.type_id = t.id
     GROUP BY t.id
     ORDER BY t.name`
  );
  return NextResponse.json({ types });
}
```

- [ ] **Step 3: Create models list route**

Create `app/api/atlas/models/route.ts`:

```typescript
import { NextRequest, NextResponse } from "next/server";
import { dbAll } from "@/lib/data/atlas-db";

export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl;
  const brand = searchParams.get("brand");
  const type = searchParams.get("type");

  let sql = `SELECT m.*, b.name as brand_name, b.slug as brand_slug,
                    t.name as type_name, t.slug as type_slug
             FROM models m
             JOIN brands b ON b.id = m.brand_id
             JOIN types t ON t.id = m.type_id
             WHERE 1=1`;
  const params: unknown[] = [];

  if (brand) {
    sql += " AND (b.slug = ? OR b.id = ?)";
    params.push(brand, brand);
  }
  if (type) {
    sql += " AND (t.slug = ? OR t.id = ?)";
    params.push(type, type);
  }

  sql += " ORDER BY m.name";
  const models = dbAll<Record<string, unknown>>(sql, ...params);

  // Attach model_numbers and protocols
  const enriched = models.map((m: Record<string, unknown>) => ({
    ...m,
    model_numbers: dbAll<{ model_number: string }>(
      "SELECT model_number FROM model_numbers WHERE model_id = ?",
      m.id
    ).map((r) => r.model_number),
    protocols: dbAll<{ protocol: string }>(
      "SELECT protocol FROM model_protocols WHERE model_id = ?",
      m.id
    ).map((r) => r.protocol),
  }));

  return NextResponse.json({ models: enriched });
}
```

- [ ] **Step 4: Create model detail route**

Create `app/api/atlas/models/[id]/route.ts`:

```typescript
import { NextRequest, NextResponse } from "next/server";
import { dbAll, dbGet } from "@/lib/data/atlas-db";

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;

  const model = dbGet<Record<string, unknown>>(
    `SELECT m.*, b.name as brand_name, b.slug as brand_slug,
            t.name as type_name, t.slug as type_slug
     FROM models m
     JOIN brands b ON b.id = m.brand_id
     JOIN types t ON t.id = m.type_id
     WHERE m.id = ? OR m.slug = ?`,
    id, id
  );
  if (!model) {
    return NextResponse.json({ error: "Model not found" }, { status: 404 });
  }

  const model_numbers = dbAll<{ model_number: string }>(
    "SELECT model_number FROM model_numbers WHERE model_id = ?",
    model.id
  ).map((r) => r.model_number);

  const protocols = dbAll<{ protocol: string }>(
    "SELECT protocol FROM model_protocols WHERE model_id = ?",
    model.id
  ).map((r) => r.protocol);

  return NextResponse.json({ ...model, model_numbers, protocols });
}
```

- [ ] **Step 5: Test all catalog endpoints**

```bash
curl -s "http://localhost:3000/api/atlas/brands" | jq '.brands | length'
curl -s "http://localhost:3000/api/atlas/types" | jq '.types | length'
curl -s "http://localhost:3000/api/atlas/models?limit=3" | jq '.models | length'
```

- [ ] **Step 6: Commit**

```bash
git add app/api/atlas/brands/ app/api/atlas/types/ app/api/atlas/models/
git commit -m "feat: add catalog API endpoints (brands, types, models)"
```

---

### Task 9: Search endpoint

**Files:**
- Create: `basidekick-site/app/api/atlas/search/route.ts`

- [ ] **Step 1: Create search route**

Create `app/api/atlas/search/route.ts`:

```typescript
import { NextRequest, NextResponse } from "next/server";
import { dbAll } from "@/lib/data/atlas-db";

export async function GET(request: NextRequest) {
  const q = request.nextUrl.searchParams.get("q");
  if (!q || q.length < 2) {
    return NextResponse.json({ results: [] });
  }

  // FTS5 search
  const results = dbAll<{
    entry_id: string;
    entry_type: string;
    name: string;
    rank: number;
  }>(
    `SELECT entry_id, entry_type, name, rank
     FROM search_index
     WHERE search_index MATCH ?
     ORDER BY rank
     LIMIT 50`,
    q + "*"
  );

  return NextResponse.json({ results, query: q });
}
```

- [ ] **Step 2: Test search**

```bash
curl -s "http://localhost:3000/api/atlas/search?q=chiller" | jq '.results[] | {id: .entry_id, type: .entry_type, name}'
```

- [ ] **Step 3: Commit**

```bash
git add app/api/atlas/search/route.ts
git commit -m "feat: add /api/atlas/search FTS5 endpoint"
```

---

### Task 10: Graph data endpoint

**Files:**
- Create: `basidekick-site/app/api/atlas/graph/route.ts`

- [ ] **Step 1: Create graph route**

Create `app/api/atlas/graph/route.ts`:

```typescript
import { NextRequest, NextResponse } from "next/server";
import { dbAll, dbGet } from "@/lib/data/atlas-db";

interface GraphNode {
  id: string;
  type: "equipment" | "point";
  label: string;
  category: string;
}

interface GraphEdge {
  source: string;
  target: string;
}

export async function GET(request: NextRequest) {
  const root = request.nextUrl.searchParams.get("root");
  const depth = Math.min(parseInt(request.nextUrl.searchParams.get("depth") || "1"), 3);

  if (root) {
    return NextResponse.json(getNeighborhood(root, depth));
  }

  // Full graph
  const equipNodes = dbAll<{ id: string; name: string; category: string }>(
    "SELECT id, name, category FROM equipment ORDER BY name"
  );
  const pointNodes = dbAll<{ id: string; name: string; category: string }>(
    `SELECT DISTINCT p.id, p.name, p.category FROM points p
     JOIN equipment_typical_points etp ON etp.point_id = p.id`
  );
  const edges = dbAll<{ equipment_id: string; point_id: string }>(
    "SELECT equipment_id, point_id FROM equipment_typical_points"
  );

  const nodes: GraphNode[] = [
    ...equipNodes.map((e) => ({ id: e.id, type: "equipment" as const, label: e.name, category: e.category })),
    ...pointNodes.map((p) => ({ id: p.id, type: "point" as const, label: p.name, category: p.category })),
  ];

  return NextResponse.json({
    nodes,
    edges: edges.map((e) => ({ source: e.equipment_id, target: e.point_id })),
  });
}

function getNeighborhood(rootId: string, depth: number) {
  const nodes = new Map<string, GraphNode>();
  const edges: GraphEdge[] = [];
  const visited = new Set<string>();

  function expand(id: string, currentDepth: number) {
    if (visited.has(id) || currentDepth > depth) return;
    visited.add(id);

    // Check if equipment
    const equip = dbGet<{ id: string; name: string; category: string }>(
      "SELECT id, name, category FROM equipment WHERE id = ?", id
    );
    if (equip) {
      nodes.set(equip.id, { id: equip.id, type: "equipment", label: equip.name, category: equip.category });
      const points = dbAll<{ point_id: string; name: string; category: string }>(
        `SELECT p.id as point_id, p.name, p.category
         FROM equipment_typical_points etp
         JOIN points p ON p.id = etp.point_id
         WHERE etp.equipment_id = ?`, id
      );
      for (const p of points) {
        nodes.set(p.point_id, { id: p.point_id, type: "point", label: p.name, category: p.category });
        edges.push({ source: equip.id, target: p.point_id });
        if (currentDepth < depth) expand(p.point_id, currentDepth + 1);
      }
    }

    // Check if point
    const point = dbGet<{ id: string; name: string; category: string }>(
      "SELECT id, name, category FROM points WHERE id = ?", id
    );
    if (point) {
      nodes.set(point.id, { id: point.id, type: "point", label: point.name, category: point.category });
      const equips = dbAll<{ equipment_id: string; name: string; category: string }>(
        `SELECT e.id as equipment_id, e.name, e.category
         FROM equipment_typical_points etp
         JOIN equipment e ON e.id = etp.equipment_id
         WHERE etp.point_id = ?`, id
      );
      for (const e of equips) {
        nodes.set(e.equipment_id, { id: e.equipment_id, type: "equipment", label: e.name, category: e.category });
        edges.push({ source: e.equipment_id, target: point.id });
        if (currentDepth < depth) expand(e.equipment_id, currentDepth + 1);
      }
    }
  }

  expand(rootId, 0);

  return {
    nodes: Array.from(nodes.values()),
    edges: dedupeEdges(edges),
    root: rootId,
  };
}

function dedupeEdges(edges: GraphEdge[]): GraphEdge[] {
  const seen = new Set<string>();
  return edges.filter((e) => {
    const key = `${e.source}|${e.target}`;
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });
}
```

- [ ] **Step 2: Test graph endpoint**

```bash
curl -s "http://localhost:3000/api/atlas/graph?root=chiller&depth=1" | jq '{nodes: (.nodes | length), edges: (.edges | length)}'
```

Expected: 24 nodes (1 chiller + 23 points), 23 edges.

- [ ] **Step 3: Commit**

```bash
git add app/api/atlas/graph/route.ts
git commit -m "feat: add /api/atlas/graph endpoint for relationship visualization"
```

---

## Chunk 3: Data Layer Migration

### Task 11: Update server-side data fetching

**Files:**
- Modify: `basidekick-site/lib/data/atlas.ts`
- Modify: `basidekick-site/lib/data/babel.ts`

- [ ] **Step 1: Rewrite atlas.ts to use DB**

Replace `lib/data/atlas.ts` with:

```typescript
import { cache } from "react";
import { dbAll, dbGet } from "@/lib/data/atlas-db";
import type { AtlasBrand, AtlasData, AtlasModel, AtlasType } from "@/lib/types";

export const getAtlasData = cache(async (): Promise<AtlasData | null> => {
  try {
    const brands = dbAll<AtlasBrand>(
      "SELECT id, name, slug, logo_url, website, description FROM brands ORDER BY name"
    );
    const types = dbAll<AtlasType>(
      "SELECT id, name, slug, description FROM types ORDER BY name"
    );

    const modelRows = dbAll<AtlasModel & { brand_id: string; type_id: string }>(
      `SELECT m.id, m.brand_id as brand, m.type_id as type, m.name, m.slug,
              m.description, m.status, m.manufacturer_url, m.image_url, m.added_at
       FROM models m ORDER BY m.name`
    );

    const models: AtlasModel[] = modelRows.map((m) => ({
      ...m,
      model_numbers: dbAll<{ model_number: string }>(
        "SELECT model_number FROM model_numbers WHERE model_id = ?", m.id
      ).map((r) => r.model_number),
      protocols: dbAll<{ protocol: string }>(
        "SELECT protocol FROM model_protocols WHERE model_id = ?", m.id
      ).map((r) => r.protocol),
    }));

    const meta = dbGet<{ value: string }>(
      "SELECT value FROM meta WHERE key = 'lastUpdated'"
    );

    return {
      version: "1.0.0",
      lastUpdated: meta?.value ?? new Date().toISOString(),
      totalBrands: brands.length,
      totalTypes: types.length,
      totalModels: models.length,
      brands,
      types,
      models,
    };
  } catch {
    return null;
  }
});

export async function getAtlasBrand(slug: string): Promise<AtlasBrand | null> {
  return dbGet<AtlasBrand>(
    "SELECT id, name, slug, logo_url, website, description FROM brands WHERE slug = ? OR id = ?",
    slug, slug
  ) ?? null;
}

export async function getAtlasType(_brandSlug: string, typeSlug: string): Promise<AtlasType | null> {
  return dbGet<AtlasType>(
    "SELECT id, name, slug, description FROM types WHERE slug = ? OR id = ?",
    typeSlug, typeSlug
  ) ?? null;
}

export async function getAtlasModel(
  brandSlug: string, typeSlug: string, modelSlug: string
): Promise<AtlasModel | null> {
  const model = dbGet<AtlasModel & { brand_id: string; type_id: string }>(
    `SELECT m.id, m.brand_id as brand, m.type_id as type, m.name, m.slug,
            m.description, m.status, m.manufacturer_url, m.image_url, m.added_at
     FROM models m
     JOIN brands b ON b.id = m.brand_id
     JOIN types t ON t.id = m.type_id
     WHERE (b.slug = ? OR b.id = ?) AND (t.slug = ? OR t.id = ?) AND (m.slug = ? OR m.id = ?)`,
    brandSlug, brandSlug, typeSlug, typeSlug, modelSlug, modelSlug
  );
  if (!model) return null;

  return {
    ...model,
    model_numbers: dbAll<{ model_number: string }>(
      "SELECT model_number FROM model_numbers WHERE model_id = ?", model.id
    ).map((r) => r.model_number),
    protocols: dbAll<{ protocol: string }>(
      "SELECT protocol FROM model_protocols WHERE model_id = ?", model.id
    ).map((r) => r.protocol),
  };
}

export async function getAllBrandSlugs(): Promise<string[]> {
  return dbAll<{ slug: string }>("SELECT slug FROM brands ORDER BY name")
    .map((r) => r.slug);
}

export async function getAllTypeSlugs(): Promise<Array<{ brand: string; type: string }>> {
  return dbAll<{ brand: string; type: string }>(
    `SELECT DISTINCT b.slug as brand, t.slug as type
     FROM models m
     JOIN brands b ON b.id = m.brand_id
     JOIN types t ON t.id = m.type_id`
  );
}

export async function getAllModelSlugs(): Promise<Array<{ brand: string; type: string; model: string }>> {
  return dbAll<{ brand: string; type: string; model: string }>(
    `SELECT b.slug as brand, t.slug as type, m.slug as model
     FROM models m
     JOIN brands b ON b.id = m.brand_id
     JOIN types t ON t.id = m.type_id`
  );
}
```

- [ ] **Step 2: Rewrite babel.ts to use DB**

Replace `lib/data/babel.ts` with:

```typescript
import { cache } from "react";
import { dbAll, dbGet } from "@/lib/data/atlas-db";
import type { BabelData, BabelEquipmentEntry, BabelPointEntry } from "@/lib/types";

export const getBabelData = cache(async (): Promise<BabelData | null> => {
  try {
    const points = dbAll<Record<string, unknown>>("SELECT * FROM points ORDER BY name");
    const equipment = dbAll<Record<string, unknown>>("SELECT * FROM equipment ORDER BY name");

    const babelPoints: BabelPointEntry[] = points.map((p) => ({
      concept: {
        id: p.id as string,
        name: p.name as string,
        category: p.category as string,
        subcategory: p.subcategory as string | undefined,
        description: (p.description as string) ?? "",
        kind: p.kind as string | undefined,
        point_function: p.point_function as string | undefined,
        haystack: p.haystack_tag_string ? {
          tagString: p.haystack_tag_string as string,
          tags: dbAll<{ tag_name: string; tag_kind: string }>(
            "SELECT tag_name, tag_kind FROM point_haystack_tags WHERE point_id = ?", p.id
          ).map((t) => ({ name: t.tag_name, kind: t.tag_kind as "Marker" })),
          markers: (p.haystack_tag_string as string).split(" "),
          unit: p.haystack_unit as string | undefined,
          kind: p.haystack_kind as string | undefined,
        } : undefined,
        brick: p.brick as string | undefined,
      },
      aliases: buildAliases("point_aliases", "point_id", p.id as string),
      notes: dbAll<{ note: string }>(
        "SELECT note FROM point_notes WHERE point_id = ?", p.id
      ).map((n) => n.note) || undefined,
      related: dbAll<{ related_point_id: string }>(
        "SELECT related_point_id FROM point_related WHERE point_id = ?", p.id
      ).map((r) => r.related_point_id) || undefined,
    }));

    const babelEquipment: BabelEquipmentEntry[] = equipment.map((e) => ({
      id: e.id as string,
      name: e.name as string,
      full_name: e.full_name as string | undefined,
      abbreviation: e.abbreviation as string | undefined,
      category: e.category as string,
      description: (e.description as string) ?? "",
      haystack: e.haystack_tag_string ? {
        tagString: e.haystack_tag_string as string,
        tags: dbAll<{ tag_name: string; tag_kind: string }>(
          "SELECT tag_name, tag_kind FROM equipment_haystack_tags WHERE equipment_id = ?", e.id
        ).map((t) => ({ name: t.tag_name, kind: t.tag_kind as "Marker" })),
        markers: (e.haystack_tag_string as string).split(" "),
      } : undefined,
      brick: e.brick as string | undefined,
      aliases: buildAliases("equipment_aliases", "equipment_id", e.id as string),
      subtypes: dbAll<{ id: string; name: string; description: string | null }>(
        "SELECT id, name, description FROM equipment_subtypes WHERE equipment_id = ?", e.id
      ).map((s) => ({
        id: s.id,
        name: s.name,
        description: s.description ?? undefined,
        aliases: dbAll<{ alias: string }>(
          "SELECT alias FROM equipment_subtype_aliases WHERE subtype_id = ? AND equipment_id = ?", s.id, e.id
        ).map((a) => a.alias) || undefined,
      })),
      typical_points: dbAll<{ point_id: string }>(
        "SELECT point_id FROM equipment_typical_points WHERE equipment_id = ?", e.id
      ).map((r) => r.point_id),
    }));

    const meta = dbGet<{ value: string }>("SELECT value FROM meta WHERE key = 'lastUpdated'");

    return {
      version: "1.0.0",
      lastUpdated: meta?.value ?? new Date().toISOString(),
      totalPoints: babelPoints.length,
      totalEquipment: babelEquipment.length,
      points: babelPoints,
      equipment: babelEquipment,
    };
  } catch {
    return null;
  }
});

function buildAliases(table: string, fkColumn: string, id: string) {
  const rows = dbAll<{ alias: string; alias_group: string }>(
    `SELECT alias, alias_group FROM ${table} WHERE ${fkColumn} = ?`, id
  );
  const common = rows.filter((r) => r.alias_group === "common").map((r) => r.alias);
  const misspellings = rows.filter((r) => r.alias_group === "misspellings").map((r) => r.alias);
  return {
    common: common.length > 0 ? common : [],
    misspellings: misspellings.length > 0 ? misspellings : undefined,
  };
}

export type BabelEntryLookup = {
  data: BabelPointEntry | BabelEquipmentEntry;
  type: "point" | "equipment";
};

export const getBabelEntry = cache(async (id: string): Promise<BabelEntryLookup | null> => {
  const data = await getBabelData();
  if (!data || !id) return null;

  const pointEntry = data.points.find((point) => point.concept.id === id);
  if (pointEntry) return { data: pointEntry, type: "point" };

  const equipmentEntry = data.equipment.find((equipment) => equipment.id === id);
  if (equipmentEntry) return { data: equipmentEntry, type: "equipment" };

  return null;
});

export const getAllBabelIds = cache(async (): Promise<string[]> => {
  const pointIds = dbAll<{ id: string }>("SELECT id FROM points").map((r) => r.id);
  const equipIds = dbAll<{ id: string }>("SELECT id FROM equipment").map((r) => r.id);
  return [...pointIds, ...equipIds];
});
```

- [ ] **Step 3: Verify the site still builds**

```bash
cd /Users/benhansen/github/basidekick-site
pnpm build 2>&1 | tail -20
```

- [ ] **Step 4: Commit**

```bash
git add lib/data/atlas.ts lib/data/babel.ts
git commit -m "feat: switch data layer from JSON files to SQLite DB"
```

---

### Task 12: Remove old JSON data files

**Files:**
- Delete: `basidekick-site/public/data/atlas/*`
- Delete: `basidekick-site/public/data/babel/*`
- Delete: `basidekick-site/public/data/atlas-terms/*`

- [ ] **Step 1: Remove files**

```bash
rm -rf public/data/atlas/ public/data/babel/ public/data/atlas-terms/
```

- [ ] **Step 2: Update client-side data hook**

Modify `components/atlas/use-atlas-data.ts` to call API routes instead of JSON files. The hooks should fetch from `/api/atlas/brands` etc. instead of `/data/atlas/index.json`.

- [ ] **Step 3: Verify site works without JSON files**

```bash
pnpm dev
# Test in browser: http://localhost:3000/atlas
```

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "feat: remove JSON data files, fully DB-driven"
```

---

## Chunk 4: Graph Visualization

### Task 13: Graph page and React Flow component

**Files:**
- Create: `basidekick-site/app/(main)/atlas/graph/page.tsx`
- Create: `basidekick-site/components/atlas/atlas-graph.tsx`
- Create: `basidekick-site/components/atlas/graph-equipment-node.tsx`
- Create: `basidekick-site/components/atlas/graph-point-node.tsx`
- Create: `basidekick-site/components/atlas/graph-sidebar.tsx`

- [ ] **Step 1: Create the graph page**

Create `app/(main)/atlas/graph/page.tsx`:

```typescript
import type { Metadata } from "next";
import { AtlasGraph } from "@/components/atlas/atlas-graph";

export const metadata: Metadata = {
  title: "Equipment & Point Relationships | BAS Atlas",
  description: "Interactive graph visualization of BAS equipment and their typical points",
};

export default function GraphPage() {
  return (
    <div className="h-[calc(100vh-4rem)] w-full">
      <AtlasGraph />
    </div>
  );
}
```

- [ ] **Step 2: Create custom node components**

Create `components/atlas/graph-equipment-node.tsx`:

```typescript
"use client";

import { Handle, Position, type NodeProps } from "@xyflow/react";

interface EquipmentNodeData {
  label: string;
  category: string;
  pointCount?: number;
}

export function EquipmentNode({ data, selected }: NodeProps) {
  const d = data as EquipmentNodeData;
  return (
    <div
      className={`rounded-lg border-2 px-3 py-2 shadow-sm transition-all ${
        selected
          ? "border-blue-500 bg-blue-50 shadow-md"
          : "border-blue-200 bg-white hover:border-blue-300"
      }`}
    >
      <Handle type="source" position={Position.Right} className="!bg-blue-400" />
      <Handle type="target" position={Position.Left} className="!bg-blue-400" />
      <div className="text-sm font-semibold text-blue-900">{d.label}</div>
      <div className="text-xs text-blue-500">{d.category}</div>
    </div>
  );
}
```

Create `components/atlas/graph-point-node.tsx`:

```typescript
"use client";

import { Handle, Position, type NodeProps } from "@xyflow/react";

interface PointNodeData {
  label: string;
  category: string;
}

export function PointNode({ data, selected }: NodeProps) {
  const d = data as PointNodeData;
  return (
    <div
      className={`rounded-md border px-2 py-1 shadow-sm transition-all ${
        selected
          ? "border-emerald-500 bg-emerald-50 shadow-md"
          : "border-emerald-200 bg-white hover:border-emerald-300"
      }`}
    >
      <Handle type="source" position={Position.Right} className="!bg-emerald-400" />
      <Handle type="target" position={Position.Left} className="!bg-emerald-400" />
      <div className="text-xs font-medium text-emerald-900">{d.label}</div>
      <div className="text-[10px] text-emerald-500">{d.category}</div>
    </div>
  );
}
```

- [ ] **Step 3: Create sidebar component**

Create `components/atlas/graph-sidebar.tsx`:

```typescript
"use client";

import Link from "next/link";

interface GraphNode {
  id: string;
  type: "equipment" | "point";
  label: string;
  category: string;
}

interface GraphSidebarProps {
  node: GraphNode | null;
  connectedNodes: GraphNode[];
  onNavigate: (id: string) => void;
  onClose: () => void;
}

export function GraphSidebar({ node, connectedNodes, onNavigate, onClose }: GraphSidebarProps) {
  if (!node) return null;

  const isEquip = node.type === "equipment";

  return (
    <div className="absolute right-0 top-0 z-10 h-full w-80 overflow-y-auto border-l bg-white p-4 shadow-lg">
      <div className="mb-4 flex items-center justify-between">
        <h3 className="text-lg font-semibold">{node.label}</h3>
        <button onClick={onClose} className="text-gray-400 hover:text-gray-600">
          &times;
        </button>
      </div>

      <div className="mb-2">
        <span
          className={`inline-block rounded px-2 py-0.5 text-xs font-medium ${
            isEquip ? "bg-blue-100 text-blue-700" : "bg-emerald-100 text-emerald-700"
          }`}
        >
          {node.type}
        </span>
        <span className="ml-2 text-xs text-gray-500">{node.category}</span>
      </div>

      <Link
        href={`/atlas/${node.id}`}
        className="mb-4 inline-block text-sm text-blue-600 underline hover:text-blue-800"
      >
        View full detail &rarr;
      </Link>

      <h4 className="mb-2 mt-4 text-sm font-medium text-gray-700">
        {isEquip ? "Typical Points" : "Used by Equipment"} ({connectedNodes.length})
      </h4>
      <div className="space-y-1">
        {connectedNodes.map((cn) => (
          <button
            key={cn.id}
            onClick={() => onNavigate(cn.id)}
            className="block w-full rounded px-2 py-1 text-left text-sm hover:bg-gray-100"
          >
            <span className="font-medium">{cn.label}</span>
            <span className="ml-1 text-xs text-gray-400">{cn.category}</span>
          </button>
        ))}
      </div>
    </div>
  );
}
```

- [ ] **Step 4: Create main graph component**

Create `components/atlas/atlas-graph.tsx`:

```typescript
"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import {
  ReactFlow,
  useNodesState,
  useEdgesState,
  Controls,
  Background,
  MiniMap,
  type Node,
  type Edge,
} from "@xyflow/react";
import "@xyflow/react/dist/style.css";
import { useSearchParams, useRouter } from "next/navigation";
import { EquipmentNode } from "./graph-equipment-node";
import { PointNode } from "./graph-point-node";
import { GraphSidebar } from "./graph-sidebar";

interface GraphData {
  nodes: Array<{
    id: string;
    type: "equipment" | "point";
    label: string;
    category: string;
  }>;
  edges: Array<{ source: string; target: string }>;
  root?: string;
}

const nodeTypes = {
  equipment: EquipmentNode,
  point: PointNode,
};

export function AtlasGraph() {
  const searchParams = useSearchParams();
  const router = useRouter();
  const root = searchParams.get("root");

  const [graphData, setGraphData] = useState<GraphData | null>(null);
  const [selectedNode, setSelectedNode] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const url = root
      ? `/api/atlas/graph?root=${encodeURIComponent(root)}&depth=1`
      : "/api/atlas/graph";

    fetch(url)
      .then((r) => r.json())
      .then((data: GraphData) => {
        setGraphData(data);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, [root]);

  // Layout nodes in a force-like arrangement
  const { flowNodes, flowEdges } = useMemo(() => {
    if (!graphData) return { flowNodes: [], flowEdges: [] };

    const equipNodes = graphData.nodes.filter((n) => n.type === "equipment");
    const pointNodes = graphData.nodes.filter((n) => n.type === "point");

    // Simple grid layout: equipment on left, points on right
    const nodes: Node[] = [];
    const centerY = Math.max(equipNodes.length, pointNodes.length) * 40;

    equipNodes.forEach((n, i) => {
      nodes.push({
        id: n.id,
        type: "equipment",
        position: {
          x: 50 + Math.random() * 100,
          y: (i / equipNodes.length) * centerY * 2,
        },
        data: { label: n.label, category: n.category },
      });
    });

    pointNodes.forEach((n, i) => {
      nodes.push({
        id: n.id,
        type: "point",
        position: {
          x: 500 + Math.random() * 100,
          y: (i / pointNodes.length) * centerY * 2,
        },
        data: { label: n.label, category: n.category },
      });
    });

    const edges: Edge[] = graphData.edges.map((e, i) => ({
      id: `e-${i}`,
      source: e.source,
      target: e.target,
      animated: false,
      style: { stroke: "#94a3b8", strokeWidth: 1 },
    }));

    return { flowNodes: nodes, flowEdges: edges };
  }, [graphData]);

  const [nodes, setNodes, onNodesChange] = useNodesState(flowNodes);
  const [edges, setEdges, onEdgesChange] = useEdgesState(flowEdges);

  useEffect(() => {
    setNodes(flowNodes);
    setEdges(flowEdges);
  }, [flowNodes, flowEdges, setNodes, setEdges]);

  const onNodeClick = useCallback((_: React.MouseEvent, node: Node) => {
    setSelectedNode(node.id);
  }, []);

  const onNavigate = useCallback(
    (id: string) => {
      router.push(`/atlas/graph?root=${encodeURIComponent(id)}`);
    },
    [router]
  );

  const selectedGraphNode = graphData?.nodes.find((n) => n.id === selectedNode) ?? null;
  const connectedNodes = useMemo(() => {
    if (!graphData || !selectedNode) return [];
    const connected = new Set<string>();
    for (const e of graphData.edges) {
      if (e.source === selectedNode) connected.add(e.target);
      if (e.target === selectedNode) connected.add(e.source);
    }
    return graphData.nodes.filter((n) => connected.has(n.id));
  }, [graphData, selectedNode]);

  if (loading) {
    return <div className="flex h-full items-center justify-center">Loading graph...</div>;
  }

  return (
    <div className="relative h-full w-full">
      {/* Search bar */}
      <div className="absolute left-4 top-4 z-10">
        <input
          type="text"
          placeholder="Search equipment or points..."
          className="rounded-lg border bg-white px-3 py-2 text-sm shadow-sm focus:border-blue-400 focus:outline-none"
          onChange={(e) => {
            if (e.target.value.length > 2) {
              const match = graphData?.nodes.find((n) =>
                n.label.toLowerCase().includes(e.target.value.toLowerCase())
              );
              if (match) onNavigate(match.id);
            }
          }}
        />
      </div>

      <ReactFlow
        nodes={nodes}
        edges={edges}
        onNodesChange={onNodesChange}
        onEdgesChange={onEdgesChange}
        onNodeClick={onNodeClick}
        nodeTypes={nodeTypes}
        fitView
        minZoom={0.1}
        maxZoom={2}
      >
        <Controls />
        <Background />
        <MiniMap
          nodeStrokeColor={(n) => (n.type === "equipment" ? "#3b82f6" : "#10b981")}
          nodeColor={(n) => (n.type === "equipment" ? "#dbeafe" : "#d1fae5")}
        />
      </ReactFlow>

      <GraphSidebar
        node={selectedGraphNode}
        connectedNodes={connectedNodes}
        onNavigate={onNavigate}
        onClose={() => setSelectedNode(null)}
      />
    </div>
  );
}
```

- [ ] **Step 5: Test the graph page**

```bash
pnpm dev
# Open http://localhost:3000/atlas/graph
# Open http://localhost:3000/atlas/graph?root=chiller
```

Verify: nodes render, clicking shows sidebar, navigation works.

- [ ] **Step 6: Commit**

```bash
git add app/\(main\)/atlas/graph/ components/atlas/atlas-graph.tsx components/atlas/graph-*.tsx
git commit -m "feat: add interactive equipment-point relationship graph"
```

---

## Chunk 5: Cleanup & Verification

### Task 14: Final verification

- [ ] **Step 1: Run full build**

```bash
cd /Users/benhansen/github/basidekick-site
pnpm build 2>&1 | tail -30
```

Expected: Build succeeds with no errors.

- [ ] **Step 2: Test all API endpoints**

```bash
pnpm start &
sleep 3
curl -s http://localhost:3000/api/atlas/stats | jq .
curl -s "http://localhost:3000/api/atlas/points?limit=3" | jq '.total'
curl -s http://localhost:3000/api/atlas/points/chiller-alarm | jq '.equipment | length'
curl -s http://localhost:3000/api/atlas/equipment-detail/chiller | jq '.typical_points | length'
curl -s http://localhost:3000/api/atlas/brands | jq '.brands | length'
curl -s "http://localhost:3000/api/atlas/search?q=temperature" | jq '.results | length'
curl -s "http://localhost:3000/api/atlas/graph?root=chiller" | jq '.nodes | length'
```

- [ ] **Step 3: Verify site pages still work**

Navigate to:
- http://localhost:3000/atlas (tabbed browse)
- http://localhost:3000/atlas/chiller-alarm (point detail)
- http://localhost:3000/atlas/graph?root=chiller (graph)
- http://localhost:3000/atlas/equipment (equipment browse)

- [ ] **Step 4: Commit any remaining fixes**

```bash
git add -A
git commit -m "chore: final cleanup for DB-powered atlas"
```
