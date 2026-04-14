# Development Guide

> How to develop kwik-e-marketplace locally on this machine, iterate on any of
> the three plugins, and test changes in other projects without publishing.

---

## One-time setup

Install the marketplace as a **local path** pointing at this repo folder. No git
URL required — Claude Code reads `.claude-plugin/marketplace.json` directly.

```bash
/plugin marketplace add /Users/adriancastillo/Workspace/rodacato/kwik-e-dev
/plugin install launchpad@kwik-e-marketplace
/plugin install lifecycle@kwik-e-marketplace
/plugin install philosophy@kwik-e-marketplace
```

Confirm plugins are registered:

```bash
/plugin list
/plugin marketplace list
```

You should see three plugins — `launchpad`, `lifecycle`, `philosophy` — all
sourced from your local `kwik-e-marketplace`.

> **Already installed from git with the old marketplace name?** Uninstall first:
>
> ```bash
> /plugin uninstall launchpad@launchpad-marketplace
> /plugin marketplace remove launchpad-marketplace
> ```
>
> Then run the local install above.

---

## Daily iteration loop

### Editing skills or commands

If you change any of these files:

- `plugins/<plugin>/skills/*/SKILL.md`
- `plugins/<plugin>/skills/*/template.md`
- `plugins/<plugin>/commands/*.md`

Pick up the change with:

```bash
/reload-plugins
```

No Claude Code restart needed. Test immediately:

```bash
/launchpad:docs vision
/lifecycle:review 42
/philosophy:panel architecture review
```

### Editing a plugin manifest

If you change:

- `plugins/<plugin>/.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`
- The directory structure (adding / removing plugins, skills, or commands)

`/reload-plugins` is NOT enough. You must reinstall the affected plugin:

```bash
/plugin uninstall <plugin>@kwik-e-marketplace
/plugin install <plugin>@kwik-e-marketplace
/reload-plugins
```

For marketplace.json changes, uninstall and reinstall all affected plugins.

---

## Workflow — making a change

```text
┌──────────────────────────────────────────────────┐
│                                                  │
│  1. Edit plugins/<plugin>/skills/... or          │
│           plugins/<plugin>/commands/...          │
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

The marketplace is installed globally in Claude Code — once installed, every
plugin is available in every project on this machine. To test:

1. `cd` into any other project
2. Open Claude Code there
3. Run any command: `/launchpad:docs vision`, `/lifecycle:review 42`, etc.
4. The skill executes against that project's files

Verify the plugin is active in a given project:

```bash
/plugin list
```

---

## Version bumps

Each plugin versions independently. When you change `version` in a plugin's
`plugin.json`:

```bash
# Your local install won't auto-pick up the new version
/plugin uninstall <plugin>@kwik-e-marketplace
/plugin install <plugin>@kwik-e-marketplace
```

For users installing from the remote repo:

```bash
/plugin marketplace update kwik-e-marketplace
```

Keep `version` in both places consistent:
- `plugins/<plugin>/.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json` (the entry for that plugin)

Add a CHANGELOG entry under the new version.

---

## Debugging

When something doesn't work as expected:

```bash
/plugin validate                    # Validates marketplace.json, plugin.jsons, SKILL.md
/plugin list                        # Confirms plugins are installed + which version
/plugin marketplace list            # Confirms marketplace is registered
claude --debug                      # Start Claude with debug logging
```

If a skill isn't triggering:

- Check the `description` in its frontmatter has trigger phrases
  (`Use when X. Use when Y.`) — see `docs/guides/skill-authoring.md`
- Run `/reload-plugins` to rule out stale cache
- Try invoking explicitly: `/launchpad:docs vision`

If a command isn't showing in autocomplete:

- Check `plugins/<plugin>/commands/*.md` exists and has valid frontmatter
- Reinstall the plugin (command list is cached at install time, not hot-reloaded)

---

## Adding a new plugin to the marketplace

1. Create the plugin directory skeleton:

   ```bash
   mkdir -p plugins/<new-plugin>/.claude-plugin
   mkdir -p plugins/<new-plugin>/commands
   mkdir -p plugins/<new-plugin>/skills
   ```

2. Create `plugins/<new-plugin>/.claude-plugin/plugin.json`:

   ```json
   {
     "name": "<new-plugin>",
     "description": "...",
     "version": "0.1.0",
     "author": { "name": "rodacato", "email": "rodacato@gmail.com" },
     "homepage": "https://github.com/rodacato/kwik-e-dev",
     "repository": "https://github.com/rodacato/kwik-e-dev",
     "license": "MIT",
     "keywords": [...]
   }
   ```

3. Add an entry in `.claude-plugin/marketplace.json` under `plugins[]`:

   ```json
   {
     "name": "<new-plugin>",
     "source": "./plugins/<new-plugin>",
     "description": "...",
     "version": "0.1.0",
     "author": { "name": "rodacato" }
   }
   ```

4. Reinstall the marketplace:

   ```bash
   /plugin uninstall launchpad@kwik-e-marketplace  # if you had launchpad installed
   /plugin marketplace remove kwik-e-marketplace
   /plugin marketplace add /path/to/kwik-e-dev
   /plugin install <new-plugin>@kwik-e-marketplace
   ```

5. Add at least one skill and one command file, then `/reload-plugins`.

---

## Publishing changes

kwik-e-marketplace is public at `github.com/rodacato/kwik-e-dev`. To release:

```bash
# 1. Make changes, commit atomically
git add <files>
git commit -m "feat(launchpad): add new skill"

# 2. Bump version in both places (for the affected plugin):
#    - plugins/<plugin>/.claude-plugin/plugin.json
#    - .claude-plugin/marketplace.json (the entry for that plugin)
# Commit:
#    chore(release): launchpad@0.8.0

# 3. Add a CHANGELOG entry

# 4. Push
git push origin master
```

Users pick up the new version by running:

```bash
/plugin marketplace update kwik-e-marketplace
```

See `docs/guides/releasing.md` for the full release checklist.

---

## Uninstall

To remove the marketplace entirely from this machine:

```bash
/plugin uninstall launchpad@kwik-e-marketplace
/plugin uninstall lifecycle@kwik-e-marketplace
/plugin uninstall philosophy@kwik-e-marketplace
/plugin marketplace remove kwik-e-marketplace
```

Projects where skills were used retain their `.launchpad/manifest.yml` and any
files the skills produced — those are project-owned.

---

## Cheat sheet

| Scenario | Command |
|---|---|
| Edit SKILL.md or commands/*.md | `/reload-plugins` |
| Edit `plugins/<plugin>/.claude-plugin/plugin.json` | Uninstall + reinstall that plugin |
| Edit `.claude-plugin/marketplace.json` | Uninstall all + `marketplace remove` + re-add + reinstall |
| Check what's installed | `/plugin list` |
| Check marketplace sources | `/plugin marketplace list` |
| Validate plugin files | `/plugin validate` |
| Debug plugin loading | `claude --debug` |
| Full reinstall single plugin | `/plugin uninstall <plugin>@kwik-e-marketplace` then `/plugin install <plugin>@kwik-e-marketplace` |
| Remove everything | Uninstall every plugin + `/plugin marketplace remove kwik-e-marketplace` |

---

## Common issues

**"Plugin not loading after edit"**
→ Run `/reload-plugins`. If still not picking up, you likely edited a `plugin.json`
  (requires reinstall) not a SKILL.md.

**"Command shows but skill does nothing"**
→ Check the skill's `description` frontmatter has trigger phrases. Verify the
  SKILL.md file exists at `plugins/<plugin>/skills/<name>/SKILL.md`. Run
  `/plugin validate`.

**"Changes visible in this project but not another"**
→ `/reload-plugins` is per-session. Run it in the other project's Claude Code
  session too.

**"Version bump not reflected"**
→ Local installs don't auto-refresh versions. Uninstall + reinstall the plugin.

**"Plugin not found in any marketplace" after local install**
→ Confirm `plugins/<plugin>/.claude-plugin/plugin.json` exists. Confirm
  `.claude-plugin/marketplace.json` lists the plugin with
  `"source": "./plugins/<plugin>"`. This is exactly the structure the official
  Anthropic marketplaces use — if it still fails, re-add the marketplace from
  scratch (`remove` then `add`).
