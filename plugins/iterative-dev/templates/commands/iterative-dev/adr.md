---
description: Create an architecture decision record for significant cross-cutting decisions
argument-hint: <decision-title>
allowed-tools:
  - Read
  - Write
  - Glob
  - Bash
---

# Create Architecture Decision Record

**Input**: $ARGUMENTS

## When to Use ADRs

ADRs are for **significant, cross-cutting decisions** - NOT routine feature work.

**Create an ADR when:**
- Decision affects multiple features or the entire codebase
- You're reversing a previous architectural choice
- Multiple people need to understand "why we do things this way"
- The decision involves trade-offs that will be questioned later

**Don't create an ADR when:**
- It's a library choice within a single feature (use Research Findings in scope doc)
- You're following existing codebase patterns
- The decision is obvious with no real alternatives
- It's implementation details, not architecture

## Actions

1. **Validate this needs an ADR**:
   - If this is a single-feature decision, suggest documenting in the scope doc's Research Findings instead
   - If user confirms it's cross-cutting, proceed

2. **Find next ADR number**:
   ```bash
   ls docs/adrs/ 2>/dev/null | grep -oE '^[0-9]+' | sort -n | tail -1
   ```
   - If no ADRs exist, start at 0001
   - Otherwise, increment the highest number

3. **Create ADR file**:
   - Location: `docs/adrs/NNNN-<decision-slug>.md`
   - Use template from `${CLAUDE_PLUGIN_ROOT}/templates/adr-template.md`
   - Fill in the title, date, and feature reference

4. **Guide the user through sections**:
   - Ask about the context/problem
   - Ask what options were considered
   - Document the chosen approach and rationale
   - Note trade-offs and future considerations

5. **Link to active feature** (if applicable):
   - If there's an active iteration, reference this ADR in the scope doc

## Output

Display the created ADR path and remind user:
```
Created: docs/adrs/NNNN-<slug>.md

Remember: Most decisions belong in scope docs, not ADRs.
ADRs are for cross-cutting architectural decisions that affect
multiple features or need to be understood by future contributors.
```
