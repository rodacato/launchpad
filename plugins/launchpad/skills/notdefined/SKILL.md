---
name: notdefined
description: Create or update .notdefined.yml — project metadata consumed by the rodacato showroom (rodacato.github.io/projects). Use when publishing a new project to the showroom for the first time. Use when the showroom entry shows stale tagline, status, or stack. Use when branding assets (icon, screenshot, colors) are finalized and need to surface on the site. Use when the repo moves or its primary language changes.
metadata:
  version: "1.1"
  author: rodacato
  category: bootstrap
  triggers:
    - notdefined
    - ".notdefined.yml"
    - showroom
    - "project metadata"
    - "rodacato projects"
    - "showcase entry"
---

# Notdefined

## Overview

Create or update `.notdefined.yml` — the single source of truth for how
this project appears in the rodacato showroom (rodacato.github.io/projects).
The file declares tagline, description, stack, status, icon, screenshot,
and links so the showroom can render a consistent card without scraping
the README.

Spec: https://github.com/rodacato/rodacato/blob/master/docs/guides/notdefined-yml-spec.md

## When to Use

- Publishing a new project to the rodacato showroom for the first time
- Showroom card is stale — tagline, status, version, or stack no longer match reality
- Branding assets (icon, screenshot, primary color) are finalized and should surface publicly
- Repo moved, got renamed, or changed its primary language
- Project status changed (`active` → `maintenance`, or vice versa)

**When NOT to use:**
- Project will never be published to the rodacato showroom — the file has no other consumer
- Private client work that shouldn't appear anywhere public
- Values aren't settled yet (no tagline, no clear status) — draft the docs first, then return

## Before you start

Search for source files that contain the values needed:

```bash
fd BRANDING.md --exclude .git      # tagline, description, colors, icon
fd ARCHITECTURE.md --exclude .git  # stack, lang
fd CLAUDE.md --exclude .git        # name, status, version
```

If any source doc is missing, ask the human directly rather than guess.
Read the showroom spec linked above for the current field list — new
fields may have been added since this skill was last bumped.

## Process

### If .notdefined.yml does NOT exist — Create

#### Step 1 — Collect values

From the files found above, extract:
- `tagline` → from BRANDING.md tagline (max 10 words)
- `description` → from BRANDING.md elevator pitch (2-4 sentences, casual tone)
- `version` → from CLAUDE.md or package.json / gemspec / pyproject.toml
- `lang` → primary language from ARCHITECTURE.md
- `stack` → top 2-3 tech choices from ARCHITECTURE.md
- `status` → from CLAUDE.md (active | maintenance | paused)
- `category` → product or utility (ask if unclear)
- `repo` → from git remote: `git remote get-url origin`
- `background_color` → accent primary color from BRANDING.md (if available)

If any source doc is missing, ask the human for the values directly.

#### Step 2 — Branding assets

Ask: "Do you have a logo/icon ready? (docs/branding/icon.svg or similar)"
If yes, uncomment and fill `icon` and `background_color`.

Ask: "Do you have any screenshots ready? (docs/screenshots/)"
If yes, uncomment and fill `screenshot`.

#### Step 3 — Create .notdefined.yml

Use the template at `skills/notdefined/template.md` as base.
Fill in all values. Show the result to the human for approval.

### If .notdefined.yml already exists — Update

1. Read the current file
2. Check for placeholder values still present (`<!-- ... -->`)
3. Check for new fields in the spec or template
4. Fill missing values, preserve existing ones
5. Show a diff to the human and confirm before saving

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The README already says all this" | The showroom can't parse a freeform README. `.notdefined.yml` is the machine-readable contract — without it, the card is generic or absent. |
| "I'll fill in `tagline` later" | Later means the showroom renders the repo name as the tagline. Ship a real tagline or defer the whole file. |
| "Status is probably `active`, let's just say that" | `active` implies ongoing work. If nobody's touched it in 6 months, `maintenance` is the honest value. Lying here misleads visitors. |
| "Icon and screenshot are nice-to-haves" | They're the entire visual of the card. A card with neither looks abandoned. Either ship assets or set `background_color` to something brand-correct. |
| "I'll skip `repo` — the showroom can figure it out" | It can't. Fill it from `git remote get-url origin` — it's literally one command. |

## Red Flags

- Template placeholders (`<!-- ... -->`) still present in the committed file — the showroom renders them literally
- `tagline` longer than 10 words or written as a paragraph — card layout breaks
- `status` value outside the allowed set (`active | maintenance | paused`) — showroom treats it as unknown
- `repo` URL uses SSH form (`git@github.com:...`) — showroom expects HTTPS
- `icon` or `screenshot` path points to a file that isn't committed — broken image in production
- `stack` lists five or more items — showroom truncates and the card looks cluttered

## Verification

- [ ] `.notdefined.yml` exists at the project root
- [ ] `tagline`, `description`, `version`, `lang`, `stack`, `status`, `category`, `repo` all have real values (no placeholders)
- [ ] `status` is one of `active`, `maintenance`, `paused`
- [ ] `repo` is an HTTPS GitHub URL and matches `git remote get-url origin`
- [ ] If `icon` is set, the referenced file is committed to the repo
- [ ] If `screenshot` is set, the referenced file is committed to the repo
- [ ] YAML parses cleanly (`yq '.' .notdefined.yml` exits 0, or equivalent)
- [ ] `.launchpad/manifest.yml` updated with `notdefined: "1.1"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `notdefined: "1.1"` under `modules:`.

Next likely skills:
- `vision` — if the description feels generic, the project may not have a real compass yet
- `github` — make sure the repo has the labels and templates the showroom links assume
- `branding` — finalize icon, screenshot, and colors so this file has real assets to point to
