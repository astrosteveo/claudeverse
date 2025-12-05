#!/usr/bin/env bash
#
# validate-coverage.sh - Validate test coverage against configured thresholds
#
# Supports:
#   - LCOV format (JavaScript/TypeScript)
#   - Cobertura XML format (Python, Java, etc.)
#
# Exit codes:
#   0 - Coverage meets thresholds
#   1 - Coverage below thresholds
#   2 - Coverage file not found
#   3 - Invalid arguments or configuration

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
COVERAGE_FILE=""
FORMAT="auto"
LINE_THRESHOLD=80
BRANCH_THRESHOLD=75
OUTPUT_FORMAT="json"
VERBOSE=false

# Usage information
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Validate test coverage against configured thresholds.

OPTIONS:
    -f, --file FILE           Coverage file path (required)
    -t, --format FORMAT       Coverage format: auto, lcov, cobertura (default: auto)
    -l, --line PERCENT        Line coverage threshold (default: 80)
    -b, --branch PERCENT      Branch coverage threshold (default: 75)
    -o, --output FORMAT       Output format: json, text (default: json)
    -v, --verbose             Enable verbose output
    -h, --help                Show this help message

EXAMPLES:
    # Auto-detect format
    $(basename "$0") -f coverage/lcov.info -l 85 -b 80

    # Explicit format
    $(basename "$0") -f coverage.xml -t cobertura -l 90 -b 85

    # Text output
    $(basename "$0") -f coverage/lcov.info -o text -v

EXIT CODES:
    0 - Coverage meets thresholds
    1 - Coverage below thresholds
    2 - Coverage file not found
    3 - Invalid arguments or configuration
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            COVERAGE_FILE="$2"
            shift 2
            ;;
        -t|--format)
            FORMAT="$2"
            shift 2
            ;;
        -l|--line)
            LINE_THRESHOLD="$2"
            shift 2
            ;;
        -b|--branch)
            BRANCH_THRESHOLD="$2"
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

# Validate required arguments
if [[ -z "$COVERAGE_FILE" ]]; then
    echo "Error: Coverage file is required (-f/--file)" >&2
    usage
    exit 3
fi

# Check if coverage file exists
if [[ ! -f "$COVERAGE_FILE" ]]; then
    echo "Error: Coverage file not found: $COVERAGE_FILE" >&2
    exit 2
fi

# Log function for verbose output
log() {
    if [[ "$VERBOSE" == true ]]; then
        echo "$@" >&2
    fi
}

# Auto-detect coverage format
detect_format() {
    local file="$1"

    if grep -q "^TN:" "$file" 2>/dev/null; then
        echo "lcov"
    elif grep -q '<?xml.*<coverage' "$file" 2>/dev/null; then
        echo "cobertura"
    else
        echo "unknown"
    fi
}

# Parse LCOV format
parse_lcov() {
    local file="$1"
    local lines_found=0
    local lines_hit=0
    local branches_found=0
    local branches_hit=0

    while IFS= read -r line; do
        if [[ "$line" =~ ^LF:([0-9]+) ]]; then
            lines_found=${BASH_REMATCH[1]}
        elif [[ "$line" =~ ^LH:([0-9]+) ]]; then
            lines_hit=${BASH_REMATCH[1]}
        elif [[ "$line" =~ ^BRF:([0-9]+) ]]; then
            branches_found=${BASH_REMATCH[1]}
        elif [[ "$line" =~ ^BRH:([0-9]+) ]]; then
            branches_hit=${BASH_REMATCH[1]}
        fi
    done < "$file"

    # Calculate percentages
    local line_coverage=0
    local branch_coverage=0

    if [[ $lines_found -gt 0 ]]; then
        line_coverage=$(awk "BEGIN {printf \"%.2f\", ($lines_hit / $lines_found) * 100}")
    fi

    if [[ $branches_found -gt 0 ]]; then
        branch_coverage=$(awk "BEGIN {printf \"%.2f\", ($branches_hit / $branches_found) * 100}")
    fi

    echo "$line_coverage $branch_coverage $lines_found $lines_hit $branches_found $branches_hit"
}

# Parse Cobertura XML format
parse_cobertura() {
    local file="$1"

    # Extract line-rate and branch-rate attributes
    local line_rate=$(grep -oP 'line-rate="\K[^"]+' "$file" | head -1)
    local branch_rate=$(grep -oP 'branch-rate="\K[^"]+' "$file" | head -1)

    # Convert rates to percentages
    local line_coverage=$(awk "BEGIN {printf \"%.2f\", $line_rate * 100}")
    local branch_coverage=$(awk "BEGIN {printf \"%.2f\", $branch_rate * 100}")

    # Extract counts
    local lines_valid=$(grep -oP 'lines-valid="\K[^"]+' "$file" | head -1)
    local lines_covered=$(grep -oP 'lines-covered="\K[^"]+' "$file" | head -1)
    local branches_valid=$(grep -oP 'branches-valid="\K[^"]+' "$file" | head -1)
    local branches_covered=$(grep -oP 'branches-covered="\K[^"]+' "$file" | head -1)

    echo "$line_coverage $branch_coverage ${lines_valid:-0} ${lines_covered:-0} ${branches_valid:-0} ${branches_covered:-0}"
}

# Determine format
if [[ "$FORMAT" == "auto" ]]; then
    FORMAT=$(detect_format "$COVERAGE_FILE")
    log "Auto-detected format: $FORMAT"
fi

# Parse coverage data
log "Parsing coverage file: $COVERAGE_FILE"
case "$FORMAT" in
    lcov)
        read -r line_coverage branch_coverage lines_total lines_covered branches_total branches_covered <<< "$(parse_lcov "$COVERAGE_FILE")"
        ;;
    cobertura)
        read -r line_coverage branch_coverage lines_total lines_covered branches_total branches_covered <<< "$(parse_cobertura "$COVERAGE_FILE")"
        ;;
    *)
        echo "Error: Unknown or unsupported coverage format: $FORMAT" >&2
        exit 3
        ;;
esac

log "Line coverage: $line_coverage% ($lines_covered/$lines_total)"
log "Branch coverage: $branch_coverage% ($branches_covered/$branches_total)"

# Compare against thresholds
line_pass=$(awk "BEGIN {print ($line_coverage >= $LINE_THRESHOLD) ? 1 : 0}")
branch_pass=$(awk "BEGIN {print ($branch_coverage >= $BRANCH_THRESHOLD) ? 1 : 0}")

overall_pass=0
if [[ $line_pass -eq 1 && $branch_pass -eq 1 ]]; then
    overall_pass=1
fi

# Generate output
if [[ "$OUTPUT_FORMAT" == "json" ]]; then
    # JSON output
    cat << EOF
{
  "passed": $([ $overall_pass -eq 1 ] && echo "true" || echo "false"),
  "coverage": {
    "line": {
      "percentage": $line_coverage,
      "threshold": $LINE_THRESHOLD,
      "passed": $([ $line_pass -eq 1 ] && echo "true" || echo "false"),
      "total": $lines_total,
      "covered": $lines_covered
    },
    "branch": {
      "percentage": $branch_coverage,
      "threshold": $BRANCH_THRESHOLD,
      "passed": $([ $branch_pass -eq 1 ] && echo "true" || echo "false"),
      "total": $branches_total,
      "covered": $branches_covered
    }
  },
  "format": "$FORMAT",
  "file": "$COVERAGE_FILE"
}
EOF
else
    # Text output
    echo "Coverage Validation Report"
    echo "=========================="
    echo ""
    echo "Coverage File: $COVERAGE_FILE"
    echo "Format: $FORMAT"
    echo ""
    echo "Line Coverage:"
    echo "  Current:   $line_coverage%"
    echo "  Threshold: $LINE_THRESHOLD%"
    echo "  Status:    $([ $line_pass -eq 1 ] && echo -e "${GREEN}PASS${NC}" || echo -e "${RED}FAIL${NC}")"
    echo "  Details:   $lines_covered / $lines_total lines covered"
    echo ""
    echo "Branch Coverage:"
    echo "  Current:   $branch_coverage%"
    echo "  Threshold: $BRANCH_THRESHOLD%"
    echo "  Status:    $([ $branch_pass -eq 1 ] && echo -e "${GREEN}PASS${NC}" || echo -e "${RED}FAIL${NC}")"
    echo "  Details:   $branches_covered / $branches_total branches covered"
    echo ""
    echo "Overall: $([ $overall_pass -eq 1 ] && echo -e "${GREEN}PASS${NC}" || echo -e "${RED}FAIL${NC}")"
fi

# Exit with appropriate code
if [[ $overall_pass -eq 1 ]]; then
    exit 0
else
    exit 1
fi
