# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [0.5.0] - 2026-03-29

### Added

- Modular system: each module is independently installable and updatable via `scripts/run.sh`
- `scripts/run.sh` — universal module runner; fetches `prompt.md`, adds project context, writes `LAUNCHPAD_TASK.md`
- `scripts/check.sh` — shows installed vs. remote version for all modules
- 16 modules across 4 categories: `docs/` (vision, identity, experts, architecture, branding, roadmap, workflow, agents, notdefined), `ci/` (github), `infra/` (devcontainer, kamal, caddy), `process/` (releasing, contributing, changelog)
- Per-module version tracking in `.launchpad/manifest.yml`
- Module groups: `concept`, `technical`, `process`
- `modules/ci/github/` — GitHub workflows, issue templates, PR template (moved from `.github/`)
- `modules/infra/devcontainer/` — dev environment with guided language/service selection (moved from `.devcontainer/`)

### Changed

- `.launchpad/manifest.yml` format changed from global `version:` to per-module `modules:` map
- `README.md` rewritten as tool documentation (launchpad is no longer a GitHub template)
- `AGENTS.md` rewritten with real agent roles for this repo
- `CLAUDE.md` updated to reflect actual project structure

### Removed

- `scripts/adopt.sh`, `scripts/sync.sh`, `scripts/install.sh` — replaced by modular `run.sh`
- `.launchpad/ADOPT.md`, `.launchpad/WORKFLOW.md`, `.launchpad/AGENTS.md` — no longer needed
- `START_HERE.md` — content merged into `README.md`
- `.devcontainer/` and `.github/` from repo root (now live inside their respective modules)
- `.notdefined.yml` from repo root (now a module: `docs/notdefined`)
- Blank placeholder docs from `docs/` (each module carries its own `template.md`)

---

## [0.4.0] - 2025-01-01

- Initial project setup from forge-template

---

<!-- Template for future releases:

## [X.Y.Z] - YYYY-MM-DD

### Added
### Changed
### Removed
### Fixed
### Security

-->

[Unreleased]: https://github.com/rodacato/launchpad/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/rodacato/launchpad/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/rodacato/launchpad/releases/tag/v0.4.0
