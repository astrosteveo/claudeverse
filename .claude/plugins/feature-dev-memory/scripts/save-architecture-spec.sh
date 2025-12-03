#!/bin/bash

# Save architecture specification from code-architect subagent to project memory
TRANSCRIPT="$1"

# Create memory directory if it doesn't exist
MEMORY_DIR=".claude/memory/feature-specs"
mkdir -p "$MEMORY_DIR"

# Generate timestamp for filename
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Extract feature name from transcript if possible (look for common patterns)
# Try to find a feature description in the first few lines
FEATURE_NAME=$(echo "$TRANSCRIPT" | grep -i -m 1 -E "(feature|implementing|building|creating)" | \
    sed -E 's/.*\b(feature|implementing|building|creating)\b\s*:?\s*([^.,:]+).*/\2/' | \
    tr '[:upper:]' '[:lower:]' | \
    tr -s ' ' '-' | \
    sed 's/[^a-z0-9-]//g' | \
    cut -c1-50)

# If we couldn't extract a name, use a default
if [[ -z "$FEATURE_NAME" || "$FEATURE_NAME" == "$TRANSCRIPT" ]]; then
    FEATURE_NAME="feature"
fi

# Create the spec file
SPEC_FILE="${MEMORY_DIR}/${TIMESTAMP}-${FEATURE_NAME}-architecture.md"

# Write the spec with metadata header
cat > "$SPEC_FILE" << SPEC_HEADER
# Feature Architecture Specification

**Generated:** $(date +"%Y-%m-%d %H:%M:%S")
**Source:** feature-dev:code-architect subagent
**Plugin:** feature-dev-memory

---

SPEC_HEADER

# Append the actual transcript
echo "$TRANSCRIPT" >> "$SPEC_FILE"

# Create a symlink to the latest spec
ln -sf "$(basename "$SPEC_FILE")" "${MEMORY_DIR}/latest-architecture.md"

# Log success
echo "[feature-dev-memory] Architecture spec saved to: $SPEC_FILE" >&2

exit 0
