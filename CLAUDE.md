# CLAUDE.md — Agent Context

> This file is loaded automatically by Claude Code. Keep it updated as the project evolves.
> Do not delete this file — it is the agent's memory of this project.

## Project identity

**Name**: <!-- project name -->
**Purpose**: <!-- one sentence -->
**Stack**: <!-- e.g. Ruby 3.3 / Roda / Postgres 16 -->
**Stage**: <!-- prototype | active | maintenance -->
**GitHub Project Number**: <!-- set during Phase 3b, used for board status updates -->

## Repository structure

```
.
├── .devcontainer/     # Dev environment (Docker + Claude Code + GitHub CLI)
├── .github/           # Issue templates, workflows, PR template
├── .launchpad/        # Template-managed files (synced from launchpad)
│   ├── AGENTS.md          # Base agent roles and behavior
│   ├── WORKFLOW.md        # Base process (sprints, PRs, automations)
│   └── manifest.yml       # Template version and source
├── src/               # Application code
├── tests/             # Test suite
├── docs/
│   ├── VISION.md          # Problem, goals, success metrics
│   ├── IDENTITY.md        # Who builds this and for whom
│   ├── ARCHITECTURE.md    # Tech stack, system design, ADRs
│   ├── ROADMAP.md         # Phases, milestones, risks
│   ├── BRANDING.md        # Name, voice, visual identity
│   ├── EXPERTS.md         # AI expert panel for decisions
│   ├── WORKFLOW.md        # Project-specific workflow customizations
│   ├── branding/          # Logo, icons, OG images
│   ├── guides/            # Operational guides (releasing, etc.)
│   └── screenshots/       # App screenshots for showroom
├── CLAUDE.md          # ← you are here
├── AGENTS.md          # Project-specific agent overrides
├── START_HERE.md      # Init guide (deleted after setup)
└── README.md          # Human-facing documentation
```

## How to start a session

1. Read `.launchpad/WORKFLOW.md` (base process) then `docs/WORKFLOW.md` (project specifics)
2. Run `gh issue list --assignee @me --state open` to see your active issues
3. If no issues assigned, run `gh issue list --state open --limit 10` and ask which to work
4. Never start work without an associated issue number

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

<!-- Add anything the agent needs to know: external APIs, quirks, constraints -->
<!-- Example: "The embeddings API has a 100 req/min rate limit" -->
<!-- Example: "Always run `bundle exec rspec` before opening a PR" -->
