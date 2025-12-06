---
description: Add a new story to the backlog
argument-hint: <title> [--effort r3|r5|r9]
allowed-tools:
  - Read
  - Write
---

# Add Story to Backlog

Add a new story to the backlog with an auto-generated ID.

## Arguments

- `title` (required): The story title/description
- `--effort` (optional): Effort tier - r3 (small), r5 (medium), r9 (large). Defaults to r5.

## Process

### 1. Load Backlog State

Read `.claude/backlog.yaml`. If not found, tell user to run `/backlog:init` first.

### 2. Parse Arguments

Extract:
- `title`: Everything before `--effort` or the entire argument
- `effort`: Value after `--effort`, default to `r5`

Validate effort is one of: r3, r5, r9

### 3. Generate Story ID

1. Read `id_prefix` and `id_counter` from backlog
2. Increment counter: `new_counter = id_counter + 1`
3. Generate ID: `<id_prefix>-<padded_counter>` (e.g., `PROJ-001`)

### 4. Create Story Object

```yaml
- id: "<generated-id>"
  title: "<title>"
  effort: "<effort>"
  status: backlog
  blocked_by: []
  stubs: []
  stubs_acknowledged: false
  notes: ""
  created_at: "<ISO-8601 timestamp>"
  completed_at: ""
```

### 5. Update Backlog

1. Append story to `stories` array
2. Update `id_counter`
3. Update `session.last_saved`
4. Write back to `.claude/backlog.yaml`

### 6. Display Confirmation

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STORY ADDED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  <id> <title>
  Effort: <effort>
  Status: backlog

  To start working: /backlog:start <id>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Examples

```
/backlog:add "User authentication"
/backlog:add "Complex data pipeline" --effort r9
/backlog:add "Fix login button" --effort r3
```
