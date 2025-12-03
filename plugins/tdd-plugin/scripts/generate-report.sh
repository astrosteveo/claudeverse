#!/usr/bin/env bash
#
# generate-report.sh - Generate TDD compliance report
#
# Creates comprehensive markdown report with:
#   - Spec status
#   - Test coverage
#   - TDD compliance score
#   - Violations log
#   - Git statistics

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
OUTPUT_FILE=".claude/tdd-report.md"
MANIFEST_FILE=".claude/specs-manifest.yaml"
VIOLATIONS_FILE=".claude/tdd-violations.json"
INCLUDE_GIT_STATS=true
VERBOSE=false

# Usage information
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Generate a comprehensive TDD compliance report.

OPTIONS:
    -o, --output FILE         Output file path (default: .claude/tdd-report.md)
    -m, --manifest FILE       Specs manifest file (default: .claude/specs-manifest.yaml)
    --no-git-stats            Exclude Git statistics from report
    -v, --verbose             Enable verbose output
    -h, --help                Show this help message

EXAMPLES:
    # Generate default report
    $(basename "$0")

    # Custom output location
    $(basename "$0") -o docs/tdd-report.md

    # Without Git stats
    $(basename "$0") --no-git-stats

EXIT CODES:
    0 - Report generated successfully
    1 - Error generating report
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -m|--manifest)
            MANIFEST_FILE="$2"
            shift 2
            ;;
        --no-git-stats)
            INCLUDE_GIT_STATS=false
            shift
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
            exit 1
            ;;
    esac
done

# Log function for verbose output
log() {
    if [[ "$VERBOSE" == true ]]; then
        echo "$@" >&2
    fi
}

# Ensure output directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Get current timestamp
REPORT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

log "Generating TDD compliance report..."

# Initialize report
cat > "$OUTPUT_FILE" << EOF
# TDD Compliance Report

**Generated**: $REPORT_DATE

---

EOF

# Executive Summary
log "Generating executive summary..."
cat >> "$OUTPUT_FILE" << 'EOF'
## Executive Summary

EOF

# Count features and their statuses
if [[ -f "$MANIFEST_FILE" ]]; then
    total_features=$(grep -c "^  - name:" "$MANIFEST_FILE" 2>/dev/null || echo "0")
    planning_features=$(grep -A5 "^  - name:" "$MANIFEST_FILE" | grep -c "status: planning" 2>/dev/null || echo "0")
    in_progress_features=$(grep -A5 "^  - name:" "$MANIFEST_FILE" | grep -c "status: in-progress" 2>/dev/null || echo "0")
    testing_features=$(grep -A5 "^  - name:" "$MANIFEST_FILE" | grep -c "status: testing" 2>/dev/null || echo "0")
    complete_features=$(grep -A5 "^  - name:" "$MANIFEST_FILE" | grep -c "status: complete" 2>/dev/null || echo "0")

    cat >> "$OUTPUT_FILE" << EOF
- **Total Features**: $total_features
- **Planning**: $planning_features
- **In Progress**: $in_progress_features
- **Testing**: $testing_features
- **Complete**: $complete_features

EOF
else
    cat >> "$OUTPUT_FILE" << EOF
⚠️ Specs manifest not found at: \`$MANIFEST_FILE\`

Initialize with: \`/tdd:init-project\`

EOF
fi

# Violations summary
log "Checking violations..."
total_violations=0
unresolved_violations=0
if [[ -f "$VIOLATIONS_FILE" ]]; then
    total_violations=$(jq '.total // 0' "$VIOLATIONS_FILE" 2>/dev/null || echo "0")
    unresolved_violations=$(jq '[.history[]? | select(.resolved == false)] | length' "$VIOLATIONS_FILE" 2>/dev/null || echo "0")

    cat >> "$OUTPUT_FILE" << EOF
### TDD Compliance

- **Total Violations**: $total_violations
- **Unresolved**: $unresolved_violations
- **Compliance Rate**: $(awk "BEGIN {if ($total_violations > 0) printf \"%.1f\", (1 - $unresolved_violations / $total_violations) * 100; else print \"100.0\"}")%

EOF
else
    cat >> "$OUTPUT_FILE" << EOF
### TDD Compliance

✓ No violations recorded

EOF
fi

# Feature Details
log "Generating feature details..."
cat >> "$OUTPUT_FILE" << EOF
---

## Feature Status

EOF

if [[ -f "$MANIFEST_FILE" ]]; then
    # Parse YAML and extract feature information
    # This is a simplified parser - production version would use yq or similar
    features=$(grep "^  - name:" "$MANIFEST_FILE" | sed 's/^  - name: //')

    if [[ -z "$features" ]]; then
        cat >> "$OUTPUT_FILE" << EOF
No features tracked yet.

Initialize a feature with: \`/tdd:start-feature <name>\`

EOF
    else
        cat >> "$OUTPUT_FILE" << EOF
| Feature | Status | Tests | Coverage | Compliance |
|---------|--------|-------|----------|------------|
EOF

        while IFS= read -r feature; do
            # Extract feature details (simplified - would need proper YAML parsing)
            status="unknown"
            total_tests="0"
            coverage="N/A"
            compliance="N/A"

            # Try to extract status (this is brittle - improve with yq)
            feature_section=$(sed -n "/- name: $feature/,/^  - name:/p" "$MANIFEST_FILE")
            if echo "$feature_section" | grep -q "status:"; then
                status=$(echo "$feature_section" | grep "status:" | head -1 | sed 's/.*status: //' | tr -d ' ')
            fi

            # Status emoji
            case "$status" in
                planning) status_display="📋 Planning" ;;
                in-progress) status_display="🚧 In Progress" ;;
                testing) status_display="🧪 Testing" ;;
                complete) status_display="✅ Complete" ;;
                *) status_display="❓ Unknown" ;;
            esac

            echo "| \`$feature\` | $status_display | $total_tests | $coverage | $compliance |" >> "$OUTPUT_FILE"
        done <<< "$features"

        echo "" >> "$OUTPUT_FILE"
    fi
else
    cat >> "$OUTPUT_FILE" << EOF
⚠️ No manifest file found. Initialize with \`/tdd:init-project\`.

EOF
fi

# Test Coverage
log "Analyzing test coverage..."
cat >> "$OUTPUT_FILE" << EOF
---

## Test Coverage

EOF

# Look for coverage files
coverage_files=$(find . -name "lcov.info" -o -name "coverage.xml" -o -name ".coverage" 2>/dev/null | head -5)

if [[ -n "$coverage_files" ]]; then
    cat >> "$OUTPUT_FILE" << EOF
### Coverage Files Found

EOF

    while IFS= read -r cov_file; do
        echo "- \`$cov_file\`" >> "$OUTPUT_FILE"
    done <<< "$coverage_files"

    cat >> "$OUTPUT_FILE" << EOF

Run \`/tdd:checkpoint\` to validate coverage thresholds.

EOF
else
    cat >> "$OUTPUT_FILE" << EOF
No coverage files found.

Generate coverage with your test framework:
- **Jest**: \`npm test -- --coverage\`
- **Pytest**: \`pytest --cov\`
- **Go**: \`go test -cover\`
- **RSpec**: \`bundle exec rspec --coverage\`

EOF
fi

# Git Statistics
if [[ "$INCLUDE_GIT_STATS" == true ]]; then
    log "Generating Git statistics..."
    cat >> "$OUTPUT_FILE" << EOF
---

## Git Statistics

EOF

    if git rev-parse --git-dir >/dev/null 2>&1; then
        # Commits by phase (heuristic based on file patterns)
        spec_commits=$(git log --oneline --all -- "docs/specs/**/*.md" "docs/adrs/**/*.md" 2>/dev/null | wc -l)
        test_commits=$(git log --oneline --all -- "**/*.test.*" "**/*_test.*" "**/*_spec.*" 2>/dev/null | wc -l)
        impl_commits=$(git log --oneline --all -- "src/**/*" "lib/**/*" 2>/dev/null | wc -l)

        cat >> "$OUTPUT_FILE" << EOF
### Commits by Phase

- **Specification Commits**: $spec_commits
- **Test Commits**: $test_commits
- **Implementation Commits**: $impl_commits

EOF

        # Recent activity
        cat >> "$OUTPUT_FILE" << EOF
### Recent Activity (Last 7 Days)

EOF

        recent_activity=$(git log --oneline --since="7 days ago" --pretty=format:"- \`%h\` %s (%ar)" 2>/dev/null | head -10)

        if [[ -n "$recent_activity" ]]; then
            echo "$recent_activity" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
        else
            echo "No recent commits." >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
        fi

        # Contributors
        cat >> "$OUTPUT_FILE" << EOF
### Top Contributors

EOF

        git shortlog -sn --all | head -5 | awk '{print "- **" $2 " " $3 "**: " $1 " commits"}' >> "$OUTPUT_FILE" 2>/dev/null || echo "No contributors found." >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
    else
        cat >> "$OUTPUT_FILE" << EOF
⚠️ Not a Git repository. Git statistics unavailable.

EOF
    fi
fi

# Violations Detail
log "Generating violations detail..."
if [[ -f "$VIOLATIONS_FILE" ]]; then
    cat >> "$OUTPUT_FILE" << EOF
---

## Violations Log

EOF

    unresolved=$(jq '[.history[]? | select(.resolved == false)]' "$VIOLATIONS_FILE" 2>/dev/null)

    if [[ "$unresolved" == "[]" || -z "$unresolved" ]]; then
        cat >> "$OUTPUT_FILE" << EOF
✓ No unresolved violations

EOF
    else
        cat >> "$OUTPUT_FILE" << EOF
### Unresolved Violations

| Type | File | Message | Date |
|------|------|---------|------|
EOF

        echo "$unresolved" | jq -r '.[] | "| \(.type) | `\(.file)` | \(.message) | \(.timestamp) |"' >> "$OUTPUT_FILE" 2>/dev/null

        echo "" >> "$OUTPUT_FILE"
    fi
fi

# Recommendations
log "Generating recommendations..."
cat >> "$OUTPUT_FILE" << EOF
---

## Recommendations

EOF

# Generate recommendations based on state
recommendations=0

if [[ ! -f "$MANIFEST_FILE" ]]; then
    echo "1. 🔧 **Initialize TDD Plugin**: Run \`/tdd:init-project\` to set up directory structure and templates." >> "$OUTPUT_FILE"
    recommendations=$((recommendations + 1))
fi

if [[ "$unresolved_violations" -gt 0 ]]; then
    echo "$((recommendations + 1)). ⚠️ **Address Violations**: $unresolved_violations unresolved TDD violations found. Review and fix before proceeding." >> "$OUTPUT_FILE"
    recommendations=$((recommendations + 1))
fi

if [[ -z "$coverage_files" ]]; then
    echo "$((recommendations + 1)). 📊 **Enable Coverage**: Configure your test framework to generate coverage reports." >> "$OUTPUT_FILE"
    recommendations=$((recommendations + 1))
fi

if [[ "$recommendations" -eq 0 ]]; then
    cat >> "$OUTPUT_FILE" << EOF
✓ No critical recommendations. Keep up the good work!

Consider:
- Review test coverage for gaps
- Update specifications for in-progress features
- Run \`/tdd:checkpoint\` regularly to validate compliance

EOF
fi

# Footer
cat >> "$OUTPUT_FILE" << EOF

---

## Next Steps

- **Review Compliance**: Run \`/tdd:checkpoint\` for detailed validation
- **Start New Feature**: Use \`/tdd:start-feature <name>\` to begin with proper TDD workflow
- **Improve Coverage**: Focus on modules below threshold
- **Document Decisions**: Create ADRs for significant architectural choices

**Report Location**: \`$OUTPUT_FILE\`

*Generated by TDD Plugin v0.1.0*
EOF

log "Report generated successfully: $OUTPUT_FILE"

# Print summary to console
if [[ "$VERBOSE" == true ]]; then
    echo ""
    echo -e "${GREEN}✓ TDD Compliance Report Generated${NC}"
    echo ""
    echo "Location: $OUTPUT_FILE"
    echo "Features: $total_features"
    echo "Violations: $unresolved_violations unresolved"
    echo ""
fi

exit 0
