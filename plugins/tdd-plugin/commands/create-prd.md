---
description: Interactive PRD creation with guided prompts for current feature
argument-hint: none
allowed-tools:
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

# Create Product Requirements Document

Guide user through interactive PRD creation for current feature.

## Task

Use AskUserQuestion to gather PRD information, then populate template.

## Implementation

1. **Get current feature**: Read `.claude/current-feature.txt`
2. **Check PRD exists**: Read `docs/specs/<feature>/prd.md`
3. **Ask key questions** using AskUserQuestion:

**Question 1**: What problem does this feature solve?
- Options: New capability, Performance improvement, User experience, Bug fix
- Multi-select: false

**Question 2**: Who are the primary users?
- Free-form answer for user personas

**Question 3**: What are the success metrics?
- Free-form answer for KPIs

**Question 4**: What's the scope priority?
- Options: MVP (minimal), Standard (full-featured), Enterprise (comprehensive)

4. **Populate template**: Update PRD with answers, fill in sections
5. **Save**: Write updated PRD
6. **Display**: Show summary and next step (`/tdd:create-spec`)

Use AskUserQuestion for interaction, Edit to update PRD file.
