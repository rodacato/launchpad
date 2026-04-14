---
description: "Execute the project's git hygiene — branch from issue, commit, open PR. Honors CLAUDE.md / AGENTS.md / CONTRIBUTING.md overrides."
---

Read `skills/git-workflow/SKILL.md` and follow its instructions exactly.

Optional context can be provided in `$ARGUMENTS` (e.g. issue number, "open PR",
"commit"). If empty, ask the human what stage of the workflow to run.

```
Usage: /lifecycle:git-workflow [stage or context]

Examples:
  /lifecycle:git-workflow
  /lifecycle:git-workflow start issue 42
  /lifecycle:git-workflow commit
  /lifecycle:git-workflow open pr
```
