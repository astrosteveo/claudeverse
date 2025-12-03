#!/bin/bash

# SubagentStop hook for capturing feature-dev architecture specs and task breakdowns
# This hook triggers when any subagent completes

# Extract the subagent type from the event data
SUBAGENT_TYPE=$(echo "$CLAUDE_HOOK_EVENT_JSON" | jq -r '.subagent_type // empty')

# Only process code-architect subagents (which contain architecture specs)
if [[ "$SUBAGENT_TYPE" == "feature-dev:code-architect" ]]; then
    # Extract the full transcript
    TRANSCRIPT=$(echo "$CLAUDE_HOOK_EVENT_JSON" | jq -r '.transcript // empty')

    if [[ -n "$TRANSCRIPT" ]]; then
        # Call the memory writer script
        "${CLAUDE_PLUGIN_ROOT}/scripts/save-architecture-spec.sh" "$TRANSCRIPT"
    fi
fi

# Also capture code-explorer outputs for context
if [[ "$SUBAGENT_TYPE" == "feature-dev:code-explorer" ]]; then
    TRANSCRIPT=$(echo "$CLAUDE_HOOK_EVENT_JSON" | jq -r '.transcript // empty')

    if [[ -n "$TRANSCRIPT" ]]; then
        # Call the exploration writer script
        "${CLAUDE_PLUGIN_ROOT}/scripts/save-exploration-notes.sh" "$TRANSCRIPT"
    fi
fi

# Allow the event to proceed
exit 0
