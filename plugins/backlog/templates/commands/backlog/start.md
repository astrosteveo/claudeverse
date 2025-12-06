---
description: Start working on a story
argument-hint: <story-id>
allowed-tools:
  - Read
  - Write
---

# Start Story

Mark a story as in-progress and set it as the current focus.

## Arguments

- `story-id` (required): The ID of the story to start (e.g., `PROJ-001`)

## Process

### 1. Load Backlog State

Read `.claude/backlog.yaml`. If not found, tell user to run `/backlog:init` first.

### 2. Find Story

Search for story by ID. Case-insensitive match.

If not found:
```
Story "<id>" not found. Run /backlog to see available stories.
```

### 3. Validate State Transition

Story must be in `backlog` or `blocked` status to start.

If already `in-progress`:
```
Story "<id>" is already in progress.
```

If `done`:
```
Story "<id>" is already completed. Create a new story for additional work.
```

### 4. Check for Blockers (Advisory)

If story has `blocked_by` entries, warn but allow proceeding:

```
Warning: This story is blocked by:
  - <blocker-id>: <blocker-title>

Proceeding anyway. Consider resolving blockers first.
```

### 5. Update Story

1. Set `status: in-progress`
2. Clear from any `blocked` state (user is overriding)
3. Set `session.current_focus` to this story ID

### 6. Check Other In-Progress Stories

If other stories are already in-progress, ask if user wants to:
- Keep multiple in-progress (fine for parallel work)
- Pause the other story (move back to backlog)

### 7. Update Backlog

1. Apply story updates
2. Update `session.last_saved`
3. Write back to `.claude/backlog.yaml`

### 8. Display Confirmation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STORY STARTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  <id> <title>
  Effort: <effort>
  Status: in-progress (focus)

  When done: /backlog:done <id>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Examples

```
/backlog:start PROJ-001
/backlog:start proj-002  # case-insensitive
```
