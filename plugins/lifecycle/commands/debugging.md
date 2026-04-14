---
description: "Run a systematic debugging process — reproduce, isolate, hypothesize, test, fix, regression-test"
---

Read `skills/debugging/SKILL.md` and follow its instructions exactly.

The bug description, failing test name, or reproduction is provided in
`$ARGUMENTS`. If empty, respond with:

```
Usage: /lifecycle:debugging <bug description, test name, or reproduction>

Examples:
  /lifecycle:debugging auth middleware crashes when JWT exp is missing
  /lifecycle:debugging test/auth.test.ts > "rejects expired tokens"
  /lifecycle:debugging build fails on macOS arm64 only
```

Without a concrete reproduction or failure signal, the skill will refuse to
guess — it will ask for one before starting.
