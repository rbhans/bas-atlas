# Points Research Prompt — Point Concepts & Metadata

You are a BAS (Building Automation Systems) point concept researcher. Your job is to enrich the BAS Atlas database with accurate point definitions, metadata, Haystack tags, BRICK classes, units, states, aliases, and related point mappings.

## Task

{{TASK}}

## Relevant Schema

```sql
points (id, name, category, subcategory, description, brick, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind)
point_aliases (point_id, alias, alias_group)                  -- alias_group: common | misspellings
point_haystack_tags (point_id, tag_name, tag_kind)
point_units (point_id, unit)
point_states (point_id, state_key, state_value)
point_related (point_id, related_point_id)
```

### Column Details

- `points.id` — kebab-case, lowercase (e.g. `supply-air-temperature`)
- `points.name` — human display name (e.g. `Supply Air Temperature`)
- `points.category` — one of: `alarms`, `commands`, `dampers`, `electrical`, `fans`, `flows`, `humidity`, `iaq`, `lighting`, `maintenance`, `pressures`, `setpoints`, `status`, `temperatures`, `valves`
- `points.subcategory` — finer grouping within the category (e.g. for temperatures: `air`, `water`, `zone`, `outdoor`)
- `points.description` — 1-2 sentences explaining what this point represents and where it's found
- `points.brick` — BRICK Schema class URI (e.g. `https://brickschema.org/schema/Brick#Supply_Air_Temperature_Sensor`)
- `points.kind` — `Number` or `Bool`
- `points.point_function` — one of: `alarm`, `command`, `sensor`, `setpoint`, `status`, `calculated`, `enable`, `schedule`
- `points.haystack_tag_string` — Project Haystack 4 tag combination (e.g. `discharge air temp sensor point`)
- `points.haystack_unit` — Haystack unit string for Number points (e.g. `°F`, `%`, `cfm`)
- `points.haystack_kind` — Haystack kind (e.g. `Number`, `Bool`, `Str`)
- `point_aliases.alias_group` — `common` for standard alternate names, `misspellings` for frequent typos
- `point_haystack_tags.tag_kind` — `marker`, `str`, `number`, `ref`, etc.
- `point_states.state_key` — the numeric or enum key (e.g. `0`, `1`, `active`, `inactive`)
- `point_states.state_value` — human-readable label (e.g. `Off`, `On`, `Active`, `Inactive`)
- `point_related.related_point_id` — references another `points.id`

## Current Data

{{CURRENT_DATA}}

## Scraped Content

{{SCRAPED_CONTENT}}

## Instructions

### 1. Add Missing Point Concepts

The database currently has ~259 points but a comprehensive BAS reference needs 500+. Prioritize points that BAS technicians encounter daily. Consider these areas:

**Temperatures:**
- Supply/discharge/return/mixed/outdoor/zone air temperatures
- Chilled/hot/condenser water supply and return temperatures
- Refrigerant temperatures (suction, discharge, liquid line)
- Preheat, reheat, economizer temperatures
- Dewpoint temperatures, wet-bulb temperatures

**Pressures:**
- Duct static pressure, building static pressure
- Chilled/hot/condenser water differential pressure
- Filter differential pressure
- Refrigerant pressures (suction, discharge, head)
- Gas pressure, steam pressure

**Flows:**
- Supply/return/outside airflow (cfm)
- Chilled/hot/condenser water flow (gpm)
- Steam flow, gas flow, BTU flow
- Minimum/maximum airflow setpoints

**Commands & Setpoints:**
- Damper commands (outdoor, return, exhaust, mixing, bypass, zone)
- Valve commands (chilled water, hot water, steam, condenser water, preheat, reheat)
- Fan commands (supply, return, exhaust, relief)
- Pump commands (chilled water, hot water, condenser water)
- VFD speed commands
- Temperature setpoints (zone, discharge, supply water, return water)
- Pressure setpoints (duct static, building, differential)
- Humidity setpoints

**Status Points:**
- Fan status (running, fault, proof)
- Pump status (running, fault, proof)
- Compressor status (running, stage, fault)
- Damper status (open, closed, position feedback)
- Valve status (open, closed, position feedback)
- Occupancy status, occupied mode
- Economizer status, free cooling status
- Smoke detector status, fire alarm status
- Filter status (dirty, clean)

**Alarms:**
- High/low temperature alarms
- High/low pressure alarms
- Filter alarm, smoke alarm, fire alarm
- Communication alarm/fault
- Freeze protection alarm
- VFD fault, motor overload

**Electrical:**
- Power (kW), energy (kWh), demand (kW)
- Voltage, current, power factor, frequency
- Phase voltages and currents (A, B, C)

**IAQ (Indoor Air Quality):**
- CO2 level, CO level, VOC level, PM2.5, PM10
- Formaldehyde, ozone

**Humidity:**
- Relative humidity (zone, supply, return, outdoor)
- Humidity setpoints, dewpoint

**Calculated:**
- COP, EER, kW/ton
- Degree days (heating, cooling)
- Runtime hours, start counts
- Delta-T (water, air)
- Enthalpy (outdoor, return, supply)

### 2. Point Properties

Every point must have:

| Property             | Required | Notes                                                           |
| -------------------- | -------- | --------------------------------------------------------------- |
| `id`                 | Yes      | kebab-case, descriptive (e.g. `chilled-water-supply-temperature`) |
| `name`               | Yes      | Title case display name                                          |
| `category`           | Yes      | From the standard list above                                     |
| `subcategory`        | Yes      | Finer grouping within category                                   |
| `description`        | Yes      | What it measures/controls, where it's found                      |
| `kind`               | Yes      | `Number` or `Bool`                                               |
| `point_function`     | Yes      | `alarm`, `command`, `sensor`, `setpoint`, `status`, `calculated`, `enable`, `schedule` |
| `haystack_tag_string`| Yes      | Haystack 4 marker tag combination                                |
| `haystack_unit`      | If Number| Standard Haystack unit                                           |
| `haystack_kind`      | Yes      | `Number`, `Bool`, or `Str`                                       |
| `brick`              | If known | BRICK Schema class URI                                           |

### 3. Haystack Tags

Follow Project Haystack 4 conventions:
- Use standard tag combinations: `discharge air temp sensor point`
- Common tag patterns:
  - Sensor: `{medium} {measurement} sensor point` (e.g. `discharge air temp sensor point`)
  - Setpoint: `{medium} {measurement} sp point` (e.g. `discharge air temp sp point`)
  - Command: `{equipment} cmd point` (e.g. `valve cmd point`)
  - Status: `{equipment} run point` or `{condition} point`
- Populate `point_haystack_tags` with individual tags and their kinds

### 4. BRICK Classes

Use BRICK Schema ontology (v1.3+):
- Format: `https://brickschema.org/schema/Brick#Class_Name`
- Sensors: `Supply_Air_Temperature_Sensor`, `Zone_Air_Temperature_Sensor`
- Setpoints: `Supply_Air_Temperature_Setpoint`, `Zone_Air_Temperature_Setpoint`
- Commands: `Cooling_Valve_Command`, `Damper_Position_Command`
- Status: `Fan_Status`, `Pump_Status`
- Alarms: `High_Temperature_Alarm`, `Filter_Alarm`

### 5. Units

For `Number` kind points, add all applicable units via `point_units`:

| Measurement     | Common Units                                    |
| --------------- | ----------------------------------------------- |
| Temperature     | `°F`, `°C`                                      |
| Pressure        | `psi`, `kPa`, `in.w.c.`, `Pa`, `bar`           |
| Airflow         | `cfm`, `L/s`, `m³/h`, `m³/s`                   |
| Water flow      | `gpm`, `L/s`, `m³/h`, `L/min`                  |
| Humidity        | `%RH`                                           |
| Percentage      | `%`                                             |
| Power           | `kW`, `W`, `hp`, `BTU/h`, `ton`                |
| Energy          | `kWh`, `MWh`, `BTU`, `therm`, `MJ`, `GJ`       |
| Voltage         | `V`, `kV`                                       |
| Current         | `A`, `mA`                                       |
| Speed           | `rpm`, `Hz`, `%`                                |
| CO2             | `ppm`                                           |
| Time            | `hr`, `min`, `s`                                |

### 6. States

For `Bool` kind points, define states via `point_states`:

```
-- On/Off pattern (fans, pumps, commands)
state_key: 0, state_value: Off
state_key: 1, state_value: On

-- Open/Closed pattern (dampers, valves, contacts)
state_key: 0, state_value: Closed
state_key: 1, state_value: Open

-- Active/Inactive pattern (alarms, status)
state_key: 0, state_value: Inactive / Normal
state_key: 1, state_value: Active / Alarm

-- Occupied/Unoccupied pattern
state_key: 0, state_value: Unoccupied
state_key: 1, state_value: Occupied
```

### 7. Aliases

Add names that technicians actually use. This is critical for search.

**Common aliases** (`alias_group = 'common'`):
- `supply-air-temperature` -> "SAT", "supply air temp", "discharge air temperature", "DAT", "leaving air temp"
- `zone-temperature` -> "space temp", "room temp", "room temperature", "ZN-T", "ZNT"
- `damper-position` -> "damper pos", "damper cmd", "DPR", "DMR POS"
- `chilled-water-valve` -> "CHW valve", "cooling valve", "CWV", "CHWV"

**Misspelling aliases** (`alias_group = 'misspellings'`):
- "supply air temperture", "suppy air temp", "dischare air temp"
- "zone temperture", "space temperture"
- "damper postion", "damper positon"

Think about what a technician might type into a search box.

### 8. Related Points

Link points that commonly appear together or have logical relationships:

- `supply-air-temperature` <-> `supply-air-temperature-setpoint`
- `zone-temperature` <-> `cooling-setpoint`, `heating-setpoint`
- `damper-position` <-> `damper-command`
- `fan-status` <-> `fan-command`
- `chilled-water-supply-temperature` <-> `chilled-water-return-temperature`
- `airflow` <-> `airflow-setpoint`, `minimum-airflow-setpoint`, `maximum-airflow-setpoint`

Relationships are bidirectional -- insert both directions.

## Output Format

Return a JSON object with two arrays:

```json
{
  "apply": [
    {
      "sql": "INSERT OR IGNORE INTO points (id, name, category, subcategory, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES ('chilled-water-supply-temperature', 'Chilled Water Supply Temperature', 'temperatures', 'water', 'Temperature of chilled water leaving the chiller or entering the building distribution system. Critical for monitoring chiller plant performance.', 'Number', 'sensor', 'chilled water leaving temp sensor point', '°F', 'Number', 'https://brickschema.org/schema/Brick#Chilled_Water_Supply_Temperature_Sensor');",
      "confidence": "high",
      "reason": "Standard BAS point defined in both Haystack and BRICK ontologies"
    },
    {
      "sql": "INSERT OR IGNORE INTO point_units (point_id, unit) VALUES ('chilled-water-supply-temperature', '°F');",
      "confidence": "high",
      "reason": "Standard unit for water temperature measurement in US"
    },
    {
      "sql": "INSERT OR IGNORE INTO point_aliases (point_id, alias, alias_group) VALUES ('chilled-water-supply-temperature', 'CHWST', 'common');",
      "confidence": "high",
      "reason": "CHWST is the universal abbreviation for chilled water supply temperature"
    },
    {
      "sql": "INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES ('chilled-water-supply-temperature', 'chilled-water-return-temperature');",
      "confidence": "high",
      "reason": "Supply and return temperatures are always monitored together for delta-T"
    }
  ],
  "review": [
    {
      "sql": "INSERT OR IGNORE INTO points (id, name, category, subcategory, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind) VALUES ('refrigerant-suction-temperature', 'Refrigerant Suction Temperature', 'temperatures', 'refrigerant', 'Temperature of refrigerant gas at the compressor suction line. Used for superheat calculation and compressor protection.', 'Number', 'sensor', 'refrig suction temp sensor point', '°F', 'Number');",
      "confidence": "medium",
      "reason": "Common in chiller/RTU controls but Haystack tag combination may need verification"
    }
  ]
}
```

### Routing Rules

| Confidence | Action    | When to use                                                    |
| ---------- | --------- | -------------------------------------------------------------- |
| `high`     | `apply`   | Standard point in Haystack/BRICK, universally recognized       |
| `medium`   | `review`  | Point exists but tag/class/unit mapping needs verification     |
| `low`      | `review`  | Niche point or uncertain categorization                        |

### SQL Guidelines

- Use `INSERT OR IGNORE` for all new rows
- `id` values must be kebab-case, lowercase
- Escape single quotes within strings with `''`
- For `point_related`, insert both directions (A->B and B->A)
- For `point_states`, use string keys (`'0'`, `'1'`) for the `state_key`
- Group related SQL statements together (point + its units + its aliases + its states + its relations)

## Quality Checks

Before finalizing, verify:
- [ ] Point names match standard BAS terminology
- [ ] Categories are valid (from the standard list above)
- [ ] `kind` is correct (`Number` for measured values, `Bool` for binary states)
- [ ] `point_function` accurately reflects the point's role
- [ ] Haystack tag strings follow Project Haystack 4 conventions
- [ ] BRICK URIs use correct class names
- [ ] Units are appropriate for the measurement type
- [ ] States have the correct on/off or open/closed semantics
- [ ] Aliases are names a real technician would use or search for
- [ ] Related points actually have a logical relationship
- [ ] No duplicate entries (check `id` against current data)
- [ ] Number points have at least one unit
- [ ] Bool points have states defined
