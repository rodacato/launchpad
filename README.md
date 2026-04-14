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
/launchpad:docs vision
/launchpad:docs identity
/launchpad:docs experts
/launchpad:docs architecture
/launchpad:docs branding
/launchpad:docs roadmap
/launchpad:docs workflow
/launchpad:docs agents
/launchpad:docs notdefined

/launchpad:ci github

/launchpad:infra devcontainer
/launchpad:infra kamal
/launchpad:infra caddy

/launchpad:process releasing
/launchpad:process contributing
/launchpad:process changelog
```

Each skill handles both create (from scratch) and update (preserve + extend) cases.

## Structure

```text
commands/
  docs.md        ← /launchpad:docs <skill>
  ci.md          ← /launchpad:ci <skill>
  infra.md       ← /launchpad:infra <skill>
  process.md     ← /launchpad:process <skill>
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

## Development

Working on launchpad itself? See [docs/guides/development.md](docs/guides/development.md)
for the local dev loop — how to install from a local path, refresh after changes,
and test in other projects without publishing.

Writing a new skill? See [docs/guides/skill-authoring.md](docs/guides/skill-authoring.md)
for the SKILL.md template and authoring process.
