---
name: Test Patterns
description: This skill should be used when the user asks about "test structure", "test patterns", "how to write tests", "given when then", "arrange act assert", "test organization", "test naming", "testing best practices", or needs guidance on structuring and organizing tests across different programming languages and frameworks.
version: 0.1.0
---

# Test Patterns

## Overview

Well-structured tests are readable, maintainable, and serve as living documentation. This skill provides guidance on common test patterns, naming conventions, test organization strategies, and framework-specific best practices for JavaScript/TypeScript (Jest), Python (Pytest), Go, and Ruby (RSpec).

## Test Structure Patterns

### The AAA Pattern (Arrange-Act-Assert)

**Purpose**: Standard structure for organizing test logic

**Structure**:
1. **Arrange**: Set up test data and preconditions
2. **Act**: Execute the code being tested
3. **Assert**: Verify the expected outcome

**Example (JavaScript/Jest)**:
```javascript
test('calculates order total with tax', () => {
  // Arrange
  const order = new Order();
  order.addItem({ price: 100, quantity: 2 });
  order.addItem({ price: 50, quantity: 1 });
  const taxRate = 0.08;

  // Act
  const total = order.calculateTotal(taxRate);

  // Assert
  expect(total).toBe(270); // (100*2 + 50) * 1.08 = 270
});
```

**Benefits**:
- Clear test structure
- Easy to follow logic
- Separates setup from execution
- Makes assertions obvious

### The Given-When-Then Pattern

**Purpose**: Behavior-driven test structure (BDD style)

**Structure**:
1. **Given**: Establish preconditions and context
2. **When**: Perform action or event
3. **Then**: Verify outcome and side effects

**Example (Python/Pytest)**:
```python
def test_user_login_with_valid_credentials():
    # Given: User with valid credentials exists
    user = User.create(email="alice@test.com", password="SecurePass123!")
    login_form = LoginForm()

    # When: User submits valid credentials
    result = login_form.submit(
        email="alice@test.com",
        password="SecurePass123!"
    )

    # Then: User is logged in successfully
    assert result.success is True
    assert result.user_id == user.id
    assert result.session_token is not None
```

**Benefits**:
- Natural language flow
- Maps to requirements
- Clear behavior description
- Good for BDD frameworks

### The Four-Phase Test Pattern

**Purpose**: Extended structure for complex tests

**Structure**:
1. **Setup**: Create fixtures and dependencies
2. **Exercise**: Execute system under test
3. **Verify**: Check results and state
4. **Teardown**: Clean up resources

**Example (Go)**:
```go
func TestDatabaseTransaction(t *testing.T) {
    // Setup
    db := setupTestDatabase(t)
    tx := db.Begin()

    // Exercise
    user := &User{Name: "Alice", Email: "alice@test.com"}
    err := tx.Create(user).Error

    // Verify
    if err != nil {
        t.Fatalf("Expected no error, got: %v", err)
    }

    var found User
    tx.First(&found, user.ID)
    if found.Name != "Alice" {
        t.Errorf("Expected name 'Alice', got: %s", found.Name)
    }

    // Teardown
    tx.Rollback()
    cleanupTestDatabase(t, db)
}
```

**Benefits**:
- Explicit resource management
- Clear cleanup responsibilities
- Prevents test pollution
- Good for integration tests

## Test Naming Conventions

### Descriptive Test Names

**Follow structure**: `test_[unit]_[scenario]_[expected_result]`

**Good examples**:
```javascript
// JavaScript/Jest
test('validates email - rejects empty string - returns false')
test('validates email - accepts standard format - returns true')
test('validates email - rejects missing @ symbol - returns false')

// Python/Pytest
def test_user_registration_with_valid_data_creates_user():
def test_user_registration_with_duplicate_email_raises_error():
def test_user_registration_with_weak_password_returns_validation_error():

// Go
func TestEmailValidator_WithValidEmail_ReturnsTrue(t *testing.T)
func TestEmailValidator_WithEmptyString_ReturnsFalse(t *testing.T)
func TestEmailValidator_WithMissingAtSymbol_ReturnsFalse(t *testing.T)

// Ruby/RSpec
it 'returns true for valid email addresses'
it 'returns false for empty strings'
it 'returns false when @ symbol is missing'
```

**Naming principles**:
- Be specific and descriptive
- Include the scenario being tested
- State the expected outcome
- Use consistent format across project
- Avoid abbreviations

### Behavior-Focused Names

**Focus on what, not how**:

❌ **Bad** (implementation-focused):
```javascript
test('calls validateEmail function')
test('sets isValid property to true')
test('returns value from database query')
```

✅ **Good** (behavior-focused):
```javascript
test('accepts valid email addresses')
test('marks user account as verified after email confirmation')
test('retrieves user profile by ID')
```

## Test Organization

### Test File Structure

**Convention**: Mirror source file structure

```
src/
├── auth/
│   ├── validator.js
│   ├── service.js
│   └── controller.js
└── user/
    ├── model.js
    └── repository.js

tests/
├── auth/
│   ├── validator.test.js       # Mirrors src/auth/validator.js
│   ├── service.test.js
│   └── controller.test.js
└── user/
    ├── model.test.js
    └── repository.test.js
```

**Benefits**:
- Easy to locate tests for source files
- Clear one-to-one mapping
- Maintains project structure
- Scales with codebase

### Grouping Tests with Describe Blocks

**Organize related tests**:

```javascript
describe('UserValidator', () => {
  describe('isValidEmail', () => {
    it('returns true for standard email format', () => {
      // Test implementation
    });

    it('returns false for missing @ symbol', () => {
      // Test implementation
    });

    it('returns false for missing domain', () => {
      // Test implementation
    });
  });

  describe('isValidPassword', () => {
    it('returns true for password meeting all criteria', () => {
      // Test implementation
    });

    it('returns false for password shorter than 8 characters', () => {
      // Test implementation
    });

    it('returns false for password without numbers', () => {
      // Test implementation
    });
  });
});
```

**Benefits**:
- Logical grouping
- Better test output readability
- Shared setup/teardown per group
- Clear test organization

### Test Suites by Type

**Separate test types**:

```
tests/
├── unit/              # Fast, isolated tests
│   ├── models/
│   └── services/
├── integration/       # Tests with real dependencies
│   ├── api/
│   └── database/
└── e2e/              # End-to-end user scenarios
    └── workflows/
```

**Characteristics**:

| Type | Speed | Scope | Dependencies | Run Frequency |
|------|-------|-------|--------------|---------------|
| Unit | <1ms | Single function/class | Mocked | Every save |
| Integration | <100ms | Multiple components | Real (DB, API) | Pre-commit |
| E2E | >1s | Full system | All real | Pre-merge |

## Framework-Specific Patterns

### JavaScript/TypeScript (Jest)

**Standard structure**:

```javascript
describe('ReceiptProcessor', () => {
  // Shared setup
  let processor;
  let mockOCRService;

  beforeEach(() => {
    // Setup before each test
    mockOCRService = {
      extract: jest.fn()
    };
    processor = new ReceiptProcessor(mockOCRService);
  });

  afterEach(() => {
    // Cleanup after each test
    jest.clearAllMocks();
  });

  describe('processImage', () => {
    it('extracts text from valid receipt image', async () => {
      // Arrange
      const imageBuffer = Buffer.from('fake-image-data');
      mockOCRService.extract.mockResolvedValue({
        vendor: 'Coffee Shop',
        amount: 4.50,
        date: '2025-01-15'
      });

      // Act
      const result = await processor.processImage(imageBuffer);

      // Assert
      expect(result.vendor).toBe('Coffee Shop');
      expect(result.amount).toBe(4.50);
      expect(mockOCRService.extract).toHaveBeenCalledWith(imageBuffer);
    });

    it('throws error for corrupted image', async () => {
      // Arrange
      const corruptedBuffer = Buffer.from('');
      mockOCRService.extract.mockRejectedValue(
        new Error('Invalid image format')
      );

      // Act & Assert
      await expect(processor.processImage(corruptedBuffer))
        .rejects
        .toThrow('Invalid image format');
    });
  });
});
```

**Key patterns**:
- `describe` for grouping
- `beforeEach`/`afterEach` for setup/cleanup
- `it` or `test` for individual tests
- `jest.fn()` for mocks
- `expect` for assertions
- `async/await` for promises

### Python (Pytest)

**Standard structure**:

```python
import pytest
from receipt_processor import ReceiptProcessor, InvalidImageError


class TestReceiptProcessor:
    @pytest.fixture
    def processor(self):
        """Create ReceiptProcessor instance for tests"""
        return ReceiptProcessor()

    @pytest.fixture
    def mock_ocr_service(self, mocker):
        """Mock OCR service dependency"""
        return mocker.patch('receipt_processor.OCRService')

    def test_process_image_extracts_text_from_valid_receipt(
        self, processor, mock_ocr_service
    ):
        # Arrange
        image_data = b'fake-image-data'
        mock_ocr_service.extract.return_value = {
            'vendor': 'Coffee Shop',
            'amount': 4.50,
            'date': '2025-01-15'
        }

        # Act
        result = processor.process_image(image_data)

        # Assert
        assert result['vendor'] == 'Coffee Shop'
        assert result['amount'] == 4.50
        mock_ocr_service.extract.assert_called_once_with(image_data)

    def test_process_image_raises_error_for_corrupted_image(
        self, processor, mock_ocr_service
    ):
        # Arrange
        corrupted_data = b''
        mock_ocr_service.extract.side_effect = InvalidImageError(
            'Invalid image format'
        )

        # Act & Assert
        with pytest.raises(InvalidImageError, match='Invalid image format'):
            processor.process_image(corrupted_data)

    @pytest.mark.parametrize('vendor,amount,date', [
        ('Starbucks', 5.50, '2025-01-15'),
        ('Whole Foods', 42.30, '2025-01-16'),
        ('Shell Gas', 60.00, '2025-01-17'),
    ])
    def test_process_image_handles_various_receipt_types(
        self, processor, mock_ocr_service, vendor, amount, date
    ):
        # Arrange
        mock_ocr_service.extract.return_value = {
            'vendor': vendor,
            'amount': amount,
            'date': date
        }

        # Act
        result = processor.process_image(b'image-data')

        # Assert
        assert result['vendor'] == vendor
        assert result['amount'] == amount
        assert result['date'] == date
```

**Key patterns**:
- Class-based organization with `Test` prefix
- `@pytest.fixture` for setup
- `test_` prefix for test functions
- `assert` for assertions
- `@pytest.mark.parametrize` for data-driven tests
- `pytest.raises` for exception testing

### Go

**Standard structure**:

```go
package receipt

import (
    "testing"
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/mock"
)

// MockOCRService for testing
type MockOCRService struct {
    mock.Mock
}

func (m *MockOCRService) Extract(imageData []byte) (*ExtractResult, error) {
    args := m.Called(imageData)
    if args.Get(0) == nil {
        return nil, args.Error(1)
    }
    return args.Get(0).(*ExtractResult), args.Error(1)
}

func TestReceiptProcessor_ProcessImage(t *testing.T) {
    tests := []struct {
        name          string
        imageData     []byte
        mockResult    *ExtractResult
        mockError     error
        expectedError bool
    }{
        {
            name:      "valid receipt image",
            imageData: []byte("fake-image-data"),
            mockResult: &ExtractResult{
                Vendor: "Coffee Shop",
                Amount: 4.50,
                Date:   "2025-01-15",
            },
            mockError:     nil,
            expectedError: false,
        },
        {
            name:          "corrupted image",
            imageData:     []byte(""),
            mockResult:    nil,
            mockError:     errors.New("invalid image format"),
            expectedError: true,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            // Arrange
            mockOCR := new(MockOCRService)
            mockOCR.On("Extract", tt.imageData).Return(tt.mockResult, tt.mockError)
            processor := NewReceiptProcessor(mockOCR)

            // Act
            result, err := processor.ProcessImage(tt.imageData)

            // Assert
            if tt.expectedError {
                assert.Error(t, err)
                assert.Nil(t, result)
            } else {
                assert.NoError(t, err)
                assert.Equal(t, tt.mockResult.Vendor, result.Vendor)
                assert.Equal(t, tt.mockResult.Amount, result.Amount)
            }

            mockOCR.AssertExpectations(t)
        })
    }
}
```

**Key patterns**:
- Table-driven tests with struct slices
- `t.Run` for subtests
- `testify/assert` for assertions
- `testify/mock` for mocking
- `Test` prefix for test functions
- `_test.go` suffix for test files

### Ruby (RSpec)

**Standard structure**:

```ruby
require 'rails_helper'

RSpec.describe ReceiptProcessor do
  let(:ocr_service) { instance_double(OCRService) }
  let(:processor) { described_class.new(ocr_service) }

  describe '#process_image' do
    context 'with valid receipt image' do
      let(:image_data) { 'fake-image-data' }
      let(:extracted_data) do
        {
          vendor: 'Coffee Shop',
          amount: 4.50,
          date: '2025-01-15'
        }
      end

      before do
        allow(ocr_service).to receive(:extract)
          .with(image_data)
          .and_return(extracted_data)
      end

      it 'extracts text from the image' do
        result = processor.process_image(image_data)

        expect(result[:vendor]).to eq('Coffee Shop')
        expect(result[:amount]).to eq(4.50)
        expect(ocr_service).to have_received(:extract).with(image_data)
      end
    end

    context 'with corrupted image' do
      let(:corrupted_data) { '' }

      before do
        allow(ocr_service).to receive(:extract)
          .with(corrupted_data)
          .and_raise(InvalidImageError, 'Invalid image format')
      end

      it 'raises InvalidImageError' do
        expect { processor.process_image(corrupted_data) }
          .to raise_error(InvalidImageError, 'Invalid image format')
      end
    end

    context 'with various receipt types' do
      let(:test_cases) do
        [
          { vendor: 'Starbucks', amount: 5.50, date: '2025-01-15' },
          { vendor: 'Whole Foods', amount: 42.30, date: '2025-01-16' },
          { vendor: 'Shell Gas', amount: 60.00, date: '2025-01-17' }
        ]
      end

      it 'handles different receipt formats' do
        test_cases.each do |test_case|
          allow(ocr_service).to receive(:extract).and_return(test_case)

          result = processor.process_image('image-data')

          expect(result[:vendor]).to eq(test_case[:vendor])
          expect(result[:amount]).to eq(test_case[:amount])
          expect(result[:date]).to eq(test_case[:date])
        end
      end
    end
  end
end
```

**Key patterns**:
- `describe` and `context` for grouping
- `let` for lazy-loaded variables
- `before` hooks for setup
- `it` for test cases
- `expect` for assertions
- `instance_double` for mocking

## Test Data Patterns

### Test Fixtures

**Purpose**: Reusable test data

**Factory pattern (JavaScript)**:
```javascript
class UserFactory {
  static create(overrides = {}) {
    return {
      id: 'user-123',
      email: 'test@example.com',
      name: 'Test User',
      role: 'user',
      createdAt: new Date('2025-01-01'),
      ...overrides
    };
  }

  static createAdmin(overrides = {}) {
    return this.create({
      role: 'admin',
      ...overrides
    });
  }
}

// Usage in tests
test('user can view their profile', () => {
  const user = UserFactory.create({ name: 'Alice' });
  // Test implementation
});
```

**Fixtures file (Python)**:
```python
# conftest.py
import pytest

@pytest.fixture
def sample_user():
    return {
        'id': 'user-123',
        'email': 'test@example.com',
        'name': 'Test User',
        'role': 'user'
    }

@pytest.fixture
def admin_user():
    return {
        'id': 'admin-456',
        'email': 'admin@example.com',
        'name': 'Admin User',
        'role': 'admin'
    }

# Usage in tests
def test_user_can_view_profile(sample_user):
    # Test implementation with sample_user
    pass
```

### Parametrized Tests

**Test multiple inputs efficiently**:

```python
@pytest.mark.parametrize('email,expected', [
    ('valid@example.com', True),
    ('missing-at.com', False),
    ('missing-domain@', False),
    ('', False),
    ('spaces in@email.com', False),
])
def test_email_validation(email, expected):
    result = validate_email(email)
    assert result == expected
```

**Benefits**:
- Reduce test duplication
- Easy to add new cases
- Clear input/output mapping
- Comprehensive coverage

### Builders for Complex Objects

**Purpose**: Construct test objects incrementally

```javascript
class OrderBuilder {
  constructor() {
    this.order = {
      items: [],
      customer: null,
      shippingAddress: null,
      billingAddress: null
    };
  }

  withItem(item) {
    this.order.items.push(item);
    return this;
  }

  withCustomer(customer) {
    this.order.customer = customer;
    return this;
  }

  withShippingAddress(address) {
    this.order.shippingAddress = address;
    return this;
  }

  build() {
    return this.order;
  }
}

// Usage
const order = new OrderBuilder()
  .withCustomer({ name: 'Alice' })
  .withItem({ sku: 'ABC123', quantity: 2 })
  .withItem({ sku: 'DEF456', quantity: 1 })
  .withShippingAddress({ city: 'Seattle', zip: '98101' })
  .build();
```

**Benefits**:
- Fluent, readable syntax
- Only specify relevant fields
- Reusable across tests
- Handles complex object graphs

## Assertion Patterns

### Specific Assertions

**Use precise assertions**:

❌ **Bad** (vague):
```javascript
expect(result).toBeTruthy();
expect(array.length > 0).toBe(true);
```

✅ **Good** (specific):
```javascript
expect(result).toBe(true);
expect(array).toHaveLength(3);
```

### Multiple Assertions

**When appropriate to have multiple assertions**:

```javascript
test('creates user with correct attributes', () => {
  const user = createUser('Alice', 'alice@test.com');

  // Related assertions about single operation
  expect(user.name).toBe('Alice');
  expect(user.email).toBe('alice@test.com');
  expect(user.id).toBeDefined();
  expect(user.createdAt).toBeInstanceOf(Date);
});
```

**When to split**:
- Testing different behaviors
- Can fail independently
- Different preconditions

### Custom Matchers

**Create domain-specific assertions**:

```javascript
// Custom matcher
expect.extend({
  toBeValidEmail(received) {
    const pass = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(received);
    return {
      message: () => `expected ${received} to be a valid email`,
      pass
    };
  }
});

// Usage
test('validates email format', () => {
  expect('user@example.com').toBeValidEmail();
  expect('invalid-email').not.toBeValidEmail();
});
```

## Mock and Stub Patterns

### When to Mock

**Mock external dependencies**:
- Database calls
- HTTP requests
- File system operations
- Third-party APIs
- Time-dependent functions

**Don't mock**:
- Code under test
- Simple data structures
- Pure functions with no side effects
- Standard library functions (usually)

### Mock Patterns

**Spy pattern** (verify calls):
```javascript
test('logs error when processing fails', () => {
  const logSpy = jest.spyOn(console, 'error').mockImplementation();
  const processor = new Processor();

  processor.process(invalidData);

  expect(logSpy).toHaveBeenCalledWith('Processing failed:', expect.any(Error));
  logSpy.mockRestore();
});
```

**Stub pattern** (return predetermined values):
```javascript
test('calculates total with tax from external service', async () => {
  const taxService = {
    getTaxRate: jest.fn().mockResolvedValue(0.08)
  };

  const calculator = new OrderCalculator(taxService);
  const total = await calculator.calculateTotal(order);

  expect(total).toBe(270);
});
```

**Fake pattern** (simplified implementation):
```javascript
class InMemoryDatabase {
  constructor() {
    this.records = new Map();
  }

  async save(id, record) {
    this.records.set(id, record);
  }

  async find(id) {
    return this.records.get(id);
  }

  async clear() {
    this.records.clear();
  }
}

// Use in tests instead of real database
test('repository saves and retrieves records', async () => {
  const db = new InMemoryDatabase();
  const repo = new UserRepository(db);

  await repo.save({ id: '123', name: 'Alice' });
  const user = await repo.findById('123');

  expect(user.name).toBe('Alice');
});
```

## Test Anti-Patterns

### Interdependent Tests

**Problem**: Tests that rely on each other's state

❌ **Bad**:
```javascript
let userId;

test('creates user', () => {
  userId = createUser('Alice');
  expect(userId).toBeDefined();
});

test('retrieves user', () => {
  // Depends on previous test!
  const user = getUser(userId);
  expect(user.name).toBe('Alice');
});
```

✅ **Good**:
```javascript
test('creates user', () => {
  const userId = createUser('Alice');
  expect(userId).toBeDefined();
});

test('retrieves user', () => {
  // Independent - creates own user
  const userId = createUser('Bob');
  const user = getUser(userId);
  expect(user.name).toBe('Bob');
});
```

### Testing Implementation Details

**Problem**: Tests coupled to internal structure

❌ **Bad**:
```javascript
test('user has _passwordHash property', () => {
  const user = new User('password123');
  expect(user._passwordHash).toBeDefined();
  expect(user._passwordHash).not.toBe('password123');
});
```

✅ **Good**:
```javascript
test('authenticates user with correct password', () => {
  const user = new User('password123');
  expect(user.authenticate('password123')).toBe(true);
  expect(user.authenticate('wrong')).toBe(false);
});
```

### Excessive Mocking

**Problem**: Mocking everything makes tests fragile

❌ **Bad**:
```javascript
test('calculates order total', () => {
  const mockItem = { getPrice: jest.fn().mockReturnValue(100) };
  const mockTax = { calculate: jest.fn().mockReturnValue(8) };
  const mockOrder = {
    items: [mockItem],
    getTaxCalculator: jest.fn().mockReturnValue(mockTax)
  };

  // Too many mocks - not testing real behavior
});
```

✅ **Good**:
```javascript
test('calculates order total', () => {
  const order = new Order();
  order.addItem({ price: 100, quantity: 1 });

  // Only mock external dependency (tax service)
  const mockTaxService = { getTaxRate: jest.fn().mockReturnValue(0.08) };

  const total = order.calculateTotal(mockTaxService);
  expect(total).toBe(108);
});
```

## Additional Resources

### Reference Files

For detailed patterns:
- **`references/framework-guides.md`** - Framework-specific best practices
- **`references/mock-strategies.md`** - Comprehensive mocking patterns

### Example Files

Complete test examples in `examples/`:
- **`example-jest.test.js`** - Jest best practices
- **`example-pytest.py`** - Pytest patterns
- **`example-go-test.go`** - Go testing patterns
- **`example-rspec.rb`** - RSpec examples

## Quick Reference

### Test Structure Templates

**AAA Pattern**:
```
// Arrange: Setup
// Act: Execute
// Assert: Verify
```

**Given-When-Then**:
```
// Given: Preconditions
// When: Action
// Then: Outcome
```

### Naming Convention

`test_[unit]_[scenario]_[expected_result]`

### Organization

```
tests/
├── unit/           # Fast, isolated
├── integration/    # With dependencies
└── e2e/           # Full system
```

Use these patterns to write clear, maintainable tests that serve as living documentation.
