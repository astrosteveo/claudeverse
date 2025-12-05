#!/usr/bin/env bash
# update-claude-md.sh - Update CLAUDE.md with iterative-dev project state
# Called by SessionEnd hook

set -euo pipefail

# Find project root (where .claude directory is)
find_project_root() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.claude" ]]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

PROJECT_ROOT=$(find_project_root) || exit 0
CLAUDE_MD="$PROJECT_ROOT/CLAUDE.md"
MANIFEST="$PROJECT_ROOT/.claude/iterative-dev/manifest.yaml"
SETTINGS="$PROJECT_ROOT/.claude/iterative-dev/settings.local.md"
ACTIVE="$PROJECT_ROOT/.claude/iterative-dev/active-iteration.yaml"
STATE="$PROJECT_ROOT/.claude/iterative-dev/session-state.yaml"
ADRS_DIR="$PROJECT_ROOT/docs/adrs"

# Exit if not initialized
[[ -f "$MANIFEST" ]] || exit 0

# Parse YAML value (simple parser)
yaml_value() {
  local file="$1" key="$2"
  grep "^${key}:" "$file" 2>/dev/null | sed "s/^${key}:[[:space:]]*//" | tr -d '"' || echo ""
}

# Get project name
PROJECT_NAME=$(yaml_value "$MANIFEST" "project")
[[ -z "$PROJECT_NAME" ]] && PROJECT_NAME="Unknown"

# Get enforcement level
ENFORCEMENT="advisory"
if [[ -f "$SETTINGS" ]]; then
  ENFORCEMENT=$(grep -A1 "^---" "$SETTINGS" | grep "enforcementLevel:" | sed 's/.*://' | tr -d ' "' || echo "advisory")
fi

# Count features
FEATURES_COUNT=0
if [[ -f "$MANIFEST" ]]; then
  FEATURES_COUNT=$(grep -c "^  - name:" "$MANIFEST" 2>/dev/null || echo "0")
fi

# Count ADRs
ADRS_COUNT=0
if [[ -d "$ADRS_DIR" ]]; then
  ADRS_COUNT=$(find "$ADRS_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
fi

# Get active feature
ACTIVE_FEATURE=""
ACTIVE_PHASE=""
if [[ -f "$ACTIVE" ]]; then
  ACTIVE_FEATURE=$(yaml_value "$ACTIVE" "feature")
  ACTIVE_PHASE=$(yaml_value "$ACTIVE" "currentPhase")
fi

# Check for saved state
SAVED_STATE=""
if [[ -f "$STATE" ]]; then
  SAVED_STATE=$(yaml_value "$STATE" "feature")
fi

# Get current timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Generate TDD section
TDD_SECTION="
---

## Iterative Development Status

> Last updated: $TIMESTAMP

| Metric | Value |
|--------|-------|
| Enforcement | $ENFORCEMENT |
| Features | $FEATURES_COUNT |
| ADRs | $ADRS_COUNT |
| Active Feature | ${ACTIVE_FEATURE:-None} |
| Saved State | ${SAVED_STATE:-None} |

### Quick Commands

| Command | Purpose |
|---------|---------|
| \`/iterative-dev <feature>\` | Start/continue feature |
| \`/iterative-dev:save\` | Save session state |
| \`/iterative-dev:resume\` | Resume from saved state |
| \`/iterative-dev:check\` | Compliance report |

### Key Locations

- Iterations: \`docs/iterations/\`
- ADRs: \`docs/adrs/\`
- Settings: \`.claude/iterative-dev/settings.local.md\`

### Development Philosophy

1. **MVP First**: Define minimum scope before building
2. **Spec Driven**: Clear specifications drive implementation
3. **Test First**: Write failing tests before code
4. **No Stubs**: Everything works or nothing ships
5. **Iterate**: Ship value early, expand incrementally
"

# Add active feature details
if [[ -n "$ACTIVE_FEATURE" ]]; then
  TDD_SECTION+="
### Active Feature: $ACTIVE_FEATURE

**Phase**: ${ACTIVE_PHASE:-?}/8

**Documents**:
- Vision: \`docs/iterations/$ACTIVE_FEATURE/vision.md\`
- Scope: \`docs/iterations/$ACTIVE_FEATURE/scope-v*.md\`
- Requirements: \`docs/iterations/$ACTIVE_FEATURE/requirements-v*.md\`
"
fi

# Add saved state warning
if [[ -n "$SAVED_STATE" ]]; then
  TDD_SECTION+="
### ⚠️ Saved State Available

Feature \`$SAVED_STATE\` has saved state. Run \`/iterative-dev:resume\` to continue.
"
fi

# Add recent ADRs
if [[ -d "$ADRS_DIR" ]] && [[ "$ADRS_COUNT" -gt 0 ]]; then
  TDD_SECTION+="
### Recent ADRs
"
  # Get 3 most recent ADRs
  find "$ADRS_DIR" -name "*.md" -printf "%T@ %p\n" 2>/dev/null | \
    sort -rn | head -3 | cut -d' ' -f2- | while read -r adr; do
      adr_name=$(basename "$adr")
      TDD_SECTION+="- [\`$adr_name\`](docs/adrs/$adr_name)
"
    done
fi

TDD_SECTION+="
---
*Maintained by iterative-dev plugin*
"

# Update CLAUDE.md
if [[ -f "$CLAUDE_MD" ]]; then
  # Check if TDD section exists
  if grep -q "## Iterative Development Status" "$CLAUDE_MD"; then
    # Replace existing section (between "---" markers around TDD section)
    # This is a simplified approach - just append/update at end
    # Remove old section first
    sed -i '/^## Iterative Development Status/,/^\*Maintained by iterative-dev/d' "$CLAUDE_MD"
  fi

  # Append new section
  echo "$TDD_SECTION" >> "$CLAUDE_MD"

  # Remove trailing blank lines
  sed -i -e :a -e '/^\s*$/{ $d; N; ba; }' "$CLAUDE_MD"
else
  # Create minimal CLAUDE.md
  cat > "$CLAUDE_MD" << EOF
# Project: $PROJECT_NAME

## Overview

[Add project description here]

$TDD_SECTION
EOF
fi

exit 0
