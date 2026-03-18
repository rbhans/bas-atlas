# BAS Atlas

**An open, community-driven BAS reference that combines point naming standards and equipment catalog data.**

## Overview

This repository unifies:

- **Atlas core data**: BAS point naming standards and equipment definitions with Haystack/Brick metadata
- **Catalog data**: equipment brands, types, and models used for Atlas browsing/search

The website presents this as a single Atlas experience with points and equipment tabs.

## Web Interface

Browse BAS Atlas at [basidekick.com/atlas](https://basidekick.com/atlas)

## REST API

BAS Atlas provides a free REST API at `https://basidekick.com/api/atlas`. No authentication is required. All endpoints return JSON and CORS is fully enabled (`Access-Control-Allow-Origin: *`), so you can call the API directly from browser-side code.

**Base URL:** `https://basidekick.com/api/atlas`

### Endpoints

#### Index

```
GET /api/atlas
```

Returns an API index with a listing of all available endpoints and current data counts.

```bash
curl https://basidekick.com/api/atlas
```

#### Statistics

```
GET /api/atlas/stats
```

Returns database statistics and facet breakdowns (counts by category, kind, function, etc.).

```bash
curl https://basidekick.com/api/atlas/stats
```

#### Search

```
GET /api/atlas/search?q=
```

Full-text search across all data. Searches point names, equipment names, aliases, and more.

| Parameter | Description |
|-----------|-------------|
| `q` | Search query (required). Supports aliases. |
| `type` | Filter by result type: `point`, `equipment`, `model`, or `brand` |
| `limit` | Maximum results to return (default 50) |

```bash
# Search for "discharge air temperature"
curl "https://basidekick.com/api/atlas/search?q=discharge+air+temperature"

# Search only points
curl "https://basidekick.com/api/atlas/search?q=damper&type=point&limit=10"
```

#### Equipment

```
GET /api/atlas/equipment
```

List equipment definitions.

| Parameter | Description |
|-----------|-------------|
| `category` | Filter by equipment category |
| `q` | Search query (searches aliases) |
| `limit` | Maximum results to return |
| `offset` | Pagination offset |

```bash
curl "https://basidekick.com/api/atlas/equipment?category=hvac"
```

#### Equipment Detail

```
GET /api/atlas/equipment-detail/:id
```

Returns full detail for a single equipment type, including aliases, haystack tags, subtypes, typical points, and compatible models.

```bash
curl https://basidekick.com/api/atlas/equipment-detail/ahu
```

#### Points

```
GET /api/atlas/points
```

List BAS points.

| Parameter | Description |
|-----------|-------------|
| `category` | Filter by point category |
| `kind` | Filter by value kind: `Number` or `Bool` |
| `point_function` | Filter by function: `sensor`, `command`, `setpoint`, `alarm`, `status`, or `enable` |
| `q` | Search query (searches aliases) |
| `limit` | Maximum results to return |
| `offset` | Pagination offset |

```bash
# List all sensor points
curl "https://basidekick.com/api/atlas/points?point_function=sensor"

# List boolean command points
curl "https://basidekick.com/api/atlas/points?kind=Bool&point_function=command&limit=20"
```

#### Point Detail

```
GET /api/atlas/points/:id
```

Returns full detail for a single point, including aliases, units, states, haystack tags, related points, and equipment usage.

```bash
curl https://basidekick.com/api/atlas/points/dat
```

#### Brands

```
GET /api/atlas/brands
```

List all equipment brands with their model counts.

```bash
curl https://basidekick.com/api/atlas/brands
```

#### Types

```
GET /api/atlas/types
```

List all model types with their model counts.

```bash
curl https://basidekick.com/api/atlas/types
```

#### Models

```
GET /api/atlas/models
```

List equipment models.

| Parameter | Description |
|-----------|-------------|
| `brand` | Filter by brand |
| `type` | Filter by model type |

```bash
# List all models from a specific brand
curl "https://basidekick.com/api/atlas/models?brand=trane"

# Filter by type
curl "https://basidekick.com/api/atlas/models?type=vav"
```

#### Model Detail

```
GET /api/atlas/models/:id
```

Returns full detail for a single model, including protocols, model numbers, and equipment links.

```bash
curl https://basidekick.com/api/atlas/models/trane-uc600
```

#### Relationship Graph

```
GET /api/atlas/graph
```

Returns the equipment-point relationship graph.

| Parameter | Description |
|-----------|-------------|
| `root` | Root entity ID to start traversal from |
| `depth` | Traversal depth, 1-3 |

```bash
# Full graph
curl https://basidekick.com/api/atlas/graph

# Graph rooted at a specific equipment type
curl "https://basidekick.com/api/atlas/graph?root=ahu&depth=2"
```

### JavaScript Example

```javascript
// Search the Atlas
const results = await fetch(
  "https://basidekick.com/api/atlas/search?q=supply+fan&type=point"
).then((res) => res.json());

console.log(results);

// Fetch equipment detail
const ahu = await fetch(
  "https://basidekick.com/api/atlas/equipment-detail/ahu"
).then((res) => res.json());

console.log(ahu.typicalPoints, ahu.compatibleModels);

// Get database stats
const stats = await fetch(
  "https://basidekick.com/api/atlas/stats"
).then((res) => res.json());

console.log(stats);
```

### Raw Data Downloads

If you prefer to work with the data offline, two options are available:

- **SQLite database** (1.3 MB): download the full database directly from
  [github.com/rbhans/bas-atlas/raw/main/dist/bas-atlas.db](https://github.com/rbhans/bas-atlas/raw/main/dist/bas-atlas.db)
- **JSON files**: the pre-built JSON bundles remain available for direct download from the repository:

```bash
# Atlas core (points + equipment definitions)
curl -LO https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/atlas/index.json
curl -LO https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/atlas/categories.json
curl -LO https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/atlas/search-index.json

# Catalog (brands + types + models)
curl -LO https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/catalog/index.json
curl -LO https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/catalog/categories.json
curl -LO https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/catalog/search-index.json
```

## Data Layout

### Atlas Core Source Data

- Points: `data/points/{category}/{point-id}.yaml`
- Equipment definitions: `data/equipment/{category}.yaml`
- Haystack dictionaries: `data/haystack-tags.yaml`, `data/haystack-units.yaml`

### Catalog Source Data

- Brands: `data/catalog/brands/*.json`
- Types: `data/catalog/types/*.json`
- Models: `data/catalog/models/*.json`

## Build Outputs

The build is namespaced to avoid filename collisions:

```text
dist/
  bas-atlas.db
  atlas/
    index.json
    categories.json
    search-index.json
  catalog/
    index.json
    categories.json
    search-index.json
```

## Development

```bash
# Install dependencies
npm install

# Build both datasets
npm run build

# Build only Atlas core dataset
npm run build:atlas

# Build only catalog dataset
npm run build:catalog

# Validate both datasets
npm run validate

# Run test suite
npm run test
```

## Contributing

We welcome contributions to point naming, equipment definitions, and catalog records.

1. Fork the repository
2. Add or edit files in `data/`
3. Run `npm run build` (and `npm run test` when changing Atlas core data/build logic)
4. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution details.

## License

MIT License - see [LICENSE](LICENSE)
