# PRD: CLAUDE.md Maintenance System

**Status**: Implemented (Retroactive Documentation)
**Priority**: High
**Created**: 2025-12-02
**Owner**: TDD Plugin Team

## Overview

Automatically maintain a `CLAUDE.md` file at the project root that provides Claude with up-to-date context about the TDD workflow state, recent activity, and key documentation locations.

## Problem Statement

When Claude starts a new session, it has no context about:
- Current TDD workflow status
- Active features being developed
- Recent violations or issues
- Where to find specifications and test files
- Project enforcement settings

This leads to repeated questions and context gathering at the start of each session.

## Goals

1. **Automatic Context Loading**: Provide Claude with instant access to project state
2. **Session Continuity**: Bridge information across sessions
3. **Documentation Discovery**: Point to all relevant TDD documentation files
4. **Real-time Status**: Show current violations, enforcement mode, and active features
5. **Zero Maintenance**: Fully automated via hooks, no manual updates required

## Non-Goals

- Replacing detailed documentation files (specs, ADRs, etc.)
- Storing large amounts of duplicated data
- Version control or history tracking (that's git's job)
- Cross-project context sharing

## Success Metrics

- Claude can understand project state within first prompt
- Reduced "Where is...?" questions
- Faster session startup
- Accurate violation counts and status

## User Stories

### US-1: Session Startup Context
**As** Claude
**I want** to read CLAUDE.md when a session starts
**So that** I immediately understand the project state without asking questions

**Acceptance Criteria**:
- CLAUDE.md exists at project root
- Contains current TDD enforcement mode
- Shows violation counts (total and unresolved)
- Lists all key documentation locations
- Updates automatically at session end

### US-2: Feature Context Discovery
**As** Claude
**I want** to see which feature is currently active
**So that** I can continue work on the right feature without asking

**Acceptance Criteria**:
- CLAUDE.md references `.claude/current-feature.txt`
- Shows recent activity from session log
- Points to feature spec locations
- Indicates if no feature is active

### US-3: Documentation Navigation
**As** Claude
**I want** a central reference to all TDD documentation
**So that** I can quickly find specs, tests, and requirements

**Acceptance Criteria**:
- Lists all spec template locations
- Shows manifest file location
- References violations log
- Includes quick command reference

## Technical Requirements

### Functional Requirements

1. **File Generation**
   - Create CLAUDE.md if it doesn't exist
   - Update existing CLAUDE.md preserving non-TDD content
   - Use clear section markers for TDD content

2. **Content Sections**
   - Project configuration (name, mode, violations)
   - Key documentation locations (specs, tests, logs)
   - Recent activity summary (last 20 lines)
   - Quick command reference
   - Usage instructions

3. **Data Sources**
   - Read from `.claude/tdd-plugin.local.md` (settings)
   - Read from `.claude/specs-manifest.yaml` (project info)
   - Read from `.claude/tdd-violations.json` (violation counts)
   - Read from `.claude/tdd-session-log.md` (recent activity)

4. **Update Triggers**
   - SessionEnd hook (always)
   - Optional: After significant file changes

### Non-Functional Requirements

1. **Performance**: Updates must complete in <5 seconds
2. **Reliability**: Must handle missing files gracefully
3. **Idempotency**: Running multiple times produces consistent results
4. **Safety**: Never corrupts existing CLAUDE.md content

## Implementation Notes

### Script Location
`plugins/tdd-plugin/scripts/update-claude-md.sh`

### Hook Integration
```json
"SessionEnd": [{
  "hooks": [{
    "type": "command",
    "command": "bash \"${CLAUDE_PLUGIN_ROOT}/scripts/update-claude-md.sh\"",
    "timeout": 20
  }]
}]
```

### Content Structure
```markdown
# Project Context for Claude

[User content preserved]

---

## TDD Workflow Status

**Last Updated**: [timestamp]

### Project Configuration
- Project: [name]
- Enforcement Mode: [mode]
- Violations: [count]

### Key Documentation Locations
[Links to all docs]

### Recent Activity
[Last session summary]

### Quick Commands
[Command reference]

---
```

## Test Cases

See `test-cases.md` for detailed test scenarios.

## Open Questions

- ✅ Should we update on every Write/Edit or just SessionEnd?
  - **Decision**: SessionEnd only to avoid overhead
- ✅ How to handle projects without git?
  - **Decision**: Works fine, just shows basic info
- ✅ Should we track history of CLAUDE.md changes?
  - **Decision**: No, git handles that

## Future Enhancements

1. Add AI-generated session summaries
2. Include code coverage trends
3. Show recent git commits
4. Add project-specific reminders
5. Integration with ADR documentation

## Rollout Plan

**Phase 1** (Completed): Basic implementation
- Create update script
- Add SessionEnd hook
- Test with current project

**Phase 2**: Validation
- Write comprehensive tests
- Validate with multiple projects
- Handle edge cases

**Phase 3**: Enhancement
- Add more context sources
- Improve formatting
- User customization options
