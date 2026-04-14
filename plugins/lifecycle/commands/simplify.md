---
description: "Audit a diff and propose deletions for code that doesn't earn its keep — dead code, premature abstractions, speculative flexibility, over-defensive guards"
---

Read `skills/simplify/SKILL.md` and follow its instructions exactly.

The target (a diff target, PR number, or file path) is provided in
`$ARGUMENTS`. If empty, default to the uncommitted working tree
(`git diff`). Ask the human to confirm which target to audit when ambiguous.

```
Usage: /lifecycle:simplify [target]

Examples:
  /lifecycle:simplify
  /lifecycle:simplify HEAD~3..HEAD
  /lifecycle:simplify origin/main...HEAD
  /lifecycle:simplify pr 42
  /lifecycle:simplify src/auth/middleware.ts
```
