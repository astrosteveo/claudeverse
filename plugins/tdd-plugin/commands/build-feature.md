---
description: Fully automated feature development from spec to completion
argument-hint: feature name
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - TodoWrite
  - SlashCommand
---

# Build Feature

Completely automated feature development: create specs, then execute TDD cycles until all requirements are implemented.

## Task

Given a feature name, create complete specifications (PRD, tech spec, requirements) and then automatically implement the entire feature using TDD cycles. No questions, just build it.

## Implementation

1. **Initialize feature**:
   - Run `/tdd:start-feature {feature-name}` to create specs
   - This creates PRD, technical spec, and functional requirements

2. **Load requirements**:
   - Read `docs/specs/{feature}/functional-requirements.md`
   - Parse all FR-XXX requirements
   - Create implementation plan from requirements

3. **Set up tracking**:
   - Create todo for each functional requirement
   - Track overall progress

4. **Execute TDD cycles for each requirement**:

   For each FR-XXX requirement:

   **a) Identify behavior to test**:
   - Read requirement description
   - Understand acceptance criteria
   - Determine what to test

   **b) RED - Write failing test**:
   - Create/update test file
   - Write test for this specific requirement
   - Use appropriate framework (Jest/Pytest/Go/RSpec)
   - Mark requirement as "in_progress"

   **c) Verify RED**:
   - Run test suite
   - Verify test fails as expected
   - If passes unexpectedly: fix test

   **d) GREEN - Write implementation**:
   - Write minimal code to pass test
   - Keep it simple
   - Only what's needed for THIS requirement

   **e) Verify GREEN**:
   - Run test suite
   - Verify all tests pass
   - If fails: debug and fix

   **f) REFACTOR**:
   - Check for code smells
   - Remove duplication
   - Improve names
   - Only if needed

   **g) Final verify**:
   - Run full test suite
   - Ensure nothing broke
   - Mark requirement as "completed"

   **h) Continue to next requirement**

5. **Final validation**:
   - Run `/tdd:checkpoint` to generate report
   - Display coverage metrics
   - Show completion summary

6. **Display summary**:
```
✅ Feature Complete: {feature-name}

Requirements implemented: X/X
Test coverage: XX%
Files created/modified: X

Specifications: docs/specs/{feature}/
Tests: [test file paths]
Implementation: [source file paths]

Next steps:
- Review code
- Run /tdd:checkpoint for detailed report
- Commit changes
```

## Key Behaviors

- **Fully autonomous**: Once started, runs to completion
- **TDD for every requirement**: Red-green-refactor for each FR-XXX
- **Auto-verify**: Runs tests after every change
- **Smart ordering**: Implements requirements in logical order (dependencies first)
- **No interruptions**: Only stops if tests fail unexpectedly
- **Progress tracking**: Shows which requirement is being worked on

## Error Handling

If tests fail unexpectedly:
- Display error output
- Show which requirement was being worked on
- Show test file and implementation file
- Stop and let user debug
- Can resume with `/tdd:build-feature {feature-name}` (skips completed requirements)

## Example Flow

```
/tdd:build-feature elastic-kubernetes-cluster

Creating specifications...
✓ PRD created
✓ Technical spec created
✓ Functional requirements created (12 requirements)

Starting TDD cycles...

[1/12] FR-001: Cluster configuration validation
  🔴 Writing test... ✓
  Running tests... ✓ Failed as expected
  🟢 Writing implementation... ✓
  Running tests... ✓ All passing
  🔵 Refactoring... ✓
  Final verification... ✓

[2/12] FR-002: Node pool creation
  🔴 Writing test... ✓
  ...

[12/12] FR-012: Health check endpoint
  ...
  ✓ Complete

✅ Feature Complete: elastic-kubernetes-cluster
```

The entire feature gets built without any questions or interruptions.
