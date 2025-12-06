---
description: Save current backlog state with notes for resumption
argument-hint: [reason/notes]
allowed-tools:
  - Read
  - Write
  - TodoWrite
---

# Save Backlog State

Save the current backlog state with optional notes for later resumption. Use this before `/clear` or when pausing work.

## Arguments

- `reason/notes` (optional): Notes about current state, what to do next, etc.

## When to Use

- Before running `/clear` to reset context
- When pausing work for later
- Before switching to a different project
- As a checkpoint during complex work
- When context usage is getting high

## Process

### 1. Load Backlog State

Read `.claude/backlog.yaml`. If not found:
```
No backlog found. Nothing to save.
```

### 2. Gather Current State

Analyze current progress:
- Count stories by status
- Identify current focus
- Note any blockers
- Check for in-progress work

### 3. Generate Resume Notes

If user provided notes, use those. Otherwise, auto-generate based on:
- Current focus story
- In-progress stories
- Blocked stories and their blockers
- Recent activity

### 4. Capture TodoWrite State

If there are active todos, include them in the state:
```yaml
todos:
  - content: "Implement addItem function"
    status: in_progress
  - content: "Write tests for inventory"
    status: pending
```

### 5. Update Session State

Update `.claude/backlog.yaml`:

```yaml
session:
  last_saved: "<ISO-8601 timestamp>"
  current_focus: "<current focus story ID>"
  resume_notes: |
    <user notes or auto-generated summary>

    Current state:
    - X stories done
    - Y in-progress
    - Z blocked
    - W in backlog

    Focus: <story-id> "<title>"

    <if blockers>
    Blockers:
    - <blocked> waiting on <blocker>
    </if>

    <if todos>
    Active todos:
    - <todo items>
    </if>
```

### 6. Write Back

Save updated backlog to `.claude/backlog.yaml`

### 7. Display Confirmation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STATE SAVED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Project: <project-name>
  Saved at: <timestamp>

  Summary:
    Done: X | In-Progress: Y | Blocked: Z | Backlog: W

  <if current_focus>
  Current focus: <id> "<title>"
  </if>

  ## To Resume Later
  1. Run /clear to reset context
  2. Run /backlog:resume to continue

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Examples

```
/backlog:save
/backlog:save "Finished auth, need to wire up to API next"
/backlog:save "Pausing - blocked on design decision"
```

## Notes

- State is saved to `.claude/backlog.yaml` (same file)
- Previous session state is overwritten
- Resume notes are meant to be human-readable
- Include enough context to pick up where you left off
