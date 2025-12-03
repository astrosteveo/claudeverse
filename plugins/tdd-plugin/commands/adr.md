---
description: Create architecture decision record
argument-hint: <title of the decision>
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - TodoWrite
  - AskUserQuestion
---

# Create Architecture Decision Record

Document significant technical decisions with context, options, and rationale. ADRs create a searchable history of "why we did things this way."

## When to Create an ADR

- Major technology choices (frameworks, databases, languages)
- Architectural patterns (microservices, monolith, event-driven)
- Security decisions (auth approach, encryption, access control)
- Breaking changes to APIs or data models
- Deviations from established patterns
- Any decision you might need to explain later

## Task

Create an ADR for: $ARGUMENTS

## Implementation

### Phase 1: Context Gathering

**Goal**: Understand the decision being documented

**Actions**:
1. Parse the title: $ARGUMENTS
2. If title is vague, ask ONE clarifying question
3. Determine the next ADR number:
   ```bash
   # Find highest existing ADR number
   ls docs/adrs/*.md 2>/dev/null | grep -oP '\d{4}' | sort -n | tail -1
   ```
4. Generate ADR number (previous + 1, or 0001 if none exist)

### Phase 2: Structured Interview

**Goal**: Gather decision details through focused questions

Ask the following questions (can be combined if context is clear):

1. **Problem Statement**: "What problem are you trying to solve?"
   - Current pain points
   - Why this decision is needed now

2. **Options Considered**: "What alternatives did you evaluate?"
   - At least 2 options (including "do nothing" if applicable)
   - Brief pros/cons for each

3. **Decision**: "What did you decide and why?"
   - The chosen approach
   - Primary reasons for selection

4. **Consequences**: "What are the implications?"
   - What becomes easier
   - What becomes harder or requires attention

### Phase 3: Generate ADR

**Goal**: Create the ADR document

**File location**: `docs/adrs/NNNN-<slug>.md`

**Use simplified template** (full template available in `templates/adr-template.md`):

```markdown
---
adrNumber: NNNN
title: "<Title>"
status: proposed
date: YYYY-MM-DD
---

# ADR-NNNN: <Title>

## Status

**proposed**

## Context

[Problem statement and background]

## Decision

[What we decided and why]

## Options Considered

### Option 1: [Name] (Chosen)
- Pros: [list]
- Cons: [list]

### Option 2: [Name]
- Pros: [list]
- Cons: [list]
- Why not chosen: [reason]

## Consequences

### Positive
- [benefits]

### Negative
- [trade-offs and mitigations]

## Related

- [Links to related ADRs, features, or issues]
```

### Phase 4: Update Manifest

**Goal**: Register the ADR in specs-manifest.yaml

**Actions**:
1. Read `.claude/specs-manifest.yaml`
2. Add ADR entry to `adrs` array:
   ```yaml
   adrs:
     - number: NNNN
       title: "<title>"
       status: proposed
       date: "YYYY-MM-DD"
       file: "docs/adrs/NNNN-<slug>.md"
   ```
3. If manifest doesn't exist, inform user to run `/tdd:init` first

### Phase 5: Summary

**Goal**: Confirm creation and suggest next steps

**Output**:
```
ADR Created

docs/adrs/NNNN-<slug>.md

Decision: <brief summary>
Status: proposed

Next steps:
- Review and refine the ADR
- Share with team for feedback
- Update status to 'accepted' when finalized
- Reference in code: // See ADR-NNNN

To list all ADRs: ls docs/adrs/
```

## Examples

### Technology Choice
```
/tdd:adr Use PostgreSQL for primary database

→ Context: Need production database for new service
→ Options: PostgreSQL, MySQL, MongoDB, SQLite
→ Decision: PostgreSQL for JSONB support and reliability
→ Consequences: Team needs PostgreSQL expertise
```

### Architectural Pattern
```
/tdd:adr Implement event sourcing for order system

→ Context: Need audit trail and ability to replay events
→ Options: Traditional CRUD, Event sourcing, Hybrid
→ Decision: Event sourcing for orders, CRUD for catalog
→ Consequences: More complex queries, full audit history
```

### Breaking Change
```
/tdd:adr Migrate API from v1 to v2 with breaking changes

→ Context: v1 API has accumulated tech debt
→ Options: Versioned endpoints, gradual migration, big bang
→ Decision: Versioned endpoints with 6-month deprecation
→ Consequences: Maintain two versions temporarily
```

## ADR Lifecycle

| Status | Meaning |
|--------|---------|
| proposed | Under discussion |
| accepted | Approved and in effect |
| deprecated | No longer recommended |
| superseded | Replaced by another ADR |

To update status:
```bash
# Change status in frontmatter
sed -i 's/status: proposed/status: accepted/' docs/adrs/NNNN-*.md
```

## Tips

- **Keep it concise**: 1-2 pages max for most decisions
- **Write for future readers**: Include enough context to understand without verbal history
- **Link generously**: Reference related code, issues, and other ADRs
- **Date everything**: Decisions age; timestamps provide context
- **Update, don't delete**: When decisions change, supersede with new ADRs

## Notes

- Creates `docs/adrs/` directory if it doesn't exist
- Uses sequential numbering (0001, 0002, etc.)
- Full detailed template available for complex decisions
- ADR numbers are never reused
