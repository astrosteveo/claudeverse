---
description: Lightweight TDD workflow for bug fixes and small improvements
argument-hint: <description of bug or improvement>
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - TodoWrite
---

# TDD Fix

Lightweight test-driven workflow for bug fixes, small improvements, and iterative development. Skips specifications and goes straight to test → implement → verify.

## When to Use

- Bug fixes
- Small enhancements to existing features
- Adding validation or error handling
- Code review findings
- Refactoring with characterization tests
- Any change too small to warrant full specs

## Task

Given a description of a bug or improvement, execute a focused TDD cycle:

1. **Understand** the issue
2. **Write failing test** that reproduces/verifies the behavior
3. **Implement** the fix
4. **Verify** all tests pass

## Implementation

### Phase 1: Understand

**Goal**: Clearly understand what needs to change

**Actions**:
1. Parse the description: $ARGUMENTS
2. If description is vague, ask ONE clarifying question
3. Identify affected code:
   - Use Grep/Glob to find relevant files
   - Read the code to understand current behavior
4. Summarize:
   ```
   Issue: [what's wrong or what needs to change]
   Location: [file:line]
   Expected: [desired behavior]
   ```

### Phase 2: Write Failing Test (RED)

**Goal**: Create a test that fails, proving the issue exists or behavior is missing

**Actions**:
1. Identify test file (create if needed)
2. Write test that:
   - Reproduces the bug, OR
   - Verifies the new behavior
3. Use descriptive name: `test_[context]_[scenario]_[expected]`
4. Run test to verify it fails
5. If test passes unexpectedly:
   - Bug may already be fixed
   - Or test doesn't capture the issue
   - Investigate and adjust

**Test Template**:
```javascript
describe('Context', () => {
  it('should [expected behavior] when [scenario]', () => {
    // Arrange - set up conditions that trigger the bug
    // Act - perform the action
    // Assert - verify correct behavior
  });
});
```

### Phase 3: Implement Fix (GREEN)

**Goal**: Make the test pass with minimal changes

**Actions**:
1. Make the smallest change that fixes the issue
2. Avoid refactoring or scope creep
3. Run tests after each change
4. Continue until test passes

**Constraints**:
- Only fix what the test covers
- Don't add features
- Don't refactor unrelated code
- Keep the diff small

### Phase 4: Verify

**Goal**: Ensure fix doesn't break anything

**Actions**:
1. Run full test suite
2. If other tests fail:
   - Determine if intentional behavior change
   - Fix or update tests as needed
3. Quick code review:
   - Is the fix correct?
   - Any obvious issues?
4. Display summary:
   ```
   ✅ Fix Complete

   Issue: [description]
   Test: [file:line]
   Fix: [file:line]

   Tests: X passing

   Next: Commit changes or run /tdd:check
   ```

## Examples

### Bug Fix
```
/tdd:fix users can't login with special characters in password

→ Understand: Password validation regex rejects valid special chars
→ Test: it('accepts passwords with !@#$% characters')
→ Fix: Update regex in validatePassword()
→ Verify: All tests pass
```

### Small Enhancement
```
/tdd:fix add email validation to registration form

→ Understand: Registration accepts invalid emails
→ Test: it('rejects emails without @ symbol')
→ Fix: Add email validation before save
→ Verify: All tests pass
```

### Code Review Finding
```
/tdd:fix handle null user in getProfile

→ Understand: getProfile throws on null user instead of returning error
→ Test: it('returns NotFound error when user is null')
→ Fix: Add null check at start of function
→ Verify: All tests pass
```

## Key Differences from /tdd

| Aspect | /tdd | /tdd:fix |
|--------|------|----------|
| Specs | Creates PRD, tech spec, requirements | None |
| Phases | 6 (Discovery → Summary) | 4 (Understand → Verify) |
| Scope | New features | Bug fixes, small changes |
| Duration | Long (full feature) | Short (single issue) |
| Output | Full documentation | Just test + fix |

## Notes

- No specs created or updated
- No manifest tracking (too granular)
- Does update CLAUDE.md if significant
- Can chain multiple fixes: `/tdd:fix` for each issue
- For larger changes, use `/tdd <feature>` instead
