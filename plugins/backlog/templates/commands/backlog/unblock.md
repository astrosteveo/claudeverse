---
description: Remove blocker from a story
argument-hint: <story-id> [--from <blocker-id>]
allowed-tools:
  - Read
  - Write
---

# Unblock Story

Remove a blocker from a story, optionally specifying which blocker.

## Arguments

- `story-id` (required): The ID of the blocked story
- `--from` (optional): Specific blocker to remove. If omitted, removes all blockers.

## Process

### 1. Load Backlog State

Read `.claude/backlog.yaml`. If not found, tell user to run `/backlog:init` first.

### 2. Find Story

Locate story by ID (case-insensitive).

If not found:
```
Story "<id>" not found. Run /backlog to see available stories.
```

### 3. Check Blockers

If story has no blockers:
```
Story "<id>" is not blocked.
```

### 4. Remove Blocker(s)

If `--from` specified:
- Remove that specific blocker from `blocked_by` array
- If blocker not in array, warn: "Story was not blocked by <blocker-id>"

If `--from` not specified:
- Clear entire `blocked_by` array

### 5. Update Status

If `blocked_by` is now empty and status was `blocked`:
- Set `status: backlog`

### 6. Update Backlog

1. Apply updates
2. Update `session.last_saved`
3. Write back to `.claude/backlog.yaml`

### 7. Display Confirmation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STORY UNBLOCKED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  <id> "<title>"
  Status: backlog (was blocked)
  <if removed specific>
  Removed blocker: <blocker-id>
  </if>
  <if removed all>
  Removed all blockers
  </if>

  To start working: /backlog:start <id>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Examples

```
/backlog:unblock PROJ-003                    # Remove all blockers
/backlog:unblock PROJ-003 --from PROJ-002    # Remove specific blocker
```
