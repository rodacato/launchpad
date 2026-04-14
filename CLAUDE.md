# CLAUDE.md — Agent Context

> This file is loaded automatically by Claude Code. Keep it updated as the project evolves.
> Do not delete this file — it is the agent's memory of this project.

## Project identity

**Name**: kwik-e-marketplace (repo: `kwik-e-dev`, currently still `launchpad` locally)
**Purpose**: rodacato's personal Claude Code plugin marketplace. Three plugins:
`launchpad` (project bootstrap), `lifecycle` (daily work skills), `philosophy`
(reference material — experts panel, identity, voice, orient meta-skill,
core principles + operating behaviors).
**Stack**: Markdown + YAML, Claude Code plugin format
**Stage**: active, pre-1.0

## Repository structure

```text
.
├── .claude-plugin/
│   └── marketplace.json          # Lists the three plugins
├── plugins/
│   ├── launchpad/                # Bootstrap plugin (v0.7.0)
│   │   ├── .claude-plugin/plugin.json
│   │   ├── commands/             # /launchpad:docs|ci|infra|process
│   │   └── skills/               # vision, architecture, devcontainer, kamal, ...
│   ├── lifecycle/                # Daily work plugin (v0.2.0)
│   │   ├── .claude-plugin/plugin.json
│   │   ├── commands/             # /lifecycle:review|git-workflow|debugging|simplify|ship
│   │   └── skills/               # code-review, git-workflow, debugging, simplify, ship
│   └── philosophy/               # Reference plugin (v0.3.0)
│       ├── .claude-plugin/plugin.json
│       ├── commands/             # /philosophy:panel, /philosophy:identity, /philosophy:voice, /philosophy:orient
│       ├── shared/               # core-principles.md, operating-behaviors.md
│       └── skills/               # experts, identity, voice, orient (meta)
├── docs/
│   ├── EXPERTS.md                # Reference panel consulted by skills
│   ├── IDENTITY.md
│   └── guides/
│       ├── development.md        # Local plugin dev loop
│       ├── skill-authoring.md    # SKILL.md template and authoring process
│       └── releasing.md
├── CHANGELOG.md
├── AGENTS.md
├── CLAUDE.md                     # ← you are here
└── README.md                     # Marketplace-level documentation
```

## Core conventions

- **Commits**: `type(scope): description` — types: feat, fix, docs, refactor, test, chore
  - Scopes include: `launchpad`, `lifecycle`, `philosophy`, `skills`, `docs`, `marketplace`
- **Branches**: `issue-{number}-{short-description}` — e.g. `issue-14-add-search-endpoint`
- **PRs**: always reference the issue with `closes #N` in the PR body
- **Tests**: write tests before or alongside code, never after a PR is opened
- **Never** add Co-Authored-By lines or "Generated with Claude" attributions in
  commits, PRs, or issues

## What NOT to do

- Do not push directly to `master`
- Do not create issues — that is the human's job
- Do not close issues manually — they close via PR merge (`closes #N`)
- Do not modify `.env` or secrets — ask the human
- Do not install global dependencies without noting them in the PR
- Do not add skills outside the three existing plugins without first discussing
  which plugin they belong to (bootstrap / lifecycle / philosophy)

## Environment

```bash
# Check your tools
claude --version
gh auth status
git --version
```

Plugin dev setup is documented in `docs/guides/development.md`.

## Project-specific notes

- **Bootstrap skills** produce files in target projects. They have `SKILL.md`,
  `template.md`, and `VERSION`. The template must stay in sync with what the
  SKILL.md tells the agent to produce.
- **Lifecycle and philosophy skills** do not ship a `template.md` — their output
  is an action (a review, a consultation), not a file.
- **VERSION files** contain only a semver string (e.g. `1.0`) — no newlines.
  Bump VERSION on every skill change that alters behavior, not just content.
- **Skill format** is defined in `docs/guides/skill-authoring.md`. Every skill
  must have Overview, When to Use, Process, Common Rationalizations, Red Flags,
  and Verification sections.
- **Commands** live at `plugins/<plugin>/commands/*.md`. Each command file has
  a frontmatter `description` and dispatches to a skill by reading its `SKILL.md`.
- **Marketplace and plugin versions** are tracked in:
  - `.claude-plugin/marketplace.json` (each plugin's version in the entry)
  - `plugins/<plugin>/.claude-plugin/plugin.json` (authoritative)
  - They must match.
- **CHANGELOG** entries are per-plugin under `## launchpad@X.Y.Z`,
  `## lifecycle@X.Y.Z`, `## philosophy@X.Y.Z` sections since plugins version
  independently.
- **Shared inheritable content** lives at `plugins/<plugin>/shared/`. Currently
  only `philosophy/shared/core-principles.md` exists — it is copied verbatim
  into every generated `docs/IDENTITY.md` with a `<!-- inherited from
  philosophy/core-principles vX.Y -->` marker. Bump its version (inside the
  file's header comment) whenever principles change; the `identity` skill
  refreshes downstream copies on next run.
- **Persona layering**: Core Principles (shared, inherited) < Identity
  (project, `docs/IDENTITY.md`) < Voice (user-global,
  `~/.claude/output-styles/<name>.md`). Core Principles = the floor. Identity
  = what the agent thinks on this project. Voice = how the agent sounds
  across all projects.
- **Floor for every session**: `core-principles.md` (rules / values) +
  `operating-behaviors.md` (situation-triggered reflexes). The `orient`
  meta-skill loads both before any other skill runs. Update the shared
  source to update everywhere; do NOT hand-edit copies in target projects.
- **Skill discovery entry point**: `philosophy:orient`. Use it when the
  matching skill isn't obvious — it walks a decision tree across all three
  plugins and returns one routing decision plus the loaded floor. Skip it
  for unambiguous tasks.
