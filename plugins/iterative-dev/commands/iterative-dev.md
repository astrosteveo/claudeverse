---
description: Spec-driven, test-driven, iterative development workflow with MVP-first thinking
argument-hint: <feature-name> or empty to continue current feature
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - TodoWrite
  - Task
  - SlashCommand
---

# Iterative Development Workflow

Guide feature development using a spec-driven, test-driven, MVP-first methodology. This workflow ensures you prove value quickly and iterate toward a complete solution.

## Core Philosophy

- **MVP-First**: Define the minimum viable scope before building elaborate solutions
- **Spec-Driven**: Clear specifications drive everything downstream
- **Test-Driven**: Write failing tests before implementation (RED → GREEN → Refactor)
- **Iterative**: Ship value early, expand incrementally through iteration loops
- **Anti-Stubbing**: No incomplete implementations - everything works or nothing ships
- **Context-Aware**: Preserve state before context compaction for seamless resumption

---

## Phase 1: Vision

**Goal**: Understand what problem we're solving and why it matters

**Input**: $ARGUMENTS

### Actions

1. **Create todo list** with all 8 phases for tracking
2. **Check for existing context**:
   - Look for `.claude/iterative-dev/session-state.yaml` (resume scenario)
   - Look for `.claude/iterative-dev/active-iteration.yaml`
   - If found, ask user: "Resume existing work or start fresh?"
3. **If resuming**: Load state and skip to saved phase
4. **If new feature**, conduct Vision Discovery:
   - Ask: "What problem are you trying to solve?"
   - Ask: "Who experiences this problem and how painful is it?"
   - Ask: "How will you know when this is solved?"
5. **Confirm vision** with user before proceeding

### Artifacts Created

- `docs/iterations/<feature>/vision.md`:
  ```markdown
  ---
  feature: <feature-name>
  status: vision-defined
  created: <timestamp>
  ---

  # Vision: <Feature Name>

  ## Problem Statement
  [User-provided problem description]

  ## User Impact
  - Who: [affected users]
  - Frequency: [how often]
  - Severity: [pain level]

  ## Success Criteria
  - [Measurable outcome 1]
  - [Measurable outcome 2]
  ```

- `.claude/iterative-dev/active-iteration.yaml`:
  ```yaml
  feature: <feature-name>
  currentPhase: 1
  iteration: 1
  startedAt: <timestamp>
  ```

### Exit Criteria

- Vision document exists with problem statement
- Success criteria are measurable
- User confirms understanding is accurate

---

## Phase 2: MVP Scope

**Goal**: Define the minimum viable scope that proves value

**THIS IS THE KEY DIFFERENTIATOR** - Ruthlessly scope down before building.

### Actions

1. **Present the full problem** from vision document
2. **Ask MVP-defining questions**:
   - "What is the absolute minimum that would prove this is solvable?"
   - "What can you explicitly defer to later iterations?"
   - "Can this be completed in a single session?"
3. **Generate 2-3 MVP scope options** if helpful
4. **User selects or refines** MVP scope
5. **Document explicit deferrals** - what is NOT in this iteration

### Artifacts Created

- `docs/iterations/<feature>/scope-v<N>.md`:
  ```markdown
  ---
  feature: <feature-name>
  iteration: <N>
  status: scoped
  created: <timestamp>
  ---

  # Iteration <N> Scope: <Feature>

  ## MVP Definition
  [Clear statement of what this iteration delivers]

  ## In Scope
  - [ ] Deliverable 1
  - [ ] Deliverable 2

  ## Explicitly Out of Scope (Deferred)
  - Item X - Rationale: [why deferred]
  - Item Y - Rationale: [why deferred]

  ## Success Criteria for This Iteration
  - [Measurable outcome 1]

  ## Session Feasibility
  - Estimated complexity: [Low/Medium/High]
  - Dependencies: [list]
  ```

### Exit Criteria

- MVP scope is clearly defined with In/Out boundaries
- User confirms scope is achievable in one session
- At least one testable behavior is identified
- Deferred items are documented with rationale

---

## Phase 3: Specification

**Goal**: Create precise, testable specifications for the MVP scope only

### Actions

1. **Read MVP scope** document
2. **Create or copy templates**:
   - `prd.md` - Product Requirements Document
   - `requirements.md` - Functional Requirements (FR-XXX)
   - `technical-spec.md` - Technical Specification (if needed)
   - `gdd.md` - Game Design Document (gamedev only - detect Unity, Godot, Unreal)
3. **Generate functional requirements**:
   - For each In-Scope item, create FR-XXX requirements
   - Each FR must have Given-When-Then acceptance criteria
   - Each FR must be independently testable
4. **Validate requirements**:
   - Confirm each maps to an MVP scope item
   - Remove any "nice-to-have" requirements
   - Ensure no scope creep

**Templates location**: `${CLAUDE_PLUGIN_ROOT}/templates/`

### Artifacts Created

- `docs/iterations/<feature>/requirements-v<N>.md`:
  ```markdown
  ---
  feature: <feature-name>
  iteration: <N>
  status: specified
  ---

  # Functional Requirements: Iteration <N>

  ## FR-001: <Requirement Title>

  **Priority**: Critical
  **Scope Item**: [Which MVP item this fulfills]

  **Description**:
  [Clear description]

  **Acceptance Criteria**:
  1. **Given** [context]
     **When** [action]
     **Then** [result]

  **Testable**: Yes
  ```

### Exit Criteria

- Each In-Scope item has at least one FR
- Each FR has testable acceptance criteria
- User confirms requirements match MVP intent
- No requirements exceed defined scope

---

## Phase 4: Test Design (RED)

**Goal**: Write failing tests for all requirements BEFORE implementation

### Actions

1. **Detect test framework**:
   ```bash
   ${CLAUDE_PLUGIN_ROOT}/scripts/detect-test-framework.sh
   ```
2. **Generate test plan**:
   - Map each FR-XXX to test file(s)
   - Follow project conventions for test location
3. **Write failing tests** for each requirement:
   - Test name must reference FR-XXX
   - Use AAA (Arrange-Act-Assert) or Given-When-Then structure
   - Include happy path AND error cases
   - Framework patterns:
     - Jest: `describe`, `it`, `expect`
     - Pytest: `test_`, `assert`
     - Go: `func Test*`, `t.Run`
     - RSpec: `describe`, `context`, `it`
4. **Verify RED state**:
   - Run all new tests
   - Confirm ALL fail (not syntax errors, but actual test failures)
   - If any pass unexpectedly, investigate

### Artifacts Created

- Test files following framework conventions
- `docs/iterations/<feature>/test-plan-v<N>.md`:
  ```markdown
  ---
  feature: <feature-name>
  iteration: <N>
  status: red
  ---

  # Test Plan: Iteration <N>

  ## Test Inventory

  | FR | Test File | Test Count | Status |
  |----|-----------|------------|--------|
  | FR-001 | tests/fr001_auth.test.ts | 3 | RED |

  ## RED State Verified
  - Date: <timestamp>
  - All tests failing: Yes
  ```

### Exit Criteria

- All FRs have corresponding test(s)
- All tests are failing (RED state confirmed)
- Test failures are for expected reasons
- Test quality is reviewed (specific assertions, proper structure)

---

## Phase 5: Implementation (GREEN)

**Goal**: Write minimal code to make tests pass

### Actions

1. **Check context threshold** before starting:
   - If approaching limit, trigger `/iterative-dev:save` before proceeding
2. **For each FR** (in priority order):
   a. Read the failing test(s)
   b. Write minimum code to pass
   c. Run tests for that FR only
   d. Verify GREEN for that FR
   e. Run full test suite to check no regressions
3. **Anti-stubbing check** after each FR:
   - Scan for TODO, FIXME, NotImplementedError
   - Scan for placeholder returns (return null, return {})
   - If found, must complete before proceeding
4. **Architecture decisions**:
   - If significant decision needed, create ADR:
     ```
     /iterative-dev:adr <decision-title>
     ```
5. **Commit checkpoints** after each FR is GREEN (optional)

### Code Quality Standards

- **No stubs allowed**:
  - No `// TODO:` or `// FIXME:` in new code
  - No `throw new Error('Not implemented')`
  - No `pass # placeholder` or `raise NotImplementedError`
  - No empty function bodies
  - No hardcoded placeholder returns
- **Follow existing patterns** in codebase
- **Only implement what tests require** - no extra features

### Exit Criteria

- All tests passing (GREEN state)
- Zero stubs or TODOs in implementation
- No regressions in existing tests
- Implementation follows codebase conventions

---

## Phase 6: Validation

**Goal**: Ensure implementation is complete and tested adequately

### Actions

1. **Coverage analysis**:
   ```bash
   ${CLAUDE_PLUGIN_ROOT}/scripts/validate-coverage.sh
   ```
   - Compare against thresholds (default: 80% line, 75% branch)
   - Identify uncovered critical paths
2. **Final stub detection**:
   - Comprehensive scan for incomplete code
   - Check for TODO/FIXME in new code
   - Check for empty catch blocks
3. **Test meaningfulness audit**:
   - Verify tests check actual behavior
   - Verify tests would fail if behavior changed
   - Flag overly permissive assertions (e.g., `toBeTruthy()`)
4. **Integration check**:
   - Run full test suite
   - Verify no regressions
5. **If issues found**:
   - Add missing tests
   - Complete stub implementations
   - Address quality concerns

### Exit Criteria

- Coverage meets thresholds (or user acknowledges gaps)
- Zero stubs detected
- Test quality is acceptable
- All tests passing

---

## Phase 7: Ship

**Goal**: Document completion and make it official

### Actions

1. **Generate usage documentation**:
   - Import/require statements
   - Basic usage examples
   - Common use cases
   - Error handling examples
2. **Update project documentation**:
   - Update README.md if needed
   - Update CLAUDE.md with current state
3. **Create release summary**:
   ```markdown
   ## Iteration <N> Complete: <Feature>

   ### Delivered
   - FR-001: [description]
   - FR-002: [description]

   ### Files Changed
   - [list of files]

   ### Coverage: XX%

   ### Usage
   [Usage examples]
   ```
4. **Git operations** (with user approval):
   - Stage changes
   - Create commit with iteration summary
5. **Clear active iteration** if complete

### Artifacts Created

- `docs/iterations/<feature>/release-v<N>.md`
- Updated CLAUDE.md
- Git commit (if approved)

### Exit Criteria

- Usage documentation exists
- Changes committed (or user declined)
- CLAUDE.md reflects current state

---

## Phase 8: Iterate

**Goal**: Plan next iteration or close the feature

### Actions

1. **Review deferred items** from scope document
2. **Retrospective questions**:
   - "Did this iteration prove value?"
   - "What did we learn?"
   - "What should we tackle next?"
3. **Decision point**:
   - **Continue**: Loop back to Phase 2 with next iteration scope
   - **Complete**: Feature is done, archive and close
   - **Pause**: Save state for later resumption

### If Continuing

1. Increment iteration number
2. Pre-populate next scope with top deferred items
3. Transition to Phase 2 (MVP Scope)

### If Complete

1. Archive iteration artifacts
2. Update feature status to "complete"
3. Clear active iteration

### If Pausing

1. Run `/iterative-dev:save`
2. Inform user how to resume later

---

## Context Preservation

**IMPORTANT**: Before context compaction triggers, preserve state.

### Auto-Save Trigger

When detecting high context usage:
1. Pause current work
2. Save state to `.claude/iterative-dev/session-state.yaml`
3. Display:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ⚠️  CONTEXT CHECKPOINT

   Session state saved. To continue with fresh context:
   1. Run `/clear`
   2. Run `/iterative-dev:resume`

   Progress: Phase <N>/8 | Tests: X/Y passing
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

### Manual Save

User can run `/iterative-dev:save` at any time.

---

## Error Handling

### Tests fail unexpectedly in GREEN phase

1. Display error output
2. Show which FR was being worked on
3. Ask: debug now or skip to next FR?

### Tests pass when they should fail (RED phase)

1. Check if code already exists
2. Test may be redundant - note and continue
3. If not, test may be incorrect - review

### Stubs detected

1. Block progression
2. List all stubs with file:line
3. Must complete implementation before proceeding

### Context limit approaching

1. Trigger auto-save
2. Instruct user to `/clear` and `/iterative-dev:resume`

---

## Example Usage

### Start new feature

```
/iterative-dev user-authentication
```

### Continue current feature

```
/iterative-dev
```

### Resume after context clear

```
/iterative-dev:resume
```

### Quick single iteration

```
/iterative-dev validate email addresses contain @
```

---

## Integration Points

- `/iterative-dev:init` - Initialize project for iterative-dev
- `/iterative-dev:save` - Manual state checkpoint
- `/iterative-dev:resume` - Resume from saved state
- `/iterative-dev:adr` - Create architecture decision record
- `/iterative-dev:check` - Compliance and coverage report
