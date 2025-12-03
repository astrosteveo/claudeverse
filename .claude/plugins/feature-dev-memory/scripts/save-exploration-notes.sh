#!/bin/bash

# Save codebase exploration notes from code-explorer subagent to project memory
TRANSCRIPT="$1"

# Create memory directory if it doesn't exist
MEMORY_DIR=".claude/memory/feature-specs"
EXPLORATION_DIR="${MEMORY_DIR}/explorations"
mkdir -p "$EXPLORATION_DIR"

# Generate timestamp for filename
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Try to extract topic from transcript
TOPIC=$(echo "$TRANSCRIPT" | grep -i -m 1 -E "(analyzing|exploring|tracing|mapping)" | \
    sed -E 's/.*\b(analyzing|exploring|tracing|mapping)\b\s*:?\s*([^.,:]+).*/\2/' | \
    tr '[:upper:]' '[:lower:]' | \
    tr -s ' ' '-' | \
    sed 's/[^a-z0-9-]//g' | \
    cut -c1-50)

# If we couldn't extract a topic, use a default
if [[ -z "$TOPIC" || "$TOPIC" == "$TRANSCRIPT" ]]; then
    TOPIC="exploration"
fi

# Create the exploration file
EXPLORATION_FILE="${EXPLORATION_DIR}/${TIMESTAMP}-${TOPIC}.md"

# Write the exploration notes with metadata header
cat > "$EXPLORATION_FILE" << EXPLORATION_HEADER
# Codebase Exploration Notes

**Generated:** $(date +"%Y-%m-%d %H:%M:%S")
**Source:** feature-dev:code-explorer subagent
**Plugin:** feature-dev-memory

---

EXPLORATION_HEADER

# Append the actual transcript
echo "$TRANSCRIPT" >> "$EXPLORATION_FILE"

# Log success
echo "[feature-dev-memory] Exploration notes saved to: $EXPLORATION_FILE" >&2

exit 0
