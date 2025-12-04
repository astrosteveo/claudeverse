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
---

# TDD Workflow

Guide feature development using Test-Driven Development methodology. This command walks through a phased workflow: specification, test design, implementation, and validation.

## Core Principles

- **Spec before tests**: Understand what to build before writing tests
- **Tests before code**: Write failing tests before implementation
- **Minimal implementation**: Write only enough code to pass tests
- **Continuous validation**: Run tests at every step
- **Ask questions early**: Clarify requirements before designing tests

---

## Phase 1: Discovery

**Goal**: Understand what needs to be built

Initial request: $ARGUMENTS

**Actions**:
1. Create todo list with all 6 phases
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
   - Game libraries: pygame, LÖVE, Phaser, libGDX
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

**Goal**: Identify test cases and write failing tests

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

## Phase 4: Implementation

**Goal**: Write minimal code to pass tests (GREEN phase)

**IMPORTANT**: Before starting, verify we have failing tests from Phase 3

**Actions**:
1. **Explore codebase patterns** (for existing codebases):
   - Launch 2-3 `agent-feature-dev:code-explorer` agents in parallel using the Task tool
   - Each agent should explore different aspects (similar features, architecture, patterns)
   - Read the key files identified by the agents
   - Example Task prompts:
     - "Find features similar to [feature] and trace implementation comprehensively"
     - "Map the architecture and abstractions for [feature area]"
     - "Identify testing patterns and conventions in the codebase"

2. **Design implementation approach**:
   - Launch 2-3 `agent-feature-dev:code-architect` agents in parallel using the Task tool
   - Each agent focuses on different approach: minimal changes, clean architecture, pragmatic balance
   - Review all approaches and select the best fit
   - Example Task prompt:
     - "Design implementation approaches for [feature] with different trade-offs"

3. For each failing test:
   - Identify what code needs to be written
   - Write MINIMAL implementation to pass the test
   - Run tests after each change
   - Continue until test passes

4. Track progress using TodoWrite:
   - Mark each requirement in_progress when starting
   - Mark completed when its test passes

5. Run full test suite after each requirement

**Constraints**:
- Only write code needed to pass current test
- No extra features or edge cases not covered by tests
- Follow existing codebase conventions identified by code-explorer agents

---

## Phase 5: Refactor & Validate

**Goal**: Improve code quality while maintaining passing tests

**Actions**:

### Refactoring (REFACTOR phase):
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
3. **Launch quality review agents**:
   - Launch 3 `agent-feature-dev:code-reviewer` agents in parallel using the Task tool
   - Each agent focuses on different aspects: simplicity/DRY/elegance, bugs/functional correctness, project conventions/abstractions
   - Consolidate findings and identify high-severity issues
   - Example Task prompts:
     - "Review code for simplicity, DRY principles, and elegance"
     - "Review code for bugs and functional correctness"
     - "Review code for adherence to project conventions and proper use of abstractions"
4. Present findings to user and ask what to address
5. Fix critical issues while keeping tests green

**Output**: Clean, tested implementation

---

## Phase 6: Summary

**Goal**: Document completion and next steps

**Actions**:
1. Mark all todos complete
2. Update `.claude/specs-manifest.yaml`:
   - Set feature status to `implemented` or `tested`
   - Link test files to requirements
3. Generate summary:
   ```
   TDD Cycle Complete: <feature-name>

   Requirements implemented: X/X
   Test files: [list]
   Implementation files: [list]

   Coverage: Run /tdd-plugin:check for detailed report

   Next steps:
   - Run /tdd-plugin:check for compliance report
   - Consider additional edge case tests
   - Commit changes
   ```
4. Clear `.claude/current-feature.txt` if feature is complete

---

## Adapting to Context

### Greenfield project (no existing code):
- Skip codebase exploration in Phase 4
- Focus on establishing conventions early
- Create directory structure as needed

### Existing codebase:
- Launch feature-dev agents for exploration (Phase 4)
- Follow existing patterns strictly
- Run existing tests to ensure no regressions

### Single test cycle (quick mode):
If user provides specific behavior to test:
1. Skip to Phase 3 with that behavior
2. Write single failing test
3. Implement minimal code
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

## Integration with feature-dev Plugin

This TDD workflow is designed to integrate seamlessly with the feature-dev plugin's specialized agents:

**Phase 4 (Implementation):**
- Launches `agent-feature-dev:code-explorer` agents to understand codebase patterns and architecture
- Launches `agent-feature-dev:code-architect` agents to design implementation approaches
- These agents run in parallel for efficiency
- Read all files identified by agents before implementing

**Phase 5 (Refactor & Validate):**
- Launches `agent-feature-dev:code-reviewer` agents in parallel
- Each agent focuses on different quality aspects
- Consolidates findings and presents actionable recommendations

**How to use:**
Simply run `/tdd-plugin:tdd <feature>` - the workflow will automatically leverage feature-dev agents when analyzing code, designing architecture, and reviewing quality.

**Benefits of integration:**
- Deeper codebase understanding through comprehensive exploration
- Multiple architectural perspectives before implementation
- Systematic quality review from different angles
- Parallel agent execution for faster workflow

---

## Example Usage

### Start new feature:
```
/tdd user-authentication
```
Creates specs, writes tests, implements feature.

### Continue existing feature:
```
/tdd
```
Loads current feature from `.claude/current-feature.txt` and continues.

### Quick single test:
```
/tdd validate that email addresses contain @
```
Runs single RED-GREEN-REFACTOR cycle for that specific behavior.
