---
description: Resume workflow from saved state after context clear
argument-hint: none
allowed-tools:
  - Read
  - Write
  - TodoWrite
  - Glob
  - Grep
---

# Resume Workflow from Saved State

Load saved session state and continue iterative development workflow from where you left off.

## When to Use

- After running `/clear` to reset context
- When returning to paused work
- After switching back from another task

## Process

### 1. Load State File

Read `.claude/iterative-dev/session-state.yaml`

If not found:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  NO SAVED STATE FOUND

No session-state.yaml found. Options:
1. Start fresh: /iterative-dev <feature-name>
2. Check for active iteration in .claude/iterative-dev/active-iteration.yaml

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 2. Display State Summary

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RESUMING SESSION

Feature: <feature-name>
Iteration: <N>
Saved: <timestamp>
Reason: <reason>

## Progress
Phase <current>/8: <phase-name>

Completed:
  ✓ Phase 1: Vision - <summary>
  ✓ Phase 2: MVP Scope - <summary>
  ✓ Phase 3: Specification - <summary>
  → Phase 4: Test Design - IN PROGRESS

## Current State
Tests: <passing>/<total> passing
Files modified: <count>

## Pending Work
- <pending item 1>
- <pending item 2>

## Resume Instructions
<instructions from state file>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3. Restore TodoWrite State

Recreate the todo list from saved state:
- Add all pending todos with their status
- Mark completed items as completed
- Set current in-progress item

### 4. Load Key Context Files

Read the essential files for current phase:
- Vision document: `docs/iterations/<feature>/vision.md`
- Scope document: `docs/iterations/<feature>/scope-v<N>.md`
- Requirements (if past Phase 3): `docs/iterations/<feature>/requirements-v<N>.md`
- Test plan (if past Phase 4): `docs/iterations/<feature>/test-plan-v<N>.md`

### 5. Confirm and Continue

Ask user:
```
Ready to continue from Phase <N> (<phase-name>)?

[Continue] - Resume from saved state
[Review]   - Show more details before continuing
[Restart]  - Start this phase over
```

### 6. Clear State File (Optional)

After successful resume, optionally clear the state file:
- Keep it during the session (for potential re-saves)
- Clear on successful phase completion

## Restore Behavior by Phase

### If resuming Phase 1 (Vision)
- Load any partial vision document
- Continue vision discovery

### If resuming Phase 2 (MVP Scope)
- Load vision document
- Continue scope definition

### If resuming Phase 3 (Specification)
- Load vision and scope
- Continue requirements writing

### If resuming Phase 4 (Test Design)
- Load all specs
- Check which tests exist
- Continue test generation
- Re-verify RED state

### If resuming Phase 5 (Implementation)
- Load specs and tests
- Check current test status (run tests)
- Identify which FRs are complete
- Continue implementation

### If resuming Phase 6 (Validation)
- Run full test suite
- Run coverage analysis
- Continue validation

### If resuming Phase 7 (Ship)
- Check documentation state
- Continue documentation and release

### If resuming Phase 8 (Iterate)
- Load iteration history
- Continue iteration planning

## Notes

- State file remains until overwritten by next save
- Always verify test state after resume (tests may have changed)
- If state seems stale, user can choose to start phase over
- Resume loads minimal context to avoid filling context window
