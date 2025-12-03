#!/usr/bin/env bash
#
# check-test-ordering.sh - Verify tests were created before implementation
#
# Uses Git timestamps when available, falls back to file modification times
#
# Exit codes:
#   0 - All tests created before implementation
#   1 - Test ordering violations found
#   2 - Git repository not found
#   3 - Invalid arguments

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
CHECK_DIR="."
OUTPUT_FORMAT="text"
VERBOSE=false
INCLUDE_UNCOMMITTED=true

# Usage information
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Verify that tests were created before their corresponding implementation files.

OPTIONS:
    -d, --dir DIRECTORY       Directory to check (default: current directory)
    -o, --output FORMAT       Output format: text, json (default: text)
    -v, --verbose             Enable verbose output
    --no-uncommitted          Exclude uncommitted files from check
    -h, --help                Show this help message

EXAMPLES:
    # Check current directory
    $(basename "$0")

    # Check specific directory with JSON output
    $(basename "$0") -d src/ -o json

    # Check only committed files
    $(basename "$0") --no-uncommitted

EXIT CODES:
    0 - All tests created before implementation
    1 - Test ordering violations found
    2 - Git repository not found
    3 - Invalid arguments
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)
            CHECK_DIR="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        --no-uncommitted)
            INCLUDE_UNCOMMITTED=false
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Error: Unknown option $1" >&2
            usage
            exit 3
            ;;
    esac
done

# Log function for verbose output
log() {
    if [[ "$VERBOSE" == true ]]; then
        echo "$@" >&2
    fi
}

# Check if in git repository
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Error: Not in a Git repository" >&2
    exit 2
fi

# Map test file to implementation file
map_test_to_impl() {
    local test_file="$1"
    local impl_file=""

    # JavaScript/TypeScript: *.test.js -> *.js, *.spec.ts -> *.ts
    if [[ "$test_file" =~ (.*)\.test\.(js|ts|jsx|tsx)$ ]]; then
        impl_file="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
    elif [[ "$test_file" =~ (.*)\.spec\.(js|ts|jsx|tsx)$ ]]; then
        impl_file="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
    # Python: *_test.py -> *.py, test_*.py -> *.py
    elif [[ "$test_file" =~ (.*)_test\.py$ ]]; then
        impl_file="${BASH_REMATCH[1]}.py"
    elif [[ "$test_file" =~ test_(.*)\.py$ ]]; then
        impl_file="${BASH_REMATCH[1]}.py"
    # Go: *_test.go -> *.go
    elif [[ "$test_file" =~ (.*)_test\.go$ ]]; then
        impl_file="${BASH_REMATCH[1]}.go"
    # Ruby: *_spec.rb -> *.rb
    elif [[ "$test_file" =~ (.*)_spec\.rb$ ]]; then
        impl_file="${BASH_REMATCH[1]}.rb"
    fi

    echo "$impl_file"
}

# Get file creation timestamp (Git or filesystem)
get_timestamp() {
    local file="$1"

    # Try Git first
    if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
        # File is tracked by Git, get first commit timestamp
        git log --follow --format=%at --reverse "$file" 2>/dev/null | head -1
    elif [[ "$INCLUDE_UNCOMMITTED" == true ]]; then
        # File not in Git, use filesystem modification time
        stat -c %Y "$file" 2>/dev/null || stat -f %m "$file" 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}

# Find all test files
log "Searching for test files in: $CHECK_DIR"
test_files=()

while IFS= read -r -d '' file; do
    test_files+=("$file")
done < <(find "$CHECK_DIR" -type f \( \
    -name "*.test.js" -o \
    -name "*.test.ts" -o \
    -name "*.test.jsx" -o \
    -name "*.test.tsx" -o \
    -name "*.spec.js" -o \
    -name "*.spec.ts" -o \
    -name "*.spec.jsx" -o \
    -name "*.spec.tsx" -o \
    -name "*_test.py" -o \
    -name "test_*.py" -o \
    -name "*_test.go" -o \
    -name "*_spec.rb" \
\) -print0)

log "Found ${#test_files[@]} test files"

# Check each test file
violations=()
checked=0
passed=0

for test_file in "${test_files[@]}"; do
    impl_file=$(map_test_to_impl "$test_file")

    if [[ -z "$impl_file" || ! -f "$impl_file" ]]; then
        log "Skipping $test_file: Implementation file not found or not mapped"
        continue
    fi

    checked=$((checked + 1))

    test_timestamp=$(get_timestamp "$test_file")
    impl_timestamp=$(get_timestamp "$impl_file")

    if [[ "$test_timestamp" == "0" || "$impl_timestamp" == "0" ]]; then
        log "Skipping $test_file: Could not determine timestamps"
        continue
    fi

    log "Checking: $test_file ($(date -d @$test_timestamp 2>/dev/null || date -r $test_timestamp 2>/dev/null)) vs $impl_file ($(date -d @$impl_timestamp 2>/dev/null || date -r $impl_timestamp 2>/dev/null))"

    if [[ $test_timestamp -gt $impl_timestamp ]]; then
        # Test created AFTER implementation - violation!
        test_date=$(date -d @$test_timestamp '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date -r $test_timestamp '+%Y-%m-%d %H:%M:%S' 2>/dev/null)
        impl_date=$(date -d @$impl_timestamp '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date -r $impl_timestamp '+%Y-%m-%d %H:%M:%S' 2>/dev/null)

        violations+=("$test_file|$impl_file|$test_date|$impl_date|$test_timestamp|$impl_timestamp")
    else
        passed=$((passed + 1))
    fi
done

# Generate output
if [[ "$OUTPUT_FORMAT" == "json" ]]; then
    # JSON output
    echo "{"
    echo "  \"passed\": $([ ${#violations[@]} -eq 0 ] && echo "true" || echo "false"),"
    echo "  \"summary\": {"
    echo "    \"checked\": $checked,"
    echo "    \"passed\": $passed,"
    echo "    \"violations\": ${#violations[@]}"
    echo "  },"
    echo "  \"violations\": ["

    first=true
    for violation in "${violations[@]}"; do
        IFS='|' read -r test_file impl_file test_date impl_date test_ts impl_ts <<< "$violation"

        if [[ "$first" == false ]]; then
            echo ","
        fi
        first=false

        cat << EOF
    {
      "testFile": "$test_file",
      "implementationFile": "$impl_file",
      "testCreated": "$test_date",
      "implementationCreated": "$impl_date",
      "testTimestamp": $test_ts,
      "implementationTimestamp": $impl_ts,
      "message": "Test created after implementation"
    }
EOF
    done

    echo ""
    echo "  ]"
    echo "}"
else
    # Text output
    echo "Test Ordering Validation Report"
    echo "================================"
    echo ""
    echo "Directory: $CHECK_DIR"
    echo "Checked: $checked file pairs"
    echo "Passed: $passed"
    echo "Violations: ${#violations[@]}"
    echo ""

    if [[ ${#violations[@]} -eq 0 ]]; then
        echo -e "${GREEN}✓ All tests created before implementation${NC}"
    else
        echo -e "${RED}✗ Test ordering violations found:${NC}"
        echo ""

        for violation in "${violations[@]}"; do
            IFS='|' read -r test_file impl_file test_date impl_date test_ts impl_ts <<< "$violation"

            echo -e "${RED}Violation:${NC}"
            echo "  Test File: $test_file"
            echo "    Created: $test_date"
            echo "  Implementation: $impl_file"
            echo "    Created: $impl_date"
            echo "  ${YELLOW}Issue: Test created AFTER implementation${NC}"
            echo ""
        done
    fi
fi

# Exit with appropriate code
if [[ ${#violations[@]} -eq 0 ]]; then
    exit 0
else
    exit 1
fi
