---
testId: "TC-NNN"
feature: "[Feature Name]"
requirement: "FR-XXX"
priority: high
status: draft
author: "[Author Name]"
created: YYYY-MM-DD
lastModified: YYYY-MM-DD
---

# Test Case TC-NNN: [Test Case Title]

## Test Information

**Test ID**: TC-NNN

**Feature**: [Feature Name]

**Related Requirements**: FR-XXX, FR-YYY

**Priority**: Critical | High | Medium | Low

**Test Type**: Unit | Integration | End-to-End | Performance | Security

**Automated**: Yes | No | Partial

**Execution Environment**: [Development | Staging | Production]

## Test Objective

**Purpose**: Clear statement of what this test validates

**Scope**: What aspects of functionality are covered

**Out of Scope**: What this test explicitly does not cover

## Prerequisites

### System Prerequisites
- [ ] System/service [name] is running
- [ ] Database contains [required data]
- [ ] Environment variable [name] is set to [value]

### Data Prerequisites
- [ ] Test user account exists with credentials [details]
- [ ] Test data set [name] is loaded
- [ ] Database tables [list] are initialized

### Access Prerequisites
- [ ] User has [permission level] access
- [ ] API key/token is configured
- [ ] Required endpoints are accessible

## Test Data

### Input Data
```json
{
  "field1": "value1",
  "field2": "value2",
  "field3": {
    "nested": "value3"
  }
}
```

### Expected Output Data
```json
{
  "status": "success",
  "result": {
    "field1": "expected_value1",
    "field2": "expected_value2"
  }
}
```

### Test Accounts
| Account | Username | Role | Purpose |
|---------|----------|------|---------|
| Account 1 | test_user_1 | Admin | Test admin functionality |
| Account 2 | test_user_2 | User | Test standard user flow |

## Test Scenarios

### Scenario 1: Happy Path - [Scenario Name]

**Given-When-Then Format:**

**Given** the following preconditions:
- User is authenticated as [role]
- System state is [description]
- Required data exists in [location]

**When** the user performs these actions:
1. User [action 1]
2. System responds with [response 1]
3. User [action 2]
4. System responds with [response 2]

**Then** the following outcomes occur:
- ✓ System displays [expected UI state]
- ✓ Database contains [expected data]
- ✓ Response status is [expected status code]
- ✓ Response body matches [expected structure]

**Acceptance Criteria:**
- [ ] Criterion 1 is met
- [ ] Criterion 2 is met
- [ ] Criterion 3 is met

---

### Scenario 2: Error Handling - [Scenario Name]

**Given** the following preconditions:
- User is authenticated as [role]
- System state is [description]
- Required data is [missing/invalid/etc.]

**When** the user performs these actions:
1. User [action 1 with invalid input]
2. System detects invalid input

**Then** the following outcomes occur:
- ✓ System displays error message: "[expected message]"
- ✓ Response status is [error status code]
- ✓ No data is persisted to database
- ✓ User is prompted to [corrective action]

**Acceptance Criteria:**
- [ ] Appropriate error message shown
- [ ] No side effects occur
- [ ] System remains stable

---

### Scenario 3: Edge Case - [Scenario Name]

**Given** the following preconditions:
- User is authenticated as [role]
- System state is [edge condition]

**When** the user performs these actions:
1. User [action that triggers edge case]

**Then** the following outcomes occur:
- ✓ System handles edge case gracefully
- ✓ Response is [expected response]
- ✓ No errors are thrown

**Acceptance Criteria:**
- [ ] Edge case handled correctly
- [ ] No degradation in performance

---

### Scenario 4: Boundary Conditions - [Scenario Name]

**Given** the following preconditions:
- Input value is at [minimum/maximum] boundary

**When** the user performs these actions:
1. User submits [boundary value]

**Then** the following outcomes occur:
- ✓ System accepts/rejects value appropriately
- ✓ Validation behaves correctly
- ✓ System state is consistent

**Acceptance Criteria:**
- [ ] Boundary conditions validated
- [ ] No overflow/underflow errors

## Detailed Test Steps

### Setup
1. **Step 1**: [Detailed setup action]
   - **Expected Result**: [What should happen]

2. **Step 2**: [Detailed setup action]
   - **Expected Result**: [What should happen]

### Execution
1. **Step 1**: [Detailed test action]
   - **Input**: [Specific input]
   - **Expected Result**: [What should happen]
   - **Actual Result**: [To be filled during execution]
   - **Status**: [Pass/Fail]

2. **Step 2**: [Detailed test action]
   - **Input**: [Specific input]
   - **Expected Result**: [What should happen]
   - **Actual Result**: [To be filled during execution]
   - **Status**: [Pass/Fail]

3. **Step 3**: [Detailed test action]
   - **Input**: [Specific input]
   - **Expected Result**: [What should happen]
   - **Actual Result**: [To be filled during execution]
   - **Status**: [Pass/Fail]

### Verification
1. **Verify**: [What to check]
   - **Expected**: [Expected state]
   - **Actual**: [To be filled during execution]
   - **Status**: [Pass/Fail]

2. **Verify**: [What to check]
   - **Expected**: [Expected state]
   - **Actual**: [To be filled during execution]
   - **Status**: [Pass/Fail]

### Cleanup
1. **Step 1**: [Cleanup action]
2. **Step 2**: [Cleanup action]

## Expected Results

### Success Criteria
- [ ] All test scenarios pass
- [ ] Performance is within acceptable limits ([target])
- [ ] No errors logged during execution
- [ ] Data integrity maintained
- [ ] User experience meets requirements

### Key Assertions
```javascript
// Example assertions (adjust to your framework)
expect(response.status).toBe(200);
expect(response.data).toHaveProperty('id');
expect(response.data.status).toBe('active');
expect(database.records.length).toBe(1);
```

## Failure Conditions

### When Test Should Fail
- Condition 1: [Description]
- Condition 2: [Description]
- Condition 3: [Description]

### Common Failure Scenarios
1. **Scenario 1**: [Description]
   - **Cause**: [Root cause]
   - **Resolution**: [How to fix]

2. **Scenario 2**: [Description]
   - **Cause**: [Root cause]
   - **Resolution**: [How to fix]

## Test Code Template

### Unit Test (JavaScript/Jest)
```javascript
describe('TC-NNN: [Test Case Title]', () => {
  beforeEach(() => {
    // Setup
  });

  afterEach(() => {
    // Cleanup
  });

  describe('Scenario 1: Happy Path', () => {
    it('should [expected behavior]', () => {
      // Given
      const input = { /* test data */ };

      // When
      const result = functionUnderTest(input);

      // Then
      expect(result).toBeDefined();
      expect(result.status).toBe('success');
      expect(result.data).toMatchObject({
        /* expected data */
      });
    });
  });

  describe('Scenario 2: Error Handling', () => {
    it('should handle invalid input gracefully', () => {
      // Given
      const invalidInput = { /* invalid data */ };

      // When & Then
      expect(() => functionUnderTest(invalidInput))
        .toThrow('Expected error message');
    });
  });
});
```

### Integration Test (Python/Pytest)
```python
class TestTC_NNN:
    """TC-NNN: [Test Case Title]"""

    @pytest.fixture
    def setup_data(self):
        """Setup test data"""
        # Setup code
        yield
        # Cleanup code

    def test_scenario_1_happy_path(self, setup_data):
        """Scenario 1: Happy Path - should [expected behavior]"""
        # Given
        input_data = {"field": "value"}

        # When
        result = function_under_test(input_data)

        # Then
        assert result is not None
        assert result["status"] == "success"
        assert "data" in result

    def test_scenario_2_error_handling(self, setup_data):
        """Scenario 2: Error Handling - should handle invalid input"""
        # Given
        invalid_input = {"field": None}

        # When & Then
        with pytest.raises(ValueError) as exc_info:
            function_under_test(invalid_input)
        assert "Expected error message" in str(exc_info.value)
```

### End-to-End Test (Go)
```go
func TestTC_NNN(t *testing.T) {
    // Setup
    setup()
    defer cleanup()

    t.Run("Scenario 1: Happy Path", func(t *testing.T) {
        // Given
        input := TestInput{Field: "value"}

        // When
        result, err := FunctionUnderTest(input)

        // Then
        if err != nil {
            t.Fatalf("Expected no error, got: %v", err)
        }
        if result.Status != "success" {
            t.Errorf("Expected status 'success', got: %s", result.Status)
        }
    })

    t.Run("Scenario 2: Error Handling", func(t *testing.T) {
        // Given
        invalidInput := TestInput{Field: ""}

        // When
        _, err := FunctionUnderTest(invalidInput)

        // Then
        if err == nil {
            t.Fatal("Expected error, got nil")
        }
    })
}
```

### Integration Test (Ruby/RSpec)
```ruby
RSpec.describe 'TC-NNN: [Test Case Title]' do
  before(:each) do
    # Setup
  end

  after(:each) do
    # Cleanup
  end

  context 'Scenario 1: Happy Path' do
    it 'should [expected behavior]' do
      # Given
      input = { field: 'value' }

      # When
      result = function_under_test(input)

      # Then
      expect(result).not_to be_nil
      expect(result[:status]).to eq('success')
      expect(result[:data]).to include(field: 'expected_value')
    end
  end

  context 'Scenario 2: Error Handling' do
    it 'should handle invalid input gracefully' do
      # Given
      invalid_input = { field: nil }

      # When & Then
      expect { function_under_test(invalid_input) }
        .to raise_error(ArgumentError, /Expected error message/)
    end
  end
end
```

## Dependencies

### System Dependencies
- [Dependency 1]: Version and purpose
- [Dependency 2]: Version and purpose

### Test Dependencies
- [Test framework]: Version
- [Mock library]: Version
- [Assertion library]: Version

### External Services
- [Service 1]: Purpose and requirement
- [Service 2]: Purpose and requirement

## Performance Criteria

### Response Time
- **Target**: < [X]ms for [operation]
- **Acceptable**: < [Y]ms
- **Measurement**: [How to measure]

### Resource Usage
- **Memory**: < [X]MB
- **CPU**: < [Y]%
- **Network**: < [Z]KB transferred

## Security Considerations

### Security Checks
- [ ] Authentication is required
- [ ] Authorization is enforced
- [ ] Input is validated and sanitized
- [ ] Sensitive data is not logged
- [ ] Rate limiting is applied

### Threat Scenarios
1. **Threat**: [Description]
   - **Test**: How this test validates protection
   - **Expected**: System behavior

## Known Issues & Limitations

### Current Limitations
1. **Limitation 1**: Description and workaround
2. **Limitation 2**: Description and workaround

### Blocked By
- [ ] Issue #XXX: [Description]
- [ ] Feature XYZ: [Description]

## Execution History

| Date | Tester | Environment | Result | Notes |
|------|--------|-------------|--------|-------|
| YYYY-MM-DD | [Name] | Dev | Pass | [Notes] |
| YYYY-MM-DD | [Name] | Staging | Fail | [Issue found] |
| YYYY-MM-DD | [Name] | Staging | Pass | [Issue fixed] |

## Notes

### Implementation Notes
- Note 1
- Note 2

### Future Enhancements
- Enhancement 1
- Enhancement 2

## References

- **Requirement**: docs/specs/[feature]/requirements.md#FR-XXX
- **Technical Spec**: docs/specs/[feature]/technical-spec.md
- **Related Tests**: TC-YYY, TC-ZZZ
- **Bug Reports**: #123, #456

## Change Log

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| YYYY-MM-DD | 1.0 | Initial test case | [Name] |
| YYYY-MM-DD | 1.1 | Added edge case scenarios | [Name] |
