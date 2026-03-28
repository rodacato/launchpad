# Branding, Voice & Visual Identity

> This document defines how the project looks, sounds, and feels.
> It's the style guide for everything from UI to marketing to microcopy.
> The agent will help you build this through conversation.

---

<!-- AGENT INSTRUCTIONS — How to fill this document

This is a creative exploration. The goal is to define a brand that feels REAL —
not a corporate identity manual, but a personality that's consistent across
every touchpoint (UI, README, share cards, social posts, microcopy).

PREREQUISITES: Read these first if they exist:
  - docs/VISION.md — the philosophy and "what this is NOT" directly inform the brand
  - docs/IDENTITY.md — the Build Identity's communication style sets the technical tone

STEP 1 — The Name
  If the project already has a name, explore WHY it works:
  - "What does the name communicate? What associations does it carry?"
  - "Does it work internationally? Is it easy to pronounce and remember?"
  - "What's the domain? Does the domain add meaning?"

  If the name isn't decided:
  - "What feeling should the name evoke?"
  - "What names have you considered? What did you like/dislike about each?"
  - Propose 3-5 options with reasoning. Let the human choose.

  Also define: tagline, brand descriptor, and elevator pitch.

STEP 2 — Brand Personality
  This shapes EVERYTHING else. Ask:
  - "If the project were a person at a party, how would they talk?"
  - "What brands do you admire the aesthetic of? (doesn't have to be tech)"
  - "What tone should the UI have? Serious? Playful? Irreverent? Minimal?"
  - "What should the product NEVER sound like?"

  Define:
  - Archetype (e.g. "The Indie Builder", "The Strict Mentor", "The Quiet Craftsman")
  - Traits (5-6 adjectives with what they mean in practice)
  - Voice do's and don'ts with concrete examples
  - Anti-patterns (what the brand should NEVER do)

STEP 3 — Visual Direction
  Ask:
  - "Dark mode, light mode, or both?"
  - "What products do you like the look of? (e.g. Linear, Raycast, Notion, Stripe)"
  - "What aesthetic: minimal? bold? terminal-like? playful? geometric?"
  - "Any color preferences or colors to avoid?"

  Define the full palette, typography, spacing, and visual style.
  Use design tokens — never hardcode hex values in components.

STEP 4 — Logo Concept
  Ask:
  - "Do you have a logo concept or should we explore?"
  - "Icon-based, wordmark, or combination?"
  - "What should the logo communicate at a glance?"

  Propose 2-3 concepts with reasoning. Define usage guidelines.

STEP 5 — UX Voice (Microcopy)
  Based on the brand personality, write example microcopy for common moments:
  - Empty states, errors, loading, success, onboarding, CTAs
  - This is where the brand personality comes alive in the product

STEP 6 — Image Generation Prompts
  Write 3-6 prompts for Google Stitch, Midjourney, or OpenAI image generation
  to explore the visual direction. These are for REFERENCE mockups, not final specs.
  Include: specific colors, fonts, layout descriptions, aesthetic references.

STEP 7 — Draft and iterate
  Show the full brand guide to the human. Refine until it feels right.
  The test: does this feel like a REAL product, not a template?

-->

## The Name

**Name:** <!-- project name -->

<!-- WHY this name works: etymology, associations, cultural fit.
     A good name has layers — explain them. -->

**Domain:** <!-- e.g. project.notdefined.dev -->

<!-- Does the domain add meaning beyond the name? -->

**Tagline:** <!-- One line, max 10 words. The hook. -->

**Brand descriptor:** <!-- Used as subtitle beneath the logo.
     e.g. "Diagrams & Whiteboards. Self-Hosted." -->

**Elevator pitch:** <!-- 2-3 sentences. How you'd explain it to a dev friend.
     Same as docs/VISION.md "The Pitch" — keep them in sync. -->

**Naming alternatives considered:**
<!-- What other names were explored and why this one won. -->

---

## Brand Personality

### Archetype

<!-- One phrase that captures the brand's character.
     e.g. "The Indie Builder", "The Strict Mentor", "The Quiet Craftsman" -->

### Traits

| Trait | What it means in practice |
|-------|--------------------------|
| <!-- e.g. Direct --> | <!-- e.g. No filler, no corporate speak --> |
| <!-- e.g. Opinionated --> | <!-- e.g. Has a point of view, not afraid to say "no" --> |
| <!-- e.g. Technical --> | <!-- e.g. Assumes the user knows what they're doing --> |
| <!-- e.g. Honest --> | <!-- e.g. Tells you when you failed, with specifics --> |
| <!-- e.g. Indie --> | <!-- e.g. Self-hosted, no VC energy, built for builders --> |

### Tone of Voice

**One sentence:** <!-- e.g. "Direct. Honest. Smart." or "Brutally honest but with humor." -->

**Do:**
- <!-- e.g. Write like you're talking to a peer, not a customer -->
- <!-- e.g. Be technically accurate -->
- <!-- e.g. Use humor when it's natural, not forced -->

**Don't:**
- <!-- e.g. No enterprise buzzwords ("leverage", "synergy") -->
- <!-- e.g. No filler ("we're excited to announce") -->
- <!-- e.g. No fake enthusiasm ("Amazing! You did it!") -->

**Examples:**

| Instead of... | Write... |
|---------------|----------|
| <!-- corporate version --> | <!-- brand version --> |
| <!-- corporate version --> | <!-- brand version --> |
| <!-- corporate version --> | <!-- brand version --> |

### Anti-patterns

<!-- Things the brand should NEVER do. Be specific. -->

- <!-- e.g. Never use motivational poster energy -->
- <!-- e.g. Never apologize for being opinionated -->
- <!-- e.g. Never sound like a startup pitch deck -->

---

## Visual Identity

### Color Palette

<!-- Define the full palette with roles. Use semantic names, not just colors.
     Every color needs a PURPOSE — why is it in the palette? -->

#### Core

| Role | Hex | Usage |
|------|-----|-------|
| Background base | <!-- e.g. #0F172A --> | <!-- page background --> |
| Surface | <!-- e.g. #1E293B --> | <!-- cards, panels, editors --> |
| Surface elevated | <!-- e.g. #253347 --> | <!-- hover states, dropdowns --> |
| Border | <!-- e.g. #334155 --> | <!-- all borders and dividers --> |
| Accent primary | <!-- e.g. #6366F1 --> | <!-- CTAs, active elements, focus rings --> |
| Accent secondary | <!-- e.g. #10B981 --> | <!-- success, positive states --> |

#### Semantic States

| State | Hex | Usage |
|-------|-----|-------|
| Success | <!-- e.g. #10B981 --> | <!-- confirmations, positive outcomes --> |
| Warning | <!-- e.g. #F59E0B --> | <!-- caution, approaching limits --> |
| Error | <!-- e.g. #EF4444 --> | <!-- errors, destructive actions --> |
| Info | <!-- e.g. #3B87F6 --> | <!-- tips, informational messages --> |

#### Text

| Role | Hex | Usage |
|------|-----|-------|
| Primary | <!-- e.g. #F8FAFC --> | <!-- main content --> |
| Secondary | <!-- e.g. #94A3B8 --> | <!-- descriptions, labels --> |
| Muted | <!-- e.g. #475569 --> | <!-- placeholders, disabled --> |

### Design Tokens

<!-- Canonical token names for CSS/Tailwind. ALWAYS reference tokens, never raw hex. -->

```css
/* Surfaces */
--color-bg-base:        /* value */;
--color-bg-surface:     /* value */;
--color-bg-elevated:    /* value */;
--color-border:         /* value */;

/* Accent */
--color-accent-primary:   /* value */;
--color-accent-secondary: /* value */;

/* Semantic */
--color-success:   /* value */;
--color-warning:   /* value */;
--color-error:     /* value */;
--color-info:      /* value */;

/* Text */
--color-text-primary:     /* value */;
--color-text-secondary:   /* value */;
--color-text-muted:       /* value */;
```

### Typography

<!-- Define font roles, not just font names. Each role needs a WHY. -->

| Role | Font | Why |
|------|------|-----|
| Headings | <!-- e.g. Sora, JetBrains Mono --> | <!-- e.g. Geometric, digital-first --> |
| Body/UI | <!-- e.g. Inter --> | <!-- e.g. Highly legible, screen-optimized --> |
| Code/Mono | <!-- e.g. JetBrains Mono --> | <!-- e.g. Consistent with heading, technical --> |

**Font sources:** <!-- e.g. Google Fonts (free, open-source) -->

**Type scale:**

```css
--text-xs:   /* value */;   /* labels, badges, timestamps */
--text-sm:   /* value */;   /* secondary content */
--text-base: /* value */;   /* body, UI text */
--text-lg:   /* value */;   /* section headers */
--text-xl:   /* value */;   /* page titles */
--text-2xl:  /* value */;   /* hero numbers, dashboard */
```

### Spacing & Grid

<!-- Base unit and scale. All spacing should be a multiple of the base. -->

**Base unit:** <!-- e.g. 4px -->

| Token | Value | Usage |
|---|---|---|
| `space-1` | <!-- e.g. 4px --> | <!-- tight padding, icon gaps --> |
| `space-2` | <!-- e.g. 8px --> | <!-- inline spacing --> |
| `space-4` | <!-- e.g. 16px --> | <!-- card padding, section gaps --> |
| `space-6` | <!-- e.g. 24px --> | <!-- section separation --> |
| `space-8` | <!-- e.g. 32px --> | <!-- large gaps --> |

**Border radius:** <!-- e.g. 4px for interactive, 6px for cards. No rounded-full. -->

### Visual Style

<!-- The overall aesthetic direction in 2-3 sentences.
     Reference products that have the right feel.
     Then list specific characteristics. -->

<!-- e.g. "Dark mode only. Terminal meets product — like Linear or Raycast
     but with more personality. Not a consumer app, not a corporate tool." -->

**Characteristics:**
- <!-- e.g. Subtle borders, small border-radius (4-6px) -->
- <!-- e.g. Depth through color, not drop-shadows -->
- <!-- e.g. Functional animations: 150-200ms transitions, no bouncing -->
- <!-- e.g. Dark mode default and only option -->

---

## Logo

### Concept

<!-- Describe the logo concept with reasoning. Why this approach?
     Include 1-2 primary concepts and what they communicate. -->

### Variants

<!-- Define what logo variants are needed and where each is used. -->

| Variant | Usage |
|---------|-------|
| Primary (horizontal) | Landing page, app header |
| Icon only | Favicon, app icon, GitHub avatar |
| Monochrome | Contexts where color isn't available |
| Wordmark only | Documentation, plain text contexts |

### Assets location

```
docs/branding/
├── logo.svg              # Primary logo
├── logo-dark.svg         # Inverted for light backgrounds (if applicable)
├── icon.png              # App icon / favicon source (512x512)
├── favicon.png           # 32x32 favicon
├── og-image.png          # Social media preview (1200x630)
└── palette.md            # Quick-reference color palette
```

### Usage rules

- <!-- e.g. Minimum clear space: height of the logomark -->
- <!-- e.g. Never rotate, skew, or add shadows -->
- <!-- e.g. Never change colors outside the defined palette -->

---

## Microcopy & UX Voice

<!-- This is where the brand personality comes alive in the product.
     Write examples for key moments. The voice should be consistent
     with the Brand Personality section above. -->

| Moment | Copy |
|--------|------|
| Empty state | <!-- e.g. "Nothing here yet." --> |
| Loading | <!-- e.g. "Working on it..." --> |
| Success | <!-- e.g. "Done." --> |
| Error | <!-- e.g. "That didn't work. Here's why:" --> |
| First use | <!-- e.g. "Welcome. Let's set this up." --> |
| CTA (primary) | <!-- e.g. "Get started" --> |
| Destructive action | <!-- e.g. "Delete permanently — this can't be undone" --> |
| Login | <!-- e.g. "Sign in" --> |
| Logout | <!-- e.g. "Sign out" --> |

---

## Image Generation Prompts

<!-- Prompts for Google Stitch, Midjourney, OpenAI, or similar tools.
     These generate REFERENCE mockups to explore the visual direction.
     They are not implementation specs — the design tokens above are the source of truth.
     Include specific colors, fonts, layout, and aesthetic references. -->

### Prompt 1 — <!-- Screen/View name -->

```
<!-- Detailed prompt with specific colors, layout, typography,
     aesthetic references, and what the screen should communicate. -->
```

### Prompt 2 — <!-- Screen/View name -->

```
<!-- prompt -->
```

### Prompt 3 — <!-- Screen/View name -->

```
<!-- prompt -->
```

<!-- Add more prompts as needed. Cover the key screens:
     landing/hero, main dashboard, primary feature view, mobile, share/social. -->

---

## Implementation Reference

<!-- Ready-to-copy config for the dev environment. -->

### CSS Custom Properties

```css
:root {
  /* Paste final design tokens here once approved */
}
```

### Tailwind Config (if applicable)

```js
// Paste Tailwind theme extension here once approved
```

---

## Showroom Integration

<!-- These values feed into .notdefined.yml for the rodacato showroom. -->

| .notdefined.yml field | Source |
|-----------------------|--------|
| `description` | Elevator pitch (above) |
| `icon` | `docs/branding/icon.png` |
| `og_image` | `docs/branding/og-image.png` |
| `color` | Accent primary color |
