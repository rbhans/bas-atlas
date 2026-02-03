# BAS Atlas

**A community-driven equipment reference database for BAS professionals.**

## Overview

BAS Atlas is a structured, open dataset of building automation equipment: brands, types, and models. It is designed to be versioned, contributed to, and consumed by the BASidekick website and other tools.

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
2. Add or edit JSON files in `data/`
3. Run `npm run build` to validate and generate `dist/`
4. Submit a Pull Request

## Development

```bash
# Build JSON from data files
npm run build

# Validate data only
npm run validate
```

## License

MIT
