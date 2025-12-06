---
description: Mark a story as done (runs stub check first)
argument-hint: <story-id> [--force]
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
  - Bash
  - AskUserQuestion
---

# Complete Story

Mark a story as done after running anti-stubbing checks.

## Arguments

- `story-id` (required): The ID of the story to complete (e.g., `PROJ-001`)
- `--force` (optional): Skip stub check confirmation

## Process

### 1. Load Backlog State

Read `.claude/backlog.yaml`. If not found, tell user to run `/backlog:init` first.

### 2. Find Story

Search for story by ID. Case-insensitive match.

If not found:
```
Story "<id>" not found. Run /backlog to see available stories.
```

### 3. Validate State

Story should be `in-progress` or `blocked` to complete.

If `backlog`:
```
Story "<id>" hasn't been started. Run /backlog:start <id> first.
```

If already `done`:
```
Story "<id>" is already completed.
```

### 4. Run Stub Detection

Run the stub detection script or use grep to scan for:

```bash
# Run stub detection
"${CLAUDE_PLUGIN_ROOT}/scripts/detect-stubs.sh" "$PWD"
```

Or use grep patterns:
- `TODO` (case insensitive)
- `FIXME` (case insensitive)
- `NotImplementedError`
- `throw new Error("not implemented")`
- `throw new Error('not implemented')`
- `raise NotImplementedError`
- `panic("not implemented")`
- `unimplemented!()`
- `pass  # TODO`

Exclude:
- `node_modules/`, `vendor/`, `venv/`, `.git/`
- Test files (optional - stubs in tests may be intentional)
- The backlog.yaml file itself

### 5. Handle Stubs Found (Advisory)

If stubs are detected, display them:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STUBS DETECTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Found <N> potential stubs:

  src/inventory.ts:45
    TODO: implement addItem logic

  src/pickup.ts:23
    throw new Error("not implemented")

  src/storage.ts:78
    // FIXME: handle edge case

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Then ask user (unless --force):
```
Mark as done anyway? These stubs will be recorded in the story.
[Yes] [No - fix stubs first]
```

If user says Yes:
- Set `stubs_acknowledged: true`
- Record stubs in story's `stubs` array

If user says No:
- Don't mark as done
- Show: "Story remains in-progress. Fix stubs and try again."

### 6. Update Story (if proceeding)

1. Set `status: done`
2. Set `completed_at: <ISO-8601 timestamp>`
3. If stubs acknowledged, update `stubs` and `stubs_acknowledged`
4. Clear from `session.current_focus` if it was focused

### 7. Update Dependent Stories

Check if any blocked stories are now unblocked:
- For each story with this story ID in `blocked_by`
- Remove this ID from their `blocked_by` array
- If `blocked_by` becomes empty, change status from `blocked` to `backlog`

### 8. Auto-Save

Update `session.last_saved` - completing a story is a milestone.

### 9. Write Back

Save updated backlog to `.claude/backlog.yaml`

### 10. Display Confirmation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STORY COMPLETED ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  <id> <title>
  Effort: <effort>
  Completed: <timestamp>
  <if stubs_acknowledged>
  Note: Completed with <N> acknowledged stubs
  </if>

  <if unblocked stories>
  Unblocked:
    - <id>: <title>
  </if>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Examples

```
/backlog:done PROJ-001
/backlog:done PROJ-002 --force  # skip stub confirmation
```

## Notes

- Stub detection is advisory, not blocking
- Acknowledging stubs records them for future reference
- Completing a story automatically unblocks dependent stories
- This triggers an auto-save (milestone)
