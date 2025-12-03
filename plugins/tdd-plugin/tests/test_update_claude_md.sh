#!/bin/bash
# Test suite for update-claude-md.sh
# Using bash unit testing to test our TDD plugin (meta!)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
SCRIPT_UNDER_TEST="${PLUGIN_ROOT}/scripts/update-claude-md.sh"

# Test utilities
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test helper functions
setup_test_env() {
    export TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR"
    mkdir -p .claude docs/specs
    export CLAUDE_PLUGIN_ROOT="$PLUGIN_ROOT"
}

teardown_test_env() {
    cd /
    rm -rf "$TEST_DIR"
}

assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Assertion failed}"

    TESTS_RUN=$((TESTS_RUN + 1))
    if [[ "$expected" == "$actual" ]]; then
        echo -e "${GREEN}✓${NC} $message"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $message"
        echo "  Expected: $expected"
        echo "  Actual:   $actual"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    local message="${2:-File should exist: $file}"

    TESTS_RUN=$((TESTS_RUN + 1))
    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} $message"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $message"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

assert_file_contains() {
    local file="$1"
    local pattern="$2"
    local message="${3:-File should contain pattern: $pattern}"

    TESTS_RUN=$((TESTS_RUN + 1))
    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $message"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $message"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Test cases

test_creates_claude_md_if_missing() {
    echo -e "\n${YELLOW}Test: Creates CLAUDE.md if missing${NC}"
    setup_test_env

    bash "$SCRIPT_UNDER_TEST" >/dev/null 2>&1

    assert_file_exists "CLAUDE.md" "CLAUDE.md should be created"
    assert_file_contains "CLAUDE.md" "Project Context for Claude" "Should contain header"
    assert_file_contains "CLAUDE.md" "TDD Workflow Status" "Should contain TDD section"

    teardown_test_env
}

test_preserves_existing_content() {
    echo -e "\n${YELLOW}Test: Preserves existing CLAUDE.md content${NC}"
    setup_test_env

    cat > CLAUDE.md << 'EOF'
# My Project

This is important custom content.

## Custom Section

Don't delete this!
EOF

    bash "$SCRIPT_UNDER_TEST" >/dev/null 2>&1

    assert_file_contains "CLAUDE.md" "My Project" "Should preserve original header"
    assert_file_contains "CLAUDE.md" "important custom content" "Should preserve custom content"
    assert_file_contains "CLAUDE.md" "TDD Workflow Status" "Should add TDD section"

    teardown_test_env
}

test_updates_existing_tdd_section() {
    echo -e "\n${YELLOW}Test: Updates existing TDD section${NC}"
    setup_test_env

    cat > CLAUDE.md << 'EOF'
# Project

---

## TDD Workflow Status

**Last Updated**: 2020-01-01 00:00:00

OLD CONTENT HERE

---
EOF

    bash "$SCRIPT_UNDER_TEST" >/dev/null 2>&1

    assert_file_contains "CLAUDE.md" "TDD Workflow Status" "Should still have TDD section"
    if grep -q "OLD CONTENT HERE" CLAUDE.md 2>/dev/null; then
        echo -e "${RED}✗${NC} Should replace old TDD content"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        TESTS_RUN=$((TESTS_RUN + 1))
    else
        echo -e "${GREEN}✓${NC} Should replace old TDD content"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        TESTS_RUN=$((TESTS_RUN + 1))
    fi

    teardown_test_env
}

test_reads_enforcement_level_from_settings() {
    echo -e "\n${YELLOW}Test: Reads enforcement level from settings${NC}"
    setup_test_env

    mkdir -p .claude
    cat > .claude/tdd-plugin.local.md << 'EOF'
---
enforcementLevel: strict
---
EOF

    bash "$SCRIPT_UNDER_TEST" >/dev/null 2>&1

    assert_file_contains "CLAUDE.md" "Enforcement Mode.*strict" "Should show strict mode"

    teardown_test_env
}

test_reads_project_name_from_manifest() {
    echo -e "\n${YELLOW}Test: Reads project name from manifest${NC}"
    setup_test_env

    mkdir -p .claude
    cat > .claude/specs-manifest.yaml << 'EOF'
name: test-project
version: 1.0.0
EOF

    bash "$SCRIPT_UNDER_TEST" >/dev/null 2>&1

    assert_file_contains "CLAUDE.md" "Project.*test-project" "Should show project name"

    teardown_test_env
}

test_counts_violations_from_json() {
    echo -e "\n${YELLOW}Test: Counts violations from JSON file${NC}"
    setup_test_env

    mkdir -p .claude
    cat > .claude/tdd-violations.json << 'EOF'
{
  "total": 5,
  "history": [
    {"resolved": false},
    {"resolved": false},
    {"resolved": true},
    {"resolved": true},
    {"resolved": true}
  ]
}
EOF

    bash "$SCRIPT_UNDER_TEST" >/dev/null 2>&1

    assert_file_contains "CLAUDE.md" "2 unresolved.*5 total" "Should show violation counts"

    teardown_test_env
}

test_handles_missing_files_gracefully() {
    echo -e "\n${YELLOW}Test: Handles missing files gracefully${NC}"
    setup_test_env

    # No settings, no manifest, no violations - should still work
    bash "$SCRIPT_UNDER_TEST" >/dev/null 2>&1
    local exit_code=$?

    assert_equals "0" "$exit_code" "Should exit successfully even with missing files"
    assert_file_exists "CLAUDE.md" "Should create CLAUDE.md"
    assert_file_contains "CLAUDE.md" "Enforcement Mode.*advisory" "Should default to advisory"
    assert_file_contains "CLAUDE.md" "0 unresolved.*0 total" "Should default to zero violations"

    teardown_test_env
}

test_includes_quick_commands() {
    echo -e "\n${YELLOW}Test: Includes quick commands section${NC}"
    setup_test_env

    bash "$SCRIPT_UNDER_TEST" >/dev/null 2>&1

    assert_file_contains "CLAUDE.md" "Quick Commands" "Should have quick commands section"
    assert_file_contains "CLAUDE.md" "/tdd-plugin:status" "Should list status command"
    assert_file_contains "CLAUDE.md" "/tdd-plugin:run-cycle" "Should list run-cycle command"

    teardown_test_env
}

test_includes_documentation_locations() {
    echo -e "\n${YELLOW}Test: Includes documentation locations${NC}"
    setup_test_env

    bash "$SCRIPT_UNDER_TEST" >/dev/null 2>&1

    assert_file_contains "CLAUDE.md" "Key Documentation Locations" "Should have docs section"
    assert_file_contains "CLAUDE.md" "docs/specs" "Should reference specs directory"
    assert_file_contains "CLAUDE.md" ".claude/specs-manifest.yaml" "Should reference manifest"
    assert_file_contains "CLAUDE.md" ".claude/tdd-violations.json" "Should reference violations"

    teardown_test_env
}

# Run all tests
echo "================================"
echo "  update-claude-md.sh Test Suite"
echo "================================"

test_creates_claude_md_if_missing
test_preserves_existing_content
test_updates_existing_tdd_section
test_reads_enforcement_level_from_settings
test_reads_project_name_from_manifest
test_counts_violations_from_json
test_handles_missing_files_gracefully
test_includes_quick_commands
test_includes_documentation_locations

# Summary
echo ""
echo "================================"
echo "  Test Summary"
echo "================================"
echo -e "Tests run:    $TESTS_RUN"
echo -e "Passed:       ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed:       ${RED}$TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}All tests passed!${NC} ✨"
    exit 0
else
    echo -e "\n${RED}Some tests failed${NC}"
    exit 1
fi
