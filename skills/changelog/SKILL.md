---
name: changelog
description: Create or update CHANGELOG.md — version history following Keep a Changelog format
metadata:
  version: "1.0"
  author: rodacato
  triggers:
    - changelog
    - "CHANGELOG.md"
    - "version history"
    - "keep a changelog"
---

# Changelog

Create or update `CHANGELOG.md` — version history following Keep a Changelog format.
Updated every time a release is cut.

## Before you start

```bash
find . -name "CHANGELOG.md" -not -path "*/.git/*"
find . -name "releasing.md" -not -path "*/.git/*"
```

---

## If CHANGELOG.md does NOT exist — Create

1. Ask: "What's the current version of this project? (e.g. 0.1.0)"
2. Ask: "Is there anything already shipped that should be in the initial entry?"
3. Create `CHANGELOG.md` using the template at `skills/changelog/template.md`.
   - Replace `{repo}` with the actual GitHub repo path
   - Replace `{version}` with the current version
   - Add any initial shipped changes under that version
   - Leave `[Unreleased]` empty and ready for new changes

If `docs/guides/releasing.md` doesn't exist yet, suggest running `/launchpad:releasing` next.

---

## If CHANGELOG.md already exists — Update

1. Read the current file
2. Read the template at `skills/changelog/template.md` for format improvements
3. Common issues to look for:
   - Missing comparison links at the bottom
   - Wrong format for `[Unreleased]` section
   - Placeholder repo name still present
4. Fix issues, preserve all existing version history

---

## When done

Update `.launchpad/manifest.yml` — set `changelog: "1.0"` under `modules:`.
