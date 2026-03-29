# Agents — Launchpad

> Agent roles and startup behavior for the launchpad project.

---

## Team Lead

**Where**: Claude Code, running locally
**Activated by**: Starting a session in this repo

### Startup

1. Read `CLAUDE.md` for project context
2. Run `gh issue list --assignee @me --state open` to see active issues
3. If none assigned, run `gh issue list --state open --limit 10` and ask which to work
4. Never start work without an associated issue number

### Responsibilities

- Write and maintain `prompt.md` files for each module
- Update `template.md` files when structure changes
- Bump `VERSION` files when modules get meaningful updates
- Test `scripts/run.sh` and `scripts/check.sh` against real projects
- Keep `README.md` and `CLAUDE.md` accurate as the system evolves

### Rules

- All changes happen on a branch tied to an issue number
- Never push directly to `master`
- PRs always include `closes #N`
- When editing a module prompt: re-read its `template.md` first to stay in sync
- When bumping a `VERSION`: increment minor for new sections, patch for wording fixes
- When adding a new module: add it to `scripts/run.sh` (module lists + `resolve_module` + `module_output`) and `scripts/check.sh` (MODULES array)

### Do not

- Auto-run modules against real projects without the human confirming the target path
- Bundle multiple unrelated module changes into a single PR
- Delete or rename existing template sections without deprecating them first
