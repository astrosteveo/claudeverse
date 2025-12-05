---
name: Iterative Development Practices
description: Provides guidance on spec-driven, test-driven, iterative development methodology. Activated when user asks about MVP-first development, iterative workflows, TDD cycles, specification writing, or how to structure feature development.
version: 0.1.0
---

# Iterative Development Practices

This skill provides guidance on the iterative-dev methodology: a spec-driven, test-driven, MVP-first approach to building software.

## Core Philosophy

### MVP-First Thinking

**Principle**: Prove value quickly, then iterate toward the full solution.

**Why**:
- Reduces risk of building the wrong thing
- Gets feedback faster
- Prevents over-engineering
- Maintains momentum and motivation

**How**:
1. Define the full vision (what success looks like)
2. Identify the minimum that proves the concept
3. Explicitly defer everything else
4. Implement, validate, ship
5. Loop back and expand scope

### Spec-Driven Development

**Principle**: Clear specifications drive everything downstream.

**Why**:
- Prevents miscommunication
- Creates testable requirements
- Documents decisions for future reference
- Enables independent testing

**Key Documents**:
- **Vision**: Problem statement and success criteria
- **MVP Scope**: What's in/out for this iteration
- **Requirements**: FR-XXX with Given-When-Then criteria
- **ADRs**: Architecture decisions and rationale

### Test-Driven Development (TDD)

**Principle**: Write failing tests before implementation.

**The Cycle**:
```
RED    → Write failing test
GREEN  → Write minimal code to pass
REFACTOR → Improve code, keep tests green
```

**Why**:
- Tests verify requirements, not implementation
- Drives better design (testable = modular)
- Prevents regression
- Documents expected behavior

### Anti-Stubbing

**Principle**: Everything works or nothing ships.

**What to Avoid**:
```javascript
// ❌ Stubs
function processPayment(amount) {
  // TODO: implement
  return true;
}

// ❌ Placeholders
throw new Error('Not implemented');

// ❌ Empty handlers
catch (error) {
  // handle error later
}
```

**Why**:
- Stubs create false confidence
- They're easily forgotten
- They hide incomplete work
- They can ship to production

---

## The 8-Phase Workflow

### Phase 1: Vision
**Goal**: Understand the problem

Ask:
- What problem are we solving?
- Who experiences it?
- How will we know it's solved?

**Output**: `vision.md`

### Phase 2: MVP Scope
**Goal**: Define minimum viable scope

Ask:
- What's the minimum to prove value?
- What can we defer?
- Can we complete this in one session?

**Output**: `scope-v<N>.md`

### Phase 3: Specification
**Goal**: Create testable requirements

For each scope item:
- Create FR-XXX requirement
- Write Given-When-Then criteria
- Validate testability

**Output**: `requirements-v<N>.md`

### Phase 4: Test Design (RED)
**Goal**: Write failing tests

For each requirement:
- Create test file
- Write tests referencing FR-XXX
- Verify all tests fail

**Output**: Test files, `test-plan-v<N>.md`

### Phase 5: Implementation (GREEN)
**Goal**: Make tests pass

For each requirement:
- Write minimal code
- Run tests
- No stubs allowed

**Output**: Implementation files

### Phase 6: Validation
**Goal**: Ensure quality

Check:
- Coverage meets thresholds
- No stubs detected
- Tests are meaningful
- No regressions

**Output**: `validation-v<N>.md`

### Phase 7: Ship
**Goal**: Document and release

Actions:
- Generate usage docs
- Update README
- Commit changes

**Output**: `release-v<N>.md`

### Phase 8: Iterate
**Goal**: Plan next iteration

Decide:
- Continue (loop to Phase 2)
- Complete (close feature)
- Pause (save for later)

---

## Writing Good Specifications

### Functional Requirements Format

```markdown
## FR-001: User Login

**Priority**: Critical
**Scope Item**: Authentication

**Description**:
Users can log in with email and password to access their account.

**Acceptance Criteria**:

1. **Given** a registered user with valid credentials
   **When** they submit email and password
   **Then** they receive an authentication token

2. **Given** invalid credentials
   **When** login is attempted
   **Then** error message is displayed (no token)

3. **Given** empty email or password
   **When** login is attempted
   **Then** validation error is shown
```

### Good vs Bad Requirements

**❌ Bad**: "System should be fast"
**✅ Good**: "API responds in < 200ms for 95th percentile"

**❌ Bad**: "User experience should be good"
**✅ Good**: "User can complete checkout in ≤ 3 clicks"

**❌ Bad**: "Handle errors appropriately"
**✅ Good**: "Return 400 status with error message for invalid input"

---

## Writing Good Tests

### Test Structure (AAA Pattern)

```typescript
it('should return token for valid credentials', () => {
  // Arrange - set up test data
  const credentials = { email: 'user@test.com', password: 'valid123' };

  // Act - perform the action
  const result = login(credentials);

  // Assert - verify the outcome
  expect(result.token).toBeDefined();
  expect(result.token).toMatch(/^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+/);
});
```

### Test Quality Checklist

- [ ] Test name describes expected behavior
- [ ] References FR-XXX requirement
- [ ] Tests ONE thing per test
- [ ] Uses specific assertions (not `toBeTruthy()`)
- [ ] Includes error cases
- [ ] Tests boundaries

### Anti-Patterns

```typescript
// ❌ Too vague
expect(result).toBeTruthy();

// ❌ Testing implementation
expect(mockDb.query).toHaveBeenCalledWith('SELECT...');

// ❌ Multiple concerns
it('should login and update profile and send email', () => {...});

// ❌ No assertion
it('should process data', () => {
  processData(input);
  // forgot to assert!
});
```

---

## Context Management

### When to Save State

Use `/iterative-dev:save` when:
- Session is getting long
- Switching to different task
- Before complex operation
- When prompted about context

### State Preservation

The session state includes:
- Current phase and progress
- Completed work summaries
- Pending tasks
- Key decisions made
- Resume instructions

### Resuming Work

After `/clear`, run `/iterative-dev:resume` to:
- Load saved state
- Restore todo list
- Display progress summary
- Continue from saved phase

---

## Quick Reference

### Commands

| Command | Purpose |
|---------|---------|
| `/iterative-dev <feature>` | Start/continue feature |
| `/iterative-dev:init` | Initialize project |
| `/iterative-dev:save` | Save state manually |
| `/iterative-dev:resume` | Resume from state |
| `/iterative-dev:check` | Compliance report |

### Key Locations

| Location | Purpose |
|----------|---------|
| `docs/iterations/<feature>/` | Feature documents |
| `docs/adrs/` | Architecture decisions |
| `.claude/iterative-dev/` | Plugin state |
| `CLAUDE.md` | Project context |

### Coverage Thresholds

| Metric | Default |
|--------|---------|
| Line Coverage | 80% |
| Branch Coverage | 75% |

---

## Troubleshooting

### Tests Pass When They Shouldn't (RED Phase)

1. Check if implementation already exists
2. Verify test is checking correct behavior
3. Test may be too permissive

### Coverage Below Threshold

1. Run `/iterative-dev:check` for gap analysis
2. Add tests for critical paths first
3. Consider if threshold is appropriate

### Stubs Detected

1. Cannot proceed until stubs removed
2. Complete implementation or
3. Remove feature from scope

### Context Getting Full

1. `/iterative-dev:save` to checkpoint
2. `/clear` to reset
3. `/iterative-dev:resume` to continue
