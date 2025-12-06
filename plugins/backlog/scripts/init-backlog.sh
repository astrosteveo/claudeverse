#!/bin/bash

# Backlog Plugin - Project Initialization Script
# Creates .claude/backlog.yaml and sets up project for backlog tracking

set -e

PROJECT_DIR="${1:-$PWD}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  BACKLOG PLUGIN INITIALIZATION${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Detect project name
if [[ -f "$PROJECT_DIR/package.json" ]]; then
    PROJECT_NAME=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' "$PROJECT_DIR/package.json" | head -1 | cut -d'"' -f4)
elif [[ -f "$PROJECT_DIR/Cargo.toml" ]]; then
    PROJECT_NAME=$(grep -o '^name[[:space:]]*=[[:space:]]*"[^"]*"' "$PROJECT_DIR/Cargo.toml" | head -1 | cut -d'"' -f2)
elif [[ -f "$PROJECT_DIR/go.mod" ]]; then
    PROJECT_NAME=$(head -1 "$PROJECT_DIR/go.mod" | awk '{print $2}' | xargs basename)
elif [[ -f "$PROJECT_DIR/pyproject.toml" ]]; then
    PROJECT_NAME=$(grep -o '^name[[:space:]]*=[[:space:]]*"[^"]*"' "$PROJECT_DIR/pyproject.toml" | head -1 | cut -d'"' -f2)
else
    PROJECT_NAME=$(basename "$PROJECT_DIR")
fi

echo -e "  Project: ${GREEN}$PROJECT_NAME${NC}"
echo -e "  Directory: $PROJECT_DIR"
echo ""

# Create .claude directory if it doesn't exist
CLAUDE_DIR="$PROJECT_DIR/.claude"
if [[ ! -d "$CLAUDE_DIR" ]]; then
    mkdir -p "$CLAUDE_DIR"
    echo -e "  ${GREEN}Created${NC} .claude directory"
fi

# Check if backlog already exists
BACKLOG_FILE="$CLAUDE_DIR/backlog.yaml"
if [[ -f "$BACKLOG_FILE" ]]; then
    echo -e "  ${YELLOW}Warning:${NC} backlog.yaml already exists"
    echo -e "  Use /backlog:resume to continue existing work"
    echo ""
    exit 0
fi

# Generate ID prefix from project name (uppercase, max 4 chars)
ID_PREFIX=$(echo "$PROJECT_NAME" | tr '[:lower:]' '[:upper:]' | tr -cd '[:alnum:]' | head -c 4)
if [[ -z "$ID_PREFIX" ]]; then
    ID_PREFIX="TASK"
fi

# Create backlog.yaml
cat > "$BACKLOG_FILE" << EOF
# Backlog State File
# Project: $PROJECT_NAME
# Generated: $(date -Iseconds)

project: "$PROJECT_NAME"
epic: ""

# Story ID prefix and counter
id_prefix: "$ID_PREFIX"
id_counter: 0

stories: []

session:
  last_saved: "$(date -Iseconds)"
  current_focus: ""
  resume_notes: "Fresh backlog initialized. Use /backlog:add to create stories."
EOF

echo -e "  ${GREEN}Created${NC} .claude/backlog.yaml"

# Create commands directory if needed
COMMANDS_DIR="$CLAUDE_DIR/commands/backlog"
if [[ ! -d "$COMMANDS_DIR" ]]; then
    mkdir -p "$COMMANDS_DIR"
    echo -e "  ${GREEN}Created${NC} .claude/commands/backlog/"
fi

# Copy/symlink command files
TEMPLATE_COMMANDS="$PLUGIN_ROOT/templates/commands/backlog"
if [[ -d "$TEMPLATE_COMMANDS" ]]; then
    for cmd_file in "$TEMPLATE_COMMANDS"/*.md; do
        if [[ -f "$cmd_file" ]]; then
            cmd_name=$(basename "$cmd_file")
            cp "$cmd_file" "$COMMANDS_DIR/$cmd_name"
            echo -e "  ${GREEN}Installed${NC} /backlog:${cmd_name%.md}"
        fi
    done
fi

# Copy main backlog command
MAIN_CMD="$PLUGIN_ROOT/templates/commands/backlog.md"
if [[ -f "$MAIN_CMD" ]]; then
    cp "$MAIN_CMD" "$CLAUDE_DIR/commands/backlog.md"
    echo -e "  ${GREEN}Installed${NC} /backlog"
fi

# Add to .gitignore if git repo
if [[ -d "$PROJECT_DIR/.git" ]]; then
    GITIGNORE="$PROJECT_DIR/.gitignore"
    if ! grep -q "^\.claude/backlog\.yaml$" "$GITIGNORE" 2>/dev/null; then
        echo "" >> "$GITIGNORE"
        echo "# Backlog plugin state (session-specific)" >> "$GITIGNORE"
        echo ".claude/backlog.yaml" >> "$GITIGNORE"
        echo -e "  ${GREEN}Updated${NC} .gitignore"
    fi
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  INITIALIZATION COMPLETE${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  Next steps:"
echo -e "    1. /backlog:add \"Your first story\" --effort r5"
echo -e "    2. /backlog:start ${ID_PREFIX}-001"
echo -e "    3. /backlog to view current state"
echo ""
