#!/bin/bash
# Check if code is actually integrated, not just tested in isolation

set -euo pipefail

# Read tool input from stdin (passed by Claude Code)
TOOL_INPUT=$(cat)
FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" ]]; then
    echo "No file path provided"
    exit 0
fi

# Skip if this is a test file itself
if [[ "$FILE_PATH" =~ (test|spec|__tests__)/ ]] || [[ "$FILE_PATH" =~ \.(test|spec)\. ]]; then
    exit 0
fi

# Skip exempted paths
if [[ "$FILE_PATH" =~ ^(scripts/|docs/|\.config\.) ]]; then
    exit 0
fi

# Extract functions/classes/exports from the file being written
# This is a simple grep - real implementation would parse AST
EXPORTS=$(grep -oP '(export (function|class|const|let|var|default)|def |func |class )' "$FILE_PATH" 2>/dev/null || true)

if [[ -z "$EXPORTS" ]]; then
    # No exports found, probably not a module
    exit 0
fi

# Search for imports/usage of this file in the codebase
BASENAME=$(basename "$FILE_PATH" | sed 's/\.[^.]*$//')
USAGE_COUNT=$(grep -r "import.*$BASENAME" --include="*.js" --include="*.ts" --include="*.py" --include="*.go" --exclude-dir=node_modules --exclude-dir=test --exclude-dir=tests --exclude-dir=__tests__ . 2>/dev/null | wc -l)

if [[ $USAGE_COUNT -eq 0 ]]; then
    # Check for integration tests
    INTEGRATION_TESTS=$(find . -path "*/test*/integration/*" -o -name "*integration.test.*" -o -name "*integration.spec.*" 2>/dev/null | wc -l)

    if [[ $INTEGRATION_TESTS -eq 0 ]]; then
        cat >&2 <<EOF
⚠️  INTEGRATION WARNING: Code appears tested but NOT integrated!

File: $FILE_PATH
Issue: No imports/usage found outside of test files
       No integration tests found

This code may have unit tests but isn't actually wired into the system.

Recommendations:
1. Ensure this code is imported and used somewhere
2. Add integration tests to verify end-to-end functionality
3. Check that tests verify actual integration, not just isolated behavior

To bypass: Add file to exemptions in .claude/tdd-plugin.local.md
EOF
        # Exit 0 to warn but not block (advisory mode)
        # Change to exit 2 for strict enforcement
        exit 0
    fi
fi

exit 0
