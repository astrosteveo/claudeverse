---
description: Initialize project for iterative development workflow
argument-hint: [--with-state-tracking] for context preservation hooks
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# Initialize Iterative Development Project

One-time setup for iterative-dev workflow in current project.

## Task

Create directory structure, initialize settings, and optionally enable context-aware state preservation.

## Arguments

- `--with-state-tracking`: Enable per-project hooks for automatic context preservation (recommended for long sessions)
- No arguments: Basic setup without state tracking hooks

## Implementation

### 1. Check if already initialized

- Look for `.claude/iterative-dev/manifest.yaml`
- If exists, inform user and ask if they want to reinitialize

### 2. Gather project info

- Detect project name from package.json, go.mod, Cargo.toml, pyproject.toml, or directory name
- Detect primary language/framework
- Check for existing test files and framework
- Check for existing CLAUDE.md

### 3. Create directories

```bash
mkdir -p docs/iterations
mkdir -p docs/adrs
mkdir -p .claude/iterative-dev
mkdir -p .claude/commands/iterative-dev
```

### 4. Install workflow commands

Copy command templates from the plugin to the project's `.claude/commands/` directory:

```
${CLAUDE_PLUGIN_ROOT}/templates/commands/iterative-dev.md    → .claude/commands/iterative-dev.md
${CLAUDE_PLUGIN_ROOT}/templates/commands/iterative-dev/save.md   → .claude/commands/iterative-dev/save.md
${CLAUDE_PLUGIN_ROOT}/templates/commands/iterative-dev/resume.md → .claude/commands/iterative-dev/resume.md
```

This creates local commands:
- `/iterative-dev` - Main workflow command
- `/iterative-dev:save` - Save state before context clear
- `/iterative-dev:resume` - Resume from saved state

### 5. Create manifest

Write `.claude/iterative-dev/manifest.yaml`:
```yaml
# Iterative-Dev Plugin - Project Manifest
# Tracks iterations, features, and project state

version: "1.0"
project: "<detected-project-name>"
initialized: "<timestamp>"
plugin: "iterative-dev"

features: []
# Example:
# - name: user-authentication
#   status: in-progress  # vision | scoped | specified | red | green | validated | shipped | complete
#   iteration: 1
#   created: <timestamp>

adrs: []

settings:
  enforcementLevel: advisory  # advisory | strict
  stateTracking: <true if --with-state-tracking>
  coverage:
    enabled: true
    lineThreshold: 80
    branchThreshold: 75
  antiStubbing:
    enabled: true
    level: advisory  # advisory | strict
```

### 6. Create settings file

Write `.claude/iterative-dev/settings.local.md`:
```yaml
---
# Iterative-Dev Settings
# This file should be gitignored

enforcementLevel: advisory
stateTracking: <true/false>

coverage:
  lineThreshold: 80
  branchThreshold: 75
  enabled: true

antiStubbing:
  enabled: true
  level: advisory

testFramework: auto

exemptions:
  - "scripts/**"
  - "docs/**"
  - "*.config.js"
  - "*.config.ts"
  - "*.config.mjs"
---

# Iterative-Dev Local Settings

This file configures iterative-dev for this project.
Edit the YAML frontmatter above to customize behavior.

## Enforcement Levels

- **advisory**: Warns about issues, allows operations
- **strict**: Blocks operations until issues resolved

## State Tracking

When enabled, the plugin will:
- Monitor context usage during long sessions
- Auto-save state before context compaction
- Enable `/iterative-dev:save` and `/iterative-dev:resume` commands

## Anti-Stubbing

Detects incomplete implementations:
- TODO/FIXME comments in new code
- NotImplementedError / throw new Error('Not implemented')
- Empty function bodies
- Placeholder return values
```

### 7. Create or update CLAUDE.md

**If CLAUDE.md doesn't exist**, create it:

```markdown
# Project: <project-name>

IMPORTANT: This file provides context to Claude. Keep it concise and current.

## Quick Commands

YOU MUST follow iterative development workflow:
- `/iterative-dev <feature>` - Start/continue feature development
- `/iterative-dev:save` - Save state before context clear
- `/iterative-dev:resume` - Resume from saved state
- `/iterative-dev:check` - Compliance report

## Tech Stack

- **Language**: <detected>
- **Test Framework**: <detected>
- **Package Manager**: <detected>

## Architecture Guidelines

[Include language-specific section - see below]

## Development Philosophy

This project uses **Iterative Development**:

1. **MVP First**: Define minimum viable scope before building
2. **Spec Driven**: Clear specifications drive implementation
3. **Test First**: Write failing tests before code (RED → GREEN)
4. **No Stubs**: Everything works or nothing ships
5. **Iterate**: Ship value early, expand incrementally

## Key Locations

- Iterations: `docs/iterations/`
- ADRs: `docs/adrs/`
- Settings: `.claude/iterative-dev/settings.local.md`

## Current Status

**Initialized**: <timestamp>
**Enforcement**: advisory
**Active Feature**: None

---
*Maintained by iterative-dev plugin*
```

**Language-specific Architecture sections** (include appropriate one):

**For TypeScript/JavaScript:**
```markdown
## Architecture Guidelines

### Project Structure
```
src/
├── index.ts            # Entry point
├── <domain>/           # Domain modules
│   ├── index.ts        # Barrel exports
│   ├── <name>.ts       # Implementation
│   └── <name>.test.ts  # Co-located tests
└── shared/             # Cross-cutting utilities
```

### Conventions
- Feature folders over type folders
- Co-located tests: `<name>.test.ts`
- Barrel exports via `index.ts`
```

**For Python:**
```markdown
## Architecture Guidelines

### Project Structure
```
src/<package>/
├── __init__.py
├── <domain>/
│   ├── __init__.py
│   └── <module>.py
tests/
├── conftest.py
└── test_<domain>/
```

### Conventions
- src layout for packages
- Mirror structure in tests/
- Fixtures in conftest.py
```

**For Go:**
```markdown
## Architecture Guidelines

### Project Structure
```
cmd/<app>/main.go       # Entry points
internal/<domain>/      # Private code
pkg/                    # Public libraries (optional)
```

### Conventions
- cmd pattern for binaries
- internal/ for app code
- Co-located tests: `<name>_test.go`
```

**For Rust:**
```markdown
## Architecture Guidelines

### Project Structure
```
src/
├── lib.rs              # Library root
├── main.rs             # Binary (if applicable)
└── <domain>/
    ├── mod.rs
    └── <component>.rs
tests/                  # Integration tests
```

### Conventions
- Domain modules with mod.rs
- Integration tests in tests/
- Unit tests inline with #[cfg(test)]
```

**If CLAUDE.md exists**, append iterative-dev section at the end.

### 8. Install per-project hooks (if --with-state-tracking)

If state tracking enabled, create `.claude/hooks.json`:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check iterative-dev state: 1) Is there an active iteration? 2) Are tests in place for this file? 3) Is context usage high (consider /iterative-dev:save)? Keep response minimal.",
            "timeout": 10
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check .claude/iterative-dev/active-iteration.yaml - if exists, display: 'Active: <feature> Phase <N>/8 | /iterative-dev to continue'. Check for session-state.yaml and suggest resume if found. Keep minimal.",
            "timeout": 10
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"${CLAUDE_PROJECT_ROOT}/.claude/iterative-dev/scripts/update-claude-md.sh\" 2>/dev/null || true",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### 9. Detect test framework

Run framework detection and update settings if found.

### 10. Display completion

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Iterative Development Initialized

Created:
  ✓ docs/iterations/          (feature iterations)
  ✓ docs/adrs/                (architecture decisions)
  ✓ .claude/iterative-dev/    (plugin state)
  ✓ .claude/commands/         (workflow commands)
  ✓ CLAUDE.md                 (project context)

Commands installed:
  /iterative-dev        - Start/continue feature development
  /iterative-dev:save   - Save state before context clear
  /iterative-dev:resume - Resume from saved state

Detected:
  - Project: <name>
  - Language: <lang>
  - Test Framework: <framework>

State Tracking: <enabled/disabled>

Next steps:
  1. Review CLAUDE.md and add project description
  2. Review settings in .claude/iterative-dev/settings.local.md
  3. Start a feature: /iterative-dev <feature-name>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Notes

- Does not overwrite existing files unless user confirms
- Settings file (.local.md) should be gitignored
- CLAUDE.md should be committed to share context with team
- Per-project hooks only installed with --with-state-tracking
