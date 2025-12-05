---
description: Save current workflow state for later resumption
argument-hint: [reason] optional reason for saving
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - TodoWrite
---

# Save Workflow State

Manually save current iterative-dev session state for later resumption. Use this before running `/clear` or when pausing work.

## When to Use

- Before context compaction (auto-triggered, but manual backup is good)
- When pausing work for later
- Before switching to a different task
- As a checkpoint during complex implementations

## Process

### 1. Gather Current State

Read from:
- `.claude/iterative-dev/active-iteration.yaml` - current feature/phase
- `docs/iterations/<feature>/` - all iteration documents
- Recent TodoWrite state
- Test results (if available)

### 2. Generate State Summary

Analyze current progress:
- Which phase are we in (1-8)?
- What work is completed?
- What work is in progress?
- What decisions have been made?
- What files have been modified?

### 3. Write State File

Create `.claude/iterative-dev/session-state.yaml`:

```yaml
# Iterative-Dev Session State
# Generated: <timestamp>
# Reason: <user_provided_or_auto>

version: 1
savedAt: "<ISO-8601 timestamp>"
reason: "<manual | context_threshold | phase_complete>"

feature:
  name: "<feature-name>"
  iteration: <N>

workflow:
  currentPhase: <1-8>
  phaseName: "<Vision | MVP Scope | Specification | Test Design | Implementation | Validation | Ship | Iterate>"
  phasesCompleted:
    - phase: 1
      name: "Vision"
      summary: "<brief summary>"
      completedAt: "<timestamp>"
    # ... more phases

implementation:
  status: "<not_started | in_progress | complete>"
  testsPassing: <N>
  testsFailing: <N>
  testsTotal: <N>
  filesModified:
    - path: "<file-path>"
      status: "<created | modified | partial>"
    # ... more files

decisions:
  - type: "<architecture | scope | technical>"
    summary: "<brief description>"
    adr: "<path to ADR if exists>"
  # ... more decisions

pendingWork:
  - "<description of pending item 1>"
  - "<description of pending item 2>"

todos:
  - content: "<todo content>"
    status: "<pending | in_progress | completed>"
  # ... current todos

resumeInstructions: |
  <Clear instructions for resuming work>
  - What to do first
  - What context is needed
  - Any blockers or considerations
```

### 4. Display Confirmation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ SESSION STATE SAVED

Feature: <feature-name> (Iteration <N>)
Phase: <N>/8 (<phase-name>)
Tests: <passing>/<total> passing

Saved to: .claude/iterative-dev/session-state.yaml

## To Resume Later
1. Run `/clear` to reset context
2. Run `/iterative-dev:resume` to continue

## Quick Summary
<2-3 line summary of current state>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## State File Location

`.claude/iterative-dev/session-state.yaml`

This file should be gitignored as it contains session-specific state.

## Notes

- State file is overwritten on each save (only latest state preserved)
- For version history, use git commits at phase boundaries
- State includes enough context to resume without reading all files
- Resume instructions are generated to be self-contained
