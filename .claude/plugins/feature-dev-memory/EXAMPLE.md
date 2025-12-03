# Example Usage

This document shows what happens when you use the feature-dev-memory plugin.

## Example Workflow

### 1. Run Feature Dev Command

```bash
/feature-dev:feature-dev Add user authentication with JWT tokens
```

### 2. Feature Dev Workflow Executes

The `/feature-dev:feature-dev` command goes through its phases:
- Phase 1: Discovery
- Phase 2: Codebase Exploration (triggers `code-explorer` subagents)
- Phase 3: Clarifying Questions
- Phase 4: Architecture Design (triggers `code-architect` subagents)
- Phase 5: Implementation
- Phase 6: Quality Review
- Phase 7: Summary

### 3. Plugin Captures Output

As each subagent completes, the plugin automatically captures their output:

**After Code Explorer completes:**
```
.claude/memory/feature-specs/explorations/20231202-143022-auth-patterns.md
```

**After Code Architect completes:**
```
.claude/memory/feature-specs/20231202-143545-user-authentication-architecture.md
.claude/memory/feature-specs/latest-architecture.md → 20231202-143545-user-authentication-architecture.md
```

### 4. Review Saved Specs

The saved files contain complete specifications you can reference later:

**Architecture File Example:**
```markdown
# Feature Architecture Specification

**Generated:** 2023-12-02 14:35:45
**Source:** feature-dev:code-architect subagent
**Plugin:** feature-dev-memory

---

[Full architecture blueprint with:]
- Patterns & Conventions Found
- Architecture Decision
- Component Design
- Implementation Map
- Data Flow
- Build Sequence
- Critical Details
```

**Exploration File Example:**
```markdown
# Codebase Exploration Notes

**Generated:** 2023-12-02 14:30:22
**Source:** feature-dev:code-explorer subagent
**Plugin:** feature-dev-memory

---

[Complete analysis including:]
- Entry points with file:line references
- Step-by-step execution flow
- Key components and responsibilities
- Architecture insights
- Dependencies
- List of essential files
```

## Benefits in Practice

### Scenario 1: Team Handoff
A developer runs feature-dev to plan a feature but doesn't implement it. The saved architecture spec can be handed to another developer who can implement it exactly as designed.

### Scenario 2: Documentation
After implementing several features, you have a complete history of architectural decisions in `.claude/memory/feature-specs/`. This becomes valuable documentation.

### Scenario 3: Revisiting Features
Months later, you need to modify the authentication system. You can reference the original architecture spec to understand the design decisions that were made.

### Scenario 4: Learning
Junior developers can read saved exploration notes to understand how to analyze codebases effectively.

## File Organization Tips

You can organize saved specs by creating subdirectories:

```bash
.claude/memory/feature-specs/
├── auth/
│   ├── 20231202-143545-jwt-tokens-architecture.md
│   └── 20231203-091200-oauth-integration-architecture.md
├── api/
│   ├── 20231204-141500-rest-endpoints-architecture.md
│   └── 20231204-153000-graphql-schema-architecture.md
└── latest-architecture.md
```

Simply move the files after they're created, or create a post-processing script.

## Advanced: Custom Processing

You can extend the plugin by modifying the scripts to:
- Send specs to a documentation system
- Create GitHub issues with the implementation checklist
- Notify team members when new specs are created
- Generate diagrams from the architecture descriptions

The scripts are in `.claude/plugins/feature-dev-memory/scripts/` and can be customized to your workflow.
