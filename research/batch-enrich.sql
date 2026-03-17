-- BAS Atlas Batch Enrichment — Real BAS products, protocols, equipment links, and brand descriptions
-- Generated from manufacturer product knowledge

BEGIN TRANSACTION;

-- ═══════════════════════════════════════════════════════════
-- BRAND DESCRIPTIONS
-- ═══════════════════════════════════════════════════════════

UPDATE brands SET description = 'Belimo is the global market leader in damper actuators, control valves, and sensors for HVAC systems. Known for reliable, energy-efficient actuators used across commercial buildings worldwide.' WHERE id = 'belimo' AND description IS NULL;
UPDATE brands SET description = 'Delta Controls, a subsidiary of Delta Electronics, develops BACnet-native building automation controllers and software. Their products span supervisory controllers, application controllers, and smart sensors.' WHERE id = 'delta-controls' AND description IS NULL;
UPDATE brands SET description = 'Distech Controls, a Honeywell company, specializes in building automation solutions with a focus on open protocols and IoT connectivity. Known for their ECLYPSE series of connected controllers.' WHERE id = 'distech-controls' AND description IS NULL;
UPDATE brands SET description = 'Honeywell Building Technologies provides integrated building management systems, controllers, sensors, and thermostats for commercial and institutional facilities. One of the largest BAS manufacturers globally.' WHERE id = 'honeywell' AND description IS NULL;
UPDATE brands SET description = 'Johnson Controls is a global leader in smart buildings, offering the Metasys building automation platform along with a comprehensive line of controllers, sensors, and field devices for HVAC control.' WHERE id = 'johnson-controls' AND description IS NULL;
UPDATE brands SET description = 'Schneider Electric offers the EcoStruxure Building platform for building management, including SmartX controllers, sensors, and actuators. Strong focus on sustainability and energy management.' WHERE id = 'schneider-electric' AND description IS NULL;
UPDATE brands SET description = 'Siemens Smart Infrastructure provides the Desigo building automation platform with a comprehensive range of controllers, actuators, sensors, and room automation devices for commercial buildings.' WHERE id = 'siemens' AND description IS NULL;
UPDATE brands SET description = 'Trane, a brand of Trane Technologies, manufactures HVAC equipment and the Tracer building automation platform. Known for their integrated approach to controls and equipment.' WHERE id = 'trane' AND description IS NULL;
UPDATE brands SET description = 'Veris Industries specializes in energy monitoring and environmental sensing products for commercial buildings, including current transformers, power meters, CO2 sensors, pressure transducers, and temperature sensors.' WHERE id = 'veris' AND description IS NULL;

-- ═══════════════════════════════════════════════════════════
-- BELIMO — actuators, valves, sensors
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('belimo-lf24-sr', 'belimo', 'damper-actuators', 'LF24-SR', 'lf24-sr', 'Spring-return modulating damper actuator with 35 in-lb torque for small to medium HVAC dampers. 2-10 VDC or 4-20 mA control signal.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('belimo-nf24-sr', 'belimo', 'damper-actuators', 'NF24-SR', 'nf24-sr', 'Non-spring-return modulating damper actuator with 90 in-lb torque for larger commercial dampers.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('belimo-lmb24-3-t', 'belimo', 'damper-actuators', 'LMB24-3-T', 'lmb24-3-t', 'Non-spring-return 3-position damper actuator with auxiliary switch, 45 in-lb torque.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('belimo-b215-b225', 'belimo', 'valve-actuators', 'B2 Series (B215/B225)', 'b2-series', 'Characterized control valves in 1/2" to 1" sizes for chilled and hot water applications. Globe valve design with equal percentage characteristic.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('belimo-b3-series', 'belimo', 'valve-actuators', 'B3 Series (B315/B325)', 'b3-series', '3-way characterized control valves for mixing or diverting chilled/hot water. Sizes from 1/2" to 2".', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('belimo-p6-series', 'belimo', 'valve-actuators', 'P6000W Pressure Independent Valve', 'p6-series', 'Pressure independent characterized control valve combining flow control and balancing. Eliminates need for separate balancing valves.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('belimo-22atp-54', 'belimo', 'temperature-sensors', '22ATP-54', '22atp-54', 'Averaging temperature sensor with 10K Type III thermistor. Available in various lengths for duct mounting.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('belimo-22ahp-34', 'belimo', 'humidity-sensors', '22AHP-34', '22ahp-34', 'Duct-mount humidity and temperature combination sensor with 4-20 mA or 0-10 VDC output.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('belimo-zip-economizer', 'belimo', 'unitary-controllers', 'ZIP Economizer', 'zip-economizer', 'Integrated economizer control module with onboard sensors for rooftop unit economizer control.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('belimo-energy-valve', 'belimo', 'valve-actuators', 'Energy Valve', 'energy-valve', 'IoT-enabled pressure independent valve with integrated flow meter, energy metering, and cloud connectivity for hydronic system optimization.', 'current', datetime('now'));

-- Belimo protocols
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('belimo-energy-valve', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('belimo-energy-valve', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('belimo-energy-valve', 'Modbus RTU');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('belimo-zip-economizer', 'BACnet MSTP');

-- Belimo equipment links
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-lf24-sr', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-lf24-sr', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-lf24-sr', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-lf24-sr', 'energy-recovery-ventilator');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-nf24-sr', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-nf24-sr', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-nf24-sr', 'dedicated-outdoor-air-system');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-lmb24-3-t', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-lmb24-3-t', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-b215-b225', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-b215-b225', 'chilled-beam');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-b215-b225', 'unit-ventilator');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-b3-series', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-b3-series', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-b3-series', 'boiler');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-p6-series', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-p6-series', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-p6-series', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-energy-valve', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-energy-valve', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-energy-valve', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-22atp-54', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-22atp-54', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-22ahp-34', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-22ahp-34', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-zip-economizer', 'rooftop-unit');

-- ═══════════════════════════════════════════════════════════
-- DELTA CONTROLS
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('delta-controls-dac-1146', 'delta-controls', 'unitary-controllers', 'DAC-1146', 'dac-1146', 'Application controller for AHU and central plant equipment. 14 universal inputs, 6 universal outputs, native BACnet.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('delta-controls-dac-606', 'delta-controls', 'unitary-controllers', 'DAC-606', 'dac-606', 'Compact application controller for fan coil units, heat pumps, and unit ventilators with 6 inputs and 6 outputs.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('delta-controls-dvs', 'delta-controls', 'vav-controllers', 'DVS VAV Controller', 'dvs', 'Integrated VAV controller with onboard differential pressure sensor, actuator output, and reheat control.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('delta-controls-o3-sense', 'delta-controls', 'zone-controllers', 'O3 Sense', 'o3-sense', 'Multi-sensor room controller with temperature, humidity, CO2, VOC, occupancy, and light level sensing.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('delta-controls-ebcon-hr', 'delta-controls', 'network-controllers', 'eBCON-HR', 'ebcon-hr', 'High-resolution network controller with expanded I/O for complex mechanical systems.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('delta-controls-o3-hub', 'delta-controls', 'gateways', 'O3 Hub', 'o3-hub', 'Wireless gateway that connects O3 wireless devices to the eBMGR or eBCON network via 802.15.4.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('delta-controls-orbcad', 'delta-controls', 'software', 'ORCAview', 'orcaview', 'Browser-based building management front-end for Delta Controls systems providing graphics, trends, schedules, and alarm management.', 'current', datetime('now'));

-- Delta Controls protocols
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-dac-1146', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-dac-1146', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-dac-606', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-dvs', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-o3-sense', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-ebcon-hr', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-ebcon-hr', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-o3-hub', 'BACnet IP');

-- Delta Controls equipment links
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-dac-1146', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-dac-1146', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-dac-1146', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-dac-1146', 'boiler');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-dac-606', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-dac-606', 'unit-ventilator');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-dac-606', 'water-source-heat-pump');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-dvs', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-dvs', 'parallel-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-dvs', 'series-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-o3-sense', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-o3-sense', 'fan-coil-unit');

-- ═══════════════════════════════════════════════════════════
-- DISTECH CONTROLS
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('distech-controls-eclypse-connected-vav', 'distech-controls', 'vav-controllers', 'ECLYPSE Connected VAV', 'eclypse-connected-vav', 'IP-native VAV controller with integrated differential pressure sensor, BACnet/IP, and RESTful API for IoT integration.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('distech-controls-eclypse-connected-room', 'distech-controls', 'zone-controllers', 'ECLYPSE Connected Room Controller', 'eclypse-connected-room', 'Multi-protocol room controller supporting BACnet/IP, Modbus, and RESTful API for zone-level HVAC control.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('distech-controls-eclypse-ahu', 'distech-controls', 'unitary-controllers', 'ECLYPSE Connected AHU Controller', 'eclypse-ahu', 'Air handling unit controller with IP connectivity, integrated sequences, and cloud analytics support.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('distech-controls-ecb-vav', 'distech-controls', 'vav-controllers', 'ECB-VAV', 'ecb-vav', 'BACnet MSTP VAV controller with onboard pressure sensor and configurable I/O for single-duct and fan-powered applications.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('distech-controls-horyzon-envision', 'distech-controls', 'software', 'ENVISION for Horyzon', 'envision-horyzon', 'HTML5 building management interface with graphic design tools, dashboards, and mobile access for Distech systems.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('distech-controls-allure-unitouch', 'distech-controls', 'thermostats', 'Allure UNITOUCH', 'allure-unitouch', 'Touchscreen room sensor with temperature, humidity, and CO2 sensing. Supports BACnet MSTP and custom UI.', 'current', datetime('now'));

-- Distech protocols
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-eclypse-connected-vav', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-eclypse-connected-room', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-eclypse-connected-room', 'Modbus TCP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-eclypse-ahu', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-ecb-vav', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-allure-unitouch', 'BACnet MSTP');

-- Distech equipment links
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-eclypse-connected-vav', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-eclypse-connected-vav', 'parallel-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-eclypse-connected-vav', 'series-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-eclypse-connected-room', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-eclypse-connected-room', 'unit-ventilator');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-eclypse-connected-room', 'chilled-beam');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-eclypse-ahu', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-eclypse-ahu', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-eclypse-ahu', 'dedicated-outdoor-air-system');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-eclypse-ahu', 'makeup-air-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-ecb-vav', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-ecb-vav', 'parallel-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-ecb-vav', 'series-fan-powered-box');

-- ═══════════════════════════════════════════════════════════
-- HONEYWELL
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('honeywell-pul6438s', 'honeywell', 'unitary-controllers', 'PUL6438S', 'pul6438s', 'Programmable unitary controller for AHU and rooftop applications with BACnet and LON support.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('honeywell-pva4024as', 'honeywell', 'vav-controllers', 'PVA4024AS', 'pva4024as', 'Spyder VAV controller with integrated airflow sensor for pressure-independent VAV control.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('honeywell-wb350', 'honeywell', 'supervisory-controllers', 'WEBs-AX (Niagara)', 'webs-ax', 'Niagara Framework-based supervisory controller providing multi-protocol integration, graphics, and enterprise connectivity.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('honeywell-t10-pro', 'honeywell', 'thermostats', 'T10 Pro Smart', 't10-pro', 'Smart thermostat with touchscreen, remote sensor support, and Wi-Fi connectivity for light commercial applications.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('honeywell-ml6161a', 'honeywell', 'damper-actuators', 'ML6161A', 'ml6161a', 'Direct-coupled spring-return damper actuator with 45 in-lb torque for commercial HVAC dampers.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('honeywell-vn-series', 'honeywell', 'valve-actuators', 'VN Series Control Valves', 'vn-series', '2-way and 3-way globe control valves for chilled water and hot water with Cv ratings from 0.73 to 118.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('honeywell-cdb', 'honeywell', 'co2-sensors', 'C7632', 'c7632', 'Wall-mount CO2 sensor with 0-2000 ppm range and 4-20 mA or 0-10 VDC output for demand-controlled ventilation.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('honeywell-dp-series', 'honeywell', 'pressure-sensors', 'DP Series', 'dp-series', 'Differential pressure sensor/transmitter for air and water systems with field-selectable ranges.', 'current', datetime('now'));

-- Honeywell protocols
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-pul6438s', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-pul6438s', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-pul6438s', 'LON');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-pva4024as', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-pva4024as', 'LON');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-wb350', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-wb350', 'Modbus TCP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-wb350', 'LON');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-wb350', 'N2');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-t10-pro', 'WiFi');

-- Honeywell equipment links
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-pul6438s', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-pul6438s', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-pul6438s', 'dedicated-outdoor-air-system');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-pva4024as', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-pva4024as', 'parallel-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-pva4024as', 'series-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-ml6161a', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-ml6161a', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-ml6161a', 'energy-recovery-ventilator');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-vn-series', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-vn-series', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-vn-series', 'chilled-beam');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-cdb', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-cdb', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-dp-series', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-dp-series', 'variable-air-volume-box');

-- ═══════════════════════════════════════════════════════════
-- JOHNSON CONTROLS
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('johnson-controls-fac-3531', 'johnson-controls', 'unitary-controllers', 'FAC-3531', 'fac-3531', 'Facility Explorer application controller for AHU and central plant with 35 I/O points and BACnet/IP.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('johnson-controls-cgm09090', 'johnson-controls', 'supervisory-controllers', 'CGM09090 (NAE)', 'cgm09090', 'Network automation engine providing supervisory control, scheduling, alarming, and trending for Metasys systems.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('johnson-controls-openblue', 'johnson-controls', 'software', 'OpenBlue Enterprise Manager', 'openblue', 'Cloud-based building management platform with AI-driven analytics, energy optimization, and portfolio-level visibility.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('johnson-controls-ms-vma1620', 'johnson-controls', 'vav-controllers', 'MS-VMA1620', 'ms-vma1620', 'Integrated VAV controller actuator for single-duct VAV terminal units with onboard pressure sensor.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('johnson-controls-te-6300', 'johnson-controls', 'temperature-sensors', 'TE-6300 Series', 'te-6300', 'Duct/immersion temperature sensor with 10K Type III or II thermistor for HVAC applications.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('johnson-controls-va-7480', 'johnson-controls', 'valve-actuators', 'VA-7480 Series', 'va-7480', 'Electric ball valve actuator for 2-way and 3-way control valves, proportional or floating control.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('johnson-controls-d-9100', 'johnson-controls', 'damper-actuators', 'D-9100 Series', 'd-9100', 'Electronic damper actuator with spring return, available in multiple torque ratings for commercial dampers.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('johnson-controls-cd-p', 'johnson-controls', 'co2-sensors', 'CD-P Series', 'cd-p', 'Wall-mount CO2 and temperature sensor for demand-controlled ventilation with BACnet or analog output.', 'current', datetime('now'));

-- JCI protocols
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-fac-3531', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-fac-3531', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-cgm09090', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-cgm09090', 'N2');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-ms-vma1620', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-cd-p', 'BACnet MSTP');

-- JCI equipment links
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-fac-3531', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-fac-3531', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-fac-3531', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-fac-3531', 'boiler');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-ms-vma1620', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-ms-vma1620', 'parallel-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-te-6300', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-te-6300', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-te-6300', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-va-7480', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-va-7480', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-va-7480', 'boiler');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-d-9100', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-d-9100', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-cd-p', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-cd-p', 'rooftop-unit');

-- ═══════════════════════════════════════════════════════════
-- SCHNEIDER ELECTRIC
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('schneider-electric-smartx-ip', 'schneider-electric', 'supervisory-controllers', 'SmartX IP Controller AS-P', 'smartx-ip-as-p', 'IP-based automation server providing supervisory control and BACnet/IP routing for EcoStruxure Building systems.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('schneider-electric-mn-s4', 'schneider-electric', 'unitary-controllers', 'MN-S4', 'mn-s4', 'MicroNet Simplicity controller for AHU, rooftop, and central plant applications with native BACnet MSTP.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('schneider-electric-tc-vav', 'schneider-electric', 'vav-controllers', 'TC VAV Controller', 'tc-vav', 'Integrated VAV terminal controller with onboard pressure transducer and actuator output.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('schneider-electric-mn-fcu', 'schneider-electric', 'zone-controllers', 'MN-FCU', 'mn-fcu', 'Fan coil unit controller for 2-pipe and 4-pipe fan coil applications with floating or proportional valve control.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('schneider-electric-sxwaspxxx', 'schneider-electric', 'network-controllers', 'SmartX AS-B', 'smartx-as-b', 'BACnet building controller for mid-size buildings with integrated I/O and IP connectivity.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('schneider-electric-stb', 'schneider-electric', 'temperature-sensors', 'STB Series Temp Sensor', 'stb-series', 'Duct and pipe temperature sensors with NTC 10K or Pt1000 elements for HVAC monitoring.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('schneider-electric-ma-series', 'schneider-electric', 'damper-actuators', 'MA Series Damper Actuators', 'ma-series', 'Spring-return and non-spring-return damper actuators with 35-180 in-lb torque for commercial HVAC dampers.', 'current', datetime('now'));

-- Schneider protocols
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-smartx-ip', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-smartx-ip', 'Modbus TCP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-mn-s4', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-tc-vav', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-mn-fcu', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-sxwaspxxx', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-sxwaspxxx', 'BACnet MSTP');

-- Schneider equipment links
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-mn-s4', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-mn-s4', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-mn-s4', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-mn-s4', 'boiler');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-tc-vav', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-tc-vav', 'parallel-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-tc-vav', 'series-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-mn-fcu', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-mn-fcu', 'unit-ventilator');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-mn-fcu', 'chilled-beam');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-ma-series', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-ma-series', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-stb', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-stb', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-stb', 'chiller');

-- ═══════════════════════════════════════════════════════════
-- SIEMENS
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('siemens-pxc5', 'siemens', 'supervisory-controllers', 'PXC5.E16', 'pxc5', 'Compact automation station with 16 I/O and BACnet/IP for mid-size HVAC applications.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('siemens-pxc7', 'siemens', 'network-controllers', 'PXC7.E400', 'pxc7', 'Modular automation station for large buildings with up to 400 I/O points and native BACnet/IP.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('siemens-txs1-vav', 'siemens', 'vav-controllers', 'TXS1.EF10', 'txs1-vav', 'Terminal equipment controller for VAV, fan coil, and chilled beam applications with BACnet MSTP.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('siemens-rdf800kn', 'siemens', 'thermostats', 'RDF800KN', 'rdf800kn', 'KNX touchscreen room thermostat with scheduling, fan speed control, and multi-stage heating/cooling.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('siemens-glb-series', 'siemens', 'damper-actuators', 'GLB Series', 'glb-series', 'Rotary air damper actuator with spring return, 10 Nm torque, for commercial ventilation dampers.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('siemens-sat', 'siemens', 'valve-actuators', 'SAX/SAT Series', 'sat-series', 'Electric valve actuators for 2-way and 3-way control valves, 400N to 2800N force ratings.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('siemens-qpa2002', 'siemens', 'air-quality-sensors', 'QPA2002', 'qpa2002', 'Room air quality sensor measuring CO2, temperature, and humidity with BACnet or analog output.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('siemens-qbm3020', 'siemens', 'pressure-sensors', 'QBM3020', 'qbm3020', 'Differential pressure sensor for air duct applications with auto-zero and configurable ranges.', 'current', datetime('now'));

-- Siemens protocols
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-pxc5', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-pxc5', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-pxc7', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-pxc7', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-pxc7', 'Modbus TCP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-txs1-vav', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-rdf800kn', 'KNX');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-qpa2002', 'BACnet MSTP');

-- Siemens equipment links
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-pxc5', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-pxc5', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-pxc5', 'boiler');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-pxc7', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-pxc7', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-pxc7', 'cooling-tower');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-txs1-vav', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-txs1-vav', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-txs1-vav', 'chilled-beam');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-glb-series', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-glb-series', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-sat', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-sat', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-sat', 'boiler');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-qpa2002', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-qpa2002', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-qbm3020', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-qbm3020', 'variable-air-volume-box');

-- ═══════════════════════════════════════════════════════════
-- TRANE
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('trane-uc400', 'trane', 'unitary-controllers', 'UC400', 'uc400', 'Programmable controller for small to mid-size AHU and rooftop equipment with BACnet MSTP.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('trane-uc210', 'trane', 'zone-controllers', 'UC210', 'uc210', 'Zone controller for fan coil units, unit ventilators, and heat pump applications.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('trane-tcu', 'trane', 'vav-controllers', 'TCU VAV Controller', 'tcu-vav', 'Integrated terminal control unit for VAV boxes with onboard pressure sensor and actuator.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('trane-bcu', 'trane', 'network-controllers', 'BCU Controller', 'bcu', 'Building control unit providing BACnet/IP routing and integration for Tracer systems.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('trane-xv80', 'trane', 'thermostats', 'XV80 ComfortLink', 'xv80', 'Communicating thermostat with multi-stage control for Trane HVAC equipment.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('trane-ics', 'trane', 'software', 'Tracer Concierge', 'tracer-concierge', 'Cloud-based building analytics and monitoring platform with fault detection and energy dashboards.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('trane-chiller-controller', 'trane', 'unitary-controllers', 'Adaptive Control (CH530)', 'ch530', 'Integrated chiller plant controller for Trane centrifugal and screw chillers with BACnet connectivity.', 'current', datetime('now'));

-- Trane protocols
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-uc400', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-uc210', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-tcu', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-bcu', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-bcu', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-chiller-controller', 'BACnet IP');

-- Trane equipment links
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-uc400', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-uc400', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-uc400', 'dedicated-outdoor-air-system');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-uc210', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-uc210', 'unit-ventilator');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-uc210', 'water-source-heat-pump');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-tcu', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-tcu', 'parallel-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-tcu', 'series-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-chiller-controller', 'chiller');

-- ═══════════════════════════════════════════════════════════
-- VERIS
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('veris-e51c2', 'veris', 'meters', 'E51C2', 'e51c2', 'Branch circuit power meter monitoring up to 42 circuits with revenue-grade accuracy for tenant submetering.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('veris-h8xx', 'veris', 'humidity-sensors', 'H8 Series', 'h8-series', 'Outdoor humidity/temperature combination sensor with solar radiation shield.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('veris-cdl', 'veris', 'co2-sensors', 'CDL Series', 'cdl-series', 'Duct-mount CO2 sensor with 0-2000 or 0-5000 ppm range and 4-20 mA or 0-10 VDC output.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('veris-pxu', 'veris', 'pressure-sensors', 'PXU Series', 'pxu-series', 'Universal pressure transducer with field-selectable ranges for duct static, building pressure, and filter monitoring.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('veris-tw', 'veris', 'temperature-sensors', 'TW Series', 'tw-series', 'Wall-mount temperature sensor with multiple thermistor and RTD element options.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('veris-e30a', 'veris', 'meters', 'E30A Series', 'e30a-series', 'Networked power meter with BACnet/IP or Modbus for main service entrance and large load monitoring.', 'current', datetime('now'));
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('veris-hawkeye', 'veris', 'meters', 'Hawkeye Series', 'hawkeye', 'Split-core current transformers for power monitoring, available in 5A-2500A ranges.', 'current', datetime('now'));

-- Veris protocols
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-e51c2', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-e51c2', 'Modbus TCP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-e30a', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-e30a', 'Modbus TCP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-e30a', 'Modbus RTU');

-- Veris equipment links
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-e51c2', 'electric-meter');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-e30a', 'electric-meter');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-hawkeye', 'electric-meter');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-cdl', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-cdl', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-pxu', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-pxu', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-tw', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-tw', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-h8xx', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-h8xx', 'rooftop-unit');

-- ═══════════════════════════════════════════════════════════
-- EQUIPMENT SUBTYPES (filling the 9% gap)
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('air-handling-unit', 'single-duct', 'Single Duct', 'Standard single supply duct AHU serving VAV or CV terminal units');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('air-handling-unit', 'dual-duct', 'Dual Duct', 'AHU with separate hot and cold supply ducts mixing at terminal units');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('air-handling-unit', 'multizone', 'Multizone', 'AHU with zone-level mixing dampers at the unit serving multiple zones');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('air-handling-unit', 'constant-volume', 'Constant Volume', 'Fixed airflow AHU typically using face-and-bypass or discharge air temperature control');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('air-handling-unit', 'variable-volume', 'Variable Air Volume', 'AHU with VFD-driven supply fan modulating airflow based on system demand');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('chiller', 'air-cooled', 'Air-Cooled', 'Chiller rejecting heat through air-cooled condenser coils, no cooling tower required');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('chiller', 'water-cooled', 'Water-Cooled', 'Chiller rejecting heat through condenser water loop to cooling tower');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('chiller', 'centrifugal', 'Centrifugal', 'Large-capacity chiller using centrifugal compressor, typically 200-2000+ tons');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('chiller', 'screw', 'Screw', 'Mid-range chiller using rotary screw compressor, typically 70-500 tons');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('chiller', 'scroll', 'Scroll', 'Smaller chiller using scroll compressor, typically 15-200 tons');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('chiller', 'absorption', 'Absorption', 'Chiller using heat source (steam/hot water/gas) instead of electric compressor');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('boiler', 'condensing', 'Condensing', 'High-efficiency boiler that recovers latent heat from flue gases, 90-98% efficiency');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('boiler', 'non-condensing', 'Non-Condensing', 'Standard efficiency boiler, typically 80-85% efficiency');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('boiler', 'steam', 'Steam', 'Boiler producing steam for heating, humidification, or process loads');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('boiler', 'hot-water', 'Hot Water', 'Boiler producing hot water for hydronic heating systems');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('variable-air-volume-box', 'single-duct', 'Single Duct', 'Standard VAV box with single supply duct inlet and modulating damper');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('variable-air-volume-box', 'dual-duct', 'Dual Duct', 'VAV box with separate hot and cold duct inlets and mixing control');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('variable-air-volume-box', 'reheat', 'Reheat', 'VAV box with hot water or electric reheat coil for heating mode');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('variable-air-volume-box', 'cooling-only', 'Cooling Only', 'VAV box without reheat, modulates airflow only');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('fan-coil-unit', '2-pipe', '2-Pipe', 'FCU with single coil connected to either chilled or hot water depending on season');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('fan-coil-unit', '4-pipe', '4-Pipe', 'FCU with separate chilled water and hot water coils for simultaneous heating/cooling');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('fan-coil-unit', 'vertical', 'Vertical', 'Floor-standing FCU typically installed along exterior walls');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('fan-coil-unit', 'horizontal', 'Horizontal', 'Ceiling-mounted FCU, can be concealed above ceiling or exposed');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('cooling-tower', 'induced-draft', 'Induced Draft', 'Cooling tower with fan on top pulling air up through fill media');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('cooling-tower', 'forced-draft', 'Forced Draft', 'Cooling tower with fan at base pushing air up through fill media');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('cooling-tower', 'crossflow', 'Crossflow', 'Cooling tower where air flows horizontally across downward-flowing water');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('cooling-tower', 'counterflow', 'Counterflow', 'Cooling tower where air flows upward against downward-flowing water');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('heat-exchanger', 'plate-and-frame', 'Plate and Frame', 'Compact heat exchanger using corrugated plates for high efficiency heat transfer');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('heat-exchanger', 'shell-and-tube', 'Shell and Tube', 'Traditional heat exchanger with tube bundle inside cylindrical shell');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('pump', 'primary', 'Primary', 'Pump serving the primary loop in a primary/secondary pumping arrangement');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('pump', 'secondary', 'Secondary', 'Pump serving the secondary/distribution loop, typically variable speed');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('pump', 'condenser-water', 'Condenser Water', 'Pump circulating condenser water between chillers and cooling towers');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('pump', 'boiler', 'Boiler', 'Pump circulating hot water through boiler loop');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('rooftop-unit', 'gas-electric', 'Gas/Electric', 'RTU with gas heat and DX cooling, most common commercial configuration');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('rooftop-unit', 'heat-pump', 'Heat Pump', 'RTU using refrigerant cycle reversal for both heating and cooling');
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('rooftop-unit', 'electric-heat', 'Electric Heat', 'RTU with electric resistance heating and DX cooling');

-- ═══════════════════════════════════════════════════════════
-- AUTOMATED LOGIC — equipment links for new models
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-me812u', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-me812u', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-me812u', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-me812u', 'boiler');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-zn341', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-zn341', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-vma-series', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-vma-series', 'parallel-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-vma-series', 'series-fan-powered-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-zs-pro', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-zs-pro', 'rooftop-unit');

-- Protocols for ALC models that were missing them
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-me812u', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-me812u', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-zn341', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-zn551', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-vma-series', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-esc', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-esc', 'BACnet MSTP');

COMMIT;
