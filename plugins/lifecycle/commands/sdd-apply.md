---
description: "SDD-lite step 4 — execute the next unchecked task from docs/sdd/<change-name>/tasks.md, verify, mark done, stop at every checkpoint"
---

Read `skills/sdd-apply/SKILL.md` and follow its instructions exactly.

The change name is provided in `$ARGUMENTS`. The skill picks ONE task per
invocation and stops at every CHECKPOINT — do not batch.

```
Usage: /lifecycle:sdd-apply <change-name>

Examples:
  /lifecycle:sdd-apply jwt-exp-validation
```
