---
description: "SDD-lite step 5 — validate implementation against the spec; report CRITICAL/WARNING/SUGGESTION findings with verdict APPROVE or REQUEST CHANGES"
---

Read `skills/sdd-verify/SKILL.md` and follow its instructions exactly.

The change name is provided in `$ARGUMENTS`. The skill requires all four
artifacts (spec, plan, tasks, implementation) and refuses to verify against
unchecked tasks.

This is NOT a code-quality review — that's `lifecycle:review`. This is a
spec-fit check.

```
Usage: /lifecycle:sdd-verify <change-name>

Examples:
  /lifecycle:sdd-verify jwt-exp-validation
```
