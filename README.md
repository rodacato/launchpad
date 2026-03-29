# Launchpad

> Claude Code plugin — atomic skills for project bootstrapping and documentation.

16 independent skills. Each one creates or updates a specific document or configuration
in your project. Run one, get a result. Iterate from there.

## Install

```bash
claude plugin marketplace add git@github.com:rodacato/launchpad.git
claude plugin install launchpad@launchpad-marketplace
```

## Usage

From any project:

```text
/launchpad:vision        # Create or update VISION.md
/launchpad:identity      # Create or update IDENTITY.md
/launchpad:experts       # Create or update EXPERTS.md
/launchpad:architecture  # Create or update ARCHITECTURE.md
/launchpad:roadmap       # Create or update ROADMAP.md
/launchpad:workflow      # Create or update WORKFLOW.md
/launchpad:agents        # Create or update AGENTS.md
/launchpad:branding      # Create or update BRANDING.md
/launchpad:notdefined    # Create or update .notdefined.yml
/launchpad:github        # Configure GitHub labels, workflows, board
/launchpad:devcontainer  # Create or update .devcontainer/
/launchpad:kamal         # Create or update config/deploy.yml
/launchpad:caddy         # Create or update Caddyfile
/launchpad:releasing     # Create or update docs/guides/releasing.md
/launchpad:contributing  # Create or update CONTRIBUTING.md
/launchpad:changelog     # Create or update CHANGELOG.md
```

Each skill handles both create (from scratch) and update (preserve + extend) cases.

## Structure

```text
skills/
  {name}/
    SKILL.md      ← agent instructions (create + update)
    template.md   ← blank document template
    VERSION       ← semver string
.claude-plugin/
  plugin.json
  marketplace.json
```

## Tracking installed versions

Skills record which version is installed in `.launchpad/manifest.yml` at the project root:

```yaml
source: rodacato/launchpad
modules:
  vision: "1.1"
  experts: "1.1"
  github: "1.0"
```
