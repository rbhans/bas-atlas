import type { BabelData, BabelTemplatesData } from "../core.ts";
import { validatePointList } from "../core.ts";

export { validatePointList };

export function runValidation(
  equipmentTypeId: string,
  points: string[],
  data: BabelData,
  templates: BabelTemplatesData,
) {
  return validatePointList(equipmentTypeId, points, data, templates);
}
