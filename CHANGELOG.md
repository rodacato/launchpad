# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### philosophy@0.2.0 — Voice skill + inheritable core principles

**Added:**

- `voice` skill — creates or updates a user-level Claude Code output style at
  `~/.claude/output-styles/<name>.md`. Invoked via `/philosophy:voice
  [style-name]`. Voice = how the agent sounds (global, per-user); Identity =
  what the agent thinks (per-project)
- `plugins/philosophy/shared/core-principles.md` v1.0 — the inheritable base
  block injected into every Build Identity. Universal rules (verify before
  asserting, stop-and-wait on questions, evidence over authority, scope
  discipline, …) that every project's IDENTITY.md now carries verbatim with a
  `<!-- inherited from philosophy/core-principles v1.0 -->` version marker

**Changed:**

- `identity` skill bumped to `1.3` — template now includes a
  `## Core Principles (inherited)` block at the top; Step 3 of the Create
  flow injects the current shared source verbatim; Update flow refreshes
  the block when the version marker drifts from the shared source. Manifest
  key also bumps to `"1.3"`

**Why:** Every Build Identity re-derived the same floor principles in slightly
different wording, producing drift and leaving gaps. The shared source + inline
copy pattern keeps IDENTITY.md self-contained (agent can read it without the
marketplace present) while letting a single update propagate via re-injection.
The new Voice skill separates tone (user-global) from judgment (project-local),
so the same human's agent sounds consistent across projects without forcing
every project to share technical opinions.

---

### launchpad@0.7.0 — Multi-plugin marketplace (BREAKING)

**Breaking changes:**

- Marketplace renamed from `launchpad-marketplace` to `kwik-e-marketplace`
- Repo renamed from `rodacato/launchpad` to `rodacato/kwik-e-dev` on GitHub
  (old URL continues to work via GitHub redirect)
- Plugin layout restructured: skills and commands moved into `plugins/launchpad/`
- Existing git installs will continue to function until users update the marketplace
- Upgrade path for installed users:

  ```bash
  /plugin uninstall launchpad@launchpad-marketplace
  /plugin marketplace remove launchpad-marketplace

  /plugin marketplace add git@github.com:rodacato/kwik-e-dev.git
  /plugin install launchpad@kwik-e-marketplace
  ```

**Added:**

- `lifecycle@0.1.0` plugin — daily work skills, currently ships `code-review`
  (invoked via `/lifecycle:review <PR-number>`)
- `philosophy@0.1.0` plugin — reference skills: `experts` (advisory panel) and
  `identity` (team way-of-working); invoked via `/philosophy:panel` and
  `/philosophy:identity`
- All 16 existing skills upgraded to the new SKILL.md format with
  `Rationalizations`, `Red Flags`, and `Verification` sections (see
  `docs/guides/skill-authoring.md` for the template)
- `docs/guides/development.md` — local plugin dev workflow
- `docs/guides/skill-authoring.md` — canonical skill template and process

**Changed:**

- Commands now namespaced per plugin: `/launchpad:*`, `/lifecycle:*`,
  `/philosophy:*`
- `experts` and `identity` skills moved from `launchpad` to `philosophy`
- Skill versions bumped across the board as part of the format upgrade

**Why:** Single-plugin install failed on local paths due to a Claude Code bug
([anthropics/claude-code#11278](https://github.com/anthropics/claude-code/issues/11278))
where plugins sharing a directory with `marketplace.json` fail to resolve. The
multi-plugin layout matches the official pattern used by Anthropic's own
marketplaces, unlocks independent versioning, and gives rodacato a single umbrella
for every future plugin.

---

## [0.6.0] - 2026-03-29

### Added

- Claude Code plugin structure (`.claude-plugin/plugin.json`, `marketplace.json`)
- 16 atomic skills under `skills/` — each with `SKILL.md`, `template.md`, `VERSION`
- Invocation via `/launchpad:vision`, `/launchpad:experts`, `/launchpad:github`, etc.
- Install: `claude plugin install launchpad@launchpad-marketplace`

### Changed

- `modules/` renamed to `skills/` — `prompt.md` → `SKILL.md` with YAML frontmatter
- `README.md` rewritten for plugin usage

### Removed

- `modules/`, `scripts/run.sh`, `scripts/check.sh`, `commands/` — replaced by plugin skills

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

[Unreleased]: https://github.com/rodacato/kwik-e-dev/compare/v0.6.0...HEAD
[0.6.0]: https://github.com/rodacato/kwik-e-dev/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/rodacato/kwik-e-dev/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/rodacato/kwik-e-dev/releases/tag/v0.4.0
