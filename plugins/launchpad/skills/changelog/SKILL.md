---
name: changelog
description: Create or update CHANGELOG.md — version history following Keep a Changelog format. Use when starting a project that will ship versioned releases. Use when cutting a new release and recording what changed. Use when CHANGELOG.md is missing, malformed, or has diverged from Keep a Changelog format. Use before running the releasing skill for the first time.
metadata:
  version: "1.1"
---

# Changelog

## Overview

Create or update `CHANGELOG.md` — the human-readable version history. Follows
[Keep a Changelog](https://keepachangelog.com) + SemVer. Updated every time a
release is cut. This is the user-facing story of the project; commit messages
are the raw data, CHANGELOG is the curated narrative.

## When to Use

- Project is about to ship its first versioned release
- No CHANGELOG.md exists but the repo has been shipping changes silently
- Existing CHANGELOG is missing comparison links, misformatted, or has no `[Unreleased]` section
- Before running the `releasing` skill — the release flow writes into this file
- Project just migrated repo hosts and the comparison links point to a dead URL

**When NOT to use:**
- Repos that don't ship versioned releases (internal dashboards, one-off scripts)
- Projects where release notes live exclusively on GitHub Releases UI and nobody consumes a file
- When the user just wants a "what changed" summary — that's a diff, not a changelog

## Before you start

Locate the file and surrounding context:

```bash
fd CHANGELOG.md --exclude .git
fd releasing.md --exclude .git
```

If `docs/guides/releasing.md` doesn't exist, the changelog will be written in
isolation — you should suggest running `releasing` next to close the loop.

## Process

### If CHANGELOG.md does NOT exist — Create

#### Step 1 — Gather release context
Ask the human:
- "What's the current version of this project? (e.g. `0.1.0`, `1.2.3`)"
- "Is there anything already shipped that should be back-filled as the initial entry?"
- "What's the GitHub repo path? (owner/repo — used for comparison links)"

#### Step 2 — Build the file
Use the template at `skills/changelog/template.md`. Customize:
- Replace `{repo}` with the actual `owner/repo` path
- Replace `{version}` with the current version
- Add any initial shipped changes under that version, grouped by Added / Changed / Fixed
- Leave `[Unreleased]` empty and ready for new changes
- Ensure comparison links at the bottom point to the right tags

#### Step 3 — Connect to the release flow
If `docs/guides/releasing.md` doesn't exist yet, tell the human:
"CHANGELOG is ready. Run the `releasing` skill next so the release process
knows how to update this file."

### If CHANGELOG.md already exists — Update

1. Read the current file end-to-end
2. Read `skills/changelog/template.md` for format reference
3. Common issues to hunt for:
   - Missing or wrong comparison links at the bottom
   - No `[Unreleased]` section, or it's missing the standard sub-headers
   - Placeholder repo name (`{repo}`, `owner/name`, `yourname/project`) never replaced
   - Version entries missing date (`YYYY-MM-DD`)
   - Sections not in Keep a Changelog order (Added → Changed → Deprecated → Removed → Fixed → Security)
   - Breaking changes mentioned in commits but not flagged in changelog
4. Show the diff to the human
5. Fix issues, preserving ALL existing version history verbatim

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Git log is the changelog" | Git log is noise; CHANGELOG is signal. Users don't read commit messages — they scan release notes. |
| "GitHub Releases UI handles this for me" | The UI is a copy of what should live in the repo. Without a file, there's no diff-review of release notes and no history that survives hosting moves. |
| "I'll skip the `[Unreleased]` section, we'll add one when we release" | Without it, every release forces reconstruction of what changed. The `[Unreleased]` section is the draft space — skip it and you'll ship blind. |
| "Breaking changes can wait — nobody's using this yet" | The moment someone upgrades without knowing about a breaking change, trust burns. Flag breaks from day one or you'll forget by v2. |
| "I'll update CHANGELOG as part of the commit that makes the change" | Only works if every contributor remembers. A dedicated section (`[Unreleased]`) + a release checklist is more reliable than discipline. |

## Red Flags

- No `[Unreleased]` section at the top
- Versions missing dates, or dates in inconsistent formats (`2025-01-15` vs `Jan 15, 2025`)
- No comparison links at the bottom, or links pointing at a repo that doesn't exist
- Sections named `Features` / `Bugfixes` instead of the Keep a Changelog vocabulary (`Added` / `Fixed`)
- A single `[1.0.0]` entry with no granular breakdown — just "initial release"
- Breaking changes buried in `Changed` without a `BREAKING:` marker or `Removed` companion
- Placeholder `{repo}` or `yourname/project` still present

## Verification

- [ ] `CHANGELOG.md` exists at project root
- [ ] First non-header section is `[Unreleased]` with Added/Changed/Fixed subheaders ready
- [ ] Every released version has a date in `YYYY-MM-DD` format
- [ ] Comparison links at the bottom use real `owner/repo` — paste one into a browser and it 200s
- [ ] Keep a Changelog section order preserved: Added, Changed, Deprecated, Removed, Fixed, Security
- [ ] Breaking changes are explicitly marked (e.g. `**Breaking:**` prefix or `Removed` section)
- [ ] No template placeholders (`{repo}`, `{version}`) remain in the file
- [ ] `.launchpad/manifest.yml` updated with `changelog: "1.1"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `changelog: "1.1"` under `modules:`.

Next likely skills:
- `releasing` — define the release process that writes into this file
- `contributing` — tell contributors how to add entries to `[Unreleased]`
