# Releasing

How to cut a release for this project.
Follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/).

---

## When to release

Release when a meaningful set of changes is ready to be stable.
Don't release every commit. Don't let `[Unreleased]` grow for months.

A good release is a sprint that's mostly done, or a specific feature that's
complete and stable enough to version.

---

## Version rules

| Change type | Version bump | Example |
|---|---|---|
| Bug fixes, small improvements | Patch — `0.1.X` | `0.1.0` → `0.1.1` |
| New features, backward compatible | Minor — `0.X.0` | `0.1.0` → `0.2.0` |
| Breaking changes | Major — `X.0.0` | `0.1.0` → `1.0.0` |

Early projects (before `1.0.0`) use minor bumps for features and patch for fixes.
The jump to `1.0.0` means: stable API, committed to not breaking things.

---

## Release checklist

### 1. Prepare CHANGELOG.md

Open `CHANGELOG.md` and move everything under `[Unreleased]` to a new versioned section:

```markdown
## [0.2.0] - 2026-04-15

### Added
- Search endpoint with pgvector similarity
- CLI command: `recall search "query"`

### Fixed
- Empty results no longer crash the status command

## [Unreleased]
(empty — new changes go here)
```

Update the comparison link at the bottom:

```markdown
[Unreleased]: https://github.com/rodacato/project/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/rodacato/project/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/rodacato/project/releases/tag/v0.1.0
```

### 2. Update version references

Update the version in `.notdefined.yml`:

```yaml
version: "0.2.0"
```

Update any other version references in the project (gemspec, package.json, etc.):

```bash
# Find version strings to update
grep -r "0\.1\.0" . --include="*.rb" --include="*.json" --include="*.yml" \
  --exclude-dir=".git" --exclude-dir="node_modules"
```

### 3. Commit the release

```bash
git add CHANGELOG.md .notdefined.yml
git commit -m "chore(release): v0.2.0"
```

### 4. Tag and push

```bash
git tag v0.2.0
git push origin main
git push origin v0.2.0
```

### 5. Create the GitHub release

```bash
gh release create v0.2.0 \
  --title "v0.2.0" \
  --notes "$(awk '/^## \[0\.2\.0\]/,/^## \[/' CHANGELOG.md | head -n -1)" \
  --latest
```

Or interactively:

```bash
gh release create v0.2.0 --generate-notes
# Then edit the notes to match your CHANGELOG section
```

---

## Hotfix releases

For urgent fixes that can't wait for the next planned release:

```bash
# Branch from the last tag
git checkout v0.2.0
git checkout -b hotfix-auth-crash

# Fix, test, commit
git commit -m "fix(auth): prevent crash on expired token"

# Merge back to main
git checkout main
git merge hotfix-auth-crash

# Release as patch
git tag v0.2.1
git push origin main v0.2.1
gh release create v0.2.1 --title "v0.2.1 — hotfix" --notes "Fix: auth crash on expired token"
```

---

## What goes in each section

| Section | Include |
|---|---|
| `Added` | New features, new commands, new endpoints |
| `Changed` | Behavior changes in existing features |
| `Deprecated` | Things that still work but will be removed |
| `Removed` | Things that no longer exist |
| `Fixed` | Bug fixes |
| `Security` | Security patches — always mention CVE if applicable |

**Do not include**:
- Internal refactors with no user-visible effect → use `chore` commits but skip the changelog
- Dependency bumps unless they change behavior → `chore(deps): bump X`
- Test additions → not user-facing

---

## Asking the agent to help

You can ask Claude Code to prepare a release:

```
Prepare the release for v0.2.0. 
Read CHANGELOG.md and the commits since the last tag.
Update the [Unreleased] section with what changed.
Update .notdefined.yml version.
Show me the diff before committing anything.
```

Or to draft the release notes:

```
Read the CHANGELOG.md section for v0.2.0 and the GitHub issues
closed in this milestone. Write release notes in the Keep a Changelog
format. Don't commit, just show me.
```
