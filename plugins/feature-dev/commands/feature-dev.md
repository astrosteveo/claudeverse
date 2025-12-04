---
description: Guided feature development with codebase understanding and architecture focus
argument-hint: Feature description or name
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

# Feature Development Workflow

Guide feature development through systematic codebase analysis, clarification, design, and implementation.

## Core Principles

- **Ask First**: Identify ambiguities and edge cases before implementation
- **Understand Deeply**: Read files identified by exploration agents to build context
- **Design Before Code**: Architecture decisions precede implementation
- **Quality Focus**: Readable, maintainable, architecturally sound code
- **Track Progress**: Use TodoWrite throughout

---

## Phase 1: Discovery

**Goal**: Understand what needs to be built

**Input**: $ARGUMENTS

**Actions**:
1. Create todo list with all 7 phases
2. If feature is clear from arguments, summarize understanding
3. If unclear, ask clarifying questions:
   - What problem does this solve?
   - Who are the users?
   - What are the constraints?
4. Confirm understanding with user before proceeding

**Output**: Clear, agreed-upon feature definition

---

## Phase 2: Codebase Exploration

**Goal**: Understand existing patterns and relevant code

**Actions**:
1. Launch 2-3 `code-explorer` agents in parallel targeting:
   - Similar existing features
   - Relevant architecture layers
   - Related implementation patterns
2. Read the key files identified by explorers
3. Synthesize findings into a codebase summary

**Agent Prompts**:
```
Explore how [similar feature] is implemented. Focus on:
- Entry points and API surface
- Data flow and transformations
- Patterns and conventions used
```

```
Analyze the [layer] architecture. Document:
- Component responsibilities
- Integration patterns
- Error handling approach
```

**Output**: Codebase context document with key files and patterns

---

## Phase 3: Clarifying Questions

**Goal**: Resolve all ambiguities before design

**Actions**:
1. Based on exploration, identify underspecified aspects:
   - Edge cases and boundary conditions
   - Error handling requirements
   - Integration points with existing code
   - Scope boundaries (what's in/out)
   - Performance requirements
   - Security considerations
2. Present ALL questions to user at once
3. **Wait for answers before proceeding**

**Output**: Complete requirements with no ambiguity

---

## Phase 4: Architecture Design

**Goal**: Design the implementation approach

**Actions**:
1. Launch 2-3 `code-architect` agents exploring different approaches:
   - Minimal changes approach
   - Clean architecture approach
   - Pragmatic balance approach
2. Present trade-offs for each approach:
   - Complexity vs flexibility
   - Time to implement vs maintainability
   - Risk factors
3. Make a recommendation
4. **Request explicit user preference**

**Agent Prompts**:
```
Design a minimal-changes architecture for [feature].
Prioritize: smallest diff, reuse existing patterns.
```

```
Design a clean architecture for [feature].
Prioritize: separation of concerns, testability, extensibility.
```

**Output**: Approved architecture blueprint

---

## Phase 5: Implementation

**Goal**: Build the feature following the approved design

**IMPORTANT**: Do not start until user explicitly approves architecture

**Actions**:
1. Read all relevant files identified in exploration
2. Implement following the chosen architecture
3. Respect existing codebase conventions
4. Write tests alongside implementation
5. Update todos as each component is completed
6. Run tests frequently to catch issues early

**Constraints**:
- Follow patterns discovered in Phase 2
- Match existing code style exactly
- Add appropriate error handling
- Include logging consistent with project

**Output**: Working implementation with tests

---

## Phase 6: Quality Review

**Goal**: Ensure code meets quality standards

**Actions**:
1. Launch 3 `code-reviewer` agents with different focuses:
   - **Simplicity**: Is the code as simple as possible?
   - **Correctness**: Does it handle all cases correctly?
   - **Conventions**: Does it follow project guidelines?
2. Compile findings from all reviewers
3. Present issues by severity (Critical > Important)
4. **Ask user how to proceed**:
   - Fix all issues
   - Fix critical only
   - Defer to follow-up PR

**Agent Prompts**:
```
Review for simplicity and elegance. Flag:
- Unnecessary complexity
- Over-engineering
- Code that could be simplified
```

```
Review for correctness. Flag:
- Logic errors
- Missing edge cases
- Error handling gaps
```

```
Review for conventions. Flag:
- Style inconsistencies
- Pattern violations
- Missing tests
```

**Output**: Clean, reviewed code ready for merge

---

## Phase 7: Summary

**Goal**: Document completion and next steps

**Actions**:
1. Mark all todos complete
2. Generate summary:
   ```
   ## Feature Complete: [Feature Name]

   ### What Was Built
   - [Component 1]: Description
   - [Component 2]: Description

   ### Files Modified
   - `path/to/file.ts` - Description of changes

   ### Files Created
   - `path/to/new/file.ts` - Purpose

   ### Tests Added
   - `path/to/test.ts` - What it tests

   ### Next Steps
   - [ ] Consider adding...
   - [ ] May want to...
   ```
3. Ask if user wants to commit changes

---

## When to Use This Workflow

**Good fit**:
- New features touching multiple files
- Complex integrations with existing code
- Features with unclear requirements
- Architectural decisions needed

**Skip this for**:
- Single-line bug fixes
- Trivial changes
- Well-defined simple tasks
- Use `/tdd-plugin:fix` instead

---

## Example Usage

```
/feature-dev Add user notification preferences

→ Phase 1: Understanding notification preferences feature...
→ Phase 2: Exploring existing notification and user settings code...
→ Phase 3: Questions about notification channels, frequency options...
→ Phase 4: Presenting architecture options...
→ Phase 5: Implementing approved design...
→ Phase 6: Reviewing for quality...
→ Phase 7: Summary and commit
```
