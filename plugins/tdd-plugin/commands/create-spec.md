---
description: Generate technical specification from PRD using spec-writer agent
argument-hint: none
allowed-tools:
  - Read
  - Task
---

# Create Technical Specification

Generate technical spec from existing PRD using the spec-writer agent.

## Task

Invoke spec-writer agent to convert PRD into detailed technical specification.

## Implementation

1. **Get current feature**: Read `.claude/current-feature.txt`
2. **Read PRD**: Load `docs/specs/<feature>/prd.md`
3. **Invoke agent**: Use Task tool with spec-writer agent:
   ```
   Prompt: "Generate technical specification for <feature> based on this PRD:
   [PRD content]

   Create detailed technical spec including:
   - Architecture diagrams (Mermaid)
   - Data models
   - API design
   - Technology choices with rationale
   - Security considerations
   - Performance requirements

   Write directly to: docs/specs/<feature>/technical-spec.md"
   ```
4. **Verify**: Agent writes spec to file
5. **Display**: Show completion message and next step

Use Task tool to launch spec-writer agent (on-demand).
