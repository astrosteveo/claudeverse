---
description: Validate TDD compliance and generate status report
argument-hint: none
allowed-tools:
  - Read
  - Bash
  - Glob
  - Grep
---

# TDD Compliance Check

Validate current state and generate comprehensive TDD compliance report.

## Task

Analyze specifications, tests, coverage, and violations to produce a status report.

## Implementation

1. **Read configuration**:
   - Load `.claude/tdd-plugin.local.md` settings
   - Load `.claude/specs-manifest.yaml` feature tracking

2. **Analyze specifications**:
   - Count features in manifest
   - For each feature, check:
     - PRD exists and has content
     - Technical spec exists
     - Functional requirements exist with FR-XXX IDs
   - Calculate spec completion percentage

3. **Analyze tests**:
   - Detect test framework
   - Find all test files matching conventions
   - For each feature, check if tests exist
   - Run test suite and capture results

4. **Analyze coverage** (if available):
   - Run `${CLAUDE_PLUGIN_ROOT}/scripts/validate-coverage.sh`
   - Parse coverage report (lcov.info, coverage.xml, etc.)
   - Compare against thresholds

5. **Check violations**:
   - Read `.claude/tdd-violations.json` if exists
   - Count unresolved violations
   - List recent violations

6. **Generate report**:

```markdown
# TDD Compliance Report

**Generated**: <timestamp>
**Project**: <project-name>

---

## Executive Summary

| Metric | Status | Details |
|--------|--------|---------|
| Specifications | 🟢/🟡/🔴 | X/Y features have complete specs |
| Test Coverage | 🟢/🟡/🔴 | XX% line, XX% branch |
| TDD Violations | 🟢/🟡/🔴 | X unresolved |
| Current Feature | 🟢/⚪ | <feature> or None |

---

## Feature Status

| Feature | Spec | Tests | Implementation | Status |
|---------|------|-------|----------------|--------|
| feature-1 | ✓ | ✓ | ✓ | Complete |
| feature-2 | ✓ | ⚠ | ⚠ | In Progress |
| feature-3 | ⚪ | ⚪ | ⚪ | Planning |

---

## Coverage Analysis

**Overall**: XX% line / XX% branch

### Files Below Threshold

| File | Line | Branch | Action |
|------|------|--------|--------|
| src/auth/validator.ts | 65% | 55% | Add tests |
| src/api/handlers.ts | 72% | 68% | Add tests |

---

## TDD Violations

**Unresolved**: X

| Date | File | Violation | Enforcement |
|------|------|-----------|-------------|
| 2025-01-15 | src/foo.ts | Code before test | advisory |

---

## Recommendations

1. **High Priority**: Add tests for src/auth/validator.ts
2. **Medium Priority**: Complete specs for feature-2
3. **Low Priority**: Consider stricter enforcement

---

## Next Steps

- Continue current feature: `/tdd`
- Start new feature: `/tdd <name>`
- Run full test suite: `npm test` (or detected command)

*Report saved to: .claude/tdd-session-log.md*
```

7. **Save report**:
   - Write to `.claude/tdd-session-log.md`
   - Update CLAUDE.md with summary if update script exists

## Status Indicators

- 🟢 Green: Meets all thresholds
- 🟡 Yellow: Partial compliance (50-79%)
- 🔴 Red: Below threshold (<50%)
- ⚪ Gray: Not started/not applicable
- ✓ Complete
- ⚠ Partial/Warning
