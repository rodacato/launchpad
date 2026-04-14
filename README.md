# kwik-e-marketplace

> rodacato's personal Claude Code plugin marketplace.
> Three plugins for bootstrapping projects, governing daily work, and consulting
> the reference material behind it all.

---

## Plugins

| Plugin | Purpose | Commands |
|---|---|---|
| **launchpad** | Project bootstrap — docs, infra, CI, process artifacts | `/launchpad:docs`, `/launchpad:ci`, `/launchpad:infra`, `/launchpad:process` |
| **lifecycle** | Daily work skills — review, debug, ship | `/lifecycle:review` (more coming) |
| **philosophy** | Reference — expert panel, identity | `/philosophy:panel`, `/philosophy:identity` |

Install the ones you want, skip the ones you don't.

---

## Install

```bash
/plugin marketplace add git@github.com:rodacato/kwik-e-dev.git
/plugin install launchpad@kwik-e-marketplace
/plugin install lifecycle@kwik-e-marketplace
/plugin install philosophy@kwik-e-marketplace
```

Each plugin installs independently — you're not forced to take all three.

---

## Usage

### launchpad — bootstrap a project

```text
/launchpad:docs vision
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

Each skill handles both create (from scratch) and update (preserve + extend).

### lifecycle — daily work

```text
/lifecycle:review <PR-number>
```

More skills incoming — git-workflow, debugging, shipping.

### philosophy — reference material

```text
/philosophy:panel <question or topic>
/philosophy:identity
```

`panel` consults a curated advisory panel (Architect, DevX, Prompting, etc.).
`identity` creates or updates `docs/IDENTITY.md` — how the team actually works.

---

## Repository structure

```text
kwik-e-dev/                           ← repo root
├── .claude-plugin/
│   └── marketplace.json              ← lists 3 plugins
├── plugins/
│   ├── launchpad/                    ← bootstrap plugin
│   │   ├── .claude-plugin/plugin.json
│   │   ├── commands/
│   │   └── skills/{vision, architecture, ...}
│   ├── lifecycle/                    ← daily work plugin
│   │   ├── .claude-plugin/plugin.json
│   │   ├── commands/
│   │   └── skills/{code-review, ...}
│   └── philosophy/                   ← reference plugin
│       ├── .claude-plugin/plugin.json
│       ├── commands/
│       └── skills/{experts, identity}
├── docs/
│   └── guides/
│       ├── development.md            ← plugin dev loop
│       └── skill-authoring.md        ← how to write a new skill
├── PLAN.md                           ← decisions log
├── CHANGELOG.md
└── README.md
```

---

## Skill format

All skills follow the format documented in
[docs/guides/skill-authoring.md](docs/guides/skill-authoring.md):

```text
plugins/<plugin>/skills/<name>/
├── SKILL.md              ← agent instructions, ranked by Overview / When / Process / Rationalizations / Red Flags / Verification
├── template.md           ← (bootstrap only) the document shape produced
└── VERSION               ← semver string
```

Bootstrap skills record their installed version in the target project's
`.launchpad/manifest.yml`. Lifecycle and philosophy skills do not — they run
ON projects, not INTO them.

---

## Development

Working on the marketplace itself? See
[docs/guides/development.md](docs/guides/development.md) for the local dev loop —
install from a local path, `/reload-plugins` for hot refresh, reinstall when
`plugin.json` changes.

Writing a new skill? See
[docs/guides/skill-authoring.md](docs/guides/skill-authoring.md) for the SKILL.md
template, section-by-section anatomy, and a pre-ship quality checklist.

Tracking the restructure that produced this layout? See
[PLAN.md](PLAN.md) for the decisions log.
