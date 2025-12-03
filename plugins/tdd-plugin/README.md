# TDD Plugin for Claude Code

A streamlined Test-Driven Development workflow plugin with specification support, test enforcement, and coverage analysis.

## Overview

The TDD Plugin provides a structured approach to test-driven development:

- **Single workflow command** (`/tdd`) that guides you through spec → test → implement
- **Test enforcement hooks** that remind you to write tests first
- **Coverage analysis** to identify gaps and improve test quality
- **Multi-language support** for Jest, Pytest, Go test, and RSpec

## Quick Start

### 1. Initialize Project
```
/tdd:init
```
Creates directory structure and settings.

### 2. Start Feature Development
```
/tdd user-authentication
```
Guides you through:
1. **Discovery** - Understand what to build
2. **Specification** - Create PRD and requirements
3. **Test Design** - Write failing tests (RED)
4. **Implementation** - Write code to pass tests (GREEN)
5. **Refactor** - Improve code quality (REFACTOR)
6. **Summary** - Document completion

### 3. Check Compliance
```
/tdd:check
```
Generates report on specs, tests, and coverage.

## Commands

| Command | Description |
|---------|-------------|
| `/tdd <feature>` | Full TDD workflow for feature |
| `/tdd:init` | Initialize project structure |
| `/tdd:check` | Compliance and coverage report |

## How It Works

### The /tdd Command

Runs a phased workflow similar to feature-dev, but with TDD methodology:

**Phase 1: Discovery**
- Understand the feature request
- Load existing specs if available
- Clarify requirements

**Phase 2: Specification**
- Create PRD, technical spec, functional requirements
- Or review existing specifications
- Identify testable requirements (FR-XXX)

**Phase 3: Test Design (RED)**
- Generate tests from requirements
- Use test-generator agent
- Verify tests fail

**Phase 4: Implementation (GREEN)**
- Write minimal code to pass tests
- Optionally use feature-dev agents for exploration
- Run tests after each change

**Phase 5: Refactor & Validate**
- Improve code quality
- Check coverage
- Address gaps

**Phase 6: Summary**
- Update manifest
- Report completion

### Integration with feature-dev

If the feature-dev plugin is installed, `/tdd` can leverage its agents:
- `code-explorer` for codebase understanding
- `code-architect` for design
- `code-reviewer` for quality review

Without feature-dev, the plugin works standalone.

## Configuration

Settings in `.claude/tdd-plugin.local.md`:

```yaml
---
enforcementLevel: advisory  # advisory | strict
coverage:
  lineThreshold: 80
  branchThreshold: 75
  enabled: true
testFramework: auto
autoRunTests: false
exemptions:
  - "scripts/**"
  - "docs/**"
  - "*.config.js"
---
```

### Enforcement Levels

- **advisory** (default): Shows warnings, allows code changes
- **strict**: Blocks code changes without tests

## Project Structure

After initialization:

```
project-root/
├── docs/
│   └── specs/
│       └── <feature-name>/
│           ├── prd.md
│           ├── technical-spec.md
│           └── requirements.md
├── .claude/
│   ├── specs-manifest.yaml
│   ├── tdd-plugin.local.md
│   └── current-feature.txt
└── tests/
    └── (your test files)
```

## Agents

### test-generator

Generates comprehensive test suites from functional requirements.

**Triggers**: "generate tests", "create test suite", "write tests for feature"

**Output**: Test files with:
- Framework-specific structure
- Tests for each FR-XXX requirement
- Happy path and error cases

### coverage-analyzer

Analyzes coverage reports and suggests improvements.

**Triggers**: "analyze coverage", "find coverage gaps", "improve test coverage"

**Output**: Report with:
- Files below threshold
- Prioritized gaps
- Specific test suggestions

## Skill

The `tdd-practices` skill activates when you ask about:
- TDD workflow, red-green-refactor
- Test patterns (AAA, Given-When-Then)
- Coverage analysis
- Specification writing

## Hooks

**PreToolUse** (Write/Edit): Checks for tests before code changes
- advisory: Shows warning
- strict: Blocks without tests

**SessionStart**: Loads active feature context

**SessionEnd**: Updates CLAUDE.md with status

## Templates

Templates in `templates/`:
- `prd-template.md` - Product Requirements Document
- `technical-spec-template.md` - Technical Specification
- `functional-requirements-template.md` - Functional Requirements
- `test-case-template.md` - Test Case Template

## Language Support

| Language | Framework | Detection |
|----------|-----------|-----------|
| JavaScript/TypeScript | Jest, Vitest | package.json |
| Python | Pytest | pytest.ini, pyproject.toml |
| Go | go test | go.mod |
| Ruby | RSpec | Gemfile + spec/ |

## Example Workflow

```
User: /tdd payment-processing

Claude: Starting TDD workflow for payment-processing...

Phase 1: Discovery
- What payment methods need support?
- Any specific validation requirements?

Phase 2: Specification
Created:
- docs/specs/payment-processing/prd.md
- docs/specs/payment-processing/technical-spec.md
- docs/specs/payment-processing/requirements.md

Phase 3: Test Design
Writing tests for:
- FR-001: Validate payment amount
- FR-002: Process credit card
- FR-003: Handle declined transactions

🔴 Tests failing as expected

Phase 4: Implementation
Implementing FR-001...
🟢 Tests passing

[continues through all requirements]

Phase 6: Summary
✅ Feature Complete: payment-processing
Requirements: 3/3 implemented
Coverage: 87% line, 82% branch
```

## Migration from v0.1

If upgrading from the previous version:

1. Old commands map to new:
   - `/tdd:start-feature` → `/tdd <name>`
   - `/tdd:run-cycle` → `/tdd` (continues current feature)
   - `/tdd:checkpoint` → `/tdd:check`
   - `/tdd:init-project` → `/tdd:init`

2. Skills consolidated into `tdd-practices`

3. Hooks simplified (removed UserPromptSubmit, PostToolUse)

## License

MIT License - see LICENSE file for details.
