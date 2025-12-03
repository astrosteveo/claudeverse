---
name: Coverage Analysis
description: This skill should be used when the user asks about "test coverage", "coverage analysis", "coverage gaps", "code coverage", "coverage thresholds", "coverage reports", "untested code", "improve coverage", or needs guidance on analyzing, interpreting, and improving test coverage metrics.
version: 0.1.0
---

# Coverage Analysis

## Overview

Test coverage metrics measure how much of the codebase is executed by tests. This skill provides guidance on interpreting coverage reports, identifying gaps, setting appropriate thresholds, and improving coverage strategically across different programming languages.

## Coverage Metrics

### Line Coverage

**Definition**: Percentage of code lines executed by tests

**Calculation**: (Lines executed / Total lines) × 100

**Example**:
```javascript
function calculateDiscount(price, customerType) {
  if (customerType === 'premium') {      // Line 1 - Executed
    return price * 0.20;                  // Line 2 - Executed
  } else if (customerType === 'regular') { // Line 3 - Executed
    return price * 0.10;                  // Line 4 - Not executed
  }
  return 0;                               // Line 5 - Not executed
}

// Test only covers 'premium' path
test('premium discount', () => {
  expect(calculateDiscount(100, 'premium')).toBe(20);
});

// Line coverage: 3/5 = 60%
```

**Interpretation**:
- 80-90% is typical target for production code
- 100% line coverage doesn't guarantee bug-free code
- Focus on critical paths first

### Branch Coverage

**Definition**: Percentage of decision branches executed

**Calculation**: (Branches executed / Total branches) × 100

**Example**:
```javascript
function processOrder(order) {
  if (order.isPriority && order.amount > 100) {  // 4 branches: TT, TF, FT, FF
    return 'express';
  }
  return 'standard';
}

// Test covers only one branch (TT)
test('priority high-value order', () => {
  expect(processOrder({ isPriority: true, amount: 150 }))
    .toBe('express');
});

// Branch coverage: 1/4 = 25%
```

**Interpretation**:
- More meaningful than line coverage
- Reveals untested edge cases
- 75-85% is typical target

### Function Coverage

**Definition**: Percentage of functions called by tests

**Calculation**: (Functions called / Total functions) × 100

**Less useful** than line/branch coverage - a called function may not be fully tested.

### Statement Coverage

**Definition**: Similar to line coverage, counts executable statements

**Difference from line coverage**: Multiple statements per line count separately.

## Coverage Tools by Language

### JavaScript/TypeScript (Jest with Istanbul)

**Generate coverage**:
```bash
npm test -- --coverage
```

**Configuration** (`package.json` or `jest.config.js`):
```javascript
{
  "jest": {
    "coverageThreshold": {
      "global": {
        "branches": 75,
        "functions": 80,
        "lines": 80,
        "statements": 80
      },
      "src/core/**/*.ts": {
        "branches": 90,
        "lines": 90
      }
    },
    "coveragePathIgnorePatterns": [
      "/node_modules/",
      "/tests/",
      "/*.config.js"
    ]
  }
}
```

**Coverage formats**:
- Terminal summary
- HTML report: `coverage/lcov-report/index.html`
- LCOV format: `coverage/lcov.info`

### Python (Coverage.py with Pytest)

**Generate coverage**:
```bash
pytest --cov=src --cov-report=html --cov-report=term
```

**Configuration** (`.coveragerc` or `pyproject.toml`):
```ini
[coverage:run]
source = src/
omit =
    */tests/*
    */migrations/*
    */__init__.py

[coverage:report]
precision = 2
skip_covered = False
skip_empty = True

[coverage:html]
directory = htmlcov
```

**Coverage formats**:
- Terminal summary
- HTML report: `htmlcov/index.html`
- XML format: `coverage.xml` (Cobertura)

### Go (Built-in)

**Generate coverage**:
```bash
go test -cover ./...
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out -o coverage.html
```

**Coverage profile**:
```bash
# Generate coverage profile
go test -coverprofile=coverage.out -covermode=count ./...

# View in browser
go tool cover -html=coverage.out

# View summary
go tool cover -func=coverage.out
```

**Per-package coverage**:
```bash
go test -cover $(go list ./... | grep -v /vendor/)
```

### Ruby (SimpleCov with RSpec)

**Configuration** (`spec/spec_helper.rb`):
```ruby
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'

  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Services', 'app/services'

  minimum_coverage 80
  minimum_coverage_by_file 75
end
```

**Generate coverage**:
```bash
bundle exec rspec
# Report generated in coverage/index.html
```

## Interpreting Coverage Reports

### Reading HTML Reports

**Color coding**:
- 🟢 Green: Executed lines/branches
- 🔴 Red: Unexecuted lines/branches
- 🟡 Yellow: Partially covered branches

**Example HTML report sections**:
```
File                    | Line   | Branch | Function
------------------------|--------|--------|----------
src/auth/validator.js   | 85.2%  | 78.6%  | 90.0%
src/auth/service.js     | 92.1%  | 85.3%  | 100.0%
src/user/model.js       | 73.5%  | 65.2%  | 80.0%    ⚠️ Below threshold
```

**Drill down**: Click files to see line-by-line coverage with red highlighting for gaps.

### Identifying Critical Gaps

**Priority order for coverage**:

1. **Critical business logic**
   - Payment processing
   - Authentication/authorization
   - Data validation

2. **Error handling paths**
   - Exception handlers
   - Validation failures
   - Fallback logic

3. **Edge cases and boundaries**
   - Empty inputs
   - Maximum values
   - Null/undefined handling

4. **Public APIs**
   - Exported functions
   - Public methods
   - API endpoints

**Lower priority**:
- Trivial getters/setters
- Configuration files
- Generated code
- Simple data structures

## Setting Coverage Thresholds

### Recommended Targets

| Code Type | Line Coverage | Branch Coverage |
|-----------|---------------|-----------------|
| Core business logic | 90-95% | 85-90% |
| Standard features | 80-85% | 75-80% |
| UI/presentation | 70-75% | 65-70% |
| Legacy code | 60-70% | 55-65% |
| Scripts/utilities | 50-60% | 45-55% |

**Factors affecting targets**:
- Industry requirements (e.g., medical: 95%+)
- Risk tolerance
- Code complexity
- Team experience
- Project maturity

### Per-Directory Thresholds

**Example configuration**:
```yaml
# .claude/tdd-plugin.local.md
coverage:
  lineThreshold: 80
  branchThreshold: 75

directoryOverrides:
  "src/core/**":
    lineThreshold: 90
    branchThreshold: 85

  "src/legacy/**":
    lineThreshold: 60
    branchThreshold: 55

  "src/ui/**":
    lineThreshold: 70
    branchThreshold: 65
```

**Benefits**:
- Stricter requirements for critical code
- Realistic targets for legacy code
- Gradual improvement path

### Language-Specific Thresholds

**Example**:
```yaml
languages:
  javascript:
    lineThreshold: 85
    branchThreshold: 80

  python:
    lineThreshold: 90
    branchThreshold: 85

  go:
    lineThreshold: 80
    branchThreshold: 75

  ruby:
    lineThreshold: 85
    branchThreshold: 80
```

## Improving Coverage

### Identify Gaps Systematically

**Use coverage report**:
1. Generate coverage report with HTML output
2. Sort files by coverage percentage (ascending)
3. Focus on files below threshold
4. Review uncovered lines in detail

**Use included script**:
```bash
${CLAUDE_PLUGIN_ROOT}/scripts/validate-coverage.sh \
  -f coverage/lcov.info \
  -l 80 \
  -b 75 \
  -o text
```

### Write Tests for Uncovered Code

**Process**:
1. Locate uncovered line in coverage report (highlighted in red)
2. Trace back to calling code to understand context
3. Write test that exercises that code path
4. Verify coverage increases
5. Repeat for remaining gaps

**Example** - Uncovered error handling:
```javascript
// Source code with uncovered error path
function fetchUserData(userId) {
  if (!userId) {
    throw new Error('User ID required');  // ⚠️ Uncovered
  }
  return database.getUser(userId);
}

// Existing test (only happy path)
test('fetches user data', async () => {
  const data = await fetchUserData('user-123');
  expect(data).toBeDefined();
});

// New test to cover error path
test('throws error when user ID is missing', async () => {
  await expect(fetchUserData(null))
    .rejects
    .toThrow('User ID required');
});

// Coverage increases from 66% to 100%
```

### Parametrize Tests for Multiple Paths

**Before** (partial coverage):
```javascript
function calculateGrade(score) {
  if (score >= 90) return 'A';
  if (score >= 80) return 'B';
  if (score >= 70) return 'C';
  if (score >= 60) return 'D';
  return 'F';
}

test('calculates grade A', () => {
  expect(calculateGrade(95)).toBe('A');
});
// Coverage: 20% (only one branch)
```

**After** (full coverage):
```javascript
test.each([
  [95, 'A'],
  [85, 'B'],
  [75, 'C'],
  [65, 'D'],
  [55, 'F'],
])('calculates grade for score %i', (score, expected) => {
  expect(calculateGrade(score)).toBe(expected);
});
// Coverage: 100% (all branches)
```

### Refactor for Testability

**Untestable code** (tightly coupled):
```javascript
function processOrder(orderId) {
  const order = database.getOrder(orderId);  // Direct DB access
  const result = externalAPI.process(order);  // Direct API call
  logger.log('Processed order', result);      // Direct logging

  return result;
}
// Hard to test without real database, API, and logger
```

**Testable code** (dependency injection):
```javascript
function processOrder(orderId, deps = {}) {
  const { database, api, logger } = deps;

  const order = database.getOrder(orderId);
  const result = api.process(order);
  logger.log('Processed order', result);

  return result;
}

// Easy to test with mocks
test('processes order successfully', () => {
  const mockDb = { getOrder: jest.fn().mockReturnValue(order) };
  const mockApi = { process: jest.fn().mockReturnValue(result) };
  const mockLogger = { log: jest.fn() };

  processOrder('order-123', {
    database: mockDb,
    api: mockApi,
    logger: mockLogger
  });

  expect(mockApi.process).toHaveBeenCalledWith(order);
});
```

## Coverage Anti-Patterns

### Chasing 100% Coverage

**Problem**: Diminishing returns at high coverage levels

**Reality**:
- Last 10% takes 50% of effort
- Often low-value code (error messages, logging)
- May lead to testing implementation details

**Solution**:
- Set realistic thresholds (80-90%)
- Focus on critical paths
- Accept some uncovered trivial code

### Coverage Without Meaningful Assertions

**Problem**: Tests that execute code but don't verify behavior

❌ **Bad**:
```javascript
test('processes order', () => {
  processOrder('order-123');
  // No assertions - just executes code for coverage
});
// High coverage, low confidence
```

✅ **Good**:
```javascript
test('processes order and updates status', () => {
  const result = processOrder('order-123');

  expect(result.status).toBe('completed');
  expect(result.processedAt).toBeInstanceOf(Date);
  expect(mockDb.update).toHaveBeenCalledWith(
    'order-123',
    expect.objectContaining({ status: 'completed' })
  );
});
// High coverage, high confidence
```

### Ignoring Branch Coverage

**Problem**: Focusing only on line coverage misses untested paths

**Example**:
```javascript
function applyDiscount(price, code) {
  if (code === 'SAVE10') return price * 0.9;
  if (code === 'SAVE20') return price * 0.8;
  return price;
}

test('applies discount', () => {
  expect(applyDiscount(100, 'SAVE10')).toBe(90);
});

// Line coverage: 75% (3/4 lines)
// Branch coverage: 33% (1/3 branches)
// Missing: SAVE20 case and default case
```

**Solution**: Check branch coverage, add tests for all paths.

### Testing Private Methods for Coverage

**Problem**: Tests coupled to implementation

❌ **Bad**:
```javascript
class OrderProcessor {
  _validateOrder(order) {  // Private method
    return order.items.length > 0;
  }

  process(order) {
    if (!this._validateOrder(order)) {
      throw new Error('Invalid order');
    }
    // Process order
  }
}

// Testing private method directly
test('validates order', () => {
  const processor = new OrderProcessor();
  expect(processor._validateOrder(order)).toBe(true);
});
```

✅ **Good**:
```javascript
// Test through public interface
test('throws error for order with no items', () => {
  const processor = new OrderProcessor();
  const emptyOrder = { items: [] };

  expect(() => processor.process(emptyOrder))
    .toThrow('Invalid order');
});
// Private method covered through public API
```

## Coverage in CI/CD

### Enforce Thresholds

**Jest configuration**:
```javascript
{
  "jest": {
    "coverageThreshold": {
      "global": {
        "branches": 75,
        "lines": 80
      }
    }
  }
}
```

**Pytest configuration**:
```bash
pytest --cov=src --cov-fail-under=80
```

**Go configuration**:
```bash
# In CI script
go test -cover ./... | grep -E "coverage: [0-9]+\.[0-9]+%" | \
  awk '{if ($2 < 80.0) exit 1}'
```

### Track Coverage Trends

**Store coverage reports**:
```yaml
# .github/workflows/test.yml
- name: Run tests with coverage
  run: npm test -- --coverage

- name: Upload coverage to Codecov
  uses: codecov/codecov-action@v3
  with:
    files: ./coverage/lcov.info

- name: Archive coverage report
  uses: actions/upload-artifact@v3
  with:
    name: coverage-report
    path: coverage/
```

**Monitor trends**:
- Coverage should increase or stay stable
- Declining coverage indicates insufficient tests for new code
- Set PR requirements: "Coverage must not decrease"

## Validating Coverage

### Use Included Scripts

**Validate against thresholds**:
```bash
${CLAUDE_PLUGIN_ROOT}/scripts/validate-coverage.sh \
  --file coverage/lcov.info \
  --line 80 \
  --branch 75 \
  --output json
```

**Output**:
```json
{
  "passed": false,
  "coverage": {
    "line": {
      "percentage": 78.5,
      "threshold": 80,
      "passed": false
    },
    "branch": {
      "percentage": 76.2,
      "threshold": 75,
      "passed": true
    }
  }
}
```

### Run at Checkpoints

**Use TDD plugin commands**:
```
/tdd:checkpoint
```

Generates comprehensive report including coverage status.

## Additional Resources

### Reference Files

For detailed information:
- **`references/coverage-tools.md`** - Tool-specific guidance for all languages
- **`references/coverage-strategies.md`** - Advanced strategies for complex codebases

### Example Files

Coverage configuration examples in `examples/`:
- **`jest.config.coverage.js`** - Jest coverage setup
- **`.coveragerc`** - Python coverage config
- **`simplecov-config.rb`** - Ruby SimpleCov setup

## Quick Reference

### Coverage Commands

**JavaScript/Jest**:
```bash
npm test -- --coverage
npm test -- --coverage --watch
```

**Python/Pytest**:
```bash
pytest --cov=src --cov-report=html
pytest --cov=src --cov-report=term-missing
```

**Go**:
```bash
go test -cover ./...
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out
```

**Ruby/RSpec**:
```bash
bundle exec rspec
# Opens coverage/index.html
```

### Recommended Thresholds

| Metric | Target | Notes |
|--------|--------|-------|
| Line Coverage | 80-90% | Critical: 90-95% |
| Branch Coverage | 75-85% | More important than line |
| Function Coverage | 80-90% | Less useful metric |

### Validation Script

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/validate-coverage.sh \
  -f <coverage-file> \
  -l <line-threshold> \
  -b <branch-threshold> \
  -o <json|text>
```

Use coverage analysis to identify gaps and ensure adequate test coverage for critical code paths.
