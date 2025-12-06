---
description: Explore and validate an idea before planning
argument-hint: <your idea or problem>
allowed-tools:
  - Read
  - Glob
  - Grep
  - WebSearch
  - AskUserQuestion
---

# Explore an Idea

Have a conversation about an idea before committing to building it. Discuss feasibility, approaches, trade-offs, and scope.

## Purpose

This is the "thinking out loud" phase:
- Is this idea feasible?
- What are the different ways to approach it?
- What's the MVP vs the full vision?
- What unknowns or risks exist?
- Should we even build this?

## Process

### 1. Understand the Idea

Ask the user to explain:
- What's the idea? What problem does it solve?
- Why now? What triggered this?
- Who benefits from this?
- What does success look like?

Listen actively. Ask follow-up questions. Don't jump to solutions yet.

### 2. Explore the Context

Based on the idea, investigate:
- **Codebase**: Does related functionality exist? What patterns are used?
- **External**: Are there libraries, APIs, or prior art we should know about?
- **Constraints**: Technical limitations, dependencies, platform requirements?

Share findings conversationally:
```
"I looked at your codebase and noticed you're already using X for similar things.
We could extend that, or go a different direction. What's your instinct?"
```

### 3. Discuss Approaches

Present 2-3 possible approaches:

```
I see a few ways we could tackle this:

**Approach A: Quick & Simple**
- Do X with minimal changes
- Pro: Fast to implement, low risk
- Con: Might not scale, limited flexibility

**Approach B: Proper Architecture**
- Build Y with abstraction layer
- Pro: Extensible, clean separation
- Con: More upfront work

**Approach C: Leverage Existing**
- Use library Z, integrate with current system
- Pro: Battle-tested, less code to maintain
- Con: Another dependency, learning curve

What resonates with you? Or is there another direction you're thinking?
```

### 4. Identify Unknowns & Risks

Be honest about what we don't know:
- Technical unknowns ("I'm not sure how X handles Y")
- Scope unknowns ("This could be small or huge depending on Z")
- Dependency risks ("If A doesn't work, we'd need to rethink")

Suggest spikes or investigations if needed:
```
"Before committing, might be worth spiking on the API integration
to see if it actually supports what we need. Want to do that first?"
```

### 5. Scope the MVP

If the idea seems viable, help define the smallest useful version:
- What's the core value?
- What can we defer?
- What's the "good enough" first version?

```
"Sounds like the core is really just X and Y.
The Z part is nice-to-have but we could add it later.
Does that feel right for a first pass?"
```

### 6. Decision Point

End with a clear decision:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  IDEA: <summary>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Feasibility: <High / Medium / Needs Investigation>
  Approach: <recommended approach>
  MVP Scope: <brief description>

  Unknowns:
    - <unknown 1>
    - <unknown 2>

  What's next?
  [Plan it] → /backlog:plan to break into stories
  [Spike first] → Investigate unknowns before committing
  [Park it] → Save idea for later
  [Drop it] → Not worth pursuing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 7. Transition

**If "Plan it":**
- Transition to `/backlog:plan` with context from discussion

**If "Spike first":**
- Create a spike story: `/backlog:add "Spike: <investigation>" --effort r3`
- Note what we're trying to learn

**If "Park it":**
- Save to a `parked-ideas.md` or similar for later

**If "Drop it":**
- Acknowledge and move on. Not every idea should be built.

## Conversation Style

This should feel like talking to a thoughtful colleague:
- Ask questions, don't lecture
- Share observations, not mandates
- Be honest about uncertainty
- Validate good instincts
- Push back respectfully on risky assumptions
- Keep it conversational, not formal

## Examples

```
/backlog:idea I want to add multiplayer to my game
/backlog:idea What if we cached API responses locally
/backlog:idea I'm thinking about rewriting the auth system
/backlog:idea Users keep asking for dark mode
```

## Notes

- This is exploratory - no commitment to build anything
- It's okay to conclude "let's not do this"
- Can lead to `/backlog:plan` if idea is validated
- Good for bigger ideas where jumping straight to planning feels premature
