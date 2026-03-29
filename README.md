# Launchpad

> Modular project bootstrapping for AI-assisted development.

Launchpad is a collection of independent modules. Each one guides an AI agent through creating or updating a specific document or configuration in your project. You pick what you need, run it, and the agent does the work.

## How it works

1. Run a module from your project root:

```bash
bash <(curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/run.sh) <module>
```

1. This creates `LAUNCHPAD_TASK.md` with context-aware instructions for the agent
1. Tell Claude Code: **"read LAUNCHPAD_TASK.md and execute it"**

The bash script prepares context (what files exist, what version is installed). The agent does the actual work.

---

## New project

```bash
# 1. Create a repo on GitHub, clone it, cd into it

# 2. Run the concept group — defines what you're building
bash <(curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/run.sh) concept

# 3. Tell Claude Code: "read LAUNCHPAD_TASK.md and execute it"

# 4. Add more modules as the project takes shape
bash <(curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/run.sh) github
bash <(curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/run.sh) devcontainer
```

---

## Available modules

### Docs

| Module | Creates | Group |
| --- | --- | --- |
| `vision` | `docs/VISION.md` | concept |
| `identity` | `docs/IDENTITY.md` | concept |
| `experts` | `docs/EXPERTS.md` | concept |
| `architecture` | `docs/ARCHITECTURE.md` | technical |
| `roadmap` | `docs/ROADMAP.md` | technical |
| `branding` | `docs/BRANDING.md` | — |
| `workflow` | `docs/WORKFLOW.md` | process |
| `agents` | `AGENTS.md` | process |
| `notdefined` | `.notdefined.yml` | — |

### CI

| Module | Creates | Group |
| --- | --- | --- |
| `github` | labels + workflows + issue templates + project board | — |

### Infrastructure

| Module | Creates | Group |
| --- | --- | --- |
| `devcontainer` | `.devcontainer/` | — |
| `kamal` | `config/deploy.yml` | — |
| `caddy` | `Caddyfile` | — |

### Process

| Module | Creates | Group |
| --- | --- | --- |
| `releasing` | `docs/guides/releasing.md` | — |
| `contributing` | `CONTRIBUTING.md` | — |
| `changelog` | `CHANGELOG.md` | — |

---

## Groups

Run multiple related modules in one command:

```bash
bash <(curl -sL .../run.sh) concept    # vision + identity + experts
bash <(curl -sL .../run.sh) technical  # architecture + roadmap
bash <(curl -sL .../run.sh) process    # workflow + agents
```

Replace `...` with `https://raw.githubusercontent.com/rodacato/launchpad/master/scripts`.

---

## Updating a module

Re-run any module on a project that already has it. The agent compares the current doc with the template, adds missing sections, and preserves your existing content.

```bash
bash <(curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/run.sh) experts
```

---

## Check module status

```bash
bash <(curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/check.sh)
```

Shows installed versions, remote versions, and what's outdated:

```text
Module          Local    Remote   Status
────────────────────────────────────────────────────────
experts         1.0      1.2      ↑ update available
identity        1.0      1.0      ✓ up to date
workflow        —        2.0      ✗ not installed
```

---

## Leaving Launchpad

```bash
rm -rf .launchpad/
```

Everything outside `.launchpad/` is yours. Nothing breaks.
