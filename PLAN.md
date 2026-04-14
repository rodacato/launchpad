# Plan: Marketplace Restructure

> Working document. We are discussing this plan, NOT executing it yet.
> Each section has a **Status** (decided / pending / blocked) and a place for notes.

---

## Why we're doing this

1. **Local install is broken** with current structure — Claude Code bug
   ([anthropics/claude-code#11278](https://github.com/anthropics/claude-code/issues/11278))
   prevents `/plugin install` from working when marketplace is added via local path
   and the plugin lives in the same directory as marketplace.json.
2. **Official pattern is multi-plugin** — Anthropic's own marketplaces
   (`anthropics/claude-code`, `anthropics/claude-plugins-official`) use
   `plugins/<name>/` subdirectories even for single-plugin cases.
3. **Opportunity**: turn the marketplace into a `rodacato` umbrella that hosts
   multiple plugins (launchpad, lifecycle, future) instead of one monolithic plugin
   with internal subdirectories.

---

## End-state structure

```text
launchpad/                                  ← repo (keeps this name for now)
├── .claude-plugin/
│   └── marketplace.json                    ← lists 2 plugins
├── plugins/
│   ├── launchpad/                          ← bootstrap plugin
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json                 (version 0.7.0)
│   │   ├── commands/
│   │   │   ├── ci.md
│   │   │   ├── docs.md
│   │   │   ├── infra.md
│   │   │   └── process.md
│   │   └── skills/
│   │       ├── agents/
│   │       ├── architecture/
│   │       ├── branding/
│   │       ├── caddy/
│   │       ├── changelog/
│   │       ├── contributing/
│   │       ├── devcontainer/
│   │       ├── experts/
│   │       ├── github/
│   │       ├── identity/
│   │       ├── kamal/
│   │       ├── notdefined/
│   │       ├── releasing/
│   │       ├── roadmap/
│   │       ├── vision/
│   │       └── workflow/
│   └── lifecycle/                          ← NEW plugin
│       ├── .claude-plugin/
│       │   └── plugin.json                 (version 0.1.0)
│       ├── commands/
│       │   └── review.md                   (NEW — dispatches to skills)
│       └── skills/
│           └── code-review/                (moved from root skills/)
├── docs/                                   ← shared, belongs to the repo
│   ├── EXPERTS.md
│   ├── IDENTITY.md
│   ├── guides/
│   │   ├── development.md                  (needs update)
│   │   ├── releasing.md
│   │   └── skill-authoring.md              (needs path updates)
│   └── plans/
│       └── (archived plans go here)
├── .launchpad/manifest.yml                 ← launchpad eating own food, stays
├── AGENTS.md                               ← repo-level
├── CLAUDE.md                               ← repo-level
├── CHANGELOG.md                            ← repo-level
├── PLAN.md                                 ← this file
├── README.md                               ← repo-level, updated to reflect 2 plugins
└── .gitignore, .vscode, .markdownlint.json
```

---

## Decisions

### D1. Marketplace name

**Status:** DECIDED — `kwik-e-marketplace`

Rodacato's personal marketplace, named after the Simpsons' Kwik-E-Mart. Breaking
rename from `launchpad-marketplace`; acceptable pre-1.0.

---

### D2. Repo name

**Status:** DECIDED — rename to `kwik-e-dev`

Repo becomes `rodacato/kwik-e-dev` on GitHub. GitHub preserves redirects for
the old URL so existing git installs don't immediately break. User will rename
on GitHub as part of this work. Local clone on other machines requires
`git remote set-url origin <new>`.

---

### D3. Commands for the `lifecycle` plugin

**Status:** DECIDED — mixto (flat first, group later)

**The pattern across all plugins:**

- **Single-skill category** → flat command, no args.
  Example: `/lifecycle:review <PR>` (one command, takes PR number as $ARGUMENTS).
- **Multi-skill category** (3+ skills) → grouped command.
  Example: `/lifecycle:git <subcommand>` where subcommand is commit, pr, rebase, etc.

**Why short names matter:** plugin name + command = user's daily typing cost.
A `/lifecycle:review` is 18 chars, tolerable. A `/lifecycle:code-review 123` is
27 chars, starting to grate. Keep command names short even when skill names
are long — the command is an ENTRYPOINT, not a description.

**Naming principles:**

- Command name = short verb or noun (`review`, `commit`, `panel`, `identity`)
- Command arg = what you're operating on (`review 123`, `panel architecture`)
- Skill behind the command can be longer and more descriptive
  (`code-review`, `consult-experts`) — the user never types the skill name

**Initial command layout:**

- **launchpad** (bootstrap, ~16 skills): keep existing grouped commands
  (`/launchpad:docs vision`, `/launchpad:ci github`, `/launchpad:infra devcontainer`,
  `/launchpad:process releasing`)
- **lifecycle** (1 skill today): `/lifecycle:review <PR>` → invokes code-review
- **philosophy** (2 skills today): `/philosophy:panel [topic]` → invokes experts,
  `/philosophy:identity` → invokes identity. No grouping needed yet.

**When a category grows to 3+ skills**, convert to grouped form — e.g. add
`/lifecycle:git <subcommand>` when debugging, commit helpers, and PR helpers
all exist.

---

### D4. How to handle addyosmani/agent-skills

**Status:** DECIDED — option B (write my own, slowly)

Scaffolding for `lifecycle` and `philosophy` plugins goes in NOW (empty-ish,
ready). Content fills in over time in rodacato's voice. `launchpad` ships with
its current skills upgraded to the new format. `lifecycle` ships with just
`code-review` (the pilot) + scaffolding for future skills. `philosophy` ships
with `experts` and `identity` moved in + command entrypoints.

addyosmani's repo stays as a reference (cloned at `/tmp/agent-skills-ref`) to
mine patterns from, but nothing is imported wholesale.

---

### D5. Philosophy layer — plugin or not?

**Status:** DECIDED — yes, third plugin

`philosophy` plugin scaffolded NOW. Scope:
- Move `skills/experts/` → `plugins/philosophy/skills/experts/`
- Move `skills/identity/` → `plugins/philosophy/skills/identity/`
- Commands: `/philosophy:panel [topic]`, `/philosophy:identity`
- Version 0.1.0 — ready to accept more philosophy skills (principles, values,
  ways-of-working) as they get articulated

Rationale: philosophy skills are CONSULTED more than produced. They're reference
material about HOW to work, distinct from bootstrap (setting up) and lifecycle
(daily work). Clean separation makes the marketplace more legible.

---

### D6. Version strategy

**Status:** DECIDED

**Rules for this repo** (SemVer-ish, pre-1.0 wiggly):

- **PATCH** (0.x.y → 0.x.y+1): typo fix, doc clarification, no behavior change
- **MINOR** (0.x.0 → 0.(x+1).0): new skill, new command, upgrade to skill
  format (additive), OR any breaking change while still pre-1.0
- **MAJOR** (0.x.y → 1.0.0): declares stability. Happens when rodacato trusts
  the plugin enough to commit to backwards compatibility

**Current restructure:**
- `launchpad`: `0.6.0` → `0.7.0`
  (breaking: marketplace renamed, users must re-add + reinstall. But format
   upgrade is additive within the skill files themselves.)
- `lifecycle`: `0.1.0`
  (first release, scaffolded with `code-review` skill)
- `philosophy`: `0.1.0`
  (first release, scaffolded with `experts` and `identity` skills)
- Marketplace has no version — Claude Code tracks per-plugin

**CHANGELOG.md receives an entry per version bump per plugin.** Since plugins
live in one repo and version independently, the CHANGELOG uses sections per
plugin (e.g. `## launchpad@0.7.0`, `## lifecycle@0.1.0`).

**Migration instructions go in CHANGELOG** under the 0.7.0 entry:
```bash
# Remove old marketplace
/plugin uninstall launchpad@launchpad-marketplace
/plugin marketplace remove launchpad-marketplace

# Add new marketplace
/plugin marketplace add git@github.com:rodacato/kwik-e-dev.git
# or local: /plugin marketplace add /path/to/kwik-e-dev

# Install the plugins you want
/plugin install launchpad@kwik-e-marketplace
/plugin install lifecycle@kwik-e-marketplace
/plugin install philosophy@kwik-e-marketplace
```

---

## Execution phases

> We execute these AFTER decisions D1-D6 are resolved. Each phase = one commit.

### Phase 1 — Scaffolding (non-destructive)
- [ ] Create `plugins/launchpad/.claude-plugin/`
- [ ] Create `plugins/lifecycle/.claude-plugin/`
- [ ] Do NOT move files yet — just create directories and placeholder `plugin.json` files

**Risk:** none. Pure addition.

### Phase 2 — Move launchpad plugin contents
- [ ] Move `commands/` → `plugins/launchpad/commands/`
- [ ] Move `skills/{agents,architecture,branding,caddy,changelog,contributing,devcontainer,experts,github,identity,kamal,notdefined,releasing,roadmap,vision,workflow}/` → `plugins/launchpad/skills/`
- [ ] Move `.claude-plugin/plugin.json` → `plugins/launchpad/.claude-plugin/plugin.json`
- [ ] Bump version in moved `plugin.json` to 0.7.0

**Risk:** medium. Git history preserved via `git mv`. Commands/skills stop
working during this phase until Phase 4.

### Phase 3 — Move code-review to lifecycle plugin
- [ ] Move `skills/code-review/` → `plugins/lifecycle/skills/code-review/`
- [ ] Create `plugins/lifecycle/.claude-plugin/plugin.json` (v0.1.0)
- [ ] Create `plugins/lifecycle/commands/` with a dispatcher for code-review
      (following D3 decision — one command per skill, or grouped)

**Risk:** low. Single skill move.

### Phase 4 — Update marketplace.json
- [ ] Rewrite `.claude-plugin/marketplace.json` to list both plugins
- [ ] Apply D1 decision: rename or keep marketplace name
- [ ] `source` fields: `./plugins/launchpad` and `./plugins/lifecycle`

**Risk:** high. This is the moment install starts working with new structure
and stops working with old. Must commit with Phase 2+3.

### Phase 5 — Documentation updates
- [ ] Update `README.md` — reflect 2-plugin structure, updated install commands
- [ ] Update `docs/guides/development.md` — new paths, confirmed local install works
- [ ] Update `docs/guides/skill-authoring.md` — examples table points to new paths
- [ ] Update `CHANGELOG.md` — entry for 0.7.0 with migration instructions for
      existing users
- [ ] Update `CLAUDE.md` — project structure section reflects new layout

**Risk:** low. All docs, no plugin behavior change.

### Phase 6 — Verify
- [ ] Run `/plugin uninstall launchpad@<old-marketplace-name>`
- [ ] Run `/plugin marketplace remove <old-marketplace-name>`
- [ ] Run `/plugin marketplace add /Users/adriancastillo/Workspace/rodacato/launchpad`
- [ ] Run `/plugin install launchpad@rodacato-marketplace` — should succeed
- [ ] Run `/plugin install lifecycle@rodacato-marketplace` — should succeed
- [ ] Test `/launchpad:docs vision` in a scratch project
- [ ] Test `/lifecycle:code-review` (or whatever D3 resolves to)

**Risk:** this is the validation step. If it fails, rollback is a `git reset`.

---

## Rollback plan

All changes are in a single branch with atomic commits per phase. If the
restructure fails:

```bash
git log --oneline          # identify the last good commit
git reset --hard <commit>  # revert locally
```

No data loss — everything in the repo, no side effects outside.

For the currently git-installed plugin on your machine (breaking change): the
old install keeps working UNTIL you do `/plugin marketplace update`. So the
rollback window is effectively "until you explicitly update."

---

## Open questions / parking lot

Use this section to park anything we discuss but don't resolve immediately.

1. **Future plugins in this marketplace?** — potential candidates: `tdd`,
   `git-workflow` (separate plugin or skill inside `lifecycle`?), `debugging`,
   `shipping`. Defer until after restructure lands.

2. **Should the `launchpad` plugin itself be renamed?** — e.g., to `bootstrap`
   or `project-setup`. Would make the plugin categories symmetrical
   (bootstrap + lifecycle + ...). BUT it breaks the `/launchpad:*` namespace
   users may have muscle memory for. Probably keep `launchpad` as the plugin
   name even if the repo houses multiple.

3. **Shared skills across plugins?** — what if `lifecycle` skills need
   `EXPERTS.md`? Options: (a) each plugin has its own copy, (b) symlink to
   repo-root `docs/`, (c) reference via known path. Defer until a skill actually
   needs it.

4. **Marketplace.json as a registry of skill taxonomies?** — could we use the
   marketplace to classify plugins by layer (bootstrap/lifecycle/philosophy)?
   Not a feature of Claude Code's marketplace.json today, but worth noting if
   it becomes useful.

---

## Notes / discussion log

> Add entries as we discuss. Format: `YYYY-MM-DD — note`.

- **2026-04-14** — Plan created. Decisions D1-D6 pending before execution.
  Preferred marketplace name is `rodacato-marketplace`. Preferred approach to
  addyosmani is option B (write our own, inspired by his). `code-review` pilot
  already exists and just needs to be moved.
- **2026-04-14** — All 6 decisions resolved:
  - D1: `kwik-e-marketplace`
  - D2: rename repo to `kwik-e-dev`
  - D3: mixto (flat per-skill commands, group when 3+ skills in a category)
  - D4: write our own lifecycle + philosophy, scaffold both now
  - D5: philosophy IS a plugin — experts + identity move there
  - D6: launchpad 0.7.0 (breaking), lifecycle 0.1.0, philosophy 0.1.0
  - Additional: also upgrade the 16 existing bootstrap skills to the new
    SKILL.md format while we're moving them (per docs/guides/skill-authoring.md).
  - Execution begins immediately.
