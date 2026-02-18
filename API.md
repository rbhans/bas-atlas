# BAS Babel API + CLI Usage

## Static JSON Endpoints
Public data can be consumed from GitHub raw:
- `dist/index.json`
- `dist/categories.json`
- `dist/search-index.json`
- `dist/templates.json`
- `dist/graph.json`

## CLI
After install or from repo root:

```bash
bas-babel validate --equipment ahu --file ./examples/points.txt
bas-babel normalize --name "AHU-1 SAT"
```

## Validator Output Contract
`validate` returns:
- `matched: [{ input, pointId, confidence }]`
- `missingRequired: string[]`
- `missingRecommended: string[]`
- `unknown: string[]`
- `suggestions: [{ input, candidates: [{ pointId, confidence }] }]`

## Notes
- CLI reads from local `dist/` artifacts.
- Run `npm run build:clean` before validation to ensure data is current.
