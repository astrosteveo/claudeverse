# iterative-dev

**Spec-driven, test-driven, iterative development framework with MVP-first thinking.**

Build software the right way: prove value quickly, then iterate toward the complete solution.

## Philosophy

1. **MVP-First**: Define minimum viable scope before building elaborate solutions
2. **Spec-Driven**: Clear specifications drive everything downstream
3. **Test-Driven**: Write failing tests before implementation (RED → GREEN → Refactor)
4. **Iterative**: Ship value early, expand incrementally through iteration loops
5. **Anti-Stubbing**: No incomplete implementations - everything works or nothing ships
6. **Context-Aware**: Preserve state before context compaction for seamless resumption

## Quick Start

```bash
# Initialize your project
/iterative-dev:init

# Start developing a feature
/iterative-dev user-authentication
```

## The 8-Phase Workflow

```
/iterative-dev <feature>
│
├── Phase 1: Vision        → What problem are we solving?
├── Phase 2: MVP Scope     → What's the minimum to prove value?
├── Phase 3: Specification → Spec the MVP only (PRD, FR-XXX)
├── Phase 4: Test Design   → RED (failing tests)
├── Phase 5: Implementation → GREEN (make tests pass)
├── Phase 6: Validation    → Coverage, stubs, quality
├── Phase 7: Ship          → Document, release
└── Phase 8: Iterate       → Plan next iteration, loop to Phase 2
```

## Commands

| Command | Purpose |
|---------|---------|
| `/iterative-dev <feature>` | Start or continue a feature |
| `/iterative-dev:init` | Initialize project for iterative-dev |
| `/iterative-dev:save` | Save session state for later resumption |
| `/iterative-dev:resume` | Resume from saved state after `/clear` |

## Key Features

### MVP Scoping

Before diving into implementation, explicitly define:
- What's **in scope** for this iteration
- What's **out of scope** (deferred to later)
- Success criteria for this iteration

This prevents scope creep and ensures you ship value quickly.

### Context Preservation

Long sessions can hit context limits. iterative-dev handles this:

1. **Auto-detection**: Recognizes when context is getting full
2. **State saving**: Preserves all progress to `session-state.yaml`
3. **Clean resume**: After `/clear`, run `/iterative-dev:resume` to continue

### Anti-Stubbing Enforcement

No more forgotten TODOs or placeholder implementations:

- Detects `// TODO`, `// FIXME`, `throw new Error('Not implemented')`
- Blocks progression until stubs are resolved
- Ensures everything that ships actually works

### Iterative Loops

Phase 8 enables continuous improvement:
- **Continue**: Loop back to Phase 2 with expanded scope
- **Complete**: Feature is done, close it out
- **Pause**: Save state for later

## Project Structure

After initialization, your project will have:

```
your-project/
├── docs/
│   ├── iterations/           # Feature iterations
│   │   └── <feature>/
│   │       ├── vision.md
│   │       ├── scope-v1.md
│   │       ├── requirements-v1.md
│   │       └── ...
│   └── adrs/                 # Architecture decisions
├── .claude/
│   └── iterative-dev/
│       ├── manifest.yaml     # Project tracking
│       ├── settings.local.md # Local settings (gitignore)
│       ├── active-iteration.yaml
│       └── session-state.yaml
└── CLAUDE.md                 # Project context
```

## Agents

| Agent | Purpose | Model |
|-------|---------|-------|
| `spec-writer` | Generate testable specifications | Opus |
| `test-generator` | Create tests from requirements | Sonnet |
| `coverage-analyzer` | Identify coverage gaps | Sonnet |

## Configuration

Edit `.claude/iterative-dev/settings.local.md`:

```yaml
---
enforcementLevel: advisory  # or strict
stateTracking: true

coverage:
  lineThreshold: 80
  branchThreshold: 75

antiStubbing:
  enabled: true
  level: advisory  # or strict

exemptions:
  - "scripts/**"
  - "docs/**"
---
```

## State Tracking

Enable per-project state tracking for long sessions:

```bash
/iterative-dev:init --with-state-tracking
```

This installs project-local hooks that:
- Monitor context usage
- Auto-remind about saving state
- Update CLAUDE.md on session end

## Templates

| Template | Purpose |
|----------|---------|
| `mvp-scope-template.md` | Define iteration scope |
| `prd-template.md` | Product requirements |
| `functional-requirements-template.md` | FR-XXX specs |
| `technical-spec-template.md` | Technical details |
| `adr-template.md` | Architecture decisions |
| `session-state-template.yaml` | State preservation |

## Workflow Example

```
You: /iterative-dev user-authentication

Claude: Starting iterative-dev workflow for "user-authentication"

## Phase 1: Vision

Let me understand the problem:
- What problem are you solving? [...]
- Who experiences this? [...]
- How will you know it's solved? [...]

[Creates vision.md]

## Phase 2: MVP Scope

What's the minimum to prove this works?
- Option A: Basic login only
- Option B: Login + registration
- Option C: Full auth with password reset

[User selects, creates scope-v1.md]

## Phase 3: Specification

Creating requirements for MVP scope...
- FR-001: User can log in with email/password
- FR-002: Invalid credentials show error
- FR-003: Session token returned on success

[Creates requirements-v1.md]

## Phase 4: Test Design (RED)

Generating tests for requirements...
[Creates test files, verifies all fail]

## Phase 5: Implementation (GREEN)

Implementing FR-001...
[Writes code, tests pass]

Implementing FR-002...
[Writes code, tests pass]

## Phase 6: Validation

Coverage: 85% line, 80% branch ✓
Stubs detected: 0 ✓
All tests passing ✓

## Phase 7: Ship

[Updates docs, commits changes]

## Phase 8: Iterate

Would you like to:
1. Continue with next iteration (add registration)
2. Mark feature complete
3. Pause for later
```

## Best Practices

### Writing Good MVP Scope

✅ **Do**:
- Include 3-7 capabilities per iteration
- Explicitly list what's deferred
- Define measurable success criteria

❌ **Don't**:
- Try to build everything at once
- Leave scope boundaries vague
- Include "nice-to-haves" in MVP

### Writing Good Requirements

✅ **Do**:
- Use Given-When-Then format
- Make requirements independently testable
- Reference scope items

❌ **Don't**:
- Write vague requirements ("should be fast")
- Create interdependent requirements
- Exceed MVP scope

### Writing Good Tests

✅ **Do**:
- Reference FR-XXX in test names
- Use specific assertions
- Test error cases

❌ **Don't**:
- Use vague assertions (`toBeTruthy()`)
- Test implementation details
- Skip error handling tests

## Troubleshooting

### Context Getting Full

```bash
# Save your state
/iterative-dev:save

# Clear context
/clear

# Resume where you left off
/iterative-dev:resume
```

### Stubs Detected

If blocked by stub detection:
1. Find the stub locations in the output
2. Complete the implementation
3. Try again

### Tests Pass in RED Phase

If tests pass when they should fail:
1. Implementation may already exist
2. Test may be too permissive
3. Review and fix the test

## Migration from tdd-plugin

If you're using tdd-plugin:

1. iterative-dev is a complete replacement
2. Existing specs in `docs/specs/` can be moved to `docs/iterations/`
3. Run `/iterative-dev:init` to set up new structure
4. Continue your workflow with `/iterative-dev`

## License

MIT

---

*Built with ❤️ for developers who ship*
