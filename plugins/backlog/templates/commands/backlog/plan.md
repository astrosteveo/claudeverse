---
description: Brainstorm and break down a feature into stories
argument-hint: <feature or goal description>
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - WebSearch
  - AskUserQuestion
---

# Plan Feature Breakdown

Help brainstorm and break down a feature or goal into actionable stories.

## Arguments

- `feature description` (required): What you want to build or achieve

## Process

### 1. Understand the Goal

Read the user's feature description. Ask clarifying questions if needed:
- What problem does this solve?
- Who is the user/audience?
- What does "done" look like?
- Any constraints or requirements?

### 2. Research (Optional)

If the feature involves unfamiliar technology or patterns:
- Search for best practices
- Look at existing codebase patterns
- Identify potential approaches

### 3. Identify Components

Break the feature into logical components:
- Core functionality (must-have)
- Supporting features (should-have)
- Nice-to-haves (could defer)

### 4. Generate Story Candidates

For each component, suggest stories with:
- Clear title
- Brief description of what it accomplishes
- Suggested effort (r3/r5/r9)
- Dependencies on other stories

### 5. Present Stories

Display as:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  FEATURE BREAKDOWN: <feature name>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ## Core (Must Have)

  1. "<story title>" [r5]
     <brief description>

  2. "<story title>" [r3]
     <brief description>
     Depends on: #1

  ## Supporting

  3. "<story title>" [r5]
     <brief description>
     Depends on: #1, #2

  ## Nice-to-Have (Defer?)

  4. "<story title>" [r9]
     <brief description>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Suggested order: #1 → #2 → #3 (defer #4)

  Add these to backlog?
  [All] [Core only] [Let me pick] [Revise]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 6. Handle User Choice

**If "All":**
- Add all stories via `/backlog:add`
- Set up dependencies via `/backlog:block`

**If "Core only":**
- Add only core stories
- Note deferred items in epic description

**If "Let me pick":**
- Let user select which stories to add
- Add selected ones

**If "Revise":**
- Ask what to change
- Regenerate breakdown

### 7. Set Up Dependencies

After adding stories, automatically set up blockers based on the dependency analysis.

### 8. Update Epic

If backlog has an `epic` field, offer to set it to this feature name.

## Tips for Good Breakdowns

- **Vertical slices**: Each story should deliver something testable/usable
- **Independence**: Minimize dependencies where possible
- **Size consistency**: Most stories should be r5; r9 might need further breakdown
- **Clear boundaries**: Each story has clear "done" criteria

## Examples

```
/backlog:plan User authentication with OAuth
/backlog:plan Inventory system for RPG game
/backlog:plan API rate limiting and caching
/backlog:plan Refactor database layer to use repository pattern
```

## Notes

- This doesn't automatically add stories - you choose what to add
- Dependencies are suggestions based on logical order
- Can be re-run to refine or expand the breakdown
- Works best when you have some idea of the scope
