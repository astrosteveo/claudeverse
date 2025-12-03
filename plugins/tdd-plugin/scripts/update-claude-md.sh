#!/bin/bash
set -euo pipefail

# Update CLAUDE.md with current TDD project state
# This keeps Claude informed about the project structure and recent changes

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="${PWD}"

CLAUDE_MD="${PROJECT_ROOT}/CLAUDE.md"
MANIFEST_FILE="${PROJECT_ROOT}/.claude/specs-manifest.yaml"
VIOLATIONS_FILE="${PROJECT_ROOT}/.claude/tdd-violations.json"
SESSION_LOG="${PROJECT_ROOT}/.claude/tdd-session-log.md"
SETTINGS_FILE="${PROJECT_ROOT}/.claude/tdd-plugin.local.md"
CURRENT_FEATURE_FILE="${PROJECT_ROOT}/.claude/current-feature.txt"
ADRS_DIR="${PROJECT_ROOT}/docs/adrs"

# Helper function for logging
log() {
    echo "[update-claude-md] $*" >&2
}

log "Updating CLAUDE.md with TDD context..."

# Create CLAUDE.md if it doesn't exist
if [[ ! -f "$CLAUDE_MD" ]]; then
    log "Creating new CLAUDE.md"
    cat > "$CLAUDE_MD" << 'EOF'
# Project Context for Claude

This file is automatically maintained by the TDD plugin to keep Claude informed about the project state.

EOF
fi

# Read current enforcement level
ENFORCEMENT_LEVEL="advisory"
if [[ -f "$SETTINGS_FILE" ]]; then
    ENFORCEMENT_LEVEL=$(grep -oP 'enforcementLevel:\s*\K\w+' "$SETTINGS_FILE" 2>/dev/null || echo "advisory")
fi

# Read manifest data
PROJECT_NAME="unknown"
if [[ -f "$MANIFEST_FILE" ]]; then
    PROJECT_NAME=$(grep -oP 'project:\s*\K.*' "$MANIFEST_FILE" 2>/dev/null | head -1 || echo "unknown")
fi

# Count violations
TOTAL_VIOLATIONS=0
UNRESOLVED_VIOLATIONS=0
if [[ -f "$VIOLATIONS_FILE" ]] && command -v jq &>/dev/null; then
    TOTAL_VIOLATIONS=$(jq '.total // 0' "$VIOLATIONS_FILE" 2>/dev/null || echo "0")
    UNRESOLVED_VIOLATIONS=$(jq '[.history[]? | select(.resolved == false)] | length' "$VIOLATIONS_FILE" 2>/dev/null || echo "0")
fi

# Read current feature
CURRENT_FEATURE="None"
if [[ -f "$CURRENT_FEATURE_FILE" ]]; then
    CURRENT_FEATURE=$(cat "$CURRENT_FEATURE_FILE" 2>/dev/null || echo "None")
fi

# Count features and ADRs
FEATURE_COUNT=0
if [[ -d "${PROJECT_ROOT}/docs/specs" ]]; then
    FEATURE_COUNT=$(find "${PROJECT_ROOT}/docs/specs" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l || echo "0")
fi

ADR_COUNT=0
if [[ -d "$ADRS_DIR" ]]; then
    ADR_COUNT=$(find "$ADRS_DIR" -name "*.md" -type f 2>/dev/null | wc -l || echo "0")
fi

# Generate the TDD section
TDD_SECTION=$(cat << EOF

---

## TDD Workflow Status

**Last Updated**: $(date '+%Y-%m-%d %H:%M:%S')

### Project Overview
| Metric | Value |
|--------|-------|
| Project | ${PROJECT_NAME} |
| Enforcement | ${ENFORCEMENT_LEVEL} |
| Features | ${FEATURE_COUNT} documented |
| ADRs | ${ADR_COUNT} recorded |
| Violations | ${UNRESOLVED_VIOLATIONS} unresolved |
| Active Feature | ${CURRENT_FEATURE} |

### Quick Commands

| Command | Purpose |
|---------|---------|
| \`/tdd <feature>\` | Full TDD workflow for new features |
| \`/tdd:fix <issue>\` | Quick fix with test-first approach |
| \`/tdd:check\` | Compliance and coverage report |
| \`/tdd:adr <title>\` | Create architecture decision record |
| \`/tdd:init\` | Initialize TDD in new project |

### Key Locations

| Type | Path |
|------|------|
| Feature specs | \`docs/specs/<feature>/\` |
| ADRs | \`docs/adrs/\` |
| Settings | \`.claude/tdd-plugin.local.md\` |
| Manifest | \`.claude/specs-manifest.yaml\` |

### TDD Principles

1. **Specs First** - Document requirements before coding
2. **Tests First** - Write failing tests before implementation
3. **Minimal Code** - Only implement what tests require
4. **Refactor** - Improve code while keeping tests green
5. **Document Decisions** - Use ADRs for significant choices

EOF
)

# Add current feature details if active
if [[ "$CURRENT_FEATURE" != "None" && -d "${PROJECT_ROOT}/docs/specs/${CURRENT_FEATURE}" ]]; then
    TDD_SECTION+="
### Active Feature: ${CURRENT_FEATURE}

- PRD: \`docs/specs/${CURRENT_FEATURE}/prd.md\`
- Tech Spec: \`docs/specs/${CURRENT_FEATURE}/technical-spec.md\`
- Requirements: \`docs/specs/${CURRENT_FEATURE}/requirements.md\`

Continue with: \`/tdd\`
"
fi

# Add recent ADRs if any
if [[ $ADR_COUNT -gt 0 ]]; then
    RECENT_ADRS=$(find "$ADRS_DIR" -name "*.md" -type f -printf "%T@ %f\n" 2>/dev/null | sort -rn | head -3 | cut -d' ' -f2 | sed 's/^/- /')
    if [[ -n "$RECENT_ADRS" ]]; then
        TDD_SECTION+="
### Recent ADRs

${RECENT_ADRS}

See all: \`docs/adrs/\`
"
    fi
fi

TDD_SECTION+="
---
"

# Update or append TDD section in CLAUDE.md
if grep -q "## TDD Workflow Status" "$CLAUDE_MD"; then
    # Replace existing TDD section using a temp file approach (more reliable than perl)
    TEMP_FILE=$(mktemp)

    # Extract content before TDD section
    sed -n '1,/^---$/p' "$CLAUDE_MD" | head -n -1 > "$TEMP_FILE"

    # Check if there's content before the TDD section
    if [[ $(wc -l < "$TEMP_FILE") -eq 0 ]]; then
        # TDD section is at the start, keep any header content
        head -n 5 "$CLAUDE_MD" > "$TEMP_FILE"
    fi

    # Append new TDD section
    echo "$TDD_SECTION" >> "$TEMP_FILE"

    # Move temp file to CLAUDE.md
    mv "$TEMP_FILE" "$CLAUDE_MD"

    log "Updated existing TDD section"
else
    # Append new TDD section
    echo "$TDD_SECTION" >> "$CLAUDE_MD"
    log "Added new TDD section"
fi

log "CLAUDE.md updated successfully"
