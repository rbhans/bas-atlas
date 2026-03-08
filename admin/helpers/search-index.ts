import { run, all } from "../db.js";

export function updateSearchEntry(
  entityId: string,
  entityType: string,
  name: string,
  tokens: string[],
): void {
  run(
    `DELETE FROM search_index WHERE entry_id = ? AND entry_type = ?`,
    entityId,
    entityType,
  );
  run(
    `INSERT INTO search_index (entry_id, entry_type, name, tokens) VALUES (?, ?, ?, ?)`,
    entityId,
    entityType,
    name,
    tokens.join(" "),
  );
}

export function deleteSearchEntry(
  entityId: string,
  entityType: string,
): void {
  run(
    `DELETE FROM search_index WHERE entry_id = ? AND entry_type = ?`,
    entityId,
    entityType,
  );
}

export function extractPointTokensFromDb(point: {
  id: string;
  name: string;
  description?: string;
  haystack_tag_string?: string;
}): string[] {
  const tokens: string[] = [];
  tokens.push(point.name.toLowerCase());
  tokens.push(point.id.toLowerCase());
  if (point.description)
    tokens.push(...point.description.toLowerCase().split(/\s+/));
  if (point.haystack_tag_string)
    tokens.push(
      ...point.haystack_tag_string.toLowerCase().split(/\s+/),
    );

  // Add aliases
  const aliases = all<{ alias: string }>(
    `SELECT alias FROM point_aliases WHERE point_id = ?`,
    point.id,
  );
  for (const a of aliases) tokens.push(a.alias.toLowerCase());

  return [...new Set(tokens.filter((t) => t.length > 0))];
}

export function extractEquipTokensFromDb(equip: {
  id: string;
  name: string;
  full_name?: string;
  abbreviation?: string;
  description?: string;
  haystack_tag_string?: string;
}): string[] {
  const tokens: string[] = [];
  tokens.push(equip.name.toLowerCase());
  tokens.push(equip.id.toLowerCase());
  if (equip.full_name) tokens.push(equip.full_name.toLowerCase());
  if (equip.abbreviation) tokens.push(equip.abbreviation.toLowerCase());
  if (equip.description)
    tokens.push(...equip.description.toLowerCase().split(/\s+/));
  if (equip.haystack_tag_string)
    tokens.push(
      ...equip.haystack_tag_string.toLowerCase().split(/\s+/),
    );

  const aliases = all<{ alias: string }>(
    `SELECT alias FROM equipment_aliases WHERE equipment_id = ?`,
    equip.id,
  );
  for (const a of aliases) tokens.push(a.alias.toLowerCase());

  return [...new Set(tokens.filter((t) => t.length > 0))];
}
