# backlog

Lightweight story-based backlog tracking for Claude Code with state persistence across sessions.

## Why

- **Context limits derail multi-session work** - compacting/new sessions lose the thread
- **Stub accumulation** - days of work, thousands of lines, but functions aren't integrated
- **Need visibility** - what's done, what's blocked, what's next

## Philosophy

- **Single state file** - one `backlog.yaml` tracks everything
- **Story-based, not phase-based** - flexible Kanban-style workflow
- **Advisory enforcement** - warns about issues, doesn't block unless you want it to
- **Effort, not time** - r3/r5/r9 tiers, no deadlines

## Quick Start

```bash
# Initialize backlog in your project
/backlog:init

# Add stories
/backlog:add "User authentication" --effort r5

# Start working
/backlog:start AUTH-001

# Mark done (runs stub check)
/backlog:done AUTH-001

# Save state before clearing context
/backlog:save "Finished auth, starting on profiles next"

# Resume in new session
/backlog:resume
```

## Commands

| Command | Description |
|---------|-------------|
| `/backlog` | View current backlog grouped by status |
| `/backlog:init` | Initialize backlog in project |
| `/backlog:add <title> [--effort r3\|r5\|r9]` | Add a new story |
| `/backlog:start <id>` | Mark story as in-progress |
| `/backlog:done <id>` | Mark story as done (runs stub check) |
| `/backlog:block <id> --by <id>` | Mark story as blocked by another |
| `/backlog:unblock <id>` | Remove blocker from story |
| `/backlog:save [reason]` | Save current state with notes |
| `/backlog:resume` | Resume from saved state |
| `/backlog:stubs` | Scan codebase for stubs |

## Effort Tiers

Instead of time estimates:

| Tier | Meaning |
|------|---------|
| `r3` | Small - straightforward, low complexity |
| `r5` | Medium - moderate complexity, some unknowns |
| `r9` | Large - high complexity, significant effort |

## State File

All state lives in `.claude/backlog.yaml`:

```yaml
project: my-project
epic: "Current Feature"

stories:
  - id: FEAT-001
    title: "Basic functionality"
    effort: r5
    status: done

  - id: FEAT-002
    title: "Integration layer"
    effort: r5
    status: in-progress
    blocked_by: []
    stubs: []

  - id: FEAT-003
    title: "UI components"
    effort: r9
    status: blocked
    blocked_by: [FEAT-002]
    notes: "Waiting on integration"

session:
  last_saved: "2025-12-05T10:30:00Z"
  current_focus: FEAT-002
  resume_notes: "Working on API client. Auth done, storage next."
```

## Anti-Stubbing

When marking a story as done, the plugin scans for:
- `TODO` comments
- `FIXME` comments
- `NotImplementedError`
- `throw new Error("not implemented")`
- Placeholder returns (`return null`, `return {}`, etc.)

If found, you'll get a warning with locations. You can:
1. Fix the stubs and retry
2. Acknowledge and proceed anyway (tracked in state)

## Resume Flow

When you start a new session with an existing backlog:

```
Found backlog: my-project
  5 stories: 2 done, 1 in-progress, 2 blocked

  Current focus: FEAT-002 "Integration layer"

  Blockers:
    FEAT-003 blocked by FEAT-002
    FEAT-004 blocked by FEAT-002

  Resume notes: "Working on API client. Auth done, storage next."

Continue? [y/n]
```

## Installation

1. Clone or copy to your claudeverse plugins directory
2. Run `/backlog:init` in your project
3. Start adding stories

## License

MIT
