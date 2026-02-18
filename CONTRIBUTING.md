# Contributing to BAS Atlas

## Quick Start
1. Fork and clone the repo.
2. Make updates to source data:
- Canonical baseline: `data/canonical/index.json`
- Granular sources (optional migration path): `data/brands`, `data/types`, `data/models`
3. Run checks:

```bash
npm run check
```

4. Submit a pull request with a clear summary.

## Data Rules
- Preserve existing IDs whenever possible.
- Do not remove existing public keys without a major version bump.
- Keep model-to-brand/type references valid.

## Validation Gates
- Build must be deterministic.
- Dist artifacts must pass JSON schema validation.
- Contract compatibility tests must pass.
