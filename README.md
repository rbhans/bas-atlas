# BAS Babel

**BAS Point Naming Standards** - A comprehensive, open-source resource for Building Automation System point naming conventions and aliases.

## Overview

BAS Babel provides a standardized reference for point naming across different BAS platforms, vendors, and conventions. Whether you're dealing with Haystack tags, Brick schema, or vendor-specific naming, this resource helps translate between them.

## Usage

### Web Interface

Browse the standards at [basidekick.com/resources/babel](https://basidekick.com/resources/babel)

### API Access

Fetch the data directly via CDN (free, no auth required):

```bash
# Full dataset
curl https://cdn.jsdelivr.net/gh/rbhans/bas-babel@main/dist/index.json

# Categories only
curl https://cdn.jsdelivr.net/gh/rbhans/bas-babel@main/dist/categories.json

# Search index
curl https://cdn.jsdelivr.net/gh/rbhans/bas-babel@main/dist/search-index.json
```

### NPM Package

```bash
npm install bas-babel
```

```javascript
import data from 'bas-babel/dist/index.json';
```

## Data Structure

### Points

Each point entry includes:

```yaml
concept:
  id: "zone-air-temperature"
  name: "Zone Air Temperature"
  category: "temperatures"
  description: "Sensed temperature of air in occupied zone/space"
  haystack: "zone air temp sensor"
  brick: "Zone_Air_Temperature_Sensor"
  unit: "degF"
  typical_range: { min: 55, max: 85 }
  object_type: "analog-input"

aliases:
  common: ["zn-t", "zone temp", "ZoneTemp"]
  abbreviated: ["zt", "zat", "znt"]
  verbose: ["zone temperature", "room temperature"]
  misspellings: ["temperture", "tempreture"]

notes:
  - "Often abbreviated as ZAT in industry"

related: ["discharge-air-temperature"]
```

### Equipment

```yaml
equipment:
  id: "ahu"
  name: "AHU"
  full_name: "Air Handling Unit"
  category: "air-handling"
  description: "Central air conditioning unit"

  aliases:
    common: ["air handling unit", "air handler"]
    abbreviated: ["ah"]

  subtypes:
    - id: "rtu"
      name: "Rooftop Unit"
      aliases: ["roof top unit"]

  typical_points: ["supply-fan-status"]
```

## Categories

### Equipment
- Air Handling (AHUs, RTUs, MAUs, DOAS, FCUs)
- Terminal Units (VAVs)
- Central Plant (Chillers, Boilers, Cooling Towers, Pumps)
- Metering (Electric, Gas, Flow meters)
- Motors (Fan motors)
- VRF (Indoor/Outdoor units)

### Points
- Fans (Supply, Return, Exhaust, Relief)
- Dampers (OA, EA, MA, Relief)
- Valves (Heating, Cooling, Bypass)
- Temperatures (Zone, DA, RA, MA, OA)
- Pressures (Duct static, Building, Space)
- Setpoints (All types)
- Flows (Air flow)
- Humidity
- Alarms (Filter, Freeze, Pressure)
- Status
- Commands/Enables

## Contributing

We welcome contributions! Whether it's adding new entries, fixing errors, or expanding aliases.

### How to Contribute

1. Fork this repository
2. Add or edit YAML files in `data/`
3. Run `npm run build` to validate
4. Submit a Pull Request

### YAML File Location

- Points: `data/points/{category}/{id}.yaml`
- Equipment: `data/equipment/{category}.yaml`

### Guidelines

- Use lowercase kebab-case for IDs
- Include common aliases you've encountered in the field
- Add notes for vendor-specific conventions
- Link related entries when applicable

## Development

```bash
# Install dependencies
npm install

# Build JSON from YAML
npm run build

# Validate YAML syntax
npm run validate

# Migrate from CSV (one-time)
npm run migrate
```

## License

MIT License - see [LICENSE](LICENSE)

## Credits

Maintained by [BASidekick](https://basidekick.com)

Built by the BAS community.
