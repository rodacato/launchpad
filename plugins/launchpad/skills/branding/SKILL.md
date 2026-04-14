---
name: branding
description: Create or update docs/BRANDING.md — name, tagline, voice, color palette, typography, logo concept, microcopy. Use when a project needs a brand identity beyond "it works". Use when the UI copy feels inconsistent or generic. Use when the project is about to go public and has no visual direction. Use when onboarding a designer who asks "what's the brand?".
metadata:
  version: "1.1"
  author: rodacato
  category: bootstrap
  triggers:
    - branding
    - "BRANDING.md"
    - "brand identity"
    - "color palette"
    - tagline
    - voice
    - microcopy
    - logo
    - typography
---

# Branding

## Overview

Create or update `docs/BRANDING.md` — the brand, voice, and visual identity document. Name, tagline, personality, color palette, typography, logo concept, and microcopy all live here. A brand without an explicit personality defaults to "generic SaaS" — your job is to prevent that.

The test: when someone reads this, can they write a new error message in the project's voice without asking? If not, the brand isn't done.

## When to Use

- Project has code but no defined look or voice — every new screen feels different
- UI copy is inconsistent — errors sound corporate, empty states sound playful, onboarding sounds robotic
- Preparing for public launch, a landing page, or external users
- A designer or agent needs to generate assets and has no reference to anchor them
- BRANDING.md exists but was written as a checklist, not a personality

**When NOT to use:**
- Pre-vision — you cannot brand something you haven't defined. Run `vision` first
- Internal tooling that will never have users beyond the author
- Early prototypes where the product identity is still in flux — wait until the core is stable

## Before you start

Search for these files by name:
- `VISION.md` — philosophy and "what this is NOT" directly inform the brand
- `IDENTITY.md` — the Build Identity's communication style sets the technical tone

Use: `fd VISION.md --exclude .git` (or `find . -name "VISION.md" -not -path "*/.git/*"`)

If VISION.md is missing, stop and run the `vision` skill first. Branding without vision produces aesthetics without meaning.

## Process

### If BRANDING.md does NOT exist — Create

This is a creative exploration. The goal is a brand that feels REAL — not a corporate
identity manual, but a personality.

#### Step 1 — The Name
If the project has a name, explore WHY it works:
- "What does the name communicate? What associations does it carry?"
- "Does it work internationally? Easy to pronounce and remember?"

If the name isn't decided:
- "What feeling should the name evoke?"
- Propose 3-5 options with reasoning. Let the human choose.

Also define: tagline, brand descriptor, elevator pitch.

#### Step 2 — Brand personality
Ask:
- "If the project were a person at a party, how would they talk?"
- "What brands do you admire the aesthetic of? (doesn't have to be tech)"
- "What tone should the UI have? Serious? Playful? Irreverent? Minimal?"
- "What should the product NEVER sound like?"

Define: archetype, traits (5-6 adjectives with meaning), voice do's/don'ts, anti-patterns.

#### Step 3 — Visual direction
Ask:
- "Dark mode, light mode, or both?"
- "What products do you like the look of? (Linear, Raycast, Notion, Stripe?)"
- "What aesthetic: minimal? bold? terminal-like? playful? geometric?"

Define the full palette, typography, spacing, and visual style using design tokens.

#### Step 4 — Logo concept
Ask:
- "Do you have a logo concept or should we explore?"
- "Icon-based, wordmark, or combination?"
Propose 2-3 concepts with reasoning.

#### Step 5 — Microcopy
Write example microcopy for: empty states, errors, loading, success, onboarding, CTAs.
This is where the brand personality comes alive in the product.

#### Step 6 — Image generation prompts
Write 3-6 prompts for visual exploration (Google Stitch, Midjourney, OpenAI).

Use the template at `skills/branding/template.md` as structure.
The test: does this feel like a REAL product, not a template?

### If BRANDING.md already exists — Update

1. Find the file: `fd BRANDING.md --exclude .git` (or `find . -name "BRANDING.md" -not -path "*/.git/*"`)
2. Read the current content
3. Read the template at `skills/branding/template.md` for new sections
4. Update with approved changes, preserving established brand decisions

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "We're engineers, brand is a design concern" | Every error message, every CTA, every empty state IS the brand. Ship code without a brand and you ship a brand by accident. |
| "Let's just pick a blue and move on" | A palette without reasoning becomes a palette everyone overrides. Define the WHY and the palette survives. |
| "Voice is just 'be friendly'" | 'Friendly' is generic. The voice is defined by what the product refuses to sound like. Without anti-patterns, every tone is acceptable. |
| "Microcopy can come later" | Microcopy is where the brand lives. Without written examples, each dev invents their own voice and the product reads like three products. |
| "The vision already covers this" | Vision covers WHY; brand covers HOW it sounds and looks. A designer cannot ship a button from the vision alone. |

## Red Flags

- Palette has colors but no semantic tokens (no `--color-danger`, just `#FF4444`)
- Voice section lists only DO's, no DON'Ts or anti-patterns
- Microcopy section is missing or has fewer than 4 example states
- "Brand personality" reads like a brand manual template — archetype named but no concrete traits
- Tagline is a feature list ("fast, secure, easy") instead of a stance
- Typography defined as "system font" with no scale or weight reasoning
- No image-generation prompts — asset exploration has no starting point

## Verification

- [ ] `docs/BRANDING.md` exists at the project root
- [ ] Name section explains WHY the name works (or shows 3-5 candidates with reasoning)
- [ ] Tagline, brand descriptor, and elevator pitch are all present and distinct
- [ ] Personality section lists 5-6 traits with one-line meanings AND voice DON'Ts
- [ ] Palette has semantic tokens (danger, success, etc.) with hex + usage notes
- [ ] Typography defines scale (at least 4 sizes) and weight usage
- [ ] Microcopy section covers at least: empty state, error, success, loading, CTA
- [ ] 3-6 image-generation prompts included for logo/visual exploration
- [ ] `.launchpad/manifest.yml` updated with `branding: "1.1"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `branding: "1.1"` under `modules:`.

Next likely skills:
- `workflow` — define a "brand review" step in the definition of done
- `architecture` — if the brand implies UI primitives or a design system, architecture captures where they live
