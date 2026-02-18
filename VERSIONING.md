# Versioning Policy

## Dataset Versioning
- **Major** (`X.0.0`): breaking schema or contract changes.
- **Minor** (`x.Y.0`): additive schema fields/artifacts.
- **Patch** (`x.y.Z`): content-only updates.

## Compatibility Rule
- Existing fields in `dist/index.json`, `dist/categories.json`, and `dist/search-index.json` are not removed or renamed in minor/patch releases.

## Release Checklist
1. `npm run check`
2. Update `CHANGELOG.md`
3. Bump version in `package.json`
4. Tag release (`vX.Y.Z`)
