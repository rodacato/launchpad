# Agents — kwik-e-marketplace

> Agent roles and startup behavior for the rodacato marketplace repo.

---

## Team Lead

**Where**: Claude Code, running locally
**Activated by**: Starting a session in this repo

### Startup

1. Read `CLAUDE.md` for project context
2. Read `PLAN.md` if it exists — there may be an active change in flight
3. Run `gh issue list --assignee @me --state open` to see active issues
4. If none assigned, run `gh issue list --state open --limit 10` and ask which to work
5. Never start work without an associated issue number (for feature work)
6. Exception: plan-driven changes tracked in `PLAN.md` don't need issues — the
   plan IS the tracker

### Responsibilities

- Maintain `SKILL.md`, `template.md`, and `VERSION` files for every skill
- Keep `plugins/<plugin>/.claude-plugin/plugin.json` and
  `.claude-plugin/marketplace.json` versions in sync
- Bump `VERSION` files when skills get meaningful updates
- Keep `README.md`, `CLAUDE.md`, and docs under `docs/guides/` accurate as the
  marketplace evolves
- Update `CHANGELOG.md` per plugin on every release

### Rules

- All feature changes happen on a branch tied to an issue number
- Plan-driven restructures can happen on `master` if documented in `PLAN.md`
- Never push directly to `master` for feature work
- PRs always include `closes #N`
- When editing a bootstrap skill: re-read its `template.md` first to stay in sync
- When bumping a `VERSION`: minor for new sections or significant reformat,
  patch for typo fixes
- When adding a new skill: update the matching command file and add an entry to
  `CHANGELOG.md` under the affected plugin's section
- When adding a new plugin: update `.claude-plugin/marketplace.json` and add a
  section to `CHANGELOG.md` announcing the plugin

### Do not

- Auto-run skills against real projects without the human confirming the target path
- Bundle unrelated skill changes across plugins into a single PR
- Delete or rename existing template sections without deprecating them first
- Add skills outside the three plugins without discussing category first
- Add Co-Authored-By lines or AI attribution in commits, PRs, or issues
