# Module: branding

## What this installs

`docs/BRANDING.md` — Brand, voice, and visual identity. Name, tagline, personality,
color palette, typography, logo concept, microcopy. This is how the project looks,
sounds, and feels across every touchpoint.

## Before you start

Search for these files by name:
- `VISION.md` — philosophy and "what this is NOT" directly inform the brand
- `IDENTITY.md` — the Build Identity's communication style sets the technical tone

Use: `find . -name "VISION.md" -not -path "*/.git/*"`

---

## If BRANDING.md does NOT exist — Create

This is a creative exploration. The goal is a brand that feels REAL —
not a corporate identity manual, but a personality.

### Step 1 — The Name
If the project has a name, explore WHY it works:
- "What does the name communicate? What associations does it carry?"
- "Does it work internationally? Easy to pronounce and remember?"
- "What's the domain? Does the domain add meaning?"

If the name isn't decided:
- "What feeling should the name evoke?"
- Propose 3-5 options with reasoning. Let the human choose.

Also define: tagline, brand descriptor, elevator pitch.

### Step 2 — Brand personality
Ask:
- "If the project were a person at a party, how would they talk?"
- "What brands do you admire the aesthetic of? (doesn't have to be tech)"
- "What tone should the UI have? Serious? Playful? Irreverent? Minimal?"
- "What should the product NEVER sound like?"

Define: archetype, traits (5-6 adjectives with meaning), voice do's/don'ts,
anti-patterns.

### Step 3 — Visual direction
Ask:
- "Dark mode, light mode, or both?"
- "What products do you like the look of? (Linear, Raycast, Notion, Stripe?)"
- "What aesthetic: minimal? bold? terminal-like? playful? geometric?"

Define the full palette, typography, spacing, and visual style.
Use design tokens — never hardcode hex values.

### Step 4 — Logo concept
Ask:
- "Do you have a logo concept or should we explore?"
- "Icon-based, wordmark, or combination?"
Propose 2-3 concepts with reasoning.

### Step 5 — Microcopy
Write example microcopy for: empty states, errors, loading, success, onboarding, CTAs.
This is where the brand personality comes alive in the product.

### Step 6 — Image generation prompts
Write 3-6 prompts for visual exploration (Google Stitch, Midjourney, OpenAI).

Use the template at `modules/branding/template.md` as structure.
The test: does this feel like a REAL product, not a template?

---

## If BRANDING.md already exists — Update

1. Find the file: `find . -name "BRANDING.md" -not -path "*/.git/*"`
2. Read the current content
3. Check the template for new sections:
   `https://raw.githubusercontent.com/rodacato/launchpad/master/modules/branding/template.md`
4. Identify: missing sections, stale design tokens, or areas to improve
5. Update with approved changes, preserving established brand decisions

---

## When done

Update `.launchpad/manifest.yml`:
- Add `branding: "1.0"` under `modules:`

Then delete `LAUNCHPAD_TASK.md`.
