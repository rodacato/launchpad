# Module: releasing

## What this installs

`docs/guides/releasing.md` — The release process guide. How to cut a release:
version rules, CHANGELOG format, tagging, GitHub releases, hotfix process.
Follows Keep a Changelog + Semantic Versioning.

Also optionally creates/updates `CHANGELOG.md` if it doesn't exist.

## Before you start

Search for existing files:

```bash
find . -name "releasing.md" -not -path "*/.git/*"
find . -name "CHANGELOG.md" -not -path "*/.git/*"
```

No hard prerequisites, but knowing the project's version management approach helps.

---

## If releasing.md does NOT exist — Create

1. Ask the human:
   - "Do you use any specific version management tooling? (gem-release, npm version, etc.)"
   - "Is there a CI step for releases, or is it purely manual?"
   - "Do you do hotfix releases or always from main?"

2. Use the template at `modules/process/releasing/template.md` as the base.
   Customize the version update step (step 2 in the checklist) based on the project's stack:
   - Ruby gem → update `.gemspec` version or `lib/*/version.rb`
   - Node → `package.json` version
   - Python → `pyproject.toml` version
   - Generic → `.notdefined.yml` version

3. Create `docs/guides/` directory if it doesn't exist.
   Create `docs/guides/releasing.md` with the customized content.

4. If `CHANGELOG.md` doesn't exist, create it:

```markdown
# Changelog

All notable changes to this project will be documented in this file.
Follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/).

## [Unreleased]

<!-- Changes go here as they're made -->

[Unreleased]: https://github.com/{owner}/{repo}/compare/v0.1.0...HEAD
```

---

## If releasing.md already exists — Update

1. Read the current file
2. Compare with the template:
   `https://raw.githubusercontent.com/rodacato/launchpad/master/modules/process/releasing/template.md`
3. Check for missing sections: hotfix process, agent prompts section, version rules table
4. Update with approved additions, preserving project-specific customizations

---

## When done

Update `.launchpad/manifest.yml`:
- Add `releasing: "1.0"` under `modules:`

Then delete `LAUNCHPAD_TASK.md`.
