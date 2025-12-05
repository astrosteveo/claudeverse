#!/usr/bin/env bash
#
# detect-test-framework.sh - Auto-detect testing framework for the project
#
# Detection priority:
#   1. Check settings file for explicit framework
#   2. Check package.json / requirements.txt / go.mod / Gemfile
#   3. Scan for test file patterns
#   4. Prompt user if ambiguous
#
# Exit codes:
#   0 - Framework detected successfully
#   1 - Could not detect framework

set -euo pipefail

# Default values
SETTINGS_FILE=".claude/tdd-plugin.local.md"
OUTPUT_FORMAT="text"
VERBOSE=false

# Usage information
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Auto-detect the testing framework used in the current project.

OPTIONS:
    -s, --settings FILE       Settings file path (default: .claude/tdd-plugin.local.md)
    -o, --output FORMAT       Output format: text, json (default: text)
    -v, --verbose             Enable verbose output
    -h, --help                Show this help message

SUPPORTED FRAMEWORKS:
    - jest (JavaScript/TypeScript)
    - vitest (JavaScript/TypeScript)
    - mocha (JavaScript/TypeScript)
    - pytest (Python)
    - unittest (Python)
    - gotest (Go)
    - rspec (Ruby)
    - minitest (Ruby)

EXAMPLES:
    # Detect framework
    $(basename "$0")

    # JSON output
    $(basename "$0") -o json

EXIT CODES:
    0 - Framework detected successfully
    1 - Could not detect framework
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--settings)
            SETTINGS_FILE="$2"
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

# Detected framework and confidence
FRAMEWORK=""
CONFIDENCE=""
DETECTION_METHOD=""

# 1. Check settings file for explicit configuration
log "Checking settings file: $SETTINGS_FILE"
if [[ -f "$SETTINGS_FILE" ]]; then
    framework_from_settings=$(grep "^testFramework:" "$SETTINGS_FILE" 2>/dev/null | sed 's/testFramework: *//' | tr -d ' ')

    if [[ -n "$framework_from_settings" && "$framework_from_settings" != "auto" ]]; then
        FRAMEWORK="$framework_from_settings"
        CONFIDENCE="explicit"
        DETECTION_METHOD="settings-file"
        log "Found explicit framework in settings: $FRAMEWORK"
    fi
fi

# 2. Check package manager files if not found in settings
if [[ -z "$FRAMEWORK" ]]; then
    log "Checking package manager files..."

    # JavaScript/TypeScript - package.json
    if [[ -f "package.json" ]]; then
        log "Found package.json"

        if grep -q '"jest"' package.json; then
            FRAMEWORK="jest"
            CONFIDENCE="high"
            DETECTION_METHOD="package.json (dependency)"
        elif grep -q '"vitest"' package.json; then
            FRAMEWORK="vitest"
            CONFIDENCE="high"
            DETECTION_METHOD="package.json (dependency)"
        elif grep -q '"mocha"' package.json; then
            FRAMEWORK="mocha"
            CONFIDENCE="high"
            DETECTION_METHOD="package.json (dependency)"
        elif grep -q '"@jest/core"' package.json; then
            FRAMEWORK="jest"
            CONFIDENCE="high"
            DETECTION_METHOD="package.json (dependency)"
        fi
    fi

    # Python - requirements.txt or setup.py
    if [[ -z "$FRAMEWORK" ]]; then
        if [[ -f "requirements.txt" ]]; then
            log "Found requirements.txt"

            if grep -qi "pytest" requirements.txt; then
                FRAMEWORK="pytest"
                CONFIDENCE="high"
                DETECTION_METHOD="requirements.txt"
            elif grep -qi "unittest" requirements.txt; then
                FRAMEWORK="unittest"
                CONFIDENCE="medium"
                DETECTION_METHOD="requirements.txt"
            fi
        elif [[ -f "setup.py" ]]; then
            log "Found setup.py"

            if grep -qi "pytest" setup.py; then
                FRAMEWORK="pytest"
                CONFIDENCE="high"
                DETECTION_METHOD="setup.py"
            fi
        elif [[ -f "pyproject.toml" ]]; then
            log "Found pyproject.toml"

            if grep -qi "pytest" pyproject.toml; then
                FRAMEWORK="pytest"
                CONFIDENCE="high"
                DETECTION_METHOD="pyproject.toml"
            fi
        fi
    fi

    # Go - go.mod (Go test is built-in, just check for Go project)
    if [[ -z "$FRAMEWORK" && -f "go.mod" ]]; then
        log "Found go.mod"
        FRAMEWORK="gotest"
        CONFIDENCE="high"
        DETECTION_METHOD="go.mod (builtin)"
    fi

    # Ruby - Gemfile
    if [[ -z "$FRAMEWORK" && -f "Gemfile" ]]; then
        log "Found Gemfile"

        if grep -qi "rspec" Gemfile; then
            FRAMEWORK="rspec"
            CONFIDENCE="high"
            DETECTION_METHOD="Gemfile"
        elif grep -qi "minitest" Gemfile; then
            FRAMEWORK="minitest"
            CONFIDENCE="high"
            DETECTION_METHOD="Gemfile"
        fi
    fi
fi

# 3. Scan for test file patterns if still not found
if [[ -z "$FRAMEWORK" ]]; then
    log "Scanning for test file patterns..."

    js_test_files=$(find . -type f \( -name "*.test.js" -o -name "*.spec.js" -o -name "*.test.ts" -o -name "*.spec.ts" \) 2>/dev/null | wc -l)
    py_test_files=$(find . -type f \( -name "*_test.py" -o -name "test_*.py" \) 2>/dev/null | wc -l)
    go_test_files=$(find . -type f -name "*_test.go" 2>/dev/null | wc -l)
    rb_spec_files=$(find . -type f -name "*_spec.rb" 2>/dev/null | wc -l)

    log "Test files found - JS: $js_test_files, Python: $py_test_files, Go: $go_test_files, Ruby: $rb_spec_files"

    # Determine most likely framework based on file patterns
    if [[ $js_test_files -gt 0 ]]; then
        # Default to Jest for JavaScript (most popular)
        FRAMEWORK="jest"
        CONFIDENCE="medium"
        DETECTION_METHOD="test-file-pattern (default for JS)"
    elif [[ $py_test_files -gt 0 ]]; then
        # Default to Pytest for Python (most popular)
        FRAMEWORK="pytest"
        CONFIDENCE="medium"
        DETECTION_METHOD="test-file-pattern (default for Python)"
    elif [[ $go_test_files -gt 0 ]]; then
        FRAMEWORK="gotest"
        CONFIDENCE="high"
        DETECTION_METHOD="test-file-pattern"
    elif [[ $rb_spec_files -gt 0 ]]; then
        FRAMEWORK="rspec"
        CONFIDENCE="high"
        DETECTION_METHOD="test-file-pattern"
    fi
fi

# Output results
if [[ -n "$FRAMEWORK" ]]; then
    if [[ "$OUTPUT_FORMAT" == "json" ]]; then
        cat << EOF
{
  "framework": "$FRAMEWORK",
  "confidence": "$CONFIDENCE",
  "detectionMethod": "$DETECTION_METHOD",
  "detected": true
}
EOF
    else
        echo "Detected Framework: $FRAMEWORK"
        echo "Confidence: $CONFIDENCE"
        echo "Detection Method: $DETECTION_METHOD"

        # Provide guidance based on confidence
        if [[ "$CONFIDENCE" == "medium" ]]; then
            echo ""
            echo "⚠️  Medium confidence detection. Consider setting explicitly in $SETTINGS_FILE:"
            echo ""
            echo "testFramework: $FRAMEWORK"
        fi
    fi
    exit 0
else
    if [[ "$OUTPUT_FORMAT" == "json" ]]; then
        cat << EOF
{
  "framework": null,
  "confidence": "none",
  "detectionMethod": null,
  "detected": false,
  "message": "Could not detect testing framework. Please configure explicitly in $SETTINGS_FILE"
}
EOF
    else
        echo "Could not detect testing framework."
        echo ""
        echo "Please configure explicitly in $SETTINGS_FILE:"
        echo ""
        echo "testFramework: jest      # For JavaScript/TypeScript (Jest)"
        echo "testFramework: pytest    # For Python (Pytest)"
        echo "testFramework: gotest    # For Go"
        echo "testFramework: rspec     # For Ruby (RSpec)"
        echo ""
        echo "Supported frameworks: jest, vitest, mocha, pytest, unittest, gotest, rspec, minitest"
    fi
    exit 1
fi
