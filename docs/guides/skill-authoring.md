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

## Three skill categories

Skills in this marketplace fall into one of three categories. Each lives in its
own plugin. Know which you're writing before you start — it changes the shape of
the Process section.

| Category | Plugin | What it does | Output | Examples |
|---|---|---|---|---|
| **bootstrap** | `launchpad` | Sets up a project artifact | File(s) written to the project | `vision`, `architecture`, `devcontainer`, `github` |
| **lifecycle** | `lifecycle` | Governs a recurring behavior | Action performed (review posted, commit made, tests run) | `code-review`, future: `git-workflow`, `debugging` |
| **philosophy** | `philosophy` | Consulted for guidance | An advisory read-out or reference application | `experts`, `identity` |

Bootstrap skills get tracked in a target project's `.launchpad/manifest.yml`
(version per installed skill). Lifecycle and philosophy skills do NOT appear in
the manifest — they run ON projects, not INTO them, and nothing needs to be
versioned per target project.

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
---
```

That's the entire frontmatter. Three keys total.

- `name` — lowercase, hyphenated; must match the skill's directory name
- `description` — what the skill does AND when to use it. The agent reads this
  to auto-discover which skill fits the task. Load it with `Use when X.` clauses
  — at least 2, ideally 3-4. A naked one-liner loses auto-discovery.
- `metadata.version` — semver string. Bump on any behavior-changing edit.

**What is intentionally NOT in the frontmatter:**

- `metadata.author` — plugin-level info, lives in `plugin.json`
- `metadata.category` — the plugin IS the category (`launchpad` = bootstrap,
  `lifecycle` = lifecycle, `philosophy` = philosophy)
- `metadata.triggers` — keyword arrays duplicate the description's `Use when`
  clauses. Put trigger language inline in the description instead

Inspired by [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills),
which uses the same minimal shape and proved that auto-discovery works on
description alone.

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

- [ ] Frontmatter is exactly three keys: `name`, `description`, `metadata.version`
      — no `author`, no `category`, no `triggers` array
- [ ] `description` contains at least 2 `Use when ...` clauses inline (these
      are the auto-discovery triggers; a one-liner won't be matched reliably)
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
plugins/<plugin>/skills/<skill-name>/
├── SKILL.md          # The workflow (this template)
├── VERSION           # Semver, no newline (e.g. "0.1")
└── template.md       # Bootstrap only — the artifact shape the agent produces
```

Lifecycle and philosophy skills don't need `template.md` — their "output" is
an action or a consultation, not a file.

**Which plugin do I drop my skill into?**

| Skill produces... | Plugin |
|---|---|
| A document, a config, a CI file, an infra artifact | `launchpad` |
| A review, a commit, a merge, a deploy, a debug session | `lifecycle` |
| An advisory consultation, a principles reference, a panel read-out | `philosophy` |

Decision flowchart when the table is ambiguous:

```text
What does running this skill leave behind?

   File(s) committed to the target project's git tree?
       ├─ YES ──→ launchpad
       └─ NO  ─→  Action affecting external state (PR comment, tag, deploy)?
                      ├─ YES ──→ lifecycle
                      └─ NO  ─→  Reference / advisory only?
                                     ├─ YES ──→ philosophy
                                     └─ NO  ─→  pause — talk to a human first
```

If unsure, ask before creating. Boundary-adjacent skills are worth a quick
discussion.

---

## Examples in this repo

| Skill | Plugin | Category | What to study |
|---|---|---|---|
| [plugins/lifecycle/skills/code-review/SKILL.md](../../plugins/lifecycle/skills/code-review/SKILL.md) | lifecycle | lifecycle | Full new-format reference — Rationalizations, Red Flags, Verification, gh CLI commands |
| [plugins/launchpad/skills/vision/SKILL.md](../../plugins/launchpad/skills/vision/SKILL.md) | launchpad | bootstrap | Dialogue-driven step structure with all new-format sections |
| [plugins/philosophy/skills/experts/SKILL.md](../../plugins/philosophy/skills/experts/SKILL.md) | philosophy | philosophy | Reference skill — consultation-oriented rather than doc-producing |

When in doubt, copy the closest example and adapt:
- **Lifecycle / workflow skill** → start from `code-review`
- **Bootstrap / doc-producing skill** → start from `vision`
- **Philosophy / reference skill** → start from `experts`

---

## When to evolve the template

If you find yourself writing a skill that doesn't fit this template cleanly,
don't bend the skill — pause and ask whether the template needs a new section.
A template that produces awkward output is a template with a missing section.

Record the gap in an issue, propose the addition, and update this guide in the
same PR that adds the section to the template.
