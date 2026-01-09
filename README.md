# BAS Babel

**An open source, community-driven database of BAS point naming standards and equipment definitions.**

## Overview

BAS Babel provides a standardized reference for point naming across different BAS platforms, vendors, and conventions. Translate between Haystack tags, Brick schema, and vendor-specific naming with a shared resource that grows with contributions from the industry.

## Usage

### Web Interface

Browse the standards at [basidekick.com/babel](https://basidekick.com/babel)

### API Access

Fetch the data directly (free, no auth required):

```bash
# Full dataset
curl https://raw.githubusercontent.com/rbhans/bas-babel/main/dist/index.json

# Categories only
curl https://raw.githubusercontent.com/rbhans/bas-babel/main/dist/categories.json

# Search index
curl https://raw.githubusercontent.com/rbhans/bas-babel/main/dist/search-index.json
```

```javascript
fetch("https://raw.githubusercontent.com/rbhans/bas-babel/main/dist/index.json")
  .then(res => res.json())
  .then(data => console.log(data));
```

## Data Structure

### Points

Each point entry includes:

```yaml
concept:
  id: zone-temperature
  name: Zone Temperature
  category: temperatures
  description: Sensed temperature of air in occupied zone/space
  haystack: zone air temp sensor
  brick: Zone_Air_Temperature_Sensor
  unit: degF
  typical_range:
    min: 55
    max: 85
  object_type: analogInput

aliases:
  common:
    - zn-t
    - zone temp
    - ZoneTemp
    - zt
    - zat
    - room temperature
  misspellings:
    - temperture
    - tempreture

notes:
  - Often abbreviated as ZAT in industry

related:
  - discharge-air-temperature
```

### Equipment

```yaml
equipment:
  - id: air-handling-unit
    name: Air Handling Unit
    abbreviation: AHU
    category: air-handling
    description: Central air conditioning unit that conditions and circulates air
    haystack: ahu
    brick: Air_Handling_Unit
    aliases:
      common:
        - AHU
        - air handler
        - central air handler
    typical_points:
      - supply-fan-status
      - discharge-air-temperature
```

## Categories

### Equipment
- **Air Handling** - AHUs, RTUs, MAUs, DOAS, FCUs, CRACs, Unit Ventilators, Heat Pumps, ERVs
- **Terminal Units** - VAV Boxes, CAV Boxes, Fan Powered Boxes, Chilled Beams, Radiant Panels
- **Central Plant** - Chillers, Boilers, Cooling Towers, Pumps, VFDs
- **Metering** - Electric, Gas, Water, Steam, BTU Meters
- **VRF** - Outdoor Units, Indoor Units, Branch Selector Boxes

### Points
- **Temperatures** - Zone, Discharge, Return, Mixed, Outdoor, Supply/Return Water
- **Fans** - Supply, Return, Exhaust, Relief (Status, Command, Speed, Alarm)
- **Dampers** - Outside Air, Mixed Air, Exhaust, Relief (Position, Command, Open/Closed)
- **Valves** - Heating, Cooling, Bypass, Isolation, Mixing
- **Pressures** - Duct Static, Building, Space, Differential
- **Flows** - Supply, Return, Exhaust, Outdoor Air
- **Humidity** - Zone, Return, Discharge, Outdoor
- **Setpoints** - Occupied/Unoccupied Heating/Cooling, Discharge Air, Pressure
- **Status** - Occupancy, Filter, Equipment Run Status
- **Commands** - Enable, Run, Speed
- **Alarms** - Equipment, Filter, Smoke, Low Limit

## Contributing

We welcome contributions! Whether it's adding new entries, fixing errors, or expanding aliases.

### How to Contribute

1. Fork this repository
2. Add or edit YAML files in `data/`
3. Run `npm run build` to validate
4. Submit a Pull Request

### File Locations

- Points: `data/points/{category}/{point-id}.yaml`
- Equipment: `data/equipment/{category}.yaml`

### Guidelines

- Use lowercase kebab-case for IDs
- Include common aliases you've encountered in the field
- Add Haystack tags and Brick schema classes where known
- Use `-` for Haystack/Brick fields if unknown (indicates contribution needed)
- Link related entries when applicable

## Development

```bash
# Install dependencies
npm install

# Build JSON from YAML
npm run build
```

## Stats

- **174** point definitions
- **42** equipment definitions
- **16** categories

## License

MIT License - see [LICENSE](LICENSE)

## Credits

Maintained by [BASidekick](https://basidekick.com)

Built by the BAS community.
