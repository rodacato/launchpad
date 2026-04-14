# Releasing

How to cut a release for kwik-e-marketplace. Each plugin versions independently,
so a release is always **per plugin**, never marketplace-wide.

Follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and
[Semantic Versioning](https://semver.org/).

---

## Per-plugin versioning

The three plugins ship on their own clocks:

| Plugin | Versioned in |
|---|---|
| `launchpad` | `plugins/launchpad/.claude-plugin/plugin.json` |
| `lifecycle` | `plugins/lifecycle/.claude-plugin/plugin.json` |
| `philosophy` | `plugins/philosophy/.claude-plugin/plugin.json` |

The marketplace-level file `.claude-plugin/marketplace.json` carries a copy of
each plugin's version. **Both numbers must match** — if they drift, users on
`/plugin install` get mystery mismatches.

Tags on git are per-plugin too: `launchpad-v0.7.0`, `lifecycle-v0.1.0`,
`philosophy-v0.2.0`. No repo-wide `vX.Y.Z` tag.

---

## When to release

- A meaningful set of changes for **one plugin** is ready to be stable
- Don't release every commit. Don't let `[Unreleased]` grow for months
- A good release is a capability (a new skill, a format upgrade, a behavior
  change) that's complete and tested

If you changed skills in two plugins in the same PR, that's two releases — do
them separately.

---

## Version rules

| Change type | Version bump | Example |
|---|---|---|
| Bug fixes, typos, small clarifications in a SKILL.md | Patch — `0.0.X` | `0.7.0` → `0.7.1` |
| New skill, new command, new section in a skill | Minor — `0.X.0` | `0.7.0` → `0.8.0` |
| Rename a skill, remove a command, change invocation path | Major — `X.0.0` | `0.7.0` → `1.0.0` |

Before `1.0.0`: use minor for features, patch for fixes.
The jump to `1.0.0` means: invocation paths are stable, committed to not
breaking what's installed.

---

## Release checklist

The example below releases `launchpad@0.8.0`. Swap the plugin name and version
for whatever you're cutting.

### 1. Confirm the plugin is ready

```bash
/plugin validate                          # Validates marketplace.json + plugin.jsons + SKILL.mds
git status                                 # No uncommitted skill or command changes
```

Run the plugin's commands one more time against a real project to smoke-test
before tagging.

### 2. Bump the version in both places

Edit `plugins/launchpad/.claude-plugin/plugin.json`:

```json
{
  "name": "launchpad",
  "version": "0.8.0",
  ...
}
```

Edit the matching entry in `.claude-plugin/marketplace.json`:

```json
{
  "name": "launchpad",
  "source": "./plugins/launchpad",
  "version": "0.8.0",
  ...
}
```

These must match exactly.

### 3. Update CHANGELOG.md

Move everything under `[Unreleased]` that applies to THIS plugin into a new
dated section. Keep the other plugins' unreleased entries in place.

```markdown
## [Unreleased]

### lifecycle@0.2.0 — <summary>
...

---

## [launchpad@0.8.0] - 2026-05-03

**Added:**
- New skill: `kubernetes` under `plugins/launchpad/skills/kubernetes/`
- `/launchpad:infra kubernetes` command

**Changed:**
- `devcontainer` skill: bumped to 1.2, adds ARM64 detection

**Why:** Devcontainer wasn't probing architecture on Apple Silicon...
```

Add the comparison link at the bottom of the file:

```markdown
[launchpad@0.8.0]: https://github.com/rodacato/kwik-e-dev/compare/launchpad-v0.7.0...launchpad-v0.8.0
```

### 4. Bump the affected skill VERSIONs

If you touched any `SKILL.md`, bump its sibling `VERSION` file. Minor for new
sections or significant reformat, patch for typo fixes.

```bash
# For each changed skill:
echo "1.2" > plugins/launchpad/skills/devcontainer/VERSION
```

No newline at the end — `VERSION` is a bare semver string.

### 5. Commit the release

```bash
git add plugins/launchpad/.claude-plugin/plugin.json \
        .claude-plugin/marketplace.json \
        CHANGELOG.md \
        plugins/launchpad/skills/*/VERSION
git commit -m "chore(launchpad): release v0.8.0"
```

### 6. Tag and push

```bash
git tag launchpad-v0.8.0
git push origin master
git push origin launchpad-v0.8.0
```

### 7. Create the GitHub release

```bash
gh release create launchpad-v0.8.0 \
  --title "launchpad@0.8.0" \
  --notes "$(awk '/^## \[launchpad@0\.8\.0\]/,/^---/' CHANGELOG.md | sed '$d')" \
  --latest=false
```

Only one release at a time should be `--latest=true` across the three plugins —
pick whichever was most recent if you care about the "Latest" badge on GitHub.
Otherwise leave them all non-latest and users discover releases via
`/plugin marketplace update`.

---

## How users pick up the release

After the tag is pushed and visible on GitHub:

```bash
/plugin marketplace update kwik-e-marketplace
/plugin uninstall launchpad@kwik-e-marketplace
/plugin install launchpad@kwik-e-marketplace
```

The uninstall/install dance is required because Claude Code doesn't hot-swap
installed plugin versions. Only new marketplace versions are detected by
`update`.

---

## Hotfix releases

For urgent fixes that can't wait for the next planned release:

```bash
# Branch from the last tag
git checkout launchpad-v0.8.0
git checkout -b hotfix-launchpad-devcontainer

# Fix, test, commit
git commit -m "fix(launchpad/devcontainer): prevent crash on missing dockerfile"

# Merge back to master
git checkout master
git merge hotfix-launchpad-devcontainer

# Bump patch in both plugin.json + marketplace.json → 0.8.1
# Add CHANGELOG entry under launchpad@0.8.1

git tag launchpad-v0.8.1
git push origin master launchpad-v0.8.1
gh release create launchpad-v0.8.1 \
  --title "launchpad@0.8.1 — hotfix" \
  --notes "Fix: devcontainer crash on missing Dockerfile"
```

---

## What goes in each CHANGELOG section

| Section | Include |
|---|---|
| `Added` | New skills, new commands, new sections in a SKILL.md |
| `Changed` | Behavior changes in existing skills, reformatted templates |
| `Deprecated` | Skills or commands that still work but will be removed |
| `Removed` | Skills or commands that no longer exist |
| `Fixed` | Bugs in skill logic, broken command dispatch, template errors |
| `Security` | Anything that changes exposure in generated files |

**Do not include:**

- Internal refactors with no user-visible skill behavior change — use `chore`
  commits but skip the changelog
- Doc-only updates under `docs/guides/` unless they represent a workflow change
  users need to know about
- Version bumps to `VERSION` files alone — mention the skill changes that
  caused them, not the bump itself

---

## Asking the agent to help

You can ask Claude Code to prepare a release:

```
Prepare launchpad@0.8.0.
Read CHANGELOG.md's [Unreleased] section and the commits since
tag launchpad-v0.7.0.
Move applicable entries under a new [launchpad@0.8.0] heading dated today.
Bump plugin.json + marketplace.json to 0.8.0.
Bump VERSION files for any skill I touched.
Show me the full diff before committing.
```

Or to draft release notes:

```
Read CHANGELOG.md section [launchpad@0.8.0] and the GitHub issues
closed on master since launchpad-v0.7.0.
Write release notes in the Keep a Changelog format.
Don't commit — just show me.
```
