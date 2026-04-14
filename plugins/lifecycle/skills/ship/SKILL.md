---
name: ship
description: Executes a release — bumps version, finalizes CHANGELOG, tags, pushes, creates the GitHub release. Reads docs/guides/releasing.md if present and follows it; otherwise falls back to the Keep-a-Changelog + SemVer defaults. Use when the human says "cut a release" / "ship 0.4.0" / "release this". Use when CHANGELOG has unreleased entries ready to publish. NOT for setting up the release process — that's launchpad:releasing (which writes the doc this skill follows).
metadata:
  version: "0.1"
---

# Ship

## Overview

Executes a release: version bump → CHANGELOG finalize → commit → tag →
push → GitHub release. Reads the project's `docs/guides/releasing.md`
first and follows it; falls back to Keep-a-Changelog + SemVer defaults if
no guide exists.

`ship` does the release. `launchpad:releasing` writes the playbook the
release follows. They are intentionally different skills.

The bar: a release is reproducible from the artifacts left behind. If
someone re-runs the same steps a week later they get the same result.

## When to Use

- Human says "cut a release", "ship X.Y.Z", "release this", "tag and publish"
- CHANGELOG `[Unreleased]` section has entries ready to publish and the work has merged to the release branch
- A milestone is closing and the release is the next step
- A hotfix is ready and needs a patch release

**When NOT to use:**
- Setting up release process / writing the playbook — that's `launchpad:releasing`
- The release process is fully automated (release-please, semantic-release) and the project explicitly says humans / agents should not run releases manually
- Branch isn't ready (failing tests, open PRs that should ship together) — pause and resolve those first
- You don't have push access to the repo / registry — surface this; don't fake it

## Before you start

Read these in order — they shape every step:

```bash
fd releasing.md docs/guides --exclude .git
fd CHANGELOG.md --exclude .git
```

If `docs/guides/releasing.md` exists: it is the authoritative source for
this project's release process. Read it end-to-end and follow it. The
defaults below apply only when the guide is absent or silent on a step.

If `CHANGELOG.md` doesn't exist: STOP and tell the human "no CHANGELOG
found — run `launchpad:changelog` first, then re-run `ship`."

Confirm the version source of truth (where the version string lives):
- Ruby gem → `lib/*/version.rb` or `.gemspec`
- Node → `package.json`
- Python → `pyproject.toml` or `setup.py`
- Rust → `Cargo.toml`
- Generic → `VERSION` file
- kwik-e-marketplace per-plugin → `plugins/<plugin>/.claude-plugin/plugin.json` AND `.claude-plugin/marketplace.json` (BOTH must update together)

Confirm registry / publish target if applicable (npm, RubyGems, PyPI,
crates.io, GHCR). If credentials are required, surface that — never embed
or echo them.

Confirm with the human BEFORE starting:

```
Releasing: <project-or-plugin>
Current version: <X.Y.Z>
Proposed bump: <patch|minor|major> → <X.Y.Z>
Reason for bump: <one line — what's in [Unreleased] that justifies it>
Branch: <main / master / release branch>
Target: <github-only | github + npm | github + ghcr | etc.>
Proceed?
```

Wait for "yes" before touching anything.

## Process

### Step 1 — Pre-flight checks

```bash
git status                     # clean working tree
git fetch
git log --oneline @{u}..       # not behind remote
gh pr list --state open --base <release-branch>  # nothing pending that should ship together?
```

Verify:
- Working tree is clean (no uncommitted changes)
- Branch is up to date with remote
- No open PRs that should ship in this release
- All CI checks for the latest commit passed: `gh run list --branch <branch> --limit 5`

If any check fails: STOP and report. Don't release a broken main.

### Step 2 — Decide the version bump

Apply SemVer:

| Bump | Triggered by |
|---|---|
| MAJOR | Breaking changes in public surface (commands removed/renamed, file paths changed, behavior reversed) |
| MINOR | New features, new commands, new skills, additive non-breaking changes |
| PATCH | Bug fixes only, doc-only changes that don't shift behavior |

Read the `[Unreleased]` section of `CHANGELOG.md` and verify the proposed
bump matches what's there. If `[Unreleased]` contains `### Removed` or
`BREAKING` markers but the human asked for a minor bump, push back with
evidence.

### Step 3 — Update the CHANGELOG

Move `[Unreleased]` → `[X.Y.Z] - YYYY-MM-DD`:

```markdown
## [Unreleased]

(empty for the next cycle)

## [X.Y.Z] - 2026-04-15

### Added
...
### Changed
...
### Fixed
...
```

Update the comparison links at the bottom:

```markdown
[Unreleased]: https://github.com/<owner>/<repo>/compare/vX.Y.Z...HEAD
[X.Y.Z]: https://github.com/<owner>/<repo>/compare/v<previous>...vX.Y.Z
```

For multi-plugin marketplaces (kwik-e-marketplace pattern), CHANGELOG
sections are per-plugin (`## launchpad@X.Y.Z`, `## philosophy@X.Y.Z`).
Move only the per-plugin section being shipped.

### Step 4 — Bump the version source of truth

For a single-package project:

```bash
# Examples — pick the one matching this project
npm version <patch|minor|major> --no-git-tag-version
# OR edit pyproject.toml / Cargo.toml / VERSION manually
```

For kwik-e-marketplace per-plugin release:
- Update `plugins/<plugin>/.claude-plugin/plugin.json` `version`
- Update `.claude-plugin/marketplace.json` plugin entry `version`
- Both MUST match (CLAUDE.md convention)

### Step 5 — Commit the release

```bash
git add CHANGELOG.md <version-file(s)>
git commit -m "$(cat <<'EOF'
chore(release): <project-or-plugin>@X.Y.Z

Releases the changes accumulated in [Unreleased]. Headlines:
- <one-line for each top-level item>
EOF
)"
```

Per CLAUDE.md / AGENTS.md: NO Co-Authored-By trailers. Ever.

### Step 6 — Tag

Tag format depends on the project — check existing tags:

```bash
git tag --list --sort=-v:refname | head -5
```

Common formats:
- Single-package: `vX.Y.Z`
- Multi-package monorepo: `<package>@X.Y.Z`
- Marketplace per-plugin: `<plugin>@X.Y.Z` (kwik-e-marketplace pattern)

Annotated tag (preferred — carries the release notes):

```bash
git tag -a <tag> -m "$(cat <<'EOF'
<project-or-plugin> X.Y.Z

<copy of the relevant CHANGELOG section, plain text>
EOF
)"
```

### Step 7 — Push

```bash
git push                       # the release commit
git push origin <tag>          # the tag
```

If the project has branch protection that blocks direct push (most
project-with-PRs setups), pause and tell the human:
"The release commit needs a PR. Want me to open one with `gh pr create`?"

### Step 8 — Create the GitHub release

```bash
gh release create <tag> \
  --title "<project-or-plugin> X.Y.Z" \
  --notes "$(cat <<'EOF'
<copy of the CHANGELOG section, markdown>
EOF
)"
```

If the project publishes to a registry (npm / RubyGems / PyPI / crates.io /
GHCR): follow the project's `docs/guides/releasing.md` for the publish
step. Don't invent the publish command — registries have
project-specific auth and configuration.

### Step 9 — Verify

After the release lands, verify the artifacts exist:

```bash
gh release view <tag>          # the GitHub release exists with notes
git ls-remote --tags origin | grep <tag>  # the tag pushed
# If published to a registry: confirm with the registry's CLI/API
```

Report back to the human:
- Tag: `<tag>` pushed
- GitHub release: `<URL>`
- Registry (if applicable): published as `<package>@<version>`
- CHANGELOG: `[Unreleased]` is empty for the next cycle

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Tests are flaky, I'll release anyway" | Flaky-test tolerance is a release-process anti-pattern. The release sets a baseline future bisects compare against — a flaky baseline poisons every future debug. Fix the flake or block the release. |
| "I'll skip CHANGELOG, the commits explain it" | Commits explain WHAT to engineers reading the repo. The CHANGELOG explains WHAT to USERS reading the release page. They serve different audiences; both are needed. |
| "It's a tiny patch, I'll ship without a tag" | Untagged releases drift — package consumers can't reference a specific version, bisecting becomes impossible, GitHub Release notes don't generate. Always tag. |
| "I'll bump the version + CHANGELOG in one giant PR for the whole quarter" | Quarterly release PRs accumulate so much change that release notes become useless and CHANGELOG conflicts compound. Ship smaller, more often. |
| "BREAKING CHANGE in a minor bump is fine if the user base is small" | SemVer is a contract with users — even one user. A breaking change in a minor bump erodes trust permanently. Bump major and document the migration. |
| "I'll force-push the release commit to fix a typo in the notes" | Force-pushing a release rewrites history downstream consumers may already reference. Edit notes via `gh release edit`; for tag changes, cut a new patch. |

## Red Flags

- Tests / CI failing on the release branch and release proceeds anyway
- Working tree is dirty when the tag is created (un-staged or un-committed work)
- CHANGELOG `[Unreleased]` is empty but the human asked to release (nothing to ship)
- Version bump in code doesn't match the version in the CHANGELOG / tag / release title
- BREAKING change present in `[Unreleased]` but proposed bump is patch or minor
- Release commit contains AI attribution or Co-Authored-By
- Force-push, history rewrite, or tag deletion happens during the release flow
- For multi-plugin: `marketplace.json` and `plugin.json` versions disagree after the bump
- Registry publish step is silently skipped on a project that has one

## Verification

- [ ] `docs/guides/releasing.md` was read first if present, and its steps were followed
- [ ] Pre-flight: clean working tree, branch up to date with remote, CI green for HEAD, no PRs blocking the release
- [ ] CHANGELOG `[Unreleased]` moved to `[X.Y.Z] - YYYY-MM-DD` with comparison links updated
- [ ] Version source of truth bumped (and for multi-plugin: ALL relevant version files match)
- [ ] Commit message uses `chore(release): ...` format and has NO Co-Authored-By
- [ ] Annotated tag created with the correct format and contains the CHANGELOG excerpt
- [ ] Tag and release commit pushed to remote
- [ ] GitHub release created with title, tag, and notes (`gh release view <tag>` confirms)
- [ ] Registry publish (if applicable) confirmed via the registry's own CLI/API, not assumed
- [ ] Final summary reported back to human with tag, release URL, and registry URL

## When done

Nothing to update in `.launchpad/manifest.yml` — `ship` is a lifecycle
skill and produces a tag + a GitHub release + (sometimes) a registry
artifact, not a project artifact.

Next likely skills:
- `lifecycle:review` — for the FOLLOW-UP PRs that arrive after the release lands
- `launchpad:changelog` — if the release surfaced gaps in the CHANGELOG format
- `launchpad:releasing` — if the release surfaced gaps in the playbook itself, update the doc
