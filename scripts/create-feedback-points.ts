import * as fs from "fs";
import * as path from "path";
import { parse as parseYaml, stringify as stringifyYaml } from "yaml";

const POINTS_DIR = path.join(process.cwd(), "data/points");

// Find all output point files
function findOutputFiles(dir: string): string[] {
  const results: string[] = [];
  const items = fs.readdirSync(dir, { withFileTypes: true });

  for (const item of items) {
    const fullPath = path.join(dir, item.name);
    if (item.isDirectory()) {
      results.push(...findOutputFiles(fullPath));
    } else if (item.name.endsWith("-output.yaml")) {
      results.push(fullPath);
    }
  }
  return results;
}

// Haystack tag mappings for feedback points
const haystackFeedbackMap: Record<string, string> = {
  // Valves - output is cmd, feedback is position sensor
  "cool valve cmd": "cool valve sensor",
  "heat valve cmd": "heat valve sensor",
  "bypass valve cmd": "bypass valve sensor",
  "mixing valve cmd": "mixing valve sensor",
  "isolation valve cmd": "isolation valve sensor",

  // Dampers - output is cmd, feedback is position sensor
  "outside air damper cmd": "outside air damper sensor",
  "mixed air damper cmd": "mixed air damper sensor",
  "exhaust damper cmd": "exhaust damper sensor",
  "relief damper cmd": "relief damper sensor",
  "economizer cmd": "economizer sensor",
  "face bypass damper cmd": "face bypass damper sensor",

  // Fans - output is speed cmd, feedback is speed sensor
  "supply fan speed cmd": "supply fan speed sensor",
  "return fan speed cmd": "return fan speed sensor",
  "exhaust fan speed cmd": "exhaust fan speed sensor",
  "relief fan speed cmd": "relief fan speed sensor",

  // Pumps
  "chilled water pump cmd": "chilled water pump speed sensor",
  "hot water pump cmd": "hot water pump speed sensor",
  "condenser water pump cmd": "condenser water pump speed sensor",
  "boiler pump cmd": "boiler pump speed sensor",
  "primary chilled water pump cmd": "primary chilled water pump speed sensor",
  "secondary chilled water pump cmd": "secondary chilled water pump speed sensor",

  // Equipment
  "boiler cmd": "boiler run sensor",
  "cooling tower cmd": "cooling tower run sensor",
  "heat wheel cmd": "heat wheel speed sensor",
  "humidifier cmd": "humidifier run sensor",
  "steam heat cmd": "steam heat sensor",
  "gas heat cmd": "gas heat sensor",
};

// Brick class mappings for feedback points
const brickFeedbackMap: Record<string, string> = {
  // Valves
  "Cooling_Valve_Command": "Cooling_Valve_Position_Sensor",
  "Heating_Valve_Command": "Heating_Valve_Position_Sensor",
  "Bypass_Valve_Command": "Bypass_Valve_Position_Sensor",
  "Valve_Command": "Valve_Position_Sensor",
  "Isolation_Valve_Command": "Isolation_Valve_Position_Sensor",

  // Dampers
  "Outside_Air_Damper_Command": "Outside_Air_Damper_Position_Sensor",
  "Mixed_Air_Damper_Command": "Mixed_Air_Damper_Position_Sensor",
  "Exhaust_Air_Damper_Command": "Exhaust_Air_Damper_Position_Sensor",
  "Relief_Damper_Command": "Relief_Damper_Position_Sensor",
  "Damper_Command": "Damper_Position_Sensor",
  "Economizer_Damper_Command": "Economizer_Damper_Position_Sensor",

  // Fans
  "Supply_Fan_Speed_Command": "Supply_Fan_Speed_Sensor",
  "Return_Fan_Speed_Command": "Return_Fan_Speed_Sensor",
  "Exhaust_Fan_Speed_Command": "Exhaust_Fan_Speed_Sensor",
  "Fan_Speed_Command": "Fan_Speed_Sensor",

  // Pumps
  "Pump_Command": "Pump_Speed_Sensor",
  "Chilled_Water_Pump_Command": "Chilled_Water_Pump_Speed_Sensor",
  "Hot_Water_Pump_Command": "Hot_Water_Pump_Speed_Sensor",
  "Condenser_Water_Pump_Command": "Condenser_Water_Pump_Speed_Sensor",

  // Equipment
  "Boiler_Command": "Boiler_Status",
  "Cooling_Tower_Command": "Cooling_Tower_Status",
  "Heat_Wheel_Command": "Heat_Wheel_Speed_Sensor",
  "Humidifier_Command": "Humidifier_Status",
};

// Convert output aliases to feedback aliases
function convertAliases(aliases: string[]): string[] {
  return aliases.map(alias => {
    // Replace output/out/cmd with feedback/fb
    let fb = alias
      .replace(/-o$/i, "-fb")
      .replace(/\bout(put)?\b/gi, "feedback")
      .replace(/\bcmd\b/gi, "fb")
      .replace(/\bcommand\b/gi, "feedback");

    // If no change was made, append " fb" or "-fb"
    if (fb === alias) {
      if (alias.includes(" ")) {
        fb = alias + " fb";
      } else if (alias.includes("-")) {
        fb = alias + "-fb";
      } else {
        fb = alias + " feedback";
      }
    }

    return fb;
  });
}

function createFeedbackPoint(outputFile: string): void {
  const content = fs.readFileSync(outputFile, "utf-8");
  const data = parseYaml(content);

  // Create feedback version
  const feedbackId = data.concept.id.replace("-output", "-feedback");
  const feedbackName = data.concept.name.replace("Output", "Feedback");
  const feedbackDesc = data.concept.description
    .replace("Output", "Feedback")
    .replace("output", "feedback")
    .replace("command", "actual position/state")
    .replace("Command", "Actual position/state");

  // If description is just "[Name] Output point", make it more descriptive
  if (feedbackDesc.includes("Feedback point")) {
    const baseName = feedbackName.replace(" Feedback", "");
    feedbackDesc.replace(
      `${baseName} Feedback point`,
      `Actual position/state feedback from ${baseName.toLowerCase()}`
    );
  }

  // Convert Haystack tag
  let feedbackHaystack = data.concept.haystack;
  if (feedbackHaystack && feedbackHaystack !== "-") {
    // Try direct mapping first
    if (haystackFeedbackMap[feedbackHaystack]) {
      feedbackHaystack = haystackFeedbackMap[feedbackHaystack];
    } else {
      // Generic conversion: replace cmd with sensor
      feedbackHaystack = feedbackHaystack
        .replace(/\bcmd\b/g, "sensor")
        .replace(/\bcommand\b/g, "sensor");
    }
  }

  // Convert Brick class
  let feedbackBrick = data.concept.brick;
  if (feedbackBrick && feedbackBrick !== "-") {
    // Try direct mapping first
    if (brickFeedbackMap[feedbackBrick]) {
      feedbackBrick = brickFeedbackMap[feedbackBrick];
    } else {
      // Generic conversion: replace Command with Position_Sensor or Status
      feedbackBrick = feedbackBrick
        .replace(/_Command$/, "_Position_Sensor")
        .replace(/_Cmd$/, "_Position_Sensor");
    }
  }

  // Convert aliases
  const feedbackAliases = convertAliases(data.aliases.common || []);

  // Build feedback point data
  const feedbackData: any = {
    concept: {
      id: feedbackId,
      name: feedbackName,
      category: data.concept.category,
      description: `Actual position/state feedback from ${feedbackName.replace(" Feedback", "").toLowerCase()}`,
      haystack: feedbackHaystack || "-",
      brick: feedbackBrick || "-",
    },
    aliases: {
      common: feedbackAliases,
    },
  };

  // Add unit if valve/damper (percentage)
  if (data.concept.category === "valves" || data.concept.category === "dampers") {
    feedbackData.concept.unit = "%";
    feedbackData.concept.typical_range = { min: 0, max: 100 };
    feedbackData.concept.object_type = "analogInput";
  } else if (data.concept.category === "fans") {
    feedbackData.concept.unit = "%";
    feedbackData.concept.typical_range = { min: 0, max: 100 };
    feedbackData.concept.object_type = "analogInput";
  }

  // Add related pointing back to output
  feedbackData.related = [data.concept.id];

  // Write feedback file
  const feedbackFile = outputFile.replace("-output.yaml", "-feedback.yaml");
  const yamlContent = stringifyYaml(feedbackData, { lineWidth: 0 });
  fs.writeFileSync(feedbackFile, yamlContent);

  console.log(`Created: ${path.basename(feedbackFile)}`);

  // Also update the output file to reference the feedback
  if (!data.related) {
    data.related = [];
  }
  if (!data.related.includes(feedbackId)) {
    data.related.push(feedbackId);
    const updatedYaml = stringifyYaml(data, { lineWidth: 0 });
    fs.writeFileSync(outputFile, updatedYaml);
    console.log(`  Updated: ${path.basename(outputFile)} with related reference`);
  }
}

// Main
const outputFiles = findOutputFiles(POINTS_DIR);
console.log(`Found ${outputFiles.length} output points\n`);

for (const file of outputFiles) {
  createFeedbackPoint(file);
}

console.log(`\nCreated ${outputFiles.length} feedback points`);
