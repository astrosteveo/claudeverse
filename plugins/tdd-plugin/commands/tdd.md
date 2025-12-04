---
description: Guided TDD workflow from specification to implementation
argument-hint: Optional feature name or description
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - TodoWrite
  - Task
  - AskUserQuestion
  - SlashCommand
---

# TDD Workflow

Guide feature development using Test-Driven Development methodology. This command integrates with `/feature-dev:feature-dev` to provide a complete workflow: specification, test design, implementation with codebase understanding, and validation.

## Core Principles

- **Spec before tests**: Understand what to build before writing tests
- **Tests before code**: Write failing tests before implementation
- **Understand before implementing**: Use feature-dev for codebase exploration and architecture
- **Document decisions**: Create ADRs for significant architectural choices
- **Continuous validation**: Run tests at every step
- **Track everything**: Use TodoWrite throughout

---

## Phase 1: Discovery

**Goal**: Understand what needs to be built

Initial request: $ARGUMENTS

**Actions**:
1. Create todo list with all phases
2. If feature is clear from arguments:
   - Check if `.claude/current-feature.txt` exists for active feature context
   - Check if specs exist in `docs/specs/<feature>/`
   - If specs exist, load and summarize them
3. If feature is unclear or new, ask user:
   - What problem are they solving?
   - What should the feature do?
   - Any constraints or requirements?
4. Summarize understanding and confirm with user

**Output**: Clear understanding of what to build

---

## Phase 2: Specification

**Goal**: Create or review specifications

**Actions**:

### For new features:
1. Create feature directory: `mkdir -p docs/specs/<feature-name>`
2. Copy templates from plugin templates directory:
   - `prd.md` - Product Requirements Document
   - `technical-spec.md` - Technical Specification
   - `requirements.md` - Functional Requirements
   - `gdd.md` - Game Design Document (**gamedev projects only**)
3. **Detect gamedev context** by checking for:
   - Game engines: Unity (`*.unity`, `ProjectSettings/`), Godot (`project.godot`), Unreal (`*.uproject`)
   - Game libraries: pygame, LOVE, Phaser, libGDX
   - Game-related directories: `Assets/`, `Scenes/`, `Sprites/`, `Levels/`
   - If gamedev detected, create GDD alongside PRD
4. Ask user to fill key sections OR help draft them:
   - Problem statement
   - User stories with acceptance criteria
   - Key functional requirements (FR-001, FR-002, etc.)
   - For gamedev: Core gameplay loop, mechanics, art/audio direction
5. Update `.claude/specs-manifest.yaml` with new feature
6. Write feature name to `.claude/current-feature.txt`

### For existing features:
1. Read existing specs from `docs/specs/<feature>/`
2. Summarize PRD, technical spec, and requirements
3. Identify which functional requirements lack tests
4. Present summary to user

**Templates location**: `${CLAUDE_PLUGIN_ROOT}/templates/`

**Output**: Complete or reviewed specifications

---

## Phase 3: Test Design

**Goal**: Identify test cases and write failing tests (RED phase)

**Actions**:
1. Read `docs/specs/<feature>/requirements.md`
2. Parse functional requirements (FR-001, FR-002, etc.)
3. For each requirement, extract Given-When-Then acceptance criteria
4. Create test case inventory:
   ```
   | Requirement | Description | Test File | Status |
   |-------------|-------------|-----------|--------|
   | FR-001 | User can X | tests/x.test.js | pending |
   ```
5. **Detect test framework** using `${CLAUDE_PLUGIN_ROOT}/scripts/detect-test-framework.sh`
6. For each untested requirement:
   - Create test file if needed
   - Write failing test with proper structure (AAA or Given-When-Then)
   - Use framework-appropriate patterns:
     - Jest: `describe`, `it`, `expect`
     - Pytest: `test_`, `assert`
     - Go: `func Test*`, `t.Run`
     - RSpec: `describe`, `context`, `it`
7. Run tests to verify they fail (RED phase)
8. If tests pass unexpectedly, investigate and fix

**Key output**: Failing tests for all requirements

---

## Phase 4: Implementation via feature-dev

**Goal**: Implement code to pass tests (GREEN phase) using feature-dev's structured approach

**IMPORTANT**: Before starting, verify we have failing tests from Phase 3

**Actions**:

### Hand off to feature-dev:
1. Summarize context for feature-dev:
   - The feature being implemented
   - The requirements from specs
   - The failing tests that need to pass
   - Any constraints or patterns identified

2. **Invoke `/feature-dev:feature-dev`** using the SlashCommand tool with the feature context

   feature-dev will handle:
   - **Codebase Exploration**: Launch code-explorer agents to understand existing patterns
   - **Clarifying Questions**: Resolve ambiguities before designing
   - **Architecture Design**: Launch code-architect agents to design approaches
   - **ADR Creation**: After architecture is decided, create an ADR using `/tdd-plugin:adr` to document the decision
   - **Implementation**: Build the feature following chosen architecture
   - **Quality Review**: Launch code-reviewer agents for comprehensive review

3. **After feature-dev completes**:
   - Run tests to verify implementation passes (GREEN phase)
   - If tests fail, work with user to debug and fix
   - Track progress in TodoWrite

**Constraints**:
- Only write code needed to pass current tests
- No extra features or edge cases not covered by tests
- Follow existing codebase conventions

**Key integration point**: When feature-dev reaches Architecture Design phase and makes a decision, it should invoke `/tdd-plugin:adr <architecture decision title>` to document the decision before proceeding to implementation.

---

## Phase 5: Refactor & Validate

**Goal**: Improve code quality while maintaining passing tests (REFACTOR phase)

**Actions**:

### Refactoring:
1. Review implementation for code smells:
   - Duplication
   - Long methods
   - Poor naming
   - Complex conditionals
2. Refactor incrementally, running tests after each change
3. If tests fail after refactoring, fix before continuing

### Validation:
1. Run full test suite
2. Check coverage if available:
   ```bash
   ${CLAUDE_PLUGIN_ROOT}/scripts/validate-coverage.sh
   ```
3. Present any remaining issues to user
4. Fix critical issues while keeping tests green

**Output**: Clean, tested, refactored implementation

---

## Phase 6: Summary

**Goal**: Document completion, provide usage guidance, and clear next steps

**Actions**:

### 1. Update tracking
- Mark all todos complete
- Update `.claude/specs-manifest.yaml`:
  - Set feature status to `implemented` or `tested`
  - Link test files to requirements
  - Add coverage percentage
  - Reference any ADRs created
- Clear `.claude/current-feature.txt` if feature is complete

### 2. Generate usage documentation
Provide clear examples showing how to use the implemented feature:
- Import/require statements
- Basic usage examples for each function/method
- Common use cases
- Error handling examples (if applicable)
- Any configuration or setup required

Example format:
```
## Usage

\`\`\`typescript
import { functionName } from './path/to/module';

// Basic usage
functionName(arg1, arg2);  // → expected result

// Error handling
try {
  functionName(invalidArg);
} catch (error) {
  // Handle error
}
\`\`\`
```

### 3. Present completion summary
```
## TDD Cycle Complete: <feature-name>

### Requirements implemented: X/X
| Requirement | Description | Status |
|-------------|-------------|--------|
| FR-001 | ... | ✓ |

### Files created/modified
**Specs:** [list spec files]
**Tests:** [list test files with test count]
**Implementation:** [list implementation files]
**ADRs:** [list if any]

### Coverage: X%

### Usage
[Include usage examples from step 2]

### Next steps
1. **Run compliance check**: `/tdd-plugin:check` for detailed TDD report
2. **Review coverage**: Consider additional edge case tests if coverage < 100%
3. **Commit changes**: All files are ready for version control
4. **Integration**: [Any integration steps specific to the feature]
```

### 4. Offer follow-up actions
Ask user if they want to:
- Run `/tdd-plugin:check` for compliance report
- Add additional edge case tests
- Create a commit with all changes
- Start another TDD cycle for related functionality

---

## Adapting to Context

### Greenfield project (no existing code):
- feature-dev will skip extensive codebase exploration
- Focus on establishing conventions early
- Create directory structure as needed

### Existing codebase:
- feature-dev will thoroughly explore existing patterns
- Follow existing patterns strictly
- Run existing tests to ensure no regressions

### Single test cycle (quick mode):
If user provides specific behavior to test:
1. Skip to Phase 3 with that behavior
2. Write single failing test
3. Implement minimal code (can skip feature-dev for simple cases)
4. Refactor if needed
5. Brief summary

---

## Error Handling

### Tests fail unexpectedly in GREEN phase:
1. Display error output
2. Show which requirement was being worked on
3. Ask user: debug now or skip to next requirement?

### Tests pass when they should fail (RED phase):
1. Check if code already exists
2. If so, test may be redundant - note and continue
3. If not, test may be incorrect - review and fix

### Coverage below threshold:
1. Show which files/lines are uncovered
2. Suggest additional tests
3. Ask user if they want to add more tests

---

## Integration Architecture

This TDD workflow integrates with feature-dev for a complete development experience:

```
┌─────────────────────────────────────────────────────────────┐
│                    /tdd-plugin:tdd                          │
├─────────────────────────────────────────────────────────────┤
│  Phase 1: Discovery                                         │
│  Phase 2: Specification (PRD, requirements)                 │
│  Phase 3: Test Design (RED - write failing tests)           │
├─────────────────────────────────────────────────────────────┤
│                          ↓                                  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              /feature-dev:feature-dev                 │  │
│  ├───────────────────────────────────────────────────────┤  │
│  │  • Codebase Exploration (code-explorer agents)        │  │
│  │  • Clarifying Questions                               │  │
│  │  • Architecture Design (code-architect agents)        │  │
│  │      └─→ /tdd-plugin:adr (document decision)          │  │
│  │  • Implementation                                     │  │
│  │  • Quality Review (code-reviewer agents)              │  │
│  └───────────────────────────────────────────────────────┘  │
│                          ↓                                  │
│  Phase 5: Validate (run tests, check coverage)              │
│  Phase 6: Summary (document everything)                     │
└─────────────────────────────────────────────────────────────┘
```

**Benefits of integration:**
- TDD provides structure: specs, tests-first, documentation, progress tracking
- feature-dev provides depth: codebase understanding, architecture design, quality review
- ADRs capture decisions: architectural choices are documented for future reference
- Complete audit trail: specs → tests → architecture → implementation → validation

---

## Example Usage

### Start new feature:

```
/tdd-plugin:tdd user-authentication
```

Creates specs, writes tests, invokes feature-dev for implementation, validates.

### Continue existing feature:

```
/tdd-plugin:tdd
```

Loads current feature from `.claude/current-feature.txt` and continues.

### Quick single test:

```
/tdd-plugin:tdd validate that email addresses contain @
```

Runs single RED-GREEN-REFACTOR cycle for that specific behavior.
