---
name: releasing
description: Create or update docs/guides/releasing.md — release process, versioning, CHANGELOG workflow. Use when setting up the release process for a new project. Use when releases are inconsistent or undocumented. Use when the team needs a hotfix process. Use before cutting the first tagged release.
metadata:
  version: "1.1"
  author: rodacato
  category: bootstrap
  triggers:
    - releasing
    - "release process"
    - "releasing.md"
    - "how to release"
    - "cut a release"
    - "semver"
    - "hotfix process"
---

# Releasing

## Overview

Create or update `docs/guides/releasing.md` — the release process guide. How to
cut a release: version rules, CHANGELOG format, tagging, GitHub releases,
hotfix process. Follows Keep a Changelog + Semantic Versioning. A release that
isn't documented is a release that's shipped differently every time.

## When to Use

- Project is about to cut its first tagged release and has no process
- Releases are inconsistent — different people bump versions in different files
- No documented hotfix process and the team keeps re-inventing it under pressure
- CHANGELOG exists but there's no procedure tying it to git tags and GitHub releases
- Onboarding a new maintainer who'll need to cut releases

**When NOT to use:**
- Projects that don't version (internal tools, static sites with continuous deploy)
- Repos where releases are fully automated via release-please / semantic-release and nobody should touch the process manually
- When what's actually needed is a CI pipeline doc, not a release guide

## Prerequisites

```bash
fd releasing.md --exclude .git
fd CHANGELOG.md --exclude .git
```

If `CHANGELOG.md` doesn't exist yet, the release flow has no file to write
into — run the `changelog` skill first, or tell the human to run it after.

Identify the project's version source of truth so the guide can reference it:
- Ruby gem → `lib/*/version.rb` or `.gemspec`
- Node → `package.json`
- Python → `pyproject.toml` or `setup.py`
- Rust → `Cargo.toml`
- Generic → `VERSION` file or similar

## Process

### If releasing.md does NOT exist — Create

#### Step 1 — Gather release context
Ask the human:
- "Do you use any specific version management tooling? (gem-release, npm version, release-please, semantic-release, purely manual?)"
- "Is there a CI step that publishes releases, or is the whole flow manual?"
- "Do you cut hotfix releases from a separate branch, or always from main?"
- "Where does the version actually live? (file path)"
- "Do you publish to a registry? (npm, RubyGems, PyPI, crates.io) If so, credentials are where?"

#### Step 2 — Build the guide
Use the template at `skills/releasing/template.md` as the base. Customize the
version update step based on the project's stack:
- Ruby gem → update `lib/*/version.rb`, run `gem build`, `gem push`
- Node → `npm version <bump>`, `npm publish`
- Python → bump `pyproject.toml`, `python -m build`, `twine upload`
- Rust → bump `Cargo.toml`, `cargo publish`
- Generic → update the `VERSION` file or equivalent

Ensure these sections exist:
- Version rules (SemVer table: when to bump MAJOR / MINOR / PATCH)
- Release checklist (CHANGELOG update → version bump → tag → push → GH release)
- Hotfix process (branch from tag, cherry-pick, release)
- Agent prompts (copy-pasteable prompts for common release asks)

#### Step 3 — Place the file
Create `docs/guides/` if it doesn't exist. Write
`docs/guides/releasing.md` with the customized content.

If `CHANGELOG.md` doesn't exist, tell the human:
"Release guide is ready. Run the `changelog` skill next so the release flow
has a file to write into."

### If releasing.md already exists — Update

1. Read the current file end-to-end
2. Read `skills/releasing/template.md` for reference
3. Check for missing sections: hotfix process, agent prompts, version rules table, registry publish steps
4. Verify commands still match the project's actual stack (e.g. did the project migrate from npm to pnpm?)
5. Propose the diff to the human
6. Update with approved changes, preserving all project-specific customizations

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "We only release once a quarter, we'll remember" | You won't. And the next person definitely won't. Documented process is the insurance policy against panicked releases at midnight. |
| "Semantic versioning is obvious" | It isn't. "Does this bug fix count as PATCH or as a MINOR because of the behavior change?" comes up every release. Write the rules down. |
| "Hotfix process can wait until we need one" | By the time you need a hotfix, the prod is already on fire. Write the hotfix process before the first real emergency, not during it. |
| "CI handles releases automatically" | Until it doesn't. Automated flows fail; the human fallback needs to be documented so someone can release without CI. |
| "We'll just tag and push — GitHub Releases will handle the rest" | Untied from CHANGELOG and version bumps, tag-and-push produces releases with no notes, mismatched version strings, and drift between package registries and GitHub. |

## Red Flags

- No SemVer rules table — MAJOR / MINOR / PATCH criteria aren't explicit
- Release process doesn't mention CHANGELOG update (releases will ship without notes)
- No hotfix section, or hotfix section assumes main is always deployable
- Version bump step references a file or tool the project no longer uses
- No mention of git tag format — `v1.2.3` vs `1.2.3` drift breaks comparison links
- No step for publishing to the relevant registry (npm, RubyGems, PyPI)
- "Agent prompts" section missing entirely — forces the human to re-author prompts each release

## Verification

- [ ] `docs/guides/releasing.md` exists
- [ ] Version rules table covers MAJOR, MINOR, PATCH with concrete examples
- [ ] Release checklist is numbered and in execution order
- [ ] Version bump step references the actual file the project uses (checked against repo)
- [ ] Tag format is specified (`v1.2.3` or `1.2.3`) and consistent with existing tags
- [ ] CHANGELOG.md update step appears BEFORE the version bump in the checklist
- [ ] Hotfix process exists and explains branch-from-tag strategy
- [ ] Registry publish step (if applicable) includes auth / credential guidance
- [ ] Agent prompts section is present and copy-pasteable
- [ ] `.launchpad/manifest.yml` updated with `releasing: "1.1"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `releasing: "1.1"` under `modules:`.

Next likely skills:
- `changelog` — if not already set up, define the CHANGELOG this process writes into
- `contributing` — link the release process from the contributor guide
- `workflow` — tie release cadence to the team's sprint / iteration rhythm
