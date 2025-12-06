---
description: Mark a story as blocked by another
argument-hint: <story-id> --by <blocker-id>
allowed-tools:
  - Read
  - Write
---

# Block Story

Mark a story as blocked by another story, establishing a dependency.

## Arguments

- `story-id` (required): The ID of the story to mark as blocked
- `--by` (required): The ID of the blocking story

## Process

### 1. Load Backlog State

Read `.claude/backlog.yaml`. If not found, tell user to run `/backlog:init` first.

### 2. Parse Arguments

Extract both story IDs. Both are required.

If missing `--by`:
```
Usage: /backlog:block <story-id> --by <blocker-id>
Example: /backlog:block PROJ-003 --by PROJ-002
```

### 3. Find Both Stories

Locate both stories by ID (case-insensitive).

If blocked story not found:
```
Story "<id>" not found. Run /backlog to see available stories.
```

If blocker story not found:
```
Blocker story "<id>" not found. Run /backlog to see available stories.
```

### 4. Validate

Check blocker isn't already done:
```
Story "<blocker-id>" is already completed - no need to block on it.
```

Check not blocking itself:
```
A story cannot block itself.
```

Check not creating circular dependency:
- If blocker is blocked by the story we're trying to block
```
Circular dependency detected: <id> would block <blocker-id> which blocks <id>
```

### 5. Update Blocked Story

1. Add blocker ID to `blocked_by` array (if not already present)
2. Set `status: blocked`
3. Optionally add note about why blocked

### 6. Update Backlog

1. Apply updates
2. Update `session.last_saved`
3. Write back to `.claude/backlog.yaml`

### 7. Display Confirmation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BLOCKER ADDED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  <blocked-id> "<blocked-title>"
  ↳ blocked by <blocker-id> "<blocker-title>"

  To unblock: Complete <blocker-id> or run /backlog:unblock <blocked-id>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Examples

```
/backlog:block PROJ-003 --by PROJ-002
/backlog:block UI-005 --by API-002
```
