---
description: Create test files with boilerplate for detected framework
argument-hint: <optional-file-path>
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
---

# Create Test Files

Create test file with framework-specific boilerplate.

## Task

Generate test file with proper structure for detected test framework.

## Implementation

1. **Determine target**:
   - If file path provided: Create test for that file
   - If no path: Ask user for file name or create from current feature

2. **Detect framework**: Run `${CLAUDE_PLUGIN_ROOT}/scripts/detect-test-framework.sh -o json`

3. **Determine test file path**:
   - JavaScript: `*.test.js` or `*.spec.ts`
   - Python: `*_test.py` or `test_*.py`
   - Go: `*_test.go`
   - Ruby: `*_spec.rb`

4. **Generate boilerplate**:

**Jest**:
```javascript
describe('[Module Name]', () => {
  it('should [behavior description]', () => {
    // Arrange

    // Act

    // Assert
    expect(true).toBe(true);
  });
});
```

**Pytest**:
```python
def test_[function_name]_[scenario]_[expected]():
    # Arrange

    # Act

    # Assert
    assert True
```

**Go**:
```go
func Test[Function][Scenario](t *testing.T) {
    // Arrange

    // Act

    // Assert
    if got != want {
        t.Errorf("got %v, want %v", got, want)
    }
}
```

**RSpec**:
```ruby
RSpec.describe [ClassName] do
  it 'should [behavior]' do
    # Arrange

    # Act

    # Assert
    expect(true).to be true
  end
end
```

5. **Write file**: Create test file with boilerplate
6. **Update manifest**: Add test file to current feature in manifest
7. **Display**: Show file location and remind to write failing test first (RED)

Use Bash for framework detection, Write for file creation.
