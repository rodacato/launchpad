# Development Guide

> How to develop launchpad locally on this machine, iterate on skills, and test
> changes in other projects without publishing.

---

## One-time setup

Install launchpad as a **local marketplace** pointing at this repo folder. No git
URL required — Claude Code reads `.claude-plugin/marketplace.json` directly from
the path.

```bash
/plugin marketplace add /Users/adriancastillo/Workspace/rodacato/launchpad
/plugin install launchpad@launchpad-marketplace
```

Confirm it's registered:

```bash
/plugin list
/plugin marketplace list
```

You should see `launchpad@launchpad-marketplace` installed with source pointing
at your local path.

> **Already installed from git?** Uninstall the remote version first so the local
> one takes precedence:
> ```bash
> /plugin uninstall launchpad@launchpad-marketplace
> /plugin marketplace remove launchpad-marketplace
> ```
> Then run the local install above.

---

## Daily iteration loop

### Editing skills or commands

If you change any of these:

- `skills/*/SKILL.md`
- `skills/*/template.md`
- `commands/*.md`
- `agents/*.md` (future)
- `hooks/hooks.json` (future)

Pick up the change with:

```bash
/reload-plugins
```

No restart needed. Test immediately:

```bash
/launchpad:docs vision        # or whichever command you're working on
```

### Editing the plugin manifest

If you change:

- `.claude-plugin/plugin.json` (version, description, dependencies)
- `.claude-plugin/marketplace.json`
- The directory structure (adding/removing skills that should be exposed)

`/reload-plugins` is NOT enough. You must reinstall:

```bash
/plugin uninstall launchpad@launchpad-marketplace
/plugin install launchpad@launchpad-marketplace
/reload-plugins
```

---

## Workflow — making a change

```text
┌──────────────────────────────────────────────────┐
│                                                  │
│  1. Edit SKILL.md / commands/*.md / etc.         │
│              │                                   │
│              ▼                                   │
│  2. /reload-plugins                              │
│              │                                   │
│              ▼                                   │
│  3. Test the command in this project             │
│              │                                   │
│              ▼                                   │
│  4. cd to another project → test there too       │
│              │                                   │
│              ▼                                   │
│  5. Happy? Commit. Push when ready.              │
│                                                  │
└──────────────────────────────────────────────────┘
```

Keep commits atomic — one skill or one guide change per commit. See
`docs/guides/skill-authoring.md` for how to write new skills.

---

## Testing in another project

Launchpad is installed globally once you run the install steps above, so it's
available in EVERY project on this machine. To test:

1. `cd` into any other project
2. Open Claude Code there
3. Run `/launchpad:<group> <skill>` — for example `/launchpad:docs vision`
4. The skill executes against that project's files

No need to reinstall per project. The plugin is global to your Claude Code
installation.

To verify the plugin is active in a given project:

```bash
/plugin list
```

---

## Version bumps

When you change `version` in `.claude-plugin/plugin.json`:

```bash
# Your local install won't auto-pick up the new version
/plugin uninstall launchpad@launchpad-marketplace
/plugin install launchpad@launchpad-marketplace
```

For users installing from the remote repo, they run:

```bash
/plugin marketplace update launchpad-marketplace
```

Bump version in both `.claude-plugin/plugin.json` AND `.claude-plugin/marketplace.json`.
They must match.

---

## Debugging

When something doesn't work as expected:

```bash
/plugin validate                    # Validates plugin.json, SKILL.md, hooks
/plugin list                        # Confirms plugin is installed + which version
/plugin marketplace list            # Confirms marketplace is registered
claude --debug                      # Start Claude with debug logging
```

If a skill isn't triggering:

- Check the `description` in its frontmatter has trigger phrases
  (`Use when X. Use when Y.`) — see `docs/guides/skill-authoring.md`
- Run `/reload-plugins` to rule out stale cache
- Try invoking explicitly: `/launchpad:<group> <skill-name>`

If a command isn't showing in autocomplete:

- Check `commands/*.md` file exists and has valid frontmatter
- Reinstall the plugin (command list is cached at install time, not hot-reloaded)

---

## Publishing changes

Launchpad is a public plugin at `github.com/rodacato/launchpad`. To release:

```bash
# 1. Make changes, commit atomically
git add <files>
git commit -m "feat(skills): ..."

# 2. Bump version in both places
# .claude-plugin/plugin.json       → "version": "0.7.0"
# .claude-plugin/marketplace.json  → "version": "0.7.0"
# Commit: chore(release): v0.7.0

# 3. Push
git push origin master
```

Users on the remote install will pick up the new version next time they run
`/plugin marketplace update launchpad-marketplace`.

See `docs/guides/releasing.md` for the full release checklist.

---

## Uninstall

If you want to remove launchpad entirely from your Claude Code install:

```bash
/plugin uninstall launchpad@launchpad-marketplace
/plugin marketplace remove launchpad-marketplace
```

Projects where launchpad was used will retain their `.launchpad/manifest.yml`
and the files the skills produced — those are owned by the project, not the
plugin.

---

## Cheat sheet

| Scenario | Command |
|---|---|
| Edit SKILL.md or commands/*.md | `/reload-plugins` |
| Edit `.claude-plugin/plugin.json` | Uninstall + reinstall |
| Check what's installed | `/plugin list` |
| Check marketplace sources | `/plugin marketplace list` |
| Validate plugin files | `/plugin validate` |
| Debug plugin loading | `claude --debug` |
| Full reinstall | `/plugin uninstall ...` then `/plugin install ...` |
| Remove completely | `/plugin uninstall` + `/plugin marketplace remove` |

---

## Common issues

**"Plugin not loading after edit"**
→ Run `/reload-plugins`. If still not picking up, you likely edited `plugin.json`
  (requires reinstall) not a SKILL.md.

**"Command shows but skill does nothing"**
→ Check the skill's `description` frontmatter has trigger phrases. Check the
  SKILL.md file exists at `skills/<name>/SKILL.md`. Run `/plugin validate`.

**"Changes visible in this project but not another"**
→ `/reload-plugins` is per-session. Run it in the other project's Claude Code
  session too.

**"Version bump not reflected"**
→ Local installs don't auto-refresh versions. Uninstall + reinstall.
