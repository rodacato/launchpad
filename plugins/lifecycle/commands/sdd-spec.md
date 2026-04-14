---
description: "SDD-lite step 1 — write docs/sdd/<change-name>/spec.md (WHAT, WHY, success criteria) for a substantial change"
---

Read `skills/sdd-spec/SKILL.md` and follow its instructions exactly.

The change name (kebab-case) is provided in `$ARGUMENTS`. If empty, ask
the human for one before doing anything else — the change name becomes the
folder under `docs/sdd/`.

```
Usage: /lifecycle:sdd-spec <change-name>

Examples:
  /lifecycle:sdd-spec jwt-exp-validation
  /lifecycle:sdd-spec billing-webhook-retries
  /lifecycle:sdd-spec migrate-auth-middleware
```
