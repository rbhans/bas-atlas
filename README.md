# BAS Atlas

**An open, community-driven BAS reference that combines point naming standards and equipment catalog data.**

## Overview

This repository unifies:

- **Atlas core data**: BAS point naming standards and equipment definitions with Haystack/Brick metadata
- **Catalog data**: equipment brands, types, and models used for Atlas browsing/search

The website presents this as a single Atlas experience with points and equipment tabs.

## Web Interface

Browse BAS Atlas at [basidekick.com/atlas](https://basidekick.com/atlas)

## API Access

Fetch the published JSON directly (free, no auth required):

```bash
# Atlas core (points + equipment definitions)
curl https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/atlas/index.json
curl https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/atlas/categories.json
curl https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/atlas/search-index.json

# Catalog (brands + types + models)
curl https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/catalog/index.json
curl https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/catalog/categories.json
curl https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/catalog/search-index.json
```

```javascript
const [atlas, catalog] = await Promise.all([
  fetch("https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/atlas/index.json").then((res) => res.json()),
  fetch("https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/catalog/index.json").then((res) => res.json()),
]);

console.log(atlas.totalPoints, catalog.totalModels);
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
