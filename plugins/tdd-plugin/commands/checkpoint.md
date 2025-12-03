---
description: Validate current state and generate comprehensive TDD compliance report
argument-hint: none
allowed-tools:
  - Bash
  - Read
  - Write
---

# TDD Checkpoint

Validate project state: specs complete, tests passing, coverage met.

## Task

Run comprehensive validation and generate report in markdown table format.

## Implementation

1. **Run validations in parallel**:

```bash
# Coverage validation
${CLAUDE_PLUGIN_ROOT}/scripts/validate-coverage.sh \
  -f coverage/lcov.info -l 80 -b 75 -o json > /tmp/coverage-result.json

# Test ordering validation
${CLAUDE_PLUGIN_ROOT}/scripts/check-test-ordering.sh \
  -o json > /tmp/ordering-result.json

# Generate report
${CLAUDE_PLUGIN_ROOT}/scripts/generate-report.sh \
  -o .claude/tdd-report.md
```

2. **Parse results**: Read JSON outputs

3. **Check test execution**: Run test suite and capture results
   - Jest: `npm test -- --json`
   - Pytest: `pytest --json-report`
   - Go: `go test -json ./...`
   - Ruby: `bundle exec rspec --format json`

4. **Read manifest**: Load `.claude/specs-manifest.yaml`

5. **Generate summary table**:

```markdown
## TDD Checkpoint Report

Generated: [timestamp]

### Summary

| Metric | Status | Details |
|--------|--------|---------|
| Specifications | ✓ / ⚠ / ✗ | X features planned, Y complete |
| Test Coverage | ✓ / ⚠ / ✗ | Line: XX%, Branch: YY% |
| Test Results | ✓ / ⚠ / ✗ | X passing, Y failing |
| Test Ordering | ✓ / ⚠ / ✗ | X violations found |
| TDD Compliance | XX% | Overall compliance score |

### Details

**Coverage Analysis**:
- Line Coverage: XX% (threshold: 80%)
- Branch Coverage: YY% (threshold: 75%)
- Files Below Threshold: [list]

**Test Results**:
- Total Tests: X
- Passing: X
- Failing: X
- Skipped: X

**Test Ordering**:
- Validated: X file pairs
- Violations: X
- Details: [list violations]

**Recommendations**:
1. [Action item based on findings]
2. [Action item based on findings]
3. [Action item based on findings]

### Next Steps

- Fix failing tests: [list files]
- Improve coverage: [list files below threshold]
- Address violations: [specific actions]
- Update specs: [incomplete specifications]

Full report: .claude/tdd-report.md
```

6. **Display table**: Show in terminal

7. **Exit code**: Return 0 if all pass, 1 if failures

Use Bash for script execution, Read for parsing, display markdown table output.
