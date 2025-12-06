#!/bin/bash

# Backlog Plugin - Stub Detection Script
# Scans codebase for TODO, FIXME, NotImplementedError, and other stub patterns

set -e

PROJECT_DIR="${1:-$PWD}"
OUTPUT_FORMAT="${2:-text}"  # text or json

# Colors for output
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories to exclude
EXCLUDE_DIRS=(
    "node_modules"
    "vendor"
    "venv"
    ".venv"
    "__pycache__"
    ".git"
    "dist"
    "build"
    "target"
    ".claude"
    ".next"
    "coverage"
)

# Build exclude pattern for grep
EXCLUDE_PATTERN=""
for dir in "${EXCLUDE_DIRS[@]}"; do
    EXCLUDE_PATTERN="$EXCLUDE_PATTERN --exclude-dir=$dir"
done

# Patterns to search for (case-insensitive where appropriate)
declare -A PATTERNS
PATTERNS["TODO"]="TODO"
PATTERNS["FIXME"]="FIXME"
PATTERNS["XXX"]="XXX"
PATTERNS["HACK"]="HACK"
PATTERNS["NotImplementedError"]="NotImplementedError|raise NotImplementedError"
PATTERNS["not_implemented_js"]='throw new Error\(["\x27]not implemented["\x27]\)'
PATTERNS["panic_go"]='panic\(["\x27]not implemented'
PATTERNS["unimplemented_rust"]='unimplemented!\(\)|todo!\(\)'

# Initialize counters
declare -A COUNTS
TOTAL=0

# Temporary file for results
RESULTS_FILE=$(mktemp)
trap "rm -f $RESULTS_FILE" EXIT

cd "$PROJECT_DIR"

# Function to search for a pattern
search_pattern() {
    local name="$1"
    local pattern="$2"
    local case_flag="$3"  # -i for case insensitive

    local results
    results=$(grep -rn $case_flag $EXCLUDE_PATTERN -E "$pattern" . 2>/dev/null || true)

    if [[ -n "$results" ]]; then
        local count=$(echo "$results" | wc -l)
        COUNTS["$name"]=$count
        TOTAL=$((TOTAL + count))
        echo "$results" >> "$RESULTS_FILE"
    else
        COUNTS["$name"]=0
    fi
}

# Run searches
search_pattern "TODO" "TODO" "-i"
search_pattern "FIXME" "FIXME" "-i"
search_pattern "XXX" "XXX" ""
search_pattern "HACK" "HACK" "-i"
search_pattern "NotImplementedError" "NotImplementedError|raise NotImplementedError" ""
search_pattern "not_implemented_js" 'throw new Error\(["\x27]not implemented' "-i"
search_pattern "panic_go" 'panic\(["\x27]not implemented' ""
search_pattern "unimplemented_rust" 'unimplemented!\(\)|todo!\(\)' ""

# Output results
if [[ "$OUTPUT_FORMAT" == "json" ]]; then
    # JSON output for programmatic use
    echo "{"
    echo "  \"total\": $TOTAL,"
    echo "  \"counts\": {"
    first=true
    for key in "${!COUNTS[@]}"; do
        if [[ "${COUNTS[$key]}" -gt 0 ]]; then
            if [[ "$first" == "true" ]]; then
                first=false
            else
                echo ","
            fi
            echo -n "    \"$key\": ${COUNTS[$key]}"
        fi
    done
    echo ""
    echo "  },"
    echo "  \"results\": ["
    first=true
    while IFS= read -r line; do
        file=$(echo "$line" | cut -d: -f1)
        linenum=$(echo "$line" | cut -d: -f2)
        content=$(echo "$line" | cut -d: -f3-)

        if [[ "$first" == "true" ]]; then
            first=false
        else
            echo ","
        fi
        # Escape quotes in content for JSON
        content=$(echo "$content" | sed 's/"/\\"/g' | sed 's/\t/  /g')
        echo -n "    {\"file\": \"$file\", \"line\": $linenum, \"content\": \"$content\"}"
    done < "$RESULTS_FILE"
    echo ""
    echo "  ]"
    echo "}"
else
    # Human-readable output
    if [[ $TOTAL -eq 0 ]]; then
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}  STUB SCAN: CLEAN ✓${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo "  No stubs found in codebase."
        echo "  All implementations appear complete."
        echo ""
    else
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${YELLOW}  STUB SCAN RESULTS${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo -e "  Found ${RED}$TOTAL${NC} stubs:"
        echo ""

        # Group by file
        current_file=""
        while IFS= read -r line; do
            file=$(echo "$line" | cut -d: -f1 | sed 's|^\./||')
            linenum=$(echo "$line" | cut -d: -f2)
            content=$(echo "$line" | cut -d: -f3- | sed 's/^[[:space:]]*//')

            if [[ "$file" != "$current_file" ]]; then
                current_file="$file"
                echo -e "  ${BLUE}## $file${NC}"
            fi

            # Truncate long lines
            if [[ ${#content} -gt 60 ]]; then
                content="${content:0:60}..."
            fi

            echo "    :$linenum  $content"
        done < <(sort "$RESULTS_FILE")

        echo ""
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        echo "  Summary:"
        for key in "TODO" "FIXME" "XXX" "HACK" "NotImplementedError" "not_implemented_js" "panic_go" "unimplemented_rust"; do
            if [[ "${COUNTS[$key]}" -gt 0 ]]; then
                echo "    $key: ${COUNTS[$key]}"
            fi
        done
        echo "    ─────────"
        echo "    Total: $TOTAL"
        echo ""
    fi
fi

# Exit with code based on whether stubs were found
if [[ $TOTAL -gt 0 ]]; then
    exit 1
else
    exit 0
fi
