# Versioning Policy

## Dataset Versioning
- **Major** (`X.0.0`): breaking schema or contract changes.
- **Minor** (`x.Y.0`): additive schema fields, new artifacts, new non-breaking endpoints or capabilities.
- **Patch** (`x.y.Z`): content-only updates, typo fixes, metadata corrections.

## Compatibility Rule
- Existing fields in `dist/index.json`, `dist/search-index.json`, and `dist/categories.json` must not be removed or renamed in minor/patch releases.
- New fields should be additive first.

## Release Checklist
1. `npm run check`
2. Update `CHANGELOG.md`
3. Bump `package.json` version
4. Tag release (`vX.Y.Z`)
5. Publish release artifacts from `dist/`
