# TDD Plugin for Claude Code

Enforce Spec and Test Driven Development workflows with automated validation, comprehensive documentation templates, and intelligent test-first guidance.

## Overview

The TDD Plugin helps teams follow rigorous specification and test-driven practices by providing:

- **Structured Documentation**: PRD, technical specifications, and functional requirements templates
- **Test-First Enforcement**: Configurable validation that ensures tests exist before implementation
- **Multi-Language Support**: Jest, Pytest, Go test, and RSpec detection and conventions
- **Coverage Analysis**: Automated threshold validation and gap identification
- **Workflow Guidance**: Step-by-step TDD cycle assistance with red-green-refactor tracking
- **Architecture Decision Records**: ADR templates and best practices

## Features

### 📋 Documentation Templates
- Product Requirements Documents (PRDs)
- Technical Specifications with Mermaid diagram placeholders
- Functional Requirements with user story format
- Architecture Decision Records (ADRs)
- Test Case templates with Given-When-Then structure

### 🔴🟢🔄 TDD Workflow Support
- Guided red-green-refactor cycles
- Test-first validation hooks
- Automated test execution after code changes
- Coverage threshold enforcement

### 🧪 Multi-Language Testing
- **JavaScript/TypeScript**: Jest, Vitest conventions
- **Python**: Pytest, unittest patterns
- **Go**: Go test standards
- **Ruby**: RSpec conventions

### 📊 Tracking & Reporting
- Specs manifest tracking (spec → test → code mappings)
- Session logs with TDD compliance metrics
- Coverage reports with gap analysis
- Git-based test-first verification

## Installation

### From Local Marketplace
```bash
cc --plugin-dir /home/astrosteveo/workspace/claudeverse/plugins/tdd-plugin
```

Or add to your project's `.claude/plugins.json`:
```json
{
  "plugins": [
    "tdd-plugin@local:/home/astrosteveo/workspace/claudeverse/plugins/tdd-plugin"
  ]
}
```

## Quick Start

### 1. Initialize Project
```
/tdd:init-project
```

Creates directory structure, installs templates, and initializes settings.

### 2. Configure Settings

Edit `.claude/tdd-plugin.local.md`:

```yaml
---
enforcementLevel: advisory  # advisory | strict | graduated
graduatedThreshold: 3       # violations before strict mode
coverage:
  lineThreshold: 80
  branchThreshold: 75
  enabled: true
testFramework: auto         # auto | jest | pytest | gotest | rspec
autoRunTests: false         # Auto-run tests after code changes
blockWithoutSpecs: false    # Require spec before tests
trackingEnabled: true       # Log violations and metrics
gracePeriodDays: 7          # Days before enforcement starts
exemptions:
  - "scripts/**"
  - "docs/**"
  - "*.config.js"
---
```

### 3. Start a Feature
```
/tdd:start-feature user-authentication
```

Scaffolds:
- `docs/specs/user-authentication/prd.md`
- `docs/specs/user-authentication/technical-spec.md`
- `docs/specs/user-authentication/requirements.md`
- Entry in `.claude/specs-manifest.yaml`

### 4. Follow TDD Cycle
```
/tdd:run-cycle
```

Guides through:
1. Write failing test (RED)
2. Implement minimal code (GREEN)
3. Refactor for quality (REFACTOR)

### 5. Validate Progress
```
/tdd:checkpoint
```

Reports:
- Specification completeness
- Test coverage status
- TDD compliance score
- Violations log

## Commands

| Command | Description |
|---------|-------------|
| `/tdd:init-project` | One-time project setup with templates and directories |
| `/tdd:start-feature <name>` | Scaffold new feature with PRD, spec, and test placeholders |
| `/tdd:create-prd` | Interactive PRD creation with guided prompts |
| `/tdd:create-spec` | Generate technical specification from PRD |
| `/tdd:create-test` | Create test files with framework-specific boilerplate |
| `/tdd:run-cycle` | Guided red-green-refactor workflow |
| `/tdd:checkpoint` | Validate current state and generate compliance report |

## Skills

Skills activate automatically based on your questions:

- **TDD Workflow**: "how do I do TDD", "red green refactor"
- **Spec Writing**: "create PRD", "write technical spec"
- **Test Patterns**: "test structure", "given when then"
- **Coverage Analysis**: "analyze coverage", "coverage gaps"
- **ADR Practices**: "architecture decision", "document decision"

## Agents

Agents are invoked by commands for specialized tasks:

- **Spec Writer**: Converts PRDs to detailed technical specifications
- **Test Generator**: Creates comprehensive test suites from specs
- **Coverage Analyzer**: Identifies untested code paths
- **Workflow Orchestrator**: Guides through complete TDD cycles

## Hooks

Automated validation hooks (configurable via settings):

- **PreToolUse**: Validates test existence before code edits
- **Stop**: Generates session summary with TDD metrics
- **SessionStart**: Loads current feature spec into context
- **UserPromptSubmit**: Suggests writing tests when implementation detected
- **PostToolUse**: Auto-runs tests after code changes (opt-in)

## Configuration

### Enforcement Levels

**Advisory** (default): Warns but allows violations
```yaml
enforcementLevel: advisory
```

**Strict**: Blocks code changes without tests
```yaml
enforcementLevel: strict
```

**Graduated**: Advisory for N violations, then strict
```yaml
enforcementLevel: graduated
graduatedThreshold: 3
```

### Coverage Thresholds

Per-language thresholds:
```yaml
coverage:
  lineThreshold: 80
  branchThreshold: 75
  perLanguage:
    javascript: { line: 85, branch: 80 }
    python: { line: 90, branch: 85 }
    go: { line: 80, branch: 75 }
```

### Per-Directory Overrides

```yaml
directoryOverrides:
  "src/core/**":
    enforcementLevel: strict
    coverage: { line: 90, branch: 85 }
  "src/legacy/**":
    enforcementLevel: advisory
```

### Exemptions

```yaml
exemptions:
  - "scripts/**"
  - "*.config.js"
  - "migrations/**"
  - "docs/**"
```

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
│       └── NNNN-decision-title.md
├── .claude/
│   ├── tdd-plugin.local.md          # Settings
│   ├── specs-manifest.yaml          # Spec → Test → Code tracking
│   ├── tdd-session-log.md           # Session summaries
│   ├── tdd-violations.json          # Violation tracking
│   └── current-feature.txt          # Active feature name
└── tests/
    └── (your test files)
```

## Git Integration

Optional Git hooks (installed via `/tdd:init-project`):

**pre-commit**: Validates test-first ordering and coverage thresholds

**pre-push**: Ensures specs are committed for in-progress features

Enable during initialization or add manually:
```bash
cp .claude/git-hooks/pre-commit .git/hooks/
chmod +x .git/hooks/pre-commit
```

## Examples

### Example: Starting a New Feature

```
User: /tdd:start-feature payment-processing

Claude: Created feature scaffold:
✓ docs/specs/payment-processing/prd.md (template)
✓ docs/specs/payment-processing/technical-spec.md (template)
✓ docs/specs/payment-processing/requirements.md (template)
✓ Updated .claude/specs-manifest.yaml
✓ Set as current feature

Next steps:
1. Fill out PRD: /tdd:create-prd
2. Generate spec: /tdd:create-spec
3. Create tests: /tdd:create-test
```

### Example: TDD Cycle

```
User: /tdd:run-cycle

Claude: Starting TDD cycle for payment-processing...

Step 1: RED - Write failing test
- Create test file: tests/payment/process.test.js
- Define expected behavior
- Run tests (should fail)

Ready to proceed? [yes]
```

## Troubleshooting

### Tests Not Detected
- Check test file naming matches conventions (`*.test.js`, `*_test.py`, etc.)
- Verify `testFramework` setting in `.claude/tdd-plugin.local.md`
- Run `/tdd:checkpoint` to see detected tests

### Coverage Not Calculated
- Ensure coverage tool is installed (nyc, coverage.py, go test -cover)
- Check coverage output format (LCOV or Cobertura XML)
- Verify `coverage.enabled: true` in settings

### Hooks Not Triggering
- Confirm plugin is enabled in Claude Code
- Check hook configuration in `hooks/hooks.json`
- Verify enforcement level is not `disabled`

## Contributing

Contributions welcome! Please ensure:
- Tests exist for new features
- Documentation is updated
- Examples are provided
- Code follows existing patterns

## License

MIT License - see LICENSE file for details

## Support

- Issues: https://github.com/claude-code/tdd-plugin/issues
- Docs: https://github.com/claude-code/tdd-plugin/wiki
- Community: https://discord.gg/claude-code
