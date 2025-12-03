#!/bin/bash
# Integration test: Verify TDD plugin is properly structured for Claude Code

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Testing TDD plugin structure..."

# Test 1: Plugin.json exists and is valid
if [[ ! -f "$PLUGIN_ROOT/.claude-plugin/plugin.json" ]]; then
    echo "❌ FAIL: plugin.json not found at .claude-plugin/plugin.json"
    exit 1
fi
if ! jq empty "$PLUGIN_ROOT/.claude-plugin/plugin.json" 2>/dev/null; then
    echo "❌ FAIL: plugin.json is not valid JSON"
    exit 1
fi
echo "✓ plugin.json exists and is valid JSON"

# Test 1b: Plugin.json has required registration fields
MISSING_FIELDS=()
for field in commands agents skills hooks; do
    if ! jq -e ".$field" "$PLUGIN_ROOT/.claude-plugin/plugin.json" >/dev/null 2>&1; then
        MISSING_FIELDS+=("$field")
    fi
done
if [[ ${#MISSING_FIELDS[@]} -gt 0 ]]; then
    echo "❌ FAIL: plugin.json missing registration fields:"
    printf '  - %s\n' "${MISSING_FIELDS[@]}"
    exit 1
fi
echo "✓ plugin.json registers commands, agents, skills, and hooks"

# Test 2: Hooks.json exists in correct location
if [[ ! -f "$PLUGIN_ROOT/hooks/hooks.json" ]]; then
    echo "❌ FAIL: hooks.json not found at hooks/hooks.json"
    echo "  Expected location: $PLUGIN_ROOT/hooks/hooks.json"
    if [[ -f "$PLUGIN_ROOT/.claude-plugin/hooks.json" ]]; then
        echo "  Found at WRONG location: $PLUGIN_ROOT/.claude-plugin/hooks.json"
    fi
    exit 1
fi
echo "✓ hooks.json exists in hooks/"

# Test 3: Hooks.json is valid JSON
if ! jq empty "$PLUGIN_ROOT/hooks/hooks.json" 2>/dev/null; then
    echo "❌ FAIL: hooks.json is not valid JSON"
    exit 1
fi
echo "✓ hooks.json is valid JSON"

# Test 4: Hooks.json has required structure
if ! jq -e '.hooks' "$PLUGIN_ROOT/hooks/hooks.json" >/dev/null 2>&1; then
    echo "❌ FAIL: hooks.json missing .hooks key"
    exit 1
fi
echo "✓ hooks.json has .hooks structure"

# Test 5: Scripts referenced in hooks exist
MISSING_SCRIPTS=()
while IFS= read -r script; do
    # Extract script path from command like: bash "${CLAUDE_PLUGIN_ROOT}/scripts/foo.sh"
    if [[ $script =~ \$\{CLAUDE_PLUGIN_ROOT\}/scripts/([^\"]+) ]]; then
        script_name="${BASH_REMATCH[1]}"
        if [[ ! -f "$PLUGIN_ROOT/scripts/$script_name" ]]; then
            MISSING_SCRIPTS+=("$script_name")
        fi
    fi
done < <(jq -r '.. | .command? // empty' "$PLUGIN_ROOT/hooks/hooks.json" 2>/dev/null)

if [[ ${#MISSING_SCRIPTS[@]} -gt 0 ]]; then
    echo "❌ FAIL: Referenced scripts don't exist:"
    printf '  - %s\n' "${MISSING_SCRIPTS[@]}"
    exit 1
fi
echo "✓ All referenced scripts exist"

# Test 6: Scripts are executable
NON_EXECUTABLE=()
for script in "$PLUGIN_ROOT"/scripts/*.sh; do
    if [[ -f "$script" ]] && [[ ! -x "$script" ]]; then
        NON_EXECUTABLE+=("$(basename "$script")")
    fi
done

if [[ ${#NON_EXECUTABLE[@]} -gt 0 ]]; then
    echo "⚠️  WARNING: Some scripts are not executable:"
    printf '  - %s\n' "${NON_EXECUTABLE[@]}"
fi

echo ""
echo "✅ All integration tests passed!"
echo "Plugin is properly wired up for Claude Code."
exit 0
