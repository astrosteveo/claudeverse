---
description: Resume from saved backlog state
allowed-tools:
  - Read
  - TodoWrite
  - AskUserQuestion
---

# Resume Backlog

Resume work from a previously saved backlog state. Use this after `/clear` or when starting a new session.

## Process

### 1. Load Backlog State

Read `.claude/backlog.yaml`. If not found:
```
No backlog found. Run /backlog:init to start a new project.
```

### 2. Display State Summary

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  RESUMING: <project-name>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  <if epic>
  Epic: <epic-name>
  </if>

  Last saved: <timestamp>

  ## Status
    Done: X stories
    In-Progress: Y stories
    Blocked: Z stories
    Backlog: W stories

  <if current_focus>
  ## Current Focus
    <id> "<title>" [<effort>]
  </if>

  <if in_progress stories>
  ## In Progress
    <id> "<title>" [<effort>]
    ...
  </if>

  <if blocked stories>
  ## Blocked
    <id> "<title>"
         ↳ waiting on: <blocker-ids>
    ...
  </if>

  <if resume_notes>
  ## Session Notes
  <resume_notes content>
  </if>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3. Restore Todos (if any)

If the backlog contains saved todo state, restore it:

```
Restoring <N> todos from saved state...
```

Use TodoWrite to restore the todo list.

### 4. Ask How to Proceed

```
How would you like to proceed?
[Continue] Continue from current focus
[Review] Review full backlog first
[Different] Start a different story
```

### 5. Load Context (Based on Choice)

**If Continue:**
- Read key files related to current focus story
- Display: "Ready to continue <id>: <title>"

**If Review:**
- Run full `/backlog` view
- Let user choose next action

**If Different:**
- Show available stories (non-done)
- Let user pick which to start

### 6. Final Prompt

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  READY TO WORK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Focus: <id> "<title>"

  Commands:
    /backlog           - View full backlog
    /backlog:done <id> - Complete current story
    /backlog:save      - Save state

  What would you like to work on?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Auto-Resume Detection

When starting a new session, Claude should check for existing backlog and offer to resume:

1. Check if `.claude/backlog.yaml` exists
2. If yes, and has in-progress or saved state, prompt:
   ```
   Found existing backlog for "<project-name>".
   Run /backlog:resume to continue, or /backlog to view status.
   ```

## Notes

- Resume restores context without re-reading all files
- TodoWrite state is preserved and restored
- User can choose to review or continue directly
- Blockers are highlighted so user knows what to prioritize
