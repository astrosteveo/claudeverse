# Feature Dev Memory Plugin

Automatically captures and persists feature specifications, architecture designs, and codebase exploration notes from the `/feature-dev:feature-dev` workflow to project memory.

## Overview

This plugin hooks into the feature-dev workflow to ensure that all valuable architectural decisions, specifications, and exploration notes are automatically saved to your project's `.claude/memory/feature-specs/` directory. This creates a permanent record of feature development that can be referenced later.

## What Gets Captured

### 1. Architecture Specifications
When the `code-architect` subagent completes, the plugin captures:
- Complete architecture blueprints
- Component design decisions
- Implementation maps with specific files to create/modify
- Data flow diagrams
- Build sequences and phased implementation steps
- Error handling, state management, and security considerations

Saved to: `.claude/memory/feature-specs/YYYYMMDD-HHMMSS-{feature-name}-architecture.md`

### 2. Codebase Exploration Notes
When the `code-explorer` subagent completes, the plugin captures:
- Feature discovery findings
- Code flow traces
- Architecture analysis
- Implementation details
- Dependencies and integrations
- Key files and references

Saved to: `.claude/memory/feature-specs/explorations/YYYYMMDD-HHMMSS-{topic}.md`

## Directory Structure

```
.claude/
└── memory/
    └── feature-specs/
        ├── latest-architecture.md (symlink to most recent)
        ├── 20231202-143022-user-auth-architecture.md
        ├── 20231202-150133-api-caching-architecture.md
        └── explorations/
            ├── 20231202-142500-auth-system.md
            └── 20231202-145800-api-layer.md
```

## How It Works

The plugin uses the `SubagentStop` hook to intercept when feature-dev subagents complete:

1. **Hook Detection**: The `SubagentStop.sh` hook monitors for completion of `code-architect` and `code-explorer` subagents
2. **Transcript Extraction**: Extracts the complete transcript from the subagent's execution
3. **File Generation**: Saves the transcript to timestamped markdown files with metadata headers
4. **Symlink Update**: Updates `latest-architecture.md` to point to the most recent architecture spec

## Usage

Simply run the `/feature-dev:feature-dev` command as usual. The plugin works transparently in the background:

```
/feature-dev:feature-dev Add user authentication
```

After the workflow completes, check `.claude/memory/feature-specs/` for saved specifications.

## Benefits

- **Knowledge Preservation**: Never lose architectural decisions or exploration findings
- **Team Collaboration**: Share specs with team members
- **Documentation**: Automatic feature documentation
- **Context for Future Work**: Reference past decisions when working on related features
- **Audit Trail**: Track how features evolved over time

## Configuration

No configuration needed! The plugin works out of the box.

## File Naming

Files are automatically named using:
- Timestamp: `YYYYMMDD-HHMMSS` for chronological ordering
- Feature/Topic name: Extracted from transcript content
- Type suffix: `-architecture` or exploration topic

## Troubleshooting

### Files not being created

1. Ensure the plugin is installed in `.claude/plugins/feature-dev-memory/`
2. Check that hook scripts are executable: `chmod +x .claude/plugins/feature-dev-memory/hooks/*.sh .claude/plugins/feature-dev-memory/scripts/*.sh`
3. Verify you're running `/feature-dev:feature-dev` (not just regular commands)

### Permission errors

The plugin creates directories automatically, but ensure you have write permissions in your project directory.

## Plugin Details

- **Name**: feature-dev-memory
- **Version**: 1.0.0
- **Hooks Used**: `SubagentStop`
- **Target**: `feature-dev:code-architect` and `feature-dev:code-explorer` subagents

## License

This plugin is provided as-is for use with Claude Code.
