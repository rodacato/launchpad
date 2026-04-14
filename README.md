# kwik-e-marketplace

> rodacato's personal Claude Code plugin marketplace.
> Three plugins for bootstrapping projects, governing daily work, and consulting
> the reference material behind it all.

Inspired by [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
and [Gentleman-Programming/gentle-ai](https://github.com/Gentleman-Programming/gentle-ai).

---

## Plugins

| Plugin | Version | Purpose | Skills | Commands |
|---|---|---|---|---|
| **launchpad** | 0.7.0 | Project bootstrap — docs, infra, CI, process artifacts | 14 (vision, architecture, branding, roadmap, workflow, agents, notdefined, github, devcontainer, kamal, caddy, releasing, contributing, changelog) | `/launchpad:docs`, `/launchpad:ci`, `/launchpad:infra`, `/launchpad:process` |
| **lifecycle** | 0.2.0 | Daily work skills — review, branch/commit/PR, debug, simplify, ship | 5 (code-review, git-workflow, debugging, simplify, ship) | `/lifecycle:review`, `/lifecycle:git-workflow`, `/lifecycle:debugging`, `/lifecycle:simplify`, `/lifecycle:ship` |
| **philosophy** | 0.3.0 | Reference — expert panel, identity, voice, orient meta-skill, core principles + operating behaviors | 4 (experts, identity, voice, orient) | `/philosophy:panel`, `/philosophy:identity`, `/philosophy:voice`, `/philosophy:orient` |

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
/lifecycle:git-workflow [stage]
/lifecycle:debugging <bug or failing-test>
/lifecycle:simplify [target]
/lifecycle:ship [target or version]
```

- `review` runs a multi-axis code review on a GitHub PR via `gh`.
- `git-workflow` executes branch / commit / PR per the project's CLAUDE.md
  + AGENTS.md + CONTRIBUTING.md conventions; refuses destructive ops without
  confirmation.
- `debugging` walks a systematic process — reproduce, isolate, hypothesize,
  test the hypothesis BEFORE changing code, fix minimally, write a regression
  test, verify the original reproduction.
- `simplify` audits a diff for what doesn't earn its keep (dead code,
  premature abstractions, speculative flexibility, over-defensive guards)
  and proposes concrete deletions.
- `ship` cuts a release — pre-flight checks, version bump, CHANGELOG
  finalize, tag, push, GitHub release; follows `docs/guides/releasing.md`
  if present.

### philosophy — reference material

```text
/philosophy:orient [task description]
/philosophy:panel <question or topic>
/philosophy:identity
/philosophy:voice [style-name]
```

- `orient` is the meta-skill — load it FIRST when you don't know which skill
  applies. It routes the task across launchpad / lifecycle / philosophy and
  loads the inherited floor (`core-principles.md` + `operating-behaviors.md`)
  before anything else runs.
- `panel` consults a curated advisory panel (Architect, DevX, Prompting, etc.).
- `identity` creates or updates `docs/IDENTITY.md` — the project's Build Identity,
  with an inherited `## Core Principles` block from `philosophy/shared/core-principles.md`.
- `voice` creates or updates a Claude Code output style at `~/.claude/output-styles/`
  — the user-level voice the agent uses across every project.

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
│   │   └── skills/{code-review, git-workflow, debugging, simplify, ship}
│   └── philosophy/                   ← reference plugin
│       ├── .claude-plugin/plugin.json
│       ├── commands/
│       ├── shared/{core-principles, operating-behaviors}  ← inherited floor
│       └── skills/{experts, identity, voice, orient}      ← orient is the meta-skill
├── docs/
│   ├── EXPERTS.md                   ← reference panel consulted by skills
│   ├── IDENTITY.md                  ← how this team works
│   └── guides/
│       ├── development.md           ← plugin dev loop
│       ├── releasing.md             ← release checklist per plugin
│       └── skill-authoring.md       ← how to write a new skill
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

Cutting a release? See
[docs/guides/releasing.md](docs/guides/releasing.md) for the per-plugin release
checklist.
