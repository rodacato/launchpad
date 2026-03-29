# Launchpad

> Standardized project bootstrapping with AI-assisted development workflows.

<!-- TEMPLATE DOCS — remove this entire section during project setup (Phase 4) -->

## How to use Launchpad

### New project (start from scratch)

1. Click **"Use this template"** → "Create a new repository" on GitHub
2. Clone the new repo and open in VS Code
3. The agent detects `START_HERE.md` and walks you through the full setup
4. Result: docs, devcontainer, workflows, board, sprint — all configured

### Existing project (add the process layer)

```bash
# Run from your project root
curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/install.sh | bash
```

What it does:
- Creates `.launchpad/` with base workflow and agent roles (3 markdown files)
- Copies GitHub workflows and issue templates (only if missing — never overwrites)
- Drops `ADOPT.md` — the agent reads it and sets everything up interactively

What it does NOT do:
- Modify any existing file
- Delete anything
- Push to remote
- Run anything beyond copying files

You review with `git diff` before committing.

### Already using Launchpad (update)

```bash
# Same command — detects launchpad and syncs .launchpad/ files only
curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/install.sh | bash
```

What it does:
- Compares your `.launchpad/manifest.yml` version against the template
- If outdated, downloads updated `.launchpad/*.md` files
- Never touches anything outside `.launchpad/`

### Leave Launchpad

```bash
rm -rf .launchpad/
```

That's it. Everything outside `.launchpad/` is yours — workflows, templates, docs. They keep working without launchpad.

### What goes where

| Location | Owner | Synced? | Purpose |
|----------|-------|---------|---------|
| `.launchpad/` | Launchpad template | Yes | Base process, agent roles, version |
| `AGENTS.md` | Your project | Never | Project-specific agent overrides |
| `docs/WORKFLOW.md` | Your project | Never | Definition of done, test strategy |
| `.github/workflows/` | Your project | Never | Copied once, yours to customize |
| Everything else | Your project | Never | Code, docs, config |

---

<!-- END TEMPLATE DOCS -->

# Project Name

> One-line description of the project.

---

## What is this

This project was bootstrapped from [launchpad](https://github.com/rodacato/launchpad) — a template for starting new projects with standardized structure, AI-assisted development, and automated workflows.

If you just cloned this template, start by reading `START_HERE.md` — it will guide you through the full setup process.

## Stack

Defined during project setup. See `docs/ARCHITECTURE.md` for the full tech stack and design decisions.

## Getting started

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) or Docker + Docker Compose
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- A Claude Max or Pro subscription (for Claude Code)
- A GitHub account with `gh` CLI configured

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/{org}/{repo}.git
cd {repo}

# 2. Copy environment variables
cp .env.example .env
# Edit .env with your values

# 3. Open in VS Code and reopen in container
code .
# VS Code will prompt: "Reopen in Container" — click it
# Or: Cmd+Shift+P → "Dev Containers: Reopen in Container"

# 4. Verify setup (runs automatically, but you can check)
bash .devcontainer/setup.sh
```

### First time only

```bash
# Authenticate GitHub CLI
gh auth login

# Claude Code will prompt for auth on first use
claude
```

## Project structure

```
.
├── .devcontainer/           # Dev environment (Docker + Claude Code + GitHub CLI)
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── setup.sh
├── .github/                 # Issue templates, PR template, workflows
│   ├── ISSUE_TEMPLATE/
│   ├── workflows/
│   └── PULL_REQUEST_TEMPLATE.md
├── docs/
│   ├── VISION.md            # Project compass — problem, philosophy, litmus test
│   ├── IDENTITY.md          # Build persona — the AI's technical voice
│   ├── EXPERTS.md           # Expert advisory panel for decisions
│   ├── ARCHITECTURE.md      # System design, domain model, tech decisions
│   ├── ROADMAP.md           # What's built, what's next, what's not happening
│   ├── BRANDING.md          # Visual identity, voice, design tokens
│   ├── WORKFLOW.md          # How work is organized — build cycle, playbooks
│   ├── adr/                 # Architecture Decision Records
│   ├── specs/               # Feature implementation blueprints
│   ├── branding/            # Logo, icons, OG images
│   ├── guides/              # Operational guides (releasing, etc.)
│   └── screenshots/         # App screenshots
├── src/                     # Application code
├── tests/                   # Test suite
├── CLAUDE.md                # Agent context — loaded every session
├── AGENTS.md                # Agent roles and startup behavior
├── CHANGELOG.md             # Version history (Keep a Changelog)
└── .notdefined.yml          # Metadata for rodacato.github.io showroom
```

## Documentation

| Document | What it answers |
|----------|----------------|
| [VISION.md](docs/VISION.md) | Why does this exist? What problem does it solve? |
| [IDENTITY.md](docs/IDENTITY.md) | Who is the technical voice behind this project? |
| [EXPERTS.md](docs/EXPERTS.md) | Who do we consult for cross-cutting decisions? |
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | How is the system built? What patterns? What stack? |
| [ROADMAP.md](docs/ROADMAP.md) | What's done? What's next? What are we NOT building? |
| [BRANDING.md](docs/BRANDING.md) | How does it look and sound? |
| [WORKFLOW.md](docs/WORKFLOW.md) | How does work flow from idea to shipped feature? |
| [CHANGELOG.md](CHANGELOG.md) | What shipped in each version? |

## Development

### Working with issues and sprints

This project uses GitHub Issues as the task system and GitHub Milestones as sprints.
See [WORKFLOW.md](docs/WORKFLOW.md) for the full process.

```bash
# See current sprint
gh issue list --milestone "Sprint 1" --state open

# See all open issues
gh issue list --state open
```

### Agents

This project uses AI agents for development. See [AGENTS.md](AGENTS.md) for details.

- **Team Lead** — Claude Code, runs locally in the devcontainer

## Releases

This project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/).

See [releasing guide](docs/guides/releasing.md) for the release process.

## License

See [LICENSE](LICENSE).
