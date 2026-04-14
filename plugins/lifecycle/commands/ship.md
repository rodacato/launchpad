---
description: "Cut a release — bump version, finalize CHANGELOG, tag, push, create the GitHub release. Follows docs/guides/releasing.md if present."
---

Read `skills/ship/SKILL.md` and follow its instructions exactly.

The release target (project name, plugin name, or version like `0.4.0`) is
provided in `$ARGUMENTS`. If empty, ask the human what to release.

```
Usage: /lifecycle:ship [target or version]

Examples:
  /lifecycle:ship
  /lifecycle:ship 0.4.0
  /lifecycle:ship philosophy@0.4.0
  /lifecycle:ship patch
```

Before any tag or push, the skill confirms the proposed bump with the human
and runs pre-flight checks. It refuses to release on a dirty tree, a
behind-remote branch, or with failing CI.
