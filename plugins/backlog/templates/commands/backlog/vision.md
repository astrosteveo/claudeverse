---
description: Capture and evolve your project vision collaboratively
argument-hint: [view | set | refine]
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - WebSearch
  - AskUserQuestion
---

# Project Vision

Capture, view, and evolve your project's big-picture vision. For projects where you don't know everything upfront and want to discover it collaboratively over time.

## Modes

- `/backlog:vision` - View current vision
- `/backlog:vision set` - Set or replace the vision
- `/backlog:vision refine` - Evolve the vision based on new learnings

## The Vision Document

Stored in `.claude/vision.md` - a living document that grows with the project.

```markdown
# Project Vision: <project-name>

## The Dream
<What are we ultimately trying to create? Paint the picture.>

## Why It Matters
<What problem does this solve? Who cares?>

## Core Principles
<Non-negotiable values that guide decisions>
- <principle 1>
- <principle 2>

## Key Features (Discovered So Far)
<Features we've identified - not exhaustive, grows over time>
- [ ] <feature 1> - <brief description>
- [ ] <feature 2> - <brief description>
- [x] <feature 3> - <done!>

## Open Questions
<Things we still need to figure out>
- <question 1>
- <question 2>

## Learnings & Pivots
<What we've discovered along the way>
- <date>: <learning or decision>

## Current Focus
<What epic/area are we working on now?>

---
Last updated: <timestamp>
```

## Process: Setting Vision

### 1. Have a Conversation

Don't ask for a formal spec. Have a real conversation:

```
"Tell me about what you're trying to build. Not the technical stuff yet -
what's the dream? If this works perfectly, what does it look like?"
```

Follow up naturally:
- "What got you excited about this?"
- "Who would use this? What would they love about it?"
- "What's the feeling you want people to have?"

### 2. Capture the Essence

Synthesize into a vision statement - not corporate speak, but genuine:

```
"So if I'm hearing you right, you want to build a game where players
actually feel like they're managing a living world, not just clicking
through menus. The emergent stories matter more than scripted content.
Does that capture it?"
```

### 3. Identify Core Principles

What values will guide decisions?

```
"When we hit tough trade-offs, what matters most?
- Performance over features?
- Polish over scope?
- Player agency over designed experiences?"
```

### 4. Note the Unknowns

It's okay not to know everything:

```
"There's a lot we'll figure out as we go. Let me capture some open questions:
- How will multiplayer actually work?
- What's the monetization model?
- How complex should the simulation be?

We don't need answers now. We'll discover them."
```

### 5. Save the Vision

Write to `.claude/vision.md` and display confirmation.

## Process: Refining Vision

When you learn something new or make a decision:

### 1. Load Current Vision

Read `.claude/vision.md` to understand current state.

### 2. Discuss What Changed

```
"What triggered this refinement?
- Discovered something while building?
- User feedback or new insight?
- Changed priorities?
- Technical constraint?"
```

### 3. Update Appropriately

- **New feature identified** → Add to Key Features
- **Question answered** → Move from Open Questions to Learnings
- **Pivot or change** → Document in Learnings with date
- **Principle clarified** → Update Core Principles

### 4. Connect to Backlog

```
"This affects the backlog. Want me to:
- Add new stories for this?
- Reprioritize existing stories?
- Mark something as no longer needed?"
```

## Connecting Vision → Backlog

The vision feeds into planning:

```
/backlog:vision           # Remember the big picture
/backlog:idea "..."       # Explore specific ideas within that vision
/backlog:plan "..."       # Break into stories
/backlog:add "..."        # Track the work
```

When planning, reference the vision:
```
"Looking at your vision, the 'player agency' principle suggests
we should prioritize the choice system over the tutorial.
Does that feel right?"
```

## Examples

```
/backlog:vision                    # View current vision
/backlog:vision set                # Start fresh, capture the dream
/backlog:vision refine             # Update based on new learnings
```

## Starting Prompts

For a new project:
```
"I don't need a detailed spec. Just tell me:
- What's the thing you're trying to make?
- Why do you want to make it?
- What would make you proud of it?"
```

For refining:
```
"What's changed since we last talked about the vision?
Any new insights, constraints, or ideas?"
```

## Notes

- Vision is intentionally high-level and aspirational
- It's a living document - expect it to evolve
- Not everything needs to be figured out upfront
- The vision guides decisions but doesn't constrain discovery
- Revisit periodically, especially after major milestones
