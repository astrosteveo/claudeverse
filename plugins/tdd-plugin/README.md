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

### 3. Fix Bugs or Make Small Changes
```
/tdd:fix password validation rejects valid special characters
```
Lightweight test-first workflow for bug fixes and small improvements.

### 4. Document Architectural Decisions
```
/tdd:adr Use Redis for session storage
```
Creates a structured ADR in `docs/adrs/`.

### 5. Check Compliance
```
/tdd:check
```
Generates report on specs, tests, and coverage.

## Commands

| Command | Description |
|---------|-------------|
| `/tdd <feature>` | Full TDD workflow for new features |
| `/tdd:fix <issue>` | Lightweight TDD for bug fixes and small changes |
| `/tdd:adr <title>` | Create Architecture Decision Record |
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

### The /tdd:fix Command

Lightweight workflow for bug fixes, small enhancements, and iterative development. Skips specifications and goes straight to test → implement → verify.

**Use for**:
- Bug fixes
- Small enhancements to existing features
- Code review findings
- Refactoring with characterization tests

**Phases**:
1. **Understand** - Identify the issue and affected code
2. **Write Failing Test** - Create test that reproduces/verifies the behavior
3. **Implement Fix** - Make minimal changes to pass the test
4. **Verify** - Run full test suite

```
/tdd:fix users can't login with special characters in password

→ Understand: Password validation regex rejects valid special chars
→ Test: it('accepts passwords with !@#$% characters')
→ Fix: Update regex in validatePassword()
→ Verify: All tests pass
```

### The /tdd:adr Command

Creates Architecture Decision Records to document significant technical decisions.

**Use for**:
- Technology choices (frameworks, databases)
- Architectural patterns
- Breaking API changes
- Security decisions
- Deviations from established patterns

**Output**: `docs/adrs/NNNN-<slug>.md`

```
/tdd:adr Use PostgreSQL for primary database

→ Gathered context and options
→ Created: docs/adrs/0001-use-postgresql-for-primary-database.md
→ Status: proposed
```

ADR lifecycle: `proposed` → `accepted` → (`deprecated` | `superseded`)

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
│   ├── specs/
│   │   └── <feature-name>/
│   │       ├── prd.md
│   │       ├── technical-spec.md
│   │       └── requirements.md
│   └── adrs/
│       ├── 0001-initial-architecture.md
│       └── ...
├── .claude/
│   ├── specs-manifest.yaml
│   ├── tdd-plugin.local.md
│   └── current-feature.txt
├── CLAUDE.md              # Project context (auto-updated)
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
- `adr-template.md` - Architecture Decision Record (full template)

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

2. New commands added:
   - `/tdd:fix` - Lightweight workflow for bug fixes
   - `/tdd:adr` - Architecture Decision Records

3. Skills consolidated into `tdd-practices`

4. Hooks simplified (removed UserPromptSubmit, PostToolUse)

5. CLAUDE.md now auto-created and updated with project context

## License

MIT License - see LICENSE file for details.
