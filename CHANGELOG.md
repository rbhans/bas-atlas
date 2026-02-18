# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Deterministic build pipeline with `build:clean`.
- JSON Schema validation for all public dist artifacts.
- Additive point/equipment schema fields (`kind`, normalized metadata, alias variants, equipment concept metadata).
- Enhanced search index (`weightedTokens`, `ngrams`) while preserving legacy `tokens`.
- Point name normalization engine with confidence scoring.
- Equipment-to-point templates dataset (`dist/templates.json`).
- Graph dataset (`dist/graph.json`) with traversal utilities.
- Validator engine and CLI support (`bas-babel validate`).
- Contract compatibility tests, normalization fixtures, and determinism regression checks.

### Changed
- CI now enforces clean build + validate + tests.

## [1.0.0] - 2026-02-07

### Added
- Initial BAS Babel dataset, build scripts, and static dist artifacts.
