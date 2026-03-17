# BAS Atlas Research Program

## Mission

Make BAS Atlas the most comprehensive, accurate, and practically useful Building Automation Systems data reference available. Every entry should be something a BAS technician, engineer, or integrator would recognize and find valuable.

## Industry Context

BAS Atlas covers the HVAC building automation industry:

- **Protocols**: BACnet (IP/MSTP), Modbus (TCP/RTU), LON, N2, P1, KNX, DALI, EnOcean
- **Standards**: Project Haystack (tags/ontology), BRICK Schema (ontology), ASHRAE standards
- **Equipment**: AHUs, VAVs, RTUs, chillers, boilers, cooling towers, heat pumps, VRF/VRV systems, sensors, actuators, controllers, meters, VFDs, dampers, valves, fans, pumps
- **Disciplines**: HVAC controls, energy management, lighting controls, fire/life safety, power monitoring, refrigeration

## Database Schema

```sql
-- Core product catalog
brands (id, name, slug, logo_url, website, description)
types (id, name, slug, description)
models (id, brand_id, type_id, name, slug, description, status, manufacturer_url, image_url, added_at)
model_numbers (model_id, model_number)
model_protocols (model_id, protocol)
model_equipment (model_id, equipment_id)

-- Equipment ontology
equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id)
equipment_aliases (equipment_id, alias, alias_group)          -- alias_group: common | misspellings
equipment_haystack_tags (equipment_id, tag_name, tag_kind)
equipment_subtypes (equipment_id, subtype_id, subtype_name, description)
equipment_typical_points (equipment_id, point_id)

-- Point concepts
points (id, name, category, subcategory, description, brick, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind)
point_aliases (point_id, alias, alias_group)                  -- alias_group: common | misspellings
point_haystack_tags (point_id, tag_name, tag_kind)
point_units (point_id, unit)
point_states (point_id, state_key, state_value)
point_related (point_id, related_point_id)

-- Full-text search
search_index (entry_id, entry_type, name, tokens)             -- FTS5
```

## Data Quality Principles

1. **Accuracy over quantity.** Every entry must be correct and verifiable. A smaller, accurate database is more valuable than a large one with errors.
2. **Source hierarchy.** Trust data in this order:
   - Manufacturer websites, spec sheets, and product catalogs (highest)
   - Industry standards (Haystack, BRICK, ASHRAE) for ontology data
   - Well-established industry practice and convention
   - Reasoned inference from known data (lowest -- flag for review)
3. **Real-world relevance.** If a BAS technician wouldn't recognize it, question whether it belongs.

## Guardrails

| Action   | Policy                                                              |
| -------- | ------------------------------------------------------------------- |
| **ADD**  | Freely add new rows when sourced or clearly correct                 |
| **UPDATE** | Allowed when a better source contradicts existing data            |
| **DELETE** | Never auto-delete. Propose deletions for human review only        |

All changes must include:
- Confidence level (`high`, `medium`, `low`)
- Reason / source URL
- Routing: `apply` (high confidence, safe) or `review` (needs human eyes)

## Target Metrics

| Metric                          | Current | Target   |
| ------------------------------- | ------- | -------- |
| Models per major brand          | varies  | 15+      |
| Equipment types                 | ~50     | 100+     |
| Point concepts                  | ~259    | 500+     |
| Typical points per equipment    | varies  | 8+       |
| Brands with descriptions        | partial | 100%     |
| Equipment with Haystack tags    | partial | 100%     |
| Equipment with BRICK classes    | partial | 100%     |
| Points with aliases             | partial | 90%+     |
| Points with related points      | partial | 80%+     |

## Research Workflow

1. **Task selection** -- identify gaps in the database (missing brands, sparse equipment, low point counts)
2. **Data gathering** -- scrape manufacturer sites, reference standards documents
3. **Prompt execution** -- use the appropriate prompt template with gathered data
4. **SQL generation** -- researcher produces categorized SQL statements
5. **Application** -- `apply` items run automatically; `review` items queue for human approval
6. **Verification** -- spot-check applied changes against sources
