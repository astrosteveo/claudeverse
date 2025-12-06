---
description: View current backlog status
allowed-tools:
  - Read
  - Grep
  - Glob
---

# View Backlog

Display the current backlog state, grouped by status with blockers highlighted.

## Process

### 1. Load Backlog State

Read `.claude/backlog.yaml` to get current state.

If file doesn't exist:
```
No backlog found. Run /backlog:init to get started.
```

### 2. Display Backlog

Format output as:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  BACKLOG: <project-name>
  Epic: <epic-name or "Not set">
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## In Progress
  <id> <title> [<effort>]
       Focus: <if current_focus>

## Blocked
  <id> <title> [<effort>]
       Blocked by: <blocker-ids>
       Notes: <notes if any>

## Backlog
  <id> <title> [<effort>]

## Done
  <id> <title> [<effort>] ✓
  ...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Summary: X done | Y in-progress | Z blocked | W backlog
  Last saved: <timestamp>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3. Show Blockers Summary

If any stories are blocked, show a blockers section:

```
## Blocker Chain
  <blocked-id> waiting on <blocker-id> "<blocker-title>"
```

### 4. Show Resume Notes

If session.resume_notes is set:
```
## Session Notes
<resume_notes content>
```

## Effort Legend

- **r3**: Small - straightforward, low complexity
- **r5**: Medium - moderate complexity, some unknowns
- **r9**: Large - high complexity, significant effort
