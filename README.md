# BAS Babel

**An open source, community-driven database of BAS point naming standards and equipment definitions.**

## Overview

BAS Babel provides a standardized reference for point naming across different BAS platforms, vendors, and conventions. Translate between Haystack tags, Brick schema, and vendor-specific naming with a shared resource that grows with contributions from the industry.

## Design + Program Tracking

- Upgrade design doc: [`DESIGN.md`](DESIGN.md)
- BAS Atlas companion repo: [bas-atlas](https://github.com/rbhans/bas-atlas)
- BASidekick API wrapper host: [basidekick-site](https://github.com/rbhans/basidekick-site)

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

# Equipment templates
curl https://raw.githubusercontent.com/rbhans/bas-babel/main/dist/templates.json

# Relationship graph
curl https://raw.githubusercontent.com/rbhans/bas-babel/main/dist/graph.json
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
  description: Sensed temperature of air in occupied zone or space
  haystack: zone air temp sensor
  brick: Zone_Air_Temperature_Sensor
  unit:
    - °F
    - °C
  point_function: sensor

aliases:
  common:
    - zn-t
    - zone temp
    - zonetemp
    - zt
    - zat
    - room temperature
    - space temperature
  misspellings:
    - temperture
    - tempreture

notes:
  - Often abbreviated as ZAT (Zone Air Temp) or RAT (Room Air Temp)

related:
  - discharge-air-temperature
  - return-air-temperature
  - occupied-cooling-setpoint
  - occupied-heating-setpoint
```

### Equipment

```yaml
equipment:
  - id: air-handling-unit
    name: Air Handling Unit
    abbreviation: AHU
    category: air-handling
    description: Central air conditioning unit that conditions and circulates air through ductwork
    haystack: ahu
    brick: Air_Handling_Unit
    aliases:
      common:
        - AHU
        - air handler
        - central air handler
        - air handling equipment
    typical_points:
      - supply-fan-command
      - supply-fan-status
      - supply-air-temperature
      - discharge-air-temperature
      - outside-air-damper-output
      - cooling-valve-output
      - heating-valve-output
      - filter-alarm
```

## Categories

### Equipment (9 categories, 55 definitions)
- **Air Handling** - AHUs, RTUs, MAUs, DOAS, FCUs, CRACs, CRAHs, Unit Ventilators, PTACs, Heat Pumps, ERVs, HRVs, Air Turnover Units
- **Terminal Units** - VAV Boxes, CAV Boxes, Fan Powered Boxes, Chilled Beams, Radiant Panels
- **Central Plant** - Chillers, Boilers, Cooling Towers, Pumps, VFDs
- **Metering** - Electric, Gas, Water, Steam, BTU Meters
- **VRF** - Outdoor Units, Indoor Units, Branch Selector Boxes
- **Power Distribution** - Generators, Automatic Transfer Switches, Switchgear
- **Domestic Water** - Water Heaters, Recirculation Pumps
- **Life Safety** - Fire Alarm Control Panels, Smoke Control Systems
- **Standalone Fans** - Exhaust Fans, Transfer Fans

### Points (16 categories, 259 definitions)
- **Temperatures** - Zone, Discharge, Return, Mixed, Outdoor, Supply/Return Water
- **Commands** - Enable, Run, Speed, Mode, Feedback
- **Fans** - Supply, Return, Exhaust, Relief (Status, Command, Speed, Alarm)
- **Valves** - Heating, Cooling, Bypass, Isolation, Mixing (Position, Command, Open/Closed)
- **Dampers** - Outside Air, Mixed Air, Exhaust, Relief (Position, Command, Open/Closed)
- **Setpoints** - Occupied/Unoccupied Heating/Cooling, Discharge Air, Pressure
- **Status** - Occupancy, Filter, Equipment Run Status
- **Pressures** - Duct Static, Building, Space, Differential
- **Alarms** - Equipment, Filter, Smoke, Low Limit
- **Flows** - Supply, Return, Exhaust, Outdoor Air
- **Humidity** - Zone, Return, Discharge, Outdoor
- **Electrical** - Power, Voltage, Current, Frequency
- **IAQ** - CO2, VOC, Particulates
- **Lighting** - Occupancy, Daylight Sensors
- **Maintenance** - Filter Status, Service Indicators

## Contributing

We welcome contributions! Whether it's adding new entries, fixing errors, or expanding aliases. See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide.

### Quick Start

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

# Rebuild from scratch (clean + deterministic output)
npm run build:clean

# Validate dist against JSON schemas
npm run validate

# Run regression tests
npm run test

# Full local check
npm run check

# CLI example
bas-babel validate --equipment ahu --file ./examples/points.txt
```

## Stats

- **259** point definitions across **16** categories
- **55** equipment definitions across **9** categories
- **25** total categories

## License

MIT License - see [LICENSE](LICENSE)

## Credits

Maintained by [BASidekick](https://basidekick.com)

Built by the BAS community.
