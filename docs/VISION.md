# Vision

> This document is the project's compass. Every feature decision, every scope debate,
> every "should we build this?" question gets filtered through what's written here.
> If it's not aligned with the vision, it doesn't get built.
>
> The agent will help you explore and articulate this through conversation.

---

<!-- AGENT INSTRUCTIONS — How to fill this document

This is the MOST IMPORTANT doc in the project. Do not rush it.
This is an exploration — a conversation where the human discovers and articulates
what they're building and why. Your job is to ask the RIGHT questions, not fill blanks.

STEP 1 — The Problem
  Start here. Everything else flows from this.
  Ask the human:
  - "What frustrates you about the way things work today?"
  - "What's the gap you keep running into that nothing solves well?"
  - "Is this a problem you personally feel, or one you've observed in others?"
  - "How are people currently dealing with this? What's broken about those solutions?"

  Dig deeper:
  - If the answer is vague, ask for a specific scenario or moment
  - If it's too broad, ask "who feels this most acutely?"
  - If they mention competitors, ask "what do they get RIGHT, and where do they fall short?"

  The problem should feel REAL and SPECIFIC when written. Not a market analysis —
  a lived frustration that makes someone nod and say "yeah, exactly."

STEP 2 — The Insight
  This is the non-obvious observation that makes the project worth building.
  Ask:
  - "What do you see about this problem that others might be missing?"
  - "Is there an existing tool that gets 80% right? What's the missing 20%?"
  - "What would change if this existed and worked well?"

STEP 3 — The Philosophy
  This is the soul of the project. The principles that guide EVERY decision.
  Ask:
  - "When two features conflict, how do you decide which one wins?"
  - "What would you NEVER compromise on, even under pressure?"
  - "What's the tone? Is this playful? Serious? Opinionated? Neutral?"
  - "If someone described your project's personality, what would they say?"

  Good philosophies are OPINIONATED. "We value quality" is useless.
  "Process over correctness" or "Self-host first" — that's a philosophy.

STEP 4 — Who It's For
  Be honest and specific. "Everyone" is nobody.
  Ask:
  - "Who is the first person who will use this besides you?"
  - "What are they doing RIGHT NOW to solve this problem?"
  - "What would make them switch to your project?"
  - "Who is this explicitly NOT for?"

STEP 5 — What Success Looks Like
  Not vanity metrics. Real, honest success.
  Ask:
  - "If this project succeeds beyond your expectations, what does that look like?"
  - "What's the minimum outcome that would make the effort worth it?"
  - "Is this about users? Revenue? Personal learning? A combination?"

STEP 6 — What This Is NOT
  Equally important as what it IS. This section prevents scope creep forever.
  Ask:
  - "What will people assume this does that it shouldn't?"
  - "What adjacent problems are you explicitly choosing NOT to solve?"
  - "What features sound cool but would dilute the core purpose?"

STEP 7 — The Litmus Test
  Distill everything above into 3-5 yes/no questions that filter every future decision.
  Propose them based on the conversation, then refine with the human.

STEP 8 — Draft and iterate
  Write the full vision, show it to the human, and refine.
  The voice should match the project's personality — not corporate, not generic.
  Read it back: does it make you FEEL something? If not, it's not done.

-->

## The Pitch

<!-- One paragraph that captures the project in conversational language.
     This is how you'd explain it to a developer friend over coffee.
     If it takes more than 30 seconds to say, it's too long. -->

---

## The Problem

<!-- What pain point or gap does this project address?
     Be specific. Name the frustration. Describe the scenario.
     The reader should recognize themselves in this section.
     This is NOT a market analysis — it's a lived experience. -->

---

## The Insight

<!-- What non-obvious observation makes this project worth building?
     What do you see that others are missing?
     This is the "aha" that separates this from another todo app. -->

---

## The Philosophy

<!-- The principles that guide EVERY decision in this project.
     These should be OPINIONATED — if nobody would disagree, it's not a principle.
     3-5 principles, each with a brief explanation of what it means in practice. -->

---

## Who It's For

<!-- Be specific and honest. Define the audience in concentric circles:
     1. First user (probably you — dogfooding)
     2. Inner circle (the first people you'd invite)
     3. Broader audience (if it grows)

     Also define who this is NOT for. -->

---

## What Success Looks Like

<!-- Not a metrics dashboard. An honest picture of the outcome you want.
     What would make the effort worth it?
     What's the behavioral change you want to see in your users (or yourself)? -->

---

## What This Is NOT

<!-- The anti-scope. Equally important as the vision itself.
     Things people will ASSUME this does that it shouldn't.
     Adjacent problems you're explicitly choosing not to solve.
     Features that sound cool but would dilute the core. -->

---

## Architecture Principles

<!-- 3-5 technical principles derived from the philosophy above.
     These translate the vision into engineering constraints.
     e.g. "Self-host first: every feature must work with docker compose up"
     e.g. "Three entry points, one data model: editor, API, and MCP all use the same schema" -->

---

## The Litmus Test

<!-- 3-5 yes/no questions to ask before building ANY new feature.
     If a feature fails any of these, it doesn't get built.
     These are distilled from everything above. -->

Before adding any new feature, ask:

1. <!-- e.g. Does it help solve [core problem]? If no, it's out of scope. -->
2. <!-- e.g. Does it work within [core constraint]? If not, simplify or skip. -->
3. <!-- e.g. Does it respect [philosophy principle]? -->
4. <!-- e.g. Would I use this myself? -->
5. <!-- e.g. Can a new user benefit from this without configuration? -->

---

## Execution Strategy

<!-- High-level phases. NOT a detailed roadmap (that's docs/ROADMAP.md).
     This is the strategic arc — what order do things happen and why.
     Each phase should have a clear "this is done when..." statement. -->

---

## Future Ideas

<!-- Ideas that passed the litmus test but don't have a timeline.
     And ideas that are interesting but belong to a different product.
     Being explicit about both prevents scope creep and preserves good ideas. -->

### Ideas that belong here (someday)

| Idea | What it is | Builds on |
|---|---|---|
| <!-- idea --> | <!-- description --> | <!-- dependency --> |

### Ideas that belong somewhere else

| Idea | Why not this project |
|---|---|
| <!-- idea --> | <!-- reason --> |
