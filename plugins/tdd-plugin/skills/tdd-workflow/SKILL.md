---
name: TDD Workflow
description: This skill should be used when the user asks about "TDD workflow", "test driven development process", "red green refactor", "how to do TDD", "TDD cycle", "write tests first", or needs guidance on following test-first development practices. Provides comprehensive guidance on the Test Driven Development cycle and best practices.
version: 0.1.0
---

# TDD Workflow

## Overview

Test Driven Development (TDD) is a software development approach where tests are written before implementation code. This skill provides guidance on following the TDD workflow, understanding the red-green-refactor cycle, and applying TDD principles effectively across different programming languages and project types.

## The TDD Cycle: Red-Green-Refactor

TDD follows a simple but powerful three-phase cycle:

### Phase 1: RED - Write a Failing Test

**Purpose**: Define expected behavior before implementation exists.

**Steps**:
1. Identify the next smallest piece of functionality to implement
2. Write a test that describes this behavior using assertions
3. Run the test suite to verify the new test fails
4. Confirm the failure reason is correct (not a syntax error or setup issue)

**Key principles**:
- Start with the simplest test case
- Write only enough test code to see it fail
- Ensure the test fails for the right reason
- Avoid implementing functionality while writing tests

**Example (JavaScript/Jest)**:
```javascript
describe('UserValidator', () => {
  it('should return true for valid email addresses', () => {
    const validator = new UserValidator();
    expect(validator.isValidEmail('user@example.com')).toBe(true);
  });
});
```

Running this test will fail because `UserValidator` doesn't exist yet.

### Phase 2: GREEN - Make the Test Pass

**Purpose**: Implement the minimal code needed to make the test pass.

**Steps**:
1. Write the simplest implementation that makes the test pass
2. Avoid adding extra functionality not covered by tests
3. Run the test suite to verify all tests pass
4. If tests fail, debug and fix until green

**Key principles**:
- Implement only what's needed for the current test
- Resist the urge to add "future" features
- Hardcoding values is acceptable at this stage
- Focus on making tests pass, not perfect code

**Example (JavaScript)**:
```javascript
class UserValidator {
  isValidEmail(email) {
    return email.includes('@') && email.includes('.');
  }
}
```

This implementation is simple but makes the test pass.

### Phase 3: REFACTOR - Improve Code Quality

**Purpose**: Improve code structure while maintaining passing tests.

**Steps**:
1. Review the implementation and test code
2. Identify code smells, duplication, or unclear naming
3. Refactor incrementally, running tests after each change
4. Ensure all tests remain green throughout refactoring

**Key principles**:
- Tests provide safety net during refactoring
- Improve without changing behavior
- Extract methods, rename variables, remove duplication
- Run tests frequently to catch regressions

**Example (Refactored JavaScript)**:
```javascript
class UserValidator {
  isValidEmail(email) {
    const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return EMAIL_PATTERN.test(email);
  }
}
```

Better implementation using regex, more robust validation.

### Repeat the Cycle

After refactoring, return to RED by writing the next test:

1. **RED**: Write test for edge case (empty string)
2. **GREEN**: Handle empty string in implementation
3. **REFACTOR**: Extract validation logic if needed
4. **Repeat**: Continue with next test case

## TDD Best Practices

### Start with the Simplest Test

Begin with the most basic, obvious test case:

**Good progression**:
1. Test happy path with valid input
2. Test with invalid input
3. Test edge cases (null, empty, boundaries)
4. Test error handling
5. Test complex scenarios

**Avoid**:
- Starting with complex integration tests
- Testing multiple behaviors in first test
- Skipping simple cases to write "interesting" tests

### Write Only One Failing Test at a Time

**Why**: Maintains focus and prevents overwhelming yourself with failures.

**Practice**:
- Complete RED-GREEN-REFACTOR for one test before writing next
- Resist batch-writing multiple failing tests
- Use test.skip() or @Ignore to defer tests without losing ideas

### Keep Tests Independent

**Principle**: Each test should run successfully in isolation.

**Avoid**:
- Tests that depend on execution order
- Shared mutable state between tests
- Tests that require previous tests to pass

**Achieve through**:
- Setup/teardown (beforeEach, afterEach)
- Test fixtures or factories
- Fresh instances for each test

### Test Behavior, Not Implementation

**Focus on**: What the code does, not how it does it.

**Good** (tests behavior):
```python
def test_user_can_register_with_valid_credentials():
    result = register_user("alice@example.com", "SecurePass123!")
    assert result.success is True
    assert result.user_id is not None
```

**Bad** (tests implementation):
```python
def test_register_calls_database_insert():
    mock_db = Mock()
    register_user("alice@example.com", "pass", db=mock_db)
    mock_db.insert.assert_called_once()  # Too coupled to implementation
```

### Follow the Transformation Priority Premise

When making tests pass, prefer simple transformations:

**Priority order** (from simple to complex):
1. Constant → Variable
2. Unconditional → Conditional (if statement)
3. Scalar → Array/Collection
4. Array → Container (object/struct)
5. Statement → Tail recursion
6. Conditional → Loop

**Example progression**:
```javascript
// Test 1: Return constant
function add(a, b) { return 2; }  // Hardcoded

// Test 2: Use variables
function add(a, b) { return a + b; }  // Real implementation

// Test 3: Handle edge case with conditional
function add(a, b) {
  if (a === 0) return b;
  return a + b;
}
```

## Language-Specific TDD Patterns

### JavaScript/TypeScript (Jest)

**Test structure**:
```javascript
describe('Component or Module', () => {
  beforeEach(() => {
    // Setup before each test
  });

  afterEach(() => {
    // Cleanup after each test
  });

  it('should describe expected behavior', () => {
    // Arrange: Setup test data
    const input = 'test';

    // Act: Execute function under test
    const result = functionUnderTest(input);

    // Assert: Verify expectations
    expect(result).toBe('expected');
  });
});
```

**Running tests**:
```bash
npm test                    # Run all tests
npm test -- --watch         # Watch mode
npm test -- --coverage      # With coverage
```

### Python (Pytest)

**Test structure**:
```python
import pytest

class TestUserValidator:
    @pytest.fixture
    def validator(self):
        """Setup validator instance for tests"""
        return UserValidator()

    def test_valid_email_returns_true(self, validator):
        # Arrange
        email = "user@example.com"

        # Act
        result = validator.is_valid_email(email)

        # Assert
        assert result is True

    def test_invalid_email_returns_false(self, validator):
        # Arrange
        email = "invalid-email"

        # Act
        result = validator.is_valid_email(email)

        # Assert
        assert result is False
```

**Running tests**:
```bash
pytest                      # Run all tests
pytest --watch             # Watch mode (with pytest-watch)
pytest --cov               # With coverage
```

### Go (Built-in testing)

**Test structure**:
```go
package validator

import "testing"

func TestIsValidEmail(t *testing.T) {
    tests := []struct {
        name     string
        email    string
        expected bool
    }{
        {"valid email", "user@example.com", true},
        {"missing @", "userexample.com", false},
        {"missing domain", "user@", false},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            // Act
            result := IsValidEmail(tt.email)

            // Assert
            if result != tt.expected {
                t.Errorf("IsValidEmail(%s) = %v, want %v",
                    tt.email, result, tt.expected)
            }
        })
    }
}
```

**Running tests**:
```bash
go test                     # Run all tests
go test -v                  # Verbose output
go test -cover              # With coverage
```

### Ruby (RSpec)

**Test structure**:
```ruby
RSpec.describe UserValidator do
  describe '#valid_email?' do
    it 'returns true for valid email addresses' do
      # Arrange
      validator = UserValidator.new

      # Act
      result = validator.valid_email?('user@example.com')

      # Assert
      expect(result).to be true
    end

    it 'returns false for invalid email addresses' do
      validator = UserValidator.new
      expect(validator.valid_email?('invalid')).to be false
    end
  end
end
```

**Running tests**:
```bash
bundle exec rspec           # Run all tests
bundle exec rspec --format documentation
bundle exec rspec --coverage
```

## TDD Anti-Patterns to Avoid

### The Liar

**Problem**: Tests that pass but don't actually verify the behavior.

```javascript
it('should validate email', () => {
  const validator = new UserValidator();
  validator.isValidEmail('test@example.com');
  // No assertion - test always passes!
});
```

**Fix**: Always include assertions.

### The Giant

**Problem**: Tests that try to verify too much at once.

```javascript
it('should handle complete user registration flow', () => {
  // Tests validation, database insert, email sending,
  // session creation, redirect logic all in one test
});
```

**Fix**: Break into smaller, focused tests.

### The Mockery

**Problem**: Over-mocking that tests mocks instead of behavior.

```javascript
it('should call dependencies', () => {
  const mockDb = jest.fn();
  const mockEmail = jest.fn();
  const mockLogger = jest.fn();

  registerUser('user', mockDb, mockEmail, mockLogger);

  expect(mockDb).toHaveBeenCalled();
  expect(mockEmail).toHaveBeenCalled();
  expect(mockLogger).toHaveBeenCalled();
  // Verifies calls but not actual behavior
});
```

**Fix**: Mock only external dependencies, test outcomes.

### The Inspector

**Problem**: Tests that inspect internal state instead of public interface.

```python
def test_user_password_is_hashed():
    user = User("alice", "password123")
    assert user._password != "password123"  # Inspecting private state
```

**Fix**: Test through public API only.

### The Slow Poke

**Problem**: Tests that take too long to run, discouraging frequent execution.

**Causes**:
- Database connections in every test
- Network calls to external APIs
- Complex file system operations
- Sleep/wait statements

**Fix**: Use mocks, in-memory databases, test doubles.

## TDD Workflow Integration

### Starting a New Feature

1. **Write specifications first**: Create or update PRD and technical spec
2. **Design test cases**: Outline test scenarios from requirements
3. **Begin TDD cycle**: Implement using RED-GREEN-REFACTOR
4. **Track progress**: Update specs manifest as tests pass

### Working with Existing Code

**Legacy code without tests**:
1. Write characterization tests to capture current behavior
2. Refactor incrementally with test coverage
3. Expand test coverage as you modify code
4. Gradually improve to TDD workflow

**Adding features to tested code**:
1. Write test for new behavior (RED)
2. Implement minimal change (GREEN)
3. Refactor if needed (REFACTOR)
4. Verify existing tests still pass

### Debugging in TDD

When a test fails unexpectedly:

1. **Read the failure message**: Understand what assertion failed
2. **Verify the test is correct**: Is the test itself valid?
3. **Check recent changes**: What changed since tests last passed?
4. **Isolate the failure**: Run only the failing test
5. **Use debugging tools**: Debugger, print statements, logging
6. **Fix the issue**: Either implementation or test (if test was wrong)

### Dealing with Difficult Tests

**Some code is hard to test**:
- Tightly coupled dependencies
- Direct database/file system access
- Randomness or time-dependent behavior
- External API calls

**Solutions**:
- Dependency injection for loose coupling
- Repository pattern for data access
- Seeded random generators or time mocking
- API client wrappers with test doubles

## TDD Metrics and Tracking

### Coverage Metrics

**Line coverage**: Percentage of code lines executed by tests
- **Target**: 80-90% for most projects
- **Tool**: Use coverage reports from test framework

**Branch coverage**: Percentage of code branches (if/else, switch) tested
- **Target**: 75-85% for most projects
- **Importance**: More meaningful than line coverage

**Track using**:
- Jest: `--coverage` flag
- Pytest: `--cov` flag
- Go: `-cover` flag
- RSpec: SimpleCov gem

### Test-First Verification

Verify tests were written before implementation:

```bash
# Use included script
/home/astrosteveo/workspace/claudeverse/plugins/tdd-plugin/scripts/check-test-ordering.sh

# Shows violations where tests created after code
```

### TDD Compliance Scoring

**Calculate compliance rate**:
- Files with tests written first / Total files
- Track in `.claude/specs-manifest.yaml`
- Generate reports with `/tdd:checkpoint`

## Troubleshooting Common TDD Issues

### "Tests are taking too long to write"

**Symptom**: Spending more time writing tests than implementation.

**Causes**:
- Writing tests for implementation details
- Over-mocking dependencies
- Testing frameworks poorly configured

**Solutions**:
- Focus on behavior, not implementation
- Reduce mock complexity
- Invest in test utilities and fixtures
- Practice improves speed over time

### "Tests are brittle and break often"

**Symptom**: Small changes break many tests.

**Causes**:
- Tests coupled to implementation
- Shared mutable state between tests
- Poorly structured tests

**Solutions**:
- Test public interfaces only
- Ensure test independence
- Use better abstractions in tests
- Refactor tests along with code

### "Hard to know what to test next"

**Symptom**: Uncertainty about which test to write.

**Solutions**:
- Reference functional requirements document
- Follow TODO list of test cases
- Start with happy path, then edge cases
- Use requirements as guide for test scenarios

### "TDD feels slow for prototyping"

**Symptom**: TDD workflow feels cumbersome when exploring ideas.

**Approach**:
- Spike solutions without tests to validate approach
- Once direction is clear, implement with TDD
- Throw away spike code and rebuild with tests
- Or retrofit tests onto spike after validation

## Additional Resources

### Reference Files

For detailed patterns and examples:
- **`references/tdd-patterns.md`** - Common TDD patterns across languages
- **`references/testing-strategies.md`** - Strategy patterns for different scenarios

### Example Files

Working examples in `examples/`:
- **`example-jest.test.js`** - Complete Jest TDD example
- **`example-pytest.py`** - Complete Pytest TDD example
- **`example-go-test.go`** - Complete Go test example
- **`example-rspec.rb`** - Complete RSpec TDD example

## Quick Reference

### TDD Cycle Summary

1. **RED**: Write failing test → Run tests → See failure
2. **GREEN**: Write minimal code → Run tests → See success
3. **REFACTOR**: Improve code → Run tests → Maintain green
4. **Repeat**: Next test

### Essential Commands

**JavaScript/Jest**:
```bash
npm test                # Run tests
npm test -- --watch     # Watch mode
npm test -- --coverage  # Coverage report
```

**Python/Pytest**:
```bash
pytest                  # Run tests
pytest --watch          # Watch mode
pytest --cov            # Coverage report
```

**Go**:
```bash
go test                 # Run tests
go test -v              # Verbose
go test -cover          # Coverage report
```

**Ruby/RSpec**:
```bash
bundle exec rspec                          # Run tests
bundle exec rspec --format documentation   # Verbose
bundle exec rspec --coverage               # Coverage report
```

### Key Principles

✅ **Write tests first** - Before any implementation
✅ **One test at a time** - Complete cycle before next test
✅ **Keep tests independent** - No shared state or order dependency
✅ **Test behavior** - Not implementation details
✅ **Refactor frequently** - Improve while tests protect you
✅ **Run tests often** - After every small change

❌ **Avoid**:
- Writing implementation before tests
- Testing private methods
- Over-mocking dependencies
- Long-running tests
- Batch-writing many failing tests

Use `/tdd:run-cycle` command for guided RED-GREEN-REFACTOR workflow assistance.
