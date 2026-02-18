# BAS Atlas

**A community-driven equipment reference database for BAS professionals.**

## Overview

BAS Atlas is a structured, open dataset of building automation equipment: brands, types, and models. It is designed to be versioned, contributed to, and consumed by the BASidekick website and other tools.

## Program Design + Responsibilities

- BAS Babel/Atlas elevation design anchor: [bas-babel/DESIGN.md](https://github.com/rbhans/bas-babel/blob/main/DESIGN.md)
- This repository is the canonical Atlas model dataset and deterministic dist build pipeline.
- `basidekick-site` hosts the thin API wrapper layer that consumes Atlas/Babel artifacts.

## Usage

### API Access

The dataset is published as JSON files in `dist/` and can be consumed directly:

```bash
# Full dataset
curl https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/index.json

# Categories and counts
curl https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/categories.json

# Search index
curl https://raw.githubusercontent.com/rbhans/bas-atlas/main/dist/search-index.json
```

## Data Structure

### Brand

```json
{
  "brand": {
    "id": "trane",
    "name": "Trane",
    "slug": "trane",
    "logo_url": "",
    "website": "https://www.trane.com",
    "description": ""
  }
}
```

### Type

```json
{
  "type": {
    "id": "supervisory-controllers",
    "name": "Supervisory Controllers",
    "slug": "supervisory-controllers",
    "description": ""
  }
}
```

### Model

```json
{
  "model": {
    "id": "trane-tracer-sc-plus",
    "brand": "trane",
    "type": "supervisory-controllers",
    "name": "Tracer SC+",
    "slug": "tracer-sc-plus",
    "model_numbers": ["SC+"],
    "protocols": ["BACnet", "N2"],
    "status": "current",
    "description": "Building automation system controller.",
    "manufacturer_url": "https://www.trane.com",
    "image_url": "",
    "added_at": "2026-02-01"
  }
}
```

## Contributing

1. Fork this repository
2. Canonical source of truth is `data/canonical/index.json` (frozen baseline for backward compatibility)
3. Optional granular data files can still be edited in `data/brands`, `data/types`, `data/models` for future migrations
4. Run `npm run check` to build, validate, and test
4. Submit a Pull Request

## Development

```bash
# Build JSON from data files
npm run build

# Clean rebuild (deterministic)
npm run build:clean

# Validate against JSON Schemas
npm run validate

# Run regression tests
npm run test

# Full local gate
npm run check
```

## License

MIT
