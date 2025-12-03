---
description: Execute automated TDD red-green-refactor cycle
argument-hint: optional behavior description
allowed-tools:
  - Read
  - TodoWrite
  - Bash
  - Edit
  - Write
  - Grep
  - Glob
---

# Run TDD Cycle

Automatically execute the red-green-refactor TDD cycle by writing tests and implementation.

## Task

Execute a complete TDD cycle: write a failing test, verify it fails, write minimal implementation, verify it passes, refactor, and verify again. All automated.

## Implementation

1. **Load context**:
   - Read `.claude/current-feature.txt` to get active feature
   - Read `docs/specs/{feature}/functional-requirements.md` to see requirements
   - If argument provided, use as behavior to test
   - Otherwise, identify next untested requirement from functional spec

2. **Set up tracking**:
```javascript
[
  { content: "Write failing test (RED)", status: "in_progress", activeForm: "Writing failing test" },
  { content: "Verify test fails", status: "pending", activeForm: "Verifying test fails" },
  { content: "Write implementation (GREEN)", status: "pending", activeForm: "Writing implementation" },
  { content: "Verify tests pass", status: "pending", activeForm: "Verifying tests pass" },
  { content: "Refactor (REFACTOR)", status: "pending", activeForm: "Refactoring" },
  { content: "Final verification", status: "pending", activeForm: "Running final verification" }
]
```

3. **Execute cycle**:

### Phase 1: RED - Write Failing Test

- Display: "🔴 RED: Writing test for [behavior]"
- Identify test file location (use framework conventions)
- Write test using appropriate framework (Jest/Pytest/Go/RSpec)
- Use AAA pattern: Arrange, Act, Assert
- Test ONE specific behavior
- Mark complete

### Phase 2: Verify RED

- Display: "Running tests to verify failure..."
- Detect framework and run tests automatically
- Capture output and exit code
- If exit code 0 (passed): Display warning, explain issue, stop
- If exit code != 0 (failed): Display "✓ Test failed as expected", continue
- Mark complete

### Phase 3: GREEN - Write Implementation

- Display: "🟢 GREEN: Writing minimal implementation"
- Write simplest code to make test pass
- No edge cases not covered by test
- No extra features
- Mark complete

### Phase 4: Verify GREEN

- Display: "Running tests to verify pass..."
- Run test suite automatically
- If exit code != 0: Display error, show output, stop for debugging
- If exit code 0: Display "✓ All tests passing", continue
- Mark complete

### Phase 5: REFACTOR - Clean Up

- Display: "🔵 REFACTOR: Checking for improvements"
- Analyze code for:
  - Duplication
  - Unclear names
  - Complex logic
- If opportunities found: Refactor
- If code is clean: Skip refactoring
- Display what was done (or "Code is clean, skipping")
- Mark complete

### Phase 6: Final Verification

- Display: "Running final test verification..."
- Run test suite one last time
- If exit code != 0: Display "❌ Refactor broke tests", show output
- If exit code 0: Display completion summary
- Mark complete

4. **Display summary**:
```
✅ TDD Cycle Complete!

Behavior tested: [description]
Test file: [path:line]
Implementation: [path:line]

Coverage: Run /tdd:checkpoint for full report
Next: Run /tdd:run-cycle again for next behavior
```

5. **Clear todos**

## Test Framework Detection

Check for:
- `package.json` → npm test or jest
- `pytest.ini` or `test_*.py` → pytest
- `go.mod` → go test ./...
- `Gemfile` + `spec/` → rspec

## Key Principles

- **Fully automated**: Write tests AND implementation
- **No questions**: Just execute the cycle
- **Auto-verify**: Run tests at each checkpoint
- **Show results**: Display output, but keep moving
- **Trust the process**: RED → GREEN → REFACTOR

The command executes a complete TDD cycle without stopping to ask questions. If tests fail when they should pass (or vice versa), show the error and stop - otherwise keep going.
