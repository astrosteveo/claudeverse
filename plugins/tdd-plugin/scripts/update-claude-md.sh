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
    PROJECT_NAME=$(grep -oP 'name:\s*\K.*' "$MANIFEST_FILE" 2>/dev/null | head -1 || echo "unknown")
fi

# Count violations
TOTAL_VIOLATIONS=0
UNRESOLVED_VIOLATIONS=0
if [[ -f "$VIOLATIONS_FILE" ]] && command -v jq &>/dev/null; then
    TOTAL_VIOLATIONS=$(jq '.total // 0' "$VIOLATIONS_FILE" 2>/dev/null || echo "0")
    UNRESOLVED_VIOLATIONS=$(jq '[.history[]? | select(.resolved == false)] | length' "$VIOLATIONS_FILE" 2>/dev/null || echo "0")
fi

# Generate the TDD section
TDD_SECTION=$(cat << EOF

---

## TDD Workflow Status

**Last Updated**: $(date '+%Y-%m-%d %H:%M:%S')

### Project Configuration
- **Project**: ${PROJECT_NAME}
- **Enforcement Mode**: ${ENFORCEMENT_LEVEL}
- **TDD Violations**: ${UNRESOLVED_VIOLATIONS} unresolved (${TOTAL_VIOLATIONS} total)

### Key Documentation Locations

**Specifications & Requirements**
- Feature specs: \`docs/specs/<feature-name>/\`
- PRD template: \`docs/specs/prd-template.md\`
- Technical specs: \`docs/specs/technical-spec-template.md\`
- Manifest: \`.claude/specs-manifest.yaml\`

**Testing & Validation**
- Test framework: Auto-detected (check \`.claude/tdd-plugin.local.md\`)
- Coverage targets: See \`.claude/tdd-plugin.local.md\`
- Violations log: \`.claude/tdd-violations.json\`

**Session Data**
- Current feature: \`.claude/current-feature.txt\` (if exists)
- Session log: \`.claude/tdd-session-log.md\`
- Plugin settings: \`.claude/tdd-plugin.local.md\`

### Recent Activity

EOF
)

# Add recent session log summary if available
if [[ -f "$SESSION_LOG" ]]; then
    TDD_SECTION+="**Last Session Report**
\`\`\`
$(tail -20 "$SESSION_LOG" 2>/dev/null || echo "No recent activity")
\`\`\`

"
fi

# Add quick commands
TDD_SECTION+="### Quick Commands

- \`/tdd-plugin:status\` - Check current TDD workflow status
- \`/tdd-plugin:run-cycle\` - Run guided TDD cycle
- \`/tdd-plugin:start-feature <name>\` - Begin new feature with spec
- \`/tdd-plugin:checkpoint\` - Validate current state

### How to Use This Context

When starting a new session:
1. Check \`.claude/current-feature.txt\` for active feature
2. Review recent violations in \`.claude/tdd-violations.json\`
3. Read feature spec from \`docs/specs/<feature>/\`
4. Follow TDD workflow: Spec → Test → Implement

---
"

# Update or append TDD section in CLAUDE.md
if grep -q "## TDD Workflow Status" "$CLAUDE_MD"; then
    # Replace existing TDD section
    # Use perl for multi-line replacement
    perl -i -0pe 's/---\s*\n## TDD Workflow Status.*?(?=\n---|\Z)/'"$(echo "$TDD_SECTION" | sed 's/\\/\\\\/g; s/\//\\\//g; s/&/\\&/g')"'/s' "$CLAUDE_MD"
    log "Updated existing TDD section"
else
    # Append new TDD section
    echo "$TDD_SECTION" >> "$CLAUDE_MD"
    log "Added new TDD section"
fi

log "CLAUDE.md updated successfully"
