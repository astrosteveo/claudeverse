#!/bin/bash
# Run all TDD plugin tests

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "════════════════════════════════════════════════════════"
echo "  TDD Plugin Test Suite"
echo "════════════════════════════════════════════════════════"
echo ""

FAILED_TESTS=()
PASSED_TESTS=()

# Test 1: Plugin structure
echo "▶ Running: Plugin Structure Test"
echo "────────────────────────────────────────────────────────"
if bash "$SCRIPT_DIR/test_plugin_structure.sh"; then
    PASSED_TESTS+=("Plugin Structure")
else
    FAILED_TESTS+=("Plugin Structure")
fi
echo ""

# Test 2: Hooks integration
echo "▶ Running: Hooks Integration Test"
echo "────────────────────────────────────────────────────────"
if bash "$SCRIPT_DIR/test_hooks_integration.sh"; then
    PASSED_TESTS+=("Hooks Integration")
else
    FAILED_TESTS+=("Hooks Integration")
fi
echo ""

# Test 3: Update CLAUDE.md script (existing test)
if [[ -f "$SCRIPT_DIR/test_update_claude_md.sh" ]]; then
    echo "▶ Running: Update CLAUDE.md Test"
    echo "────────────────────────────────────────────────────────"
    if bash "$SCRIPT_DIR/test_update_claude_md.sh"; then
        PASSED_TESTS+=("Update CLAUDE.md")
    else
        FAILED_TESTS+=("Update CLAUDE.md")
    fi
    echo ""
fi

# Summary
echo "════════════════════════════════════════════════════════"
echo "  Test Results"
echo "════════════════════════════════════════════════════════"
echo ""
echo "✅ Passed: ${#PASSED_TESTS[@]}"
for test in "${PASSED_TESTS[@]}"; do
    echo "   - $test"
done
echo ""

if [[ ${#FAILED_TESTS[@]} -gt 0 ]]; then
    echo "❌ Failed: ${#FAILED_TESTS[@]}"
    for test in "${FAILED_TESTS[@]}"; do
        echo "   - $test"
    done
    echo ""
    exit 1
else
    echo "🎉 All tests passed!"
    echo ""
    exit 0
fi
