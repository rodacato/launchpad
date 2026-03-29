# CLAUDE.md — Agent Context

> This file is loaded automatically by Claude Code. Keep it updated as the project evolves.
> Do not delete this file — it is the agent's memory of this project.

## Project identity

**Name**: Launchpad
**Purpose**: Modular project setup system — composable modules that guide an AI agent through creating project docs, configuring infrastructure, and standardizing workflows
**Stack**: Bash + Markdown
**Stage**: active
**GitHub Project Number**: <!-- set after creating project board -->

## Repository structure

```text
.
├── modules/
│   ├── docs/              # Documentation modules (vision, identity, experts, etc.)
│   ├── ci/                # CI/GitHub modules (github, labels, workflows, board)
│   ├── infra/             # Infrastructure modules (devcontainer, kamal, caddy)
│   └── process/           # Process modules (releasing, contributing, changelog)
├── scripts/
│   ├── run.sh             # Module runner — creates LAUNCHPAD_TASK.md
│   └── check.sh           # Version checker — shows module status
├── .launchpad/
│   └── manifest.yml       # Installed module versions (for launchpad itself)
├── CLAUDE.md          # ← you are here
├── AGENTS.md          # Agent roles and startup behavior
└── README.md          # Tool documentation
```

## Core conventions

- **Commits**: `type(scope): description` — types: feat, fix, docs, refactor, test, chore
- **Branches**: `issue-{number}-{short-description}` — e.g. `issue-14-add-search-endpoint`
- **PRs**: always reference the issue with `closes #N` in the PR body
- **Tests**: write tests before or alongside code, never after a PR is opened

## What NOT to do

- Do not push directly to `main`
- Do not create issues — that is the human's job
- Do not close issues manually — they close via PR merge (`closes #N`)
- Do not modify `.env` or secrets — ask the human
- Do not install global dependencies without noting them in the PR
- Do not add Co-Authored-By lines or "Generated with" attributions in commits, PRs, or issues

## Environment

```bash
# Check your tools
claude --version
gh auth status
git --version
```

## Project-specific notes

- When editing a module, always read `modules/{category}/{name}/template.md` alongside `prompt.md` — they must stay in sync
- Test `scripts/run.sh` changes by running them against a local test project, not this repo
- `VERSION` files contain only a semver string (e.g. `1.0`) — no newlines, no extra content
- The `scripts/check.sh` MODULES array and `scripts/run.sh` module lists must be kept in sync when adding or removing modules
