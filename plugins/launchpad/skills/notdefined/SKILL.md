---
name: notdefined
description: Create or update .notdefined.yml — project metadata for rodacato showroom
metadata:
  version: "1.0"
  author: rodacato
  triggers:
    - notdefined
    - ".notdefined.yml"
    - showroom
    - "project metadata"
---

# Notdefined

Create or update `.notdefined.yml` — project metadata for the rodacato showroom
(rodacato.github.io/projects). Defines tagline, description, stack, status, icon,
screenshot, and links.

Spec: https://github.com/rodacato/rodacato/blob/master/docs/guides/notdefined-yml-spec.md

## Before you start

Search for source files that contain the values needed:

```bash
find . -name "BRANDING.md" -not -path "*/.git/*"    # tagline, description, colors, icon
find . -name "ARCHITECTURE.md" -not -path "*/.git/*" # stack, lang
find . -name "CLAUDE.md" -not -path "*/.git/*"       # name, status, version
```

---

## If .notdefined.yml does NOT exist — Create

### Step 1 — Collect values

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

### Step 2 — Branding assets
Ask: "Do you have a logo/icon ready? (docs/branding/icon.svg or similar)"
If yes, uncomment and fill `icon` and `background_color`.
Ask: "Do you have any screenshots ready? (docs/screenshots/)"
If yes, uncomment and fill `screenshot`.

### Step 3 — Create .notdefined.yml
Use the template at `skills/notdefined/template.md` as base.
Fill in all values. Show the result to the human for approval.

---

## If .notdefined.yml already exists — Update

1. Read the current file
2. Check for placeholder values still present (`<!-- ... -->`)
3. Check for new fields in the spec or template
4. Fill missing values, preserve existing ones

---

## When done

Update `.launchpad/manifest.yml` — set `notdefined: "1.0"` under `modules:`.
