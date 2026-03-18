-- BAS Atlas Batch Enrichment v2 — Comprehensive data fill
-- Targets: 500+ points, 100+ equipment, 8+ typical points/equip, subtypes, aliases, units, states, models, logos
BEGIN TRANSACTION;

-- ═══════════════════════════════════════════════════════════
-- PHASE 1: NEW EQUIPMENT TYPES (+45)
-- ═══════════════════════════════════════════════════════════

-- Lighting (new category)
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('lighting-control-panel', 'Lighting Control Panel', 'Lighting Control Panel', 'LCP', 'lighting', 'Central panel that controls lighting circuits and zones in a building area. Interfaces with BAS for scheduling and demand response.', 'Lighting_Control_Panel', 'lighting panel equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('dimmer-module', 'Dimmer Module', 'Dimmer Module', 'DIM', 'lighting', 'Electronic module that controls light output level by modulating power to luminaires. Supports 0-10V or DALI dimming protocols.', 'Dimmer', 'dimmer lighting equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('daylight-sensor', 'Daylight Sensor', 'Daylight Harvesting Sensor', 'DLS', 'lighting', 'Photosensor that measures ambient light levels to enable daylight harvesting and automatic dimming of artificial lights.', 'Daylight_Sensor', 'daylight sensor equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('lighting-relay-panel', 'Lighting Relay Panel', 'Lighting Relay Panel', 'LRP', 'lighting', 'Panel with individually controllable relays for on/off switching of lighting circuits. Commonly used for scheduled lighting control.', 'Lighting_Relay_Panel', 'lighting relay panel equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('occupancy-lighting-controller', 'Occupancy Lighting Controller', 'Occupancy-Based Lighting Controller', 'OLC', 'lighting', 'Controller that integrates occupancy sensing with lighting control to automatically turn lights on/off based on room occupancy.', 'Occupancy_Sensor', 'occupancy lighting controller equip', NULL);

-- Refrigeration (new category)
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('walk-in-cooler', 'Walk-In Cooler', 'Walk-In Cooler', 'WIC', 'refrigeration', 'Insulated enclosure maintained at 33-41°F for perishable food storage. Includes evaporator coil, fans, and door heaters.', 'Refrigerator', 'cooler refrigeration equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('walk-in-freezer', 'Walk-In Freezer', 'Walk-In Freezer', 'WIF', 'refrigeration', 'Insulated enclosure maintained at 0°F or below for frozen food storage. Requires defrost cycles and door heaters.', 'Freezer', 'freezer refrigeration equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('reach-in-refrigerator', 'Reach-In Refrigerator', 'Reach-In Refrigerator', 'RIR', 'refrigeration', 'Self-contained refrigeration unit with glass or solid doors for food service applications. BAS monitors temperature and alarms.', 'Refrigerator', 'reach refrigerator equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('condensing-unit-refrigeration', 'Condensing Unit (Refrigeration)', 'Refrigeration Condensing Unit', 'RCU', 'refrigeration', 'Remote compressor and condenser assembly that serves walk-in coolers and freezers. Located outdoors or in a mechanical room.', 'Condensing_Unit', 'condensing unit refrigeration equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('refrigeration-rack', 'Refrigeration Rack', 'Refrigeration Compressor Rack', 'RR', 'refrigeration', 'Multi-compressor system serving multiple refrigeration loads in supermarkets and cold storage. Includes suction groups and oil management.', 'Compressor', 'rack refrigeration compressor equip', NULL);

-- Central Plant additions
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('steam-pressure-reducing-valve', 'Steam PRV Station', 'Steam Pressure Reducing Valve Station', 'PRV', 'central-plant', 'Pressure reducing valve station that steps down high-pressure steam to usable building pressure. Includes safety relief valves and bypass.', 'Valve', 'steam pressure valve equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('chemical-treatment-system', 'Chemical Treatment System', 'Water Chemical Treatment System', 'CTS', 'central-plant', 'System that injects corrosion inhibitors, biocides, and scale inhibitors into hydronic loops to protect piping and equipment.', 'Water_Treatment_System', 'chemical treatment water equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('water-treatment-system', 'Water Treatment System', 'Cooling Tower Water Treatment System', 'WTS', 'central-plant', 'Manages conductivity, pH, and biological growth in open cooling tower water loops through chemical dosing and blowdown control.', 'Water_Treatment_System', 'water treatment cooling equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('glycol-feed-system', 'Glycol Feed System', 'Glycol Feed and Makeup System', 'GFS', 'central-plant', 'Maintains glycol concentration in freeze-protected hydronic loops by monitoring concentration and adding makeup glycol as needed.', 'Water_System', 'glycol feed system equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('primary-chilled-water-pump', 'Primary CHW Pump', 'Primary Chilled Water Pump', 'PCHWP', 'central-plant', 'Constant or variable speed pump that circulates chilled water through the chiller evaporator in a primary loop.', 'Chilled_Water_Pump', 'chilled water pump primary equip', 'pump');
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('secondary-chilled-water-pump', 'Secondary CHW Pump', 'Secondary Chilled Water Pump', 'SCHWP', 'central-plant', 'Variable speed pump that distributes chilled water to building loads in a primary-secondary or variable-primary system.', 'Chilled_Water_Pump', 'chilled water pump secondary equip', 'pump');
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('condenser-water-pump', 'CW Pump', 'Condenser Water Pump', 'CWP', 'central-plant', 'Pump that circulates condenser water between chillers and cooling towers. Typically constant speed in older plants, variable speed in newer.', 'Condenser_Water_Pump', 'condenser water pump equip', 'pump');
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('hot-water-pump', 'HW Pump', 'Hot Water Pump', 'HWP', 'central-plant', 'Pump that circulates hot water from boilers to building heating coils and terminal units.', 'Hot_Water_Pump', 'hot water pump equip', 'pump');

-- Terminal Units additions
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('cabinet-unit-heater', 'Cabinet Unit Heater', 'Cabinet Unit Heater', 'CUH', 'terminal-units', 'Wall or ceiling-mounted cabinet with hot water or electric heating coil and integral fan for perimeter heating.', 'Unit_Heater', 'cabinet unit heater equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('fin-tube-radiator', 'Fin Tube Radiator', 'Fin Tube Radiation', 'FTR', 'terminal-units', 'Baseboard or wall-mounted finned tube element using hot water for perimeter heating. Passive convection with optional damper control.', 'Radiator', 'fin tube radiator equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('convector', 'Convector', 'Convector Heater', 'CVR', 'terminal-units', 'Natural or forced convection terminal unit using hot water or steam for perimeter heating. Enclosed cabinet with inlet grille.', 'Radiator', 'convector heater equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('radiant-floor', 'Radiant Floor', 'Radiant Floor Heating System', 'RFH', 'terminal-units', 'Hydronic tubing embedded in floor slab for radiant heating and optional cooling. Controlled by mixing valve and zone pumps.', 'Radiant_Panel', 'radiant floor heating equip', NULL);

-- Metering additions
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('power-quality-meter', 'Power Quality Meter', 'Power Quality Analyzer', 'PQM', 'metering', 'Advanced electrical meter that monitors voltage, current, power factor, harmonics, sags, and swells for power quality analysis.', 'Electrical_Meter', 'power quality meter equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('demand-meter', 'Demand Meter', 'Electrical Demand Meter', 'DM', 'metering', 'Meter that tracks peak electrical demand over defined intervals for utility billing and demand management purposes.', 'Electrical_Meter', 'demand meter elec equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('flow-meter', 'Flow Meter', 'Fluid Flow Meter', 'FM', 'metering', 'Measures volumetric or mass flow rate of water, glycol, steam, or gas in piping systems. Technologies include electromagnetic, ultrasonic, and vortex.', 'Flow_Sensor', 'flow meter equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('thermal-energy-meter', 'Thermal Energy Meter', 'Thermal Energy Meter', 'TEM', 'metering', 'Calculates thermal energy (BTU) by measuring flow rate and supply/return temperature differential in hydronic systems.', 'Thermal_Power_Sensor', 'thermal energy meter equip', NULL);

-- Standalone fans additions
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('relief-fan', 'Relief Fan', 'Building Relief Fan', 'RF', 'standalone-fans', 'Fan that relieves building pressure by exhausting air when economizer introduces excess outdoor air.', 'Fan', 'relief fan equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('return-fan', 'Return Fan', 'Return Air Fan', 'RAF', 'standalone-fans', 'Fan that draws air from occupied spaces back to the air handling unit through the return ductwork.', 'Return_Fan', 'return fan equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('supply-fan', 'Supply Fan', 'Supply Air Fan', 'SAF', 'standalone-fans', 'Fan that moves conditioned air from the air handling unit through supply ductwork to occupied spaces.', 'Supply_Fan', 'supply fan equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('kitchen-exhaust-fan', 'Kitchen Exhaust Fan', 'Kitchen Hood Exhaust Fan', 'KEF', 'standalone-fans', 'High-temperature rated exhaust fan serving commercial kitchen hoods. Often includes grease filtration and fire suppression interlocks.', 'Exhaust_Fan', 'kitchen exhaust fan equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('garage-exhaust-fan', 'Garage Exhaust Fan', 'Parking Garage Exhaust Fan', 'GEF', 'standalone-fans', 'Exhaust fan for enclosed parking garages. Activated by CO sensors or timer schedule to maintain safe air quality.', 'Exhaust_Fan', 'garage exhaust fan equip', NULL);

-- Controls / Sensors
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('building-controller', 'Building Controller', 'Building Automation Controller', 'BC', 'controls', 'Supervisory controller that manages multiple area controllers and provides global scheduling, trending, alarming, and integration.', 'Controller', 'building controller equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('area-controller', 'Area Controller', 'Area Application Controller', 'AC', 'controls', 'Mid-level controller that manages a group of field devices and equipment within a building zone or mechanical system.', 'Controller', 'area controller equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('io-expansion-module', 'I/O Expansion Module', 'Input/Output Expansion Module', 'IOM', 'controls', 'Module that adds physical I/O points to a controller. Provides additional analog and digital inputs/outputs over a local bus.', 'Controller', 'io expansion module equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('weather-station', 'Weather Station', 'Outdoor Weather Station', 'WS', 'controls', 'Multi-sensor outdoor station measuring temperature, humidity, wind speed/direction, barometric pressure, and solar radiation for BAS optimization.', 'Weather_Station', 'weather station sensor equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('light-level-sensor', 'Light Level Sensor', 'Ambient Light Level Sensor', 'LLS', 'controls', 'Photosensor that measures illuminance levels in footcandles or lux for daylight harvesting and lighting control.', 'Luminance_Sensor', 'light level sensor equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('refrigerant-leak-detector', 'Refrigerant Leak Detector', 'Refrigerant Leak Detection Sensor', 'RLD', 'controls', 'Sensor that detects refrigerant gas leaks in mechanical rooms and occupied spaces. Required by ASHRAE 15 for certain refrigerant quantities.', 'Gas_Sensor', 'refrigerant leak detector sensor equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('water-leak-detector', 'Water Leak Detector', 'Water Leak Detection Sensor', 'WLD', 'controls', 'Sensor that detects water presence from pipe leaks, condensate overflow, or flooding. Triggers alarms and can shut isolation valves.', 'Leak_Sensor', 'water leak detector sensor equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('vibration-sensor', 'Vibration Sensor', 'Equipment Vibration Sensor', 'VS', 'controls', 'Accelerometer-based sensor that monitors vibration levels on rotating equipment like fans, pumps, and compressors for predictive maintenance.', 'Vibration_Sensor', 'vibration sensor equip', NULL);

-- Other
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('elevator', 'Elevator', 'Passenger/Freight Elevator', 'ELEV', 'vertical-transport', 'Vertical transportation system monitored by BAS for status, fault, fire service mode, and energy consumption.', 'Elevator', 'elevator equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('escalator', 'Escalator', 'Escalator', 'ESC', 'vertical-transport', 'Moving stairway monitored by BAS for run status, fault alarms, and energy. Often controlled by occupancy or schedule.', 'Escalator', 'escalator equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('server-room-cooling', 'Server Room Cooling', 'Server Room Cooling Unit', 'SRC', 'air-handling', 'Precision cooling unit for small server rooms and IT closets. Maintains tight temperature and humidity control.', 'CRAC', 'server room cooling equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('data-center-cooling', 'Data Center Cooling', 'Data Center Cooling System', 'DCC', 'air-handling', 'Precision cooling for data center environments including in-row coolers, overhead units, and rear-door heat exchangers.', 'CRAC', 'data center cooling equip', NULL);
INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('clean-room-ahu', 'Clean Room AHU', 'Clean Room Air Handling Unit', 'CRAHU', 'air-handling', 'Specialized AHU with HEPA filtration maintaining ISO cleanroom classifications. Controls pressurization, temperature, humidity, and particle counts.', 'Air_Handling_Unit', 'clean room ahu equip', NULL);

-- ═══════════════════════════════════════════════════════════
-- PHASE 2: EQUIPMENT SUBTYPES
-- ═══════════════════════════════════════════════════════════

-- Air-source heat pump
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('air-source-heat-pump', 'split-system', 'Split System', 'Outdoor condenser unit paired with indoor air handler via refrigerant lines'),
  ('air-source-heat-pump', 'packaged', 'Packaged', 'Self-contained unit with compressor, condenser, and evaporator in single housing'),
  ('air-source-heat-pump', 'mini-split', 'Mini-Split', 'Ductless wall-mounted indoor unit with outdoor condensing unit'),
  ('air-source-heat-pump', 'cold-climate', 'Cold Climate', 'Enhanced for operation at low ambient temperatures below 0°F');

-- Air turnover unit
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('air-turnover-unit', 'gas-fired', 'Gas-Fired', 'Direct gas-fired heating for warehouse and industrial spaces'),
  ('air-turnover-unit', 'indirect-fired', 'Indirect-Fired', 'Indirect gas-fired with heat exchanger to prevent combustion products in airstream'),
  ('air-turnover-unit', 'electric', 'Electric', 'Electric heating elements for spaces without gas service');

-- Automatic transfer switch
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('automatic-transfer-switch', 'open-transition', 'Open Transition', 'Brief power interruption during transfer between sources'),
  ('automatic-transfer-switch', 'closed-transition', 'Closed Transition', 'Seamless transfer with momentary parallel operation'),
  ('automatic-transfer-switch', 'soft-load', 'Soft Load Transfer', 'Gradual load transfer to minimize inrush current');

-- Baseboard heater
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('baseboard-heater', 'hot-water', 'Hot Water', 'Hydronic baseboard with copper tube and aluminum fins'),
  ('baseboard-heater', 'electric', 'Electric', 'Electric resistance baseboard with integral thermostat or BAS control'),
  ('baseboard-heater', 'steam', 'Steam', 'Steam-heated baseboard for buildings with steam distribution');

-- Blower coil unit
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('blower-coil-unit', 'horizontal', 'Horizontal', 'Horizontal mount for ceiling plenum installation'),
  ('blower-coil-unit', 'vertical', 'Vertical', 'Vertical mount for closet or mechanical room installation'),
  ('blower-coil-unit', 'ducted', 'Ducted', 'Connected to supply ductwork for multiple room coverage');

-- BTU meter
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('btu-meter', 'ultrasonic', 'Ultrasonic', 'Non-invasive ultrasonic flow measurement with temperature sensors'),
  ('btu-meter', 'electromagnetic', 'Electromagnetic', 'Mag meter based flow measurement for conductive fluids'),
  ('btu-meter', 'insertion', 'Insertion', 'Insertion-style flow sensor with matched temperature probes');

-- Chilled beam
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('chilled-beam', 'active', 'Active Chilled Beam', 'Uses primary air supply to induce room air over cooling/heating coil'),
  ('chilled-beam', 'passive', 'Passive Chilled Beam', 'Relies on natural convection without primary air connection'),
  ('chilled-beam', 'multi-service', 'Multi-Service', 'Integrates lighting, sprinklers, and acoustic elements with beam');

-- Computer room air conditioner
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('computer-room-air-conditioner', 'dx-downflow', 'DX Downflow', 'Direct expansion cooling with underfloor air distribution'),
  ('computer-room-air-conditioner', 'dx-upflow', 'DX Upflow', 'Direct expansion cooling with overhead air distribution'),
  ('computer-room-air-conditioner', 'chilled-water', 'Chilled Water', 'Chilled water coil for connection to central plant'),
  ('computer-room-air-conditioner', 'glycol', 'Glycol-Cooled', 'Glycol-cooled condenser for cold climate installations');

-- Computer room air handler
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('computer-room-air-handler', 'perimeter', 'Perimeter', 'Floor-standing unit along room perimeter with underfloor supply'),
  ('computer-room-air-handler', 'in-row', 'In-Row', 'Placed between server racks for close-coupled cooling'),
  ('computer-room-air-handler', 'overhead', 'Overhead', 'Ceiling-mounted unit for overhead air distribution');

-- Condensing unit
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('condensing-unit', 'air-cooled', 'Air-Cooled', 'Rejects heat to outdoor air via condenser coil and fan'),
  ('condensing-unit', 'water-cooled', 'Water-Cooled', 'Rejects heat to condenser water loop'),
  ('condensing-unit', 'remote', 'Remote', 'Located remotely from evaporator with long refrigerant lines');

-- Constant air volume box
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('constant-air-volume-box', 'reheat', 'CAV with Reheat', 'Constant volume box with hot water or electric reheat coil'),
  ('constant-air-volume-box', 'cooling-only', 'Cooling Only', 'Simple constant volume supply without reheat'),
  ('constant-air-volume-box', 'dual-duct', 'Dual Duct', 'Mixes hot and cold deck air to maintain zone temperature');

-- Dedicated outdoor air system
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('dedicated-outdoor-air-system', 'energy-recovery', 'Energy Recovery', 'Includes enthalpy wheel or plate exchanger for energy recovery'),
  ('dedicated-outdoor-air-system', 'heat-recovery', 'Heat Recovery', 'Sensible-only heat recovery via run-around coil or heat pipe'),
  ('dedicated-outdoor-air-system', 'dx-cooling', 'Direct Expansion', 'DX cooling with compressor for dehumidification'),
  ('dedicated-outdoor-air-system', 'chilled-water', 'Chilled Water', 'Chilled water coil connected to central plant');

-- Electric meter
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('electric-meter', 'revenue-grade', 'Revenue Grade', 'ANSI C12 certified meter for utility billing accuracy'),
  ('electric-meter', 'submeter', 'Submeter', 'Tenant or circuit-level metering for cost allocation'),
  ('electric-meter', 'ct-rated', 'CT-Rated', 'Uses current transformers for high amperage circuits'),
  ('electric-meter', 'direct-connect', 'Direct Connect', 'Direct measurement for circuits under 200A');

-- Energy recovery ventilator
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('energy-recovery-ventilator', 'enthalpy-wheel', 'Enthalpy Wheel', 'Rotating desiccant wheel recovering both sensible and latent energy'),
  ('energy-recovery-ventilator', 'plate-exchanger', 'Plate Heat Exchanger', 'Fixed plate crossflow heat exchanger for sensible recovery'),
  ('energy-recovery-ventilator', 'heat-pipe', 'Heat Pipe', 'Passive heat pipe technology for sensible heat recovery'),
  ('energy-recovery-ventilator', 'run-around', 'Run-Around Coil', 'Glycol loop connecting coils in supply and exhaust airstreams');

-- Exhaust fan
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('exhaust-fan', 'centrifugal', 'Centrifugal', 'Centrifugal blower for higher pressure ductwork systems'),
  ('exhaust-fan', 'axial', 'Axial', 'Propeller or vaneaxial fan for high volume low pressure applications'),
  ('exhaust-fan', 'inline', 'Inline', 'Duct-mounted inline fan for distributed exhaust systems'),
  ('exhaust-fan', 'roof-mounted', 'Roof Mounted', 'Upblast or downblast roof exhaust fan');

-- Expansion tank
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('expansion-tank', 'bladder', 'Bladder', 'Pre-charged bladder tank for closed hydronic systems'),
  ('expansion-tank', 'diaphragm', 'Diaphragm', 'Diaphragm-separated air and water chambers'),
  ('expansion-tank', 'open', 'Open', 'Open gravity tank at system high point for atmospheric systems');

-- Fire alarm control panel
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('fire-alarm-control-panel', 'conventional', 'Conventional', 'Zone-based detection with initiating device circuits'),
  ('fire-alarm-control-panel', 'addressable', 'Addressable', 'Individually addressable devices on SLC loops'),
  ('fire-alarm-control-panel', 'analog-addressable', 'Analog Addressable', 'Addressable with analog sensitivity adjustment per device');

-- Generator
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('generator', 'diesel', 'Diesel', 'Diesel engine driven generator for standby power'),
  ('generator', 'natural-gas', 'Natural Gas', 'Natural gas engine driven generator'),
  ('generator', 'bi-fuel', 'Bi-Fuel', 'Dual fuel capability for diesel and natural gas operation');

-- Heat recovery ventilator
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('heat-recovery-ventilator', 'plate-exchanger', 'Plate Heat Exchanger', 'Aluminum or polymer plate crossflow heat exchanger'),
  ('heat-recovery-ventilator', 'rotary-wheel', 'Rotary Wheel', 'Sensible-only rotating heat recovery wheel'),
  ('heat-recovery-ventilator', 'heat-pipe', 'Heat Pipe', 'Passive heat pipe for sensible recovery without moving parts');

-- Induction unit
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('induction-unit', '2-pipe', '2-Pipe', 'Single coil for either heating or cooling with changeover'),
  ('induction-unit', '4-pipe', '4-Pipe', 'Separate heating and cooling coils for simultaneous availability'),
  ('induction-unit', 'active', 'Active', 'Primary air nozzles induce room air over coil');

-- Makeup air unit
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('makeup-air-unit', 'gas-fired', 'Gas-Fired', 'Direct or indirect gas-fired heating section'),
  ('makeup-air-unit', 'dx-cooling', 'DX Cooling', 'Direct expansion cooling for summer operation'),
  ('makeup-air-unit', 'hot-water', 'Hot Water', 'Hot water heating coil for building with hydronic plant'),
  ('makeup-air-unit', 'energy-recovery', 'Energy Recovery', 'Includes energy recovery from exhaust air');

-- Natural gas meter
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('natural-gas-meter', 'diaphragm', 'Diaphragm', 'Positive displacement diaphragm meter for low flow'),
  ('natural-gas-meter', 'rotary', 'Rotary', 'Rotary positive displacement for medium flow rates'),
  ('natural-gas-meter', 'turbine', 'Turbine', 'Turbine meter for high flow commercial applications');

-- Packaged terminal air conditioner
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('packaged-terminal-air-conditioner', 'electric-heat', 'Electric Heat', 'Electric resistance supplemental heating'),
  ('packaged-terminal-air-conditioner', 'hot-water', 'Hot Water', 'Hot water heating coil for hydronic buildings'),
  ('packaged-terminal-air-conditioner', 'cooling-only', 'Cooling Only', 'Cooling only without supplemental heat');

-- Packaged terminal heat pump
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('packaged-terminal-heat-pump', 'standard', 'Standard', 'Reversing valve heat pump with electric backup heat'),
  ('packaged-terminal-heat-pump', 'high-efficiency', 'High Efficiency', 'Enhanced compressor and coil for higher EER/COP'),
  ('packaged-terminal-heat-pump', 'water-source', 'Water Source', 'Water-source condenser for connection to building loop');

-- Parallel fan powered box
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('parallel-fan-powered-box', 'electric-reheat', 'Electric Reheat', 'Electric heating element for zones without hydronic piping'),
  ('parallel-fan-powered-box', 'hot-water-reheat', 'Hot Water Reheat', 'Hot water coil for hydronic reheat');

-- Radiant panel
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('radiant-panel', 'ceiling', 'Ceiling Panel', 'Ceiling-mounted radiant panel for heating and/or cooling'),
  ('radiant-panel', 'wall', 'Wall Panel', 'Wall-mounted radiant panel for perimeter heating'),
  ('radiant-panel', 'metal', 'Metal Panel', 'Metal radiant panel with embedded hydronic tubing');

-- Series fan powered box
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('series-fan-powered-box', 'electric-reheat', 'Electric Reheat', 'Electric heating element for zone reheat'),
  ('series-fan-powered-box', 'hot-water-reheat', 'Hot Water Reheat', 'Hot water coil for hydronic zone reheat');

-- Steam meter
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('steam-meter', 'vortex', 'Vortex', 'Vortex shedding flow meter for saturated and superheated steam'),
  ('steam-meter', 'orifice-plate', 'Orifice Plate', 'Differential pressure across orifice plate for steam flow'),
  ('steam-meter', 'turbine', 'Turbine', 'Inline turbine meter for high-flow steam applications');

-- Steam-to-hot-water converter
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('steam-to-hot-water-converter', 'shell-and-tube', 'Shell and Tube', 'Shell-and-tube heat exchanger converting steam to hot water'),
  ('steam-to-hot-water-converter', 'plate', 'Plate', 'Plate-type heat exchanger for steam-to-water conversion');

-- Transfer fan
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('transfer-fan', 'ceiling', 'Ceiling Mounted', 'Ceiling-mounted transfer fan between zones'),
  ('transfer-fan', 'wall', 'Wall Mounted', 'Wall-mounted transfer fan for pressure relief'),
  ('transfer-fan', 'ducted', 'Ducted', 'Ducted transfer with inline fan');

-- Uninterruptible power supply
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('uninterruptible-power-supply', 'online-double-conversion', 'Online Double Conversion', 'Continuous inverter operation for zero transfer time'),
  ('uninterruptible-power-supply', 'line-interactive', 'Line Interactive', 'Voltage regulation with battery backup on outage'),
  ('uninterruptible-power-supply', 'offline-standby', 'Offline Standby', 'Battery switches in on power loss with brief transfer time');

-- Unit heater
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('unit-heater', 'hot-water', 'Hot Water', 'Hydronic coil with propeller fan for industrial/warehouse heating'),
  ('unit-heater', 'steam', 'Steam', 'Steam coil unit heater for buildings with steam distribution'),
  ('unit-heater', 'gas-fired', 'Gas-Fired', 'Direct-fired gas burner unit heater'),
  ('unit-heater', 'electric', 'Electric', 'Electric resistance heating with fan');

-- Unit ventilator
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('unit-ventilator', 'blow-through', 'Blow-Through', 'Fan upstream of coil pushing air through heating/cooling coil'),
  ('unit-ventilator', 'draw-through', 'Draw-Through', 'Fan downstream of coil pulling air through heating/cooling coil'),
  ('unit-ventilator', 'vertical', 'Vertical', 'Floor-standing vertical configuration for classroom walls'),
  ('unit-ventilator', 'horizontal', 'Horizontal', 'Horizontal ceiling-mount configuration');

-- Variable frequency drive
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('variable-frequency-drive', 'ac-drive', 'AC Drive', 'Standard variable frequency AC motor drive'),
  ('variable-frequency-drive', 'regenerative', 'Regenerative', 'Regenerative drive that returns braking energy to power system'),
  ('variable-frequency-drive', 'active-front-end', 'Active Front End', 'Low harmonic drive with active rectifier for power quality');

-- VRF branch selector box
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('vrf-branch-selector-box', 'heat-recovery', 'Heat Recovery', 'Enables simultaneous heating and cooling across zones'),
  ('vrf-branch-selector-box', 'heat-pump', 'Heat Pump', 'All zones must be in same mode (heating or cooling)');

-- VRF indoor unit
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('vrf-indoor-unit', 'wall-mounted', 'Wall Mounted', 'High-wall mounted unit for perimeter zones'),
  ('vrf-indoor-unit', 'ceiling-cassette', 'Ceiling Cassette', '4-way blow ceiling recessed cassette'),
  ('vrf-indoor-unit', 'ducted', 'Ducted', 'Concealed ducted unit for flexible air distribution'),
  ('vrf-indoor-unit', 'floor-standing', 'Floor Standing', 'Floor-standing console unit');

-- VRF outdoor unit
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('vrf-outdoor-unit', '2-pipe', '2-Pipe Heat Pump', 'Standard heat pump operation — all zones same mode'),
  ('vrf-outdoor-unit', '3-pipe', '3-Pipe Heat Recovery', 'Three-pipe system enabling simultaneous heating and cooling');

-- Water meter
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('water-meter', 'electromagnetic', 'Electromagnetic', 'Mag meter for conductive fluids with no pressure drop'),
  ('water-meter', 'ultrasonic', 'Ultrasonic', 'Non-invasive transit-time ultrasonic flow measurement'),
  ('water-meter', 'turbine', 'Turbine', 'Mechanical turbine meter for domestic water metering'),
  ('water-meter', 'positive-displacement', 'Positive Displacement', 'Nutating disc or piston meter for low flow accuracy');

-- Water source heat pump
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('water-source-heat-pump', 'console', 'Console', 'Floor-standing console unit for perimeter zones'),
  ('water-source-heat-pump', 'vertical', 'Vertical', 'Vertical stack configuration for closet installation'),
  ('water-source-heat-pump', 'horizontal', 'Horizontal', 'Horizontal ceiling-mount for plenum installation'),
  ('water-source-heat-pump', 'geothermal', 'Geothermal', 'Connected to ground-source loop field');

-- Air separator
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('air-separator', 'tangential', 'Tangential', 'Uses centrifugal action to separate air from water'),
  ('air-separator', 'coalescing', 'Coalescing', 'Coalescing media captures microbubbles for removal');

-- Domestic water recirculation pump
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('domestic-water-recirculation-pump', 'constant-speed', 'Constant Speed', 'Fixed speed circulator on timer or aquastat control'),
  ('domestic-water-recirculation-pump', 'variable-speed', 'Variable Speed', 'ECM motor with demand-based speed control'),
  ('domestic-water-recirculation-pump', 'on-demand', 'On-Demand', 'Activated by push button or motion sensor at fixture');

-- New equipment subtypes
INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('walk-in-cooler', 'indoor', 'Indoor', 'Cooler box located inside building'),
  ('walk-in-cooler', 'outdoor', 'Outdoor', 'Weather-protected outdoor cooler installation'),
  ('walk-in-freezer', 'indoor', 'Indoor', 'Freezer box inside building with remote condensing unit'),
  ('walk-in-freezer', 'outdoor', 'Outdoor', 'Outdoor freezer with self-contained refrigeration'),
  ('refrigeration-rack', 'low-temp', 'Low Temperature', 'Suction group serving freezer cases'),
  ('refrigeration-rack', 'medium-temp', 'Medium Temperature', 'Suction group serving cooler cases'),
  ('cabinet-unit-heater', 'hot-water', 'Hot Water', 'Hydronic heating coil with integral fan'),
  ('cabinet-unit-heater', 'electric', 'Electric', 'Electric resistance heating with fan'),
  ('cabinet-unit-heater', 'steam', 'Steam', 'Steam coil cabinet heater'),
  ('fin-tube-radiator', 'hot-water', 'Hot Water', 'Hot water finned tube radiation'),
  ('fin-tube-radiator', 'steam', 'Steam', 'Steam finned tube radiation'),
  ('convector', 'natural-convection', 'Natural Convection', 'Relies on natural air circulation'),
  ('convector', 'forced-convection', 'Forced Convection', 'Includes integral fan for forced air movement'),
  ('radiant-floor', 'hot-water', 'Hot Water', 'Hydronic tubing in slab for heating'),
  ('radiant-floor', 'electric', 'Electric', 'Electric resistance heating cables in slab'),
  ('building-controller', 'supervisory', 'Supervisory', 'Top-level controller managing network of area controllers'),
  ('building-controller', 'integrated', 'Integrated', 'Combined supervisory and application control'),
  ('weather-station', 'basic', 'Basic', 'Temperature and humidity sensing only'),
  ('weather-station', 'advanced', 'Advanced', 'Includes wind, solar radiation, barometric pressure, and rain'),
  ('elevator', 'traction', 'Traction', 'Geared or gearless traction elevator'),
  ('elevator', 'hydraulic', 'Hydraulic', 'Hydraulic piston driven elevator'),
  ('elevator', 'machine-room-less', 'Machine Room Less', 'Compact traction design without dedicated machine room');

COMMIT;

BEGIN TRANSACTION;

-- ═══════════════════════════════════════════════════════════
-- PHASE 3: NEW POINT DEFINITIONS (+241)
-- ═══════════════════════════════════════════════════════════

-- ── Temperatures (+15) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('preheat-leaving-temperature', 'Preheat Leaving Temperature', 'temperatures', 'Air temperature leaving the preheat coil section of an AHU', 'Number', 'sensor', 'preheat leaving air temp sensor', '°F', 'Number', 'Preheat_Coil_Leaving_Air_Temperature_Sensor'),
  ('reheat-discharge-temperature', 'Reheat Discharge Temperature', 'temperatures', 'Air temperature leaving a terminal unit reheat coil', 'Number', 'sensor', 'reheat discharge air temp sensor', '°F', 'Number', 'Reheat_Coil_Discharge_Air_Temperature_Sensor'),
  ('flue-gas-temperature', 'Flue Gas Temperature', 'temperatures', 'Temperature of combustion exhaust gases leaving a boiler or furnace', 'Number', 'sensor', 'flue gas temp sensor', '°F', 'Number', 'Flue_Gas_Temperature_Sensor'),
  ('refrigerant-suction-temperature', 'Refrigerant Suction Temperature', 'temperatures', 'Temperature of refrigerant entering the compressor suction port', 'Number', 'sensor', 'refrig suction temp sensor', '°F', 'Number', 'Suction_Temperature_Sensor'),
  ('refrigerant-discharge-temperature', 'Refrigerant Discharge Temperature', 'temperatures', 'Temperature of refrigerant leaving the compressor discharge port', 'Number', 'sensor', 'refrig discharge temp sensor', '°F', 'Number', 'Discharge_Temperature_Sensor'),
  ('ground-water-temperature', 'Ground Water Temperature', 'temperatures', 'Temperature of water from ground source well or loop field', 'Number', 'sensor', 'ground water temp sensor', '°F', 'Number', 'Water_Temperature_Sensor'),
  ('steam-temperature', 'Steam Temperature', 'temperatures', 'Temperature of steam in distribution piping', 'Number', 'sensor', 'steam temp sensor', '°F', 'Number', 'Steam_Temperature_Sensor'),
  ('radiant-panel-surface-temperature', 'Radiant Panel Surface Temperature', 'temperatures', 'Surface temperature of a radiant heating or cooling panel', 'Number', 'sensor', 'radiant panel surface temp sensor', '°F', 'Number', 'Temperature_Sensor'),
  ('ceiling-plenum-temperature', 'Ceiling Plenum Temperature', 'temperatures', 'Air temperature in the ceiling plenum space above a drop ceiling', 'Number', 'sensor', 'ceiling plenum air temp sensor', '°F', 'Number', 'Air_Temperature_Sensor'),
  ('slab-temperature', 'Slab Temperature', 'temperatures', 'Temperature of a heated or cooled floor slab for radiant systems', 'Number', 'sensor', 'slab temp sensor', '°F', 'Number', 'Temperature_Sensor'),
  ('server-inlet-temperature', 'Server Inlet Temperature', 'temperatures', 'Air temperature at the inlet face of server racks in a data center', 'Number', 'sensor', 'server inlet air temp sensor', '°F', 'Number', 'Air_Temperature_Sensor'),
  ('server-outlet-temperature', 'Server Outlet Temperature', 'temperatures', 'Air temperature at the outlet face of server racks in a data center', 'Number', 'sensor', 'server outlet air temp sensor', '°F', 'Number', 'Air_Temperature_Sensor'),
  ('heat-exchanger-leaving-temperature', 'Heat Exchanger Leaving Temperature', 'temperatures', 'Fluid temperature leaving a heat exchanger on the secondary side', 'Number', 'sensor', 'heat exchanger leaving temp sensor', '°F', 'Number', 'Leaving_Water_Temperature_Sensor'),
  ('outdoor-air-temperature-setpoint', 'Outdoor Air Temperature Setpoint', 'temperatures', 'Outdoor air temperature reference used for reset schedules and economizer control', 'Number', 'sp', 'outside air temp sp', '°F', 'Number', 'Outside_Air_Temperature_Setpoint'),
  ('subcooling-temperature', 'Subcooling Temperature', 'temperatures', 'Temperature below condensing point of refrigerant leaving the condenser', 'Number', 'sensor', 'subcooling temp sensor', '°F', 'Number', 'Temperature_Sensor');

-- ── Pressures (+15) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('condenser-water-differential-pressure', 'Condenser Water Differential Pressure', 'pressures', 'Pressure difference across condenser water piping or equipment', 'Number', 'sensor', 'condenser water differential pressure sensor', 'psi', 'Number', 'Differential_Pressure_Sensor'),
  ('refrigerant-suction-pressure', 'Refrigerant Suction Pressure', 'pressures', 'Refrigerant pressure at the compressor suction inlet', 'Number', 'sensor', 'refrig suction pressure sensor', 'psi', 'Number', 'Suction_Pressure_Sensor'),
  ('refrigerant-discharge-pressure', 'Refrigerant Discharge Pressure', 'pressures', 'Refrigerant pressure at the compressor discharge outlet', 'Number', 'sensor', 'refrig discharge pressure sensor', 'psi', 'Number', 'Discharge_Pressure_Sensor'),
  ('steam-pressure', 'Steam Pressure', 'pressures', 'Pressure of steam in distribution piping or at equipment connection', 'Number', 'sensor', 'steam pressure sensor', 'psi', 'Number', 'Steam_Pressure_Sensor'),
  ('gas-pressure', 'Gas Pressure', 'pressures', 'Natural gas supply pressure at meter or equipment inlet', 'Number', 'sensor', 'gas pressure sensor', 'in.w.c.', 'Number', 'Gas_Pressure_Sensor'),
  ('head-pressure', 'Head Pressure', 'pressures', 'Condenser head pressure in a refrigeration or chiller system', 'Number', 'sensor', 'head pressure sensor', 'psi', 'Number', 'Pressure_Sensor'),
  ('exhaust-air-static-pressure', 'Exhaust Air Static Pressure', 'pressures', 'Static pressure in exhaust air ductwork', 'Number', 'sensor', 'exhaust air static pressure sensor', 'in.w.c.', 'Number', 'Static_Pressure_Sensor'),
  ('supply-air-static-pressure', 'Supply Air Static Pressure', 'pressures', 'Static pressure in supply air ductwork downstream of the supply fan', 'Number', 'sensor', 'supply air static pressure sensor', 'in.w.c.', 'Number', 'Supply_Air_Static_Pressure_Sensor'),
  ('natural-gas-pressure', 'Natural Gas Pressure', 'pressures', 'Gas line pressure at the building meter or regulator outlet', 'Number', 'sensor', 'natural gas pressure sensor', 'in.w.c.', 'Number', 'Gas_Pressure_Sensor'),
  ('water-pressure', 'Water Pressure', 'pressures', 'Domestic or process water pressure in building piping', 'Number', 'sensor', 'water pressure sensor', 'psi', 'Number', 'Water_Pressure_Sensor'),
  ('oil-pressure', 'Oil Pressure', 'pressures', 'Lubrication oil pressure in compressor or engine systems', 'Number', 'sensor', 'oil pressure sensor', 'psi', 'Number', 'Pressure_Sensor'),
  ('suction-pressure', 'Suction Pressure', 'pressures', 'Low-side pressure in a refrigeration circuit at the compressor inlet', 'Number', 'sensor', 'suction pressure sensor', 'psi', 'Number', 'Suction_Pressure_Sensor'),
  ('condenser-pressure', 'Condenser Pressure', 'pressures', 'High-side pressure in condenser of a refrigeration or chiller system', 'Number', 'sensor', 'condenser pressure sensor', 'psi', 'Number', 'Pressure_Sensor'),
  ('boiler-pressure', 'Boiler Pressure', 'pressures', 'Operating pressure within the boiler vessel', 'Number', 'sensor', 'boiler pressure sensor', 'psi', 'Number', 'Pressure_Sensor'),
  ('chilled-water-pressure', 'Chilled Water Pressure', 'pressures', 'Pressure in the chilled water supply or return piping', 'Number', 'sensor', 'chilled water pressure sensor', 'psi', 'Number', 'Pressure_Sensor');

-- ── Flows (+15) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('makeup-water-flow', 'Makeup Water Flow', 'flows', 'Flow rate of makeup water added to a cooling tower or hydronic system to replace losses', 'Number', 'sensor', 'makeup water flow sensor', 'gpm', 'Number', 'Water_Flow_Sensor'),
  ('domestic-hot-water-flow', 'Domestic Hot Water Flow', 'flows', 'Flow rate of domestic hot water in recirculation or distribution piping', 'Number', 'sensor', 'domestic hot water flow sensor', 'gpm', 'Number', 'Hot_Water_Flow_Sensor'),
  ('blowdown-flow', 'Blowdown Flow', 'flows', 'Flow rate of water discharged from cooling tower or boiler for water quality control', 'Number', 'sensor', 'blowdown water flow sensor', 'gpm', 'Number', 'Water_Flow_Sensor'),
  ('glycol-flow', 'Glycol Flow', 'flows', 'Flow rate of glycol solution in freeze-protected hydronic loops', 'Number', 'sensor', 'glycol flow sensor', 'gpm', 'Number', 'Water_Flow_Sensor'),
  ('refrigerant-flow', 'Refrigerant Flow', 'flows', 'Mass or volumetric flow rate of refrigerant in a refrigeration circuit', 'Number', 'sensor', 'refrig flow sensor', 'lb/min', 'Number', 'Flow_Sensor'),
  ('gas-flow', 'Gas Flow', 'flows', 'Natural gas volumetric flow rate at building meter or equipment', 'Number', 'sensor', 'gas flow sensor', 'cfh', 'Number', 'Gas_Flow_Sensor'),
  ('primary-chilled-water-flow', 'Primary Chilled Water Flow', 'flows', 'Flow rate through the primary chilled water loop serving chillers', 'Number', 'sensor', 'primary chilled water flow sensor', 'gpm', 'Number', 'Chilled_Water_Flow_Sensor'),
  ('secondary-chilled-water-flow', 'Secondary Chilled Water Flow', 'flows', 'Flow rate through the secondary chilled water loop serving building loads', 'Number', 'sensor', 'secondary chilled water flow sensor', 'gpm', 'Number', 'Chilled_Water_Flow_Sensor'),
  ('bypass-flow', 'Bypass Flow', 'flows', 'Flow rate through a system bypass line such as primary-secondary decoupler', 'Number', 'sensor', 'bypass flow sensor', 'gpm', 'Number', 'Water_Flow_Sensor'),
  ('primary-hot-water-flow', 'Primary Hot Water Flow', 'flows', 'Flow rate through the primary hot water loop serving boilers', 'Number', 'sensor', 'primary hot water flow sensor', 'gpm', 'Number', 'Hot_Water_Flow_Sensor'),
  ('secondary-hot-water-flow', 'Secondary Hot Water Flow', 'flows', 'Flow rate through the secondary hot water loop serving building loads', 'Number', 'sensor', 'secondary hot water flow sensor', 'gpm', 'Number', 'Hot_Water_Flow_Sensor'),
  ('cooling-tower-water-flow', 'Cooling Tower Water Flow', 'flows', 'Flow rate of condenser water through the cooling tower', 'Number', 'sensor', 'cooling tower water flow sensor', 'gpm', 'Number', 'Water_Flow_Sensor'),
  ('condensate-flow', 'Condensate Flow', 'flows', 'Flow rate of steam condensate returning to boiler feedwater system', 'Number', 'sensor', 'condensate flow sensor', 'gpm', 'Number', 'Water_Flow_Sensor'),
  ('ventilation-airflow', 'Ventilation Airflow', 'flows', 'Volume of outdoor ventilation air being delivered to the building per ASHRAE 62.1', 'Number', 'sensor', 'ventilation air flow sensor', 'cfm', 'Number', 'Outside_Air_Flow_Sensor'),
  ('minimum-outdoor-airflow', 'Minimum Outdoor Airflow', 'flows', 'Minimum outdoor air volume required for ventilation code compliance', 'Number', 'sensor', 'min outside air flow sensor', 'cfm', 'Number', 'Min_Outside_Air_Flow_Sensor');

-- ── Commands (+30) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('outdoor-air-damper-command', 'Outdoor Air Damper Command', 'commands', 'Control signal to the outdoor air intake damper actuator', 'Number', 'cmd', 'outside air damper cmd', '%', 'Number', 'Outside_Damper_Command'),
  ('return-air-damper-command', 'Return Air Damper Command', 'commands', 'Control signal to the return air damper actuator', 'Number', 'cmd', 'return air damper cmd', '%', 'Number', 'Return_Damper_Command'),
  ('exhaust-air-damper-command', 'Exhaust Air Damper Command', 'commands', 'Control signal to the exhaust air damper actuator', 'Number', 'cmd', 'exhaust air damper cmd', '%', 'Number', 'Exhaust_Damper_Command'),
  ('bypass-damper-command', 'Bypass Damper Command', 'commands', 'Control signal to a face-and-bypass or economizer bypass damper', 'Number', 'cmd', 'bypass damper cmd', '%', 'Number', 'Bypass_Damper_Command'),
  ('chilled-water-valve-command', 'Chilled Water Valve Command', 'commands', 'Control signal to the chilled water control valve actuator', 'Number', 'cmd', 'chilled water valve cmd', '%', 'Number', 'Chilled_Water_Valve_Command'),
  ('hot-water-valve-command', 'Hot Water Valve Command', 'commands', 'Control signal to the hot water control valve actuator', 'Number', 'cmd', 'hot water valve cmd', '%', 'Number', 'Hot_Water_Valve_Command'),
  ('steam-valve-command', 'Steam Valve Command', 'commands', 'Control signal to the steam control valve actuator', 'Number', 'cmd', 'steam valve cmd', '%', 'Number', 'Steam_Valve_Command'),
  ('preheat-valve-command', 'Preheat Valve Command', 'commands', 'Control signal to the preheat coil hot water or steam valve', 'Number', 'cmd', 'preheat valve cmd', '%', 'Number', 'Preheat_Valve_Command'),
  ('reheat-valve-command', 'Reheat Valve Command', 'commands', 'Control signal to a terminal unit reheat valve actuator', 'Number', 'cmd', 'reheat valve cmd', '%', 'Number', 'Reheat_Valve_Command'),
  ('condenser-water-valve-command', 'Condenser Water Valve Command', 'commands', 'Control signal to the condenser water isolation or control valve', 'Number', 'cmd', 'condenser water valve cmd', '%', 'Number', 'Valve_Command'),
  ('supply-fan-command', 'Supply Fan Command', 'commands', 'Start/stop command to the supply air fan', 'Bool', 'cmd', 'supply fan run cmd', NULL, 'Bool', 'Supply_Fan_Command'),
  ('return-fan-command', 'Return Fan Command', 'commands', 'Start/stop command to the return air fan', 'Bool', 'cmd', 'return fan run cmd', NULL, 'Bool', 'Return_Fan_Command'),
  ('exhaust-fan-command-bool', 'Exhaust Fan Command', 'commands', 'Start/stop command to an exhaust fan', 'Bool', 'cmd', 'exhaust fan run cmd', NULL, 'Bool', 'Exhaust_Fan_Command'),
  ('relief-fan-command-bool', 'Relief Fan Command', 'commands', 'Start/stop command to the relief fan', 'Bool', 'cmd', 'relief fan run cmd', NULL, 'Bool', 'Relief_Fan_Command'),
  ('compressor-command', 'Compressor Command', 'commands', 'Start/stop or stage command to a refrigeration compressor', 'Bool', 'cmd', 'compressor run cmd', NULL, 'Bool', 'Compressor_Command'),
  ('vfd-speed-command', 'VFD Speed Command', 'commands', 'Speed reference command sent to a variable frequency drive', 'Number', 'cmd', 'vfd speed cmd', '%', 'Number', 'Frequency_Command'),
  ('compressor-stage-command', 'Compressor Stage Command', 'commands', 'Stage number command for multi-stage compressor systems', 'Number', 'cmd', 'compressor stage cmd', NULL, 'Number', 'Compressor_Command'),
  ('lead-lag-command', 'Lead/Lag Command', 'commands', 'Designates which equipment operates as lead or lag in a sequenced system', 'Number', 'cmd', 'lead lag cmd', NULL, 'Number', 'Command'),
  ('setpoint-reset-command', 'Setpoint Reset Command', 'commands', 'Enables or disables automatic setpoint reset based on demand', 'Bool', 'cmd', 'sp reset enable cmd', NULL, 'Bool', 'Command'),
  ('morning-warmup-command', 'Morning Warmup Command', 'commands', 'Initiates morning warmup mode before scheduled occupancy', 'Bool', 'cmd', 'morning warmup cmd', NULL, 'Bool', 'Command'),
  ('night-purge-command', 'Night Purge Command', 'commands', 'Initiates night purge ventilation cycle using outdoor air for free cooling', 'Bool', 'cmd', 'night purge cmd', NULL, 'Bool', 'Command'),
  ('freeze-protection-command', 'Freeze Protection Command', 'commands', 'Activates freeze protection mode — opens hot water valves, starts pumps, closes OA damper', 'Bool', 'cmd', 'freeze protection cmd', NULL, 'Bool', 'Command'),
  ('smoke-control-command', 'Smoke Control Command', 'commands', 'Activates smoke control mode — pressurizes stairwells, controls dampers per fire plan', 'Bool', 'cmd', 'smoke control cmd', NULL, 'Bool', 'Command'),
  ('lighting-on-off-command', 'Lighting On/Off Command', 'commands', 'On/off command to a lighting circuit or zone', 'Bool', 'cmd', 'lighting run cmd', NULL, 'Bool', 'Luminance_Command'),
  ('dimming-level-command', 'Dimming Level Command', 'commands', 'Dimming level command to a lighting zone or fixture (0-100%)', 'Number', 'cmd', 'lighting dimming cmd', '%', 'Number', 'Luminance_Command'),
  ('schedule-override-command', 'Schedule Override Command', 'commands', 'Temporary override of scheduled operating mode from occupant or operator', 'Bool', 'cmd', 'schedule override cmd', NULL, 'Bool', 'Command'),
  ('alarm-reset-command', 'Alarm Reset Command', 'commands', 'Command to acknowledge and reset an active equipment alarm', 'Bool', 'cmd', 'alarm reset cmd', NULL, 'Bool', 'Command'),
  ('equipment-isolation-command', 'Equipment Isolation Command', 'commands', 'Command to isolate equipment from system — closes valves, stops associated pumps', 'Bool', 'cmd', 'equip isolation cmd', NULL, 'Bool', 'Command'),
  ('demand-limit-command', 'Demand Limit Command', 'commands', 'Activates demand limiting to reduce peak electrical consumption', 'Bool', 'cmd', 'demand limit cmd', NULL, 'Bool', 'Command'),
  ('condenser-water-pump-command-bool', 'Condenser Water Pump Command', 'commands', 'Start/stop command to the condenser water pump', 'Bool', 'cmd', 'condenser water pump run cmd', NULL, 'Bool', 'Pump_Command');

-- ── Status (+25) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('supply-fan-status', 'Supply Fan Status', 'status', 'Run status feedback from the supply fan motor starter or VFD', 'Bool', 'sensor', 'supply fan run status', NULL, 'Bool', 'Supply_Fan_Status'),
  ('return-fan-status', 'Return Fan Status', 'status', 'Run status feedback from the return fan motor starter or VFD', 'Bool', 'sensor', 'return fan run status', NULL, 'Bool', 'Return_Fan_Status'),
  ('exhaust-fan-status-bool', 'Exhaust Fan Status', 'status', 'Run status feedback from an exhaust fan motor starter or VFD', 'Bool', 'sensor', 'exhaust fan run status', NULL, 'Bool', 'Exhaust_Fan_Status'),
  ('compressor-status', 'Compressor Status', 'status', 'Run status feedback from a refrigeration or chiller compressor', 'Bool', 'sensor', 'compressor run status', NULL, 'Bool', 'Compressor_Status'),
  ('compressor-stage', 'Compressor Stage', 'status', 'Current active stage of a multi-stage compressor system', 'Number', 'sensor', 'compressor stage status', NULL, 'Number', 'Compressor_Status'),
  ('economizer-status', 'Economizer Status', 'status', 'Indicates whether the economizer is currently active providing free cooling', 'Bool', 'sensor', 'economizer status', NULL, 'Bool', 'Economizer_Status'),
  ('free-cooling-status', 'Free Cooling Status', 'status', 'Indicates whether the system is operating in free cooling mode using outdoor air or waterside economizer', 'Bool', 'sensor', 'free cooling status', NULL, 'Bool', 'Status'),
  ('morning-warmup-status', 'Morning Warmup Status', 'status', 'Indicates the system is in morning warmup mode before scheduled occupancy', 'Bool', 'sensor', 'morning warmup status', NULL, 'Bool', 'Status'),
  ('night-purge-status', 'Night Purge Status', 'status', 'Indicates the system is running night purge ventilation for free cooling', 'Bool', 'sensor', 'night purge status', NULL, 'Bool', 'Status'),
  ('freeze-stat-status', 'Freeze Stat Status', 'status', 'Freeze protection thermostat trip status — indicates potential coil freezing condition', 'Bool', 'sensor', 'freeze status', NULL, 'Bool', 'Freeze_Status'),
  ('high-limit-status', 'High Limit Status', 'status', 'High limit safety thermostat trip status', 'Bool', 'sensor', 'high limit status', NULL, 'Bool', 'Status'),
  ('low-limit-status', 'Low Limit Status', 'status', 'Low limit safety thermostat trip status', 'Bool', 'sensor', 'low limit status', NULL, 'Bool', 'Status'),
  ('proof-of-flow', 'Proof of Flow', 'status', 'Flow switch confirmation that fluid is flowing through piping', 'Bool', 'sensor', 'flow proof status', NULL, 'Bool', 'Flow_Status'),
  ('proof-of-airflow', 'Proof of Airflow', 'status', 'Airflow proving switch confirmation that air is moving through ductwork', 'Bool', 'sensor', 'air flow proof status', NULL, 'Bool', 'Air_Flow_Status'),
  ('dehumidification-status', 'Dehumidification Status', 'status', 'Indicates the system is actively dehumidifying', 'Bool', 'sensor', 'dehum status', NULL, 'Bool', 'Status'),
  ('humidification-status', 'Humidification Status', 'status', 'Indicates the humidifier is actively adding moisture', 'Bool', 'sensor', 'hum status', NULL, 'Bool', 'Status'),
  ('vfd-status', 'VFD Status', 'status', 'Run/ready status of a variable frequency drive', 'Bool', 'sensor', 'vfd run status', NULL, 'Bool', 'Frequency_Status'),
  ('emergency-power-status', 'Emergency Power Status', 'status', 'Indicates building is running on emergency generator power', 'Bool', 'sensor', 'emergency power status', NULL, 'Bool', 'Status'),
  ('generator-run-status', 'Generator Run Status', 'status', 'Run status of the emergency/standby generator', 'Bool', 'sensor', 'generator run status', NULL, 'Bool', 'Status'),
  ('ups-status', 'UPS Status', 'status', 'Operating status of the uninterruptible power supply — online, battery, bypass', 'Bool', 'sensor', 'ups status', NULL, 'Bool', 'Status'),
  ('fire-mode-status', 'Fire Mode Status', 'status', 'Indicates the HVAC system has been placed in fire/smoke mode by the fire alarm panel', 'Bool', 'sensor', 'fire mode status', NULL, 'Bool', 'Status'),
  ('smoke-control-status', 'Smoke Control Status', 'status', 'Indicates smoke control pressurization is active', 'Bool', 'sensor', 'smoke control status', NULL, 'Bool', 'Status'),
  ('lead-lag-status', 'Lead/Lag Status', 'status', 'Current lead/lag designation of sequenced equipment', 'Number', 'sensor', 'lead lag status', NULL, 'Number', 'Status'),
  ('standby-status', 'Standby Status', 'status', 'Equipment is in standby mode ready to start on demand', 'Bool', 'sensor', 'standby status', NULL, 'Bool', 'Status'),
  ('alarm-active-status', 'Alarm Active Status', 'status', 'Indicates one or more active alarms exist for this equipment', 'Bool', 'sensor', 'alarm active status', NULL, 'Bool', 'Status');

-- ── Alarms (+20) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('high-discharge-air-temperature-alarm', 'High Discharge Air Temp Alarm', 'alarms', 'Alarm when discharge air temperature exceeds high limit setpoint', 'Bool', 'alarm', 'discharge air temp high alarm', NULL, 'Bool', 'High_Temperature_Alarm'),
  ('low-discharge-air-temperature-alarm', 'Low Discharge Air Temp Alarm', 'alarms', 'Alarm when discharge air temperature drops below low limit setpoint', 'Bool', 'alarm', 'discharge air temp low alarm', NULL, 'Bool', 'Low_Temperature_Alarm'),
  ('high-zone-temperature-alarm', 'High Zone Temperature Alarm', 'alarms', 'Alarm when zone temperature exceeds comfort or safety high limit', 'Bool', 'alarm', 'zone temp high alarm', NULL, 'Bool', 'High_Temperature_Alarm'),
  ('low-zone-temperature-alarm', 'Low Zone Temperature Alarm', 'alarms', 'Alarm when zone temperature drops below comfort or safety low limit', 'Bool', 'alarm', 'zone temp low alarm', NULL, 'Bool', 'Low_Temperature_Alarm'),
  ('high-duct-static-pressure-alarm', 'High Duct Static Pressure Alarm', 'alarms', 'Alarm when duct static pressure exceeds safe operating limit', 'Bool', 'alarm', 'duct static pressure high alarm', NULL, 'Bool', 'High_Static_Pressure_Alarm'),
  ('low-duct-static-pressure-alarm', 'Low Duct Static Pressure Alarm', 'alarms', 'Alarm when duct static pressure drops below minimum operating threshold', 'Bool', 'alarm', 'duct static pressure low alarm', NULL, 'Bool', 'Low_Static_Pressure_Alarm'),
  ('freeze-protection-alarm', 'Freeze Protection Alarm', 'alarms', 'Alarm indicating a freeze condition has been detected — coil or pipe freeze risk', 'Bool', 'alarm', 'freeze alarm', NULL, 'Bool', 'Freeze_Alarm'),
  ('vfd-fault-alarm', 'VFD Fault Alarm', 'alarms', 'Variable frequency drive has reported a fault condition', 'Bool', 'alarm', 'vfd fault alarm', NULL, 'Bool', 'Fault_Status'),
  ('motor-overload-alarm', 'Motor Overload Alarm', 'alarms', 'Motor thermal overload protection has tripped', 'Bool', 'alarm', 'motor overload alarm', NULL, 'Bool', 'Fault_Status'),
  ('high-co2-alarm', 'High CO2 Alarm', 'alarms', 'Indoor CO2 concentration exceeds ventilation alarm threshold', 'Bool', 'alarm', 'co2 high alarm', NULL, 'Bool', 'CO2_Alarm'),
  ('refrigerant-leak-alarm', 'Refrigerant Leak Alarm', 'alarms', 'Refrigerant gas detected by leak sensor above allowable concentration', 'Bool', 'alarm', 'refrig leak alarm', NULL, 'Bool', 'Leak_Alarm'),
  ('high-humidity-alarm', 'High Humidity Alarm', 'alarms', 'Space or duct humidity exceeds high limit alarm setpoint', 'Bool', 'alarm', 'humidity high alarm', NULL, 'Bool', 'High_Humidity_Alarm'),
  ('low-humidity-alarm', 'Low Humidity Alarm', 'alarms', 'Space or duct humidity drops below low limit alarm setpoint', 'Bool', 'alarm', 'humidity low alarm', NULL, 'Bool', 'Low_Humidity_Alarm'),
  ('power-failure-alarm', 'Power Failure Alarm', 'alarms', 'Normal utility power has been lost — building on generator or UPS', 'Bool', 'alarm', 'power failure alarm', NULL, 'Bool', 'Fault_Status'),
  ('generator-alarm', 'Generator Alarm', 'alarms', 'Emergency generator has reported a fault or failure to start', 'Bool', 'alarm', 'generator fault alarm', NULL, 'Bool', 'Fault_Status'),
  ('ups-alarm', 'UPS Alarm', 'alarms', 'UPS battery low, on battery, or fault condition', 'Bool', 'alarm', 'ups fault alarm', NULL, 'Bool', 'Fault_Status'),
  ('water-leak-alarm', 'Water Leak Alarm', 'alarms', 'Water detected by leak sensor in mechanical room, ceiling, or floor', 'Bool', 'alarm', 'water leak alarm', NULL, 'Bool', 'Leak_Alarm'),
  ('high-condenser-pressure-alarm', 'High Condenser Pressure Alarm', 'alarms', 'Condenser pressure exceeds safe operating limit — potential condenser fouling or fan failure', 'Bool', 'alarm', 'condenser pressure high alarm', NULL, 'Bool', 'High_Pressure_Alarm'),
  ('low-suction-pressure-alarm', 'Low Suction Pressure Alarm', 'alarms', 'Compressor suction pressure below safe limit — potential refrigerant loss or restriction', 'Bool', 'alarm', 'suction pressure low alarm', NULL, 'Bool', 'Low_Pressure_Alarm'),
  ('vibration-alarm', 'Vibration Alarm', 'alarms', 'Equipment vibration exceeds alarm threshold — potential bearing failure or imbalance', 'Bool', 'alarm', 'vibration high alarm', NULL, 'Bool', 'Fault_Status');

-- ── Electrical (+10) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('voltage-phase-a', 'Voltage Phase A', 'electrical', 'Line-to-neutral voltage measurement on Phase A', 'Number', 'sensor', 'elec voltage phase a sensor', 'V', 'Number', 'Voltage_Sensor'),
  ('voltage-phase-b', 'Voltage Phase B', 'electrical', 'Line-to-neutral voltage measurement on Phase B', 'Number', 'sensor', 'elec voltage phase b sensor', 'V', 'Number', 'Voltage_Sensor'),
  ('voltage-phase-c', 'Voltage Phase C', 'electrical', 'Line-to-neutral voltage measurement on Phase C', 'Number', 'sensor', 'elec voltage phase c sensor', 'V', 'Number', 'Voltage_Sensor'),
  ('current-phase-a', 'Current Phase A', 'electrical', 'Current measurement on Phase A via current transformer', 'Number', 'sensor', 'elec current phase a sensor', 'A', 'Number', 'Current_Sensor'),
  ('current-phase-b', 'Current Phase B', 'electrical', 'Current measurement on Phase B via current transformer', 'Number', 'sensor', 'elec current phase b sensor', 'A', 'Number', 'Current_Sensor'),
  ('current-phase-c', 'Current Phase C', 'electrical', 'Current measurement on Phase C via current transformer', 'Number', 'sensor', 'elec current phase c sensor', 'A', 'Number', 'Current_Sensor'),
  ('demand-power', 'Demand Power', 'electrical', 'Peak power demand over a defined interval for utility demand charges', 'Number', 'sensor', 'elec demand power sensor', 'kW', 'Number', 'Peak_Power_Demand_Sensor'),
  ('total-harmonic-distortion', 'Total Harmonic Distortion', 'electrical', 'Total harmonic distortion percentage of voltage or current waveform', 'Number', 'sensor', 'elec thd sensor', '%', 'Number', 'Power_Quality_Sensor'),
  ('line-to-line-voltage', 'Line-to-Line Voltage', 'electrical', 'Voltage measured between two phases of a three-phase system', 'Number', 'sensor', 'elec voltage line sensor', 'V', 'Number', 'Voltage_Sensor'),
  ('line-to-neutral-voltage', 'Line-to-Neutral Voltage', 'electrical', 'Voltage measured between a phase and neutral', 'Number', 'sensor', 'elec voltage neutral sensor', 'V', 'Number', 'Voltage_Sensor');

-- ── Humidity (+8) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('supply-air-humidity', 'Supply Air Humidity', 'humidity', 'Relative humidity of supply air leaving the air handling unit', 'Number', 'sensor', 'supply air humidity sensor', '%RH', 'Number', 'Supply_Air_Humidity_Sensor'),
  ('zone-humidity-setpoint', 'Zone Humidity Setpoint', 'humidity', 'Target relative humidity setpoint for a zone or space', 'Number', 'sp', 'zone humidity sp', '%RH', 'Number', 'Zone_Humidity_Setpoint'),
  ('supply-air-dewpoint', 'Supply Air Dewpoint', 'humidity', 'Dewpoint temperature of supply air for humidity control applications', 'Number', 'sensor', 'supply air dewpoint sensor', '°F', 'Number', 'Dewpoint_Sensor'),
  ('humidifier-command', 'Humidifier Command', 'humidity', 'Modulating output command to a steam or evaporative humidifier', 'Number', 'cmd', 'humidifier cmd', '%', 'Number', 'Humidifier_Command'),
  ('dehumidifier-command', 'Dehumidifier Command', 'humidity', 'Command signal to activate dehumidification mode or dehumidifier unit', 'Bool', 'cmd', 'dehumidifier cmd', NULL, 'Bool', 'Command'),
  ('humidifier-run-status', 'Humidifier Run Status', 'humidity', 'Run status feedback from the humidifier — producing steam/mist or not', 'Bool', 'sensor', 'humidifier run status', NULL, 'Bool', 'Humidifier_Status'),
  ('dehumidifier-status', 'Dehumidifier Status', 'humidity', 'Run status of the dehumidifier or dehumidification mode', 'Bool', 'sensor', 'dehumidifier status', NULL, 'Bool', 'Status'),
  ('dehumidifier-output', 'Dehumidifier Output', 'humidity', 'Modulating output level of a dehumidifier unit', 'Number', 'cmd', 'dehumidifier output cmd', '%', 'Number', 'Command');

-- ── IAQ (+8) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('co-level', 'Carbon Monoxide Level', 'iaq', 'Carbon monoxide gas concentration — critical safety parameter for parking garages and boiler rooms', 'Number', 'sensor', 'co sensor', 'ppm', 'Number', 'CO_Sensor'),
  ('formaldehyde-level', 'Formaldehyde Level', 'iaq', 'Formaldehyde gas concentration for indoor air quality monitoring in new construction', 'Number', 'sensor', 'formaldehyde sensor', 'ppb', 'Number', 'Air_Quality_Sensor'),
  ('ozone-level', 'Ozone Level', 'iaq', 'Ozone concentration for outdoor air quality and indoor pollutant monitoring', 'Number', 'sensor', 'ozone sensor', 'ppb', 'Number', 'Air_Quality_Sensor'),
  ('ventilation-rate', 'Ventilation Rate', 'iaq', 'Outdoor air ventilation rate per person or per area for ASHRAE 62.1 compliance', 'Number', 'sensor', 'ventilation rate sensor', 'cfm/person', 'Number', 'Air_Flow_Sensor'),
  ('air-changes-per-hour', 'Air Changes Per Hour', 'iaq', 'Number of complete air volume changes per hour in a space — critical for labs, clean rooms, and isolation rooms', 'Number', 'sensor', 'air changes sensor', 'ACH', 'Number', 'Air_Flow_Sensor'),
  ('radon-level', 'Radon Level', 'iaq', 'Radon gas concentration for below-grade spaces and basements', 'Number', 'sensor', 'radon sensor', 'pCi/L', 'Number', 'Air_Quality_Sensor'),
  ('nitrogen-dioxide-level', 'Nitrogen Dioxide Level', 'iaq', 'NO2 concentration for combustion appliance and vehicle exhaust monitoring', 'Number', 'sensor', 'no2 sensor', 'ppb', 'Number', 'Air_Quality_Sensor'),
  ('outdoor-air-quality-index', 'Outdoor Air Quality Index', 'iaq', 'Composite outdoor air quality index for economizer enable/disable decisions', 'Number', 'sensor', 'outside air quality index sensor', NULL, 'Number', 'Air_Quality_Sensor');

-- ── Setpoints (+20) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('supply-airflow-setpoint', 'Supply Airflow Setpoint', 'setpoints', 'Target supply airflow volume for a VAV box or AHU', 'Number', 'sp', 'supply air flow sp', 'cfm', 'Number', 'Supply_Air_Flow_Setpoint'),
  ('minimum-airflow-setpoint', 'Minimum Airflow Setpoint', 'setpoints', 'Minimum airflow volume setpoint for a VAV box — ventilation minimum', 'Number', 'sp', 'air flow min sp', 'cfm', 'Number', 'Min_Air_Flow_Setpoint'),
  ('maximum-airflow-setpoint', 'Maximum Airflow Setpoint', 'setpoints', 'Maximum airflow volume setpoint for a VAV box — full cooling capacity', 'Number', 'sp', 'air flow max sp', 'cfm', 'Number', 'Max_Air_Flow_Setpoint'),
  ('exhaust-airflow-setpoint', 'Exhaust Airflow Setpoint', 'setpoints', 'Target exhaust airflow for maintaining building pressure or code ventilation', 'Number', 'sp', 'exhaust air flow sp', 'cfm', 'Number', 'Exhaust_Air_Flow_Setpoint'),
  ('return-air-temperature-setpoint', 'Return Air Temperature Setpoint', 'setpoints', 'Target return air temperature for mixed air control', 'Number', 'sp', 'return air temp sp', '°F', 'Number', 'Return_Air_Temperature_Setpoint'),
  ('supply-air-humidity-setpoint', 'Supply Air Humidity Setpoint', 'setpoints', 'Target supply air humidity for critical environments', 'Number', 'sp', 'supply air humidity sp', '%RH', 'Number', 'Supply_Air_Humidity_Setpoint'),
  ('duct-static-pressure-reset-setpoint', 'Duct Static Pressure Reset Setpoint', 'setpoints', 'Optimized duct static pressure setpoint from trim-and-respond or demand reset logic', 'Number', 'sp', 'duct static pressure reset sp', 'in.w.c.', 'Number', 'Static_Pressure_Setpoint'),
  ('chilled-water-temperature-reset-setpoint', 'CHW Temperature Reset Setpoint', 'setpoints', 'Optimized chilled water supply temperature from reset schedule or demand logic', 'Number', 'sp', 'chilled water temp reset sp', '°F', 'Number', 'Chilled_Water_Temperature_Setpoint'),
  ('hot-water-temperature-reset-setpoint', 'HW Temperature Reset Setpoint', 'setpoints', 'Optimized hot water supply temperature from outdoor air reset schedule', 'Number', 'sp', 'hot water temp reset sp', '°F', 'Number', 'Hot_Water_Temperature_Setpoint'),
  ('supply-air-temperature-setpoint', 'Supply Air Temperature Setpoint', 'setpoints', 'Target supply air temperature for an AHU discharge', 'Number', 'sp', 'supply air temp sp', '°F', 'Number', 'Supply_Air_Temperature_Setpoint'),
  ('condenser-water-differential-pressure-setpoint', 'CW Differential Pressure Setpoint', 'setpoints', 'Target differential pressure for condenser water system', 'Number', 'sp', 'condenser water differential pressure sp', 'psi', 'Number', 'Differential_Pressure_Setpoint'),
  ('hot-water-differential-pressure-setpoint', 'HW Differential Pressure Setpoint', 'setpoints', 'Target differential pressure for hot water distribution system', 'Number', 'sp', 'hot water differential pressure sp', 'psi', 'Number', 'Differential_Pressure_Setpoint'),
  ('economizer-high-limit-setpoint', 'Economizer High Limit Setpoint', 'setpoints', 'Outdoor air temperature or enthalpy above which economizer is disabled', 'Number', 'sp', 'economizer high limit sp', '°F', 'Number', 'Outside_Air_Temperature_Setpoint'),
  ('vfd-speed-setpoint', 'VFD Speed Setpoint', 'setpoints', 'Target speed setpoint for a variable frequency drive', 'Number', 'sp', 'vfd speed sp', '%', 'Number', 'Speed_Setpoint'),
  ('demand-limit-setpoint', 'Demand Limit Setpoint', 'setpoints', 'Maximum electrical demand limit for load shedding control', 'Number', 'sp', 'demand limit sp', 'kW', 'Number', 'Power_Setpoint'),
  ('co2-ventilation-setpoint', 'CO2 Ventilation Setpoint', 'setpoints', 'CO2 concentration threshold that triggers increased ventilation via demand control ventilation', 'Number', 'sp', 'co2 ventilation sp', 'ppm', 'Number', 'CO2_Setpoint'),
  ('co-alarm-setpoint', 'CO Alarm Setpoint', 'setpoints', 'Carbon monoxide concentration alarm threshold for garage or boiler room ventilation', 'Number', 'sp', 'co alarm sp', 'ppm', 'Number', 'CO_Setpoint'),
  ('warmup-setpoint', 'Warmup Temperature Setpoint', 'setpoints', 'Target zone temperature during morning warmup mode', 'Number', 'sp', 'warmup temp sp', '°F', 'Number', 'Temperature_Setpoint'),
  ('cooling-tower-approach-setpoint', 'Cooling Tower Approach Setpoint', 'setpoints', 'Target temperature approach between condenser water leaving and outdoor wet bulb', 'Number', 'sp', 'cooling tower approach sp', '°F', 'Number', 'Temperature_Setpoint'),
  ('discharge-air-temperature-reset-setpoint', 'DAT Reset Setpoint', 'setpoints', 'Optimized discharge air temperature from demand reset logic', 'Number', 'sp', 'discharge air temp reset sp', '°F', 'Number', 'Discharge_Air_Temperature_Setpoint');

-- ── Calculated / Maintenance (+15) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('chiller-cop', 'Chiller COP', 'maintenance', 'Coefficient of performance — ratio of cooling output to electrical input for a chiller', 'Number', 'sensor', 'chiller cop sensor', 'COP', 'Number', 'Efficiency_Sensor'),
  ('chiller-kw-per-ton', 'Chiller kW/ton', 'maintenance', 'Chiller efficiency expressed as electrical input per ton of cooling output', 'Number', 'sensor', 'chiller efficiency sensor', 'kW/ton', 'Number', 'Efficiency_Sensor'),
  ('cooling-degree-days', 'Cooling Degree Days', 'maintenance', 'Accumulated cooling degree days for energy analysis and weather normalization', 'Number', 'sensor', 'cooling degree days sensor', 'degday', 'Number', 'Degree_Day_Sensor'),
  ('heating-degree-days', 'Heating Degree Days', 'maintenance', 'Accumulated heating degree days for energy analysis and weather normalization', 'Number', 'sensor', 'heating degree days sensor', 'degday', 'Number', 'Degree_Day_Sensor'),
  ('runtime-hours-total', 'Total Runtime Hours', 'maintenance', 'Cumulative operating hours since last reset for maintenance scheduling', 'Number', 'sensor', 'run hours total sensor', 'hr', 'Number', 'Run_Hours_Sensor'),
  ('supply-air-delta-t', 'Supply Air Delta-T', 'maintenance', 'Temperature difference between mixed/return air and supply/discharge air', 'Number', 'sensor', 'supply air delta temp sensor', '°F', 'Number', 'Temperature_Sensor'),
  ('chilled-water-delta-t', 'Chilled Water Delta-T', 'maintenance', 'Temperature difference between chilled water supply and return', 'Number', 'sensor', 'chilled water delta temp sensor', '°F', 'Number', 'Temperature_Sensor'),
  ('hot-water-delta-t', 'Hot Water Delta-T', 'maintenance', 'Temperature difference between hot water supply and return', 'Number', 'sensor', 'hot water delta temp sensor', '°F', 'Number', 'Temperature_Sensor'),
  ('outdoor-air-enthalpy', 'Outdoor Air Enthalpy', 'maintenance', 'Total heat content of outdoor air — used for economizer control decisions', 'Number', 'sensor', 'outside air enthalpy sensor', 'BTU/lb', 'Number', 'Enthalpy_Sensor'),
  ('return-air-enthalpy', 'Return Air Enthalpy', 'maintenance', 'Total heat content of return air — compared with outdoor air for economizer', 'Number', 'sensor', 'return air enthalpy sensor', 'BTU/lb', 'Number', 'Enthalpy_Sensor'),
  ('supply-air-enthalpy', 'Supply Air Enthalpy', 'maintenance', 'Total heat content of supply air leaving the AHU', 'Number', 'sensor', 'supply air enthalpy sensor', 'BTU/lb', 'Number', 'Enthalpy_Sensor'),
  ('energy-use-intensity', 'Energy Use Intensity', 'maintenance', 'Building energy consumption normalized by floor area — kBTU per square foot per year', 'Number', 'sensor', 'energy use intensity sensor', 'kBTU/ft²', 'Number', 'Energy_Sensor'),
  ('condenser-approach-temperature', 'Condenser Approach Temperature', 'maintenance', 'Temperature difference between condenser water leaving tower and outdoor wet bulb', 'Number', 'sensor', 'condenser approach temp sensor', '°F', 'Number', 'Temperature_Sensor'),
  ('evaporator-approach-temperature', 'Evaporator Approach Temperature', 'maintenance', 'Temperature difference between chilled water leaving evaporator and refrigerant', 'Number', 'sensor', 'evaporator approach temp sensor', '°F', 'Number', 'Temperature_Sensor'),
  ('motor-current-percentage', 'Motor Current Percentage', 'maintenance', 'Motor current as percentage of full load amps for motor health monitoring', 'Number', 'sensor', 'motor current pct sensor', '%', 'Number', 'Current_Sensor');

-- ── Additional Dampers (+10) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('bypass-damper-position', 'Bypass Damper Position', 'dampers', 'Current position feedback of a bypass damper', 'Number', 'sensor', 'bypass damper pos sensor', '%', 'Number', 'Damper_Position_Sensor'),
  ('bypass-damper-closed', 'Bypass Damper Closed', 'dampers', 'End switch confirming bypass damper is fully closed', 'Bool', 'sensor', 'bypass damper closed status', NULL, 'Bool', 'Damper_Status'),
  ('bypass-damper-open', 'Bypass Damper Open', 'dampers', 'End switch confirming bypass damper is fully open', 'Bool', 'sensor', 'bypass damper open status', NULL, 'Bool', 'Damper_Status'),
  ('bypass-damper-feedback', 'Bypass Damper Feedback', 'dampers', 'Position feedback signal from bypass damper actuator', 'Number', 'sensor', 'bypass damper feedback sensor', '%', 'Number', 'Damper_Position_Sensor'),
  ('bypass-damper-output', 'Bypass Damper Output', 'dampers', 'Control output signal to bypass damper actuator', 'Number', 'cmd', 'bypass damper cmd', '%', 'Number', 'Damper_Command'),
  ('return-air-damper-position', 'Return Air Damper Position', 'dampers', 'Current position of the return air damper', 'Number', 'sensor', 'return air damper pos sensor', '%', 'Number', 'Damper_Position_Sensor'),
  ('return-air-damper-closed', 'Return Air Damper Closed', 'dampers', 'End switch confirming return air damper is fully closed', 'Bool', 'sensor', 'return air damper closed status', NULL, 'Bool', 'Damper_Status'),
  ('return-air-damper-open', 'Return Air Damper Open', 'dampers', 'End switch confirming return air damper is fully open', 'Bool', 'sensor', 'return air damper open status', NULL, 'Bool', 'Damper_Status'),
  ('fire-damper-position', 'Fire Damper Position', 'dampers', 'Position status of a fire or fire-smoke damper — open or closed', 'Bool', 'sensor', 'fire damper pos status', NULL, 'Bool', 'Damper_Status'),
  ('fire-damper-status', 'Fire Damper Status', 'dampers', 'Monitoring status indicating if fire damper has actuated to closed position', 'Bool', 'sensor', 'fire damper status', NULL, 'Bool', 'Damper_Status');

-- ── Additional Valves (+10) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('preheat-valve-position', 'Preheat Valve Position', 'valves', 'Current position of the preheat coil control valve', 'Number', 'sensor', 'preheat valve pos sensor', '%', 'Number', 'Valve_Position_Sensor'),
  ('preheat-valve-output', 'Preheat Valve Output', 'valves', 'Control output signal to the preheat valve actuator', 'Number', 'cmd', 'preheat valve cmd', '%', 'Number', 'Valve_Command'),
  ('reheat-valve-position', 'Reheat Valve Position', 'valves', 'Current position of a terminal unit reheat valve', 'Number', 'sensor', 'reheat valve pos sensor', '%', 'Number', 'Valve_Position_Sensor'),
  ('reheat-valve-output', 'Reheat Valve Output', 'valves', 'Control output signal to the reheat valve actuator', 'Number', 'cmd', 'reheat valve cmd', '%', 'Number', 'Valve_Command'),
  ('chilled-water-valve-position', 'Chilled Water Valve Position', 'valves', 'Current position feedback of the chilled water control valve', 'Number', 'sensor', 'chilled water valve pos sensor', '%', 'Number', 'Valve_Position_Sensor'),
  ('hot-water-valve-position', 'Hot Water Valve Position', 'valves', 'Current position feedback of the hot water control valve', 'Number', 'sensor', 'hot water valve pos sensor', '%', 'Number', 'Valve_Position_Sensor'),
  ('condenser-water-valve-position', 'Condenser Water Valve Position', 'valves', 'Current position of the condenser water isolation or control valve', 'Number', 'sensor', 'condenser water valve pos sensor', '%', 'Number', 'Valve_Position_Sensor'),
  ('steam-valve-position', 'Steam Valve Position', 'valves', 'Current position of the steam control valve', 'Number', 'sensor', 'steam valve pos sensor', '%', 'Number', 'Valve_Position_Sensor'),
  ('steam-valve-output', 'Steam Valve Output', 'valves', 'Control output signal to the steam valve actuator', 'Number', 'cmd', 'steam valve cmd', '%', 'Number', 'Valve_Command'),
  ('three-way-valve-position', 'Three-Way Valve Position', 'valves', 'Position of a three-way mixing or diverting valve', 'Number', 'sensor', 'three way valve pos sensor', '%', 'Number', 'Valve_Position_Sensor');

-- ── Additional Fan Points (+10) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('supply-fan-vfd-speed', 'Supply Fan VFD Speed', 'fans', 'Current speed of the supply fan VFD as percentage of full speed', 'Number', 'sensor', 'supply fan vfd speed sensor', '%', 'Number', 'Speed_Sensor'),
  ('return-fan-vfd-speed', 'Return Fan VFD Speed', 'fans', 'Current speed of the return fan VFD as percentage of full speed', 'Number', 'sensor', 'return fan vfd speed sensor', '%', 'Number', 'Speed_Sensor'),
  ('exhaust-fan-vfd-speed', 'Exhaust Fan VFD Speed', 'fans', 'Current speed of an exhaust fan VFD as percentage of full speed', 'Number', 'sensor', 'exhaust fan vfd speed sensor', '%', 'Number', 'Speed_Sensor'),
  ('cooling-tower-fan-command', 'Cooling Tower Fan Command', 'fans', 'Start/stop or speed command to cooling tower fan', 'Bool', 'cmd', 'cooling tower fan run cmd', NULL, 'Bool', 'Fan_Command'),
  ('cooling-tower-fan-status', 'Cooling Tower Fan Status', 'fans', 'Run status of the cooling tower fan motor', 'Bool', 'sensor', 'cooling tower fan run status', NULL, 'Bool', 'Fan_Status'),
  ('cooling-tower-fan-speed', 'Cooling Tower Fan Speed', 'fans', 'Current speed of the cooling tower fan VFD', 'Number', 'sensor', 'cooling tower fan speed sensor', '%', 'Number', 'Speed_Sensor'),
  ('garage-exhaust-fan-command', 'Garage Exhaust Fan Command', 'fans', 'Start/stop command to parking garage exhaust fan activated by CO levels', 'Bool', 'cmd', 'garage exhaust fan run cmd', NULL, 'Bool', 'Fan_Command'),
  ('garage-exhaust-fan-status', 'Garage Exhaust Fan Status', 'fans', 'Run status of the parking garage exhaust fan', 'Bool', 'sensor', 'garage exhaust fan run status', NULL, 'Bool', 'Fan_Status'),
  ('kitchen-exhaust-fan-command', 'Kitchen Exhaust Fan Command', 'fans', 'Start/stop command to kitchen hood exhaust fan with fire suppression interlock', 'Bool', 'cmd', 'kitchen exhaust fan run cmd', NULL, 'Bool', 'Fan_Command'),
  ('kitchen-exhaust-fan-status', 'Kitchen Exhaust Fan Status', 'fans', 'Run status of the kitchen exhaust fan', 'Bool', 'sensor', 'kitchen exhaust fan run status', NULL, 'Bool', 'Fan_Status');

-- ── Additional Lighting Points (+10) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('lighting-status', 'Lighting Status', 'lighting', 'On/off status of a lighting circuit or zone', 'Bool', 'sensor', 'lighting run status', NULL, 'Bool', 'Luminance_Status'),
  ('lighting-command', 'Lighting Command', 'lighting', 'On/off control command to a lighting circuit or zone', 'Bool', 'cmd', 'lighting run cmd', NULL, 'Bool', 'Luminance_Command'),
  ('lighting-schedule', 'Lighting Schedule', 'lighting', 'Schedule status for automated lighting control', 'Bool', 'sensor', 'lighting schedule status', NULL, 'Bool', 'Schedule_Status'),
  ('lighting-power-consumption', 'Lighting Power Consumption', 'lighting', 'Electrical power consumed by a lighting circuit or zone', 'Number', 'sensor', 'lighting power sensor', 'kW', 'Number', 'Power_Sensor'),
  ('emergency-lighting-status', 'Emergency Lighting Status', 'lighting', 'Status of emergency and exit lighting — on battery or normal power', 'Bool', 'sensor', 'emergency lighting status', NULL, 'Bool', 'Status'),
  ('exterior-lighting-command', 'Exterior Lighting Command', 'lighting', 'On/off command for exterior/facade/parking lighting', 'Bool', 'cmd', 'exterior lighting cmd', NULL, 'Bool', 'Luminance_Command'),
  ('exterior-lighting-status', 'Exterior Lighting Status', 'lighting', 'On/off status of exterior lighting circuits', 'Bool', 'sensor', 'exterior lighting status', NULL, 'Bool', 'Luminance_Status'),
  ('task-lighting-level', 'Task Lighting Level', 'lighting', 'Light level at task height measured in footcandles or lux', 'Number', 'sensor', 'task lighting level sensor', 'fc', 'Number', 'Luminance_Sensor'),
  ('ambient-lighting-level', 'Ambient Lighting Level', 'lighting', 'General ambient light level in a space', 'Number', 'sensor', 'ambient lighting level sensor', 'fc', 'Number', 'Luminance_Sensor'),
  ('lighting-scene-command', 'Lighting Scene Command', 'lighting', 'Preset scene selection command for multi-zone lighting control', 'Number', 'cmd', 'lighting scene cmd', NULL, 'Number', 'Luminance_Command');

-- ── Refrigeration Points (+10) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('compressor-discharge-temperature', 'Compressor Discharge Temperature', 'temperatures', 'Hot gas temperature leaving the compressor discharge port', 'Number', 'sensor', 'compressor discharge temp sensor', '°F', 'Number', 'Discharge_Temperature_Sensor'),
  ('compressor-suction-temperature', 'Compressor Suction Temperature', 'temperatures', 'Refrigerant temperature at the compressor suction port', 'Number', 'sensor', 'compressor suction temp sensor', '°F', 'Number', 'Suction_Temperature_Sensor'),
  ('evaporator-temperature', 'Evaporator Temperature', 'temperatures', 'Refrigerant or air temperature at the evaporator coil', 'Number', 'sensor', 'evaporator temp sensor', '°F', 'Number', 'Evaporator_Temperature_Sensor'),
  ('condenser-temperature', 'Condenser Temperature', 'temperatures', 'Refrigerant or air temperature at the condenser coil', 'Number', 'sensor', 'condenser temp sensor', '°F', 'Number', 'Temperature_Sensor'),
  ('superheat-temperature', 'Superheat Temperature', 'temperatures', 'Degrees of superheat above refrigerant saturation at compressor suction', 'Number', 'sensor', 'superheat temp sensor', '°F', 'Number', 'Temperature_Sensor'),
  ('refrigerant-level', 'Refrigerant Level', 'status', 'Refrigerant charge level indicator — normal, low, or critical', 'Number', 'sensor', 'refrig level sensor', '%', 'Number', 'Level_Sensor'),
  ('defrost-status', 'Defrost Status', 'status', 'Indicates the evaporator is in defrost cycle', 'Bool', 'sensor', 'defrost status', NULL, 'Bool', 'Status'),
  ('defrost-command', 'Defrost Command', 'commands', 'Command to initiate evaporator defrost cycle — electric, hot gas, or off-cycle', 'Bool', 'cmd', 'defrost cmd', NULL, 'Bool', 'Command'),
  ('case-temperature', 'Case Temperature', 'temperatures', 'Temperature inside a refrigerated display case or walk-in box', 'Number', 'sensor', 'case temp sensor', '°F', 'Number', 'Temperature_Sensor'),
  ('suction-superheat', 'Suction Superheat', 'temperatures', 'Calculated superheat at compressor suction — suction temp minus saturation temp', 'Number', 'sensor', 'suction superheat sensor', '°F', 'Number', 'Temperature_Sensor');

-- ── Additional Metering / Misc (+10) ──────────────────────────────────────
INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('building-power-demand', 'Building Power Demand', 'electrical', 'Total building electrical power demand from main meter', 'Number', 'sensor', 'building elec demand power sensor', 'kW', 'Number', 'Peak_Power_Demand_Sensor'),
  ('peak-demand', 'Peak Demand', 'electrical', 'Peak electrical demand recorded over a billing period', 'Number', 'sensor', 'peak elec demand sensor', 'kW', 'Number', 'Peak_Power_Demand_Sensor'),
  ('natural-gas-consumption', 'Natural Gas Consumption', 'electrical', 'Accumulated natural gas consumption from building gas meter', 'Number', 'sensor', 'gas consumption sensor', 'therms', 'Number', 'Gas_Usage_Sensor'),
  ('water-consumption', 'Water Consumption', 'electrical', 'Accumulated domestic water consumption from building water meter', 'Number', 'sensor', 'water consumption sensor', 'gal', 'Number', 'Water_Usage_Sensor'),
  ('steam-consumption', 'Steam Consumption', 'electrical', 'Accumulated steam consumption from building steam meter', 'Number', 'sensor', 'steam consumption sensor', 'lb', 'Number', 'Steam_Usage_Sensor'),
  ('thermal-energy', 'Thermal Energy', 'electrical', 'Cumulative thermal energy measured by BTU meter', 'Number', 'sensor', 'thermal energy sensor', 'kBTU', 'Number', 'Thermal_Energy_Sensor'),
  ('elevator-run-status', 'Elevator Run Status', 'status', 'Operating status of an elevator — running, idle, or out of service', 'Bool', 'sensor', 'elevator run status', NULL, 'Bool', 'Status'),
  ('elevator-alarm', 'Elevator Alarm', 'alarms', 'General alarm from elevator controller — fault, entrapment, or maintenance required', 'Bool', 'alarm', 'elevator alarm', NULL, 'Bool', 'Fault_Status'),
  ('fire-suppression-status', 'Fire Suppression Status', 'status', 'Status of fire suppression system — normal, alarm, trouble, or supervisory', 'Bool', 'sensor', 'fire suppression status', NULL, 'Bool', 'Status'),
  ('escalator-run-status', 'Escalator Run Status', 'status', 'Operating status of an escalator — running, stopped, or fault', 'Bool', 'sensor', 'escalator run status', NULL, 'Bool', 'Status');

COMMIT;

BEGIN TRANSACTION;

-- ═══════════════════════════════════════════════════════════
-- EXTRA: Hit 100+ equipment and 500+ points
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO equipment (id, name, full_name, abbreviation, category, description, brick, haystack_tag_string, parent_id) VALUES
  ('smoke-control-panel', 'Smoke Control Panel', 'Smoke Control System Panel', 'SCP', 'life-safety', 'Dedicated panel that manages smoke control fans, dampers, and stairwell pressurization in response to fire alarm signals.', 'Panel', 'smoke control panel equip', NULL),
  ('domestic-water-booster-pump', 'Domestic Water Booster Pump', 'Domestic Water Booster Pump', 'DWBP', 'domestic-water', 'Pump that boosts domestic water pressure for upper floors of tall buildings.', 'Water_Pump', 'domestic water booster pump equip', NULL);

INSERT OR IGNORE INTO points (id, name, category, description, kind, point_function, haystack_tag_string, haystack_unit, haystack_kind, brick) VALUES
  ('outdoor-air-enthalpy-setpoint', 'OA Enthalpy Setpoint', 'setpoints', 'Outdoor air enthalpy limit for economizer enable/disable decisions', 'Number', 'sp', 'outside air enthalpy sp', 'BTU/lb', 'Number', 'Enthalpy_Setpoint'),
  ('boiler-firing-rate', 'Boiler Firing Rate', 'commands', 'Modulating firing rate output to boiler burner — percentage of full fire', 'Number', 'cmd', 'boiler firing rate cmd', '%', 'Number', 'Command'),
  ('cooling-tower-fan-vfd-speed', 'Cooling Tower Fan VFD Speed', 'fans', 'Current VFD speed of cooling tower fan as percentage', 'Number', 'sensor', 'cooling tower fan vfd speed sensor', '%', 'Number', 'Speed_Sensor'),
  ('domestic-water-temperature', 'Domestic Water Temperature', 'temperatures', 'Temperature of incoming domestic cold water supply to the building', 'Number', 'sensor', 'domestic water temp sensor', '°F', 'Number', 'Water_Temperature_Sensor'),
  ('zone-co2-setpoint', 'Zone CO2 Setpoint', 'setpoints', 'CO2 concentration setpoint for demand control ventilation in occupied zones', 'Number', 'sp', 'zone co2 sp', 'ppm', 'Number', 'CO2_Setpoint'),
  ('chiller-entering-condenser-water-temperature', 'Chiller Entering CW Temperature', 'temperatures', 'Condenser water temperature entering the chiller condenser', 'Number', 'sensor', 'chiller entering condenser water temp sensor', '°F', 'Number', 'Entering_Water_Temperature_Sensor'),
  ('chiller-leaving-condenser-water-temperature', 'Chiller Leaving CW Temperature', 'temperatures', 'Condenser water temperature leaving the chiller condenser', 'Number', 'sensor', 'chiller leaving condenser water temp sensor', '°F', 'Number', 'Leaving_Water_Temperature_Sensor');

-- ═══════════════════════════════════════════════════════════
-- PHASE 5: EQUIPMENT ↔ POINT LINKS (typical_points)
-- Target: 8+ per equipment type
-- ═══════════════════════════════════════════════════════════

-- Air Handling Unit (already 22, add a few key ones)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('air-handling-unit', 'outdoor-air-damper-command'),
  ('air-handling-unit', 'return-air-damper-command'),
  ('air-handling-unit', 'bypass-damper-position'),
  ('air-handling-unit', 'preheat-leaving-temperature'),
  ('air-handling-unit', 'preheat-valve-position'),
  ('air-handling-unit', 'economizer-status'),
  ('air-handling-unit', 'freeze-stat-status'),
  ('air-handling-unit', 'supply-fan-vfd-speed'),
  ('air-handling-unit', 'return-fan-vfd-speed'),
  ('air-handling-unit', 'outdoor-air-enthalpy'),
  ('air-handling-unit', 'chilled-water-valve-position'),
  ('air-handling-unit', 'morning-warmup-status'),
  ('air-handling-unit', 'supply-air-humidity');

-- Rooftop Unit (already 17, add more)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('rooftop-unit', 'economizer-status'),
  ('rooftop-unit', 'freeze-stat-status'),
  ('rooftop-unit', 'supply-fan-vfd-speed'),
  ('rooftop-unit', 'outdoor-air-damper-command'),
  ('rooftop-unit', 'compressor-status'),
  ('rooftop-unit', 'compressor-command'),
  ('rooftop-unit', 'morning-warmup-status'),
  ('rooftop-unit', 'outdoor-air-enthalpy');

-- Cooling Tower (already 13, add more)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('cooling-tower', 'cooling-tower-fan-command'),
  ('cooling-tower', 'cooling-tower-fan-status'),
  ('cooling-tower', 'cooling-tower-fan-speed'),
  ('cooling-tower', 'cooling-tower-water-flow'),
  ('cooling-tower', 'makeup-water-flow'),
  ('cooling-tower', 'blowdown-flow'),
  ('cooling-tower', 'condenser-approach-temperature'),
  ('cooling-tower', 'vibration-alarm');

-- DOAS (already 10, add more)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('dedicated-outdoor-air-system', 'supply-air-humidity'),
  ('dedicated-outdoor-air-system', 'outdoor-air-humidity'),
  ('dedicated-outdoor-air-system', 'supply-air-dewpoint'),
  ('dedicated-outdoor-air-system', 'preheat-leaving-temperature'),
  ('dedicated-outdoor-air-system', 'freeze-stat-status'),
  ('dedicated-outdoor-air-system', 'supply-fan-vfd-speed');

-- Pump (already 10, add more)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('pump', 'vfd-speed-command'),
  ('pump', 'vfd-status'),
  ('pump', 'supply-fan-vfd-speed'),
  ('pump', 'proof-of-flow'),
  ('pump', 'motor-current-percentage'),
  ('pump', 'vibration-alarm');

-- Boiler (already 9, add more)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('boiler', 'boiler-firing-rate'),
  ('boiler', 'flue-gas-temperature'),
  ('boiler', 'boiler-pressure'),
  ('boiler', 'proof-of-flow'),
  ('boiler', 'hot-water-delta-t');

-- Chiller (already 9, add more)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('chiller', 'compressor-status'),
  ('chiller', 'compressor-command'),
  ('chiller', 'chiller-cop'),
  ('chiller', 'chiller-kw-per-ton'),
  ('chiller', 'refrigerant-suction-pressure'),
  ('chiller', 'refrigerant-discharge-pressure'),
  ('chiller', 'chilled-water-delta-t'),
  ('chiller', 'evaporator-approach-temperature'),
  ('chiller', 'condenser-approach-temperature'),
  ('chiller', 'chiller-entering-condenser-water-temperature'),
  ('chiller', 'chiller-leaving-condenser-water-temperature'),
  ('chiller', 'energy-consumption-kwh');

-- Makeup Air Unit (already 9, add more)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('makeup-air-unit', 'supply-fan-vfd-speed'),
  ('makeup-air-unit', 'freeze-stat-status'),
  ('makeup-air-unit', 'preheat-leaving-temperature'),
  ('makeup-air-unit', 'outdoor-air-damper-command');

-- ERV (already 8, add more)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('energy-recovery-ventilator', 'supply-air-humidity'),
  ('energy-recovery-ventilator', 'outdoor-air-humidity'),
  ('energy-recovery-ventilator', 'supply-fan-vfd-speed'),
  ('energy-recovery-ventilator', 'freeze-stat-status');

-- Fan Coil Unit (already 8, add more)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('fan-coil-unit', 'chilled-water-valve-position'),
  ('fan-coil-unit', 'hot-water-valve-position'),
  ('fan-coil-unit', 'supply-fan-status'),
  ('fan-coil-unit', 'supply-fan-command');

-- Electric Meter (already 8, add more)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('electric-meter', 'voltage-phase-a'),
  ('electric-meter', 'voltage-phase-b'),
  ('electric-meter', 'voltage-phase-c'),
  ('electric-meter', 'current-phase-a'),
  ('electric-meter', 'current-phase-b'),
  ('electric-meter', 'current-phase-c'),
  ('electric-meter', 'total-harmonic-distortion'),
  ('electric-meter', 'demand-power');

-- Parallel FPB (already 8, add more)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('parallel-fan-powered-box', 'supply-airflow-setpoint'),
  ('parallel-fan-powered-box', 'minimum-airflow-setpoint'),
  ('parallel-fan-powered-box', 'reheat-valve-position'),
  ('parallel-fan-powered-box', 'reheat-discharge-temperature');

-- Series FPB (already 8, add more)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('series-fan-powered-box', 'supply-airflow-setpoint'),
  ('series-fan-powered-box', 'minimum-airflow-setpoint'),
  ('series-fan-powered-box', 'reheat-valve-position'),
  ('series-fan-powered-box', 'reheat-discharge-temperature');

-- Air Source Heat Pump (7→12+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('air-source-heat-pump', 'compressor-status'),
  ('air-source-heat-pump', 'compressor-command'),
  ('air-source-heat-pump', 'vfd-speed-command'),
  ('air-source-heat-pump', 'defrost-status'),
  ('air-source-heat-pump', 'refrigerant-suction-pressure');

-- Air Turnover Unit (7→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('air-turnover-unit', 'supply-fan-vfd-speed'),
  ('air-turnover-unit', 'supply-fan-command'),
  ('air-turnover-unit', 'supply-fan-status');

-- CRAC (7→12+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('computer-room-air-conditioner', 'compressor-status'),
  ('computer-room-air-conditioner', 'compressor-command'),
  ('computer-room-air-conditioner', 'supply-air-humidity'),
  ('computer-room-air-conditioner', 'supply-fan-vfd-speed'),
  ('computer-room-air-conditioner', 'refrigerant-suction-pressure');

-- CRAH (7→12+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('computer-room-air-handler', 'chilled-water-valve-position'),
  ('computer-room-air-handler', 'supply-air-humidity'),
  ('computer-room-air-handler', 'supply-fan-vfd-speed'),
  ('computer-room-air-handler', 'supply-fan-status'),
  ('computer-room-air-handler', 'supply-fan-command');

-- HRV (7→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('heat-recovery-ventilator', 'supply-fan-vfd-speed'),
  ('heat-recovery-ventilator', 'freeze-stat-status'),
  ('heat-recovery-ventilator', 'supply-air-humidity');

-- Unit Ventilator (7→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('unit-ventilator', 'outdoor-air-damper-command'),
  ('unit-ventilator', 'supply-fan-status'),
  ('unit-ventilator', 'supply-fan-command');

-- PTAC (6→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('packaged-terminal-air-conditioner', 'compressor-status'),
  ('packaged-terminal-air-conditioner', 'compressor-command'),
  ('packaged-terminal-air-conditioner', 'supply-fan-status'),
  ('packaged-terminal-air-conditioner', 'supply-fan-command');

-- PTHP (6→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('packaged-terminal-heat-pump', 'compressor-status'),
  ('packaged-terminal-heat-pump', 'compressor-command'),
  ('packaged-terminal-heat-pump', 'supply-fan-status'),
  ('packaged-terminal-heat-pump', 'supply-fan-command');

-- Blower Coil Unit (6→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('blower-coil-unit', 'chilled-water-valve-position'),
  ('blower-coil-unit', 'hot-water-valve-position'),
  ('blower-coil-unit', 'supply-fan-status'),
  ('blower-coil-unit', 'supply-fan-command');

-- Unit Heater (6→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('unit-heater', 'supply-fan-status'),
  ('unit-heater', 'supply-fan-command'),
  ('unit-heater', 'hot-water-valve-position'),
  ('unit-heater', 'hot-water-valve-command');

-- VAV Box (6→14+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('variable-air-volume-box', 'supply-airflow-setpoint'),
  ('variable-air-volume-box', 'minimum-airflow-setpoint'),
  ('variable-air-volume-box', 'maximum-airflow-setpoint'),
  ('variable-air-volume-box', 'reheat-valve-position'),
  ('variable-air-volume-box', 'reheat-valve-command'),
  ('variable-air-volume-box', 'reheat-discharge-temperature'),
  ('variable-air-volume-box', 'supply-air-flow'),
  ('variable-air-volume-box', 'occupancy');

-- VRF Indoor Unit (6→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('vrf-indoor-unit', 'compressor-status'),
  ('vrf-indoor-unit', 'supply-fan-status'),
  ('vrf-indoor-unit', 'supply-fan-command'),
  ('vrf-indoor-unit', 'supply-fan-speed');

-- Constant Air Volume Box (5→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('constant-air-volume-box', 'supply-fan-status'),
  ('constant-air-volume-box', 'supply-fan-command'),
  ('constant-air-volume-box', 'reheat-valve-position'),
  ('constant-air-volume-box', 'reheat-valve-command'),
  ('constant-air-volume-box', 'reheat-discharge-temperature');

-- Exhaust Fan (5→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('exhaust-fan', 'exhaust-fan-vfd-speed'),
  ('exhaust-fan', 'vfd-speed-command'),
  ('exhaust-fan', 'proof-of-airflow'),
  ('exhaust-fan', 'motor-current-percentage'),
  ('exhaust-fan', 'vibration-alarm');

-- Generator (5→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('generator', 'generator-run-status'),
  ('generator', 'generator-alarm'),
  ('generator', 'voltage-phase-a'),
  ('generator', 'current-phase-a'),
  ('generator', 'energy-consumption-kwh');

-- Humidifier (5→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('humidifier', 'humidifier-command'),
  ('humidifier', 'humidifier-run-status'),
  ('humidifier', 'supply-air-humidity'),
  ('humidifier', 'zone-humidity'),
  ('humidifier', 'zone-humidity-setpoint');

-- Radiant Panel (5→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('radiant-panel', 'hot-water-valve-position'),
  ('radiant-panel', 'hot-water-valve-command'),
  ('radiant-panel', 'chilled-water-valve-position'),
  ('radiant-panel', 'radiant-panel-surface-temperature'),
  ('radiant-panel', 'proof-of-flow');

-- Water Source Heat Pump (4→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('water-source-heat-pump', 'compressor-status'),
  ('water-source-heat-pump', 'compressor-command'),
  ('water-source-heat-pump', 'supply-fan-status'),
  ('water-source-heat-pump', 'supply-fan-command'),
  ('water-source-heat-pump', 'chilled-water-valve-position'),
  ('water-source-heat-pump', 'hot-water-valve-position');

-- Induction Unit (4→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('induction-unit', 'chilled-water-valve-position'),
  ('induction-unit', 'hot-water-valve-position'),
  ('induction-unit', 'chilled-water-valve-command'),
  ('induction-unit', 'hot-water-valve-command'),
  ('induction-unit', 'supply-air-flow'),
  ('induction-unit', 'occupancy');

-- Baseboard Heater (3→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('baseboard-heater', 'hot-water-valve-position'),
  ('baseboard-heater', 'hot-water-valve-command'),
  ('baseboard-heater', 'zone-temperature'),
  ('baseboard-heater', 'zone-temperature-setpoint'),
  ('baseboard-heater', 'occupancy');

-- Chilled Beam (3→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('chilled-beam', 'chilled-water-valve-position'),
  ('chilled-beam', 'chilled-water-valve-command'),
  ('chilled-beam', 'hot-water-valve-position'),
  ('chilled-beam', 'hot-water-valve-command'),
  ('chilled-beam', 'zone-temperature'),
  ('chilled-beam', 'zone-temperature-setpoint'),
  ('chilled-beam', 'occupancy');

-- Dehumidifier (3→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('dehumidifier', 'dehumidifier-command'),
  ('dehumidifier', 'dehumidifier-status'),
  ('dehumidifier', 'dehumidifier-output'),
  ('dehumidifier', 'zone-humidity'),
  ('dehumidifier', 'zone-humidity-setpoint');

-- Domestic Water Recirc Pump (3→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('domestic-water-recirculation-pump', 'domestic-hot-water-supply-temperature'),
  ('domestic-water-recirculation-pump', 'domestic-hot-water-return-temperature'),
  ('domestic-water-recirculation-pump', 'proof-of-flow'),
  ('domestic-water-recirculation-pump', 'equipment-run-hours'),
  ('domestic-water-recirculation-pump', 'communication-loss-alarm');

-- Fire Alarm Control Panel (3→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('fire-alarm-control-panel', 'fire-mode-status'),
  ('fire-alarm-control-panel', 'smoke-control-status'),
  ('fire-alarm-control-panel', 'communication-loss-alarm'),
  ('fire-alarm-control-panel', 'power-failure-alarm'),
  ('fire-alarm-control-panel', 'alarm-active-status');

-- Transfer Fan (3→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('transfer-fan', 'supply-fan-status'),
  ('transfer-fan', 'supply-fan-command'),
  ('transfer-fan', 'proof-of-airflow'),
  ('transfer-fan', 'space-pressure'),
  ('transfer-fan', 'equipment-run-hours');

-- UPS (3→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('uninterruptible-power-supply', 'ups-status'),
  ('uninterruptible-power-supply', 'ups-alarm'),
  ('uninterruptible-power-supply', 'voltage-phase-a'),
  ('uninterruptible-power-supply', 'current-phase-a'),
  ('uninterruptible-power-supply', 'power-failure-alarm');

-- VFD (3→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('variable-frequency-drive', 'vfd-speed-command'),
  ('variable-frequency-drive', 'vfd-status'),
  ('variable-frequency-drive', 'vfd-fault-alarm'),
  ('variable-frequency-drive', 'motor-current-percentage'),
  ('variable-frequency-drive', 'energy-consumption-kwh'),
  ('variable-frequency-drive', 'equipment-run-hours'),
  ('variable-frequency-drive', 'supply-fan-vfd-speed');

-- Domestic Water Heater (2→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('domestic-water-heater', 'domestic-hot-water-supply-temperature'),
  ('domestic-water-heater', 'domestic-hot-water-return-temperature'),
  ('domestic-water-heater', 'domestic-water-temperature'),
  ('domestic-water-heater', 'domestic-hot-water-flow'),
  ('domestic-water-heater', 'system-enable'),
  ('domestic-water-heater', 'communication-loss-alarm');

-- ATS (2→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('automatic-transfer-switch', 'emergency-power-status'),
  ('automatic-transfer-switch', 'power-failure-alarm'),
  ('automatic-transfer-switch', 'voltage-phase-a'),
  ('automatic-transfer-switch', 'current-phase-a'),
  ('automatic-transfer-switch', 'generator-run-status'),
  ('automatic-transfer-switch', 'alarm-active-status');

-- Ductless Mini Split (2→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('ductless-mini-split', 'zone-temperature'),
  ('ductless-mini-split', 'zone-temperature-setpoint'),
  ('ductless-mini-split', 'compressor-status'),
  ('ductless-mini-split', 'compressor-command'),
  ('ductless-mini-split', 'supply-fan-status'),
  ('ductless-mini-split', 'supply-fan-command');

-- Heat Exchanger (2→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('heat-exchanger', 'heat-exchanger-leaving-temperature'),
  ('heat-exchanger', 'chilled-water-valve-position'),
  ('heat-exchanger', 'hot-water-valve-position'),
  ('heat-exchanger', 'proof-of-flow'),
  ('heat-exchanger', 'chilled-water-delta-t'),
  ('heat-exchanger', 'hot-water-delta-t');

-- Steam-to-HW Converter (2→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('steam-to-hot-water-converter', 'hot-water-supply-temperature'),
  ('steam-to-hot-water-converter', 'hot-water-return-temperature'),
  ('steam-to-hot-water-converter', 'steam-valve-position'),
  ('steam-to-hot-water-converter', 'steam-valve-command'),
  ('steam-to-hot-water-converter', 'steam-pressure'),
  ('steam-to-hot-water-converter', 'proof-of-flow');

-- Condensing Unit (1→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('condensing-unit', 'compressor-status'),
  ('condensing-unit', 'compressor-command'),
  ('condensing-unit', 'refrigerant-suction-pressure'),
  ('condensing-unit', 'refrigerant-discharge-pressure'),
  ('condensing-unit', 'condenser-temperature'),
  ('condensing-unit', 'head-pressure'),
  ('condensing-unit', 'discharge-air-temperature');

-- Smoke Detector (1→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('smoke-detector', 'smoke-alarm'),
  ('smoke-detector', 'fire-alarm-status'),
  ('smoke-detector', 'communication-loss-alarm'),
  ('smoke-detector', 'sensor-fault-alarm'),
  ('smoke-detector', 'alarm-active-status'),
  ('smoke-detector', 'fire-mode-status'),
  ('smoke-detector', 'fire-damper-status');

-- Steam Meter (1→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('steam-meter', 'steam-flow'),
  ('steam-meter', 'steam-pressure'),
  ('steam-meter', 'steam-temperature'),
  ('steam-meter', 'steam-consumption'),
  ('steam-meter', 'energy-consumption-kwh'),
  ('steam-meter', 'communication-loss-alarm'),
  ('steam-meter', 'sensor-fault-alarm');

-- VRF Outdoor Unit (1→10+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('vrf-outdoor-unit', 'compressor-status'),
  ('vrf-outdoor-unit', 'compressor-command'),
  ('vrf-outdoor-unit', 'compressor-stage'),
  ('vrf-outdoor-unit', 'outdoor-air-temperature'),
  ('vrf-outdoor-unit', 'refrigerant-suction-pressure'),
  ('vrf-outdoor-unit', 'refrigerant-discharge-pressure'),
  ('vrf-outdoor-unit', 'defrost-status'),
  ('vrf-outdoor-unit', 'energy-consumption-kwh'),
  ('vrf-outdoor-unit', 'communication-loss-alarm');

-- VRF Branch Selector Box (0→8+)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('vrf-branch-selector-box', 'zone-temperature'),
  ('vrf-branch-selector-box', 'zone-temperature-setpoint'),
  ('vrf-branch-selector-box', 'supply-fan-status'),
  ('vrf-branch-selector-box', 'supply-fan-command'),
  ('vrf-branch-selector-box', 'cooling-valve-output'),
  ('vrf-branch-selector-box', 'heating-valve-output'),
  ('vrf-branch-selector-box', 'occupancy'),
  ('vrf-branch-selector-box', 'communication-loss-alarm');

-- Equipment with 0 points — all new equipment types

-- Clean Room AHU
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('clean-room-ahu', 'supply-air-temperature'),
  ('clean-room-ahu', 'discharge-air-temperature'),
  ('clean-room-ahu', 'discharge-air-temperature-setpoint'),
  ('clean-room-ahu', 'supply-fan-status'),
  ('clean-room-ahu', 'supply-fan-command'),
  ('clean-room-ahu', 'supply-fan-vfd-speed'),
  ('clean-room-ahu', 'duct-static-pressure'),
  ('clean-room-ahu', 'filter-differential-pressure'),
  ('clean-room-ahu', 'supply-air-humidity'),
  ('clean-room-ahu', 'zone-humidity'),
  ('clean-room-ahu', 'chilled-water-valve-position'),
  ('clean-room-ahu', 'space-pressure');

-- Data Center Cooling
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('data-center-cooling', 'supply-air-temperature'),
  ('data-center-cooling', 'return-air-temperature'),
  ('data-center-cooling', 'discharge-air-temperature-setpoint'),
  ('data-center-cooling', 'supply-fan-status'),
  ('data-center-cooling', 'supply-fan-command'),
  ('data-center-cooling', 'supply-fan-vfd-speed'),
  ('data-center-cooling', 'supply-air-humidity'),
  ('data-center-cooling', 'server-inlet-temperature'),
  ('data-center-cooling', 'server-outlet-temperature'),
  ('data-center-cooling', 'chilled-water-valve-position'),
  ('data-center-cooling', 'compressor-status'),
  ('data-center-cooling', 'filter-differential-pressure');

-- Server Room Cooling
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('server-room-cooling', 'supply-air-temperature'),
  ('server-room-cooling', 'return-air-temperature'),
  ('server-room-cooling', 'discharge-air-temperature-setpoint'),
  ('server-room-cooling', 'supply-fan-status'),
  ('server-room-cooling', 'supply-air-humidity'),
  ('server-room-cooling', 'compressor-status'),
  ('server-room-cooling', 'compressor-command'),
  ('server-room-cooling', 'server-inlet-temperature'),
  ('server-room-cooling', 'filter-differential-pressure'),
  ('server-room-cooling', 'communication-loss-alarm');

-- Air Separator
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('air-separator', 'chilled-water-pressure'),
  ('air-separator', 'chilled-water-supply-temperature'),
  ('air-separator', 'chilled-water-return-temperature'),
  ('air-separator', 'proof-of-flow'),
  ('air-separator', 'chilled-water-differential-pressure'),
  ('air-separator', 'hot-water-supply-temperature'),
  ('air-separator', 'hot-water-return-temperature'),
  ('air-separator', 'communication-loss-alarm');

-- Chemical Treatment System
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('chemical-treatment-system', 'condenser-water-supply-temperature'),
  ('chemical-treatment-system', 'condenser-water-return-temperature'),
  ('chemical-treatment-system', 'blowdown-flow'),
  ('chemical-treatment-system', 'makeup-water-flow'),
  ('chemical-treatment-system', 'system-enable'),
  ('chemical-treatment-system', 'communication-loss-alarm'),
  ('chemical-treatment-system', 'alarm-active-status'),
  ('chemical-treatment-system', 'equipment-run-hours');

-- Water Treatment System
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('water-treatment-system', 'condenser-water-supply-temperature'),
  ('water-treatment-system', 'blowdown-flow'),
  ('water-treatment-system', 'makeup-water-flow'),
  ('water-treatment-system', 'system-enable'),
  ('water-treatment-system', 'communication-loss-alarm'),
  ('water-treatment-system', 'alarm-active-status'),
  ('water-treatment-system', 'cooling-tower-water-flow'),
  ('water-treatment-system', 'equipment-run-hours');

-- Glycol Feed System
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('glycol-feed-system', 'glycol-flow'),
  ('glycol-feed-system', 'chilled-water-supply-temperature'),
  ('glycol-feed-system', 'system-enable'),
  ('glycol-feed-system', 'communication-loss-alarm'),
  ('glycol-feed-system', 'alarm-active-status'),
  ('glycol-feed-system', 'proof-of-flow'),
  ('glycol-feed-system', 'equipment-run-hours'),
  ('glycol-feed-system', 'water-pressure');

-- Primary CHW Pump
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('primary-chilled-water-pump', 'primary-chilled-water-pump-status'),
  ('primary-chilled-water-pump', 'primary-chilled-water-pump-command'),
  ('primary-chilled-water-pump', 'primary-chilled-water-pump-alarm'),
  ('primary-chilled-water-pump', 'primary-chilled-water-flow'),
  ('primary-chilled-water-pump', 'chilled-water-differential-pressure'),
  ('primary-chilled-water-pump', 'vfd-speed-command'),
  ('primary-chilled-water-pump', 'vfd-status'),
  ('primary-chilled-water-pump', 'proof-of-flow'),
  ('primary-chilled-water-pump', 'motor-current-percentage'),
  ('primary-chilled-water-pump', 'equipment-run-hours');

-- Secondary CHW Pump
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('secondary-chilled-water-pump', 'secondary-chilled-water-pump-status'),
  ('secondary-chilled-water-pump', 'secondary-chilled-water-pump-command'),
  ('secondary-chilled-water-pump', 'secondary-chilled-water-pump-alarm'),
  ('secondary-chilled-water-pump', 'secondary-chilled-water-flow'),
  ('secondary-chilled-water-pump', 'chilled-water-differential-pressure'),
  ('secondary-chilled-water-pump', 'vfd-speed-command'),
  ('secondary-chilled-water-pump', 'vfd-status'),
  ('secondary-chilled-water-pump', 'proof-of-flow'),
  ('secondary-chilled-water-pump', 'motor-current-percentage'),
  ('secondary-chilled-water-pump', 'equipment-run-hours');

-- Condenser Water Pump
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('condenser-water-pump', 'condenser-water-pump-status'),
  ('condenser-water-pump', 'condenser-water-pump-command'),
  ('condenser-water-pump', 'condenser-water-pump-alarm'),
  ('condenser-water-pump', 'condenser-water-flow'),
  ('condenser-water-pump', 'condenser-water-differential-pressure'),
  ('condenser-water-pump', 'vfd-speed-command'),
  ('condenser-water-pump', 'vfd-status'),
  ('condenser-water-pump', 'proof-of-flow'),
  ('condenser-water-pump', 'motor-current-percentage'),
  ('condenser-water-pump', 'equipment-run-hours');

-- Hot Water Pump
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('hot-water-pump', 'hot-water-pump-status'),
  ('hot-water-pump', 'hot-water-pump-command'),
  ('hot-water-pump', 'hot-water-pump-alarm'),
  ('hot-water-pump', 'hot-water-flow'),
  ('hot-water-pump', 'hot-water-differential-pressure'),
  ('hot-water-pump', 'vfd-speed-command'),
  ('hot-water-pump', 'vfd-status'),
  ('hot-water-pump', 'proof-of-flow'),
  ('hot-water-pump', 'motor-current-percentage'),
  ('hot-water-pump', 'equipment-run-hours');

-- Steam PRV
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('steam-pressure-reducing-valve', 'steam-pressure'),
  ('steam-pressure-reducing-valve', 'steam-temperature'),
  ('steam-pressure-reducing-valve', 'steam-valve-position'),
  ('steam-pressure-reducing-valve', 'steam-flow'),
  ('steam-pressure-reducing-valve', 'communication-loss-alarm'),
  ('steam-pressure-reducing-valve', 'alarm-active-status'),
  ('steam-pressure-reducing-valve', 'boiler-pressure'),
  ('steam-pressure-reducing-valve', 'sensor-fault-alarm');

-- Expansion Tank
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('expansion-tank', 'chilled-water-pressure'),
  ('expansion-tank', 'water-pressure'),
  ('expansion-tank', 'hot-water-supply-temperature'),
  ('expansion-tank', 'chilled-water-supply-temperature'),
  ('expansion-tank', 'communication-loss-alarm'),
  ('expansion-tank', 'alarm-active-status'),
  ('expansion-tank', 'sensor-fault-alarm'),
  ('expansion-tank', 'proof-of-flow');

-- Cabinet Unit Heater
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('cabinet-unit-heater', 'zone-temperature'),
  ('cabinet-unit-heater', 'zone-temperature-setpoint'),
  ('cabinet-unit-heater', 'hot-water-valve-position'),
  ('cabinet-unit-heater', 'hot-water-valve-command'),
  ('cabinet-unit-heater', 'supply-fan-status'),
  ('cabinet-unit-heater', 'supply-fan-command'),
  ('cabinet-unit-heater', 'occupancy'),
  ('cabinet-unit-heater', 'discharge-air-temperature');

-- Fin Tube Radiator
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('fin-tube-radiator', 'zone-temperature'),
  ('fin-tube-radiator', 'zone-temperature-setpoint'),
  ('fin-tube-radiator', 'hot-water-valve-position'),
  ('fin-tube-radiator', 'hot-water-valve-command'),
  ('fin-tube-radiator', 'occupancy'),
  ('fin-tube-radiator', 'hot-water-supply-temperature'),
  ('fin-tube-radiator', 'hot-water-return-temperature'),
  ('fin-tube-radiator', 'occupied-heating-setpoint');

-- Convector
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('convector', 'zone-temperature'),
  ('convector', 'zone-temperature-setpoint'),
  ('convector', 'hot-water-valve-position'),
  ('convector', 'hot-water-valve-command'),
  ('convector', 'occupancy'),
  ('convector', 'hot-water-supply-temperature'),
  ('convector', 'hot-water-return-temperature'),
  ('convector', 'occupied-heating-setpoint');

-- Radiant Floor
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('radiant-floor', 'zone-temperature'),
  ('radiant-floor', 'zone-temperature-setpoint'),
  ('radiant-floor', 'slab-temperature'),
  ('radiant-floor', 'hot-water-valve-position'),
  ('radiant-floor', 'hot-water-valve-command'),
  ('radiant-floor', 'hot-water-supply-temperature'),
  ('radiant-floor', 'hot-water-return-temperature'),
  ('radiant-floor', 'proof-of-flow'),
  ('radiant-floor', 'occupancy'),
  ('radiant-floor', 'mixing-valve-output');

-- Power Quality Meter
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('power-quality-meter', 'voltage-phase-a'),
  ('power-quality-meter', 'voltage-phase-b'),
  ('power-quality-meter', 'voltage-phase-c'),
  ('power-quality-meter', 'current-phase-a'),
  ('power-quality-meter', 'current-phase-b'),
  ('power-quality-meter', 'current-phase-c'),
  ('power-quality-meter', 'total-harmonic-distortion'),
  ('power-quality-meter', 'power-factor'),
  ('power-quality-meter', 'frequency-sensor'),
  ('power-quality-meter', 'line-to-line-voltage');

-- Demand Meter
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('demand-meter', 'demand-power'),
  ('demand-meter', 'peak-demand'),
  ('demand-meter', 'energy-consumption-kwh'),
  ('demand-meter', 'electrical-demand-kw'),
  ('demand-meter', 'power-factor'),
  ('demand-meter', 'voltage-phase-a'),
  ('demand-meter', 'current-phase-a'),
  ('demand-meter', 'communication-loss-alarm');

-- Flow Meter
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('flow-meter', 'chilled-water-flow'),
  ('flow-meter', 'hot-water-flow'),
  ('flow-meter', 'condenser-water-flow'),
  ('flow-meter', 'domestic-hot-water-flow'),
  ('flow-meter', 'communication-loss-alarm'),
  ('flow-meter', 'sensor-fault-alarm'),
  ('flow-meter', 'proof-of-flow'),
  ('flow-meter', 'water-pressure');

-- Thermal Energy Meter
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('thermal-energy-meter', 'thermal-energy'),
  ('thermal-energy-meter', 'chilled-water-flow'),
  ('thermal-energy-meter', 'chilled-water-supply-temperature'),
  ('thermal-energy-meter', 'chilled-water-return-temperature'),
  ('thermal-energy-meter', 'chilled-water-delta-t'),
  ('thermal-energy-meter', 'communication-loss-alarm'),
  ('thermal-energy-meter', 'sensor-fault-alarm'),
  ('thermal-energy-meter', 'hot-water-flow');

-- BTU Meter
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('btu-meter', 'thermal-energy'),
  ('btu-meter', 'chilled-water-flow'),
  ('btu-meter', 'chilled-water-supply-temperature'),
  ('btu-meter', 'chilled-water-return-temperature'),
  ('btu-meter', 'chilled-water-delta-t'),
  ('btu-meter', 'hot-water-flow'),
  ('btu-meter', 'hot-water-supply-temperature'),
  ('btu-meter', 'hot-water-return-temperature');

-- Natural Gas Meter
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('natural-gas-meter', 'gas-flow'),
  ('natural-gas-meter', 'natural-gas-consumption'),
  ('natural-gas-meter', 'gas-pressure'),
  ('natural-gas-meter', 'natural-gas-pressure'),
  ('natural-gas-meter', 'communication-loss-alarm'),
  ('natural-gas-meter', 'sensor-fault-alarm'),
  ('natural-gas-meter', 'energy-consumption-kwh'),
  ('natural-gas-meter', 'steam-temperature');

-- Water Meter
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('water-meter', 'water-consumption'),
  ('water-meter', 'water-pressure'),
  ('water-meter', 'domestic-hot-water-flow'),
  ('water-meter', 'makeup-water-flow'),
  ('water-meter', 'communication-loss-alarm'),
  ('water-meter', 'sensor-fault-alarm'),
  ('water-meter', 'domestic-water-temperature'),
  ('water-meter', 'proof-of-flow');

-- Relief Fan
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('relief-fan', 'relief-fan-status'),
  ('relief-fan', 'relief-fan-command'),
  ('relief-fan', 'relief-fan-speed'),
  ('relief-fan', 'relief-fan-alarm'),
  ('relief-fan', 'vfd-speed-command'),
  ('relief-fan', 'building-pressure'),
  ('relief-fan', 'proof-of-airflow'),
  ('relief-fan', 'motor-current-percentage');

-- Return Fan
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('return-fan', 'return-fan-status'),
  ('return-fan', 'return-fan-command'),
  ('return-fan', 'return-fan-speed'),
  ('return-fan', 'return-fan-alarm'),
  ('return-fan', 'return-fan-vfd-speed'),
  ('return-fan', 'vfd-speed-command'),
  ('return-fan', 'return-air-temperature'),
  ('return-fan', 'proof-of-airflow');

-- Supply Fan
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('supply-fan', 'supply-fan-status'),
  ('supply-fan', 'supply-fan-command'),
  ('supply-fan', 'supply-fan-speed'),
  ('supply-fan', 'supply-fan-alarm'),
  ('supply-fan', 'supply-fan-vfd-speed'),
  ('supply-fan', 'vfd-speed-command'),
  ('supply-fan', 'duct-static-pressure'),
  ('supply-fan', 'proof-of-airflow');

-- Kitchen Exhaust Fan
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('kitchen-exhaust-fan', 'kitchen-exhaust-fan-status'),
  ('kitchen-exhaust-fan', 'kitchen-exhaust-fan-command'),
  ('kitchen-exhaust-fan', 'exhaust-fan-speed'),
  ('kitchen-exhaust-fan', 'exhaust-fan-alarm'),
  ('kitchen-exhaust-fan', 'proof-of-airflow'),
  ('kitchen-exhaust-fan', 'fire-mode-status'),
  ('kitchen-exhaust-fan', 'exhaust-air-temperature'),
  ('kitchen-exhaust-fan', 'motor-current-percentage');

-- Garage Exhaust Fan
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('garage-exhaust-fan', 'garage-exhaust-fan-status'),
  ('garage-exhaust-fan', 'garage-exhaust-fan-command'),
  ('garage-exhaust-fan', 'co-level'),
  ('garage-exhaust-fan', 'exhaust-fan-speed'),
  ('garage-exhaust-fan', 'exhaust-fan-alarm'),
  ('garage-exhaust-fan', 'proof-of-airflow'),
  ('garage-exhaust-fan', 'vfd-speed-command'),
  ('garage-exhaust-fan', 'motor-current-percentage');

-- Building Controller
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('building-controller', 'outdoor-air-temperature'),
  ('building-controller', 'outdoor-air-humidity'),
  ('building-controller', 'system-enable'),
  ('building-controller', 'communication-loss-alarm'),
  ('building-controller', 'alarm-active-status'),
  ('building-controller', 'occupancy-schedule'),
  ('building-controller', 'effective-occupancy'),
  ('building-controller', 'demand-limit-command');

-- Area Controller
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('area-controller', 'zone-temperature'),
  ('area-controller', 'zone-temperature-setpoint'),
  ('area-controller', 'occupancy'),
  ('area-controller', 'system-enable'),
  ('area-controller', 'communication-loss-alarm'),
  ('area-controller', 'alarm-active-status'),
  ('area-controller', 'occupied-cooling-setpoint'),
  ('area-controller', 'occupied-heating-setpoint');

-- I/O Expansion Module
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('io-expansion-module', 'zone-temperature'),
  ('io-expansion-module', 'supply-air-temperature'),
  ('io-expansion-module', 'supply-fan-status'),
  ('io-expansion-module', 'communication-loss-alarm'),
  ('io-expansion-module', 'sensor-fault-alarm'),
  ('io-expansion-module', 'alarm-active-status'),
  ('io-expansion-module', 'system-enable'),
  ('io-expansion-module', 'voltage-sensor');

-- Weather Station
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('weather-station', 'outdoor-air-temperature'),
  ('weather-station', 'outdoor-air-humidity'),
  ('weather-station', 'wet-bulb-temperature'),
  ('weather-station', 'outdoor-air-enthalpy'),
  ('weather-station', 'building-pressure'),
  ('weather-station', 'daylight-illuminance'),
  ('weather-station', 'communication-loss-alarm'),
  ('weather-station', 'sensor-fault-alarm');

-- Light Level Sensor
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('light-level-sensor', 'daylight-illuminance'),
  ('light-level-sensor', 'task-lighting-level'),
  ('light-level-sensor', 'ambient-lighting-level'),
  ('light-level-sensor', 'lighting-dimming-output'),
  ('light-level-sensor', 'lighting-status'),
  ('light-level-sensor', 'communication-loss-alarm'),
  ('light-level-sensor', 'sensor-fault-alarm'),
  ('light-level-sensor', 'lighting-command');

-- Refrigerant Leak Detector
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('refrigerant-leak-detector', 'refrigerant-leak-alarm'),
  ('refrigerant-leak-detector', 'communication-loss-alarm'),
  ('refrigerant-leak-detector', 'sensor-fault-alarm'),
  ('refrigerant-leak-detector', 'alarm-active-status'),
  ('refrigerant-leak-detector', 'exhaust-fan-command'),
  ('refrigerant-leak-detector', 'exhaust-fan-status'),
  ('refrigerant-leak-detector', 'fire-mode-status'),
  ('refrigerant-leak-detector', 'system-enable');

-- Water Leak Detector
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('water-leak-detector', 'water-leak-alarm'),
  ('water-leak-detector', 'communication-loss-alarm'),
  ('water-leak-detector', 'sensor-fault-alarm'),
  ('water-leak-detector', 'alarm-active-status'),
  ('water-leak-detector', 'equipment-isolation-command'),
  ('water-leak-detector', 'isolation-valve-closed'),
  ('water-leak-detector', 'isolation-valve-output'),
  ('water-leak-detector', 'system-enable');

-- Vibration Sensor
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('vibration-sensor', 'vibration-alarm'),
  ('vibration-sensor', 'communication-loss-alarm'),
  ('vibration-sensor', 'sensor-fault-alarm'),
  ('vibration-sensor', 'alarm-active-status'),
  ('vibration-sensor', 'equipment-run-hours'),
  ('vibration-sensor', 'motor-current-percentage'),
  ('vibration-sensor', 'supply-fan-status'),
  ('vibration-sensor', 'system-enable');

-- Lighting Control Panel
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('lighting-control-panel', 'lighting-status'),
  ('lighting-control-panel', 'lighting-command'),
  ('lighting-control-panel', 'lighting-dimming-output'),
  ('lighting-control-panel', 'lighting-schedule'),
  ('lighting-control-panel', 'lighting-power-consumption'),
  ('lighting-control-panel', 'occupancy'),
  ('lighting-control-panel', 'daylight-illuminance'),
  ('lighting-control-panel', 'lighting-scene-command'),
  ('lighting-control-panel', 'communication-loss-alarm');

-- Dimmer Module
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('dimmer-module', 'lighting-dimming-output'),
  ('dimmer-module', 'dimming-level-command'),
  ('dimmer-module', 'lighting-status'),
  ('dimmer-module', 'lighting-command'),
  ('dimmer-module', 'lighting-power-consumption'),
  ('dimmer-module', 'daylight-illuminance'),
  ('dimmer-module', 'occupancy'),
  ('dimmer-module', 'communication-loss-alarm');

-- Daylight Sensor
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('daylight-sensor', 'daylight-illuminance'),
  ('daylight-sensor', 'lighting-dimming-output'),
  ('daylight-sensor', 'ambient-lighting-level'),
  ('daylight-sensor', 'lighting-status'),
  ('daylight-sensor', 'lighting-command'),
  ('daylight-sensor', 'communication-loss-alarm'),
  ('daylight-sensor', 'sensor-fault-alarm'),
  ('daylight-sensor', 'lighting-power-consumption');

-- Lighting Relay Panel
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('lighting-relay-panel', 'lighting-status'),
  ('lighting-relay-panel', 'lighting-command'),
  ('lighting-relay-panel', 'lighting-schedule'),
  ('lighting-relay-panel', 'lighting-power-consumption'),
  ('lighting-relay-panel', 'occupancy'),
  ('lighting-relay-panel', 'exterior-lighting-command'),
  ('lighting-relay-panel', 'exterior-lighting-status'),
  ('lighting-relay-panel', 'communication-loss-alarm');

-- Occupancy Lighting Controller
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('occupancy-lighting-controller', 'lighting-occupancy-sensor'),
  ('occupancy-lighting-controller', 'lighting-status'),
  ('occupancy-lighting-controller', 'lighting-command'),
  ('occupancy-lighting-controller', 'lighting-dimming-output'),
  ('occupancy-lighting-controller', 'occupancy'),
  ('occupancy-lighting-controller', 'daylight-illuminance'),
  ('occupancy-lighting-controller', 'lighting-schedule'),
  ('occupancy-lighting-controller', 'communication-loss-alarm');

-- Walk-In Cooler
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('walk-in-cooler', 'case-temperature'),
  ('walk-in-cooler', 'zone-temperature-setpoint'),
  ('walk-in-cooler', 'compressor-status'),
  ('walk-in-cooler', 'defrost-status'),
  ('walk-in-cooler', 'defrost-command'),
  ('walk-in-cooler', 'evaporator-temperature'),
  ('walk-in-cooler', 'high-zone-temperature-alarm'),
  ('walk-in-cooler', 'communication-loss-alarm'),
  ('walk-in-cooler', 'equipment-run-hours');

-- Walk-In Freezer
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('walk-in-freezer', 'case-temperature'),
  ('walk-in-freezer', 'zone-temperature-setpoint'),
  ('walk-in-freezer', 'compressor-status'),
  ('walk-in-freezer', 'defrost-status'),
  ('walk-in-freezer', 'defrost-command'),
  ('walk-in-freezer', 'evaporator-temperature'),
  ('walk-in-freezer', 'high-zone-temperature-alarm'),
  ('walk-in-freezer', 'communication-loss-alarm'),
  ('walk-in-freezer', 'equipment-run-hours');

-- Reach-In Refrigerator
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('reach-in-refrigerator', 'case-temperature'),
  ('reach-in-refrigerator', 'zone-temperature-setpoint'),
  ('reach-in-refrigerator', 'compressor-status'),
  ('reach-in-refrigerator', 'defrost-status'),
  ('reach-in-refrigerator', 'high-zone-temperature-alarm'),
  ('reach-in-refrigerator', 'communication-loss-alarm'),
  ('reach-in-refrigerator', 'equipment-run-hours'),
  ('reach-in-refrigerator', 'evaporator-temperature');

-- Condensing Unit (Refrigeration)
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('condensing-unit-refrigeration', 'compressor-status'),
  ('condensing-unit-refrigeration', 'compressor-command'),
  ('condensing-unit-refrigeration', 'condenser-temperature'),
  ('condensing-unit-refrigeration', 'head-pressure'),
  ('condensing-unit-refrigeration', 'suction-pressure'),
  ('condensing-unit-refrigeration', 'refrigerant-discharge-temperature'),
  ('condensing-unit-refrigeration', 'refrigerant-suction-temperature'),
  ('condensing-unit-refrigeration', 'compressor-discharge-temperature'),
  ('condensing-unit-refrigeration', 'high-condenser-pressure-alarm'),
  ('condensing-unit-refrigeration', 'low-suction-pressure-alarm');

-- Refrigeration Rack
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('refrigeration-rack', 'compressor-status'),
  ('refrigeration-rack', 'compressor-command'),
  ('refrigeration-rack', 'compressor-stage'),
  ('refrigeration-rack', 'suction-pressure'),
  ('refrigeration-rack', 'head-pressure'),
  ('refrigeration-rack', 'refrigerant-suction-temperature'),
  ('refrigeration-rack', 'refrigerant-discharge-temperature'),
  ('refrigeration-rack', 'compressor-discharge-temperature'),
  ('refrigeration-rack', 'oil-pressure'),
  ('refrigeration-rack', 'superheat-temperature'),
  ('refrigeration-rack', 'defrost-status'),
  ('refrigeration-rack', 'energy-consumption-kwh');

-- Elevator
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('elevator', 'elevator-run-status'),
  ('elevator', 'elevator-alarm'),
  ('elevator', 'fire-mode-status'),
  ('elevator', 'energy-consumption-kwh'),
  ('elevator', 'equipment-run-hours'),
  ('elevator', 'equipment-start-count'),
  ('elevator', 'communication-loss-alarm'),
  ('elevator', 'power-failure-alarm');

-- Escalator
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('escalator', 'escalator-run-status'),
  ('escalator', 'energy-consumption-kwh'),
  ('escalator', 'equipment-run-hours'),
  ('escalator', 'motor-current-percentage'),
  ('escalator', 'communication-loss-alarm'),
  ('escalator', 'vibration-alarm'),
  ('escalator', 'alarm-active-status'),
  ('escalator', 'system-enable');

-- Smoke Control Panel
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('smoke-control-panel', 'smoke-control-status'),
  ('smoke-control-panel', 'smoke-control-command'),
  ('smoke-control-panel', 'fire-mode-status'),
  ('smoke-control-panel', 'fire-alarm-status'),
  ('smoke-control-panel', 'smoke-alarm'),
  ('smoke-control-panel', 'communication-loss-alarm'),
  ('smoke-control-panel', 'alarm-active-status'),
  ('smoke-control-panel', 'power-failure-alarm');

-- Domestic Water Booster Pump
INSERT OR IGNORE INTO equipment_typical_points (equipment_id, point_id) VALUES
  ('domestic-water-booster-pump', 'water-pressure'),
  ('domestic-water-booster-pump', 'domestic-water-temperature'),
  ('domestic-water-booster-pump', 'proof-of-flow'),
  ('domestic-water-booster-pump', 'vfd-speed-command'),
  ('domestic-water-booster-pump', 'vfd-status'),
  ('domestic-water-booster-pump', 'motor-current-percentage'),
  ('domestic-water-booster-pump', 'equipment-run-hours'),
  ('domestic-water-booster-pump', 'communication-loss-alarm');

COMMIT;

BEGIN TRANSACTION;

-- ═══════════════════════════════════════════════════════════
-- PHASE 4a: POINT UNITS (for new Number points)
-- ═══════════════════════════════════════════════════════════

-- Temperature points → °F, °C
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('preheat-leaving-temperature', '°F'), ('preheat-leaving-temperature', '°C'),
  ('reheat-discharge-temperature', '°F'), ('reheat-discharge-temperature', '°C'),
  ('flue-gas-temperature', '°F'), ('flue-gas-temperature', '°C'),
  ('refrigerant-suction-temperature', '°F'), ('refrigerant-suction-temperature', '°C'),
  ('refrigerant-discharge-temperature', '°F'), ('refrigerant-discharge-temperature', '°C'),
  ('ground-water-temperature', '°F'), ('ground-water-temperature', '°C'),
  ('steam-temperature', '°F'), ('steam-temperature', '°C'),
  ('radiant-panel-surface-temperature', '°F'), ('radiant-panel-surface-temperature', '°C'),
  ('ceiling-plenum-temperature', '°F'), ('ceiling-plenum-temperature', '°C'),
  ('slab-temperature', '°F'), ('slab-temperature', '°C'),
  ('server-inlet-temperature', '°F'), ('server-inlet-temperature', '°C'),
  ('server-outlet-temperature', '°F'), ('server-outlet-temperature', '°C'),
  ('heat-exchanger-leaving-temperature', '°F'), ('heat-exchanger-leaving-temperature', '°C'),
  ('outdoor-air-temperature-setpoint', '°F'), ('outdoor-air-temperature-setpoint', '°C'),
  ('subcooling-temperature', '°F'), ('subcooling-temperature', '°C'),
  ('compressor-discharge-temperature', '°F'), ('compressor-discharge-temperature', '°C'),
  ('compressor-suction-temperature', '°F'), ('compressor-suction-temperature', '°C'),
  ('evaporator-temperature', '°F'), ('evaporator-temperature', '°C'),
  ('condenser-temperature', '°F'), ('condenser-temperature', '°C'),
  ('superheat-temperature', '°F'), ('superheat-temperature', '°C'),
  ('case-temperature', '°F'), ('case-temperature', '°C'),
  ('suction-superheat', '°F'), ('suction-superheat', '°C'),
  ('domestic-water-temperature', '°F'), ('domestic-water-temperature', '°C'),
  ('chiller-entering-condenser-water-temperature', '°F'), ('chiller-entering-condenser-water-temperature', '°C'),
  ('chiller-leaving-condenser-water-temperature', '°F'), ('chiller-leaving-condenser-water-temperature', '°C');

-- Temperature setpoints → °F, °C
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('return-air-temperature-setpoint', '°F'), ('return-air-temperature-setpoint', '°C'),
  ('supply-air-temperature-setpoint', '°F'), ('supply-air-temperature-setpoint', '°C'),
  ('warmup-setpoint', '°F'), ('warmup-setpoint', '°C'),
  ('cooling-tower-approach-setpoint', '°F'), ('cooling-tower-approach-setpoint', '°C'),
  ('discharge-air-temperature-reset-setpoint', '°F'), ('discharge-air-temperature-reset-setpoint', '°C'),
  ('chilled-water-temperature-reset-setpoint', '°F'), ('chilled-water-temperature-reset-setpoint', '°C'),
  ('hot-water-temperature-reset-setpoint', '°F'), ('hot-water-temperature-reset-setpoint', '°C'),
  ('economizer-high-limit-setpoint', '°F'), ('economizer-high-limit-setpoint', '°C');

-- Temperature deltas → °F, °C
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('supply-air-delta-t', '°F'), ('supply-air-delta-t', '°C'),
  ('chilled-water-delta-t', '°F'), ('chilled-water-delta-t', '°C'),
  ('hot-water-delta-t', '°F'), ('hot-water-delta-t', '°C'),
  ('condenser-approach-temperature', '°F'), ('condenser-approach-temperature', '°C'),
  ('evaporator-approach-temperature', '°F'), ('evaporator-approach-temperature', '°C');

-- Pressure points → psi, kPa, bar
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('condenser-water-differential-pressure', 'psi'), ('condenser-water-differential-pressure', 'kPa'),
  ('refrigerant-suction-pressure', 'psi'), ('refrigerant-suction-pressure', 'kPa'),
  ('refrigerant-discharge-pressure', 'psi'), ('refrigerant-discharge-pressure', 'kPa'),
  ('steam-pressure', 'psi'), ('steam-pressure', 'kPa'),
  ('head-pressure', 'psi'), ('head-pressure', 'kPa'),
  ('suction-pressure', 'psi'), ('suction-pressure', 'kPa'),
  ('condenser-pressure', 'psi'), ('condenser-pressure', 'kPa'),
  ('boiler-pressure', 'psi'), ('boiler-pressure', 'kPa'),
  ('chilled-water-pressure', 'psi'), ('chilled-water-pressure', 'kPa'),
  ('water-pressure', 'psi'), ('water-pressure', 'kPa'),
  ('oil-pressure', 'psi'), ('oil-pressure', 'kPa');

-- Air pressure points → in.w.c., Pa
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('gas-pressure', 'in.w.c.'), ('gas-pressure', 'Pa'),
  ('exhaust-air-static-pressure', 'in.w.c.'), ('exhaust-air-static-pressure', 'Pa'),
  ('supply-air-static-pressure', 'in.w.c.'), ('supply-air-static-pressure', 'Pa'),
  ('natural-gas-pressure', 'in.w.c.'), ('natural-gas-pressure', 'Pa'),
  ('duct-static-pressure-reset-setpoint', 'in.w.c.'), ('duct-static-pressure-reset-setpoint', 'Pa');

-- Pressure setpoints → psi, kPa
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('condenser-water-differential-pressure-setpoint', 'psi'), ('condenser-water-differential-pressure-setpoint', 'kPa'),
  ('hot-water-differential-pressure-setpoint', 'psi'), ('hot-water-differential-pressure-setpoint', 'kPa');

-- Flow points → gpm, L/s
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('makeup-water-flow', 'gpm'), ('makeup-water-flow', 'L/s'),
  ('domestic-hot-water-flow', 'gpm'), ('domestic-hot-water-flow', 'L/s'),
  ('blowdown-flow', 'gpm'), ('blowdown-flow', 'L/s'),
  ('glycol-flow', 'gpm'), ('glycol-flow', 'L/s'),
  ('primary-chilled-water-flow', 'gpm'), ('primary-chilled-water-flow', 'L/s'),
  ('secondary-chilled-water-flow', 'gpm'), ('secondary-chilled-water-flow', 'L/s'),
  ('bypass-flow', 'gpm'), ('bypass-flow', 'L/s'),
  ('primary-hot-water-flow', 'gpm'), ('primary-hot-water-flow', 'L/s'),
  ('secondary-hot-water-flow', 'gpm'), ('secondary-hot-water-flow', 'L/s'),
  ('cooling-tower-water-flow', 'gpm'), ('cooling-tower-water-flow', 'L/s'),
  ('condensate-flow', 'gpm'), ('condensate-flow', 'L/s');

-- Airflow points → cfm, L/s
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('ventilation-airflow', 'cfm'), ('ventilation-airflow', 'L/s'),
  ('minimum-outdoor-airflow', 'cfm'), ('minimum-outdoor-airflow', 'L/s'),
  ('supply-airflow-setpoint', 'cfm'), ('supply-airflow-setpoint', 'L/s'),
  ('minimum-airflow-setpoint', 'cfm'), ('minimum-airflow-setpoint', 'L/s'),
  ('maximum-airflow-setpoint', 'cfm'), ('maximum-airflow-setpoint', 'L/s'),
  ('exhaust-airflow-setpoint', 'cfm'), ('exhaust-airflow-setpoint', 'L/s');

-- Percentage points → %
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('outdoor-air-damper-command', '%'), ('return-air-damper-command', '%'),
  ('exhaust-air-damper-command', '%'), ('bypass-damper-command', '%'),
  ('chilled-water-valve-command', '%'), ('hot-water-valve-command', '%'),
  ('steam-valve-command', '%'), ('preheat-valve-command', '%'),
  ('reheat-valve-command', '%'), ('condenser-water-valve-command', '%'),
  ('vfd-speed-command', '%'), ('humidifier-command', '%'),
  ('dehumidifier-output', '%'), ('dimming-level-command', '%'),
  ('bypass-damper-position', '%'), ('bypass-damper-feedback', '%'),
  ('bypass-damper-output', '%'), ('return-air-damper-position', '%'),
  ('preheat-valve-position', '%'), ('preheat-valve-output', '%'),
  ('reheat-valve-position', '%'), ('reheat-valve-output', '%'),
  ('chilled-water-valve-position', '%'), ('hot-water-valve-position', '%'),
  ('condenser-water-valve-position', '%'), ('steam-valve-position', '%'),
  ('steam-valve-output', '%'), ('three-way-valve-position', '%'),
  ('supply-fan-vfd-speed', '%'), ('return-fan-vfd-speed', '%'),
  ('exhaust-fan-vfd-speed', '%'), ('cooling-tower-fan-speed', '%'),
  ('motor-current-percentage', '%'), ('refrigerant-level', '%'),
  ('vfd-speed-setpoint', '%'), ('total-harmonic-distortion', '%'),
  ('boiler-firing-rate', '%'), ('cooling-tower-fan-vfd-speed', '%');

-- Electrical points → V, A, kW, kWh, etc.
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('voltage-phase-a', 'V'), ('voltage-phase-b', 'V'), ('voltage-phase-c', 'V'),
  ('current-phase-a', 'A'), ('current-phase-b', 'A'), ('current-phase-c', 'A'),
  ('demand-power', 'kW'), ('line-to-line-voltage', 'V'), ('line-to-neutral-voltage', 'V'),
  ('building-power-demand', 'kW'), ('peak-demand', 'kW'),
  ('demand-limit-setpoint', 'kW'),
  ('lighting-power-consumption', 'kW'), ('thermal-energy', 'kBTU');

-- Humidity points → %RH
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('supply-air-humidity', '%RH'), ('zone-humidity-setpoint', '%RH'),
  ('supply-air-humidity-setpoint', '%RH'),
  ('supply-air-dewpoint', '°F'), ('supply-air-dewpoint', '°C');

-- IAQ points → ppm, ppb, etc.
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('co-level', 'ppm'), ('formaldehyde-level', 'ppb'),
  ('ozone-level', 'ppb'), ('radon-level', 'pCi/L'),
  ('nitrogen-dioxide-level', 'ppb'),
  ('co2-ventilation-setpoint', 'ppm'), ('co-alarm-setpoint', 'ppm'),
  ('zone-co2-setpoint', 'ppm');

-- Enthalpy → BTU/lb
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('outdoor-air-enthalpy', 'BTU/lb'), ('return-air-enthalpy', 'BTU/lb'),
  ('supply-air-enthalpy', 'BTU/lb'), ('outdoor-air-enthalpy-setpoint', 'BTU/lb');

-- Runtime → hr
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('runtime-hours-total', 'hr');

-- Lighting → fc, lux
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('task-lighting-level', 'fc'), ('task-lighting-level', 'lux'),
  ('ambient-lighting-level', 'fc'), ('ambient-lighting-level', 'lux');

-- Consumption
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('natural-gas-consumption', 'therms'), ('natural-gas-consumption', 'ccf'),
  ('water-consumption', 'gal'), ('water-consumption', 'kgal'),
  ('steam-consumption', 'lb'), ('steam-consumption', 'klb');

-- Misc
INSERT OR IGNORE INTO point_units (point_id, unit) VALUES
  ('gas-flow', 'cfh'), ('refrigerant-flow', 'lb/min'),
  ('compressor-stage', 'stage'), ('lead-lag-status', 'stage'),
  ('compressor-stage-command', 'stage'), ('lead-lag-command', 'stage'),
  ('ventilation-rate', 'cfm/person'), ('air-changes-per-hour', 'ACH'),
  ('chiller-cop', 'COP'), ('chiller-kw-per-ton', 'kW/ton'),
  ('energy-use-intensity', 'kBTU/ft²');

-- ═══════════════════════════════════════════════════════════
-- PHASE 4b: POINT STATES (for new Bool points)
-- ═══════════════════════════════════════════════════════════

-- Commands (on/off)
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'supply-fan-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='supply-fan-command' AND state_key='0');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'supply-fan-command', '1', 'On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='supply-fan-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'return-fan-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='return-fan-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'return-fan-command', '1', 'On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='return-fan-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'exhaust-fan-command-bool', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='exhaust-fan-command-bool');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'exhaust-fan-command-bool', '1', 'On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='exhaust-fan-command-bool' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'relief-fan-command-bool', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='relief-fan-command-bool');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'relief-fan-command-bool', '1', 'On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='relief-fan-command-bool' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'compressor-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='compressor-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'compressor-command', '1', 'On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='compressor-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'condenser-water-pump-command-bool', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='condenser-water-pump-command-bool');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'condenser-water-pump-command-bool', '1', 'On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='condenser-water-pump-command-bool' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'setpoint-reset-command', '0', 'Disabled' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='setpoint-reset-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'setpoint-reset-command', '1', 'Enabled' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='setpoint-reset-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'morning-warmup-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='morning-warmup-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'morning-warmup-command', '1', 'On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='morning-warmup-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'night-purge-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='night-purge-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'night-purge-command', '1', 'On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='night-purge-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'freeze-protection-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='freeze-protection-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'freeze-protection-command', '1', 'Active' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='freeze-protection-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'smoke-control-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='smoke-control-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'smoke-control-command', '1', 'Active' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='smoke-control-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'lighting-on-off-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='lighting-on-off-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'lighting-on-off-command', '1', 'On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='lighting-on-off-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'schedule-override-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='schedule-override-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'schedule-override-command', '1', 'Override' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='schedule-override-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'alarm-reset-command', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='alarm-reset-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'alarm-reset-command', '1', 'Reset' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='alarm-reset-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'equipment-isolation-command', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='equipment-isolation-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'equipment-isolation-command', '1', 'Isolated' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='equipment-isolation-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'demand-limit-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='demand-limit-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'demand-limit-command', '1', 'Active' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='demand-limit-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'dehumidifier-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='dehumidifier-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'dehumidifier-command', '1', 'On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='dehumidifier-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'defrost-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='defrost-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'defrost-command', '1', 'Defrost' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='defrost-command' AND state_key='1');

-- Status points
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'supply-fan-status', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='supply-fan-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'supply-fan-status', '1', 'Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='supply-fan-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'return-fan-status', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='return-fan-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'return-fan-status', '1', 'Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='return-fan-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'exhaust-fan-status-bool', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='exhaust-fan-status-bool');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'exhaust-fan-status-bool', '1', 'Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='exhaust-fan-status-bool' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'compressor-status', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='compressor-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'compressor-status', '1', 'Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='compressor-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'economizer-status', '0', 'Inactive' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='economizer-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'economizer-status', '1', 'Active' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='economizer-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'free-cooling-status', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='free-cooling-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'free-cooling-status', '1', 'Active' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='free-cooling-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'morning-warmup-status', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='morning-warmup-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'morning-warmup-status', '1', 'Active' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='morning-warmup-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'night-purge-status', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='night-purge-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'night-purge-status', '1', 'Active' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='night-purge-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'freeze-stat-status', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='freeze-stat-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'freeze-stat-status', '1', 'Tripped' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='freeze-stat-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-limit-status', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-limit-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-limit-status', '1', 'Tripped' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-limit-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'low-limit-status', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='low-limit-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'low-limit-status', '1', 'Tripped' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='low-limit-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'proof-of-flow', '0', 'No Flow' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='proof-of-flow');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'proof-of-flow', '1', 'Flow Proven' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='proof-of-flow' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'proof-of-airflow', '0', 'No Flow' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='proof-of-airflow');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'proof-of-airflow', '1', 'Flow Proven' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='proof-of-airflow' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'vfd-status', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='vfd-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'vfd-status', '1', 'Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='vfd-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'generator-run-status', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='generator-run-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'generator-run-status', '1', 'Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='generator-run-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'emergency-power-status', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='emergency-power-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'emergency-power-status', '1', 'Emergency' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='emergency-power-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'fire-mode-status', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='fire-mode-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'fire-mode-status', '1', 'Fire Mode' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='fire-mode-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'smoke-control-status', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='smoke-control-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'smoke-control-status', '1', 'Active' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='smoke-control-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'defrost-status', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='defrost-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'defrost-status', '1', 'Defrosting' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='defrost-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'standby-status', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='standby-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'standby-status', '1', 'Standby' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='standby-status' AND state_key='1');

-- Alarm points (normal/alarm)
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-discharge-air-temperature-alarm', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-discharge-air-temperature-alarm');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-discharge-air-temperature-alarm', '1', 'Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-discharge-air-temperature-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'low-discharge-air-temperature-alarm', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='low-discharge-air-temperature-alarm');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'low-discharge-air-temperature-alarm', '1', 'Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='low-discharge-air-temperature-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-zone-temperature-alarm', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-zone-temperature-alarm');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'high-zone-temperature-alarm', '1', 'Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='high-zone-temperature-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'low-zone-temperature-alarm', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='low-zone-temperature-alarm');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'low-zone-temperature-alarm', '1', 'Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='low-zone-temperature-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'freeze-protection-alarm', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='freeze-protection-alarm');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'freeze-protection-alarm', '1', 'Alarm' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='freeze-protection-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'vfd-fault-alarm', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='vfd-fault-alarm');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'vfd-fault-alarm', '1', 'Fault' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='vfd-fault-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'motor-overload-alarm', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='motor-overload-alarm');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'motor-overload-alarm', '1', 'Overload' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='motor-overload-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'refrigerant-leak-alarm', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='refrigerant-leak-alarm');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'refrigerant-leak-alarm', '1', 'Leak Detected' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='refrigerant-leak-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'water-leak-alarm', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='water-leak-alarm');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'water-leak-alarm', '1', 'Leak Detected' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='water-leak-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'power-failure-alarm', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='power-failure-alarm');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'power-failure-alarm', '1', 'Power Loss' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='power-failure-alarm' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'vibration-alarm', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='vibration-alarm');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'vibration-alarm', '1', 'High Vibration' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='vibration-alarm' AND state_key='1');

-- Damper/valve status (open/closed)
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'bypass-damper-closed', '0', 'Open' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='bypass-damper-closed');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'bypass-damper-closed', '1', 'Closed' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='bypass-damper-closed' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'bypass-damper-open', '0', 'Closed' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='bypass-damper-open');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'bypass-damper-open', '1', 'Open' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='bypass-damper-open' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'return-air-damper-closed', '0', 'Open' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='return-air-damper-closed');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'return-air-damper-closed', '1', 'Closed' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='return-air-damper-closed' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'return-air-damper-open', '0', 'Closed' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='return-air-damper-open');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'return-air-damper-open', '1', 'Open' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='return-air-damper-open' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'fire-damper-position', '0', 'Open' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='fire-damper-position');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'fire-damper-position', '1', 'Closed' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='fire-damper-position' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'fire-damper-status', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='fire-damper-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'fire-damper-status', '1', 'Actuated' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='fire-damper-status' AND state_key='1');

-- Lighting / misc status
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'lighting-status', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='lighting-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'lighting-status', '1', 'On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='lighting-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'lighting-command', '0', 'Off' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='lighting-command');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'lighting-command', '1', 'On' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='lighting-command' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'elevator-run-status', '0', 'Idle' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='elevator-run-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'elevator-run-status', '1', 'Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='elevator-run-status' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'escalator-run-status', '0', 'Stopped' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='escalator-run-status');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'escalator-run-status', '1', 'Running' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='escalator-run-status' AND state_key='1');

-- Existing Bool points without states
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'cooling-tower-isolation-valve', '0', 'Closed' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='cooling-tower-isolation-valve');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'cooling-tower-isolation-valve', '1', 'Open' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='cooling-tower-isolation-valve' AND state_key='1');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'shutdown', '0', 'Normal' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='shutdown');
INSERT INTO point_states (point_id, state_key, state_value) SELECT 'shutdown', '1', 'Shutdown' WHERE NOT EXISTS (SELECT 1 FROM point_states WHERE point_id='shutdown' AND state_key='1');

-- ═══════════════════════════════════════════════════════════
-- PHASE 4d: RELATED POINTS (bidirectional links for new points)
-- ═══════════════════════════════════════════════════════════

-- Temperature sensor ↔ setpoint pairs
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('supply-air-temperature-setpoint', 'supply-air-temperature'), ('supply-air-temperature', 'supply-air-temperature-setpoint'),
  ('supply-air-temperature-setpoint', 'discharge-air-temperature-setpoint'), ('discharge-air-temperature-setpoint', 'supply-air-temperature-setpoint'),
  ('return-air-temperature-setpoint', 'return-air-temperature'), ('return-air-temperature', 'return-air-temperature-setpoint'),
  ('warmup-setpoint', 'zone-temperature-setpoint'), ('zone-temperature-setpoint', 'warmup-setpoint'),
  ('economizer-high-limit-setpoint', 'outdoor-air-temperature'), ('outdoor-air-temperature', 'economizer-high-limit-setpoint'),
  ('chilled-water-temperature-reset-setpoint', 'chilled-water-supply-temperature-setpoint'), ('chilled-water-supply-temperature-setpoint', 'chilled-water-temperature-reset-setpoint'),
  ('hot-water-temperature-reset-setpoint', 'hot-water-supply-temperature-setpoint'), ('hot-water-supply-temperature-setpoint', 'hot-water-temperature-reset-setpoint'),
  ('discharge-air-temperature-reset-setpoint', 'discharge-air-temperature-setpoint'), ('discharge-air-temperature-setpoint', 'discharge-air-temperature-reset-setpoint'),
  ('cooling-tower-approach-setpoint', 'condenser-water-supply-temperature'), ('condenser-water-supply-temperature', 'cooling-tower-approach-setpoint');

-- Command ↔ status pairs
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('supply-fan-command', 'supply-fan-status'), ('supply-fan-status', 'supply-fan-command'),
  ('return-fan-command', 'return-fan-status'), ('return-fan-status', 'return-fan-command'),
  ('compressor-command', 'compressor-status'), ('compressor-status', 'compressor-command'),
  ('vfd-speed-command', 'vfd-status'), ('vfd-status', 'vfd-speed-command'),
  ('morning-warmup-command', 'morning-warmup-status'), ('morning-warmup-status', 'morning-warmup-command'),
  ('night-purge-command', 'night-purge-status'), ('night-purge-status', 'night-purge-command'),
  ('freeze-protection-command', 'freeze-stat-status'), ('freeze-stat-status', 'freeze-protection-command'),
  ('smoke-control-command', 'smoke-control-status'), ('smoke-control-status', 'smoke-control-command'),
  ('humidifier-command', 'humidifier-run-status'), ('humidifier-run-status', 'humidifier-command'),
  ('dehumidifier-command', 'dehumidifier-status'), ('dehumidifier-status', 'dehumidifier-command'),
  ('defrost-command', 'defrost-status'), ('defrost-status', 'defrost-command'),
  ('lighting-command', 'lighting-status'), ('lighting-status', 'lighting-command'),
  ('demand-limit-command', 'demand-power'), ('demand-power', 'demand-limit-command');

-- Damper command ↔ position ↔ feedback
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('outdoor-air-damper-command', 'outside-air-damper-position'), ('outside-air-damper-position', 'outdoor-air-damper-command'),
  ('return-air-damper-command', 'return-air-damper-position'), ('return-air-damper-position', 'return-air-damper-command'),
  ('exhaust-air-damper-command', 'exhaust-air-damper-position'), ('exhaust-air-damper-position', 'exhaust-air-damper-command'),
  ('bypass-damper-command', 'bypass-damper-position'), ('bypass-damper-position', 'bypass-damper-command'),
  ('bypass-damper-feedback', 'bypass-damper-output'), ('bypass-damper-output', 'bypass-damper-feedback');

-- Valve command ↔ position
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('chilled-water-valve-command', 'chilled-water-valve-position'), ('chilled-water-valve-position', 'chilled-water-valve-command'),
  ('hot-water-valve-command', 'hot-water-valve-position'), ('hot-water-valve-position', 'hot-water-valve-command'),
  ('preheat-valve-command', 'preheat-valve-position'), ('preheat-valve-position', 'preheat-valve-command'),
  ('reheat-valve-command', 'reheat-valve-position'), ('reheat-valve-position', 'reheat-valve-command'),
  ('steam-valve-command', 'steam-valve-position'), ('steam-valve-position', 'steam-valve-command'),
  ('condenser-water-valve-command', 'condenser-water-valve-position'), ('condenser-water-valve-position', 'condenser-water-valve-command');

-- Airflow setpoints ↔ sensors
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('supply-airflow-setpoint', 'supply-air-flow'), ('supply-air-flow', 'supply-airflow-setpoint'),
  ('minimum-airflow-setpoint', 'supply-airflow-setpoint'), ('supply-airflow-setpoint', 'minimum-airflow-setpoint'),
  ('maximum-airflow-setpoint', 'supply-airflow-setpoint'), ('supply-airflow-setpoint', 'maximum-airflow-setpoint'),
  ('exhaust-airflow-setpoint', 'exhaust-air-flow'), ('exhaust-air-flow', 'exhaust-airflow-setpoint');

-- Pressure setpoints ↔ sensors
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('duct-static-pressure-reset-setpoint', 'duct-static-pressure'), ('duct-static-pressure', 'duct-static-pressure-reset-setpoint'),
  ('condenser-water-differential-pressure-setpoint', 'condenser-water-differential-pressure'), ('condenser-water-differential-pressure', 'condenser-water-differential-pressure-setpoint'),
  ('hot-water-differential-pressure-setpoint', 'hot-water-differential-pressure'), ('hot-water-differential-pressure', 'hot-water-differential-pressure-setpoint');

-- Delta-T links
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('chilled-water-delta-t', 'chilled-water-supply-temperature'), ('chilled-water-delta-t', 'chilled-water-return-temperature'),
  ('hot-water-delta-t', 'hot-water-supply-temperature'), ('hot-water-delta-t', 'hot-water-return-temperature'),
  ('supply-air-delta-t', 'supply-air-temperature'), ('supply-air-delta-t', 'mixed-air-temperature');

-- Chiller performance links
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('chiller-cop', 'chiller-kw-per-ton'), ('chiller-kw-per-ton', 'chiller-cop'),
  ('chiller-cop', 'energy-consumption-kwh'), ('chiller-kw-per-ton', 'energy-consumption-kwh'),
  ('condenser-approach-temperature', 'condenser-water-supply-temperature'), ('condenser-approach-temperature', 'wet-bulb-temperature'),
  ('evaporator-approach-temperature', 'chilled-water-supply-temperature');

-- Humidity links
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('zone-humidity-setpoint', 'zone-humidity'), ('zone-humidity', 'zone-humidity-setpoint'),
  ('supply-air-humidity', 'supply-air-dewpoint'), ('supply-air-dewpoint', 'supply-air-humidity'),
  ('supply-air-humidity-setpoint', 'supply-air-humidity'), ('supply-air-humidity', 'supply-air-humidity-setpoint');

-- Enthalpy links
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('outdoor-air-enthalpy', 'return-air-enthalpy'), ('return-air-enthalpy', 'outdoor-air-enthalpy'),
  ('outdoor-air-enthalpy', 'outdoor-air-temperature'), ('outdoor-air-enthalpy', 'outdoor-air-humidity'),
  ('outdoor-air-enthalpy-setpoint', 'outdoor-air-enthalpy'), ('outdoor-air-enthalpy', 'outdoor-air-enthalpy-setpoint');

-- Refrigeration links
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('refrigerant-suction-pressure', 'refrigerant-discharge-pressure'), ('refrigerant-discharge-pressure', 'refrigerant-suction-pressure'),
  ('refrigerant-suction-temperature', 'refrigerant-discharge-temperature'), ('refrigerant-discharge-temperature', 'refrigerant-suction-temperature'),
  ('superheat-temperature', 'refrigerant-suction-temperature'), ('suction-superheat', 'superheat-temperature'),
  ('compressor-discharge-temperature', 'compressor-suction-temperature'), ('compressor-suction-temperature', 'compressor-discharge-temperature');

-- Fan VFD speed links
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('supply-fan-vfd-speed', 'vfd-speed-command'), ('vfd-speed-command', 'supply-fan-vfd-speed'),
  ('return-fan-vfd-speed', 'vfd-speed-command'),
  ('exhaust-fan-vfd-speed', 'vfd-speed-command');

-- CO/CO2 links
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('co2-ventilation-setpoint', 'zone-co2'), ('zone-co2', 'co2-ventilation-setpoint'),
  ('co-alarm-setpoint', 'co-level'), ('co-level', 'co-alarm-setpoint'),
  ('zone-co2-setpoint', 'zone-co2'), ('zone-co2', 'zone-co2-setpoint'),
  ('high-co2-alarm', 'zone-co2'), ('zone-co2', 'high-co2-alarm');

-- Electrical phase links
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('voltage-phase-a', 'voltage-phase-b'), ('voltage-phase-b', 'voltage-phase-c'), ('voltage-phase-c', 'voltage-phase-a'),
  ('current-phase-a', 'current-phase-b'), ('current-phase-b', 'current-phase-c'), ('current-phase-c', 'current-phase-a'),
  ('demand-power', 'peak-demand'), ('peak-demand', 'demand-power'),
  ('building-power-demand', 'demand-power'), ('demand-power', 'building-power-demand');

-- Update categories table for new categories
INSERT OR IGNORE INTO categories (id, name, type, count) VALUES
  ('lighting', 'Lighting', 'equipment', 0),
  ('refrigeration', 'Refrigeration', 'equipment', 0),
  ('controls', 'Controls', 'equipment', 0),
  ('vertical-transport', 'Vertical Transport', 'equipment', 0);

-- Update category counts
UPDATE categories SET count = (SELECT COUNT(*) FROM points WHERE category = categories.id) WHERE type = 'point';
UPDATE categories SET count = (SELECT COUNT(*) FROM equipment WHERE category = categories.id) WHERE type = 'equipment';

COMMIT;

BEGIN TRANSACTION;

-- ═══════════════════════════════════════════════════════════
-- PHASE 4d (continued): MORE RELATED POINTS
-- ═══════════════════════════════════════════════════════════

-- Alarm ↔ sensor/status pairs
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('high-discharge-air-temperature-alarm', 'discharge-air-temperature'), ('discharge-air-temperature', 'high-discharge-air-temperature-alarm'),
  ('low-discharge-air-temperature-alarm', 'discharge-air-temperature'), ('discharge-air-temperature', 'low-discharge-air-temperature-alarm'),
  ('high-zone-temperature-alarm', 'zone-temperature'), ('zone-temperature', 'high-zone-temperature-alarm'),
  ('low-zone-temperature-alarm', 'zone-temperature'), ('zone-temperature', 'low-zone-temperature-alarm'),
  ('high-duct-static-pressure-alarm', 'duct-static-pressure'), ('duct-static-pressure', 'high-duct-static-pressure-alarm'),
  ('low-duct-static-pressure-alarm', 'duct-static-pressure'), ('duct-static-pressure', 'low-duct-static-pressure-alarm'),
  ('freeze-protection-alarm', 'freeze-stat-status'), ('freeze-stat-status', 'freeze-protection-alarm'),
  ('high-humidity-alarm', 'zone-humidity'), ('zone-humidity', 'high-humidity-alarm'),
  ('low-humidity-alarm', 'zone-humidity'), ('zone-humidity', 'low-humidity-alarm'),
  ('vfd-fault-alarm', 'vfd-status'), ('vfd-status', 'vfd-fault-alarm'),
  ('motor-overload-alarm', 'motor-current-percentage'), ('motor-current-percentage', 'motor-overload-alarm'),
  ('refrigerant-leak-alarm', 'refrigerant-level'), ('refrigerant-level', 'refrigerant-leak-alarm'),
  ('water-leak-alarm', 'water-pressure'), ('water-pressure', 'water-leak-alarm'),
  ('power-failure-alarm', 'emergency-power-status'), ('emergency-power-status', 'power-failure-alarm'),
  ('generator-alarm', 'generator-run-status'), ('generator-run-status', 'generator-alarm'),
  ('ups-alarm', 'ups-status'), ('ups-status', 'ups-alarm'),
  ('high-condenser-pressure-alarm', 'condenser-pressure'), ('condenser-pressure', 'high-condenser-pressure-alarm'),
  ('low-suction-pressure-alarm', 'suction-pressure'), ('suction-pressure', 'low-suction-pressure-alarm'),
  ('vibration-alarm', 'equipment-run-hours'), ('elevator-alarm', 'elevator-run-status'),
  ('elevator-run-status', 'elevator-alarm');

-- Command ↔ feedback/status links
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('exhaust-fan-command-bool', 'exhaust-fan-status-bool'), ('exhaust-fan-status-bool', 'exhaust-fan-command-bool'),
  ('relief-fan-command-bool', 'relief-fan-status'), ('condenser-water-pump-command-bool', 'condenser-water-pump-status'),
  ('condenser-water-pump-status', 'condenser-water-pump-command-bool'),
  ('compressor-stage-command', 'compressor-stage'), ('compressor-stage', 'compressor-stage-command'),
  ('lead-lag-command', 'lead-lag-status'), ('lead-lag-status', 'lead-lag-command'),
  ('lighting-on-off-command', 'lighting-status'), ('lighting-status', 'lighting-on-off-command'),
  ('dimming-level-command', 'lighting-dimming-output'), ('lighting-dimming-output', 'dimming-level-command'),
  ('schedule-override-command', 'occupancy-schedule'), ('boiler-firing-rate', 'boiler-status'),
  ('boiler-status', 'boiler-firing-rate'),
  ('alarm-reset-command', 'alarm-active-status'), ('alarm-active-status', 'alarm-reset-command'),
  ('equipment-isolation-command', 'isolation-valve-closed'), ('setpoint-reset-command', 'duct-static-pressure-reset-setpoint');

-- Damper closed/open ↔ position
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('bypass-damper-closed', 'bypass-damper-position'), ('bypass-damper-position', 'bypass-damper-closed'),
  ('bypass-damper-open', 'bypass-damper-position'), ('bypass-damper-position', 'bypass-damper-open'),
  ('return-air-damper-closed', 'return-air-damper-position'), ('return-air-damper-position', 'return-air-damper-closed'),
  ('return-air-damper-open', 'return-air-damper-position'), ('return-air-damper-position', 'return-air-damper-open'),
  ('fire-damper-position', 'fire-damper-status'), ('fire-damper-status', 'fire-damper-position'),
  ('fire-damper-status', 'fire-alarm-status'), ('fire-alarm-status', 'fire-damper-status');

-- Valve output ↔ position
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('preheat-valve-output', 'preheat-valve-position'), ('preheat-valve-position', 'preheat-valve-output'),
  ('reheat-valve-output', 'reheat-valve-position'), ('reheat-valve-position', 'reheat-valve-output'),
  ('steam-valve-output', 'steam-valve-position'), ('steam-valve-position', 'steam-valve-output'),
  ('three-way-valve-position', 'mixing-valve-output'), ('mixing-valve-output', 'three-way-valve-position');

-- Electrical related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('line-to-line-voltage', 'voltage-phase-a'), ('line-to-neutral-voltage', 'voltage-phase-a'),
  ('total-harmonic-distortion', 'voltage-phase-a'), ('total-harmonic-distortion', 'power-factor');

-- Flow related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('primary-chilled-water-flow', 'secondary-chilled-water-flow'), ('secondary-chilled-water-flow', 'primary-chilled-water-flow'),
  ('primary-hot-water-flow', 'secondary-hot-water-flow'), ('secondary-hot-water-flow', 'primary-hot-water-flow'),
  ('makeup-water-flow', 'blowdown-flow'), ('blowdown-flow', 'makeup-water-flow'),
  ('cooling-tower-water-flow', 'condenser-water-flow'), ('condenser-water-flow', 'cooling-tower-water-flow'),
  ('domestic-hot-water-flow', 'domestic-hot-water-supply-temperature'),
  ('ventilation-airflow', 'minimum-outdoor-airflow'), ('minimum-outdoor-airflow', 'ventilation-airflow'),
  ('bypass-flow', 'primary-chilled-water-flow'), ('condensate-flow', 'steam-flow'),
  ('gas-flow', 'natural-gas-consumption'), ('natural-gas-consumption', 'gas-flow'),
  ('glycol-flow', 'chilled-water-flow'), ('refrigerant-flow', 'refrigerant-suction-pressure');

-- Temperature related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('preheat-leaving-temperature', 'mixed-air-temperature'), ('mixed-air-temperature', 'preheat-leaving-temperature'),
  ('reheat-discharge-temperature', 'discharge-air-temperature'), ('discharge-air-temperature', 'reheat-discharge-temperature'),
  ('flue-gas-temperature', 'boiler-status'), ('steam-temperature', 'steam-pressure'),
  ('steam-pressure', 'steam-temperature'),
  ('server-inlet-temperature', 'server-outlet-temperature'), ('server-outlet-temperature', 'server-inlet-temperature'),
  ('slab-temperature', 'radiant-panel-surface-temperature'), ('radiant-panel-surface-temperature', 'slab-temperature'),
  ('ceiling-plenum-temperature', 'return-air-temperature'), ('heat-exchanger-leaving-temperature', 'chilled-water-supply-temperature'),
  ('case-temperature', 'evaporator-temperature'), ('evaporator-temperature', 'case-temperature'),
  ('condenser-temperature', 'head-pressure'), ('head-pressure', 'condenser-temperature'),
  ('subcooling-temperature', 'condenser-temperature'), ('ground-water-temperature', 'chilled-water-supply-temperature'),
  ('chiller-entering-condenser-water-temperature', 'chiller-leaving-condenser-water-temperature'),
  ('chiller-leaving-condenser-water-temperature', 'chiller-entering-condenser-water-temperature'),
  ('domestic-water-temperature', 'domestic-hot-water-supply-temperature'),
  ('outdoor-air-temperature-setpoint', 'outdoor-air-temperature');

-- Pressure related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('boiler-pressure', 'steam-pressure'), ('steam-pressure', 'boiler-pressure'),
  ('suction-pressure', 'head-pressure'), ('head-pressure', 'suction-pressure'),
  ('condenser-pressure', 'head-pressure'), ('oil-pressure', 'compressor-status'),
  ('chilled-water-pressure', 'chilled-water-differential-pressure'),
  ('exhaust-air-static-pressure', 'duct-static-pressure'), ('supply-air-static-pressure', 'duct-static-pressure'),
  ('gas-pressure', 'natural-gas-pressure'), ('natural-gas-pressure', 'gas-pressure'),
  ('water-pressure', 'proof-of-flow');

-- Status related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('economizer-status', 'free-cooling-status'), ('free-cooling-status', 'economizer-status'),
  ('proof-of-flow', 'proof-of-airflow'), ('proof-of-airflow', 'proof-of-flow'),
  ('fire-mode-status', 'smoke-control-status'), ('smoke-control-status', 'fire-mode-status'),
  ('fire-mode-status', 'fire-alarm-status'), ('fire-suppression-status', 'fire-alarm-status'),
  ('dehumidification-status', 'humidification-status'), ('humidification-status', 'dehumidification-status'),
  ('standby-status', 'lead-lag-status'),
  ('emergency-power-status', 'generator-run-status'), ('generator-run-status', 'emergency-power-status'),
  ('alarm-active-status', 'communication-loss-alarm'), ('high-limit-status', 'low-limit-status'),
  ('low-limit-status', 'high-limit-status'), ('compressor-stage', 'compressor-status');

-- Setpoint related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('vfd-speed-setpoint', 'vfd-speed-command'), ('vfd-speed-command', 'vfd-speed-setpoint'),
  ('demand-limit-setpoint', 'demand-limit-command'), ('demand-limit-command', 'demand-limit-setpoint');

-- Cooling tower fan related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('cooling-tower-fan-command', 'cooling-tower-fan-status'), ('cooling-tower-fan-status', 'cooling-tower-fan-command'),
  ('cooling-tower-fan-speed', 'cooling-tower-fan-vfd-speed'), ('cooling-tower-fan-vfd-speed', 'cooling-tower-fan-speed'),
  ('cooling-tower-fan-speed', 'cooling-tower-fan-command');

-- Garage/kitchen fan related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('garage-exhaust-fan-command', 'garage-exhaust-fan-status'), ('garage-exhaust-fan-status', 'garage-exhaust-fan-command'),
  ('garage-exhaust-fan-command', 'co-level'), ('co-level', 'garage-exhaust-fan-command'),
  ('kitchen-exhaust-fan-command', 'kitchen-exhaust-fan-status'), ('kitchen-exhaust-fan-status', 'kitchen-exhaust-fan-command');

-- Lighting related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('lighting-schedule', 'lighting-command'), ('lighting-command', 'lighting-schedule'),
  ('lighting-power-consumption', 'lighting-status'), ('lighting-status', 'lighting-power-consumption'),
  ('exterior-lighting-command', 'exterior-lighting-status'), ('exterior-lighting-status', 'exterior-lighting-command'),
  ('lighting-scene-command', 'lighting-dimming-output'), ('lighting-dimming-output', 'lighting-scene-command'),
  ('task-lighting-level', 'ambient-lighting-level'), ('ambient-lighting-level', 'task-lighting-level'),
  ('emergency-lighting-status', 'power-failure-alarm');

-- Calculated/maintenance related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('runtime-hours-total', 'equipment-run-hours'), ('equipment-run-hours', 'runtime-hours-total'),
  ('runtime-hours-total', 'equipment-start-count'), ('supply-air-enthalpy', 'outdoor-air-enthalpy'),
  ('outdoor-air-enthalpy', 'supply-air-enthalpy'),
  ('cooling-degree-days', 'heating-degree-days'), ('heating-degree-days', 'cooling-degree-days'),
  ('energy-use-intensity', 'energy-consumption-kwh'), ('energy-consumption-kwh', 'energy-use-intensity'),
  ('motor-current-percentage', 'motor-overload-alarm');

-- Humidity related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('dehumidifier-output', 'dehumidifier-command'), ('dehumidifier-command', 'dehumidifier-output');

-- IAQ related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('ventilation-rate', 'air-changes-per-hour'), ('air-changes-per-hour', 'ventilation-rate'),
  ('ventilation-rate', 'ventilation-airflow'), ('ozone-level', 'outdoor-air-quality-index'),
  ('nitrogen-dioxide-level', 'outdoor-air-quality-index'), ('outdoor-air-quality-index', 'ozone-level'),
  ('formaldehyde-level', 'volatile-organic-compounds'), ('radon-level', 'ventilation-rate');

-- Consumption related
INSERT OR IGNORE INTO point_related (point_id, related_point_id) VALUES
  ('water-consumption', 'domestic-hot-water-flow'), ('steam-consumption', 'steam-flow'),
  ('steam-flow', 'steam-consumption'), ('thermal-energy', 'chilled-water-delta-t'),
  ('chilled-water-delta-t', 'thermal-energy'),
  ('escalator-run-status', 'escalator-run-status');

-- ═══════════════════════════════════════════════════════════
-- Additional model-equipment links to boost coverage
-- ═══════════════════════════════════════════════════════════

-- Link sensor models to more equipment types
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES
  ('belimo-22atp-54', 'dedicated-outdoor-air-system'), ('belimo-22atp-54', 'makeup-air-unit'),
  ('belimo-22ahp-34', 'dedicated-outdoor-air-system'), ('belimo-22ahp-34', 'energy-recovery-ventilator'),
  ('belimo-22adp-54t', 'air-handling-unit'), ('belimo-22adp-54t', 'rooftop-unit'),
  ('belimo-af24-sr', 'air-handling-unit'), ('belimo-af24-sr', 'rooftop-unit'),
  ('belimo-b220', 'fan-coil-unit'), ('belimo-b220', 'unit-ventilator'),
  ('belimo-lrb24-3-t', 'fan-coil-unit'), ('belimo-lrb24-3-t', 'chilled-beam'),
  ('honeywell-c7400a', 'rooftop-unit'), ('honeywell-c7400a', 'dedicated-outdoor-air-system'),
  ('honeywell-h7635b', 'air-handling-unit'), ('honeywell-h7635b', 'dedicated-outdoor-air-system'),
  ('honeywell-ml6161a', 'air-handling-unit'), ('honeywell-ml6161a', 'rooftop-unit'),
  ('honeywell-vn-series', 'boiler'), ('honeywell-vn-series', 'chiller'),
  ('honeywell-cdb', 'variable-air-volume-box'), ('honeywell-cdb', 'dedicated-outdoor-air-system'),
  ('honeywell-dp-series', 'variable-air-volume-box'), ('honeywell-dp-series', 'air-handling-unit'),
  ('johnson-controls-te-6300', 'air-handling-unit'), ('johnson-controls-te-6300', 'boiler'),
  ('johnson-controls-va-7480', 'air-handling-unit'), ('johnson-controls-va-7480', 'boiler'),
  ('johnson-controls-d-9100', 'air-handling-unit'), ('johnson-controls-d-9100', 'rooftop-unit'),
  ('schneider-electric-ms41-7103', 'air-handling-unit'), ('schneider-electric-ms41-7103', 'boiler'),
  ('schneider-electric-stb', 'air-handling-unit'), ('schneider-electric-stb', 'rooftop-unit'),
  ('schneider-electric-ma-series', 'air-handling-unit'), ('schneider-electric-ma-series', 'rooftop-unit'),
  ('siemens-gdb161-1e', 'air-handling-unit'), ('siemens-gdb161-1e', 'rooftop-unit'),
  ('siemens-mxg461', 'air-handling-unit'), ('siemens-mxg461', 'boiler'),
  ('siemens-glb-series', 'air-handling-unit'), ('siemens-glb-series', 'rooftop-unit'),
  ('siemens-sat', 'fan-coil-unit'), ('siemens-sat', 'chilled-beam'),
  ('siemens-qbm3020', 'air-handling-unit'), ('siemens-qbm3020', 'variable-air-volume-box'),
  ('trane-xr724', 'rooftop-unit'), ('trane-xr724', 'fan-coil-unit'),
  ('trane-xv80', 'rooftop-unit'), ('trane-xv80', 'air-source-heat-pump'),
  ('veris-cdd', 'air-handling-unit'), ('veris-cdd', 'variable-air-volume-box'),
  ('veris-h200', 'air-handling-unit'), ('veris-h200', 'dedicated-outdoor-air-system'),
  ('veris-px', 'air-handling-unit'), ('veris-px', 'variable-air-volume-box'),
  ('veris-tw2x', 'air-handling-unit'), ('veris-tw2x', 'chiller'),
  ('veris-h8xx', 'dedicated-outdoor-air-system'), ('veris-h8xx', 'energy-recovery-ventilator'),
  ('veris-cdl', 'variable-air-volume-box'), ('veris-cdl', 'air-handling-unit'),
  ('veris-pxu', 'air-handling-unit'), ('veris-pxu', 'rooftop-unit'),
  ('veris-tw', 'boiler'), ('veris-tw', 'rooftop-unit'),
  ('veris-hawkeye', 'electric-meter'), ('veris-hawkeye', 'power-quality-meter'),
  ('automated-logic-zs-pro', 'air-handling-unit'), ('automated-logic-zs-pro', 'rooftop-unit');

-- Link software to building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES
  ('automated-logic-webctrl', 'building-controller'),
  ('automated-logic-webctrl-mobile', 'building-controller'),
  ('delta-controls-orbcad', 'building-controller'),
  ('distech-controls-horyzon-envision', 'building-controller'),
  ('johnson-controls-openblue', 'building-controller'),
  ('trane-ics', 'building-controller');

COMMIT;

BEGIN TRANSACTION;

-- ═══════════════════════════════════════════════════════════
-- PHASE 6b: NEW MODELS (+30, ~3 per brand)
-- ═══════════════════════════════════════════════════════════

-- Automated Logic (+6)
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('automated-logic-optiflex', 'automated-logic', 'unitary-controllers', 'OptiFlex', 'optiflex', 'Compact BACnet controller for fan coil, heat pump, and unit ventilator applications with onboard I/O.', 'current', datetime('now')),
  ('automated-logic-se6104a', 'automated-logic', 'network-controllers', 'SE6104a', 'se6104a', 'Advanced application controller with 12 universal inputs and 8 outputs for AHU and central plant.', 'current', datetime('now')),
  ('automated-logic-me812u', 'automated-logic', 'zone-controllers', 'ME812u', 'me812u', 'Microedge zone controller for VAV, fan coil, and heat pump applications with wireless sensor support.', 'current', datetime('now')),
  ('automated-logic-lge', 'automated-logic', 'gateways', 'LGE', 'lge', 'LonWorks to BACnet gateway for integration of legacy LON-based devices.', 'current', datetime('now')),
  ('automated-logic-webctrl8', 'automated-logic', 'software', 'WebCTRL 8', 'webctrl-8', 'Latest version of the WebCTRL building automation server with HTML5 graphics and advanced analytics.', 'current', datetime('now')),
  ('automated-logic-zn551', 'automated-logic', 'zone-controllers', 'ZN551', 'zn551', 'Wireless-capable zone controller for terminal units with integrated occupancy and temperature sensing.', 'current', datetime('now'));

INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES
  ('automated-logic-optiflex', 'BACnet MSTP'), ('automated-logic-se6104a', 'BACnet IP'),
  ('automated-logic-se6104a', 'BACnet MSTP'), ('automated-logic-me812u', 'BACnet MSTP'),
  ('automated-logic-lge', 'BACnet IP'), ('automated-logic-lge', 'LON'),
  ('automated-logic-zn551', 'BACnet MSTP');

INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES
  ('automated-logic-optiflex', 'fan-coil-unit'), ('automated-logic-optiflex', 'unit-ventilator'),
  ('automated-logic-optiflex', 'water-source-heat-pump'),
  ('automated-logic-se6104a', 'air-handling-unit'), ('automated-logic-se6104a', 'rooftop-unit'),
  ('automated-logic-se6104a', 'chiller'), ('automated-logic-se6104a', 'boiler'),
  ('automated-logic-me812u', 'variable-air-volume-box'), ('automated-logic-me812u', 'fan-coil-unit'),
  ('automated-logic-lge', 'building-controller'),
  ('automated-logic-webctrl8', 'building-controller'),
  ('automated-logic-zn551', 'variable-air-volume-box'), ('automated-logic-zn551', 'fan-coil-unit');

-- Distech Controls (+5)
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('distech-controls-eclypse-acu', 'distech-controls', 'unitary-controllers', 'ECLYPSE ACU', 'eclypse-acu', 'Connected AHU/RTU controller with onboard web server, BACnet/IP, and RESTful API.', 'current', datetime('now')),
  ('distech-controls-eclypse-vav', 'distech-controls', 'vav-controllers', 'ECLYPSE VAV', 'eclypse-vav', 'VAV controller with integrated pressure sensor, actuator output, and optional reheat control.', 'current', datetime('now')),
  ('distech-controls-ec-fav', 'distech-controls', 'zone-controllers', 'EC-FAV', 'ec-fav', 'Fan coil and unit ventilator controller with 6 universal inputs and 4 outputs.', 'current', datetime('now')),
  ('distech-controls-ec-net-ax', 'distech-controls', 'supervisory-controllers', 'EC-Net AX', 'ec-net-ax', 'IP-based supervisory controller running Niagara Framework for multi-protocol integration.', 'current', datetime('now')),
  ('distech-controls-allure-unitouch-dl', 'distech-controls', 'thermostats', 'Allure UNITOUCH-DL', 'allure-unitouch-dl', 'Room touchscreen controller with occupancy, temperature, humidity, and CO2 sensing.', 'current', datetime('now'));

INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES
  ('distech-controls-eclypse-acu', 'BACnet IP'), ('distech-controls-eclypse-acu', 'BACnet MSTP'),
  ('distech-controls-eclypse-vav', 'BACnet MSTP'),
  ('distech-controls-ec-fav', 'BACnet MSTP'),
  ('distech-controls-ec-net-ax', 'BACnet IP'), ('distech-controls-ec-net-ax', 'Modbus TCP'),
  ('distech-controls-allure-unitouch-dl', 'BACnet MSTP');

INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES
  ('distech-controls-eclypse-acu', 'air-handling-unit'), ('distech-controls-eclypse-acu', 'rooftop-unit'),
  ('distech-controls-eclypse-vav', 'variable-air-volume-box'), ('distech-controls-eclypse-vav', 'constant-air-volume-box'),
  ('distech-controls-ec-fav', 'fan-coil-unit'), ('distech-controls-ec-fav', 'unit-ventilator'),
  ('distech-controls-ec-net-ax', 'building-controller'),
  ('distech-controls-allure-unitouch-dl', 'fan-coil-unit'), ('distech-controls-allure-unitouch-dl', 'variable-air-volume-box');

-- Delta Controls (+4)
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('delta-controls-dac-1182', 'delta-controls', 'unitary-controllers', 'DAC-1182', 'dac-1182', 'High-capacity application controller with 18 inputs and 12 outputs for complex mechanical systems.', 'current', datetime('now')),
  ('delta-controls-entelizone', 'delta-controls', 'zone-controllers', 'enteliZONE', 'entelizone', 'Wireless-ready zone controller with integrated sensing for VAV and FCU applications.', 'current', datetime('now')),
  ('delta-controls-ebmgr-core', 'delta-controls', 'supervisory-controllers', 'eBMGR Core', 'ebmgr-core', 'Building management gateway/router with embedded web server and trending.', 'current', datetime('now')),
  ('delta-controls-o3-sensor-r', 'delta-controls', 'zone-controllers', 'O3 Sensor-R', 'o3-sensor-r', 'Room sensor with temperature, humidity, CO2, VOC, and occupancy in a single device.', 'current', datetime('now'));

INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES
  ('delta-controls-dac-1182', 'BACnet IP'), ('delta-controls-dac-1182', 'BACnet MSTP'),
  ('delta-controls-entelizone', 'BACnet MSTP'),
  ('delta-controls-ebmgr-core', 'BACnet IP'), ('delta-controls-ebmgr-core', 'Modbus TCP'),
  ('delta-controls-o3-sensor-r', 'BACnet MSTP');

INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES
  ('delta-controls-dac-1182', 'air-handling-unit'), ('delta-controls-dac-1182', 'chiller'), ('delta-controls-dac-1182', 'boiler'),
  ('delta-controls-entelizone', 'variable-air-volume-box'), ('delta-controls-entelizone', 'fan-coil-unit'),
  ('delta-controls-ebmgr-core', 'building-controller'),
  ('delta-controls-o3-sensor-r', 'variable-air-volume-box'), ('delta-controls-o3-sensor-r', 'fan-coil-unit');

-- Schneider Electric (+3)
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('schneider-electric-smartx-as-b', 'schneider-electric', 'unitary-controllers', 'SmartX AS-B', 'smartx-as-b', 'BACnet application controller for AHU and plant equipment with embedded web server.', 'current', datetime('now')),
  ('schneider-electric-rp-c', 'schneider-electric', 'zone-controllers', 'SpaceLogic RP-C', 'rp-c', 'Room controller for fan coil and VAV with configurable I/O and BACnet MSTP.', 'current', datetime('now')),
  ('schneider-electric-se8600', 'schneider-electric', 'thermostats', 'SE8600 Room Controller', 'se8600', 'Touchscreen room controller with scheduling, setpoint adjustment, and BACnet communication.', 'current', datetime('now'));

INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES
  ('schneider-electric-smartx-as-b', 'BACnet IP'), ('schneider-electric-smartx-as-b', 'BACnet MSTP'),
  ('schneider-electric-rp-c', 'BACnet MSTP'), ('schneider-electric-se8600', 'BACnet MSTP');

INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES
  ('schneider-electric-smartx-as-b', 'air-handling-unit'), ('schneider-electric-smartx-as-b', 'rooftop-unit'),
  ('schneider-electric-rp-c', 'fan-coil-unit'), ('schneider-electric-rp-c', 'variable-air-volume-box'),
  ('schneider-electric-se8600', 'fan-coil-unit'), ('schneider-electric-se8600', 'unit-ventilator');

-- Trane (+3)
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('trane-uc600', 'trane', 'unitary-controllers', 'UC600', 'uc600', 'Programmable unitary controller for RTU, AHU, and chiller plant applications with BACnet.', 'current', datetime('now')),
  ('trane-zn517', 'trane', 'zone-controllers', 'ZN517', 'zn517', 'Zone controller for VAV and fan-powered terminals with integrated pressure sensor.', 'current', datetime('now')),
  ('trane-nexia', 'trane', 'thermostats', 'Nexia Home', 'nexia', 'Connected thermostat with remote access, scheduling, and integration with Trane equipment.', 'current', datetime('now'));

INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES
  ('trane-uc600', 'BACnet IP'), ('trane-uc600', 'BACnet MSTP'),
  ('trane-zn517', 'BACnet MSTP');

INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES
  ('trane-uc600', 'air-handling-unit'), ('trane-uc600', 'rooftop-unit'), ('trane-uc600', 'chiller'),
  ('trane-zn517', 'variable-air-volume-box'), ('trane-zn517', 'parallel-fan-powered-box'),
  ('trane-nexia', 'rooftop-unit'), ('trane-nexia', 'air-source-heat-pump');

-- Honeywell (+1)
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('honeywell-cpc', 'honeywell', 'unitary-controllers', 'CIPer Plant Controller', 'cpc', 'Configurable plant controller for boiler and chiller sequencing with BACnet and LON support.', 'current', datetime('now'));

INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES
  ('honeywell-cpc', 'BACnet IP'), ('honeywell-cpc', 'LON');

INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES
  ('honeywell-cpc', 'boiler'), ('honeywell-cpc', 'chiller'), ('honeywell-cpc', 'cooling-tower');

-- Johnson Controls (+2)
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('johnson-controls-fec', 'johnson-controls', 'unitary-controllers', 'FEC Field Equipment Controller', 'fec', 'Field-level controller for AHU, RTU, and plant equipment with Metasys integration.', 'current', datetime('now')),
  ('johnson-controls-tec3000', 'johnson-controls', 'thermostats', 'TEC3000 Thermostat', 'tec3000', 'Commercial programmable thermostat with BACnet MSTP for rooftop units and fan coils.', 'current', datetime('now'));

INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES
  ('johnson-controls-fec', 'BACnet IP'), ('johnson-controls-fec', 'BACnet MSTP'),
  ('johnson-controls-tec3000', 'BACnet MSTP');

INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES
  ('johnson-controls-fec', 'air-handling-unit'), ('johnson-controls-fec', 'rooftop-unit'),
  ('johnson-controls-tec3000', 'rooftop-unit'), ('johnson-controls-tec3000', 'fan-coil-unit');

-- Siemens (+2)
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('siemens-pxc5', 'siemens', 'network-controllers', 'PXC5.E003', 'pxc5', 'Compact automation station with web server, BACnet/IP, and integrated I/O for mid-size systems.', 'current', datetime('now')),
  ('siemens-rds110', 'siemens', 'thermostats', 'RDS110', 'rds110', 'Smart room thermostat with capacitive touch, scheduling, and BACnet MSTP communication.', 'current', datetime('now'));

INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES
  ('siemens-pxc5', 'BACnet IP'), ('siemens-pxc5', 'BACnet MSTP'),
  ('siemens-rds110', 'BACnet MSTP');

INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES
  ('siemens-pxc5', 'air-handling-unit'), ('siemens-pxc5', 'boiler'), ('siemens-pxc5', 'chiller'),
  ('siemens-rds110', 'fan-coil-unit'), ('siemens-rds110', 'unit-ventilator');

-- Veris (+3)
INSERT OR IGNORE INTO models (id, brand_id, type_id, name, slug, description, status, added_at) VALUES
  ('veris-e50h2', 'veris', 'meters', 'E50H2 Power Meter', 'e50h2', 'Revenue-grade power and energy meter with BACnet IP and Modbus communication for tenant submetering.', 'current', datetime('now')),
  ('veris-cwlp', 'veris', 'occupancy-sensors', 'CWLP Occupancy Sensor', 'cwlp', 'Ceiling-mount passive infrared occupancy sensor with relay output for lighting and HVAC control.', 'current', datetime('now')),
  ('veris-aflp', 'veris', 'pressure-sensors', 'AFLP Air Flow Probe', 'aflp', 'Pitot tube-based airflow measurement station for duct velocity and volume measurement.', 'current', datetime('now'));

INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES
  ('veris-e50h2', 'BACnet IP'), ('veris-e50h2', 'Modbus RTU'), ('veris-e50h2', 'Modbus TCP');

INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES
  ('veris-e50h2', 'electric-meter'), ('veris-e50h2', 'power-quality-meter'), ('veris-e50h2', 'demand-meter'),
  ('veris-cwlp', 'variable-air-volume-box'), ('veris-cwlp', 'fan-coil-unit'),
  ('veris-aflp', 'air-handling-unit'), ('veris-aflp', 'variable-air-volume-box');

-- ═══════════════════════════════════════════════════════════
-- PHASE 2b: MORE SUBTYPES (for remaining 36 equipment)
-- ═══════════════════════════════════════════════════════════

INSERT OR IGNORE INTO equipment_subtypes (equipment_id, subtype_id, subtype_name, description) VALUES
  ('clean-room-ahu', 'iso-7', 'ISO 7 (Class 10,000)', 'Clean room AHU maintaining ISO 7 classification with HEPA filtration'),
  ('clean-room-ahu', 'iso-5', 'ISO 5 (Class 100)', 'Ultra-clean AHU with ULPA filtration for ISO 5 environments'),
  ('data-center-cooling', 'in-row', 'In-Row', 'Placed between server racks for close-coupled cooling'),
  ('data-center-cooling', 'rear-door', 'Rear-Door Heat Exchanger', 'Attached to rear of server rack for passive cooling'),
  ('data-center-cooling', 'overhead', 'Overhead', 'Ceiling-mounted cooling unit for data center spaces'),
  ('server-room-cooling', 'split-system', 'Split System', 'Indoor evaporator unit with remote outdoor condenser'),
  ('server-room-cooling', 'self-contained', 'Self-Contained', 'All-in-one unit with integral condenser'),
  ('condenser-water-pump', 'constant-speed', 'Constant Speed', 'Fixed speed condenser water pump'),
  ('condenser-water-pump', 'variable-speed', 'Variable Speed', 'VFD-controlled condenser water pump for efficiency'),
  ('hot-water-pump', 'constant-speed', 'Constant Speed', 'Fixed speed hot water circulation pump'),
  ('hot-water-pump', 'variable-speed', 'Variable Speed', 'Variable speed hot water pump with VFD'),
  ('primary-chilled-water-pump', 'constant-speed', 'Constant Speed', 'Constant flow primary pump matched to chiller'),
  ('primary-chilled-water-pump', 'variable-speed', 'Variable Speed', 'Variable primary pump eliminating secondary loop'),
  ('secondary-chilled-water-pump', 'variable-speed', 'Variable Speed', 'VFD-controlled to modulate with building load'),
  ('secondary-chilled-water-pump', 'headered', 'Headered', 'Multiple pumps on common header for redundancy'),
  ('steam-pressure-reducing-valve', 'single-stage', 'Single Stage', 'Single valve reducing from high to low pressure'),
  ('steam-pressure-reducing-valve', 'two-stage', 'Two Stage', 'Two valves in series for large pressure drops'),
  ('chemical-treatment-system', 'closed-loop', 'Closed Loop', 'Chemical treatment for closed hydronic systems'),
  ('chemical-treatment-system', 'open-loop', 'Open Loop', 'Treatment for open cooling tower water systems'),
  ('water-treatment-system', 'chemical', 'Chemical', 'Chemical dosing and blowdown control'),
  ('water-treatment-system', 'filtration', 'Filtration', 'Side-stream filtration and water softening'),
  ('glycol-feed-system', 'pressurized', 'Pressurized', 'Pressurized glycol tank with automatic makeup pump'),
  ('glycol-feed-system', 'gravity', 'Gravity', 'Gravity-feed glycol makeup tank'),
  ('relief-fan', 'centrifugal', 'Centrifugal', 'Centrifugal relief fan for higher pressure systems'),
  ('relief-fan', 'axial', 'Axial', 'Propeller-type relief fan for low resistance applications'),
  ('return-fan', 'centrifugal', 'Centrifugal', 'Centrifugal return fan in ducted return systems'),
  ('return-fan', 'plenum', 'Plenum', 'Plenum return fan without scroll housing'),
  ('supply-fan', 'centrifugal', 'Centrifugal', 'Centrifugal supply fan with scroll housing'),
  ('supply-fan', 'plenum', 'Plenum', 'Plug/plenum fan without scroll for AHU applications'),
  ('supply-fan', 'vaneaxial', 'Vaneaxial', 'Vaneaxial fan for inline duct applications'),
  ('kitchen-exhaust-fan', 'upblast', 'Upblast', 'Roof-mounted upblast grease exhaust fan'),
  ('kitchen-exhaust-fan', 'utility-set', 'Utility Set', 'Belt-driven utility fan set for kitchen exhaust'),
  ('garage-exhaust-fan', 'jet-fan', 'Jet Fan', 'Impulse jet fan for garage ventilation without ductwork'),
  ('garage-exhaust-fan', 'axial', 'Axial', 'Ducted axial exhaust for parking garage ventilation'),
  ('dimmer-module', '0-10v', '0-10V', '0-10V analog dimming control'),
  ('dimmer-module', 'dali', 'DALI', 'DALI digital addressable lighting interface'),
  ('lighting-control-panel', 'relay-based', 'Relay Based', 'Mechanically latching relay panel for on/off control'),
  ('lighting-control-panel', 'dimming', 'Dimming', 'Dimming panel with 0-10V or DALI outputs'),
  ('lighting-relay-panel', 'mechanically-held', 'Mechanically Held', 'Latching relays that hold position on power loss'),
  ('lighting-relay-panel', 'electrically-held', 'Electrically Held', 'Relays that default to off on power loss'),
  ('occupancy-lighting-controller', 'pir', 'PIR', 'Passive infrared motion detection'),
  ('occupancy-lighting-controller', 'dual-tech', 'Dual Technology', 'Combined PIR and ultrasonic for reliable detection'),
  ('daylight-sensor', 'open-loop', 'Open Loop', 'Measures exterior daylight for global dimming response'),
  ('daylight-sensor', 'closed-loop', 'Closed Loop', 'Measures interior light level at task height'),
  ('demand-meter', 'thermal', 'Thermal Demand', 'Thermal demand metering with sliding window average'),
  ('demand-meter', 'block-interval', 'Block Interval', 'Block interval demand for utility billing alignment'),
  ('flow-meter', 'electromagnetic', 'Electromagnetic', 'Mag meter for conductive fluids'),
  ('flow-meter', 'ultrasonic', 'Ultrasonic', 'Transit-time ultrasonic for non-invasive measurement'),
  ('flow-meter', 'vortex', 'Vortex', 'Vortex shedding for gas and steam measurement'),
  ('power-quality-meter', 'basic', 'Basic', 'Voltage, current, power, and energy measurement'),
  ('power-quality-meter', 'advanced', 'Advanced', 'Includes harmonics, transients, power quality events'),
  ('thermal-energy-meter', 'ultrasonic', 'Ultrasonic', 'Ultrasonic flow with matched temperature probes'),
  ('thermal-energy-meter', 'electromagnetic', 'Electromagnetic', 'Mag meter based thermal energy calculation'),
  ('condensing-unit-refrigeration', 'scroll', 'Scroll Compressor', 'Scroll compressor condensing unit'),
  ('condensing-unit-refrigeration', 'reciprocating', 'Reciprocating', 'Reciprocating compressor condensing unit'),
  ('reach-in-refrigerator', 'glass-door', 'Glass Door', 'Glass door display refrigerator'),
  ('reach-in-refrigerator', 'solid-door', 'Solid Door', 'Solid door storage refrigerator'),
  ('escalator', 'indoor', 'Indoor', 'Indoor escalator for malls and transit'),
  ('escalator', 'outdoor', 'Outdoor', 'Weather-protected outdoor escalator'),
  ('area-controller', 'standard', 'Standard', 'Standard area controller with fixed I/O'),
  ('area-controller', 'high-density', 'High Density', 'High I/O count area controller for complex zones'),
  ('io-expansion-module', 'analog', 'Analog', 'Analog input/output expansion module'),
  ('io-expansion-module', 'digital', 'Digital', 'Digital input/output expansion module'),
  ('io-expansion-module', 'universal', 'Universal', 'Universal I/O supporting both analog and digital'),
  ('vibration-sensor', 'velocity', 'Velocity', 'Measures vibration velocity in inches per second'),
  ('vibration-sensor', 'acceleration', 'Acceleration', 'Measures vibration acceleration in g-force'),
  ('light-level-sensor', 'indoor', 'Indoor', 'Indoor photosensor for daylight harvesting'),
  ('light-level-sensor', 'outdoor', 'Outdoor', 'Outdoor light sensor for facade/parking control'),
  ('water-leak-detector', 'spot', 'Spot', 'Detects water at a single point location'),
  ('water-leak-detector', 'cable', 'Cable', 'Sensing cable that detects water along its entire length'),
  ('refrigerant-leak-detector', 'infrared', 'Infrared', 'NDIR infrared sensor for refrigerant detection'),
  ('refrigerant-leak-detector', 'semiconductor', 'Semiconductor', 'Metal oxide semiconductor sensor'),
  ('domestic-water-booster-pump', 'constant-speed', 'Constant Speed', 'Fixed speed booster with pressure tank'),
  ('domestic-water-booster-pump', 'variable-speed', 'Variable Speed', 'VFD-controlled booster for constant pressure'),
  ('smoke-control-panel', 'dedicated', 'Dedicated', 'Standalone smoke control system panel'),
  ('smoke-control-panel', 'integrated', 'Integrated', 'Smoke control integrated into fire alarm panel');

COMMIT;
BEGIN TRANSACTION;

-- Auto-generated aliases for points without 5+ aliases
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'air-changes-per-hour', 'air changes per hour', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='air-changes-per-hour' AND alias='air changes per hour');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'air-changes-per-hour', 'changes-per-hour', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='air-changes-per-hour' AND alias='changes-per-hour');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'air-changes-per-hour', 'changes per hour', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='air-changes-per-hour' AND alias='changes per hour');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'air-changes-per-hour', 'acph', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='air-changes-per-hour' AND alias='acph');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-active-status', 'alarm active status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-active-status' AND alias='alarm active status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-active-status', 'alm-active-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-active-status' AND alias='alm-active-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-active-status', 'alm active sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-active-status' AND alias='alm active sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-active-status', 'alrm-active-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-active-status' AND alias='alrm-active-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-active-status', 'aas', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-active-status' AND alias='aas');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-active-status', 'alarm-active-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-active-status' AND alias='alarm-active-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-active-status', 'alm-active-status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-active-status' AND alias='alm-active-status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-active-status', 'alram active status', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-active-status' AND alias='alram active status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-reset-command', 'alarm reset command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-reset-command' AND alias='alarm reset command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-reset-command', 'alm-rst-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-reset-command' AND alias='alm-rst-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-reset-command', 'alm rst cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-reset-command' AND alias='alm rst cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-reset-command', 'alrm-rst-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-reset-command' AND alias='alrm-rst-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-reset-command', 'arc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-reset-command' AND alias='arc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-reset-command', 'alarm-reset-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-reset-command' AND alias='alarm-reset-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-reset-command', 'alm-reset-command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-reset-command' AND alias='alm-reset-command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'alarm-reset-command', 'alram reset command', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='alarm-reset-command' AND alias='alram reset command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ambient-lighting-level', 'ambient lighting level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ambient-lighting-level' AND alias='ambient lighting level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ambient-lighting-level', 'ambient-ltg-level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ambient-lighting-level' AND alias='ambient-ltg-level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ambient-lighting-level', 'ambient ltg level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ambient-lighting-level' AND alias='ambient ltg level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ambient-lighting-level', 'ambient-lite-level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ambient-lighting-level' AND alias='ambient-lite-level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ambient-lighting-level', 'all', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ambient-lighting-level' AND alias='all');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ambient-lighting-level', 'ambient lite level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ambient-lighting-level' AND alias='ambient lite level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'apparent-power-kva', 'apparent power kva', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='apparent-power-kva' AND alias='apparent power kva');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'apparent-power-kva', 'apparent-pwr-kva', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='apparent-power-kva' AND alias='apparent-pwr-kva');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'apparent-power-kva', 'apparent pwr kva', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='apparent-power-kva' AND alias='apparent pwr kva');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'apparent-power-kva', 'apparent-pw-kva', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='apparent-power-kva' AND alias='apparent-pw-kva');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'apparent-power-kva', 'apk', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='apparent-power-kva' AND alias='apk');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'apparent-power-kva', 'apparent pw kva', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='apparent-power-kva' AND alias='apparent pw kva');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'blowdown-flow', 'blowdown flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='blowdown-flow' AND alias='blowdown flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'blowdown-flow', 'bd-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='blowdown-flow' AND alias='bd-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'blowdown-flow', 'bd flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='blowdown-flow' AND alias='bd flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'blowdown-flow', 'bd-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='blowdown-flow' AND alias='bd-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'blowdown-flow', 'bd fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='blowdown-flow' AND alias='bd fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-firing-rate', 'boiler firing rate', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-firing-rate' AND alias='boiler firing rate');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-firing-rate', 'blr-firing-rate', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-firing-rate' AND alias='blr-firing-rate');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-firing-rate', 'blr firing rate', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-firing-rate' AND alias='blr firing rate');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-firing-rate', 'boi-firing-rate', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-firing-rate' AND alias='boi-firing-rate');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-firing-rate', 'bfr', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-firing-rate' AND alias='bfr');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-firing-rate', 'boi firing rate', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-firing-rate' AND alias='boi firing rate');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-pressure', 'boiler pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-pressure' AND alias='boiler pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-pressure', 'blr-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-pressure' AND alias='blr-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-pressure', 'blr press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-pressure' AND alias='blr press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-pressure', 'boi-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-pressure' AND alias='boi-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-pressure', 'boiler-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-pressure' AND alias='boiler-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-pressure', 'boiler presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-pressure' AND alias='boiler presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-pressure', 'boi prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-pressure' AND alias='boi prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'boiler-pressure', 'boiler press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='boiler-pressure' AND alias='boiler press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'building-power-demand', 'building power demand', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='building-power-demand' AND alias='building power demand');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'building-power-demand', 'bldg-pwr-dmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='building-power-demand' AND alias='bldg-pwr-dmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'building-power-demand', 'bldg pwr dmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='building-power-demand' AND alias='bldg pwr dmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'building-power-demand', 'bld-pw-dmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='building-power-demand' AND alias='bld-pw-dmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'building-power-demand', 'bpd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='building-power-demand' AND alias='bpd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'building-power-demand', 'bld pw dmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='building-power-demand' AND alias='bld pw dmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-closed', 'bypass damper closed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-closed' AND alias='bypass damper closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-closed', 'byp-dmpr-closed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-closed' AND alias='byp-dmpr-closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-closed', 'byp dmpr closed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-closed' AND alias='byp dmpr closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-closed', 'bp-dmp-closed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-closed' AND alias='bp-dmp-closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-closed', 'bdc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-closed' AND alias='bdc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-closed', 'bypass dampner closed', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-closed' AND alias='bypass dampner closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-closed', 'bp dmp closed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-closed' AND alias='bp dmp closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-command', 'bypass damper command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-command' AND alias='bypass damper command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-command', 'byp-dmpr-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-command' AND alias='byp-dmpr-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-command', 'byp dmpr cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-command' AND alias='byp dmpr cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-command', 'bp-dmp-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-command' AND alias='bp-dmp-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-command', 'bdc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-command' AND alias='bdc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-command', 'bypass-damper-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-command' AND alias='bypass-damper-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-command', 'bypass dampner command', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-command' AND alias='bypass dampner command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-command', 'bp dmp com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-command' AND alias='bp dmp com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-feedback', 'bypass damper feedback', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-feedback' AND alias='bypass damper feedback');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-feedback', 'byp-dmpr-fbk', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-feedback' AND alias='byp-dmpr-fbk');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-feedback', 'byp dmpr fbk', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-feedback' AND alias='byp dmpr fbk');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-feedback', 'bp-dmp-fb', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-feedback' AND alias='bp-dmp-fb');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-feedback', 'bdf', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-feedback' AND alias='bdf');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-feedback', 'bypass dampner feedback', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-feedback' AND alias='bypass dampner feedback');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-feedback', 'bp dmp fb', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-feedback' AND alias='bp dmp fb');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-open', 'bypass damper open', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-open' AND alias='bypass damper open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-open', 'byp-dmpr-open', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-open' AND alias='byp-dmpr-open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-open', 'byp dmpr open', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-open' AND alias='byp dmpr open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-open', 'bp-dmp-open', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-open' AND alias='bp-dmp-open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-open', 'bdo', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-open' AND alias='bdo');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-open', 'bypass dampner open', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-open' AND alias='bypass dampner open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-open', 'bp dmp open', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-open' AND alias='bp dmp open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-output', 'bypass damper output', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-output' AND alias='bypass damper output');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-output', 'byp-dmpr-out', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-output' AND alias='byp-dmpr-out');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-output', 'byp dmpr out', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-output' AND alias='byp dmpr out');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-output', 'bp-dmp-ao', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-output' AND alias='bp-dmp-ao');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-output', 'bdo', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-output' AND alias='bdo');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-output', 'bypass dampner output', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-output' AND alias='bypass dampner output');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-output', 'bp dmp ao', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-output' AND alias='bp dmp ao');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-position', 'bypass damper position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-position' AND alias='bypass damper position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-position', 'byp-dmpr-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-position' AND alias='byp-dmpr-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-position', 'byp dmpr pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-position' AND alias='byp dmpr pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-position', 'bp-dmp-psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-position' AND alias='bp-dmp-psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-position', 'bdp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-position' AND alias='bdp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-position', 'bypass-damper-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-position' AND alias='bypass-damper-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-position', 'bypass dampner position', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-position' AND alias='bypass dampner position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-damper-position', 'bp dmp psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-damper-position' AND alias='bp dmp psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-flow', 'bypass flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-flow' AND alias='bypass flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-flow', 'byp-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-flow' AND alias='byp-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-flow', 'byp flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-flow' AND alias='byp flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-flow', 'bp-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-flow' AND alias='bp-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'bypass-flow', 'bp fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='bypass-flow' AND alias='bp fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'case-temperature', 'case temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='case-temperature' AND alias='case temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'case-temperature', 'case-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='case-temperature' AND alias='case-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'case-temperature', 'case temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='case-temperature' AND alias='case temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'case-temperature', 'case-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='case-temperature' AND alias='case-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'case-temperature', 'case temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='case-temperature' AND alias='case temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'case-temperature', 'case t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='case-temperature' AND alias='case t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ceiling-plenum-temperature', 'ceiling plenum temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ceiling-plenum-temperature' AND alias='ceiling plenum temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ceiling-plenum-temperature', 'ceiling-plenum-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ceiling-plenum-temperature' AND alias='ceiling-plenum-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ceiling-plenum-temperature', 'ceiling plenum temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ceiling-plenum-temperature' AND alias='ceiling plenum temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ceiling-plenum-temperature', 'ceiling-plenum-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ceiling-plenum-temperature' AND alias='ceiling-plenum-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ceiling-plenum-temperature', 'cpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ceiling-plenum-temperature' AND alias='cpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ceiling-plenum-temperature', 'ceiling plenum temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ceiling-plenum-temperature' AND alias='ceiling plenum temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ceiling-plenum-temperature', 'ceiling plenum t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ceiling-plenum-temperature' AND alias='ceiling plenum t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-delta-t', 'chilled water delta t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-delta-t' AND alias='chilled water delta t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-delta-t', 'chw-wtr-diff-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-delta-t' AND alias='chw-wtr-diff-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-delta-t', 'chw wtr diff t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-delta-t' AND alias='chw wtr diff t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-delta-t', 'chl-w-dt-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-delta-t' AND alias='chl-w-dt-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-delta-t', 'cwdt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-delta-t' AND alias='cwdt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-delta-t', 'chw-delta-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-delta-t' AND alias='chw-delta-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-delta-t', 'chl w dt t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-delta-t' AND alias='chl w dt t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-delta-t', 'chw delta t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-delta-t' AND alias='chw delta t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-pressure', 'chilled water pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-pressure' AND alias='chilled water pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-pressure', 'chw-wtr-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-pressure' AND alias='chw-wtr-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-pressure', 'chw wtr press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-pressure' AND alias='chw wtr press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-pressure', 'chl-w-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-pressure' AND alias='chl-w-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-pressure', 'cwp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-pressure' AND alias='cwp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-pressure', 'chw-pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-pressure' AND alias='chw-pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-pressure', 'chilled-water-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-pressure' AND alias='chilled-water-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-pressure', 'chilled water presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-pressure' AND alias='chilled water presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-temperature-reset-setpoint', 'chilled water temperature reset setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-temperature-reset-setpoint' AND alias='chilled water temperature reset setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-temperature-reset-setpoint', 'chw-wtr-temp-rst-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-temperature-reset-setpoint' AND alias='chw-wtr-temp-rst-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-temperature-reset-setpoint', 'chw wtr temp rst sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-temperature-reset-setpoint' AND alias='chw wtr temp rst sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-temperature-reset-setpoint', 'chl-w-t-rst-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-temperature-reset-setpoint' AND alias='chl-w-t-rst-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-temperature-reset-setpoint', 'cwtrs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-temperature-reset-setpoint' AND alias='cwtrs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-temperature-reset-setpoint', 'chw-temperature-reset-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-temperature-reset-setpoint' AND alias='chw-temperature-reset-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-temperature-reset-setpoint', 'chilled-water-temp-reset-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-temperature-reset-setpoint' AND alias='chilled-water-temp-reset-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-temperature-reset-setpoint', 'chilled-water-temperature-reset-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-temperature-reset-setpoint' AND alias='chilled-water-temperature-reset-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-command', 'chilled water valve command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-command' AND alias='chilled water valve command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-command', 'chw-wtr-vlv-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-command' AND alias='chw-wtr-vlv-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-command', 'chw wtr vlv cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-command' AND alias='chw wtr vlv cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-command', 'chl-w-vv-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-command' AND alias='chl-w-vv-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-command', 'cwvc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-command' AND alias='cwvc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-command', 'chw-valve-command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-command' AND alias='chw-valve-command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-command', 'chilled-water-valve-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-command' AND alias='chilled-water-valve-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-command', 'chilled water vlv command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-command' AND alias='chilled water vlv command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-position', 'chilled water valve position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-position' AND alias='chilled water valve position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-position', 'chw-wtr-vlv-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-position' AND alias='chw-wtr-vlv-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-position', 'chw wtr vlv pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-position' AND alias='chw wtr vlv pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-position', 'chl-w-vv-psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-position' AND alias='chl-w-vv-psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-position', 'cwvp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-position' AND alias='cwvp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-position', 'chw-valve-position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-position' AND alias='chw-valve-position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-position', 'chilled-water-valve-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-position' AND alias='chilled-water-valve-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chilled-water-valve-position', 'chilled water vlv position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chilled-water-valve-position' AND alias='chilled water vlv position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-cop', 'chiller cop', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-cop' AND alias='chiller cop');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-cop', 'chlr-cop', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-cop' AND alias='chlr-cop');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-cop', 'chlr cop', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-cop' AND alias='chlr cop');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-cop', 'ch-cop', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-cop' AND alias='ch-cop');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-cop', 'ch cop', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-cop' AND alias='ch cop');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-entering-condenser-water-temperature', 'chiller entering condenser water temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-entering-condenser-water-temperature' AND alias='chiller entering condenser water temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-entering-condenser-water-temperature', 'chlr-entering-cw-wtr-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-entering-condenser-water-temperature' AND alias='chlr-entering-cw-wtr-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-entering-condenser-water-temperature', 'chlr entering cw wtr temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-entering-condenser-water-temperature' AND alias='chlr entering cw wtr temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-entering-condenser-water-temperature', 'ch-entering-cnd-w-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-entering-condenser-water-temperature' AND alias='ch-entering-cnd-w-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-entering-condenser-water-temperature', 'cecwt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-entering-condenser-water-temperature' AND alias='cecwt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-entering-condenser-water-temperature', 'chiller-entering-cw-temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-entering-condenser-water-temperature' AND alias='chiller-entering-cw-temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-entering-condenser-water-temperature', 'chiller-entering-condenser-water-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-entering-condenser-water-temperature' AND alias='chiller-entering-condenser-water-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-entering-condenser-water-temperature', 'chiller entering condenser water temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-entering-condenser-water-temperature' AND alias='chiller entering condenser water temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-kw-per-ton', 'chiller kw per ton', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-kw-per-ton' AND alias='chiller kw per ton');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-kw-per-ton', 'chlr-kw-per-ton', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-kw-per-ton' AND alias='chlr-kw-per-ton');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-kw-per-ton', 'chlr kw per ton', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-kw-per-ton' AND alias='chlr kw per ton');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-kw-per-ton', 'ch-kw-per-ton', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-kw-per-ton' AND alias='ch-kw-per-ton');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-kw-per-ton', 'ckpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-kw-per-ton' AND alias='ckpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-kw-per-ton', 'ch kw per ton', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-kw-per-ton' AND alias='ch kw per ton');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-leaving-condenser-water-temperature', 'chiller leaving condenser water temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-leaving-condenser-water-temperature' AND alias='chiller leaving condenser water temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-leaving-condenser-water-temperature', 'chlr-leaving-cw-wtr-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-leaving-condenser-water-temperature' AND alias='chlr-leaving-cw-wtr-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-leaving-condenser-water-temperature', 'chlr leaving cw wtr temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-leaving-condenser-water-temperature' AND alias='chlr leaving cw wtr temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-leaving-condenser-water-temperature', 'ch-leaving-cnd-w-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-leaving-condenser-water-temperature' AND alias='ch-leaving-cnd-w-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-leaving-condenser-water-temperature', 'clcwt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-leaving-condenser-water-temperature' AND alias='clcwt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-leaving-condenser-water-temperature', 'chiller-leaving-cw-temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-leaving-condenser-water-temperature' AND alias='chiller-leaving-cw-temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-leaving-condenser-water-temperature', 'chiller-leaving-condenser-water-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-leaving-condenser-water-temperature' AND alias='chiller-leaving-condenser-water-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'chiller-leaving-condenser-water-temperature', 'chiller leaving condenser water temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='chiller-leaving-condenser-water-temperature' AND alias='chiller leaving condenser water temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co-alarm-setpoint', 'co alarm setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co-alarm-setpoint' AND alias='co alarm setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co-alarm-setpoint', 'carbon monoxide-alm-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co-alarm-setpoint' AND alias='carbon monoxide-alm-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co-alarm-setpoint', 'carbon monoxide alm sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co-alarm-setpoint' AND alias='carbon monoxide alm sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co-alarm-setpoint', 'carbon monoxide-alrm-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co-alarm-setpoint' AND alias='carbon monoxide-alrm-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co-alarm-setpoint', 'cas', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co-alarm-setpoint' AND alias='cas');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co-alarm-setpoint', 'co-alarm-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co-alarm-setpoint' AND alias='co-alarm-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co-alarm-setpoint', 'co-alm-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co-alarm-setpoint' AND alias='co-alm-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co-alarm-setpoint', 'co alram setpoint', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co-alarm-setpoint' AND alias='co alram setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co-level', 'co level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co-level' AND alias='co level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co-level', 'carbon monoxide-level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co-level' AND alias='carbon monoxide-level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co-level', 'carbon monoxide level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co-level' AND alias='carbon monoxide level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co2-ventilation-setpoint', 'co2 ventilation setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co2-ventilation-setpoint' AND alias='co2 ventilation setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co2-ventilation-setpoint', 'carbon dioxide-vent-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co2-ventilation-setpoint' AND alias='carbon dioxide-vent-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co2-ventilation-setpoint', 'carbon dioxide vent sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co2-ventilation-setpoint' AND alias='carbon dioxide vent sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co2-ventilation-setpoint', 'carbon dioxide-vntl-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co2-ventilation-setpoint' AND alias='carbon dioxide-vntl-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co2-ventilation-setpoint', 'cvs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co2-ventilation-setpoint' AND alias='cvs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co2-ventilation-setpoint', 'co2-ventilation-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co2-ventilation-setpoint' AND alias='co2-ventilation-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co2-ventilation-setpoint', 'carbon dioxide vntl stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co2-ventilation-setpoint' AND alias='carbon dioxide vntl stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'co2-ventilation-setpoint', 'co2 ventilation sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='co2-ventilation-setpoint' AND alias='co2 ventilation sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-command', 'compressor command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-command' AND alias='compressor command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-command', 'comp-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-command' AND alias='comp-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-command', 'comp cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-command' AND alias='comp cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-command', 'cmp-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-command' AND alias='cmp-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-command', 'compressor-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-command' AND alias='compressor-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-command', 'compresser command', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-command' AND alias='compresser command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-command', 'cmp com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-command' AND alias='cmp com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-command', 'compressor cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-command' AND alias='compressor cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-discharge-temperature', 'compressor discharge temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-discharge-temperature' AND alias='compressor discharge temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-discharge-temperature', 'comp-da-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-discharge-temperature' AND alias='comp-da-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-discharge-temperature', 'comp da temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-discharge-temperature' AND alias='comp da temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-discharge-temperature', 'cmp-disch-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-discharge-temperature' AND alias='cmp-disch-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-discharge-temperature', 'cdt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-discharge-temperature' AND alias='cdt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-discharge-temperature', 'compressor-discharge-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-discharge-temperature' AND alias='compressor-discharge-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-discharge-temperature', 'compressor discharge temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-discharge-temperature' AND alias='compressor discharge temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-discharge-temperature', 'compresser discharge temperature', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-discharge-temperature' AND alias='compresser discharge temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage', 'compressor stage', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage' AND alias='compressor stage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage', 'comp-stage', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage' AND alias='comp-stage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage', 'comp stage', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage' AND alias='comp stage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage', 'cmp-stage', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage' AND alias='cmp-stage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage', 'compresser stage', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage' AND alias='compresser stage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage', 'cmp stage', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage' AND alias='cmp stage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage-command', 'compressor stage command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage-command' AND alias='compressor stage command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage-command', 'comp-stage-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage-command' AND alias='comp-stage-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage-command', 'comp stage cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage-command' AND alias='comp stage cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage-command', 'cmp-stage-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage-command' AND alias='cmp-stage-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage-command', 'csc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage-command' AND alias='csc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage-command', 'compressor-stage-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage-command' AND alias='compressor-stage-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage-command', 'compresser stage command', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage-command' AND alias='compresser stage command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-stage-command', 'cmp stage com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-stage-command' AND alias='cmp stage com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-status', 'compressor status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-status' AND alias='compressor status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-status', 'comp-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-status' AND alias='comp-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-status', 'comp sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-status' AND alias='comp sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-status', 'cmp-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-status' AND alias='cmp-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-status', 'compressor-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-status' AND alias='compressor-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-status', 'compresser status', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-status' AND alias='compresser status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-status', 'cmp stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-status' AND alias='cmp stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-status', 'compressor sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-status' AND alias='compressor sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-suction-temperature', 'compressor suction temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-suction-temperature' AND alias='compressor suction temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-suction-temperature', 'comp-suc-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-suction-temperature' AND alias='comp-suc-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-suction-temperature', 'comp suc temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-suction-temperature' AND alias='comp suc temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-suction-temperature', 'cmp-suc-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-suction-temperature' AND alias='cmp-suc-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-suction-temperature', 'cst', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-suction-temperature' AND alias='cst');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-suction-temperature', 'compressor-suction-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-suction-temperature' AND alias='compressor-suction-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-suction-temperature', 'compressor suction temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-suction-temperature' AND alias='compressor suction temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'compressor-suction-temperature', 'compresser suction temperature', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='compressor-suction-temperature' AND alias='compresser suction temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condensate-flow', 'condensate flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condensate-flow' AND alias='condensate flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condensate-flow', 'cond-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condensate-flow' AND alias='cond-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condensate-flow', 'cond flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condensate-flow' AND alias='cond flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condensate-flow', 'cond-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condensate-flow' AND alias='cond-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condensate-flow', 'cond fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condensate-flow' AND alias='cond fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-approach-temperature', 'condenser approach temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-approach-temperature' AND alias='condenser approach temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-approach-temperature', 'cw-approach-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-approach-temperature' AND alias='cw-approach-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-approach-temperature', 'cw approach temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-approach-temperature' AND alias='cw approach temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-approach-temperature', 'cnd-approach-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-approach-temperature' AND alias='cnd-approach-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-approach-temperature', 'cat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-approach-temperature' AND alias='cat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-approach-temperature', 'condenser-approach-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-approach-temperature' AND alias='condenser-approach-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-approach-temperature', 'condenser approach temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-approach-temperature' AND alias='condenser approach temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-approach-temperature', 'cnd approach t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-approach-temperature' AND alias='cnd approach t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-pressure', 'condenser pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-pressure' AND alias='condenser pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-pressure', 'cw-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-pressure' AND alias='cw-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-pressure', 'cw press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-pressure' AND alias='cw press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-pressure', 'cnd-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-pressure' AND alias='cnd-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-pressure', 'condenser-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-pressure' AND alias='condenser-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-pressure', 'condenser presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-pressure' AND alias='condenser presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-pressure', 'cnd prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-pressure' AND alias='cnd prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-pressure', 'condenser press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-pressure' AND alias='condenser press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-temperature', 'condenser temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-temperature' AND alias='condenser temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-temperature', 'cw-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-temperature' AND alias='cw-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-temperature', 'cw temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-temperature' AND alias='cw temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-temperature', 'cnd-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-temperature' AND alias='cnd-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-temperature', 'condenser-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-temperature' AND alias='condenser-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-temperature', 'condenser temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-temperature' AND alias='condenser temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-temperature', 'cnd t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-temperature' AND alias='cnd t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-temperature', 'condenser temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-temperature' AND alias='condenser temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure', 'condenser water differential pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure' AND alias='condenser water differential pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure', 'cw-wtr-diff-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure' AND alias='cw-wtr-diff-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure', 'cw wtr diff press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure' AND alias='cw wtr diff press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure', 'cnd-w-dp-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure' AND alias='cnd-w-dp-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure', 'cwdp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure' AND alias='cwdp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure', 'cw-differential-pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure' AND alias='cw-differential-pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure', 'condenser-water-differential-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure' AND alias='condenser-water-differential-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure', 'condenser-water-dp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure' AND alias='condenser-water-dp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure-setpoint', 'condenser water differential pressure setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure-setpoint' AND alias='condenser water differential pressure setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure-setpoint', 'cw-wtr-diff-press-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure-setpoint' AND alias='cw-wtr-diff-press-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure-setpoint', 'cw wtr diff press sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure-setpoint' AND alias='cw wtr diff press sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure-setpoint', 'cnd-w-dp-prs-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure-setpoint' AND alias='cnd-w-dp-prs-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure-setpoint', 'cwdps', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure-setpoint' AND alias='cwdps');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure-setpoint', 'cw-differential-pressure-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure-setpoint' AND alias='cw-differential-pressure-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure-setpoint', 'condenser-water-differential-pressure-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure-setpoint' AND alias='condenser-water-differential-pressure-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-differential-pressure-setpoint', 'condenser-water-differential-press-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-differential-pressure-setpoint' AND alias='condenser-water-differential-press-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-pump-command-bool', 'condenser water pump command bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-pump-command-bool' AND alias='condenser water pump command bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-pump-command-bool', 'cw-wtr-pmp-cmd-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-pump-command-bool' AND alias='cw-wtr-pmp-cmd-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-pump-command-bool', 'cw wtr pmp cmd bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-pump-command-bool' AND alias='cw wtr pmp cmd bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-pump-command-bool', 'cnd-w-pp-com-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-pump-command-bool' AND alias='cnd-w-pp-com-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-pump-command-bool', 'cwpcb', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-pump-command-bool' AND alias='cwpcb');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-pump-command-bool', 'cw-pump-command-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-pump-command-bool' AND alias='cw-pump-command-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-pump-command-bool', 'condenser-water-pump-cmd-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-pump-command-bool' AND alias='condenser-water-pump-cmd-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-pump-command-bool', 'cnd w pp com bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-pump-command-bool' AND alias='cnd w pp com bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-command', 'condenser water valve command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-command' AND alias='condenser water valve command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-command', 'cw-wtr-vlv-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-command' AND alias='cw-wtr-vlv-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-command', 'cw wtr vlv cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-command' AND alias='cw wtr vlv cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-command', 'cnd-w-vv-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-command' AND alias='cnd-w-vv-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-command', 'cwvc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-command' AND alias='cwvc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-command', 'cw-valve-command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-command' AND alias='cw-valve-command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-command', 'condenser-water-valve-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-command' AND alias='condenser-water-valve-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-command', 'condenser water vlv command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-command' AND alias='condenser water vlv command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-position', 'condenser water valve position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-position' AND alias='condenser water valve position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-position', 'cw-wtr-vlv-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-position' AND alias='cw-wtr-vlv-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-position', 'cw wtr vlv pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-position' AND alias='cw wtr vlv pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-position', 'cnd-w-vv-psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-position' AND alias='cnd-w-vv-psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-position', 'cwvp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-position' AND alias='cwvp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-position', 'cw-valve-position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-position' AND alias='cw-valve-position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-position', 'condenser-water-valve-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-position' AND alias='condenser-water-valve-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'condenser-water-valve-position', 'condenser water vlv position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='condenser-water-valve-position' AND alias='condenser water vlv position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-degree-days', 'cooling degree days', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-degree-days' AND alias='cooling degree days');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-degree-days', 'clg-degree-days', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-degree-days' AND alias='clg-degree-days');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-degree-days', 'clg degree days', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-degree-days' AND alias='clg degree days');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-degree-days', 'cool-degree-days', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-degree-days' AND alias='cool-degree-days');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-degree-days', 'cdd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-degree-days' AND alias='cdd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-degree-days', 'cool degree days', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-degree-days' AND alias='cool degree days');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-approach-setpoint', 'cooling tower approach setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-approach-setpoint' AND alias='cooling tower approach setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-approach-setpoint', 'clg-twr-approach-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-approach-setpoint' AND alias='clg-twr-approach-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-approach-setpoint', 'clg twr approach sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-approach-setpoint' AND alias='clg twr approach sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-approach-setpoint', 'cool-tw-approach-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-approach-setpoint' AND alias='cool-tw-approach-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-approach-setpoint', 'ctas', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-approach-setpoint' AND alias='ctas');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-approach-setpoint', 'ct-approach-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-approach-setpoint' AND alias='ct-approach-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-approach-setpoint', 'cooling-tower-approach-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-approach-setpoint' AND alias='cooling-tower-approach-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-approach-setpoint', 'cool tw approach stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-approach-setpoint' AND alias='cool tw approach stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-command', 'cooling tower fan command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-command' AND alias='cooling tower fan command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-command', 'clg-twr-fn-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-command' AND alias='clg-twr-fn-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-command', 'clg twr fn cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-command' AND alias='clg twr fn cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-command', 'cool-tw-fn-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-command' AND alias='cool-tw-fn-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-command', 'ctfc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-command' AND alias='ctfc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-command', 'ct-fan-command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-command' AND alias='ct-fan-command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-command', 'cooling-tower-fan-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-command' AND alias='cooling-tower-fan-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-command', 'cool tw fn com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-command' AND alias='cool tw fn com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-speed', 'cooling tower fan speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-speed' AND alias='cooling tower fan speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-speed', 'clg-twr-fn-spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-speed' AND alias='clg-twr-fn-spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-speed', 'clg twr fn spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-speed' AND alias='clg twr fn spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-speed', 'cool-tw-fn-spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-speed' AND alias='cool-tw-fn-spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-speed', 'ctfs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-speed' AND alias='ctfs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-speed', 'ct-fan-speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-speed' AND alias='ct-fan-speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-speed', 'cool tw fn spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-speed' AND alias='cool tw fn spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-speed', 'ct fan speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-speed' AND alias='ct fan speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-status', 'cooling tower fan status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-status' AND alias='cooling tower fan status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-status', 'clg-twr-fn-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-status' AND alias='clg-twr-fn-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-status', 'clg twr fn sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-status' AND alias='clg twr fn sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-status', 'cool-tw-fn-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-status' AND alias='cool-tw-fn-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-status', 'ctfs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-status' AND alias='ctfs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-status', 'ct-fan-status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-status' AND alias='ct-fan-status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-status', 'cooling-tower-fan-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-status' AND alias='cooling-tower-fan-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-status', 'cool tw fn stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-status' AND alias='cool tw fn stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-vfd-speed', 'cooling tower fan vfd speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-vfd-speed' AND alias='cooling tower fan vfd speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-vfd-speed', 'clg-twr-fn-drive-spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-vfd-speed' AND alias='clg-twr-fn-drive-spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-vfd-speed', 'clg twr fn drive spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-vfd-speed' AND alias='clg twr fn drive spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-vfd-speed', 'cool-tw-fn-variable frequency-spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-vfd-speed' AND alias='cool-tw-fn-variable frequency-spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-vfd-speed', 'ctfvs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-vfd-speed' AND alias='ctfvs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-vfd-speed', 'ct-fan-vfd-speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-vfd-speed' AND alias='ct-fan-vfd-speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-vfd-speed', 'cool tw fn variable frequency spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-vfd-speed' AND alias='cool tw fn variable frequency spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-fan-vfd-speed', 'ct fan vfd speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-fan-vfd-speed' AND alias='ct fan vfd speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-water-flow', 'cooling tower water flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-water-flow' AND alias='cooling tower water flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-water-flow', 'clg-twr-wtr-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-water-flow' AND alias='clg-twr-wtr-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-water-flow', 'clg twr wtr flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-water-flow' AND alias='clg twr wtr flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-water-flow', 'cool-tw-w-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-water-flow' AND alias='cool-tw-w-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-water-flow', 'ctwf', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-water-flow' AND alias='ctwf');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-water-flow', 'ct-water-flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-water-flow' AND alias='ct-water-flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-water-flow', 'cool tw w fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-water-flow' AND alias='cool tw w fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'cooling-tower-water-flow', 'ct water flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='cooling-tower-water-flow' AND alias='ct water flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-a', 'current phase a', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-a' AND alias='current phase a');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-a', 'amp-phase-a', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-a' AND alias='amp-phase-a');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-a', 'amp phase a', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-a' AND alias='amp phase a');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-a', 'cur-phase-a', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-a' AND alias='cur-phase-a');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-a', 'cpa', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-a' AND alias='cpa');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-a', 'cur phase a', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-a' AND alias='cur phase a');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-b', 'current phase b', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-b' AND alias='current phase b');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-b', 'amp-phase-b', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-b' AND alias='amp-phase-b');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-b', 'amp phase b', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-b' AND alias='amp phase b');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-b', 'cur-phase-b', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-b' AND alias='cur-phase-b');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-b', 'cpb', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-b' AND alias='cpb');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-b', 'cur phase b', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-b' AND alias='cur phase b');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-c', 'current phase c', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-c' AND alias='current phase c');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-c', 'amp-phase-c', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-c' AND alias='amp-phase-c');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-c', 'amp phase c', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-c' AND alias='amp phase c');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-c', 'cur-phase-c', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-c' AND alias='cur-phase-c');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-c', 'cpc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-c' AND alias='cpc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'current-phase-c', 'cur phase c', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='current-phase-c' AND alias='cur phase c');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-command', 'defrost command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-command' AND alias='defrost command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-command', 'dfst-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-command' AND alias='dfst-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-command', 'dfst cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-command' AND alias='dfst cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-command', 'def-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-command' AND alias='def-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-command', 'defrost-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-command' AND alias='defrost-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-command', 'def com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-command' AND alias='def com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-command', 'defrost cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-command' AND alias='defrost cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-status', 'defrost status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-status' AND alias='defrost status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-status', 'dfst-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-status' AND alias='dfst-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-status', 'dfst sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-status' AND alias='dfst sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-status', 'def-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-status' AND alias='def-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-status', 'defrost-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-status' AND alias='defrost-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-status', 'def stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-status' AND alias='def stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'defrost-status', 'defrost sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='defrost-status' AND alias='defrost sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidification-status', 'dehumidification status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidification-status' AND alias='dehumidification status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidification-status', 'dehumidification-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidification-status' AND alias='dehumidification-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidification-status', 'dehumidification sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidification-status' AND alias='dehumidification sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidification-status', 'dehumidification-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidification-status' AND alias='dehumidification-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidification-status', 'dehumidification stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidification-status' AND alias='dehumidification stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-command', 'dehumidifier command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-command' AND alias='dehumidifier command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-command', 'dehumidifier-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-command' AND alias='dehumidifier-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-command', 'dehumidifier cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-command' AND alias='dehumidifier cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-command', 'dehumidifier-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-command' AND alias='dehumidifier-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-command', 'dehumidifier com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-command' AND alias='dehumidifier com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-output', 'dehumidifier output', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-output' AND alias='dehumidifier output');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-output', 'dehumidifier-out', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-output' AND alias='dehumidifier-out');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-output', 'dehumidifier out', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-output' AND alias='dehumidifier out');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-output', 'dehumidifier-ao', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-output' AND alias='dehumidifier-ao');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-output', 'dehumidifier ao', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-output' AND alias='dehumidifier ao');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-status', 'dehumidifier status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-status' AND alias='dehumidifier status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-status', 'dehumidifier-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-status' AND alias='dehumidifier-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-status', 'dehumidifier sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-status' AND alias='dehumidifier sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-status', 'dehumidifier-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-status' AND alias='dehumidifier-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dehumidifier-status', 'dehumidifier stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dehumidifier-status' AND alias='dehumidifier stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-command', 'demand limit command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-command' AND alias='demand limit command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-command', 'dmd-limit-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-command' AND alias='dmd-limit-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-command', 'dmd limit cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-command' AND alias='dmd limit cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-command', 'dmd-limit-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-command' AND alias='dmd-limit-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-command', 'dlc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-command' AND alias='dlc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-command', 'demand-limit-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-command' AND alias='demand-limit-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-command', 'dmd limit com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-command' AND alias='dmd limit com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-command', 'demand limit cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-command' AND alias='demand limit cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-setpoint', 'demand limit setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-setpoint' AND alias='demand limit setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-setpoint', 'dmd-limit-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-setpoint' AND alias='dmd-limit-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-setpoint', 'dmd limit sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-setpoint' AND alias='dmd limit sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-setpoint', 'dmd-limit-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-setpoint' AND alias='dmd-limit-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-setpoint', 'dls', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-setpoint' AND alias='dls');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-setpoint', 'demand-limit-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-setpoint' AND alias='demand-limit-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-setpoint', 'dmd limit stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-setpoint' AND alias='dmd limit stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-limit-setpoint', 'demand limit sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-limit-setpoint' AND alias='demand limit sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-power', 'demand power', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-power' AND alias='demand power');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-power', 'dmd-pwr', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-power' AND alias='dmd-pwr');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-power', 'dmd pwr', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-power' AND alias='dmd pwr');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-power', 'dmd-pw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-power' AND alias='dmd-pw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'demand-power', 'dmd pw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='demand-power' AND alias='dmd pw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dimming-level-command', 'dimming level command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dimming-level-command' AND alias='dimming level command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dimming-level-command', 'dimming-level-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dimming-level-command' AND alias='dimming-level-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dimming-level-command', 'dimming level cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dimming-level-command' AND alias='dimming level cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dimming-level-command', 'dimming-level-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dimming-level-command' AND alias='dimming-level-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dimming-level-command', 'dlc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dimming-level-command' AND alias='dlc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'dimming-level-command', 'dimming level com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='dimming-level-command' AND alias='dimming level com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'discharge-air-temperature-reset-setpoint', 'discharge air temperature reset setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='discharge-air-temperature-reset-setpoint' AND alias='discharge air temperature reset setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'discharge-air-temperature-reset-setpoint', 'da-temp-rst-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='discharge-air-temperature-reset-setpoint' AND alias='da-temp-rst-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'discharge-air-temperature-reset-setpoint', 'da temp rst sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='discharge-air-temperature-reset-setpoint' AND alias='da temp rst sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'discharge-air-temperature-reset-setpoint', 'disch-t-rst-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='discharge-air-temperature-reset-setpoint' AND alias='disch-t-rst-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'discharge-air-temperature-reset-setpoint', 'datrs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='discharge-air-temperature-reset-setpoint' AND alias='datrs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'discharge-air-temperature-reset-setpoint', 'da-temperature-reset-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='discharge-air-temperature-reset-setpoint' AND alias='da-temperature-reset-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'discharge-air-temperature-reset-setpoint', 'discharge-air-temp-reset-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='discharge-air-temperature-reset-setpoint' AND alias='discharge-air-temp-reset-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'discharge-air-temperature-reset-setpoint', 'discharge-air-temperature-reset-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='discharge-air-temperature-reset-setpoint' AND alias='discharge-air-temperature-reset-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-hot-water-flow', 'domestic hot water flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-hot-water-flow' AND alias='domestic hot water flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-hot-water-flow', 'dom-hw-wtr-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-hot-water-flow' AND alias='dom-hw-wtr-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-hot-water-flow', 'dom hw wtr flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-hot-water-flow' AND alias='dom hw wtr flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-hot-water-flow', 'dhw-ht-w-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-hot-water-flow' AND alias='dhw-ht-w-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-hot-water-flow', 'dhwf', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-hot-water-flow' AND alias='dhwf');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-hot-water-flow', 'domestic-hw-flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-hot-water-flow' AND alias='domestic-hw-flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-hot-water-flow', 'dhw ht w fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-hot-water-flow' AND alias='dhw ht w fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-hot-water-flow', 'domestic hw flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-hot-water-flow' AND alias='domestic hw flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-water-temperature', 'domestic water temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-water-temperature' AND alias='domestic water temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-water-temperature', 'dom-wtr-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-water-temperature' AND alias='dom-wtr-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-water-temperature', 'dom wtr temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-water-temperature' AND alias='dom wtr temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-water-temperature', 'dhw-w-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-water-temperature' AND alias='dhw-w-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-water-temperature', 'dwt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-water-temperature' AND alias='dwt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-water-temperature', 'domestic-water-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-water-temperature' AND alias='domestic-water-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-water-temperature', 'domestic water temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-water-temperature' AND alias='domestic water temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'domestic-water-temperature', 'dhw w t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='domestic-water-temperature' AND alias='dhw w t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'duct-static-pressure-reset-setpoint', 'duct static pressure reset setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='duct-static-pressure-reset-setpoint' AND alias='duct static pressure reset setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'duct-static-pressure-reset-setpoint', 'duct-stat-press-rst-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='duct-static-pressure-reset-setpoint' AND alias='duct-stat-press-rst-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'duct-static-pressure-reset-setpoint', 'duct stat press rst sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='duct-static-pressure-reset-setpoint' AND alias='duct stat press rst sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'duct-static-pressure-reset-setpoint', 'duct-stc-prs-rst-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='duct-static-pressure-reset-setpoint' AND alias='duct-stc-prs-rst-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'duct-static-pressure-reset-setpoint', 'dsprs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='duct-static-pressure-reset-setpoint' AND alias='dsprs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'duct-static-pressure-reset-setpoint', 'duct-static-pressure-reset-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='duct-static-pressure-reset-setpoint' AND alias='duct-static-pressure-reset-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'duct-static-pressure-reset-setpoint', 'duct-static-press-reset-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='duct-static-pressure-reset-setpoint' AND alias='duct-static-press-reset-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'duct-static-pressure-reset-setpoint', 'duct static presure reset setpoint', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='duct-static-pressure-reset-setpoint' AND alias='duct static presure reset setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-high-limit-setpoint', 'economizer high limit setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-high-limit-setpoint' AND alias='economizer high limit setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-high-limit-setpoint', 'econ-high-limit-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-high-limit-setpoint' AND alias='econ-high-limit-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-high-limit-setpoint', 'econ high limit sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-high-limit-setpoint' AND alias='econ high limit sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-high-limit-setpoint', 'eco-high-limit-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-high-limit-setpoint' AND alias='eco-high-limit-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-high-limit-setpoint', 'ehls', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-high-limit-setpoint' AND alias='ehls');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-high-limit-setpoint', 'economizer-high-limit-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-high-limit-setpoint' AND alias='economizer-high-limit-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-high-limit-setpoint', 'eco high limit stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-high-limit-setpoint' AND alias='eco high limit stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-high-limit-setpoint', 'economizer high limit sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-high-limit-setpoint' AND alias='economizer high limit sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-status', 'economizer status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-status' AND alias='economizer status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-status', 'econ-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-status' AND alias='econ-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-status', 'econ sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-status' AND alias='econ sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-status', 'eco-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-status' AND alias='eco-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-status', 'economizer-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-status' AND alias='economizer-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-status', 'eco stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-status' AND alias='eco stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'economizer-status', 'economizer sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='economizer-status' AND alias='economizer sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-alarm', 'elevator alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-alarm' AND alias='elevator alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-alarm', 'elev-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-alarm' AND alias='elev-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-alarm', 'elev alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-alarm' AND alias='elev alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-alarm', 'elv-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-alarm' AND alias='elv-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-alarm', 'elevator-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-alarm' AND alias='elevator-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-alarm', 'elevator alram', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-alarm' AND alias='elevator alram');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-alarm', 'elv alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-alarm' AND alias='elv alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-alarm', 'elevator alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-alarm' AND alias='elevator alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-run-status', 'elevator run status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-run-status' AND alias='elevator run status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-run-status', 'elev-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-run-status' AND alias='elev-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-run-status', 'elev sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-run-status' AND alias='elev sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-run-status', 'elv-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-run-status' AND alias='elv-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-run-status', 'ers', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-run-status' AND alias='ers');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-run-status', 'elevator-run-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-run-status' AND alias='elevator-run-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-run-status', 'elv stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-run-status' AND alias='elv stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'elevator-run-status', 'elevator run sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='elevator-run-status' AND alias='elevator run sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-lighting-status', 'emergency lighting status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-lighting-status' AND alias='emergency lighting status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-lighting-status', 'emerg-ltg-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-lighting-status' AND alias='emerg-ltg-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-lighting-status', 'emerg ltg sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-lighting-status' AND alias='emerg ltg sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-lighting-status', 'emer-lite-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-lighting-status' AND alias='emer-lite-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-lighting-status', 'els', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-lighting-status' AND alias='els');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-lighting-status', 'emergency-lighting-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-lighting-status' AND alias='emergency-lighting-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-lighting-status', 'emer lite stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-lighting-status' AND alias='emer lite stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-lighting-status', 'emergency lighting sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-lighting-status' AND alias='emergency lighting sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-power-status', 'emergency power status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-power-status' AND alias='emergency power status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-power-status', 'emerg-pwr-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-power-status' AND alias='emerg-pwr-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-power-status', 'emerg pwr sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-power-status' AND alias='emerg pwr sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-power-status', 'emer-pw-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-power-status' AND alias='emer-pw-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-power-status', 'eps', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-power-status' AND alias='eps');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-power-status', 'emergency-power-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-power-status' AND alias='emergency-power-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-power-status', 'emer pw stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-power-status' AND alias='emer pw stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'emergency-power-status', 'emergency power sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='emergency-power-status' AND alias='emergency power sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'energy-use-intensity', 'energy use intensity', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='energy-use-intensity' AND alias='energy use intensity');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'energy-use-intensity', 'nrg-use-intensity', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='energy-use-intensity' AND alias='nrg-use-intensity');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'energy-use-intensity', 'nrg use intensity', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='energy-use-intensity' AND alias='nrg use intensity');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'energy-use-intensity', 'eui', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='energy-use-intensity' AND alias='eui');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'equipment-isolation-command', 'equipment isolation command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='equipment-isolation-command' AND alias='equipment isolation command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'equipment-isolation-command', 'equipment-iso-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='equipment-isolation-command' AND alias='equipment-iso-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'equipment-isolation-command', 'equipment iso cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='equipment-isolation-command' AND alias='equipment iso cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'equipment-isolation-command', 'equipment-iso-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='equipment-isolation-command' AND alias='equipment-iso-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'equipment-isolation-command', 'eic', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='equipment-isolation-command' AND alias='eic');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'equipment-isolation-command', 'equipment-isolation-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='equipment-isolation-command' AND alias='equipment-isolation-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'equipment-isolation-command', 'equipment iso com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='equipment-isolation-command' AND alias='equipment iso com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'equipment-isolation-command', 'equipment isolation cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='equipment-isolation-command' AND alias='equipment isolation cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'escalator-run-status', 'escalator run status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='escalator-run-status' AND alias='escalator run status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'escalator-run-status', 'esc-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='escalator-run-status' AND alias='esc-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'escalator-run-status', 'esc sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='escalator-run-status' AND alias='esc sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'escalator-run-status', 'esc-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='escalator-run-status' AND alias='esc-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'escalator-run-status', 'ers', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='escalator-run-status' AND alias='ers');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'escalator-run-status', 'escalator-run-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='escalator-run-status' AND alias='escalator-run-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'escalator-run-status', 'esc stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='escalator-run-status' AND alias='esc stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'escalator-run-status', 'escalator run sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='escalator-run-status' AND alias='escalator run sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-approach-temperature', 'evaporator approach temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-approach-temperature' AND alias='evaporator approach temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-approach-temperature', 'evaporator-approach-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-approach-temperature' AND alias='evaporator-approach-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-approach-temperature', 'evaporator approach temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-approach-temperature' AND alias='evaporator approach temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-approach-temperature', 'evaporator-approach-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-approach-temperature' AND alias='evaporator-approach-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-approach-temperature', 'eat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-approach-temperature' AND alias='eat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-approach-temperature', 'evaporator approach temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-approach-temperature' AND alias='evaporator approach temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-approach-temperature', 'evaporator approach t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-approach-temperature' AND alias='evaporator approach t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-temperature', 'evaporator temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-temperature' AND alias='evaporator temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-temperature', 'evaporator-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-temperature' AND alias='evaporator-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-temperature', 'evaporator temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-temperature' AND alias='evaporator temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-temperature', 'evaporator-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-temperature' AND alias='evaporator-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-temperature', 'evaporator temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-temperature' AND alias='evaporator temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'evaporator-temperature', 'evaporator t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='evaporator-temperature' AND alias='evaporator t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-damper-command', 'exhaust air damper command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-damper-command' AND alias='exhaust air damper command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-damper-command', 'ea-dmpr-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-damper-command' AND alias='ea-dmpr-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-damper-command', 'ea dmpr cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-damper-command' AND alias='ea dmpr cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-damper-command', 'exh-dmp-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-damper-command' AND alias='exh-dmp-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-damper-command', 'eadc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-damper-command' AND alias='eadc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-damper-command', 'ea-damper-command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-damper-command' AND alias='ea-damper-command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-damper-command', 'exhaust-air-damper-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-damper-command' AND alias='exhaust-air-damper-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-damper-command', 'exhaust air dampner command', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-damper-command' AND alias='exhaust air dampner command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-static-pressure', 'exhaust air static pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-static-pressure' AND alias='exhaust air static pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-static-pressure', 'ea-stat-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-static-pressure' AND alias='ea-stat-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-static-pressure', 'ea stat press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-static-pressure' AND alias='ea stat press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-static-pressure', 'exh-stc-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-static-pressure' AND alias='exh-stc-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-static-pressure', 'easp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-static-pressure' AND alias='easp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-static-pressure', 'ea-static-pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-static-pressure' AND alias='ea-static-pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-static-pressure', 'exhaust-air-static-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-static-pressure' AND alias='exhaust-air-static-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-air-static-pressure', 'exhaust air static presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-air-static-pressure' AND alias='exhaust air static presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-airflow-setpoint', 'exhaust airflow setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-airflow-setpoint' AND alias='exhaust airflow setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-airflow-setpoint', 'ea-airflow-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-airflow-setpoint' AND alias='ea-airflow-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-airflow-setpoint', 'ea airflow sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-airflow-setpoint' AND alias='ea airflow sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-airflow-setpoint', 'exh-airflow-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-airflow-setpoint' AND alias='exh-airflow-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-airflow-setpoint', 'eas', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-airflow-setpoint' AND alias='eas');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-airflow-setpoint', 'eaflow-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-airflow-setpoint' AND alias='eaflow-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-airflow-setpoint', 'exhaust-airflow-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-airflow-setpoint' AND alias='exhaust-airflow-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-airflow-setpoint', 'exaust airflow setpoint', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-airflow-setpoint' AND alias='exaust airflow setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-command-bool', 'exhaust fan command bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-command-bool' AND alias='exhaust fan command bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-command-bool', 'ea-fn-cmd-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-command-bool' AND alias='ea-fn-cmd-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-command-bool', 'ea fn cmd bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-command-bool' AND alias='ea fn cmd bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-command-bool', 'exh-fn-com-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-command-bool' AND alias='exh-fn-com-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-command-bool', 'efcb', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-command-bool' AND alias='efcb');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-command-bool', 'ef-command-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-command-bool' AND alias='ef-command-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-command-bool', 'exhaust-fan-cmd-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-command-bool' AND alias='exhaust-fan-cmd-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-command-bool', 'exaust fan command bool', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-command-bool' AND alias='exaust fan command bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-status-bool', 'exhaust fan status bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-status-bool' AND alias='exhaust fan status bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-status-bool', 'ea-fn-sts-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-status-bool' AND alias='ea-fn-sts-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-status-bool', 'ea fn sts bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-status-bool' AND alias='ea fn sts bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-status-bool', 'exh-fn-stat-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-status-bool' AND alias='exh-fn-stat-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-status-bool', 'efsb', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-status-bool' AND alias='efsb');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-status-bool', 'ef-status-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-status-bool' AND alias='ef-status-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-status-bool', 'exhaust-fan-sts-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-status-bool' AND alias='exhaust-fan-sts-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-status-bool', 'exaust fan status bool', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-status-bool' AND alias='exaust fan status bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-vfd-speed', 'exhaust fan vfd speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-vfd-speed' AND alias='exhaust fan vfd speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-vfd-speed', 'ea-fn-drive-spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-vfd-speed' AND alias='ea-fn-drive-spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-vfd-speed', 'ea fn drive spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-vfd-speed' AND alias='ea fn drive spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-vfd-speed', 'exh-fn-variable frequency-spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-vfd-speed' AND alias='exh-fn-variable frequency-spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-vfd-speed', 'efvs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-vfd-speed' AND alias='efvs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-vfd-speed', 'ef-vfd-speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-vfd-speed' AND alias='ef-vfd-speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-vfd-speed', 'exaust fan vfd speed', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-vfd-speed' AND alias='exaust fan vfd speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exhaust-fan-vfd-speed', 'exh fn variable frequency spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exhaust-fan-vfd-speed' AND alias='exh fn variable frequency spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-command', 'exterior lighting command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-command' AND alias='exterior lighting command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-command', 'exterior-ltg-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-command' AND alias='exterior-ltg-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-command', 'exterior ltg cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-command' AND alias='exterior ltg cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-command', 'exterior-lite-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-command' AND alias='exterior-lite-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-command', 'elc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-command' AND alias='elc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-command', 'exterior-lighting-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-command' AND alias='exterior-lighting-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-command', 'exterior lite com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-command' AND alias='exterior lite com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-command', 'exterior lighting cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-command' AND alias='exterior lighting cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-status', 'exterior lighting status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-status' AND alias='exterior lighting status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-status', 'exterior-ltg-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-status' AND alias='exterior-ltg-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-status', 'exterior ltg sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-status' AND alias='exterior ltg sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-status', 'exterior-lite-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-status' AND alias='exterior-lite-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-status', 'els', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-status' AND alias='els');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-status', 'exterior-lighting-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-status' AND alias='exterior-lighting-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-status', 'exterior lite stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-status' AND alias='exterior lite stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'exterior-lighting-status', 'exterior lighting sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='exterior-lighting-status' AND alias='exterior lighting sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-position', 'fire damper position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-position' AND alias='fire damper position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-position', 'fr-dmpr-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-position' AND alias='fr-dmpr-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-position', 'fr dmpr pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-position' AND alias='fr dmpr pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-position', 'fr-dmp-psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-position' AND alias='fr-dmp-psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-position', 'fdp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-position' AND alias='fdp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-position', 'fire-damper-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-position' AND alias='fire-damper-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-position', 'fire dampner position', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-position' AND alias='fire dampner position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-position', 'fr dmp psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-position' AND alias='fr dmp psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-status', 'fire damper status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-status' AND alias='fire damper status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-status', 'fr-dmpr-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-status' AND alias='fr-dmpr-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-status', 'fr dmpr sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-status' AND alias='fr dmpr sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-status', 'fr-dmp-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-status' AND alias='fr-dmp-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-status', 'fds', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-status' AND alias='fds');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-status', 'fire-damper-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-status' AND alias='fire-damper-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-status', 'fire dampner status', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-status' AND alias='fire dampner status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-damper-status', 'fr dmp stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-damper-status' AND alias='fr dmp stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-mode-status', 'fire mode status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-mode-status' AND alias='fire mode status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-mode-status', 'fr-mode-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-mode-status' AND alias='fr-mode-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-mode-status', 'fr mode sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-mode-status' AND alias='fr mode sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-mode-status', 'fr-mode-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-mode-status' AND alias='fr-mode-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-mode-status', 'fms', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-mode-status' AND alias='fms');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-mode-status', 'fire-mode-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-mode-status' AND alias='fire-mode-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-mode-status', 'fr mode stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-mode-status' AND alias='fr mode stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-mode-status', 'fire mode sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-mode-status' AND alias='fire mode sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-suppression-status', 'fire suppression status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-suppression-status' AND alias='fire suppression status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-suppression-status', 'fr-suppression-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-suppression-status' AND alias='fr-suppression-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-suppression-status', 'fr suppression sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-suppression-status' AND alias='fr suppression sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-suppression-status', 'fr-suppression-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-suppression-status' AND alias='fr-suppression-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-suppression-status', 'fss', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-suppression-status' AND alias='fss');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-suppression-status', 'fire-suppression-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-suppression-status' AND alias='fire-suppression-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-suppression-status', 'fr suppression stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-suppression-status' AND alias='fr suppression stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'fire-suppression-status', 'fire suppression sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='fire-suppression-status' AND alias='fire suppression sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'flue-gas-temperature', 'flue gas temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='flue-gas-temperature' AND alias='flue gas temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'flue-gas-temperature', 'flue-gs-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='flue-gas-temperature' AND alias='flue-gs-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'flue-gas-temperature', 'flue gs temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='flue-gas-temperature' AND alias='flue gs temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'flue-gas-temperature', 'flue-gs-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='flue-gas-temperature' AND alias='flue-gs-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'flue-gas-temperature', 'fgt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='flue-gas-temperature' AND alias='fgt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'flue-gas-temperature', 'flue-gas-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='flue-gas-temperature' AND alias='flue-gas-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'flue-gas-temperature', 'flue gas temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='flue-gas-temperature' AND alias='flue gas temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'flue-gas-temperature', 'flue gs t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='flue-gas-temperature' AND alias='flue gs t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'formaldehyde-level', 'formaldehyde level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='formaldehyde-level' AND alias='formaldehyde level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'free-cooling-status', 'free cooling status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='free-cooling-status' AND alias='free cooling status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'free-cooling-status', 'free-clg-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='free-cooling-status' AND alias='free-clg-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'free-cooling-status', 'free clg sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='free-cooling-status' AND alias='free clg sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'free-cooling-status', 'free-cool-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='free-cooling-status' AND alias='free-cool-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'free-cooling-status', 'fcs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='free-cooling-status' AND alias='fcs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'free-cooling-status', 'free-cooling-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='free-cooling-status' AND alias='free-cooling-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'free-cooling-status', 'free cool stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='free-cooling-status' AND alias='free cool stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'free-cooling-status', 'free cooling sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='free-cooling-status' AND alias='free cooling sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-alarm', 'freeze protection alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-alarm' AND alias='freeze protection alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-alarm', 'frz-protection-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-alarm' AND alias='frz-protection-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-alarm', 'frz protection alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-alarm' AND alias='frz protection alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-alarm', 'frz-protection-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-alarm' AND alias='frz-protection-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-alarm', 'fpa', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-alarm' AND alias='fpa');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-alarm', 'freeze-protection-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-alarm' AND alias='freeze-protection-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-alarm', 'freeze protection alram', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-alarm' AND alias='freeze protection alram');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-alarm', 'frz protection alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-alarm' AND alias='frz protection alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-command', 'freeze protection command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-command' AND alias='freeze protection command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-command', 'frz-protection-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-command' AND alias='frz-protection-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-command', 'frz protection cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-command' AND alias='frz protection cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-command', 'frz-protection-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-command' AND alias='frz-protection-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-command', 'fpc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-command' AND alias='fpc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-command', 'freeze-protection-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-command' AND alias='freeze-protection-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-command', 'frz protection com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-command' AND alias='frz protection com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-protection-command', 'freeze protection cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-protection-command' AND alias='freeze protection cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-stat-status', 'freeze stat status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-stat-status' AND alias='freeze stat status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-stat-status', 'frz-stat-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-stat-status' AND alias='frz-stat-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-stat-status', 'frz stat sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-stat-status' AND alias='frz stat sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-stat-status', 'frz-stat-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-stat-status' AND alias='frz-stat-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-stat-status', 'fss', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-stat-status' AND alias='fss');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-stat-status', 'freeze-stat-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-stat-status' AND alias='freeze-stat-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-stat-status', 'frz stat stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-stat-status' AND alias='frz stat stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'freeze-stat-status', 'freeze stat sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='freeze-stat-status' AND alias='freeze stat sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-command', 'garage exhaust fan command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-command' AND alias='garage exhaust fan command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-command', 'garage-ea-fn-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-command' AND alias='garage-ea-fn-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-command', 'garage ea fn cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-command' AND alias='garage ea fn cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-command', 'garage-exh-fn-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-command' AND alias='garage-exh-fn-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-command', 'gefc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-command' AND alias='gefc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-command', 'garage-ef-command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-command' AND alias='garage-ef-command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-command', 'garage-exhaust-fan-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-command' AND alias='garage-exhaust-fan-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-command', 'garage exaust fan command', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-command' AND alias='garage exaust fan command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-status', 'garage exhaust fan status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-status' AND alias='garage exhaust fan status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-status', 'garage-ea-fn-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-status' AND alias='garage-ea-fn-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-status', 'garage ea fn sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-status' AND alias='garage ea fn sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-status', 'garage-exh-fn-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-status' AND alias='garage-exh-fn-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-status', 'gefs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-status' AND alias='gefs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-status', 'garage-ef-status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-status' AND alias='garage-ef-status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-status', 'garage-exhaust-fan-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-status' AND alias='garage-exhaust-fan-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'garage-exhaust-fan-status', 'garage exaust fan status', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='garage-exhaust-fan-status' AND alias='garage exaust fan status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-flow', 'gas flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-flow' AND alias='gas flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-flow', 'gs-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-flow' AND alias='gs-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-flow', 'gs flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-flow' AND alias='gs flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-flow', 'gs-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-flow' AND alias='gs-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-flow', 'gs fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-flow' AND alias='gs fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-pressure', 'gas pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-pressure' AND alias='gas pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-pressure', 'gs-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-pressure' AND alias='gs-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-pressure', 'gs press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-pressure' AND alias='gs press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-pressure', 'gs-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-pressure' AND alias='gs-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-pressure', 'gas-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-pressure' AND alias='gas-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-pressure', 'gas presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-pressure' AND alias='gas presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-pressure', 'gs prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-pressure' AND alias='gs prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'gas-pressure', 'gas press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='gas-pressure' AND alias='gas press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-alarm', 'generator alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-alarm' AND alias='generator alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-alarm', 'gen-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-alarm' AND alias='gen-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-alarm', 'gen alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-alarm' AND alias='gen alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-alarm', 'gen-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-alarm' AND alias='gen-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-alarm', 'generator-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-alarm' AND alias='generator-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-alarm', 'generator alram', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-alarm' AND alias='generator alram');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-alarm', 'gen alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-alarm' AND alias='gen alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-alarm', 'generator alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-alarm' AND alias='generator alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-run-status', 'generator run status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-run-status' AND alias='generator run status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-run-status', 'gen-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-run-status' AND alias='gen-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-run-status', 'gen sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-run-status' AND alias='gen sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-run-status', 'gen-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-run-status' AND alias='gen-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-run-status', 'grs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-run-status' AND alias='grs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-run-status', 'generator-run-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-run-status' AND alias='generator-run-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-run-status', 'gen stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-run-status' AND alias='gen stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'generator-run-status', 'generator run sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='generator-run-status' AND alias='generator run sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'glycol-flow', 'glycol flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='glycol-flow' AND alias='glycol flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'glycol-flow', 'gly-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='glycol-flow' AND alias='gly-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'glycol-flow', 'gly flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='glycol-flow' AND alias='gly flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'glycol-flow', 'gly-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='glycol-flow' AND alias='gly-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'glycol-flow', 'gly fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='glycol-flow' AND alias='gly fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ground-water-temperature', 'ground water temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ground-water-temperature' AND alias='ground water temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ground-water-temperature', 'ground-wtr-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ground-water-temperature' AND alias='ground-wtr-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ground-water-temperature', 'ground wtr temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ground-water-temperature' AND alias='ground wtr temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ground-water-temperature', 'ground-w-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ground-water-temperature' AND alias='ground-w-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ground-water-temperature', 'gwt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ground-water-temperature' AND alias='gwt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ground-water-temperature', 'ground-water-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ground-water-temperature' AND alias='ground-water-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ground-water-temperature', 'ground water temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ground-water-temperature' AND alias='ground water temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ground-water-temperature', 'ground w t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ground-water-temperature' AND alias='ground w t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'head-pressure', 'head pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='head-pressure' AND alias='head pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'head-pressure', 'head-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='head-pressure' AND alias='head-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'head-pressure', 'head press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='head-pressure' AND alias='head press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'head-pressure', 'head-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='head-pressure' AND alias='head-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'head-pressure', 'head presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='head-pressure' AND alias='head presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'head-pressure', 'head prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='head-pressure' AND alias='head prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heat-exchanger-leaving-temperature', 'heat exchanger leaving temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heat-exchanger-leaving-temperature' AND alias='heat exchanger leaving temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heat-exchanger-leaving-temperature', 'heat-exchanger-leaving-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heat-exchanger-leaving-temperature' AND alias='heat-exchanger-leaving-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heat-exchanger-leaving-temperature', 'heat exchanger leaving temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heat-exchanger-leaving-temperature' AND alias='heat exchanger leaving temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heat-exchanger-leaving-temperature', 'heat-exchanger-leaving-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heat-exchanger-leaving-temperature' AND alias='heat-exchanger-leaving-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heat-exchanger-leaving-temperature', 'helt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heat-exchanger-leaving-temperature' AND alias='helt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heat-exchanger-leaving-temperature', 'heat exchanger leaving temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heat-exchanger-leaving-temperature' AND alias='heat exchanger leaving temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heat-exchanger-leaving-temperature', 'heat exchanger leaving t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heat-exchanger-leaving-temperature' AND alias='heat exchanger leaving t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heating-degree-days', 'heating degree days', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heating-degree-days' AND alias='heating degree days');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heating-degree-days', 'htg-degree-days', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heating-degree-days' AND alias='htg-degree-days');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heating-degree-days', 'htg degree days', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heating-degree-days' AND alias='htg degree days');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heating-degree-days', 'heat-degree-days', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heating-degree-days' AND alias='heat-degree-days');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heating-degree-days', 'hdd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heating-degree-days' AND alias='hdd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'heating-degree-days', 'heat degree days', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='heating-degree-days' AND alias='heat degree days');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-co2-alarm', 'high co2 alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-co2-alarm' AND alias='high co2 alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-co2-alarm', 'high-carbon dioxide-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-co2-alarm' AND alias='high-carbon dioxide-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-co2-alarm', 'high carbon dioxide alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-co2-alarm' AND alias='high carbon dioxide alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-co2-alarm', 'high-carbon dioxide-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-co2-alarm' AND alias='high-carbon dioxide-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-co2-alarm', 'hca', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-co2-alarm' AND alias='hca');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-co2-alarm', 'high-co2-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-co2-alarm' AND alias='high-co2-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-co2-alarm', 'high co2 alram', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-co2-alarm' AND alias='high co2 alram');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-co2-alarm', 'high carbon dioxide alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-co2-alarm' AND alias='high carbon dioxide alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-condenser-pressure-alarm', 'high condenser pressure alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-condenser-pressure-alarm' AND alias='high condenser pressure alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-condenser-pressure-alarm', 'high-cw-press-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-condenser-pressure-alarm' AND alias='high-cw-press-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-condenser-pressure-alarm', 'high cw press alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-condenser-pressure-alarm' AND alias='high cw press alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-condenser-pressure-alarm', 'high-cnd-prs-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-condenser-pressure-alarm' AND alias='high-cnd-prs-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-condenser-pressure-alarm', 'hcpa', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-condenser-pressure-alarm' AND alias='hcpa');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-condenser-pressure-alarm', 'high-condenser-pressure-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-condenser-pressure-alarm' AND alias='high-condenser-pressure-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-condenser-pressure-alarm', 'high-condenser-press-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-condenser-pressure-alarm' AND alias='high-condenser-press-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-condenser-pressure-alarm', 'high condenser presure alarm', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-condenser-pressure-alarm' AND alias='high condenser presure alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-discharge-air-temperature-alarm', 'high discharge air temperature alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-discharge-air-temperature-alarm' AND alias='high discharge air temperature alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-discharge-air-temperature-alarm', 'high-da-temp-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-discharge-air-temperature-alarm' AND alias='high-da-temp-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-discharge-air-temperature-alarm', 'high da temp alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-discharge-air-temperature-alarm' AND alias='high da temp alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-discharge-air-temperature-alarm', 'high-disch-t-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-discharge-air-temperature-alarm' AND alias='high-disch-t-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-discharge-air-temperature-alarm', 'hdata', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-discharge-air-temperature-alarm' AND alias='hdata');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-discharge-air-temperature-alarm', 'high-da-temperature-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-discharge-air-temperature-alarm' AND alias='high-da-temperature-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-discharge-air-temperature-alarm', 'high-discharge-air-temp-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-discharge-air-temperature-alarm' AND alias='high-discharge-air-temp-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-discharge-air-temperature-alarm', 'high-discharge-air-temperature-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-discharge-air-temperature-alarm' AND alias='high-discharge-air-temperature-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-duct-static-pressure-alarm', 'high duct static pressure alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-duct-static-pressure-alarm' AND alias='high duct static pressure alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-duct-static-pressure-alarm', 'high-duct-stat-press-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-duct-static-pressure-alarm' AND alias='high-duct-stat-press-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-duct-static-pressure-alarm', 'high duct stat press alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-duct-static-pressure-alarm' AND alias='high duct stat press alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-duct-static-pressure-alarm', 'high-duct-stc-prs-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-duct-static-pressure-alarm' AND alias='high-duct-stc-prs-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-duct-static-pressure-alarm', 'hdspa', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-duct-static-pressure-alarm' AND alias='hdspa');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-duct-static-pressure-alarm', 'high-duct-static-pressure-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-duct-static-pressure-alarm' AND alias='high-duct-static-pressure-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-duct-static-pressure-alarm', 'high-duct-static-press-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-duct-static-pressure-alarm' AND alias='high-duct-static-press-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-duct-static-pressure-alarm', 'high duct static presure alarm', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-duct-static-pressure-alarm' AND alias='high duct static presure alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-humidity-alarm', 'high humidity alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-humidity-alarm' AND alias='high humidity alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-humidity-alarm', 'high-hum-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-humidity-alarm' AND alias='high-hum-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-humidity-alarm', 'high hum alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-humidity-alarm' AND alias='high hum alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-humidity-alarm', 'high-rh-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-humidity-alarm' AND alias='high-rh-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-humidity-alarm', 'hha', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-humidity-alarm' AND alias='hha');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-humidity-alarm', 'high-humidity-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-humidity-alarm' AND alias='high-humidity-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-humidity-alarm', 'high-hum-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-humidity-alarm' AND alias='high-hum-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-humidity-alarm', 'high humidty alarm', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-humidity-alarm' AND alias='high humidty alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-limit-status', 'high limit status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-limit-status' AND alias='high limit status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-limit-status', 'high-limit-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-limit-status' AND alias='high-limit-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-limit-status', 'high limit sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-limit-status' AND alias='high limit sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-limit-status', 'high-limit-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-limit-status' AND alias='high-limit-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-limit-status', 'hls', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-limit-status' AND alias='hls');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-limit-status', 'high limit stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-limit-status' AND alias='high limit stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-zone-temperature-alarm', 'high zone temperature alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-zone-temperature-alarm' AND alias='high zone temperature alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-zone-temperature-alarm', 'high-zn-temp-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-zone-temperature-alarm' AND alias='high-zn-temp-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-zone-temperature-alarm', 'high zn temp alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-zone-temperature-alarm' AND alias='high zn temp alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-zone-temperature-alarm', 'high-z-t-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-zone-temperature-alarm' AND alias='high-z-t-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-zone-temperature-alarm', 'hzta', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-zone-temperature-alarm' AND alias='hzta');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-zone-temperature-alarm', 'high-zat-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-zone-temperature-alarm' AND alias='high-zat-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-zone-temperature-alarm', 'high-zone-temp-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-zone-temperature-alarm' AND alias='high-zone-temp-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'high-zone-temperature-alarm', 'high-zone-temperature-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='high-zone-temperature-alarm' AND alias='high-zone-temperature-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-delta-t', 'hot water delta t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-delta-t' AND alias='hot water delta t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-delta-t', 'hw-wtr-diff-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-delta-t' AND alias='hw-wtr-diff-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-delta-t', 'hw wtr diff t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-delta-t' AND alias='hw wtr diff t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-delta-t', 'ht-w-dt-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-delta-t' AND alias='ht-w-dt-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-delta-t', 'hwdt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-delta-t' AND alias='hwdt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-delta-t', 'hw-delta-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-delta-t' AND alias='hw-delta-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-delta-t', 'ht w dt t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-delta-t' AND alias='ht w dt t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-delta-t', 'hw delta t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-delta-t' AND alias='hw delta t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-differential-pressure-setpoint', 'hot water differential pressure setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-differential-pressure-setpoint' AND alias='hot water differential pressure setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-differential-pressure-setpoint', 'hw-wtr-diff-press-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-differential-pressure-setpoint' AND alias='hw-wtr-diff-press-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-differential-pressure-setpoint', 'hw wtr diff press sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-differential-pressure-setpoint' AND alias='hw wtr diff press sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-differential-pressure-setpoint', 'ht-w-dp-prs-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-differential-pressure-setpoint' AND alias='ht-w-dp-prs-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-differential-pressure-setpoint', 'hwdps', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-differential-pressure-setpoint' AND alias='hwdps');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-differential-pressure-setpoint', 'hw-differential-pressure-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-differential-pressure-setpoint' AND alias='hw-differential-pressure-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-differential-pressure-setpoint', 'hot-water-differential-pressure-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-differential-pressure-setpoint' AND alias='hot-water-differential-pressure-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-differential-pressure-setpoint', 'hot-water-differential-press-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-differential-pressure-setpoint' AND alias='hot-water-differential-press-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-temperature-reset-setpoint', 'hot water temperature reset setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-temperature-reset-setpoint' AND alias='hot water temperature reset setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-temperature-reset-setpoint', 'hw-wtr-temp-rst-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-temperature-reset-setpoint' AND alias='hw-wtr-temp-rst-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-temperature-reset-setpoint', 'hw wtr temp rst sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-temperature-reset-setpoint' AND alias='hw wtr temp rst sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-temperature-reset-setpoint', 'ht-w-t-rst-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-temperature-reset-setpoint' AND alias='ht-w-t-rst-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-temperature-reset-setpoint', 'hwtrs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-temperature-reset-setpoint' AND alias='hwtrs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-temperature-reset-setpoint', 'hw-temperature-reset-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-temperature-reset-setpoint' AND alias='hw-temperature-reset-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-temperature-reset-setpoint', 'hot-water-temp-reset-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-temperature-reset-setpoint' AND alias='hot-water-temp-reset-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-temperature-reset-setpoint', 'hot-water-temperature-reset-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-temperature-reset-setpoint' AND alias='hot-water-temperature-reset-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-command', 'hot water valve command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-command' AND alias='hot water valve command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-command', 'hw-wtr-vlv-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-command' AND alias='hw-wtr-vlv-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-command', 'hw wtr vlv cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-command' AND alias='hw wtr vlv cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-command', 'ht-w-vv-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-command' AND alias='ht-w-vv-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-command', 'hwvc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-command' AND alias='hwvc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-command', 'hw-valve-command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-command' AND alias='hw-valve-command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-command', 'hot-water-valve-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-command' AND alias='hot-water-valve-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-command', 'hot water vlv command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-command' AND alias='hot water vlv command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-position', 'hot water valve position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-position' AND alias='hot water valve position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-position', 'hw-wtr-vlv-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-position' AND alias='hw-wtr-vlv-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-position', 'hw wtr vlv pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-position' AND alias='hw wtr vlv pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-position', 'ht-w-vv-psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-position' AND alias='ht-w-vv-psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-position', 'hwvp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-position' AND alias='hwvp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-position', 'hw-valve-position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-position' AND alias='hw-valve-position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-position', 'hot-water-valve-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-position' AND alias='hot-water-valve-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'hot-water-valve-position', 'hot water vlv position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='hot-water-valve-position' AND alias='hot water vlv position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidification-status', 'humidification status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidification-status' AND alias='humidification status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidification-status', 'humidification-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidification-status' AND alias='humidification-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidification-status', 'humidification sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidification-status' AND alias='humidification sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidification-status', 'humidification-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidification-status' AND alias='humidification-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidification-status', 'humidification stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidification-status' AND alias='humidification stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-command', 'humidifier command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-command' AND alias='humidifier command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-command', 'humidifier-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-command' AND alias='humidifier-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-command', 'humidifier cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-command' AND alias='humidifier cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-command', 'humidifier-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-command' AND alias='humidifier-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-command', 'humidifier com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-command' AND alias='humidifier com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-run-status', 'humidifier run status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-run-status' AND alias='humidifier run status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-run-status', 'humidifier-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-run-status' AND alias='humidifier-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-run-status', 'humidifier sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-run-status' AND alias='humidifier sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-run-status', 'humidifier-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-run-status' AND alias='humidifier-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-run-status', 'hrs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-run-status' AND alias='hrs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-run-status', 'humidifier-run-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-run-status' AND alias='humidifier-run-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-run-status', 'humidifier stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-run-status' AND alias='humidifier stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'humidifier-run-status', 'humidifier run sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='humidifier-run-status' AND alias='humidifier run sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-command', 'kitchen exhaust fan command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-command' AND alias='kitchen exhaust fan command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-command', 'kitchen-ea-fn-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-command' AND alias='kitchen-ea-fn-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-command', 'kitchen ea fn cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-command' AND alias='kitchen ea fn cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-command', 'kitchen-exh-fn-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-command' AND alias='kitchen-exh-fn-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-command', 'kefc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-command' AND alias='kefc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-command', 'kitchen-ef-command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-command' AND alias='kitchen-ef-command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-command', 'kitchen-exhaust-fan-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-command' AND alias='kitchen-exhaust-fan-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-command', 'kitchen exaust fan command', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-command' AND alias='kitchen exaust fan command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-status', 'kitchen exhaust fan status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-status' AND alias='kitchen exhaust fan status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-status', 'kitchen-ea-fn-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-status' AND alias='kitchen-ea-fn-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-status', 'kitchen ea fn sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-status' AND alias='kitchen ea fn sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-status', 'kitchen-exh-fn-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-status' AND alias='kitchen-exh-fn-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-status', 'kefs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-status' AND alias='kefs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-status', 'kitchen-ef-status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-status' AND alias='kitchen-ef-status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-status', 'kitchen-exhaust-fan-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-status' AND alias='kitchen-exhaust-fan-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'kitchen-exhaust-fan-status', 'kitchen exaust fan status', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='kitchen-exhaust-fan-status' AND alias='kitchen exaust fan status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lead-lag-command', 'lead lag command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lead-lag-command' AND alias='lead lag command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lead-lag-command', 'lead-lag-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lead-lag-command' AND alias='lead-lag-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lead-lag-command', 'lead lag cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lead-lag-command' AND alias='lead lag cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lead-lag-command', 'lead-lag-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lead-lag-command' AND alias='lead-lag-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lead-lag-command', 'llc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lead-lag-command' AND alias='llc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lead-lag-command', 'lead lag com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lead-lag-command' AND alias='lead lag com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lead-lag-status', 'lead lag status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lead-lag-status' AND alias='lead lag status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lead-lag-status', 'lead-lag-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lead-lag-status' AND alias='lead-lag-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lead-lag-status', 'lead lag sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lead-lag-status' AND alias='lead lag sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lead-lag-status', 'lead-lag-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lead-lag-status' AND alias='lead-lag-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lead-lag-status', 'lls', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lead-lag-status' AND alias='lls');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lead-lag-status', 'lead lag stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lead-lag-status' AND alias='lead lag stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-command', 'lighting command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-command' AND alias='lighting command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-command', 'ltg-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-command' AND alias='ltg-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-command', 'ltg cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-command' AND alias='ltg cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-command', 'lite-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-command' AND alias='lite-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-command', 'lighting-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-command' AND alias='lighting-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-command', 'lite com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-command' AND alias='lite com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-command', 'lighting cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-command' AND alias='lighting cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-on-off-command', 'lighting on off command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-on-off-command' AND alias='lighting on off command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-on-off-command', 'ltg-on-off-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-on-off-command' AND alias='ltg-on-off-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-on-off-command', 'ltg on off cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-on-off-command' AND alias='ltg on off cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-on-off-command', 'lite-on-off-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-on-off-command' AND alias='lite-on-off-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-on-off-command', 'looc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-on-off-command' AND alias='looc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-on-off-command', 'lighting-on-off-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-on-off-command' AND alias='lighting-on-off-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-on-off-command', 'lite on off com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-on-off-command' AND alias='lite on off com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-on-off-command', 'lighting on off cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-on-off-command' AND alias='lighting on off cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-power-consumption', 'lighting power consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-power-consumption' AND alias='lighting power consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-power-consumption', 'ltg-pwr-consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-power-consumption' AND alias='ltg-pwr-consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-power-consumption', 'ltg pwr consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-power-consumption' AND alias='ltg pwr consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-power-consumption', 'lite-pw-consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-power-consumption' AND alias='lite-pw-consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-power-consumption', 'lpc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-power-consumption' AND alias='lpc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-power-consumption', 'lite pw consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-power-consumption' AND alias='lite pw consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-scene-command', 'lighting scene command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-scene-command' AND alias='lighting scene command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-scene-command', 'ltg-scene-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-scene-command' AND alias='ltg-scene-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-scene-command', 'ltg scene cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-scene-command' AND alias='ltg scene cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-scene-command', 'lite-scene-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-scene-command' AND alias='lite-scene-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-scene-command', 'lsc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-scene-command' AND alias='lsc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-scene-command', 'lighting-scene-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-scene-command' AND alias='lighting-scene-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-scene-command', 'lite scene com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-scene-command' AND alias='lite scene com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-scene-command', 'lighting scene cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-scene-command' AND alias='lighting scene cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-schedule', 'lighting schedule', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-schedule' AND alias='lighting schedule');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-schedule', 'ltg-schedule', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-schedule' AND alias='ltg-schedule');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-schedule', 'ltg schedule', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-schedule' AND alias='ltg schedule');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-schedule', 'lite-schedule', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-schedule' AND alias='lite-schedule');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-schedule', 'lite schedule', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-schedule' AND alias='lite schedule');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-status', 'lighting status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-status' AND alias='lighting status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-status', 'ltg-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-status' AND alias='ltg-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-status', 'ltg sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-status' AND alias='ltg sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-status', 'lite-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-status' AND alias='lite-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-status', 'lighting-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-status' AND alias='lighting-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-status', 'lite stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-status' AND alias='lite stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'lighting-status', 'lighting sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='lighting-status' AND alias='lighting sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'line-to-line-voltage', 'line to line voltage', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='line-to-line-voltage' AND alias='line to line voltage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'line-to-line-voltage', 'line-to-line-volt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='line-to-line-voltage' AND alias='line-to-line-volt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'line-to-line-voltage', 'line to line volt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='line-to-line-voltage' AND alias='line to line volt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'line-to-line-voltage', 'line-to-line-v', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='line-to-line-voltage' AND alias='line-to-line-v');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'line-to-line-voltage', 'ltlv', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='line-to-line-voltage' AND alias='ltlv');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'line-to-line-voltage', 'line to line v', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='line-to-line-voltage' AND alias='line to line v');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'line-to-neutral-voltage', 'line to neutral voltage', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='line-to-neutral-voltage' AND alias='line to neutral voltage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'line-to-neutral-voltage', 'line-to-neutral-volt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='line-to-neutral-voltage' AND alias='line-to-neutral-volt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'line-to-neutral-voltage', 'line to neutral volt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='line-to-neutral-voltage' AND alias='line to neutral volt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'line-to-neutral-voltage', 'line-to-neutral-v', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='line-to-neutral-voltage' AND alias='line-to-neutral-v');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'line-to-neutral-voltage', 'ltnv', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='line-to-neutral-voltage' AND alias='ltnv');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'line-to-neutral-voltage', 'line to neutral v', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='line-to-neutral-voltage' AND alias='line to neutral v');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-discharge-air-temperature-alarm', 'low discharge air temperature alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-discharge-air-temperature-alarm' AND alias='low discharge air temperature alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-discharge-air-temperature-alarm', 'low-da-temp-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-discharge-air-temperature-alarm' AND alias='low-da-temp-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-discharge-air-temperature-alarm', 'low da temp alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-discharge-air-temperature-alarm' AND alias='low da temp alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-discharge-air-temperature-alarm', 'low-disch-t-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-discharge-air-temperature-alarm' AND alias='low-disch-t-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-discharge-air-temperature-alarm', 'ldata', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-discharge-air-temperature-alarm' AND alias='ldata');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-discharge-air-temperature-alarm', 'low-da-temperature-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-discharge-air-temperature-alarm' AND alias='low-da-temperature-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-discharge-air-temperature-alarm', 'low-discharge-air-temp-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-discharge-air-temperature-alarm' AND alias='low-discharge-air-temp-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-discharge-air-temperature-alarm', 'low-discharge-air-temperature-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-discharge-air-temperature-alarm' AND alias='low-discharge-air-temperature-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-duct-static-pressure-alarm', 'low duct static pressure alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-duct-static-pressure-alarm' AND alias='low duct static pressure alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-duct-static-pressure-alarm', 'low-duct-stat-press-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-duct-static-pressure-alarm' AND alias='low-duct-stat-press-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-duct-static-pressure-alarm', 'low duct stat press alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-duct-static-pressure-alarm' AND alias='low duct stat press alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-duct-static-pressure-alarm', 'low-duct-stc-prs-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-duct-static-pressure-alarm' AND alias='low-duct-stc-prs-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-duct-static-pressure-alarm', 'ldspa', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-duct-static-pressure-alarm' AND alias='ldspa');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-duct-static-pressure-alarm', 'low-duct-static-pressure-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-duct-static-pressure-alarm' AND alias='low-duct-static-pressure-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-duct-static-pressure-alarm', 'low-duct-static-press-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-duct-static-pressure-alarm' AND alias='low-duct-static-press-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-duct-static-pressure-alarm', 'low duct static presure alarm', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-duct-static-pressure-alarm' AND alias='low duct static presure alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-humidity-alarm', 'low humidity alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-humidity-alarm' AND alias='low humidity alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-humidity-alarm', 'low-hum-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-humidity-alarm' AND alias='low-hum-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-humidity-alarm', 'low hum alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-humidity-alarm' AND alias='low hum alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-humidity-alarm', 'low-rh-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-humidity-alarm' AND alias='low-rh-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-humidity-alarm', 'lha', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-humidity-alarm' AND alias='lha');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-humidity-alarm', 'low-humidity-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-humidity-alarm' AND alias='low-humidity-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-humidity-alarm', 'low-hum-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-humidity-alarm' AND alias='low-hum-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-humidity-alarm', 'low humidty alarm', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-humidity-alarm' AND alias='low humidty alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-limit-status', 'low limit status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-limit-status' AND alias='low limit status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-limit-status', 'low-limit-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-limit-status' AND alias='low-limit-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-limit-status', 'low limit sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-limit-status' AND alias='low limit sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-limit-status', 'low-limit-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-limit-status' AND alias='low-limit-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-limit-status', 'lls', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-limit-status' AND alias='lls');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-limit-status', 'low limit stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-limit-status' AND alias='low limit stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-suction-pressure-alarm', 'low suction pressure alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-suction-pressure-alarm' AND alias='low suction pressure alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-suction-pressure-alarm', 'low-suc-press-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-suction-pressure-alarm' AND alias='low-suc-press-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-suction-pressure-alarm', 'low suc press alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-suction-pressure-alarm' AND alias='low suc press alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-suction-pressure-alarm', 'low-suc-prs-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-suction-pressure-alarm' AND alias='low-suc-prs-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-suction-pressure-alarm', 'lspa', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-suction-pressure-alarm' AND alias='lspa');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-suction-pressure-alarm', 'low-suction-pressure-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-suction-pressure-alarm' AND alias='low-suction-pressure-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-suction-pressure-alarm', 'low-suction-press-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-suction-pressure-alarm' AND alias='low-suction-press-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-suction-pressure-alarm', 'low suction presure alarm', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-suction-pressure-alarm' AND alias='low suction presure alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-zone-temperature-alarm', 'low zone temperature alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-zone-temperature-alarm' AND alias='low zone temperature alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-zone-temperature-alarm', 'low-zn-temp-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-zone-temperature-alarm' AND alias='low-zn-temp-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-zone-temperature-alarm', 'low zn temp alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-zone-temperature-alarm' AND alias='low zn temp alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-zone-temperature-alarm', 'low-z-t-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-zone-temperature-alarm' AND alias='low-z-t-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-zone-temperature-alarm', 'lzta', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-zone-temperature-alarm' AND alias='lzta');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-zone-temperature-alarm', 'low-zat-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-zone-temperature-alarm' AND alias='low-zat-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-zone-temperature-alarm', 'low-zone-temp-alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-zone-temperature-alarm' AND alias='low-zone-temp-alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'low-zone-temperature-alarm', 'low-zone-temperature-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='low-zone-temperature-alarm' AND alias='low-zone-temperature-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'makeup-water-flow', 'makeup water flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='makeup-water-flow' AND alias='makeup water flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'makeup-water-flow', 'mu-wtr-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='makeup-water-flow' AND alias='mu-wtr-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'makeup-water-flow', 'mu wtr flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='makeup-water-flow' AND alias='mu wtr flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'makeup-water-flow', 'mu-w-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='makeup-water-flow' AND alias='mu-w-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'makeup-water-flow', 'mwf', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='makeup-water-flow' AND alias='mwf');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'makeup-water-flow', 'mu w fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='makeup-water-flow' AND alias='mu w fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'maximum-airflow-setpoint', 'maximum airflow setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='maximum-airflow-setpoint' AND alias='maximum airflow setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'maximum-airflow-setpoint', 'maximum-airflow-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='maximum-airflow-setpoint' AND alias='maximum-airflow-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'maximum-airflow-setpoint', 'maximum airflow sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='maximum-airflow-setpoint' AND alias='maximum airflow sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'maximum-airflow-setpoint', 'maximum-airflow-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='maximum-airflow-setpoint' AND alias='maximum-airflow-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'maximum-airflow-setpoint', 'mas', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='maximum-airflow-setpoint' AND alias='mas');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'maximum-airflow-setpoint', 'maximum airflow stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='maximum-airflow-setpoint' AND alias='maximum airflow stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-airflow-setpoint', 'minimum airflow setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-airflow-setpoint' AND alias='minimum airflow setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-airflow-setpoint', 'minimum-airflow-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-airflow-setpoint' AND alias='minimum-airflow-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-airflow-setpoint', 'minimum airflow sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-airflow-setpoint' AND alias='minimum airflow sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-airflow-setpoint', 'minimum-airflow-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-airflow-setpoint' AND alias='minimum-airflow-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-airflow-setpoint', 'mas', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-airflow-setpoint' AND alias='mas');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-airflow-setpoint', 'minimum airflow stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-airflow-setpoint' AND alias='minimum airflow stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-outdoor-airflow', 'minimum outdoor airflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-outdoor-airflow' AND alias='minimum outdoor airflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-outdoor-airflow', 'minimum-oa-airflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-outdoor-airflow' AND alias='minimum-oa-airflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-outdoor-airflow', 'minimum oa airflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-outdoor-airflow' AND alias='minimum oa airflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-outdoor-airflow', 'minimum-outside-airflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-outdoor-airflow' AND alias='minimum-outside-airflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-outdoor-airflow', 'moa', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-outdoor-airflow' AND alias='moa');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-outdoor-airflow', 'minimum-oaflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-outdoor-airflow' AND alias='minimum-oaflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-outdoor-airflow', 'minimum outside airflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-outdoor-airflow' AND alias='minimum outside airflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'minimum-outdoor-airflow', 'minimum oaflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='minimum-outdoor-airflow' AND alias='minimum oaflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-command', 'morning warmup command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-command' AND alias='morning warmup command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-command', 'morn-wu-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-command' AND alias='morn-wu-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-command', 'morn wu cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-command' AND alias='morn wu cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-command', 'am-wu-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-command' AND alias='am-wu-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-command', 'mwc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-command' AND alias='mwc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-command', 'morning-warmup-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-command' AND alias='morning-warmup-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-command', 'am wu com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-command' AND alias='am wu com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-command', 'morning warmup cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-command' AND alias='morning warmup cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-status', 'morning warmup status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-status' AND alias='morning warmup status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-status', 'morn-wu-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-status' AND alias='morn-wu-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-status', 'morn wu sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-status' AND alias='morn wu sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-status', 'am-wu-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-status' AND alias='am-wu-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-status', 'mws', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-status' AND alias='mws');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-status', 'morning-warmup-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-status' AND alias='morning-warmup-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-status', 'am wu stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-status' AND alias='am wu stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'morning-warmup-status', 'morning warmup sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='morning-warmup-status' AND alias='morning warmup sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-current-percentage', 'motor current percentage', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-current-percentage' AND alias='motor current percentage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-current-percentage', 'mtr-amp-percentage', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-current-percentage' AND alias='mtr-amp-percentage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-current-percentage', 'mtr amp percentage', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-current-percentage' AND alias='mtr amp percentage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-current-percentage', 'mtr-cur-percentage', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-current-percentage' AND alias='mtr-cur-percentage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-current-percentage', 'mcp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-current-percentage' AND alias='mcp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-current-percentage', 'mtr cur percentage', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-current-percentage' AND alias='mtr cur percentage');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-overload-alarm', 'motor overload alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-overload-alarm' AND alias='motor overload alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-overload-alarm', 'mtr-ol-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-overload-alarm' AND alias='mtr-ol-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-overload-alarm', 'mtr ol alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-overload-alarm' AND alias='mtr ol alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-overload-alarm', 'mtr-ol-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-overload-alarm' AND alias='mtr-ol-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-overload-alarm', 'moa', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-overload-alarm' AND alias='moa');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-overload-alarm', 'motor-overload-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-overload-alarm' AND alias='motor-overload-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-overload-alarm', 'motor overload alram', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-overload-alarm' AND alias='motor overload alram');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'motor-overload-alarm', 'mtr ol alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='motor-overload-alarm' AND alias='mtr ol alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'natural-gas-consumption', 'natural gas consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='natural-gas-consumption' AND alias='natural gas consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'natural-gas-consumption', 'nat-gs-consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='natural-gas-consumption' AND alias='nat-gs-consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'natural-gas-consumption', 'nat gs consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='natural-gas-consumption' AND alias='nat gs consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'natural-gas-consumption', 'ngc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='natural-gas-consumption' AND alias='ngc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'natural-gas-pressure', 'natural gas pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='natural-gas-pressure' AND alias='natural gas pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'natural-gas-pressure', 'nat-gs-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='natural-gas-pressure' AND alias='nat-gs-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'natural-gas-pressure', 'nat gs press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='natural-gas-pressure' AND alias='nat gs press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'natural-gas-pressure', 'nat-gs-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='natural-gas-pressure' AND alias='nat-gs-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'natural-gas-pressure', 'ngp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='natural-gas-pressure' AND alias='ngp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'natural-gas-pressure', 'natural-gas-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='natural-gas-pressure' AND alias='natural-gas-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'natural-gas-pressure', 'natural gas presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='natural-gas-pressure' AND alias='natural gas presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'natural-gas-pressure', 'nat gs prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='natural-gas-pressure' AND alias='nat gs prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-command', 'night purge command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-command' AND alias='night purge command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-command', 'nite-purge-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-command' AND alias='nite-purge-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-command', 'nite purge cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-command' AND alias='nite purge cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-command', 'nt-purge-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-command' AND alias='nt-purge-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-command', 'npc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-command' AND alias='npc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-command', 'night-purge-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-command' AND alias='night-purge-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-command', 'nt purge com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-command' AND alias='nt purge com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-command', 'night purge cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-command' AND alias='night purge cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-status', 'night purge status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-status' AND alias='night purge status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-status', 'nite-purge-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-status' AND alias='nite-purge-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-status', 'nite purge sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-status' AND alias='nite purge sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-status', 'nt-purge-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-status' AND alias='nt-purge-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-status', 'nps', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-status' AND alias='nps');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-status', 'night-purge-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-status' AND alias='night-purge-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-status', 'nt purge stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-status' AND alias='nt purge stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'night-purge-status', 'night purge sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='night-purge-status' AND alias='night purge sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'nitrogen-dioxide-level', 'nitrogen dioxide level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='nitrogen-dioxide-level' AND alias='nitrogen dioxide level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'nitrogen-dioxide-level', 'ndl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='nitrogen-dioxide-level' AND alias='ndl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'occupancy', 'occupancy', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='occupancy' AND alias='occupancy');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'occupancy', 'occ', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='occupancy' AND alias='occ');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'occupancy', 'ocp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='occupancy' AND alias='ocp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'oil-pressure', 'oil pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='oil-pressure' AND alias='oil pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'oil-pressure', 'oil-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='oil-pressure' AND alias='oil-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'oil-pressure', 'oil press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='oil-pressure' AND alias='oil press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'oil-pressure', 'oil-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='oil-pressure' AND alias='oil-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'oil-pressure', 'oil presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='oil-pressure' AND alias='oil presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'oil-pressure', 'oil prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='oil-pressure' AND alias='oil prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-damper-command', 'outdoor air damper command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-damper-command' AND alias='outdoor air damper command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-damper-command', 'oa-dmpr-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-damper-command' AND alias='oa-dmpr-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-damper-command', 'oa dmpr cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-damper-command' AND alias='oa dmpr cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-damper-command', 'outside-dmp-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-damper-command' AND alias='outside-dmp-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-damper-command', 'oadc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-damper-command' AND alias='oadc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-damper-command', 'oa-damper-command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-damper-command' AND alias='oa-damper-command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-damper-command', 'outdoor-air-damper-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-damper-command' AND alias='outdoor-air-damper-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-damper-command', 'outdoor air dampner command', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-damper-command' AND alias='outdoor air dampner command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy', 'outdoor air enthalpy', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy' AND alias='outdoor air enthalpy');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy', 'oa-enth', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy' AND alias='oa-enth');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy', 'oa enth', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy' AND alias='oa enth');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy', 'outside-enth', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy' AND alias='outside-enth');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy', 'oae', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy' AND alias='oae');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy', 'oa-enthalpy', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy' AND alias='oa-enthalpy');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy', 'outside enth', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy' AND alias='outside enth');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy', 'oa enthalpy', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy' AND alias='oa enthalpy');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy-setpoint', 'outdoor air enthalpy setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy-setpoint' AND alias='outdoor air enthalpy setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy-setpoint', 'oa-enth-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy-setpoint' AND alias='oa-enth-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy-setpoint', 'oa enth sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy-setpoint' AND alias='oa enth sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy-setpoint', 'outside-enth-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy-setpoint' AND alias='outside-enth-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy-setpoint', 'oaes', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy-setpoint' AND alias='oaes');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy-setpoint', 'oa-enthalpy-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy-setpoint' AND alias='oa-enthalpy-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy-setpoint', 'outdoor-air-enthalpy-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy-setpoint' AND alias='outdoor-air-enthalpy-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-enthalpy-setpoint', 'outside enth stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-enthalpy-setpoint' AND alias='outside enth stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-quality-index', 'outdoor air quality index', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-quality-index' AND alias='outdoor air quality index');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-quality-index', 'oa-quality-index', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-quality-index' AND alias='oa-quality-index');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-quality-index', 'oa quality index', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-quality-index' AND alias='oa quality index');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-quality-index', 'outside-quality-index', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-quality-index' AND alias='outside-quality-index');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-quality-index', 'oaqi', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-quality-index' AND alias='oaqi');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-quality-index', 'outside quality index', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-quality-index' AND alias='outside quality index');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-temperature-setpoint', 'outdoor air temperature setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-temperature-setpoint' AND alias='outdoor air temperature setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-temperature-setpoint', 'oa-temp-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-temperature-setpoint' AND alias='oa-temp-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-temperature-setpoint', 'oa temp sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-temperature-setpoint' AND alias='oa temp sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-temperature-setpoint', 'outside-t-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-temperature-setpoint' AND alias='outside-t-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-temperature-setpoint', 'oats', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-temperature-setpoint' AND alias='oats');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-temperature-setpoint', 'oa-temperature-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-temperature-setpoint' AND alias='oa-temperature-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-temperature-setpoint', 'outdoor-air-temp-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-temperature-setpoint' AND alias='outdoor-air-temp-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'outdoor-air-temperature-setpoint', 'outdoor-air-temperature-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='outdoor-air-temperature-setpoint' AND alias='outdoor-air-temperature-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ozone-level', 'ozone level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ozone-level' AND alias='ozone level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'particulate-matter-pm10', 'particulate matter pm10', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='particulate-matter-pm10' AND alias='particulate matter pm10');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'particulate-matter-pm10', 'pmp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='particulate-matter-pm10' AND alias='pmp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'peak-demand', 'peak demand', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='peak-demand' AND alias='peak demand');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'peak-demand', 'peak-dmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='peak-demand' AND alias='peak-dmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'peak-demand', 'peak dmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='peak-demand' AND alias='peak dmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-factor', 'power factor', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-factor' AND alias='power factor');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-factor', 'pwr-factor', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-factor' AND alias='pwr-factor');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-factor', 'pwr factor', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-factor' AND alias='pwr factor');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-factor', 'pw-factor', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-factor' AND alias='pw-factor');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-factor', 'pw factor', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-factor' AND alias='pw factor');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-failure-alarm', 'power failure alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-failure-alarm' AND alias='power failure alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-failure-alarm', 'pwr-failure-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-failure-alarm' AND alias='pwr-failure-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-failure-alarm', 'pwr failure alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-failure-alarm' AND alias='pwr failure alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-failure-alarm', 'pw-failure-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-failure-alarm' AND alias='pw-failure-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-failure-alarm', 'pfa', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-failure-alarm' AND alias='pfa');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-failure-alarm', 'power-failure-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-failure-alarm' AND alias='power-failure-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-failure-alarm', 'power failure alram', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-failure-alarm' AND alias='power failure alram');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'power-failure-alarm', 'pw failure alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='power-failure-alarm' AND alias='pw failure alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-leaving-temperature', 'preheat leaving temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-leaving-temperature' AND alias='preheat leaving temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-leaving-temperature', 'prht-leaving-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-leaving-temperature' AND alias='prht-leaving-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-leaving-temperature', 'prht leaving temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-leaving-temperature' AND alias='prht leaving temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-leaving-temperature', 'pre-heat-leaving-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-leaving-temperature' AND alias='pre-heat-leaving-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-leaving-temperature', 'plt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-leaving-temperature' AND alias='plt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-leaving-temperature', 'preheat-leaving-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-leaving-temperature' AND alias='preheat-leaving-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-leaving-temperature', 'preheat leaving temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-leaving-temperature' AND alias='preheat leaving temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-leaving-temperature', 'pre heat leaving t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-leaving-temperature' AND alias='pre heat leaving t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-command', 'preheat valve command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-command' AND alias='preheat valve command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-command', 'prht-vlv-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-command' AND alias='prht-vlv-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-command', 'prht vlv cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-command' AND alias='prht vlv cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-command', 'pre-heat-vv-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-command' AND alias='pre-heat-vv-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-command', 'pvc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-command' AND alias='pvc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-command', 'preheat-valve-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-command' AND alias='preheat-valve-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-command', 'preheat vlv command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-command' AND alias='preheat vlv command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-command', 'pre heat vv com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-command' AND alias='pre heat vv com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-output', 'preheat valve output', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-output' AND alias='preheat valve output');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-output', 'prht-vlv-out', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-output' AND alias='prht-vlv-out');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-output', 'prht vlv out', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-output' AND alias='prht vlv out');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-output', 'pre-heat-vv-ao', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-output' AND alias='pre-heat-vv-ao');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-output', 'pvo', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-output' AND alias='pvo');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-output', 'preheat vlv output', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-output' AND alias='preheat vlv output');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-output', 'pre heat vv ao', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-output' AND alias='pre heat vv ao');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-position', 'preheat valve position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-position' AND alias='preheat valve position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-position', 'prht-vlv-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-position' AND alias='prht-vlv-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-position', 'prht vlv pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-position' AND alias='prht vlv pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-position', 'pre-heat-vv-psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-position' AND alias='pre-heat-vv-psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-position', 'pvp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-position' AND alias='pvp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-position', 'preheat-valve-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-position' AND alias='preheat-valve-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-position', 'preheat vlv position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-position' AND alias='preheat vlv position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'preheat-valve-position', 'pre heat vv psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='preheat-valve-position' AND alias='pre heat vv psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-chilled-water-flow', 'primary chilled water flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-chilled-water-flow' AND alias='primary chilled water flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-chilled-water-flow', 'pri-chw-wtr-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-chilled-water-flow' AND alias='pri-chw-wtr-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-chilled-water-flow', 'pri chw wtr flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-chilled-water-flow' AND alias='pri chw wtr flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-chilled-water-flow', 'prim-chl-w-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-chilled-water-flow' AND alias='prim-chl-w-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-chilled-water-flow', 'pcwf', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-chilled-water-flow' AND alias='pcwf');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-chilled-water-flow', 'primary-chw-flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-chilled-water-flow' AND alias='primary-chw-flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-chilled-water-flow', 'prim chl w fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-chilled-water-flow' AND alias='prim chl w fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-chilled-water-flow', 'primary chw flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-chilled-water-flow' AND alias='primary chw flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-hot-water-flow', 'primary hot water flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-hot-water-flow' AND alias='primary hot water flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-hot-water-flow', 'pri-hw-wtr-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-hot-water-flow' AND alias='pri-hw-wtr-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-hot-water-flow', 'pri hw wtr flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-hot-water-flow' AND alias='pri hw wtr flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-hot-water-flow', 'prim-ht-w-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-hot-water-flow' AND alias='prim-ht-w-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-hot-water-flow', 'phwf', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-hot-water-flow' AND alias='phwf');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-hot-water-flow', 'primary-hw-flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-hot-water-flow' AND alias='primary-hw-flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-hot-water-flow', 'prim ht w fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-hot-water-flow' AND alias='prim ht w fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'primary-hot-water-flow', 'primary hw flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='primary-hot-water-flow' AND alias='primary hw flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'proof-of-airflow', 'proof of airflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='proof-of-airflow' AND alias='proof of airflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'proof-of-airflow', 'poa', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='proof-of-airflow' AND alias='poa');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'proof-of-flow', 'proof of flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='proof-of-flow' AND alias='proof of flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'proof-of-flow', 'proof-of-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='proof-of-flow' AND alias='proof-of-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'proof-of-flow', 'proof of flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='proof-of-flow' AND alias='proof of flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'proof-of-flow', 'proof-of-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='proof-of-flow' AND alias='proof-of-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'proof-of-flow', 'pof', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='proof-of-flow' AND alias='pof');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'proof-of-flow', 'proof of fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='proof-of-flow' AND alias='proof of fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'radiant-panel-surface-temperature', 'radiant panel surface temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='radiant-panel-surface-temperature' AND alias='radiant panel surface temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'radiant-panel-surface-temperature', 'rad-panel-surface-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='radiant-panel-surface-temperature' AND alias='rad-panel-surface-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'radiant-panel-surface-temperature', 'rad panel surface temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='radiant-panel-surface-temperature' AND alias='rad panel surface temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'radiant-panel-surface-temperature', 'rad-panel-surface-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='radiant-panel-surface-temperature' AND alias='rad-panel-surface-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'radiant-panel-surface-temperature', 'rpst', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='radiant-panel-surface-temperature' AND alias='rpst');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'radiant-panel-surface-temperature', 'radiant-panel-surface-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='radiant-panel-surface-temperature' AND alias='radiant-panel-surface-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'radiant-panel-surface-temperature', 'radiant panel surface temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='radiant-panel-surface-temperature' AND alias='radiant panel surface temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'radiant-panel-surface-temperature', 'rad panel surface t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='radiant-panel-surface-temperature' AND alias='rad panel surface t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'radon-level', 'radon level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='radon-level' AND alias='radon level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-pressure', 'refrigerant discharge pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-pressure' AND alias='refrigerant discharge pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-pressure', 'refrig-da-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-pressure' AND alias='refrig-da-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-pressure', 'refrig da press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-pressure' AND alias='refrig da press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-pressure', 'ref-disch-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-pressure' AND alias='ref-disch-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-pressure', 'rdp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-pressure' AND alias='rdp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-pressure', 'refrigerant-discharge-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-pressure' AND alias='refrigerant-discharge-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-pressure', 'refrigerant discharge presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-pressure' AND alias='refrigerant discharge presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-pressure', 'ref disch prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-pressure' AND alias='ref disch prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-temperature', 'refrigerant discharge temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-temperature' AND alias='refrigerant discharge temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-temperature', 'refrig-da-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-temperature' AND alias='refrig-da-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-temperature', 'refrig da temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-temperature' AND alias='refrig da temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-temperature', 'ref-disch-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-temperature' AND alias='ref-disch-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-temperature', 'rdt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-temperature' AND alias='rdt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-temperature', 'refrigerant-discharge-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-temperature' AND alias='refrigerant-discharge-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-temperature', 'refrigerant discharge temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-temperature' AND alias='refrigerant discharge temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-discharge-temperature', 'ref disch t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-discharge-temperature' AND alias='ref disch t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-flow', 'refrigerant flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-flow' AND alias='refrigerant flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-flow', 'refrig-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-flow' AND alias='refrig-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-flow', 'refrig flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-flow' AND alias='refrig flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-flow', 'ref-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-flow' AND alias='ref-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-flow', 'ref fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-flow' AND alias='ref fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-leak-alarm', 'refrigerant leak alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-leak-alarm' AND alias='refrigerant leak alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-leak-alarm', 'refrig-lk-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-leak-alarm' AND alias='refrig-lk-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-leak-alarm', 'refrig lk alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-leak-alarm' AND alias='refrig lk alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-leak-alarm', 'ref-lk-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-leak-alarm' AND alias='ref-lk-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-leak-alarm', 'rla', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-leak-alarm' AND alias='rla');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-leak-alarm', 'refrigerant-leak-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-leak-alarm' AND alias='refrigerant-leak-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-leak-alarm', 'refrigerant leak alram', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-leak-alarm' AND alias='refrigerant leak alram');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-leak-alarm', 'ref lk alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-leak-alarm' AND alias='ref lk alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-level', 'refrigerant level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-level' AND alias='refrigerant level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-level', 'refrig-level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-level' AND alias='refrig-level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-level', 'refrig level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-level' AND alias='refrig level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-level', 'ref-level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-level' AND alias='ref-level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-level', 'ref level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-level' AND alias='ref level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-pressure', 'refrigerant suction pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-pressure' AND alias='refrigerant suction pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-pressure', 'refrig-suc-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-pressure' AND alias='refrig-suc-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-pressure', 'refrig suc press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-pressure' AND alias='refrig suc press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-pressure', 'ref-suc-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-pressure' AND alias='ref-suc-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-pressure', 'rsp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-pressure' AND alias='rsp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-pressure', 'refrigerant-suction-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-pressure' AND alias='refrigerant-suction-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-pressure', 'refrigerant suction presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-pressure' AND alias='refrigerant suction presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-pressure', 'ref suc prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-pressure' AND alias='ref suc prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-temperature', 'refrigerant suction temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-temperature' AND alias='refrigerant suction temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-temperature', 'refrig-suc-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-temperature' AND alias='refrig-suc-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-temperature', 'refrig suc temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-temperature' AND alias='refrig suc temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-temperature', 'ref-suc-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-temperature' AND alias='ref-suc-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-temperature', 'rst', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-temperature' AND alias='rst');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-temperature', 'refrigerant-suction-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-temperature' AND alias='refrigerant-suction-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-temperature', 'refrigerant suction temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-temperature' AND alias='refrigerant suction temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'refrigerant-suction-temperature', 'ref suc t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='refrigerant-suction-temperature' AND alias='ref suc t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-discharge-temperature', 'reheat discharge temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-discharge-temperature' AND alias='reheat discharge temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-discharge-temperature', 'rht-da-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-discharge-temperature' AND alias='rht-da-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-discharge-temperature', 'rht da temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-discharge-temperature' AND alias='rht da temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-discharge-temperature', 're-heat-disch-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-discharge-temperature' AND alias='re-heat-disch-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-discharge-temperature', 'rdt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-discharge-temperature' AND alias='rdt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-discharge-temperature', 'reheat-discharge-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-discharge-temperature' AND alias='reheat-discharge-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-discharge-temperature', 'reheat discharge temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-discharge-temperature' AND alias='reheat discharge temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-discharge-temperature', 're heat disch t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-discharge-temperature' AND alias='re heat disch t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-command', 'reheat valve command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-command' AND alias='reheat valve command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-command', 'rht-vlv-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-command' AND alias='rht-vlv-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-command', 'rht vlv cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-command' AND alias='rht vlv cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-command', 're-heat-vv-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-command' AND alias='re-heat-vv-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-command', 'rvc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-command' AND alias='rvc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-command', 'reheat-valve-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-command' AND alias='reheat-valve-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-command', 'reheat vlv command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-command' AND alias='reheat vlv command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-command', 're heat vv com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-command' AND alias='re heat vv com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-output', 'reheat valve output', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-output' AND alias='reheat valve output');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-output', 'rht-vlv-out', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-output' AND alias='rht-vlv-out');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-output', 'rht vlv out', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-output' AND alias='rht vlv out');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-output', 're-heat-vv-ao', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-output' AND alias='re-heat-vv-ao');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-output', 'rvo', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-output' AND alias='rvo');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-output', 'reheat vlv output', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-output' AND alias='reheat vlv output');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-output', 're heat vv ao', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-output' AND alias='re heat vv ao');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-position', 'reheat valve position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-position' AND alias='reheat valve position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-position', 'rht-vlv-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-position' AND alias='rht-vlv-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-position', 'rht vlv pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-position' AND alias='rht vlv pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-position', 're-heat-vv-psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-position' AND alias='re-heat-vv-psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-position', 'rvp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-position' AND alias='rvp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-position', 'reheat-valve-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-position' AND alias='reheat-valve-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-position', 'reheat vlv position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-position' AND alias='reheat vlv position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'reheat-valve-position', 're heat vv psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='reheat-valve-position' AND alias='re heat vv psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'relief-fan-command-bool', 'relief fan command bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='relief-fan-command-bool' AND alias='relief fan command bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'relief-fan-command-bool', 'rlf-fn-cmd-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='relief-fan-command-bool' AND alias='rlf-fn-cmd-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'relief-fan-command-bool', 'rlf fn cmd bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='relief-fan-command-bool' AND alias='rlf fn cmd bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'relief-fan-command-bool', 'rel-fn-com-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='relief-fan-command-bool' AND alias='rel-fn-com-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'relief-fan-command-bool', 'rfcb', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='relief-fan-command-bool' AND alias='rfcb');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'relief-fan-command-bool', 'relief-fan-cmd-bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='relief-fan-command-bool' AND alias='relief-fan-cmd-bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'relief-fan-command-bool', 'rel fn com bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='relief-fan-command-bool' AND alias='rel fn com bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'relief-fan-command-bool', 'relief fan cmd bool', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='relief-fan-command-bool' AND alias='relief fan cmd bool');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-closed', 'return air damper closed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-closed' AND alias='return air damper closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-closed', 'ra-dmpr-closed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-closed' AND alias='ra-dmpr-closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-closed', 'ra dmpr closed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-closed' AND alias='ra dmpr closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-closed', 'ret-dmp-closed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-closed' AND alias='ret-dmp-closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-closed', 'radc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-closed' AND alias='radc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-closed', 'ra-damper-closed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-closed' AND alias='ra-damper-closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-closed', 'return air dampner closed', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-closed' AND alias='return air dampner closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-closed', 'ret dmp closed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-closed' AND alias='ret dmp closed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-command', 'return air damper command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-command' AND alias='return air damper command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-command', 'ra-dmpr-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-command' AND alias='ra-dmpr-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-command', 'ra dmpr cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-command' AND alias='ra dmpr cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-command', 'ret-dmp-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-command' AND alias='ret-dmp-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-command', 'radc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-command' AND alias='radc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-command', 'ra-damper-command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-command' AND alias='ra-damper-command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-command', 'return-air-damper-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-command' AND alias='return-air-damper-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-command', 'return air dampner command', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-command' AND alias='return air dampner command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-open', 'return air damper open', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-open' AND alias='return air damper open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-open', 'ra-dmpr-open', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-open' AND alias='ra-dmpr-open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-open', 'ra dmpr open', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-open' AND alias='ra dmpr open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-open', 'ret-dmp-open', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-open' AND alias='ret-dmp-open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-open', 'rado', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-open' AND alias='rado');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-open', 'ra-damper-open', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-open' AND alias='ra-damper-open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-open', 'return air dampner open', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-open' AND alias='return air dampner open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-open', 'ret dmp open', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-open' AND alias='ret dmp open');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-position', 'return air damper position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-position' AND alias='return air damper position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-position', 'ra-dmpr-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-position' AND alias='ra-dmpr-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-position', 'ra dmpr pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-position' AND alias='ra dmpr pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-position', 'ret-dmp-psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-position' AND alias='ret-dmp-psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-position', 'radp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-position' AND alias='radp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-position', 'ra-damper-position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-position' AND alias='ra-damper-position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-position', 'return-air-damper-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-position' AND alias='return-air-damper-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-damper-position', 'return air dampner position', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-damper-position' AND alias='return air dampner position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-enthalpy', 'return air enthalpy', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-enthalpy' AND alias='return air enthalpy');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-enthalpy', 'ra-enth', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-enthalpy' AND alias='ra-enth');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-enthalpy', 'ra enth', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-enthalpy' AND alias='ra enth');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-enthalpy', 'ret-enth', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-enthalpy' AND alias='ret-enth');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-enthalpy', 'rae', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-enthalpy' AND alias='rae');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-enthalpy', 'ra-enthalpy', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-enthalpy' AND alias='ra-enthalpy');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-enthalpy', 'ret enth', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-enthalpy' AND alias='ret enth');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-enthalpy', 'ra enthalpy', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-enthalpy' AND alias='ra enthalpy');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-temperature-setpoint', 'return air temperature setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-temperature-setpoint' AND alias='return air temperature setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-temperature-setpoint', 'ra-temp-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-temperature-setpoint' AND alias='ra-temp-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-temperature-setpoint', 'ra temp sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-temperature-setpoint' AND alias='ra temp sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-temperature-setpoint', 'ret-t-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-temperature-setpoint' AND alias='ret-t-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-temperature-setpoint', 'rats', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-temperature-setpoint' AND alias='rats');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-temperature-setpoint', 'ra-temperature-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-temperature-setpoint' AND alias='ra-temperature-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-temperature-setpoint', 'return-air-temp-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-temperature-setpoint' AND alias='return-air-temp-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-air-temperature-setpoint', 'return-air-temperature-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-air-temperature-setpoint' AND alias='return-air-temperature-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-fan-vfd-speed', 'return fan vfd speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-fan-vfd-speed' AND alias='return fan vfd speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-fan-vfd-speed', 'ra-fn-drive-spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-fan-vfd-speed' AND alias='ra-fn-drive-spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-fan-vfd-speed', 'ra fn drive spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-fan-vfd-speed' AND alias='ra fn drive spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-fan-vfd-speed', 'ret-fn-variable frequency-spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-fan-vfd-speed' AND alias='ret-fn-variable frequency-spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-fan-vfd-speed', 'rfvs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-fan-vfd-speed' AND alias='rfvs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-fan-vfd-speed', 'rf-vfd-speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-fan-vfd-speed' AND alias='rf-vfd-speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-fan-vfd-speed', 'ret fn variable frequency spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-fan-vfd-speed' AND alias='ret fn variable frequency spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'return-fan-vfd-speed', 'rf vfd speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='return-fan-vfd-speed' AND alias='rf vfd speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'runtime-hours-total', 'runtime hours total', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='runtime-hours-total' AND alias='runtime hours total');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'runtime-hours-total', 'rht', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='runtime-hours-total' AND alias='rht');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'schedule-override-command', 'schedule override command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='schedule-override-command' AND alias='schedule override command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'schedule-override-command', 'schedule-override-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='schedule-override-command' AND alias='schedule-override-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'schedule-override-command', 'schedule override cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='schedule-override-command' AND alias='schedule override cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'schedule-override-command', 'schedule-override-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='schedule-override-command' AND alias='schedule-override-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'schedule-override-command', 'soc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='schedule-override-command' AND alias='soc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'schedule-override-command', 'schedule override com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='schedule-override-command' AND alias='schedule override com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-chilled-water-flow', 'secondary chilled water flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-chilled-water-flow' AND alias='secondary chilled water flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-chilled-water-flow', 'sec-chw-wtr-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-chilled-water-flow' AND alias='sec-chw-wtr-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-chilled-water-flow', 'sec chw wtr flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-chilled-water-flow' AND alias='sec chw wtr flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-chilled-water-flow', 'scnd-chl-w-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-chilled-water-flow' AND alias='scnd-chl-w-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-chilled-water-flow', 'scwf', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-chilled-water-flow' AND alias='scwf');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-chilled-water-flow', 'secondary-chw-flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-chilled-water-flow' AND alias='secondary-chw-flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-chilled-water-flow', 'scnd chl w fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-chilled-water-flow' AND alias='scnd chl w fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-chilled-water-flow', 'secondary chw flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-chilled-water-flow' AND alias='secondary chw flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-hot-water-flow', 'secondary hot water flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-hot-water-flow' AND alias='secondary hot water flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-hot-water-flow', 'sec-hw-wtr-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-hot-water-flow' AND alias='sec-hw-wtr-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-hot-water-flow', 'sec hw wtr flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-hot-water-flow' AND alias='sec hw wtr flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-hot-water-flow', 'scnd-ht-w-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-hot-water-flow' AND alias='scnd-ht-w-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-hot-water-flow', 'shwf', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-hot-water-flow' AND alias='shwf');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-hot-water-flow', 'secondary-hw-flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-hot-water-flow' AND alias='secondary-hw-flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-hot-water-flow', 'scnd ht w fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-hot-water-flow' AND alias='scnd ht w fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'secondary-hot-water-flow', 'secondary hw flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='secondary-hot-water-flow' AND alias='secondary hw flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-inlet-temperature', 'server inlet temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-inlet-temperature' AND alias='server inlet temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-inlet-temperature', 'server-inlet-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-inlet-temperature' AND alias='server-inlet-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-inlet-temperature', 'server inlet temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-inlet-temperature' AND alias='server inlet temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-inlet-temperature', 'server-inlet-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-inlet-temperature' AND alias='server-inlet-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-inlet-temperature', 'sit', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-inlet-temperature' AND alias='sit');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-inlet-temperature', 'server inlet temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-inlet-temperature' AND alias='server inlet temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-inlet-temperature', 'server inlet t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-inlet-temperature' AND alias='server inlet t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-outlet-temperature', 'server outlet temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-outlet-temperature' AND alias='server outlet temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-outlet-temperature', 'server-outlet-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-outlet-temperature' AND alias='server-outlet-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-outlet-temperature', 'server outlet temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-outlet-temperature' AND alias='server outlet temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-outlet-temperature', 'server-outlet-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-outlet-temperature' AND alias='server-outlet-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-outlet-temperature', 'sot', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-outlet-temperature' AND alias='sot');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-outlet-temperature', 'server outlet temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-outlet-temperature' AND alias='server outlet temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'server-outlet-temperature', 'server outlet t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='server-outlet-temperature' AND alias='server outlet t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'setpoint-reset-command', 'setpoint reset command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='setpoint-reset-command' AND alias='setpoint reset command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'setpoint-reset-command', 'sp-rst-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='setpoint-reset-command' AND alias='sp-rst-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'setpoint-reset-command', 'sp rst cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='setpoint-reset-command' AND alias='sp rst cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'setpoint-reset-command', 'stpt-rst-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='setpoint-reset-command' AND alias='stpt-rst-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'setpoint-reset-command', 'src', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='setpoint-reset-command' AND alias='src');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'setpoint-reset-command', 'sp-reset-command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='setpoint-reset-command' AND alias='sp-reset-command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'setpoint-reset-command', 'setpoint-reset-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='setpoint-reset-command' AND alias='setpoint-reset-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'setpoint-reset-command', 'stpt rst com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='setpoint-reset-command' AND alias='stpt rst com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'shutdown', 'shutdown', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='shutdown' AND alias='shutdown');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'slab-temperature', 'slab temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='slab-temperature' AND alias='slab temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'slab-temperature', 'slab-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='slab-temperature' AND alias='slab-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'slab-temperature', 'slab temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='slab-temperature' AND alias='slab temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'slab-temperature', 'slab-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='slab-temperature' AND alias='slab-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'slab-temperature', 'slab temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='slab-temperature' AND alias='slab temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'slab-temperature', 'slab t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='slab-temperature' AND alias='slab t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-command', 'smoke control command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-command' AND alias='smoke control command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-command', 'smk-control-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-command' AND alias='smk-control-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-command', 'smk control cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-command' AND alias='smk control cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-command', 'smk-control-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-command' AND alias='smk-control-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-command', 'scc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-command' AND alias='scc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-command', 'smoke-control-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-command' AND alias='smoke-control-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-command', 'smk control com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-command' AND alias='smk control com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-command', 'smoke control cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-command' AND alias='smoke control cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-status', 'smoke control status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-status' AND alias='smoke control status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-status', 'smk-control-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-status' AND alias='smk-control-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-status', 'smk control sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-status' AND alias='smk control sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-status', 'smk-control-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-status' AND alias='smk-control-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-status', 'scs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-status' AND alias='scs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-status', 'smoke-control-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-status' AND alias='smoke-control-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-status', 'smk control stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-status' AND alias='smk control stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'smoke-control-status', 'smoke control sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='smoke-control-status' AND alias='smoke control sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'standby-status', 'standby status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='standby-status' AND alias='standby status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'standby-status', 'standby-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='standby-status' AND alias='standby-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'standby-status', 'standby sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='standby-status' AND alias='standby sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'standby-status', 'standby-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='standby-status' AND alias='standby-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'standby-status', 'standby stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='standby-status' AND alias='standby stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-consumption', 'steam consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-consumption' AND alias='steam consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-consumption', 'stm-consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-consumption' AND alias='stm-consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-consumption', 'stm consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-consumption' AND alias='stm consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-flow', 'steam flow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-flow' AND alias='steam flow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-flow', 'stm-flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-flow' AND alias='stm-flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-flow', 'stm flw', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-flow' AND alias='stm flw');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-flow', 'stm-fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-flow' AND alias='stm-fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-flow', 'stm fl', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-flow' AND alias='stm fl');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-pressure', 'steam pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-pressure' AND alias='steam pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-pressure', 'stm-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-pressure' AND alias='stm-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-pressure', 'stm press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-pressure' AND alias='stm press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-pressure', 'stm-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-pressure' AND alias='stm-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-pressure', 'steam-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-pressure' AND alias='steam-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-pressure', 'steam presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-pressure' AND alias='steam presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-pressure', 'stm prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-pressure' AND alias='stm prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-pressure', 'steam press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-pressure' AND alias='steam press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-temperature', 'steam temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-temperature' AND alias='steam temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-temperature', 'stm-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-temperature' AND alias='stm-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-temperature', 'stm temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-temperature' AND alias='stm temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-temperature', 'stm-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-temperature' AND alias='stm-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-temperature', 'steam-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-temperature' AND alias='steam-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-temperature', 'steam temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-temperature' AND alias='steam temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-temperature', 'stm t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-temperature' AND alias='stm t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-temperature', 'steam temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-temperature' AND alias='steam temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-command', 'steam valve command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-command' AND alias='steam valve command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-command', 'stm-vlv-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-command' AND alias='stm-vlv-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-command', 'stm vlv cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-command' AND alias='stm vlv cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-command', 'stm-vv-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-command' AND alias='stm-vv-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-command', 'svc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-command' AND alias='svc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-command', 'steam-valve-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-command' AND alias='steam-valve-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-command', 'steam vlv command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-command' AND alias='steam vlv command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-command', 'stm vv com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-command' AND alias='stm vv com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-output', 'steam valve output', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-output' AND alias='steam valve output');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-output', 'stm-vlv-out', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-output' AND alias='stm-vlv-out');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-output', 'stm vlv out', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-output' AND alias='stm vlv out');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-output', 'stm-vv-ao', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-output' AND alias='stm-vv-ao');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-output', 'svo', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-output' AND alias='svo');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-output', 'steam vlv output', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-output' AND alias='steam vlv output');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-output', 'stm vv ao', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-output' AND alias='stm vv ao');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-position', 'steam valve position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-position' AND alias='steam valve position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-position', 'stm-vlv-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-position' AND alias='stm-vlv-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-position', 'stm vlv pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-position' AND alias='stm vlv pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-position', 'stm-vv-psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-position' AND alias='stm-vv-psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-position', 'svp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-position' AND alias='svp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-position', 'steam-valve-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-position' AND alias='steam-valve-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-position', 'steam vlv position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-position' AND alias='steam vlv position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'steam-valve-position', 'stm vv psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='steam-valve-position' AND alias='stm vv psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'subcooling-temperature', 'subcooling temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='subcooling-temperature' AND alias='subcooling temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'subcooling-temperature', 'subcooling-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='subcooling-temperature' AND alias='subcooling-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'subcooling-temperature', 'subcooling temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='subcooling-temperature' AND alias='subcooling temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'subcooling-temperature', 'subcooling-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='subcooling-temperature' AND alias='subcooling-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'subcooling-temperature', 'subcooling temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='subcooling-temperature' AND alias='subcooling temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'subcooling-temperature', 'subcooling t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='subcooling-temperature' AND alias='subcooling t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-pressure', 'suction pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-pressure' AND alias='suction pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-pressure', 'suc-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-pressure' AND alias='suc-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-pressure', 'suc press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-pressure' AND alias='suc press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-pressure', 'suc-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-pressure' AND alias='suc-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-pressure', 'suction-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-pressure' AND alias='suction-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-pressure', 'suction presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-pressure' AND alias='suction presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-pressure', 'suc prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-pressure' AND alias='suc prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-pressure', 'suction press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-pressure' AND alias='suction press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-superheat', 'suction superheat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-superheat' AND alias='suction superheat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-superheat', 'suc-sh', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-superheat' AND alias='suc-sh');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-superheat', 'suc sh', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-superheat' AND alias='suc sh');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-superheat', 'suc-super', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-superheat' AND alias='suc-super');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'suction-superheat', 'suc super', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='suction-superheat' AND alias='suc super');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'superheat-temperature', 'superheat temperature', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='superheat-temperature' AND alias='superheat temperature');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'superheat-temperature', 'sh-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='superheat-temperature' AND alias='sh-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'superheat-temperature', 'sh temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='superheat-temperature' AND alias='sh temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'superheat-temperature', 'super-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='superheat-temperature' AND alias='super-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'superheat-temperature', 'superheat-temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='superheat-temperature' AND alias='superheat-temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'superheat-temperature', 'superheat temperture', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='superheat-temperature' AND alias='superheat temperture');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'superheat-temperature', 'super t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='superheat-temperature' AND alias='super t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'superheat-temperature', 'superheat temp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='superheat-temperature' AND alias='superheat temp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-delta-t', 'supply air delta t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-delta-t' AND alias='supply air delta t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-delta-t', 'sa-diff-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-delta-t' AND alias='sa-diff-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-delta-t', 'sa diff t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-delta-t' AND alias='sa diff t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-delta-t', 'sup-dt-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-delta-t' AND alias='sup-dt-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-delta-t', 'sadt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-delta-t' AND alias='sadt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-delta-t', 'sa-delta-t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-delta-t' AND alias='sa-delta-t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-delta-t', 'suply air delta t', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-delta-t' AND alias='suply air delta t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-delta-t', 'sup dt t', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-delta-t' AND alias='sup dt t');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-dewpoint', 'supply air dewpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-dewpoint' AND alias='supply air dewpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-dewpoint', 'sa-dewpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-dewpoint' AND alias='sa-dewpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-dewpoint', 'sa dewpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-dewpoint' AND alias='sa dewpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-dewpoint', 'sup-dewpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-dewpoint' AND alias='sup-dewpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-dewpoint', 'sad', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-dewpoint' AND alias='sad');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-dewpoint', 'suply air dewpoint', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-dewpoint' AND alias='suply air dewpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-dewpoint', 'sup dewpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-dewpoint' AND alias='sup dewpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-enthalpy', 'supply air enthalpy', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-enthalpy' AND alias='supply air enthalpy');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-enthalpy', 'sa-enth', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-enthalpy' AND alias='sa-enth');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-enthalpy', 'sa enth', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-enthalpy' AND alias='sa enth');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-enthalpy', 'sup-enth', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-enthalpy' AND alias='sup-enth');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-enthalpy', 'sae', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-enthalpy' AND alias='sae');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-enthalpy', 'sa-enthalpy', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-enthalpy' AND alias='sa-enthalpy');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-enthalpy', 'suply air enthalpy', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-enthalpy' AND alias='suply air enthalpy');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-enthalpy', 'sup enth', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-enthalpy' AND alias='sup enth');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity', 'supply air humidity', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity' AND alias='supply air humidity');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity', 'sa-hum', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity' AND alias='sa-hum');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity', 'sa hum', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity' AND alias='sa hum');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity', 'sup-rh', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity' AND alias='sup-rh');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity', 'sah', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity' AND alias='sah');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity', 'sa-humidity', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity' AND alias='sa-humidity');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity', 'supply-air-hum', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity' AND alias='supply-air-hum');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity', 'supply air humidty', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity' AND alias='supply air humidty');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity-setpoint', 'supply air humidity setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity-setpoint' AND alias='supply air humidity setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity-setpoint', 'sa-hum-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity-setpoint' AND alias='sa-hum-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity-setpoint', 'sa hum sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity-setpoint' AND alias='sa hum sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity-setpoint', 'sup-rh-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity-setpoint' AND alias='sup-rh-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity-setpoint', 'sahs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity-setpoint' AND alias='sahs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity-setpoint', 'sa-humidity-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity-setpoint' AND alias='sa-humidity-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity-setpoint', 'supply-air-humidity-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity-setpoint' AND alias='supply-air-humidity-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-humidity-setpoint', 'supply-air-hum-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-humidity-setpoint' AND alias='supply-air-hum-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-static-pressure', 'supply air static pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-static-pressure' AND alias='supply air static pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-static-pressure', 'sa-stat-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-static-pressure' AND alias='sa-stat-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-static-pressure', 'sa stat press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-static-pressure' AND alias='sa stat press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-static-pressure', 'sup-stc-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-static-pressure' AND alias='sup-stc-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-static-pressure', 'sasp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-static-pressure' AND alias='sasp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-static-pressure', 'sa-static-pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-static-pressure' AND alias='sa-static-pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-static-pressure', 'supply-air-static-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-static-pressure' AND alias='supply-air-static-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-static-pressure', 'supply air static presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-static-pressure' AND alias='supply air static presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-temperature-setpoint', 'supply air temperature setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-temperature-setpoint' AND alias='supply air temperature setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-temperature-setpoint', 'sa-temp-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-temperature-setpoint' AND alias='sa-temp-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-temperature-setpoint', 'sa temp sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-temperature-setpoint' AND alias='sa temp sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-temperature-setpoint', 'sup-t-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-temperature-setpoint' AND alias='sup-t-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-temperature-setpoint', 'sats', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-temperature-setpoint' AND alias='sats');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-temperature-setpoint', 'sa-temperature-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-temperature-setpoint' AND alias='sa-temperature-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-temperature-setpoint', 'supply-air-temp-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-temperature-setpoint' AND alias='supply-air-temp-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-air-temperature-setpoint', 'supply-air-temperature-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-air-temperature-setpoint' AND alias='supply-air-temperature-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-airflow-setpoint', 'supply airflow setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-airflow-setpoint' AND alias='supply airflow setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-airflow-setpoint', 'sa-airflow-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-airflow-setpoint' AND alias='sa-airflow-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-airflow-setpoint', 'sa airflow sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-airflow-setpoint' AND alias='sa airflow sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-airflow-setpoint', 'sup-airflow-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-airflow-setpoint' AND alias='sup-airflow-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-airflow-setpoint', 'sas', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-airflow-setpoint' AND alias='sas');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-airflow-setpoint', 'saflow-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-airflow-setpoint' AND alias='saflow-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-airflow-setpoint', 'supply-airflow-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-airflow-setpoint' AND alias='supply-airflow-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-airflow-setpoint', 'suply airflow setpoint', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-airflow-setpoint' AND alias='suply airflow setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-fan-vfd-speed', 'supply fan vfd speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-fan-vfd-speed' AND alias='supply fan vfd speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-fan-vfd-speed', 'sa-fn-drive-spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-fan-vfd-speed' AND alias='sa-fn-drive-spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-fan-vfd-speed', 'sa fn drive spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-fan-vfd-speed' AND alias='sa fn drive spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-fan-vfd-speed', 'sup-fn-variable frequency-spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-fan-vfd-speed' AND alias='sup-fn-variable frequency-spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-fan-vfd-speed', 'sfvs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-fan-vfd-speed' AND alias='sfvs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-fan-vfd-speed', 'sf-vfd-speed', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-fan-vfd-speed' AND alias='sf-vfd-speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-fan-vfd-speed', 'suply fan vfd speed', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-fan-vfd-speed' AND alias='suply fan vfd speed');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'supply-fan-vfd-speed', 'sup fn variable frequency spd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='supply-fan-vfd-speed' AND alias='sup fn variable frequency spd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'task-lighting-level', 'task lighting level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='task-lighting-level' AND alias='task lighting level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'task-lighting-level', 'task-ltg-level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='task-lighting-level' AND alias='task-ltg-level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'task-lighting-level', 'task ltg level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='task-lighting-level' AND alias='task ltg level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'task-lighting-level', 'task-lite-level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='task-lighting-level' AND alias='task-lite-level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'task-lighting-level', 'tll', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='task-lighting-level' AND alias='tll');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'task-lighting-level', 'task lite level', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='task-lighting-level' AND alias='task lite level');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'thermal-energy', 'thermal energy', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='thermal-energy' AND alias='thermal energy');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'thermal-energy', 'therm-nrg', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='thermal-energy' AND alias='therm-nrg');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'thermal-energy', 'therm nrg', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='thermal-energy' AND alias='therm nrg');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'thermal-energy', 'thrm-nrg', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='thermal-energy' AND alias='thrm-nrg');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'thermal-energy', 'thrm nrg', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='thermal-energy' AND alias='thrm nrg');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'three-way-valve-position', 'three way valve position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='three-way-valve-position' AND alias='three way valve position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'three-way-valve-position', 'three-way-vlv-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='three-way-valve-position' AND alias='three-way-vlv-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'three-way-valve-position', 'three way vlv pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='three-way-valve-position' AND alias='three way vlv pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'three-way-valve-position', 'three-way-vv-psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='three-way-valve-position' AND alias='three-way-vv-psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'three-way-valve-position', 'twvp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='three-way-valve-position' AND alias='twvp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'three-way-valve-position', 'three-way-valve-pos', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='three-way-valve-position' AND alias='three-way-valve-pos');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'three-way-valve-position', 'three way vlv position', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='three-way-valve-position' AND alias='three way vlv position');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'three-way-valve-position', 'three way vv psn', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='three-way-valve-position' AND alias='three way vv psn');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'total-harmonic-distortion', 'total harmonic distortion', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='total-harmonic-distortion' AND alias='total harmonic distortion');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'total-harmonic-distortion', 'thd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='total-harmonic-distortion' AND alias='thd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ups-alarm', 'ups alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ups-alarm' AND alias='ups alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ups-alarm', 'ups-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ups-alarm' AND alias='ups-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ups-alarm', 'ups alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ups-alarm' AND alias='ups alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ups-alarm', 'ups-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ups-alarm' AND alias='ups-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ups-alarm', 'ups alram', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ups-alarm' AND alias='ups alram');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ups-alarm', 'ups alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ups-alarm' AND alias='ups alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ups-status', 'ups status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ups-status' AND alias='ups status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ups-status', 'ups-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ups-status' AND alias='ups-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ups-status', 'ups sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ups-status' AND alias='ups sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ups-status', 'ups-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ups-status' AND alias='ups-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ups-status', 'ups stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ups-status' AND alias='ups stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ventilation-airflow', 'ventilation airflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ventilation-airflow' AND alias='ventilation airflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ventilation-airflow', 'vent-airflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ventilation-airflow' AND alias='vent-airflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ventilation-airflow', 'vent airflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ventilation-airflow' AND alias='vent airflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ventilation-airflow', 'vntl-airflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ventilation-airflow' AND alias='vntl-airflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ventilation-airflow', 'vntl airflow', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ventilation-airflow' AND alias='vntl airflow');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ventilation-rate', 'ventilation rate', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ventilation-rate' AND alias='ventilation rate');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ventilation-rate', 'vent-rate', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ventilation-rate' AND alias='vent-rate');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ventilation-rate', 'vent rate', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ventilation-rate' AND alias='vent rate');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ventilation-rate', 'vntl-rate', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ventilation-rate' AND alias='vntl-rate');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'ventilation-rate', 'vntl rate', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='ventilation-rate' AND alias='vntl rate');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-fault-alarm', 'vfd fault alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-fault-alarm' AND alias='vfd fault alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-fault-alarm', 'drive-fault-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-fault-alarm' AND alias='drive-fault-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-fault-alarm', 'drive fault alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-fault-alarm' AND alias='drive fault alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-fault-alarm', 'variable frequency-fault-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-fault-alarm' AND alias='variable frequency-fault-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-fault-alarm', 'vfa', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-fault-alarm' AND alias='vfa');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-fault-alarm', 'vfd-fault-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-fault-alarm' AND alias='vfd-fault-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-fault-alarm', 'vfd fault alram', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-fault-alarm' AND alias='vfd fault alram');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-fault-alarm', 'variable frequency fault alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-fault-alarm' AND alias='variable frequency fault alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-command', 'vfd speed command', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-command' AND alias='vfd speed command');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-command', 'drive-spd-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-command' AND alias='drive-spd-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-command', 'drive spd cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-command' AND alias='drive spd cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-command', 'variable frequency-spd-com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-command' AND alias='variable frequency-spd-com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-command', 'vsc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-command' AND alias='vsc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-command', 'vfd-speed-cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-command' AND alias='vfd-speed-cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-command', 'variable frequency spd com', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-command' AND alias='variable frequency spd com');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-command', 'vfd speed cmd', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-command' AND alias='vfd speed cmd');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-setpoint', 'vfd speed setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-setpoint' AND alias='vfd speed setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-setpoint', 'drive-spd-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-setpoint' AND alias='drive-spd-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-setpoint', 'drive spd sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-setpoint' AND alias='drive spd sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-setpoint', 'variable frequency-spd-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-setpoint' AND alias='variable frequency-spd-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-setpoint', 'vss', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-setpoint' AND alias='vss');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-setpoint', 'vfd-speed-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-setpoint' AND alias='vfd-speed-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-setpoint', 'variable frequency spd stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-setpoint' AND alias='variable frequency spd stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-speed-setpoint', 'vfd speed sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-speed-setpoint' AND alias='vfd speed sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-status', 'vfd status', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-status' AND alias='vfd status');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-status', 'drive-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-status' AND alias='drive-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-status', 'drive sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-status' AND alias='drive sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-status', 'variable frequency-stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-status' AND alias='variable frequency-stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-status', 'vfd-sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-status' AND alias='vfd-sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-status', 'variable frequency stat', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-status' AND alias='variable frequency stat');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vfd-status', 'vfd sts', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vfd-status' AND alias='vfd sts');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vibration-alarm', 'vibration alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vibration-alarm' AND alias='vibration alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vibration-alarm', 'vib-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vibration-alarm' AND alias='vib-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vibration-alarm', 'vib alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vibration-alarm' AND alias='vib alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vibration-alarm', 'vib-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vibration-alarm' AND alias='vib-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vibration-alarm', 'vibration-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vibration-alarm' AND alias='vibration-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vibration-alarm', 'vibration alram', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vibration-alarm' AND alias='vibration alram');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vibration-alarm', 'vib alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vibration-alarm' AND alias='vib alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'vibration-alarm', 'vibration alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='vibration-alarm' AND alias='vibration alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-a', 'voltage phase a', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-a' AND alias='voltage phase a');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-a', 'volt-phase-a', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-a' AND alias='volt-phase-a');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-a', 'volt phase a', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-a' AND alias='volt phase a');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-a', 'v-phase-a', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-a' AND alias='v-phase-a');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-a', 'vpa', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-a' AND alias='vpa');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-a', 'v phase a', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-a' AND alias='v phase a');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-b', 'voltage phase b', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-b' AND alias='voltage phase b');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-b', 'volt-phase-b', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-b' AND alias='volt-phase-b');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-b', 'volt phase b', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-b' AND alias='volt phase b');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-b', 'v-phase-b', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-b' AND alias='v-phase-b');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-b', 'vpb', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-b' AND alias='vpb');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-b', 'v phase b', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-b' AND alias='v phase b');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-c', 'voltage phase c', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-c' AND alias='voltage phase c');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-c', 'volt-phase-c', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-c' AND alias='volt-phase-c');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-c', 'volt phase c', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-c' AND alias='volt phase c');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-c', 'v-phase-c', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-c' AND alias='v-phase-c');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-c', 'vpc', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-c' AND alias='vpc');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'voltage-phase-c', 'v phase c', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='voltage-phase-c' AND alias='v phase c');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'warmup-setpoint', 'warmup setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='warmup-setpoint' AND alias='warmup setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'warmup-setpoint', 'wu-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='warmup-setpoint' AND alias='wu-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'warmup-setpoint', 'wu sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='warmup-setpoint' AND alias='wu sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'warmup-setpoint', 'wu-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='warmup-setpoint' AND alias='wu-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'warmup-setpoint', 'warmup-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='warmup-setpoint' AND alias='warmup-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'warmup-setpoint', 'wu stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='warmup-setpoint' AND alias='wu stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'warmup-setpoint', 'warmup sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='warmup-setpoint' AND alias='warmup sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-consumption', 'water consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-consumption' AND alias='water consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-consumption', 'wtr-consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-consumption' AND alias='wtr-consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-consumption', 'wtr consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-consumption' AND alias='wtr consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-consumption', 'w-consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-consumption' AND alias='w-consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-consumption', 'w consumption', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-consumption' AND alias='w consumption');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-leak-alarm', 'water leak alarm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-leak-alarm' AND alias='water leak alarm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-leak-alarm', 'wtr-lk-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-leak-alarm' AND alias='wtr-lk-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-leak-alarm', 'wtr lk alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-leak-alarm' AND alias='wtr lk alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-leak-alarm', 'w-lk-alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-leak-alarm' AND alias='w-lk-alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-leak-alarm', 'wla', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-leak-alarm' AND alias='wla');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-leak-alarm', 'water-leak-alm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-leak-alarm' AND alias='water-leak-alm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-leak-alarm', 'water leak alram', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-leak-alarm' AND alias='water leak alram');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-leak-alarm', 'w lk alrm', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-leak-alarm' AND alias='w lk alrm');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-pressure', 'water pressure', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-pressure' AND alias='water pressure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-pressure', 'wtr-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-pressure' AND alias='wtr-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-pressure', 'wtr press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-pressure' AND alias='wtr press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-pressure', 'w-prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-pressure' AND alias='w-prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-pressure', 'water-press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-pressure' AND alias='water-press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-pressure', 'water presure', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-pressure' AND alias='water presure');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-pressure', 'w prs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-pressure' AND alias='w prs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'water-pressure', 'water press', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='water-pressure' AND alias='water press');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-co2-setpoint', 'zone co2 setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-co2-setpoint' AND alias='zone co2 setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-co2-setpoint', 'zn-carbon dioxide-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-co2-setpoint' AND alias='zn-carbon dioxide-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-co2-setpoint', 'zn carbon dioxide sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-co2-setpoint' AND alias='zn carbon dioxide sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-co2-setpoint', 'z-carbon dioxide-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-co2-setpoint' AND alias='z-carbon dioxide-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-co2-setpoint', 'zcs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-co2-setpoint' AND alias='zcs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-co2-setpoint', 'zone-co2-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-co2-setpoint' AND alias='zone-co2-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-co2-setpoint', 'z carbon dioxide stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-co2-setpoint' AND alias='z carbon dioxide stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-co2-setpoint', 'zone co2 sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-co2-setpoint' AND alias='zone co2 sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-humidity-setpoint', 'zone humidity setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-humidity-setpoint' AND alias='zone humidity setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-humidity-setpoint', 'zn-hum-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-humidity-setpoint' AND alias='zn-hum-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-humidity-setpoint', 'zn hum sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-humidity-setpoint' AND alias='zn hum sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-humidity-setpoint', 'z-rh-stpt', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-humidity-setpoint' AND alias='z-rh-stpt');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-humidity-setpoint', 'zhs', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-humidity-setpoint' AND alias='zhs');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-humidity-setpoint', 'zone-humidity-sp', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-humidity-setpoint' AND alias='zone-humidity-sp');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-humidity-setpoint', 'zone-hum-setpoint', 'common' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-humidity-setpoint' AND alias='zone-hum-setpoint');
INSERT INTO point_aliases (point_id, alias, alias_group) SELECT 'zone-humidity-setpoint', 'zone humidty setpoint', 'misspellings' WHERE NOT EXISTS (SELECT 1 FROM point_aliases WHERE point_id='zone-humidity-setpoint' AND alias='zone humidty setpoint');

COMMIT;
-- BAS Atlas Phase 6-7: Model Protocol Enrichment, Model-Equipment Links, and Brand Logos
-- Generated for models in data/catalog/models/*.json that lack protocols and equipment links

BEGIN TRANSACTION;

-- ═══════════════════════════════════════════════════════════
-- TASK 1: MODEL PROTOCOLS
-- ═══════════════════════════════════════════════════════════
-- Rules:
--   software → NO protocols (software platforms don't have communication protocols)
--   sensors (temperature, pressure, humidity, CO2, air-quality) → NO protocols (analog 0-10V / 4-20mA / thermistor)
--   damper-actuators → NO protocols (analog 0-10V / 2-10V control)
--   valve-actuators → NO protocols (analog proportional control)
--   network-controllers → BACnet IP, BACnet MSTP
--   supervisory-controllers → BACnet IP, BACnet MSTP
--   unitary-controllers → BACnet MSTP, Modbus RTU
--   vav-controllers → BACnet MSTP
--   zone-controllers → BACnet MSTP
--   gateways → BACnet IP, BACnet MSTP, Modbus TCP
--   thermostats → brand-dependent
--   meters → BACnet IP, Modbus RTU, Modbus TCP
--   vfds-drives → BACnet MSTP, Modbus RTU

-- -------------------------------------------------------
-- Automated Logic
-- -------------------------------------------------------

-- automated-logic-webctrl (software) → NO protocols
-- Software platforms do not have communication protocols themselves.

-- automated-logic-me812u (network-controllers) → BACnet IP, BACnet MSTP
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-me812u', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-me812u', 'BACnet MSTP');

-- automated-logic-se6104a (unitary-controllers) → BACnet MSTP, Modbus RTU
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-se6104a', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-se6104a', 'Modbus RTU');

-- automated-logic-zn551 (zone-controllers) → BACnet MSTP
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('automated-logic-zn551', 'BACnet MSTP');

-- -------------------------------------------------------
-- Belimo
-- -------------------------------------------------------

-- belimo-af24-sr (damper-actuators) → NO protocols
-- Analog 2-10VDC modulating actuator, not a communicating device.

-- belimo-b220 (valve-actuators) → NO protocols
-- Analog proportional control valve body, not a communicating device.

-- belimo-lrb24-3-t (valve-actuators) → NO protocols
-- Non-spring return rotary actuator with analog control.

-- belimo-22adp-54t (pressure-sensors) → NO protocols
-- Analog 4-20mA / 0-10VDC pressure sensor, not a network device.

-- -------------------------------------------------------
-- Delta Controls
-- -------------------------------------------------------

-- delta-controls-o3-din-s (network-controllers) → BACnet IP, BACnet MSTP
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-o3-din-s', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-o3-din-s', 'BACnet MSTP');

-- delta-controls-ebmgr (supervisory-controllers) → BACnet IP, BACnet MSTP
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-ebmgr', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-ebmgr', 'BACnet MSTP');

-- delta-controls-ebcon (unitary-controllers) → BACnet MSTP, Modbus RTU
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-ebcon', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-ebcon', 'Modbus RTU');

-- delta-controls-entelitouch (thermostats) → BACnet MSTP
-- Delta Controls uses BACnet natively for their thermostats.
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('delta-controls-entelitouch', 'BACnet MSTP');

-- -------------------------------------------------------
-- Distech Controls
-- -------------------------------------------------------

-- distech-controls-ec-bos-8 (supervisory-controllers) → BACnet IP, BACnet MSTP, Modbus TCP
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-ec-bos-8', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-ec-bos-8', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-ec-bos-8', 'Modbus TCP');

-- distech-controls-ecb-ptu (unitary-controllers) → BACnet MSTP, Modbus RTU
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-ecb-ptu', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-ecb-ptu', 'Modbus RTU');

-- distech-controls-ec-smart-vue (thermostats) → BACnet MSTP
-- Distech thermostats communicate via BACnet MS/TP.
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-ec-smart-vue', 'BACnet MSTP');

-- distech-controls-allure-ec-smart-one (zone-controllers) → BACnet MSTP, ZigBee
-- The Allure EC-Smart-One uses ZigBee wireless and communicates to BACnet via gateway.
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-allure-ec-smart-one', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('distech-controls-allure-ec-smart-one', 'ZigBee');

-- -------------------------------------------------------
-- Honeywell
-- -------------------------------------------------------

-- honeywell-jace-8000 (supervisory-controllers) → BACnet IP, BACnet MSTP, Modbus TCP, LON
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-jace-8000', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-jace-8000', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-jace-8000', 'Modbus TCP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-jace-8000', 'LON');

-- honeywell-spyder (unitary-controllers) → BACnet MSTP, LON
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-spyder', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-spyder', 'LON');

-- honeywell-jade-w7220 (vav-controllers) → BACnet MSTP, LON
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-jade-w7220', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-jade-w7220', 'LON');

-- honeywell-t6-pro (thermostats) → Z-Wave
-- The T6 Pro is a residential/light-commercial thermostat with Z-Wave wireless.
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('honeywell-t6-pro', 'Z-Wave');

-- honeywell-c7400a (air-quality-sensors) → NO protocols
-- Analog 4-20mA enthalpy sensor, not a network device.

-- honeywell-h7635b (humidity-sensors) → NO protocols
-- Analog 4-20mA / 0-10VDC humidity transmitter, not a network device.

-- -------------------------------------------------------
-- Johnson Controls
-- -------------------------------------------------------

-- johnson-controls-metasys (software) → NO protocols
-- Software platform, not a physical device with communication protocols.

-- johnson-controls-nae55 (supervisory-controllers) → BACnet IP, BACnet MSTP, N2
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-nae55', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-nae55', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-nae55', 'N2');

-- johnson-controls-fec (unitary-controllers) → BACnet MSTP
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-fec', 'BACnet MSTP');

-- johnson-controls-ms-vma1630 (vav-controllers) → BACnet MSTP
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-ms-vma1630', 'BACnet MSTP');

-- johnson-controls-tec3000 (thermostats) → BACnet MSTP
-- JCI TEC3000 series uses BACnet MS/TP for communication.
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('johnson-controls-tec3000', 'BACnet MSTP');

-- -------------------------------------------------------
-- Schneider Electric
-- -------------------------------------------------------

-- schneider-electric-ecostruxure (software) → NO protocols
-- Software platform, not a physical device.

-- schneider-electric-as-p (supervisory-controllers) → BACnet IP, BACnet MSTP, LON, Modbus TCP
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-as-p', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-as-p', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-as-p', 'LON');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-as-p', 'Modbus TCP');

-- schneider-electric-mn-s3 (unitary-controllers) → BACnet MSTP, LON
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-mn-s3', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-mn-s3', 'LON');

-- schneider-electric-se8350 (thermostats) → BACnet MSTP
-- Schneider SE8350 is a BACnet MS/TP thermostat.
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('schneider-electric-se8350', 'BACnet MSTP');

-- schneider-electric-ms41-7103 (valve-actuators) → NO protocols
-- Proportional spring-return analog valve actuator.

-- -------------------------------------------------------
-- Siemens
-- -------------------------------------------------------

-- siemens-desigo-cc (software) → NO protocols
-- Software platform, not a physical device.

-- siemens-pxc4 (supervisory-controllers) → BACnet IP, BACnet MSTP, Modbus TCP
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-pxc4', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-pxc4', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-pxc4', 'Modbus TCP');

-- siemens-rdg160kn (thermostats) → KNX
-- Siemens RDG160KN is a KNX room thermostat.
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('siemens-rdg160kn', 'KNX');

-- siemens-gdb161-1e (damper-actuators) → NO protocols
-- Analog 0-10VDC modulating damper actuator, not a communicating device.

-- siemens-mxg461 (valve-actuators) → NO protocols
-- Magnetic modulating control valve with analog actuation.

-- -------------------------------------------------------
-- Trane
-- -------------------------------------------------------

-- trane-tracer-es (software) → NO protocols
-- Software platform, not a physical device.

-- trane-tracer-sc-plus (supervisory-controllers) → BACnet IP, BACnet MSTP, N2
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-tracer-sc-plus', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-tracer-sc-plus', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-tracer-sc-plus', 'N2');

-- trane-uc600 (unitary-controllers) → BACnet MSTP, Modbus RTU
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-uc600', 'BACnet MSTP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-uc600', 'Modbus RTU');

-- trane-varitrane (vav-controllers) → BACnet MSTP
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('trane-varitrane', 'BACnet MSTP');

-- trane-xr724 (thermostats) → NO protocols
-- Trane XR724 is a proprietary thermostat that communicates via Trane proprietary bus,
-- not an open protocol. Do not assign open protocols.

-- -------------------------------------------------------
-- Veris
-- -------------------------------------------------------

-- veris-e50c2 (meters) → BACnet IP, Modbus RTU, Modbus TCP
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-e50c2', 'BACnet IP');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-e50c2', 'Modbus RTU');
INSERT OR IGNORE INTO model_protocols (model_id, protocol) VALUES ('veris-e50c2', 'Modbus TCP');

-- veris-cdd (co2-sensors) → NO protocols
-- Analog CO2 sensor with selectable output ranges, not a network device.

-- veris-px (pressure-sensors) → NO protocols
-- Analog differential pressure transducer, not a network device.

-- veris-h200 (humidity-sensors) → NO protocols
-- Analog 4-20mA / 0-10VDC humidity transmitter, not a network device.

-- veris-tw2x (temperature-sensors) → NO protocols
-- Analog wall temperature sensor (thermistor/RTD), not a network device.


-- ═══════════════════════════════════════════════════════════
-- TASK 2: MODEL-EQUIPMENT LINKS
-- ═══════════════════════════════════════════════════════════
-- Mapping logic:
--   network-controllers → building-controller, area-controller
--   supervisory-controllers → building-controller
--   vav-controllers → variable-air-volume-box, constant-air-volume-box
--   unitary-controllers → air-handling-unit, rooftop-unit, fan-coil-unit
--   zone-controllers → variable-air-volume-box, fan-coil-unit
--   damper-actuators → air-handling-unit, rooftop-unit, variable-air-volume-box, dedicated-outdoor-air-system
--   valve-actuators → air-handling-unit, fan-coil-unit, chiller, boiler
--   temperature-sensors → air-handling-unit, rooftop-unit, chiller, boiler
--   pressure-sensors → air-handling-unit, rooftop-unit, variable-air-volume-box
--   humidity-sensors → air-handling-unit, rooftop-unit, dedicated-outdoor-air-system
--   co2-sensors → air-handling-unit, variable-air-volume-box
--   air-quality-sensors → air-handling-unit
--   thermostats → rooftop-unit, fan-coil-unit, unit-ventilator
--   software → building-controller
--   gateways → building-controller
--   meters → electric-meter
--   vfds-drives → variable-frequency-drive, pump, exhaust-fan

-- -------------------------------------------------------
-- Automated Logic
-- -------------------------------------------------------

-- automated-logic-webctrl (software) → building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-webctrl', 'building-controller');

-- automated-logic-me812u (network-controllers) → building-controller, area-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-me812u', 'building-controller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-me812u', 'area-controller');

-- automated-logic-se6104a (unitary-controllers) → air-handling-unit, rooftop-unit, fan-coil-unit
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-se6104a', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-se6104a', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-se6104a', 'fan-coil-unit');

-- automated-logic-zn551 (zone-controllers) → variable-air-volume-box, fan-coil-unit
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-zn551', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('automated-logic-zn551', 'fan-coil-unit');

-- -------------------------------------------------------
-- Belimo
-- -------------------------------------------------------

-- belimo-af24-sr (damper-actuators) → air-handling-unit, rooftop-unit, variable-air-volume-box, dedicated-outdoor-air-system
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-af24-sr', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-af24-sr', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-af24-sr', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-af24-sr', 'dedicated-outdoor-air-system');

-- belimo-b220 (valve-actuators) → air-handling-unit, fan-coil-unit, chiller, boiler
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-b220', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-b220', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-b220', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-b220', 'boiler');

-- belimo-lrb24-3-t (valve-actuators) → air-handling-unit, fan-coil-unit, chiller, boiler
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-lrb24-3-t', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-lrb24-3-t', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-lrb24-3-t', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-lrb24-3-t', 'boiler');

-- belimo-22adp-54t (pressure-sensors) → air-handling-unit, rooftop-unit, variable-air-volume-box
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-22adp-54t', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-22adp-54t', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('belimo-22adp-54t', 'variable-air-volume-box');

-- -------------------------------------------------------
-- Delta Controls
-- -------------------------------------------------------

-- delta-controls-o3-din-s (network-controllers) → building-controller, area-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-o3-din-s', 'building-controller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-o3-din-s', 'area-controller');

-- delta-controls-ebmgr (supervisory-controllers) → building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-ebmgr', 'building-controller');

-- delta-controls-ebcon (unitary-controllers) → air-handling-unit, rooftop-unit, fan-coil-unit
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-ebcon', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-ebcon', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-ebcon', 'fan-coil-unit');

-- delta-controls-entelitouch (thermostats) → rooftop-unit, fan-coil-unit, unit-ventilator
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-entelitouch', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-entelitouch', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('delta-controls-entelitouch', 'unit-ventilator');

-- -------------------------------------------------------
-- Distech Controls
-- -------------------------------------------------------

-- distech-controls-ec-bos-8 (supervisory-controllers) → building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-ec-bos-8', 'building-controller');

-- distech-controls-ecb-ptu (unitary-controllers) → air-handling-unit, rooftop-unit, fan-coil-unit
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-ecb-ptu', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-ecb-ptu', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-ecb-ptu', 'fan-coil-unit');

-- distech-controls-ec-smart-vue (thermostats) → rooftop-unit, fan-coil-unit, unit-ventilator
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-ec-smart-vue', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-ec-smart-vue', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-ec-smart-vue', 'unit-ventilator');

-- distech-controls-allure-ec-smart-one (zone-controllers) → variable-air-volume-box, fan-coil-unit
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-allure-ec-smart-one', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('distech-controls-allure-ec-smart-one', 'fan-coil-unit');

-- -------------------------------------------------------
-- Honeywell
-- -------------------------------------------------------

-- honeywell-jace-8000 (supervisory-controllers) → building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-jace-8000', 'building-controller');

-- honeywell-spyder (unitary-controllers) → air-handling-unit, rooftop-unit, fan-coil-unit
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-spyder', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-spyder', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-spyder', 'fan-coil-unit');

-- honeywell-jade-w7220 (vav-controllers) → variable-air-volume-box, constant-air-volume-box
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-jade-w7220', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-jade-w7220', 'constant-air-volume-box');

-- honeywell-t6-pro (thermostats) → rooftop-unit, fan-coil-unit, unit-ventilator
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-t6-pro', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-t6-pro', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-t6-pro', 'unit-ventilator');

-- honeywell-c7400a (air-quality-sensors) → air-handling-unit
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-c7400a', 'air-handling-unit');

-- honeywell-h7635b (humidity-sensors) → air-handling-unit, rooftop-unit, dedicated-outdoor-air-system
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-h7635b', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-h7635b', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('honeywell-h7635b', 'dedicated-outdoor-air-system');

-- -------------------------------------------------------
-- Johnson Controls
-- -------------------------------------------------------

-- johnson-controls-metasys (software) → building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-metasys', 'building-controller');

-- johnson-controls-nae55 (supervisory-controllers) → building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-nae55', 'building-controller');

-- johnson-controls-fec (unitary-controllers) → air-handling-unit, rooftop-unit, fan-coil-unit
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-fec', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-fec', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-fec', 'fan-coil-unit');

-- johnson-controls-ms-vma1630 (vav-controllers) → variable-air-volume-box, constant-air-volume-box
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-ms-vma1630', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-ms-vma1630', 'constant-air-volume-box');

-- johnson-controls-tec3000 (thermostats) → rooftop-unit, fan-coil-unit, unit-ventilator
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-tec3000', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-tec3000', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('johnson-controls-tec3000', 'unit-ventilator');

-- -------------------------------------------------------
-- Schneider Electric
-- -------------------------------------------------------

-- schneider-electric-ecostruxure (software) → building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-ecostruxure', 'building-controller');

-- schneider-electric-as-p (supervisory-controllers) → building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-as-p', 'building-controller');

-- schneider-electric-mn-s3 (unitary-controllers) → air-handling-unit, rooftop-unit, fan-coil-unit
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-mn-s3', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-mn-s3', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-mn-s3', 'fan-coil-unit');

-- schneider-electric-se8350 (thermostats) → rooftop-unit, fan-coil-unit, unit-ventilator
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-se8350', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-se8350', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-se8350', 'unit-ventilator');

-- schneider-electric-ms41-7103 (valve-actuators) → air-handling-unit, fan-coil-unit, chiller, boiler
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-ms41-7103', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-ms41-7103', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-ms41-7103', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('schneider-electric-ms41-7103', 'boiler');

-- -------------------------------------------------------
-- Siemens
-- -------------------------------------------------------

-- siemens-desigo-cc (software) → building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-desigo-cc', 'building-controller');

-- siemens-pxc4 (supervisory-controllers) → building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-pxc4', 'building-controller');

-- siemens-rdg160kn (thermostats) → rooftop-unit, fan-coil-unit, unit-ventilator
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-rdg160kn', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-rdg160kn', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-rdg160kn', 'unit-ventilator');

-- siemens-gdb161-1e (damper-actuators) → air-handling-unit, rooftop-unit, variable-air-volume-box, dedicated-outdoor-air-system
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-gdb161-1e', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-gdb161-1e', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-gdb161-1e', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-gdb161-1e', 'dedicated-outdoor-air-system');

-- siemens-mxg461 (valve-actuators) → air-handling-unit, fan-coil-unit, chiller, boiler
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-mxg461', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-mxg461', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-mxg461', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('siemens-mxg461', 'boiler');

-- -------------------------------------------------------
-- Trane
-- -------------------------------------------------------

-- trane-tracer-es (software) → building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-tracer-es', 'building-controller');

-- trane-tracer-sc-plus (supervisory-controllers) → building-controller
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-tracer-sc-plus', 'building-controller');

-- trane-uc600 (unitary-controllers) → air-handling-unit, rooftop-unit, fan-coil-unit
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-uc600', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-uc600', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-uc600', 'fan-coil-unit');

-- trane-varitrane (vav-controllers) → variable-air-volume-box, constant-air-volume-box
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-varitrane', 'variable-air-volume-box');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-varitrane', 'constant-air-volume-box');

-- trane-xr724 (thermostats) → rooftop-unit, fan-coil-unit, unit-ventilator
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-xr724', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-xr724', 'fan-coil-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('trane-xr724', 'unit-ventilator');

-- -------------------------------------------------------
-- Veris
-- -------------------------------------------------------

-- veris-e50c2 (meters) → electric-meter
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-e50c2', 'electric-meter');

-- veris-cdd (co2-sensors) → air-handling-unit, variable-air-volume-box
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-cdd', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-cdd', 'variable-air-volume-box');

-- veris-px (pressure-sensors) → air-handling-unit, rooftop-unit, variable-air-volume-box
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-px', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-px', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-px', 'variable-air-volume-box');

-- veris-h200 (humidity-sensors) → air-handling-unit, rooftop-unit, dedicated-outdoor-air-system
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-h200', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-h200', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-h200', 'dedicated-outdoor-air-system');

-- veris-tw2x (temperature-sensors) → air-handling-unit, rooftop-unit, chiller, boiler
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-tw2x', 'air-handling-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-tw2x', 'rooftop-unit');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-tw2x', 'chiller');
INSERT OR IGNORE INTO model_equipment (model_id, equipment_id) VALUES ('veris-tw2x', 'boiler');


-- ═══════════════════════════════════════════════════════════
-- TASK 3: BRAND LOGOS
-- ═══════════════════════════════════════════════════════════

UPDATE brands SET logo_url = 'https://www.automatedlogic.com/favicon.ico' WHERE id = 'automated-logic';
UPDATE brands SET logo_url = 'https://www.belimo.com/favicon.ico' WHERE id = 'belimo';
UPDATE brands SET logo_url = 'https://www.deltacontrols.com/favicon.ico' WHERE id = 'delta-controls';
UPDATE brands SET logo_url = 'https://www.distech-controls.com/favicon.ico' WHERE id = 'distech-controls';
UPDATE brands SET logo_url = 'https://www.honeywell.com/content/dam/honeywellbt/global/en/images/favicon.ico' WHERE id = 'honeywell';
UPDATE brands SET logo_url = 'https://www.johnsoncontrols.com/favicon.ico' WHERE id = 'johnson-controls';
UPDATE brands SET logo_url = 'https://www.se.com/favicon.ico' WHERE id = 'schneider-electric';
UPDATE brands SET logo_url = 'https://www.siemens.com/favicon.ico' WHERE id = 'siemens';
UPDATE brands SET logo_url = 'https://www.trane.com/favicon.ico' WHERE id = 'trane';
UPDATE brands SET logo_url = 'https://www.veris.com/favicon.ico' WHERE id = 'veris';

COMMIT;
