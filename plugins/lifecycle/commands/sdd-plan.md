---
description: "SDD-lite step 2 — write docs/sdd/<change-name>/plan.md with chosen design + alternatives considered"
---

Read `skills/sdd-plan/SKILL.md` and follow its instructions exactly.

The change name is provided in `$ARGUMENTS`. The skill refuses to plan
against a draft or contradictory spec — it requires
`docs/sdd/<change-name>/spec.md` with status `accepted`.

```
Usage: /lifecycle:sdd-plan <change-name>

Examples:
  /lifecycle:sdd-plan jwt-exp-validation
  /lifecycle:sdd-plan billing-webhook-retries
```
