-- BAS Atlas Batch Enrichment v3 — Fill missing fields on existing entries
-- Focuses on: type descriptions, equipment full_names, equipment aliases,
-- model protocols, model-equipment links, subtype descriptions, manufacturer URLs

BEGIN TRANSACTION;

-- ═══════════════════════════════════════════════════════════
-- 1. TYPE DESCRIPTIONS (3 missing)
-- ═══════════════════════════════════════════════════════════

UPDATE types SET description = 'Protocol translation devices that bridge different building automation networks, enabling communication between systems using BACnet, Modbus, LON, and other protocols.' WHERE id = 'gateways' AND (description IS NULL OR description = '');
UPDATE types SET description = 'Variable frequency drives and motor controllers for modulating fan, pump, and compressor speeds in HVAC systems to optimize energy efficiency.' WHERE id = 'vfds-drives' AND (description IS NULL OR description = '');
UPDATE types SET description = 'Miscellaneous building automation products and accessories that do not fit into other specific equipment categories.' WHERE id = 'other' AND (description IS NULL OR description = '');

-- ═══════════════════════════════════════════════════════════
-- 2. EQUIPMENT FULL NAMES (55 missing)
-- ═══════════════════════════════════════════════════════════

-- Air-handling
UPDATE equipment SET full_name = 'Air Handling Unit' WHERE id = 'air-handling-unit' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Air-Source Heat Pump Unit' WHERE id = 'air-source-heat-pump' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Air Turnover Unit' WHERE id = 'air-turnover-unit' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Computer Room Air Conditioning Unit' WHERE id = 'computer-room-air-conditioner' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Computer Room Air Handler' WHERE id = 'computer-room-air-handler' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Dedicated Outdoor Air System' WHERE id = 'dedicated-outdoor-air-system' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Dehumidification Unit' WHERE id = 'dehumidifier' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Energy Recovery Ventilator' WHERE id = 'energy-recovery-ventilator' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Heat Recovery Ventilator' WHERE id = 'heat-recovery-ventilator' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Humidification Unit' WHERE id = 'humidifier' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Makeup Air Unit' WHERE id = 'makeup-air-unit' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Packaged Terminal Air Conditioner' WHERE id = 'packaged-terminal-air-conditioner' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Packaged Terminal Heat Pump' WHERE id = 'packaged-terminal-heat-pump' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Rooftop Packaged Air Conditioning Unit' WHERE id = 'rooftop-unit' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Unit Ventilator' WHERE id = 'unit-ventilator' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Water-Source Heat Pump Unit' WHERE id = 'water-source-heat-pump' AND full_name IS NULL;

-- Central-plant
UPDATE equipment SET full_name = 'Hydronic Air Separator' WHERE id = 'air-separator' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Hot Water or Steam Boiler' WHERE id = 'boiler' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Water Chiller' WHERE id = 'chiller' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Air-Cooled or Water-Cooled Condensing Unit' WHERE id = 'condensing-unit' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Evaporative Cooling Tower' WHERE id = 'cooling-tower' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Hydronic Expansion Tank' WHERE id = 'expansion-tank' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Shell-and-Tube or Plate Heat Exchanger' WHERE id = 'heat-exchanger' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Hydronic Circulation Pump' WHERE id = 'pump' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Steam-to-Hot-Water Heat Exchanger' WHERE id = 'steam-to-hot-water-converter' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Variable Frequency Drive' WHERE id = 'variable-frequency-drive' AND full_name IS NULL;

-- Domestic water
UPDATE equipment SET full_name = 'Domestic Hot Water Heater' WHERE id = 'domestic-water-heater' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Domestic Hot Water Recirculation Pump' WHERE id = 'domestic-water-recirculation-pump' AND full_name IS NULL;

-- Life safety
UPDATE equipment SET full_name = 'Fire Alarm Control Panel' WHERE id = 'fire-alarm-control-panel' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Smoke Detection Sensor' WHERE id = 'smoke-detector' AND full_name IS NULL;

-- Metering
UPDATE equipment SET full_name = 'BTU / Thermal Energy Meter' WHERE id = 'btu-meter' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Electrical Power Meter' WHERE id = 'electric-meter' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Natural Gas Consumption Meter' WHERE id = 'natural-gas-meter' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Steam Flow Meter' WHERE id = 'steam-meter' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Water Flow Meter' WHERE id = 'water-meter' AND full_name IS NULL;

-- Power distribution
UPDATE equipment SET full_name = 'Automatic Transfer Switch' WHERE id = 'automatic-transfer-switch' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Emergency Standby Generator' WHERE id = 'generator' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Uninterruptible Power Supply' WHERE id = 'uninterruptible-power-supply' AND full_name IS NULL;

-- Standalone fans
UPDATE equipment SET full_name = 'Exhaust Air Fan' WHERE id = 'exhaust-fan' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Transfer Air Fan' WHERE id = 'transfer-fan' AND full_name IS NULL;

-- Terminal units
UPDATE equipment SET full_name = 'Baseboard Convection Heater' WHERE id = 'baseboard-heater' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Blower Coil Unit' WHERE id = 'blower-coil-unit' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Chilled Beam' WHERE id = 'chilled-beam' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Constant Air Volume Terminal Box' WHERE id = 'constant-air-volume-box' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Ductless Mini-Split Heat Pump' WHERE id = 'ductless-mini-split' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Fan Coil Unit' WHERE id = 'fan-coil-unit' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Induction Terminal Unit' WHERE id = 'induction-unit' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Parallel Fan-Powered Variable Air Volume Box' WHERE id = 'parallel-fan-powered-box' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Hydronic Radiant Ceiling Panel' WHERE id = 'radiant-panel' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Series Fan-Powered Variable Air Volume Box' WHERE id = 'series-fan-powered-box' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Unit Heater' WHERE id = 'unit-heater' AND full_name IS NULL;
UPDATE equipment SET full_name = 'Variable Air Volume Terminal Box' WHERE id = 'variable-air-volume-box' AND full_name IS NULL;

-- VRF
UPDATE equipment SET full_name = 'VRF Branch Selector Box' WHERE id = 'vrf-branch-selector-box' AND full_name IS NULL;
UPDATE equipment SET full_name = 'VRF Indoor Fan Coil Unit' WHERE id = 'vrf-indoor-unit' AND full_name IS NULL;
UPDATE equipment SET full_name = 'VRF Outdoor Condensing Unit' WHERE id = 'vrf-outdoor-unit' AND full_name IS NULL;

-- ═══════════════════════════════════════════════════════════
-- 3. EQUIPMENT ALIASES (46 equipment without any aliases)
-- ═══════════════════════════════════════════════════════════

-- Air-handling additions (enrichment-added equipment)
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('clean-room-ahu', 'CRA', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('clean-room-ahu', 'cleanroom air handler', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('clean-room-ahu', 'clean room air handling unit', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('clean-room-ahu', 'HEPA AHU', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('data-center-cooling', 'DCU', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('data-center-cooling', 'data center CRAC', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('data-center-cooling', 'data center CRAH', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('data-center-cooling', 'precision cooling', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('server-room-cooling', 'server room AC', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('server-room-cooling', 'server cooling unit', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('server-room-cooling', 'IT cooling', 'common');

-- Central-plant additions
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('condenser-water-pump', 'CWP', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('condenser-water-pump', 'condenser pump', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('condenser-water-pump', 'CW pump', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('chemical-treatment-system', 'water treatment', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('chemical-treatment-system', 'chemical feed', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('chemical-treatment-system', 'chemical injection system', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('glycol-feed-system', 'glycol system', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('glycol-feed-system', 'glycol feeder', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('glycol-feed-system', 'antifreeze system', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('hot-water-pump', 'HWP', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('hot-water-pump', 'HW pump', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('hot-water-pump', 'heating water pump', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('primary-chilled-water-pump', 'PCHWP', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('primary-chilled-water-pump', 'primary pump', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('primary-chilled-water-pump', 'primary CHW pump', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('secondary-chilled-water-pump', 'SCHWP', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('secondary-chilled-water-pump', 'secondary pump', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('secondary-chilled-water-pump', 'secondary CHW pump', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('steam-pressure-reducing-valve', 'PRV', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('steam-pressure-reducing-valve', 'steam PRV', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('steam-pressure-reducing-valve', 'pressure reducing station', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('water-treatment-system', 'water treatment', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('water-treatment-system', 'cooling tower water treatment', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('water-treatment-system', 'CT water treatment', 'common');

-- Controls
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('area-controller', 'AAC', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('area-controller', 'area control panel', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('area-controller', 'field controller', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('building-controller', 'BC', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('building-controller', 'supervisory controller', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('building-controller', 'BAS server', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('io-expansion-module', 'I/O module', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('io-expansion-module', 'expansion module', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('io-expansion-module', 'IO module', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('io-expansion-module', 'XM', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('light-level-sensor', 'lux sensor', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('light-level-sensor', 'illuminance sensor', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('light-level-sensor', 'photosensor', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('refrigerant-leak-detector', 'refrigerant monitor', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('refrigerant-leak-detector', 'freon detector', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('refrigerant-leak-detector', 'refrigerant sensor', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('vibration-sensor', 'vibration monitor', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('vibration-sensor', 'vibration transmitter', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('vibration-sensor', 'accelerometer', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('water-leak-detector', 'leak sensor', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('water-leak-detector', 'flood sensor', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('water-leak-detector', 'water detector', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('weather-station', 'outdoor air sensor', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('weather-station', 'OA sensor', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('weather-station', 'met station', 'common');

-- Domestic water
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('domestic-water-booster-pump', 'booster pump', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('domestic-water-booster-pump', 'water booster', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('domestic-water-booster-pump', 'pressure booster pump', 'common');

-- Life safety
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('smoke-control-panel', 'smoke control system', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('smoke-control-panel', 'SCS panel', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('smoke-control-panel', 'stairwell pressurization panel', 'common');

-- Lighting
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('daylight-sensor', 'daylight harvesting sensor', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('daylight-sensor', 'photocell', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('daylight-sensor', 'outdoor light sensor', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('dimmer-module', 'dimmer', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('dimmer-module', 'lighting dimmer', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('dimmer-module', 'dimming module', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('lighting-control-panel', 'LCP', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('lighting-control-panel', 'lighting panel', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('lighting-control-panel', 'lighting controller', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('lighting-relay-panel', 'LRP', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('lighting-relay-panel', 'relay panel', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('lighting-relay-panel', 'lighting relay', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('occupancy-lighting-controller', 'occupancy controller', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('occupancy-lighting-controller', 'occ sensor lighting', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('occupancy-lighting-controller', 'vacancy sensor', 'common');

-- Metering additions
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('demand-meter', 'peak demand meter', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('demand-meter', 'demand recorder', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('demand-meter', 'kW demand meter', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('flow-meter', 'flowmeter', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('flow-meter', 'flow transmitter', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('flow-meter', 'flow sensor', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('power-quality-meter', 'PQ meter', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('power-quality-meter', 'power analyzer', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('power-quality-meter', 'harmonics meter', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('thermal-energy-meter', 'BTU meter', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('thermal-energy-meter', 'energy meter', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('thermal-energy-meter', 'heat meter', 'common');

-- Refrigeration
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('condensing-unit-refrigeration', 'refrigeration CDU', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('condensing-unit-refrigeration', 'condensing unit', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('condensing-unit-refrigeration', 'outdoor refrigeration unit', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('reach-in-refrigerator', 'reach-in cooler', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('reach-in-refrigerator', 'commercial refrigerator', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('reach-in-refrigerator', 'upright cooler', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('refrigeration-rack', 'compressor rack', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('refrigeration-rack', 'rack system', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('refrigeration-rack', 'multi-compressor rack', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('walk-in-cooler', 'walk-in refrigerator', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('walk-in-cooler', 'cooler box', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('walk-in-cooler', 'cold room', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('walk-in-freezer', 'freezer box', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('walk-in-freezer', 'blast freezer', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('walk-in-freezer', 'cold storage freezer', 'common');

-- Standalone fans
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('garage-exhaust-fan', 'parking garage fan', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('garage-exhaust-fan', 'garage ventilation fan', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('garage-exhaust-fan', 'CO exhaust fan', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('kitchen-exhaust-fan', 'kitchen hood fan', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('kitchen-exhaust-fan', 'grease exhaust fan', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('kitchen-exhaust-fan', 'KEF', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('relief-fan', 'relief air fan', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('relief-fan', 'building relief fan', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('relief-fan', 'RLF', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('return-fan', 'return air fan', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('return-fan', 'RF', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('return-fan', 'RA fan', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('supply-fan', 'supply air fan', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('supply-fan', 'SF', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('supply-fan', 'SA fan', 'common');

-- Terminal units
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('cabinet-unit-heater', 'CUH', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('cabinet-unit-heater', 'cabinet heater', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('cabinet-unit-heater', 'wall heater', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('convector', 'convection heater', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('convector', 'kickspace heater', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('convector', 'perimeter heater', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('fin-tube-radiator', 'fin tube', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('fin-tube-radiator', 'radiator', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('fin-tube-radiator', 'perimeter radiation', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('radiant-floor', 'radiant heating', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('radiant-floor', 'in-floor heating', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('radiant-floor', 'floor radiant', 'common');

-- Vertical transport
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('elevator', 'lift', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('elevator', 'passenger elevator', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('elevator', 'freight elevator', 'common');

INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('escalator', 'moving stairway', 'common');
INSERT INTO equipment_aliases (equipment_id, alias, alias_group) VALUES ('escalator', 'moving walkway', 'common');

-- ═══════════════════════════════════════════════════════════
-- 4. MODEL PROTOCOLS (adding where confidently known)
-- ═══════════════════════════════════════════════════════════

-- Software platforms communicate via BACnet/IP to the BAS network
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-webctrl8', 'BACnet/IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-webctrl-mobile', 'BACnet/IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-orbcad', 'BACnet/IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-horyzon-envision', 'BACnet/IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-openblue', 'BACnet/IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-ics', 'BACnet/IP');

-- Johnson Controls D-9100 is a programmable controller
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-d-9100', 'N2');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-d-9100', 'BACnet MS/TP');

-- Schneider SmartX IP controller
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-smartx-ip', 'BACnet/IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-smartx-ip', 'Modbus TCP');

-- Siemens QPA2002 air quality sensor has BACnet comm option
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-qpa2002', 'BACnet MS/TP');

-- Trane XR724 thermostat
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-xr724', 'WiFi');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-xr724', 'Z-Wave');

-- Honeywell T10 Pro smart thermostat
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-t10-pro', 'WiFi');

-- Honeywell WEBs-AX (Niagara)
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-wb350', 'BACnet/IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-wb350', 'LON');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-wb350', 'Modbus TCP');

-- Honeywell C7632 CO2 sensor (Sylk bus versions available)
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-cdb', 'Modbus');

-- Honeywell ML6161A damper actuator has comm versions
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-ml6161a', 'Modbus');

-- Veris CDL CO2 series has Modbus
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-cdl', 'Modbus RTU');

-- Veris H8xx humidity series has BACnet/Modbus
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-h8xx', 'BACnet MS/TP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-h8xx', 'Modbus RTU');

-- Veris Hawkeye power meter
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-hawkeye', 'BACnet MS/TP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-hawkeye', 'Modbus RTU');

-- Veris PXU pressure sensor has Modbus
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-pxu', 'Modbus RTU');

-- Belimo P6 Series pressure independent valve has comm
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('belimo-p6-series', 'BACnet MS/TP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('belimo-p6-series', 'Modbus RTU');

-- Automated Logic ZS Pro zone sensor
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-zs-pro', 'BACnet MS/TP');

-- Distech Allure UNITOUCH thermostat
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-allure-unitouch', 'BACnet/IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-allure-unitouch', 'BACnet MS/TP');

-- Siemens RDF800KN thermostat with KNX
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-rdf800kn', 'KNX');

-- Automated Logic eSC supervisory controller
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-esc', 'BACnet/IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-esc', 'BACnet MS/TP');

-- Delta Controls O3 Hub gateway
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-o3-hub', 'BACnet/IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-o3-hub', 'Modbus TCP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-o3-hub', 'Modbus RTU');

-- Delta Controls eBCON-HR unitary controller
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-ebcon-hr', 'BACnet/IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-ebcon-hr', 'BACnet MS/TP');

-- Trane BCU controller
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-bcu', 'BACnet/IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-bcu', 'BACnet MS/TP');

-- Honeywell C7400A air quality sensor
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-c7400a', 'Modbus');

-- Johnson Controls TE-6300 temp sensor (passive analog, but adding for completeness)
-- Skipping: TE-6300 is a passive thermistor sensor with no digital protocol

-- Johnson Controls VA-7480 valve actuator (analog proportional)
-- Skipping: VA-7480 is an analog actuator

-- Schneider MS/MD damper actuators (analog)
-- Skipping: analog actuators

-- Siemens GDB/GLB damper actuators (analog OpenAir)
-- Skipping: analog actuators

-- Siemens MXG461 valve (magnetic, no digital comm)
-- Skipping: no digital protocol

-- Siemens QBM3020 pressure (analog output)
-- Skipping: analog sensor

-- Siemens SAX/SAT valve actuator (analog)
-- Skipping: analog actuator

-- Veris analog sensors (AFLP, CDD, CWLP, H200, PX, TW, TW2X)
-- Skipping: these are analog sensors with no digital communication

-- Belimo analog actuators (AF24-SR, LF24-SR, LMB24-3-T, NF24-SR)
-- Skipping: standard analog actuators

-- Belimo analog sensors (22ADP-54T, 22AHP-34, 22ATP-54)
-- Skipping: analog output sensors

-- Belimo valves (B2, B3 series are valve bodies, not actuators with protocol)
-- Skipping: valve bodies without digital protocol

-- Honeywell sensors (DPT, H7635B, VN Series)
-- Skipping: analog sensors/valve bodies

-- Schneider STO temp sensor
-- Skipping: analog sensor

-- ═══════════════════════════════════════════════════════════
-- 5. MODEL ↔ EQUIPMENT LINKS (9 unlinked models)
-- ═══════════════════════════════════════════════════════════

-- Automated Logic eSC (supervisory controller) - supervises various HVAC equipment
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-esc', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-esc', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-esc', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-esc', 'boiler');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-esc', 'cooling-tower');

-- Delta Controls O3 Hub (gateway) - bridges multiple equipment types
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-o3-hub', 'building-controller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-o3-hub', 'area-controller');

-- Delta Controls eBCON-HR (unitary controller)
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-ebcon-hr', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-ebcon-hr', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-ebcon-hr', 'makeup-air-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-ebcon-hr', 'dedicated-outdoor-air-system');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-ebcon-hr', 'fan-coil-unit');

-- Distech Controls Allure UNITOUCH (thermostat)
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-allure-unitouch', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-allure-unitouch', 'unit-ventilator');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-allure-unitouch', 'variable-air-volume-box');

-- Honeywell T10 Pro (smart thermostat)
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-t10-pro', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-t10-pro', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-t10-pro', 'ductless-mini-split');

-- Honeywell WEBs-AX (Niagara supervisory controller)
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-wb350', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-wb350', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-wb350', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-wb350', 'boiler');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-wb350', 'building-controller');

-- Schneider Electric SmartX IP (supervisory controller)
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-smartx-ip', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-smartx-ip', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-smartx-ip', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-smartx-ip', 'boiler');

-- Siemens RDF800KN (room thermostat)
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-rdf800kn', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-rdf800kn', 'unit-ventilator');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-rdf800kn', 'chilled-beam');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-rdf800kn', 'radiant-panel');

-- Trane BCU (network controller)
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-bcu', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-bcu', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-bcu', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-bcu', 'variable-air-volume-box');

-- ═══════════════════════════════════════════════════════════
-- 6. SUBTYPE DESCRIPTIONS (15 missing)
-- ═══════════════════════════════════════════════════════════

UPDATE equipment_subtypes SET description = 'Uses a refrigerant cycle with a compressor to condense moisture from the air stream' WHERE equipment_id = 'dehumidifier' AND subtype_id = 'refrigerant-dehumidifier' AND (description IS NULL OR description = '');
UPDATE equipment_subtypes SET description = 'Uses a desiccant wheel or material to absorb moisture from the air, regenerated by heat' WHERE equipment_id = 'dehumidifier' AND subtype_id = 'desiccant-dehumidifier' AND (description IS NULL OR description = '');

UPDATE equipment_subtypes SET description = 'Generates steam in a canister or boiler and injects it into the air stream via a dispersion tube' WHERE equipment_id = 'humidifier' AND subtype_id = 'steam-humidifier' AND (description IS NULL OR description = '');
UPDATE equipment_subtypes SET description = 'Passes air over a wetted media pad or spray to add moisture through evaporation' WHERE equipment_id = 'humidifier' AND subtype_id = 'evaporative-humidifier' AND (description IS NULL OR description = '');
UPDATE equipment_subtypes SET description = 'Uses high-frequency vibrations to create a fine water mist that is dispersed into the air' WHERE equipment_id = 'humidifier' AND subtype_id = 'ultrasonic-humidifier' AND (description IS NULL OR description = '');

UPDATE equipment_subtypes SET description = 'Water heater with electric resistance heating elements, common in smaller applications' WHERE equipment_id = 'domestic-water-heater' AND subtype_id = 'electric-water-heater' AND (description IS NULL OR description = '');
UPDATE equipment_subtypes SET description = 'Gas-fired water heater using natural gas or propane burners, available as tank or tankless' WHERE equipment_id = 'domestic-water-heater' AND subtype_id = 'gas-water-heater' AND (description IS NULL OR description = '');
UPDATE equipment_subtypes SET description = 'Uses a heat exchanger to transfer heat from a boiler or steam system to domestic water' WHERE equipment_id = 'domestic-water-heater' AND subtype_id = 'heat-exchanger-water-heater' AND (description IS NULL OR description = '');
UPDATE equipment_subtypes SET description = 'Uses a refrigerant heat pump cycle to extract heat from ambient air to heat water, highly efficient' WHERE equipment_id = 'domestic-water-heater' AND subtype_id = 'heat-pump-water-heater' AND (description IS NULL OR description = '');

UPDATE equipment_subtypes SET description = 'Uses a light source and photosensitive receiver to detect smoke particles scattering light' WHERE equipment_id = 'smoke-detector' AND subtype_id = 'photoelectric-smoke-detector' AND (description IS NULL OR description = '');
UPDATE equipment_subtypes SET description = 'Uses a small radioactive source to ionize air; smoke disrupts the ion current triggering alarm' WHERE equipment_id = 'smoke-detector' AND subtype_id = 'ionization-smoke-detector' AND (description IS NULL OR description = '');
UPDATE equipment_subtypes SET description = 'Installed in ductwork to detect smoke in the air handling system, triggers fan shutdown and damper closure' WHERE equipment_id = 'smoke-detector' AND subtype_id = 'duct-smoke-detector' AND (description IS NULL OR description = '');

UPDATE equipment_subtypes SET description = 'Cooling-only mini-split providing air conditioning without a heat pump reversing valve' WHERE equipment_id = 'ductless-mini-split' AND subtype_id = 'cooling-only-mini-split' AND (description IS NULL OR description = '');
UPDATE equipment_subtypes SET description = 'Reversible mini-split providing both heating and cooling via a heat pump cycle' WHERE equipment_id = 'ductless-mini-split' AND subtype_id = 'heat-pump-mini-split' AND (description IS NULL OR description = '');
UPDATE equipment_subtypes SET description = 'Single outdoor unit serving multiple indoor units, each independently controlled' WHERE equipment_id = 'ductless-mini-split' AND subtype_id = 'multi-zone-mini-split' AND (description IS NULL OR description = '');

-- ═══════════════════════════════════════════════════════════
-- 7. MANUFACTURER URLs (set to brand website for models missing them)
-- ═══════════════════════════════════════════════════════════

UPDATE models SET manufacturer_url = (SELECT website FROM brands WHERE brands.id = models.brand_id) WHERE manufacturer_url IS NULL;

COMMIT;
