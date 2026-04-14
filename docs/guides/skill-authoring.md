# Skill Authoring Guide

> How to write a skill for launchpad. The template, the reasoning behind each section,
> and the process for shipping one that the agent will actually follow.

---

## Purpose

A launchpad skill is an executable workflow an AI agent follows to accomplish a
specific task — either producing an artifact (docs, config) or governing a behavior
(reviewing, committing, debugging). This guide defines the shape every skill should
take so the agent loads, discovers, and executes them consistently.

**Reference implementation:** `skills/code-review/SKILL.md` — read it alongside this
guide.

---

## Two skill categories

Launchpad skills fall into one of two categories. Know which you're writing before
you start — it changes the shape of the Process section.

| Category | What it does | Output | Example |
|---|---|---|---|
| **bootstrap** | Sets up a project artifact | File(s) written to the project | `vision`, `devcontainer`, `github` |
| **lifecycle** | Governs a recurring behavior | Action performed (review posted, commit made, tests written) | `code-review`, `git-workflow` (future) |

Bootstrap skills get installed and tracked in `.launchpad/manifest.yml`. Lifecycle
skills are invoked on-demand and do NOT go in the manifest — nothing to version
into the project.

A third category — `philosophy` — covers reference material like `experts` and
`identity`. Those are consulted, not executed.

---

## The anatomy

Every SKILL.md has these sections in this order. Skip at your peril — each one
exists because the agent skips the section that isn't there.

### 1. Frontmatter

```yaml
---
name: <lowercase-hyphenated>
description: <one-sentence WHAT>. Use when <trigger 1>. Use when <trigger 2>.
metadata:
  version: "0.1"
  author: rodacato
  category: bootstrap | lifecycle | philosophy
  triggers:
    - <keyword>
    - <natural phrase>
---
```

The `description` is what the agent reads to decide whether THIS skill applies to
the current task. Load it with trigger phrases like `Use when X`. A naked
one-liner loses auto-discovery.

### 2. Title

One line. Human-readable, no "Skill:" prefix.

### 3. Overview

One to three sentences. The **thesis** — why this skill exists and what problem
it solves. Not the history. Not the features. The core claim.

### 4. When to Use

Bullet list of concrete triggers — situations where this skill applies. Then a
`**When NOT to use:**` counter-list. The NOT list is as important as the use
list; it prevents the skill from firing on every vaguely-related task.

### 5. Before you start

Prerequisites. Files the agent must read first. Tools that must be installed
(`gh`, `docker`, etc.). If none, say "No prerequisites."

### 6. Process

The meat. **Numbered steps**, in execution order.

- **For bootstrap skills:** dialogue-driven — "Ask the user X", "Wait for answer",
  "Show the draft", "Get approval before writing".
- **For lifecycle skills:** executable — concrete commands, branching logic based
  on findings, explicit verdicts.

Use ASCII diagrams when a workflow has a cycle or branches. Use tables when
comparing options (e.g. severity levels, strategies). Use code blocks for every
command the agent should run verbatim.

### 7. Common Rationalizations

A 2-column markdown table: `| Rationalization | Reality |`.

This is the anti-excuse defense. List the excuses the agent (or you) will give
to skip steps, and the technical rebuttal. Examples:

| Rationalization | Reality |
|---|---|
| "It's too simple to need a test" | Simple code gets complicated. The test documents the expected behavior. |
| "CI is green, it's fine" | CI catches a fraction of what matters. Architecture is invisible to CI. |

This section is what separates a prompt from a process. Steal rationalizations
aggressively from `skills/code-review/SKILL.md` and addyosmani's repo.

### 8. Red Flags

Bullet list of **observable signals** that something is wrong. Not principles —
checks an agent can actually perform by looking at the code, the diff, the doc
output, or the state.

Good: "Method longer than 50 lines with no justification"
Bad: "The code feels off"

### 9. Verification

Markdown checklist (`- [ ]`) of **concrete evidence** required before the skill
reports "done". Every item must be something the agent can point to.

Good: `- [ ] gh pr view <N> --comments confirms the review is live`
Bad: `- [ ] Review is complete`

This is the quality gate. Without it, "seems right" becomes the default.

### 10. When done

Two subsections:

- **Manifest update** (bootstrap only): `set <skill>: "X.Y" under modules:` in
  `.launchpad/manifest.yml`. Lifecycle skills say "Nothing to update — this is
  a lifecycle skill."
- **Next likely skills**: what the user / agent should probably run after this
  one. Creates a natural chain.

---

## The copyable template

```markdown
---
name: <lowercase-hyphenated>
description: <What the skill does>. Use when <trigger 1>. Use when <trigger 2>.
metadata:
  version: "0.1"
  author: rodacato
  category: bootstrap | lifecycle | philosophy
  triggers:
    - <keyword>
    - <natural phrase>
---

# <Human Title>

## Overview

<One to three sentences. The thesis.>

## When to Use

- <concrete trigger>
- <concrete trigger>

**When NOT to use:**
- <counter-trigger>

## Before you start

<Prerequisites, files to read first, tools to check.>

## Process

### Step 1 — <verb phrase>

<Dialogue for bootstrap, commands for lifecycle.>

### Step 2 — <verb phrase>

...

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "<excuse>" | <rebuttal with concrete why> |

## Red Flags

- <observable signal>
- <observable signal>

## Verification

- [ ] <concrete check producing evidence>
- [ ] <concrete check producing evidence>

## When done

<Manifest update for bootstrap skills, or "Nothing to update — lifecycle skill.">

Next likely skills:
- <skill> — <one-line when>
```

---

## How to write one — the process

1. **Pick the category.** Bootstrap or lifecycle? Write it on a sticky note.
2. **Write the one-line thesis.** If you can't summarize the skill in one
   sentence, the scope is wrong — the skill does too much.
3. **Draft the frontmatter description.** Load it with `Use when` triggers.
4. **List the 5-10 steps of the Process** as bullet points. Don't write prose
   yet — just the sequence.
5. **Identify 3-5 Rationalizations.** Ask: "Why would someone skip this skill
   or cut corners in it?" Each becomes a row in the table.
6. **Identify 3-5 Red Flags.** Ask: "If this skill ran WRONG, what would I see?"
7. **Write the Verification checklist.** Ask: "What evidence proves the skill
   actually worked?" Each item must be checkable.
8. **Fill in the Process** as prose / commands / dialogue.
9. **Write the Overview last.** By now you know what the skill really is.

Do NOT write the Overview first. You don't know what the skill is until you've
written the Process.

---

## Quality checklist

Before shipping a new skill, verify:

- [ ] `description` contains at least one `Use when` trigger phrase
- [ ] `When to Use` has a `**When NOT to use:**` counter-list
- [ ] Process steps are numbered and in execution order
- [ ] At least 3 rows in Common Rationalizations
- [ ] At least 3 items in Red Flags
- [ ] Verification items are concrete (reference a file, a command, or an
      observable state — not a feeling)
- [ ] If bootstrap: `template.md` in the skill directory, and `When done`
      updates `manifest.yml`
- [ ] `VERSION` file created with semver (start at `0.1` for unreleased,
      `1.0` for first stable release)
- [ ] A Claude Code agent can read it cold and execute without asking
      clarifying questions

---

## File structure per skill

```
skills/<skill-name>/
├── SKILL.md          # The workflow (this template)
├── VERSION           # Semver, no newline (e.g. "0.1")
└── template.md       # Bootstrap only — the artifact shape the agent produces
```

Lifecycle skills don't need `template.md` — their "output" is an action, not a
file.

---

## Examples in this repo

| Skill | Category | What to study |
|---|---|---|
| [skills/code-review/SKILL.md](../../skills/code-review/SKILL.md) | lifecycle | Full new-format reference — Rationalizations, Red Flags, Verification, gh CLI commands |
| [skills/vision/SKILL.md](../../skills/vision/SKILL.md) | bootstrap (old format) | Dialogue-driven step structure — will be upgraded to new format |
| [skills/workflow/SKILL.md](../../skills/workflow/SKILL.md) | bootstrap (old format) | Customization-heavy skill with per-project variation |

When in doubt, copy `skills/code-review/SKILL.md` and adapt. It's the canonical
reference for the new format.

---

## When to evolve the template

If you find yourself writing a skill that doesn't fit this template cleanly,
don't bend the skill — pause and ask whether the template needs a new section.
A template that produces awkward output is a template with a missing section.

Record the gap in an issue, propose the addition, and update this guide in the
same PR that adds the section to the template.
