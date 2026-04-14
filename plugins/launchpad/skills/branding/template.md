# Branding, Voice & Visual Identity

> Defines how the project looks, sounds, and feels.
> Style guide for UI, marketing, microcopy, and social presence.

---

## The Name

**Name:** <!-- project name -->

<!-- WHY this name works: etymology, associations, cultural fit. -->

**Domain:** <!-- e.g. project.example.dev -->

**Tagline:** <!-- One line, max 10 words. The hook. -->

**Brand descriptor:** <!-- Used as subtitle beneath the logo. -->

**Elevator pitch:** <!-- 2-3 sentences. Keep in sync with docs/VISION.md "The Pitch". -->

**Naming alternatives considered:**
<!-- What was explored and why this one won. -->

---

## Brand Personality

### Archetype

<!-- One phrase: e.g. "The Indie Builder", "The Quiet Craftsman" -->

### Traits

| Trait | What it means in practice |
|-------|--------------------------|
| <!-- e.g. Direct --> | <!-- e.g. No filler, no corporate speak --> |
| <!-- e.g. Opinionated --> | <!-- e.g. Has a point of view, not afraid to say "no" --> |
| <!-- e.g. Technical --> | <!-- e.g. Assumes the user knows what they're doing --> |

### Tone of Voice

**One sentence:** <!-- e.g. "Direct. Honest. Smart." -->

**Do:**
- <!-- e.g. Write like you're talking to a peer, not a customer -->
- <!-- e.g. Be technically accurate -->

**Don't:**
- <!-- e.g. No enterprise buzzwords ("leverage", "synergy") -->
- <!-- e.g. No fake enthusiasm ("Amazing! You did it!") -->

**Examples:**

| Instead of... | Write... |
|---------------|----------|
| <!-- corporate --> | <!-- brand version --> |

### Anti-patterns

- <!-- e.g. Never use motivational poster energy -->
- <!-- e.g. Never apologize for being opinionated -->

---

## Visual Identity

### Color Palette

#### Core

| Role | Hex | Usage |
|------|-----|-------|
| Background base | <!-- #0F172A --> | <!-- page background --> |
| Surface | <!-- #1E293B --> | <!-- cards, panels --> |
| Surface elevated | <!-- #253347 --> | <!-- hover states, dropdowns --> |
| Border | <!-- #334155 --> | <!-- all borders and dividers --> |
| Accent primary | <!-- #6366F1 --> | <!-- CTAs, active elements --> |
| Accent secondary | <!-- #10B981 --> | <!-- success, positive states --> |

#### Semantic States

| State | Hex | Usage |
|-------|-----|-------|
| Success | <!-- #10B981 --> | <!-- confirmations --> |
| Warning | <!-- #F59E0B --> | <!-- caution --> |
| Error | <!-- #EF4444 --> | <!-- errors --> |
| Info | <!-- #3B87F6 --> | <!-- tips --> |

#### Text

| Role | Hex | Usage |
|------|-----|-------|
| Primary | <!-- #F8FAFC --> | <!-- main content --> |
| Secondary | <!-- #94A3B8 --> | <!-- descriptions, labels --> |
| Muted | <!-- #475569 --> | <!-- placeholders, disabled --> |

### Design Tokens

```css
/* Surfaces */
--color-bg-base:          /* value */;
--color-bg-surface:       /* value */;
--color-bg-elevated:      /* value */;
--color-border:           /* value */;

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

| Role | Font | Why |
|------|------|-----|
| Headings | <!-- e.g. Sora --> | <!-- e.g. Geometric, digital-first --> |
| Body/UI | <!-- e.g. Inter --> | <!-- e.g. Highly legible --> |
| Code/Mono | <!-- e.g. JetBrains Mono --> | <!-- e.g. Technical clarity --> |

```css
--text-xs:   /* value */;   /* labels, timestamps */
--text-sm:   /* value */;   /* secondary content */
--text-base: /* value */;   /* body, UI text */
--text-lg:   /* value */;   /* section headers */
--text-xl:   /* value */;   /* page titles */
--text-2xl:  /* value */;   /* hero numbers */
```

### Spacing & Grid

**Base unit:** <!-- e.g. 4px -->

| Token | Value | Usage |
|---|---|---|
| `space-1` | <!-- 4px --> | <!-- tight padding --> |
| `space-2` | <!-- 8px --> | <!-- inline spacing --> |
| `space-4` | <!-- 16px --> | <!-- card padding --> |
| `space-6` | <!-- 24px --> | <!-- section gaps --> |
| `space-8` | <!-- 32px --> | <!-- large gaps --> |

**Border radius:** <!-- e.g. 4px interactive, 6px cards -->

### Visual Style

<!-- 2-3 sentences describing the aesthetic direction.
     Reference products with the right feel.
     Then list specific characteristics. -->

**Characteristics:**
- <!-- e.g. Subtle borders, small border-radius -->
- <!-- e.g. Depth through color, not drop-shadows -->
- <!-- e.g. Functional animations: 150-200ms -->
- <!-- e.g. Dark mode only -->

---

## Logo

### Concept

<!-- Describe the logo concept with reasoning. -->

### Variants

| Variant | Usage |
|---------|-------|
| Primary (horizontal) | Landing page, app header |
| Icon only | Favicon, app icon, GitHub avatar |
| Monochrome | Contexts where color isn't available |

### Assets location

```
docs/branding/
├── logo.svg
├── logo-dark.svg
├── icon.png          (512x512)
├── favicon.png       (32x32)
└── og-image.png      (1200x630)
```

### Usage rules

- <!-- e.g. Never rotate, skew, or add shadows -->
- <!-- e.g. Never change colors outside the defined palette -->

---

## Microcopy & UX Voice

| Moment | Copy |
|--------|------|
| Empty state | <!-- "Nothing here yet." --> |
| Loading | <!-- "Working on it..." --> |
| Success | <!-- "Done." --> |
| Error | <!-- "That didn't work. Here's why:" --> |
| First use | <!-- "Welcome. Let's set this up." --> |
| CTA (primary) | <!-- "Get started" --> |
| Destructive action | <!-- "Delete permanently — this can't be undone" --> |

---

## Image Generation Prompts

### Prompt 1 — <!-- Screen name -->

```
<!-- Detailed prompt with specific colors, layout, typography, aesthetic references. -->
```

### Prompt 2 — <!-- Screen name -->

```
<!-- prompt -->
```

---

## Implementation Reference

```css
:root {
  /* Paste final design tokens here once approved */
}
```

---

## Showroom Integration

| .notdefined.yml field | Source |
|-----------------------|--------|
| `description` | Elevator pitch (above) |
| `icon` | `docs/branding/icon.png` |
| `og_image` | `docs/branding/og-image.png` |
| `color` | Accent primary color |
