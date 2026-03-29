---
name: releasing
description: Create or update docs/guides/releasing.md — release process, versioning, CHANGELOG workflow
metadata:
  version: "1.0"
  author: rodacato
  triggers:
    - releasing
    - "release process"
    - "releasing.md"
    - "how to release"
    - "cut a release"
---

# Releasing

Create or update `docs/guides/releasing.md` — the release process guide. How to cut a
release: version rules, CHANGELOG format, tagging, GitHub releases, hotfix process.
Follows Keep a Changelog + Semantic Versioning.

## Before you start

```bash
find . -name "releasing.md" -not -path "*/.git/*"
find . -name "CHANGELOG.md" -not -path "*/.git/*"
```

---

## If releasing.md does NOT exist — Create

1. Ask the human:
   - "Do you use any specific version management tooling? (gem-release, npm version, etc.)"
   - "Is there a CI step for releases, or is it purely manual?"
   - "Do you do hotfix releases or always from main?"

2. Use the template at `skills/releasing/template.md` as the base.
   Customize the version update step based on the project's stack:
   - Ruby gem → update `.gemspec` or `lib/*/version.rb`
   - Node → `package.json` version
   - Python → `pyproject.toml` version
   - Generic → `.notdefined.yml` version

3. Create `docs/guides/` directory if it doesn't exist.
   Create `docs/guides/releasing.md` with the customized content.

4. If `CHANGELOG.md` doesn't exist, suggest running `/launchpad:changelog` next.

---

## If releasing.md already exists — Update

1. Read the current file
2. Read the template at `skills/releasing/template.md` for new sections
3. Check for missing sections: hotfix process, agent prompts section, version rules table
4. Update with approved additions, preserving project-specific customizations

---

## When done

Update `.launchpad/manifest.yml` — set `releasing: "1.0"` under `modules:`.
