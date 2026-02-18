# Contributing to BAS Babel

Thank you for your interest in contributing to BAS Babel! This project aims to be a comprehensive resource for BAS point naming standards, and community contributions are essential to making it complete.

## Ways to Contribute

### 1. Add New Entries

If you encounter point names or equipment types not in our database:

1. Fork this repository
2. Create a new source file in the appropriate directory:
   - Points: `data/points/{category}/{id}.yaml`
   - Equipment: `data/equipment/{category}.yaml`
   - Templates: `data/templates/*.yaml`
3. Follow the schema below
4. Submit a Pull Request

### 2. Add Aliases

Found a naming convention we're missing? Add it to an existing entry:

1. Find the relevant YAML file
2. Add the alias under the appropriate category:
   - `common`: Standard variations
   - `abbreviated`: Short forms (3 chars or less)
   - `verbose`: Full descriptive names
   - `misspellings`: Common typos/errors

### 3. Fix Errors

Spotted a mistake? Open an issue or submit a PR with the fix.

### 4. Add or Improve Templates

Templates connect equipment types to required/recommended point sets.

- Add template definitions in `data/templates/*.yaml`.
- Use existing point IDs from `dist/index.json`.
- Keep assumptions in `notes`.

### 5. Improve Descriptions

Help make entries more descriptive and useful for newcomers.

## Schema Reference

### Point Entry

```yaml
concept:
  id: "point-id"              # Required: lowercase-kebab-case
  name: "Point Name"          # Required: Human readable
  category: "temperatures"    # Required: One of the point categories
  description: "..."          # Required: Clear description
  haystack: "haystack tags"   # Optional: Project Haystack tags
  brick: "Brick_Class"        # Optional: Brick Schema class
  unit: "degF"                # Optional: Engineering unit
  typical_range:              # Optional
    min: 55
    max: 85
  object_type: "analog-input" # Optional: BACnet object type

aliases:
  common:                     # Required: At least one
    - "alias1"
    - "alias2"
  abbreviated: []             # Optional
  verbose: []                 # Optional
  misspellings: []            # Optional

notes:                        # Optional
  - "Relevant notes about this point"

related:                      # Optional: IDs of related entries
  - "other-point-id"
```

### Equipment Entry

```yaml
equipment:
  id: "equipment-id"
  name: "EQ"
  full_name: "Equipment Name"
  category: "air-handling"
  description: "..."

  aliases:
    common: ["alias"]
    abbreviated: ["eq"]

  subtypes:                   # Optional
    - id: "subtype-id"
      name: "Subtype"
      aliases: ["sub"]

  typical_points:             # Optional
    - "point-id"
```

## Categories

### Point Categories
- `fans` - Fan points
- `dampers` - Damper points
- `valves` - Valve points
- `temperatures` - Temperature sensors
- `pressures` - Pressure sensors
- `setpoints` - Setpoints
- `flows` - Flow measurements
- `humidity` - Humidity sensors
- `alarms` - Alarm points
- `status` - Status points
- `commands` - Command/enable points

### Equipment Categories
- `air-handling` - AHUs, RTUs, FCUs, etc.
- `terminal-units` - VAVs
- `central-plant` - Chillers, boilers, towers
- `metering` - Meters
- `motors` - Motors
- `vrf` - VRF systems

## Pull Request Process

1. **Title**: Use format `add: {entry name}` or `fix: {description}`
2. **Description**: Explain what you're adding/changing
3. **Testing**: Run local checks:
   - `npm run build:clean`
   - `npm run validate`
   - `npm run test`
   - `npm run check` (all-in-one)
4. **Review**: A maintainer will review within a few days

## Questions?

Open an issue if you have questions about contributing or the schema.

Thank you for helping build this resource!
