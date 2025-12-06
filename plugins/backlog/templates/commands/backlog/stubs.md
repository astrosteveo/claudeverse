---
description: Scan codebase for stubs and incomplete implementations
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
---

# Scan for Stubs

Scan the codebase for TODO, FIXME, NotImplementedError, and other stub patterns.

## Process

### 1. Run Stub Detection

Use grep to search for common stub patterns:

**TODO/FIXME Comments:**
- `TODO` (case insensitive)
- `FIXME` (case insensitive)
- `XXX`
- `HACK`

**Unimplemented Exceptions/Errors:**
- `NotImplementedError`
- `raise NotImplementedError`
- `throw new Error("not implemented")`
- `throw new Error('not implemented')`
- `panic("not implemented")`
- `unimplemented!()`
- `todo!()`

**Placeholder Returns:**
- `return null  # TODO`
- `return {}  # TODO`
- `return []  # TODO`
- `pass  # TODO`

### 2. Exclude Directories

Skip common non-source directories:
- `node_modules/`
- `vendor/`
- `venv/`
- `.venv/`
- `__pycache__/`
- `.git/`
- `dist/`
- `build/`
- `target/`
- `.claude/`

### 3. Group Results

Group by file and show context:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STUB SCAN RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Found <N> stubs in <M> files:

  ## src/inventory.ts
    :45  TODO: implement addItem logic
    :78  // FIXME: handle edge case

  ## src/pickup.ts
    :23  throw new Error("not implemented")

  ## src/storage.ts
    :102  // TODO: add validation

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Summary:
    TODO: 3
    FIXME: 1
    NotImplementedError: 1
    Total: 5

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 4. No Stubs Found

If no stubs detected:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  STUB SCAN: CLEAN ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  No stubs found in codebase.
  All implementations appear complete.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Severity Levels

Stubs are categorized by severity:

| Type | Severity | Description |
|------|----------|-------------|
| `NotImplementedError`, `throw Error("not implemented")` | High | Will crash at runtime |
| `TODO`, `FIXME` | Medium | Incomplete but may work |
| `XXX`, `HACK` | Low | Known issues, may be intentional |

## Notes

- This is the same scan run by `/backlog:done`
- Use to check overall codebase health
- Results don't update backlog state automatically
- Consider running before major commits
