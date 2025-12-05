#!/bin/bash
# Initialize iterative-dev for a project
# Usage: init-project.sh <project-root> [--with-state-tracking]

set -e

PROJECT_ROOT="${1:-.}"
PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_TRACKING=false
TIMESTAMP=$(date -Iseconds)

# Parse arguments
shift || true
for arg in "$@"; do
    case $arg in
        --with-state-tracking) STATE_TRACKING=true ;;
    esac
done

cd "$PROJECT_ROOT"

# Check if already initialized
if [[ -f ".claude/iterative-dev/manifest.yaml" ]]; then
    echo "Project already initialized. Use --force to reinitialize."
    exit 1
fi

# Detect project name
detect_project_name() {
    if [[ -f "package.json" ]]; then
        grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' package.json | head -1 | sed 's/.*: *"//' | sed 's/".*//'
    elif [[ -f "go.mod" ]]; then
        head -1 go.mod | awk '{print $2}' | xargs basename
    elif [[ -f "Cargo.toml" ]]; then
        grep -o 'name[[:space:]]*=[[:space:]]*"[^"]*"' Cargo.toml | head -1 | sed 's/.*= *"//' | sed 's/".*//'
    elif [[ -f "pyproject.toml" ]]; then
        grep -o 'name[[:space:]]*=[[:space:]]*"[^"]*"' pyproject.toml | head -1 | sed 's/.*= *"//' | sed 's/".*//'
    else
        basename "$PWD"
    fi
}

# Detect language
detect_language() {
    if [[ -f "package.json" ]]; then
        if [[ -f "tsconfig.json" ]]; then echo "TypeScript"; else echo "JavaScript"; fi
    elif [[ -f "go.mod" ]]; then echo "Go"
    elif [[ -f "Cargo.toml" ]]; then echo "Rust"
    elif [[ -f "pyproject.toml" ]] || [[ -f "setup.py" ]]; then echo "Python"
    elif [[ -f "Gemfile" ]]; then echo "Ruby"
    else echo "Unknown"
    fi
}

# Detect test framework
detect_test_framework() {
    if [[ -f "package.json" ]]; then
        if grep -q '"vitest"' package.json 2>/dev/null; then echo "Vitest"
        elif grep -q '"jest"' package.json 2>/dev/null; then echo "Jest"
        elif grep -q '"mocha"' package.json 2>/dev/null; then echo "Mocha"
        else echo "Unknown"
        fi
    elif [[ -f "pyproject.toml" ]] || [[ -f "setup.py" ]]; then
        if grep -q 'pytest' pyproject.toml 2>/dev/null; then echo "Pytest"
        else echo "Pytest"
        fi
    elif [[ -f "go.mod" ]]; then echo "Go test"
    elif [[ -f "Cargo.toml" ]]; then echo "Cargo test"
    elif [[ -f "Gemfile" ]]; then echo "RSpec"
    else echo "Unknown"
    fi
}

PROJECT_NAME=$(detect_project_name)
LANGUAGE=$(detect_language)
TEST_FRAMEWORK=$(detect_test_framework)

# Create directories
mkdir -p docs/iterations
mkdir -p docs/adrs
mkdir -p .claude/iterative-dev
mkdir -p .claude/commands/iterative-dev

# Symlink command templates
ln -sf "$PLUGIN_ROOT/templates/commands/iterative-dev.md" ".claude/commands/iterative-dev.md"
ln -sf "$PLUGIN_ROOT/templates/commands/iterative-dev/save.md" ".claude/commands/iterative-dev/save.md"
ln -sf "$PLUGIN_ROOT/templates/commands/iterative-dev/resume.md" ".claude/commands/iterative-dev/resume.md"

# Create manifest.yaml
cat > .claude/iterative-dev/manifest.yaml << EOF
# Iterative-Dev Plugin - Project Manifest
version: "1.0"
project: "$PROJECT_NAME"
initialized: "$TIMESTAMP"
plugin: "iterative-dev"

features: []
adrs: []

settings:
  enforcementLevel: advisory
  stateTracking: $STATE_TRACKING
  coverage:
    enabled: true
    lineThreshold: 80
    branchThreshold: 75
  antiStubbing:
    enabled: true
    level: advisory
EOF

# Create settings.local.md
cat > .claude/iterative-dev/settings.local.md << 'EOF'
---
enforcementLevel: advisory
stateTracking: false
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
---

# Iterative-Dev Local Settings

Edit the YAML frontmatter above to customize behavior.
This file should be gitignored.
EOF

# Update settings with state tracking
if $STATE_TRACKING; then
    sed -i 's/stateTracking: false/stateTracking: true/' .claude/iterative-dev/settings.local.md
fi

# Create CLAUDE.md if it doesn't exist
if [[ ! -f "CLAUDE.md" ]]; then
    cat > CLAUDE.md << EOF
# Project: $PROJECT_NAME

## Quick Commands

- \`/iterative-dev <feature>\` - Start/continue feature development
- \`/iterative-dev:save\` - Save state before context clear
- \`/iterative-dev:resume\` - Resume from saved state

## Tech Stack

- **Language**: $LANGUAGE
- **Test Framework**: $TEST_FRAMEWORK

## Development Philosophy

This project uses **Iterative Development**:
1. **MVP First**: Define minimum viable scope before building
2. **Spec Driven**: Clear specifications drive implementation
3. **Test First**: Write failing tests before code (RED -> GREEN)
4. **No Stubs**: Everything works or nothing ships
5. **Iterate**: Ship value early, expand incrementally

## Key Locations

- Iterations: \`docs/iterations/\`
- ADRs: \`docs/adrs/\`
- Settings: \`.claude/iterative-dev/settings.local.md\`

---
*Initialized by iterative-dev plugin*
EOF
fi

# Install hooks if state tracking enabled
if $STATE_TRACKING; then
    cat > .claude/hooks.json << 'EOF'
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check iterative-dev state briefly: active iteration? tests exist for file?",
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
            "prompt": "Check .claude/iterative-dev/ for active-iteration.yaml or session-state.yaml. If found, briefly note status.",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
EOF
fi

# Output completion
cat << EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Iterative Development Initialized

Created:
  ✓ docs/iterations/          (feature iterations)
  ✓ docs/adrs/                (architecture decisions)
  ✓ .claude/iterative-dev/    (plugin state)
  ✓ .claude/commands/         (workflow commands)
  ✓ CLAUDE.md                 (project context)

Commands installed (symlinked):
  /iterative-dev        - Start/continue feature development
  /iterative-dev:save   - Save state before context clear
  /iterative-dev:resume - Resume from saved state

Detected:
  - Project: $PROJECT_NAME
  - Language: $LANGUAGE
  - Test Framework: $TEST_FRAMEWORK

State Tracking: $STATE_TRACKING

Next steps:
  1. Review CLAUDE.md
  2. Start a feature: /iterative-dev <feature-name>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
