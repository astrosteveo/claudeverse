# Feature Development Plugin

A structured workflow for building new features through systematic codebase understanding, design, and implementation.

## Philosophy

Building features requires more than just writing code. This plugin enforces a disciplined approach:

1. **Understand** the existing codebase deeply
2. **Clarify** all requirements and edge cases
3. **Design** before implementing
4. **Review** before shipping

## Quick Start

```
/feature-dev Add user authentication with OAuth
```

This launches a 7-phase guided workflow.

## The 7 Phases

| Phase | Goal | Key Actions |
|-------|------|-------------|
| 1. Discovery | Understand requirements | Clarify scope, constraints, users |
| 2. Exploration | Understand codebase | Launch code-explorer agents |
| 3. Questions | Resolve ambiguity | Ask about edge cases, integration |
| 4. Design | Plan implementation | Launch code-architect agents |
| 5. Implementation | Build the feature | Code following approved design |
| 6. Review | Ensure quality | Launch code-reviewer agents |
| 7. Summary | Document completion | List changes, suggest next steps |

## Agents

### code-explorer

Deeply analyzes existing codebase features by:
- Tracing execution paths
- Mapping architecture layers
- Understanding patterns and abstractions
- Documenting dependencies

**Use for**: Understanding how similar features work, finding integration points.

### code-architect

Designs feature architectures by:
- Analyzing existing patterns and conventions
- Creating implementation blueprints
- Providing decisive recommendations
- Mapping build sequences

**Use for**: Planning implementation approach, making architectural decisions.

### code-reviewer

Reviews code for quality by:
- Checking for bugs and logic errors
- Verifying convention compliance
- Identifying security vulnerabilities
- Using confidence-based filtering (only reports issues >= 80% confidence)

**Use for**: Pre-merge quality assurance, catching issues before they ship.

## When to Use

**Good fit**:
- New features touching multiple files
- Complex integrations with existing systems
- Features with unclear or evolving requirements
- Decisions requiring architectural consideration

**Use something simpler for**:
- Single-line fixes → just edit directly
- Well-defined simple tasks → `/tdd-plugin:fix`
- Bug fixes with known cause → `/tdd-plugin:fix`

## Integration with TDD Plugin

This plugin integrates with the TDD plugin:

- **Phase 5** can use TDD workflow for implementation
- **code-reviewer** checks for test coverage
- Specs created by TDD plugin inform exploration

```
/feature-dev payment processing
→ Explores codebase, designs architecture
→ /tdd payment-processing
→ Implements with test-first approach
```

## Configuration

No configuration required. The plugin adapts to your codebase by discovering patterns during exploration.

## Example Session

```
User: /feature-dev Add email notification preferences

Claude: Starting Feature Development workflow...

## Phase 1: Discovery
Creating todo list for this feature development...

I understand you want to add email notification preferences.
Let me clarify a few things:
- What types of notifications? (marketing, transactional, alerts)
- Per-user settings or account-level?

User: Per-user, for transactional emails only

Claude: Got it. Moving to Phase 2...

## Phase 2: Codebase Exploration
Launching code-explorer agents to understand:
1. Existing user preferences system
2. Current notification infrastructure
3. Email sending patterns

[Agents explore and report findings...]

## Phase 3: Clarifying Questions
Based on exploration, I have questions:
- Should preferences sync across devices?
- Default opt-in or opt-out?
- Granularity: per-notification-type or all-or-nothing?

[User answers...]

## Phase 4: Architecture Design
Launching code-architect agents with different approaches...

[Presents options, user chooses...]

## Phase 5: Implementation
Implementing approved design...

[Builds feature with tests...]

## Phase 6: Quality Review
Launching code-reviewer agents...

[Reviews and addresses issues...]

## Phase 7: Summary
Feature complete! Here's what was built...
```

## Credits

Based on [Anthropic's feature-dev plugin](https://github.com/anthropics/claude-code/tree/main/plugins/feature-dev).

## License

MIT
