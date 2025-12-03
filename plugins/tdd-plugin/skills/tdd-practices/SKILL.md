---
name: TDD Practices
description: This skill should be used when the user asks about "TDD workflow", "test driven development", "red green refactor", "how to do TDD", "write tests first", "test structure", "test patterns", "given when then", "arrange act assert", "test coverage", "coverage gaps", "PRD", "product requirements", "technical spec", "functional requirements", or needs guidance on test-first development practices, test organization, coverage analysis, or specification writing.
version: 0.2.0
---

# TDD Practices

Comprehensive guidance on Test-Driven Development methodology, test patterns, coverage analysis, and specification writing.

## The TDD Cycle: Red-Green-Refactor

TDD follows a three-phase cycle:

### RED - Write Failing Test

Define expected behavior before implementation:

1. Identify the smallest piece of functionality to implement
2. Write a test describing that behavior
3. Run tests - verify the new test fails
4. Confirm failure is for the right reason (not syntax/setup)

```javascript
// Example: Test first, no implementation yet
describe('UserValidator', () => {
  it('returns true for valid email addresses', () => {
    const validator = new UserValidator();
    expect(validator.isValidEmail('user@example.com')).toBe(true);
  });
});
// This fails because UserValidator doesn't exist
```

### GREEN - Make Test Pass

Write minimal code to pass the test:

1. Implement simplest solution that makes test pass
2. Avoid adding extra functionality
3. Run tests - verify all pass
4. Hardcoding is acceptable at this stage

```javascript
class UserValidator {
  isValidEmail(email) {
    return email.includes('@') && email.includes('.');
  }
}
// Simple implementation makes test pass
```

### REFACTOR - Improve Code

Improve without changing behavior:

1. Review code for duplication, unclear naming, complexity
2. Refactor incrementally
3. Run tests after each change
4. Keep all tests green

```javascript
class UserValidator {
  isValidEmail(email) {
    const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return EMAIL_PATTERN.test(email);
  }
}
// Better implementation, tests still pass
```

---

## Test Structure Patterns

### AAA Pattern (Arrange-Act-Assert)

```javascript
test('calculates order total with tax', () => {
  // Arrange - setup
  const order = new Order();
  order.addItem({ price: 100, quantity: 2 });
  const taxRate = 0.08;

  // Act - execute
  const total = order.calculateTotal(taxRate);

  // Assert - verify
  expect(total).toBe(216);
});
```

### Given-When-Then (BDD Style)

```python
def test_user_login_with_valid_credentials():
    # Given: User exists
    user = User.create(email="alice@test.com", password="SecurePass!")

    # When: User submits login
    result = login_form.submit(email="alice@test.com", password="SecurePass!")

    # Then: Login succeeds
    assert result.success is True
    assert result.session_token is not None
```

---

## Framework-Specific Patterns

### JavaScript/TypeScript (Jest)

```javascript
describe('OrderProcessor', () => {
  let processor;

  beforeEach(() => {
    processor = new OrderProcessor();
  });

  it('processes valid orders', () => {
    const order = { items: [{ price: 100 }] };
    expect(processor.process(order)).toBe('completed');
  });

  it('rejects empty orders', () => {
    expect(() => processor.process({ items: [] }))
      .toThrow('Order must have items');
  });
});
```

**Commands**: `npm test`, `npm test -- --coverage`, `npm test -- --watch`

### Python (Pytest)

```python
import pytest

class TestOrderProcessor:
    @pytest.fixture
    def processor(self):
        return OrderProcessor()

    def test_processes_valid_orders(self, processor):
        order = {'items': [{'price': 100}]}
        assert processor.process(order) == 'completed'

    def test_rejects_empty_orders(self, processor):
        with pytest.raises(ValueError, match='Order must have items'):
            processor.process({'items': []})
```

**Commands**: `pytest`, `pytest --cov=src`, `pytest --watch`

### Go

```go
func TestOrderProcessor(t *testing.T) {
    tests := []struct {
        name     string
        order    Order
        expected string
        wantErr  bool
    }{
        {"valid order", Order{Items: []Item{{Price: 100}}}, "completed", false},
        {"empty order", Order{Items: []Item{}}, "", true},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result, err := ProcessOrder(tt.order)
            if tt.wantErr {
                assert.Error(t, err)
            } else {
                assert.Equal(t, tt.expected, result)
            }
        })
    }
}
```

**Commands**: `go test`, `go test -cover`, `go test -v`

### Ruby (RSpec)

```ruby
RSpec.describe OrderProcessor do
  let(:processor) { described_class.new }

  context 'with valid order' do
    let(:order) { { items: [{ price: 100 }] } }

    it 'processes successfully' do
      expect(processor.process(order)).to eq('completed')
    end
  end

  context 'with empty order' do
    let(:order) { { items: [] } }

    it 'raises error' do
      expect { processor.process(order) }
        .to raise_error('Order must have items')
    end
  end
end
```

**Commands**: `bundle exec rspec`, `bundle exec rspec --format documentation`

---

## Coverage Analysis

### Coverage Metrics

| Metric | Definition | Target |
|--------|------------|--------|
| Line | % of lines executed | 80-90% |
| Branch | % of decision paths | 75-85% |
| Function | % of functions called | 80-90% |

### Interpreting Coverage

```
File                   | Line   | Branch | Status
-----------------------|--------|--------|--------
src/core/auth.ts       | 92%    | 88%    | ✓ Good
src/api/handlers.ts    | 72%    | 65%    | ⚠ Below threshold
src/utils/format.ts    | 100%   | 100%   | ✓ Excellent
```

### Improving Coverage

1. **Find gaps**: Review HTML coverage report (red = uncovered)
2. **Prioritize**: Critical business logic > utilities
3. **Write targeted tests**:

```javascript
// Uncovered error path
function fetchUser(id) {
  if (!id) throw new Error('ID required');  // ← Not covered
  return db.get(id);
}

// Add test for error path
test('throws error when ID missing', () => {
  expect(() => fetchUser(null)).toThrow('ID required');
});
```

4. **Use parametrized tests** for multiple paths:

```javascript
test.each([
  [95, 'A'],
  [85, 'B'],
  [75, 'C'],
  [55, 'F'],
])('grade for score %i is %s', (score, expected) => {
  expect(calculateGrade(score)).toBe(expected);
});
```

---

## Specification Writing

### Product Requirements Document (PRD)

**Purpose**: Define what to build and why

**Key sections**:
- Problem statement with quantified impact
- User stories with acceptance criteria
- Success metrics with baselines and targets
- Scope (in/out of scope)

**Example user story**:
```
As a mobile user
I want to photograph receipts with my phone
So that I can capture expenses immediately

Acceptance Criteria:
- [ ] Camera opens within 2 taps from home
- [ ] OCR extracts vendor, date, amount with 95% accuracy
- [ ] User can edit extracted data before saving
```

### Technical Specification

**Purpose**: Define how to build it

**Key sections**:
- Architecture diagrams
- Data models with constraints
- API endpoints with examples
- Technology choices with rationale

### Functional Requirements

**Purpose**: Detailed behaviors for testing

**Format**:
```
### FR-001: Camera Activation

**Priority**: Critical

**Description**: Camera shall activate within 2 seconds of button tap.

**Acceptance Criteria**:
Given user is on home screen
When user taps "Add Receipt"
Then camera activates within 2 seconds

**Test Cases**: TC-001, TC-002
```

---

## TDD Best Practices

### Do:
- Write ONE failing test at a time
- Start with simplest test case
- Keep tests independent
- Test behavior, not implementation
- Run tests frequently
- Refactor while green

### Avoid:
- Writing tests after implementation
- Testing private methods directly
- Over-mocking dependencies
- Batch-writing multiple failing tests
- Chasing 100% coverage blindly

---

## Quick Reference

### TDD Cycle
```
RED → Write failing test
GREEN → Minimal implementation
REFACTOR → Improve code
REPEAT
```

### Test Naming
```
test_[unit]_[scenario]_[expected_result]

test_email_validator_with_empty_string_returns_false
```

### Coverage Commands

| Language | Command |
|----------|---------|
| JavaScript | `npm test -- --coverage` |
| Python | `pytest --cov=src` |
| Go | `go test -cover` |
| Ruby | `bundle exec rspec` (with SimpleCov) |

### Plugin Commands

| Command | Purpose |
|---------|---------|
| `/tdd <feature>` | Full TDD workflow |
| `/tdd:init` | Initialize project |
| `/tdd:check` | Compliance report |
