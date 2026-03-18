-- =============================================================================
-- BAS Atlas Data Enrichment - Accuracy Fix Script v1
-- Generated: 2026-03-17
-- Fixes all items from consolidated review report
-- =============================================================================

-- =============================================================================
-- SECTION 1: EQUIPMENT FIXES (Items 1-35)
-- =============================================================================

BEGIN TRANSACTION;

-- Items 16-21 (CRITICAL): Fix hyphenated haystack_tag_string values
-- These are parsed by build-sqlite.ts splitting on spaces — hyphens create invalid single tags
UPDATE equipment SET haystack_tag_string = 'vrf indoorUnit' WHERE id = 'vrf-indoor-unit';
UPDATE equipment SET haystack_tag_string = 'vrf outdoorUnit' WHERE id = 'vrf-outdoor-unit';
UPDATE equipment SET haystack_tag_string = 'vrf branchBox' WHERE id = 'vrf-branch-selector-box';
UPDATE equipment SET haystack_tag_string = 'water meter' WHERE id = 'water-meter';
UPDATE equipment SET haystack_tag_string = 'elec meter' WHERE id = 'electric-meter';
UPDATE equipment SET haystack_tag_string = 'gas meter' WHERE id = 'natural-gas-meter';

-- Items 22-23 (MODERATE): More hyphenated haystack tags
UPDATE equipment SET haystack_tag_string = 'steam meter' WHERE id = 'steam-meter';
UPDATE equipment SET haystack_tag_string = 'btu meter' WHERE id = 'btu-meter';

-- Also fix the equipment_haystack_tags table (derived from haystack_tag_string)
-- Remove old hyphenated tags and insert correct split tags
DELETE FROM equipment_haystack_tags WHERE equipment_id IN (
  'vrf-indoor-unit', 'vrf-outdoor-unit', 'vrf-branch-selector-box',
  'water-meter', 'electric-meter', 'natural-gas-meter', 'steam-meter', 'btu-meter'
);
INSERT INTO equipment_haystack_tags (equipment_id, tag_name, tag_kind) VALUES
  ('vrf-indoor-unit', 'vrf', 'Marker'),
  ('vrf-indoor-unit', 'indoorUnit', 'Marker'),
  ('vrf-outdoor-unit', 'vrf', 'Marker'),
  ('vrf-outdoor-unit', 'outdoorUnit', 'Marker'),
  ('vrf-branch-selector-box', 'vrf', 'Marker'),
  ('vrf-branch-selector-box', 'branchBox', 'Marker'),
  ('water-meter', 'water', 'Marker'),
  ('water-meter', 'meter', 'Marker'),
  ('electric-meter', 'elec', 'Marker'),
  ('electric-meter', 'meter', 'Marker'),
  ('natural-gas-meter', 'gas', 'Marker'),
  ('natural-gas-meter', 'meter', 'Marker'),
  ('steam-meter', 'steam', 'Marker'),
  ('steam-meter', 'meter', 'Marker'),
  ('btu-meter', 'btu', 'Marker'),
  ('btu-meter', 'meter', 'Marker');

-- Item 1 (MODERATE): fan-coil-unit category → terminal-units
UPDATE equipment SET category = 'terminal-units' WHERE id = 'fan-coil-unit';

-- Item 4 (MODERATE): dehumidifier category → air-handling
UPDATE equipment SET category = 'air-handling' WHERE id = 'dehumidifier';

-- Item 5 (MODERATE): humidifier category → air-handling
UPDATE equipment SET category = 'air-handling' WHERE id = 'humidifier';

-- Item 7 (MODERATE): air-source-heat-pump haystack
UPDATE equipment SET haystack_tag_string = 'heatPump air' WHERE id = 'air-source-heat-pump';
DELETE FROM equipment_haystack_tags WHERE equipment_id = 'air-source-heat-pump';
INSERT INTO equipment_haystack_tags (equipment_id, tag_name, tag_kind) VALUES
  ('air-source-heat-pump', 'heatPump', 'Marker'),
  ('air-source-heat-pump', 'air', 'Marker');

-- Item 8 (MODERATE): water-source-heat-pump haystack
UPDATE equipment SET haystack_tag_string = 'heatPump water' WHERE id = 'water-source-heat-pump';
DELETE FROM equipment_haystack_tags WHERE equipment_id = 'water-source-heat-pump';
INSERT INTO equipment_haystack_tags (equipment_id, tag_name, tag_kind) VALUES
  ('water-source-heat-pump', 'heatPump', 'Marker'),
  ('water-source-heat-pump', 'water', 'Marker');

-- Item 10 (MODERATE): air-turnover-unit brick → closest real Brick class
UPDATE equipment SET brick = 'Air_Handling_Unit' WHERE id = 'air-turnover-unit';

-- Item 33 (MODERATE): domestic-water-recirculation-pump brick
UPDATE equipment SET brick = 'Domestic_Hot_Water_Pump' WHERE id = 'domestic-water-recirculation-pump';

-- Item 3 (MODERATE): VFD typical_points — remove supply-fan-specific, keep generic VFD points
DELETE FROM equipment_typical_points WHERE equipment_id = 'variable-frequency-drive'
  AND point_id IN ('supply-fan-command', 'supply-fan-speed', 'supply-fan-status', 'supply-fan-vfd-speed', 'motor-current-percentage');
-- Keep: vfd-speed-command, vfd-status, vfd-fault-alarm, equipment-run-hours, energy-consumption-kwh

-- Item 24 (MODERATE): heat-exchanger — add missing points for both sides
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('heat-exchanger', 'hot-water-supply-temperature'),
  ('heat-exchanger', 'hot-water-return-temperature');

-- Item 30 (MODERATE): steam-to-hot-water-converter — add return temp
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('steam-to-hot-water-converter', 'hot-water-return-temperature');

-- Item 32 (MODERATE): RTU — remove hydronic valve points (RTUs are DX/gas)
DELETE FROM equipment_typical_points WHERE equipment_id = 'rooftop-unit'
  AND point_id IN ('cooling-valve-output', 'heating-valve-output');

-- Item 34 (MINOR): ductless-mini-split description
UPDATE equipment SET description = 'Ductless split-system HVAC unit consisting of an indoor evaporator unit connected to an outdoor condensing unit via refrigerant piping. Available in wall-mounted, ceiling cassette, floor-standing, and concealed duct configurations.' WHERE id = 'ductless-mini-split';

-- Item 35 (MODERATE): Add parent_id relationships
UPDATE equipment SET parent_id = 'air-handling-unit' WHERE id = 'rooftop-unit';
UPDATE equipment SET parent_id = 'air-handling-unit' WHERE id = 'computer-room-air-conditioner';
UPDATE equipment SET parent_id = 'air-handling-unit' WHERE id = 'computer-room-air-handler';
UPDATE equipment SET parent_id = 'variable-air-volume-box' WHERE id = 'parallel-fan-powered-box';
UPDATE equipment SET parent_id = 'variable-air-volume-box' WHERE id = 'series-fan-powered-box';
UPDATE equipment SET parent_id = 'packaged-terminal-air-conditioner' WHERE id = 'packaged-terminal-heat-pump';

COMMIT;

-- =============================================================================
-- SECTION 2: POINTS FIXES (Items 100-122)
-- =============================================================================

BEGIN TRANSACTION;

-- Item 101 (CRITICAL): Standardize point_function — change all 'cmd' to 'command'
UPDATE points SET point_function = 'command' WHERE point_function = 'cmd';

-- Item 102 (CRITICAL): Standardize point_function — change all 'sp' to 'setpoint'
UPDATE points SET point_function = 'setpoint' WHERE point_function = 'sp';

-- Item 103 (CRITICAL): Fix 32 Bool status points misclassified as 'sensor'
UPDATE points SET point_function = 'status' WHERE id IN (
  'alarm-active-status',
  'compressor-status',
  'cooling-tower-fan-status',
  'defrost-status',
  'dehumidification-status',
  'dehumidifier-status',
  'economizer-status',
  'elevator-run-status',
  'emergency-lighting-status',
  'emergency-power-status',
  'escalator-run-status',
  'exhaust-fan-status-bool',
  'exterior-lighting-status',
  'fire-damper-status',
  'fire-mode-status',
  'fire-suppression-status',
  'free-cooling-status',
  'freeze-stat-status',
  'garage-exhaust-fan-status',
  'generator-run-status',
  'high-limit-status',
  'humidification-status',
  'humidifier-run-status',
  'kitchen-exhaust-fan-status',
  'lighting-status',
  'low-limit-status',
  'morning-warmup-status',
  'night-purge-status',
  'smoke-control-status',
  'standby-status',
  'ups-status',
  'vfd-status'
);

-- Item 104 (CRITICAL): Fix kind/function mismatches
UPDATE points SET point_function = 'sensor' WHERE id = 'chiller-entering-temperature';
UPDATE points SET kind = 'Bool' WHERE id = 'humidifier-enable';

-- Item 105 (MODERATE): Remove states from Number points that shouldn't have them
-- First, change pressure alarm points to Bool (they have binary states = alarm/normal)
UPDATE points SET kind = 'Bool' WHERE id IN (
  'discharge-air-high-pressure-alarm',
  'discharge-air-low-pressure-alarm',
  'return-air-high-pressure-alarm',
  'return-air-low-pressure-alarm'
);
-- Remove states from setpoint Number points (states make no sense on numeric values)
DELETE FROM point_states WHERE point_id IN (
  'occupied-cooling-setpoint',
  'occupied-heating-setpoint',
  'unoccupied-cooling-setpoint',
  'unoccupied-heating-setpoint'
);
-- Remove wrong enable states from chiller-entering-temperature (it's a sensor, not enable)
DELETE FROM point_states WHERE point_id = 'chiller-entering-temperature';

-- Item 106 (MODERATE): Add states to 27 Bool points missing them
-- Status points: 0=Off/Inactive, 1=On/Active
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'alarm-active-status','0','Normal,No Active Alarms' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='alarm-active-status' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'alarm-active-status','1','Alarm Active,Active Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='alarm-active-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'cooling-tower-fan-status','0','Off,Stopped' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='cooling-tower-fan-status' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'cooling-tower-fan-status','1','On,Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='cooling-tower-fan-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'dehumidification-status','0','Off,Inactive' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='dehumidification-status' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'dehumidification-status','1','On,Active,Dehumidifying' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='dehumidification-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'dehumidifier-status','0','Off,Stopped' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='dehumidifier-status' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'dehumidifier-status','1','On,Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='dehumidifier-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'emergency-lighting-status','0','Off,Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='emergency-lighting-status' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'emergency-lighting-status','1','On,Emergency Active' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='emergency-lighting-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'exterior-lighting-status','0','Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='exterior-lighting-status' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'exterior-lighting-status','1','On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='exterior-lighting-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'fire-suppression-status','0','Normal,Standby' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='fire-suppression-status' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'fire-suppression-status','1','Active,Discharged' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='fire-suppression-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'garage-exhaust-fan-status','0','Off,Stopped' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='garage-exhaust-fan-status' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'garage-exhaust-fan-status','1','On,Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='garage-exhaust-fan-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'humidification-status','0','Off,Inactive' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='humidification-status' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'humidification-status','1','On,Active,Humidifying' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='humidification-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'humidifier-run-status','0','Off,Stopped' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='humidifier-run-status' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'humidifier-run-status','1','On,Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='humidifier-run-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'kitchen-exhaust-fan-status','0','Off,Stopped' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='kitchen-exhaust-fan-status' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'kitchen-exhaust-fan-status','1','On,Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='kitchen-exhaust-fan-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'ups-status','0','Off,Unavailable' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='ups-status' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'ups-status','1','On,Available,Online' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='ups-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'lighting-schedule','0','Off,Unoccupied' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='lighting-schedule' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'lighting-schedule','1','On,Occupied' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='lighting-schedule' AND state_key='1');
-- Command points: 0=Off/Stop, 1=On/Start
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'cooling-tower-fan-command','0','Stop,Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='cooling-tower-fan-command' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'cooling-tower-fan-command','1','Start,On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='cooling-tower-fan-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'exterior-lighting-command','0','Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='exterior-lighting-command' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'exterior-lighting-command','1','On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='exterior-lighting-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'garage-exhaust-fan-command','0','Stop,Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='garage-exhaust-fan-command' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'garage-exhaust-fan-command','1','Start,On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='garage-exhaust-fan-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'kitchen-exhaust-fan-command','0','Stop,Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='kitchen-exhaust-fan-command' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'kitchen-exhaust-fan-command','1','Start,On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='kitchen-exhaust-fan-command' AND state_key='1');
-- Alarm points: 0=Normal, 1=Alarm
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'elevator-alarm','0','Normal,OK' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='elevator-alarm' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'elevator-alarm','1','Alarm,Fault' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='elevator-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'generator-alarm','0','Normal,OK' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='generator-alarm' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'generator-alarm','1','Alarm,Fault' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='generator-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-co2-alarm','0','Normal,OK' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-co2-alarm' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-co2-alarm','1','High CO2,Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-co2-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-condenser-pressure-alarm','0','Normal,OK' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-condenser-pressure-alarm' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-condenser-pressure-alarm','1','High Pressure,Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-condenser-pressure-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-duct-static-pressure-alarm','0','Normal,OK' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-duct-static-pressure-alarm' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-duct-static-pressure-alarm','1','High Pressure,Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-duct-static-pressure-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-humidity-alarm','0','Normal,OK' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-humidity-alarm' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-humidity-alarm','1','High Humidity,Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-humidity-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'low-duct-static-pressure-alarm','0','Normal,OK' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='low-duct-static-pressure-alarm' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'low-duct-static-pressure-alarm','1','Low Pressure,Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='low-duct-static-pressure-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'low-humidity-alarm','0','Normal,OK' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='low-humidity-alarm' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'low-humidity-alarm','1','Low Humidity,Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='low-humidity-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'low-suction-pressure-alarm','0','Normal,OK' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='low-suction-pressure-alarm' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'low-suction-pressure-alarm','1','Low Pressure,Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='low-suction-pressure-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'ups-alarm','0','Normal,OK' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='ups-alarm' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'ups-alarm','1','Alarm,Fault,Battery Low' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='ups-alarm' AND state_key='1');

-- Item 107 (MODERATE): Add units to Number points missing them
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('cooling-degree-days', '°F·day'),
  ('cooling-degree-days', '°C·day'),
  ('heating-degree-days', '°F·day'),
  ('heating-degree-days', '°C·day');
-- lighting-scene-command and outdoor-air-quality-index are dimensionless — skip

-- Item 108 (MODERATE): Differentiate duplicate point names
UPDATE points SET name = 'Exhaust Fan Run Command' WHERE id = 'exhaust-fan-command-bool';
UPDATE points SET name = 'Exhaust Fan Speed Command' WHERE id = 'exhaust-fan-command';
UPDATE points SET name = 'Exhaust Fan Run Status' WHERE id = 'exhaust-fan-status-bool';
UPDATE points SET name = 'Exhaust Fan Speed Feedback' WHERE id = 'exhaust-fan-status';
UPDATE points SET name = 'Condenser Water Pump Run Command' WHERE id = 'condenser-water-pump-command-bool';
UPDATE points SET name = 'Condenser Water Pump Speed Command' WHERE id = 'condenser-water-pump-command';
UPDATE points SET name = 'Relief Fan Run Command' WHERE id = 'relief-fan-command-bool';
UPDATE points SET name = 'Relief Fan Speed Command' WHERE id = 'relief-fan-command';
-- Remove duplicate humidity-setpoint (keep zone-humidity-setpoint)
DELETE FROM point_aliases WHERE point_id = 'humidity-setpoint';
DELETE FROM point_units WHERE point_id = 'humidity-setpoint';
DELETE FROM point_states WHERE point_id = 'humidity-setpoint';
DELETE FROM point_related WHERE point_id = 'humidity-setpoint' OR related_point_id = 'humidity-setpoint';
DELETE FROM equipment_typical_points WHERE point_id = 'humidity-setpoint';
DELETE FROM point_haystack_tags WHERE point_id = 'humidity-setpoint';
DELETE FROM points WHERE id = 'humidity-setpoint';

-- Item 109 (MODERATE): dx-cooling-stage and electric-heat-stage → Number
UPDATE points SET kind = 'Number' WHERE id IN ('dx-cooling-stage', 'electric-heat-stage');
-- Remove any Bool states from these (they're now Number staging points)
DELETE FROM point_states WHERE point_id IN ('dx-cooling-stage', 'electric-heat-stage');
-- Add units for staging
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('dx-cooling-stage', 'stages'),
  ('electric-heat-stage', 'stages');

-- Item 110 (MODERATE): Fix non-standard 'calculated' point_function
UPDATE points SET point_function = 'setpoint' WHERE id IN (
  'effective-cooling-setpoint',
  'effective-discharge-air-temperature-setpoint',
  'effective-heating-setpoint'
);
UPDATE points SET point_function = 'status' WHERE id = 'effective-occupancy';

-- Item 111 (MODERATE): Move approach temps to temperatures category
UPDATE points SET category = 'temperatures' WHERE id IN (
  'condenser-approach-temperature',
  'evaporator-approach-temperature'
);

-- Item 112 (MODERATE): Remove hydronic valve points from RTU (already done in equipment section)
-- (handled by Item 32 DELETE above)

-- Item 113 (MODERATE): lighting-schedule function → command
UPDATE points SET point_function = 'command' WHERE id = 'lighting-schedule';

-- Item 114 (MODERATE): Damper open/closed end-switch points → status
UPDATE points SET point_function = 'status' WHERE id IN (
  'bypass-damper-closed',
  'bypass-damper-open',
  'exhaust-air-damper-closed',
  'exhaust-air-damper-open',
  'mixed-air-damper-closed',
  'mixed-air-damper-open',
  'outside-air-damper-closed',
  'outside-air-damper-open',
  'relief-air-damper-closed',
  'relief-air-damper-open',
  'return-air-damper-closed',
  'return-air-damper-open',
  'smoke-damper-open'
);

-- Item 115 (MINOR): shutdown → command
UPDATE points SET point_function = 'command' WHERE id = 'shutdown';

-- Item 116 (MINOR): Remove duplicate fire-damper-position (fire-damper-status already exists)
DELETE FROM point_aliases WHERE point_id = 'fire-damper-position';
DELETE FROM point_units WHERE point_id = 'fire-damper-position';
DELETE FROM point_states WHERE point_id = 'fire-damper-position';
DELETE FROM point_related WHERE point_id = 'fire-damper-position' OR related_point_id = 'fire-damper-position';
DELETE FROM equipment_typical_points WHERE point_id = 'fire-damper-position';
DELETE FROM point_haystack_tags WHERE point_id = 'fire-damper-position';
DELETE FROM points WHERE id = 'fire-damper-position';

COMMIT;

-- =============================================================================
-- SECTION 3: MODELS & BRANDS FIXES (Items 200-241)
-- =============================================================================

BEGIN TRANSACTION;

-- Item 200 (CRITICAL): Remove N2 protocol from Trane models (N2 is JCI proprietary)
DELETE FROM model_protocols WHERE model_id IN ('trane-tracer-sc-plus', 'trane-tracer-es') AND protocol = 'N2';

-- Item 204 (CRITICAL): Remove N2 protocol from Honeywell WEBs-AX
DELETE FROM model_protocols WHERE model_id = 'honeywell-wb350' AND protocol = 'N2';

-- Note: Keep N2 for JCI models (johnson-controls-metasys, johnson-controls-nae55, johnson-controls-cgm09090) — it's their protocol

-- Item 201 (CRITICAL): Remove Trane XV80 (residential gas furnace)
DELETE FROM model_protocols WHERE model_id = 'trane-xv80';
DELETE FROM model_equipment WHERE model_id = 'trane-xv80';
DELETE FROM model_numbers WHERE model_id = 'trane-xv80';
DELETE FROM models WHERE id = 'trane-xv80';

-- Item 202 (CRITICAL): Remove Trane Nexia Home (residential smart home platform)
DELETE FROM model_protocols WHERE model_id = 'trane-nexia';
DELETE FROM model_equipment WHERE model_id = 'trane-nexia';
DELETE FROM model_numbers WHERE model_id = 'trane-nexia';
DELETE FROM models WHERE id = 'trane-nexia';

-- Item 203 (CRITICAL): Fix Belimo LRB24-3-T equipment links
-- Remove inappropriate links (too small for chiller/boiler isolation valves)
DELETE FROM model_equipment WHERE model_id = 'belimo-lrb24-3-t' AND equipment_id IN ('chiller', 'boiler');
-- Update description to be specific
UPDATE models SET description = 'Non-spring return characterized control ball valve actuator, 24V AC/DC, 45 in-lb torque, 3-point floating control. For 1/2" to 1-1/4" ball valves.' WHERE id = 'belimo-lrb24-3-t';

-- Item 208 (MODERATE): Fix Siemens PXC5 type
UPDATE models SET type_id = 'network-controllers' WHERE id = 'siemens-pxc5';

-- Item 209 (MODERATE): Fix Delta Controls eBCON-HR type
UPDATE models SET type_id = 'unitary-controllers' WHERE id = 'delta-controls-ebcon-hr';

-- Item 210 is already correct (se6104a already has type_id = 'unitary-controllers')

-- Item 211 (MODERATE): Fix ME812u — remove wrong equipment links and fix type
UPDATE models SET type_id = 'zone-controllers' WHERE id = 'automated-logic-me812u';
DELETE FROM model_equipment WHERE model_id = 'automated-logic-me812u'
  AND equipment_id IN ('building-controller', 'area-controller');

-- Item 212 (MODERATE): Remove duplicate Schneider SmartX AS-B entry
-- Keep schneider-electric-smartx-as-b, remove schneider-electric-sxwaspxxx
DELETE FROM model_protocols WHERE model_id = 'schneider-electric-sxwaspxxx';
DELETE FROM model_equipment WHERE model_id = 'schneider-electric-sxwaspxxx';
DELETE FROM model_numbers WHERE model_id = 'schneider-electric-sxwaspxxx';
DELETE FROM models WHERE id = 'schneider-electric-sxwaspxxx';
-- Fix the kept entry's type to network-controllers
UPDATE models SET type_id = 'network-controllers' WHERE id = 'schneider-electric-smartx-as-b';

-- Item 213 (MODERATE): Fix Honeywell PUL6438S name
UPDATE models SET name = 'Spyder PUL Series', description = 'Honeywell Spyder programmable unitary controller for AHU, RTU, and custom HVAC applications. Configurable I/O with BACnet communication.' WHERE id = 'honeywell-pul6438s';

-- Item 214 (MODERATE): Fix Honeywell WB350 name to match product
UPDATE models SET name = 'WEBs-AX (Niagara AX)', slug = 'webs-ax' WHERE id = 'honeywell-wb350';

-- Item 215 (MODERATE): Fix JCI FAC-3531 to real model
UPDATE models SET name = 'FX-PCG3611', slug = 'fx-pcg3611', description = 'Johnson Controls Facility Explorer application controller with configurable I/O for AHU and central plant control.' WHERE id = 'johnson-controls-fac-3531';

-- Item 216 (MODERATE): Remove duplicate JCI CGM09090 (NAE55 already exists)
DELETE FROM model_protocols WHERE model_id = 'johnson-controls-cgm09090';
DELETE FROM model_equipment WHERE model_id = 'johnson-controls-cgm09090';
DELETE FROM model_numbers WHERE model_id = 'johnson-controls-cgm09090';
DELETE FROM models WHERE id = 'johnson-controls-cgm09090';

-- Item 217 (MODERATE): Mark JCI D-9100 as discontinued
UPDATE models SET status = 'discontinued' WHERE id = 'johnson-controls-d-9100';

-- Item 218 (MODERATE): Mark Honeywell WEBs-AX as legacy
UPDATE models SET status = 'legacy' WHERE id = 'honeywell-wb350';

-- Item 219 (MODERATE): Remove BACnet MSTP from Siemens QPA2002 (analog sensor)
DELETE FROM model_protocols WHERE model_id = 'siemens-qpa2002';

-- Item 220 (MODERATE): Add descriptions to equipment types
UPDATE types SET description = 'High-level BAS controllers providing scheduling, trending, alarming, and operator interface across multiple field controllers.' WHERE id = 'supervisory-controllers';
UPDATE types SET description = 'Mid-level controllers managing communication between supervisory and field-level devices on a building network.' WHERE id = 'network-controllers';
UPDATE types SET description = 'Field-level controllers designed to control individual pieces of HVAC equipment such as AHUs and RTUs.' WHERE id = 'unitary-controllers';
UPDATE types SET description = 'Controllers dedicated to VAV box and terminal unit control with zone-level regulation.' WHERE id = 'vav-controllers';
UPDATE types SET description = 'Controllers for individual zone regulation including fan coil units, heat pumps, and unit ventilators.' WHERE id = 'zone-controllers';
UPDATE types SET description = 'User-facing thermostats and zone sensors providing temperature sensing and occupant interface.' WHERE id = 'thermostats';
UPDATE types SET description = 'Building automation software platforms for system configuration, monitoring, and management.' WHERE id = 'software';
UPDATE types SET description = 'Temperature sensing devices for air, water, and surface measurement in HVAC systems.' WHERE id = 'temperature-sensors';
UPDATE types SET description = 'Differential and static pressure sensing devices for duct, pipe, and building pressurization monitoring.' WHERE id = 'pressure-sensors';
UPDATE types SET description = 'CO2 and indoor air quality sensing devices for demand-controlled ventilation.' WHERE id = 'co2-sensors';
UPDATE types SET description = 'Indoor air quality sensors measuring multiple parameters including CO2, VOC, and particulates.' WHERE id = 'air-quality-sensors';
UPDATE types SET description = 'Humidity and moisture sensing devices for HVAC environmental monitoring.' WHERE id = 'humidity-sensors';
UPDATE types SET description = 'Electrical power and energy metering devices for building energy management.' WHERE id = 'meters';
UPDATE types SET description = 'Motor-driven actuators for controlling valve position in hydronic piping systems.' WHERE id = 'valve-actuators';
UPDATE types SET description = 'Motor-driven actuators for controlling damper position in air handling systems.' WHERE id = 'damper-actuators';
UPDATE types SET description = 'Devices for monitoring and controlling airflow volume in duct systems.' WHERE id = 'airflow-sensors';
UPDATE types SET description = 'Occupancy and motion detection devices for demand-based HVAC and lighting control.' WHERE id = 'occupancy-sensors';
UPDATE types SET description = 'Variable frequency drives for motor speed control on fans, pumps, and compressors.' WHERE id = 'vfds';

-- Item 221 (MODERATE): Fix Honeywell C7632 CO2 sensor
-- Already has no network protocols after Item 219-style check; fix the ID mismatch
UPDATE models SET slug = 'c7632', description = 'Wall-mount CO2 sensor with analog output (4-20 mA or 0-10 VDC) for demand-controlled ventilation.' WHERE id = 'honeywell-cdb';

-- Item 222 (MODERATE): Fix Schneider TC VAV name
UPDATE models SET name = 'MicroNet MN-VAV', slug = 'mn-vav', description = 'Schneider Electric MicroNet VAV controller for variable air volume terminal unit control.' WHERE id = 'schneider-electric-tc-vav';

-- Item 206 (MODERATE): Add Automated Logic brand description
UPDATE brands SET description = 'A Carrier company providing the WebCTRL building automation system with BACnet-native controllers and web-based management for commercial buildings.' WHERE id = 'automated-logic';

-- Item 224 (MINOR): Fix Delta Controls ORCAview ID mismatch
UPDATE models SET slug = 'orcaview' WHERE id = 'delta-controls-orbcad';

-- Item 225 (MINOR): Fix JCI VA-7480 description
UPDATE models SET description = 'Electric spring-return valve actuator for 2-way and 3-way globe control valves, proportional or floating control.' WHERE id = 'johnson-controls-va-7480';

-- Item 226 (MINOR): Fix Honeywell DP Series name
UPDATE models SET name = 'DPT Series', slug = 'dpt-series', description = 'Honeywell duct and building differential pressure transmitter for static pressure monitoring and control.' WHERE id = 'honeywell-dp-series';

-- Item 227 (MINOR): Fix Schneider MN-FCU description
UPDATE models SET name = 'MicroNet MN-S FCU', slug = 'mn-s-fcu', description = 'Schneider Electric MicroNet Simplicity controller configured for fan coil unit applications.' WHERE id = 'schneider-electric-mn-fcu';

-- Item 228 (MINOR): Fix Schneider STB temp sensor
UPDATE models SET name = 'STO Series Temp Sensor', slug = 'sto-series', description = 'Schneider Electric temperature sensor for duct, pipe, and room applications.' WHERE id = 'schneider-electric-stb';

-- Item 229 (MINOR): Fix Schneider MA Series actuators
UPDATE models SET name = 'MS/MD Series Damper Actuators', slug = 'ms-md-series', description = 'Schneider Electric spring-return (MS) and non-spring-return (MD) damper actuators for air handling systems.' WHERE id = 'schneider-electric-ma-series';

-- Item 230 (MINOR): Fix Trane BCU
UPDATE models SET description = 'Trane Building Control Unit — supervisory controller providing scheduling, trending, and BACnet routing for Tracer-based building automation systems.' WHERE id = 'trane-bcu';

-- Item 231 (MINOR): Fix Trane CH530 description
UPDATE models SET description = 'Trane Adaptive Control embedded chiller controller (CH530) for centrifugal and screw chillers. Equipment-embedded, not a standalone BAS controller.' WHERE id = 'trane-chiller-controller';

-- Item 232 (MINOR): Mark Schneider MN-S4 as legacy
UPDATE models SET status = 'legacy' WHERE id = 'schneider-electric-mn-s4';

-- Item 233 (MINOR): Mark Distech ECB-VAV as legacy
UPDATE models SET status = 'legacy' WHERE id = 'distech-controls-ecb-vav';

-- Item 234 (MINOR): Fix Veris Hawkeye description
UPDATE models SET description = 'Veris Hawkeye split-core current transformer (CT) series for electrical current measurement. Used with power meters for energy monitoring.' WHERE id = 'veris-hawkeye';

-- Item 235 (MINOR): Fix Veris AFLP description
UPDATE models SET description = 'Veris AFLP pitot tube-based airflow measurement station for duct velocity and volume measurement. Uses differential pressure sensing to calculate airflow.' WHERE id = 'veris-aflp';

-- Item 240 (MINOR): Fix Honeywell PVA4024AS
UPDATE models SET name = 'JADE W7220 VAV', slug = 'jade-w7220', description = 'Honeywell JADE economizer and integrated VAV controller for rooftop unit and VAV applications.' WHERE id = 'honeywell-pva4024as';

COMMIT;

-- =============================================================================
-- SECTION 4: REBUILD SEARCH INDEX
-- =============================================================================
-- The search_index FTS table may need rebuilding after these changes.
-- This will be handled by the application or a separate rebuild step.
