---
name: voice
description: Create or update a Claude Code output style at ~/.claude/output-styles/<name>.md — the user-level voice (tone, language, idioms) the agent uses in every session. Use when the agent's tone feels generic or inconsistent across projects. Use when you want a personal speaking style applied globally regardless of project. Use to complement a project Identity — Identity is what the agent thinks, Voice is how it sounds.
metadata:
  version: "0.1"
  author: rodacato
  category: philosophy
  triggers:
    - voice
    - "output style"
    - "output-style"
    - "agent tone"
    - "agent voice"
    - "personal style"
    - "global persona"
---

# Voice

## Overview

Create or update a Claude Code output style file at
`~/.claude/output-styles/<name>.md` — the user-level voice the agent uses
across every project. Voice is global and personal (how the agent SOUNDS);
Identity is per-project (what the agent THINKS). Together they give the
agent a consistent personality without collapsing one into the other.

## When to Use

- Agent's tone feels generic or robotic across sessions and projects
- You want a consistent speaking style — idioms, language, formality — no matter which repo you're in
- You already have an IDENTITY.md but the agent still sounds off — the layer missing is Voice
- Migrating from a single CLAUDE.md that mixed voice and rules — split the voice out into an output style
- Starting with Claude Code and you want your agent to feel like yours from day one

**When NOT to use:**
- You need project-specific rules or technical opinions — that's `identity`, not `voice`
- You need a one-off instruction for a single task — just say it, don't bake it into a global style
- You share a machine and different users want different voices — output styles are per-user config; they'll collide

## Before you start

Check the current state:

```bash
ls ~/.claude/output-styles/ 2>/dev/null || echo "no output styles yet"
claude config get output-style 2>/dev/null
```

Read these to understand what Voice is NOT:

- `plugins/philosophy/shared/core-principles.md` — the floor inherited by every Identity; Voice does NOT redefine these
- `plugins/philosophy/skills/identity/SKILL.md` — project-level persona; Voice does NOT redefine these either

If `docs/IDENTITY.md` exists in the current project, read it — Voice should be compatible with the project's Identity, not contradict it.

## Process

### If the output style does NOT exist — Create

#### Step 1 — Understand what "your voice" means

Ask the human:

- "What's your default language? Spanish, English, both? If both, what triggers switching?"
- "If Spanish — which register? Rioplatense voseo, Mexican, neutral LatAm?"
- "How formal should the tone be? Peer-to-peer, mentor-to-student, direct-and-terse?"
- "Give me 3 phrases you'd use in real life that the agent should adopt — and 3 you'd NEVER want it to use."
- "When you disagree with someone, how do you push back? Softly, directly, with humor, with data?"
- "Should the agent use emphasis (CAPS, bold) to make points, or stay flat?"
- "Any speech patterns you like — rhetorical questions, repetition, analogies?"

Record answers before drafting anything.

#### Step 2 — Pick a name

The name goes in the frontmatter and becomes the argument to `/output-style`.
Suggest something short, lowercase, and personal (e.g. `adrian`, `rodacato`,
`mentor`). Confirm with the human before writing.

#### Step 3 — Draft the output style

Write to `~/.claude/output-styles/<name>.md` with this shape:

```markdown
---
name: <name>
description: <one-line summary of the voice>
keep-coding-instructions: true
---

# <Name> Output Style

## Core Principle

<1–3 sentences on the mentor/tone thesis. Helpful first, challenging when it matters.>

## Personality

<Who the agent is when speaking — not what they know. Background flavor that shapes tone.>

## Language Rules

### <Language A> input → <register>

<Natural phrases, idioms, how to use them. Warn against sarcastic misuse.>

### <Language B> input → <register>

<Same structure.>

## Tone

<Direct? Warm? Pedagogical? When to use CAPS, when to use questions.>

## Behavior

1. <How to answer small questions>
2. <How to push back when the human is wrong>
3. <How to explain concepts>

## Speech Patterns

- <Rhetorical device>
- <Repetition or emphasis pattern>
- <Closing style>

## When Asking Questions

When you ask the user a question, STOP IMMEDIATELY after the question. DO NOT
continue with code, explanations, or actions until the user responds.
```

**Frontmatter rules:**
- `name` must match the filename (sans `.md`)
- `keep-coding-instructions: true` keeps Claude Code's base coding rules; set to `false` ONLY if you know you're replacing them
- `description` is what the human sees in `/output-style` picker — make it specific

**Content rules:**
- Voice rules, NOT technical rules. No "never mock databases", no "use conventional commits" — those belong in CLAUDE.md / Identity
- Language examples should be WARM, never sarcastic or mocking
- If you include CAPS for emphasis, say WHEN to use them — CAPS-on-everything reads as shouting

Show the full draft to the human. Iterate until approved.

#### Step 4 — Activate

```bash
# Activate for the current session
/output-style <name>

# Or set as default going forward
claude config set output-style <name>
```

Confirm with the human that the next response feels right. If not, iterate on
the style file — don't rewrite from scratch.

### If the output style already exists — Update

1. Locate it: `ls ~/.claude/output-styles/`
2. Read the current file end-to-end
3. Ask the human: "What feels off? Specific examples of recent agent responses that missed the mark help most."
4. Propose the diff to the human
5. Update with approved changes — **preserve the voice's established idioms**; if the human likes a phrase, don't rewrite it

## Consultation flow (how Voice is USED)

This skill PRODUCES the output style. Once written:

1. `/output-style <name>` activates it for the session
2. `claude config set output-style <name>` makes it the default
3. Claude Code loads the style at session start; every response filters through it
4. Voice layers with project CLAUDE.md and any active Identity — Voice is the outermost layer (how it speaks), Identity is inner (what it decides), Core Principles are the floor (what it never breaks)

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll just write it into CLAUDE.md — same thing" | Not the same. Voice is user-global; CLAUDE.md is project-scoped. Putting voice in CLAUDE.md means copying it into every project forever and not being able to switch it. |
| "Identity already covers tone — I don't need a separate Voice" | Identity is project-specific. Voice travels with YOU across projects. Same human working on a fintech and a game shouldn't need two voices. |
| "I'll mix technical rules into the Voice for convenience" | Output styles are for tone. Technical rules in an output style get ignored when the human switches styles — exactly when they matter most. Keep them in CLAUDE.md. |
| "CAPS everywhere for emphasis" | If everything is emphasized, nothing is. Reserve CAPS for 2–3 concepts per message max, and only when the human specifically asked for energetic tone. |
| "Sarcastic voice is fun" | Sarcasm from an agent lands as condescension 9 times out of 10. Warm-and-direct beats sarcastic every time. |
| "Output styles are a gimmick, the model speaks how it speaks" | Verifiably false — `/output-style` changes the system prompt. The model follows it. Ignoring the feature just means defaulting to generic. |

## Red Flags

- File is not at `~/.claude/output-styles/<name>.md` (wrong location — won't load)
- Frontmatter missing `name` or `name` doesn't match the filename
- `keep-coding-instructions` set to `false` without a deliberate reason discussed with the human
- Voice file contains technical rules ("use TypeScript strict mode", "prefer X over Y") — those belong in CLAUDE.md / Identity
- Language examples read as sarcastic, mocking, or condescending
- Voice duplicates `plugins/philosophy/shared/core-principles.md` — the floor is not the voice's job
- More than one language register mixed without trigger rules (when to switch?)
- CAPS or bold used in every paragraph — emphasis eroded to zero
- Voice file has no example sentences — reads like a job description, not a speaking style

## Verification

- [ ] File exists at `~/.claude/output-styles/<name>.md`
- [ ] Frontmatter has `name:`, `description:`, `keep-coding-instructions:` fields, and `name` matches the filename
- [ ] `/output-style` picker shows the new style and selecting it changes the next response's tone
- [ ] At least 3 example phrases are listed per language register, each warm (not sarcastic)
- [ ] Tone section names WHEN to use CAPS / emphasis, not just IF
- [ ] Voice contains NO technical rules, project constraints, or stack opinions (those live elsewhere)
- [ ] Voice does not restate `plugins/philosophy/shared/core-principles.md`
- [ ] Read aloud: voice sounds like a specific person you could recognize — not generic "helpful assistant"
- [ ] Human confirms after a test response that the voice feels right

## When done

Nothing to update in `.launchpad/manifest.yml` — this is a philosophy skill
and produces a user-level config, not a project artifact.

Next likely skills:
- `identity` — if you don't have a project Identity yet, Voice alone makes the agent sound consistent but it still won't have project opinions
- `experts` — after Identity, the advisory panel that fills the Identity's known gaps
