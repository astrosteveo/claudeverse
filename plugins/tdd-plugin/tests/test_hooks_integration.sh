#!/bin/bash
# End-to-end test: Verify hooks can execute their commands

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Testing TDD plugin hooks integration..."

# Set up environment like Claude Code would
export CLAUDE_PLUGIN_ROOT="$PLUGIN_ROOT"

# Test 1: SessionEnd hook - generate-report.sh
echo "Testing SessionEnd hook: generate-report.sh..."
TEMP_REPORT=$(mktemp)
if bash "$PLUGIN_ROOT/scripts/generate-report.sh" -o "$TEMP_REPORT" 2>&1; then
    # Check if report was actually created and contains expected content
    if [[ -f "$TEMP_REPORT" ]] && grep -q "TDD Compliance Report" "$TEMP_REPORT"; then
        echo "✓ generate-report.sh executes successfully and creates report"
        rm -f "$TEMP_REPORT"
    else
        echo "❌ FAIL: generate-report.sh didn't create valid report"
        rm -f "$TEMP_REPORT"
        exit 1
    fi
else
    echo "❌ FAIL: generate-report.sh failed to execute"
    rm -f "$TEMP_REPORT"
    exit 1
fi

# Test 2: SessionEnd hook - update-claude-md.sh
echo "Testing SessionEnd hook: update-claude-md.sh..."
# Save original CLAUDE.md
CLAUDE_MD_BACKUP=$(mktemp)
if [[ -f "$PLUGIN_ROOT/../../CLAUDE.md" ]]; then
    cp "$PLUGIN_ROOT/../../CLAUDE.md" "$CLAUDE_MD_BACKUP"
fi

if bash "$PLUGIN_ROOT/scripts/update-claude-md.sh" 2>&1 | grep -q "successfully"; then
    echo "✓ update-claude-md.sh executes successfully"
    # Restore original
    if [[ -f "$CLAUDE_MD_BACKUP" ]]; then
        mv "$CLAUDE_MD_BACKUP" "$PLUGIN_ROOT/../../CLAUDE.md"
    fi
else
    echo "❌ FAIL: update-claude-md.sh failed to execute"
    if [[ -f "$CLAUDE_MD_BACKUP" ]]; then
        mv "$CLAUDE_MD_BACKUP" "$PLUGIN_ROOT/../../CLAUDE.md"
    fi
    exit 1
fi

# Test 3: Detect test framework
echo "Testing detect-test-framework.sh..."
OUTPUT=$(bash "$PLUGIN_ROOT/scripts/detect-test-framework.sh" 2>&1 || true)
if echo "$OUTPUT" | grep -qE "(Could not detect|Detected)"; then
    echo "✓ detect-test-framework.sh executes (framework detection varies)"
else
    echo "❌ FAIL: detect-test-framework.sh failed to execute"
    echo "Output was: $OUTPUT"
    exit 1
fi

echo ""
echo "✅ All hooks integration tests passed!"
echo "Scripts are executable and produce expected results."
exit 0
