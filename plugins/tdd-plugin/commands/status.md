---
description: Show current TDD workflow status and what to do next
argument-hint: none
allowed-tools:
  - Read
  - Bash
  - Glob
---

# TDD Status

Show current workflow status and suggest next steps.

## Task

Check the current state of TDD workflow and display clear next steps.

## Implementation

1. **Check if initialized**:
   - Look for `.claude/tdd-settings.yaml`
   - If missing: Display "Run /tdd:init-project first"

2. **Check for active feature**:
   - Read `.claude/current-feature.txt`
   - If exists: Load feature name
   - If missing: No active feature

3. **Check for features in progress**:
   - Look for `docs/specs/*/` directories
   - Count how many features exist

4. **Check test status**:
   - Detect test framework
   - Run tests if framework found
   - Count passing/failing

5. **Display status**:

**If not initialized**:
```
📋 TDD Plugin Status

Status: Not initialized

Next step:
  /tdd:init-project

This will set up your project structure for TDD workflows.
```

**If initialized, no features**:
```
📋 TDD Plugin Status

Status: Initialized ✓
Active feature: None
Features in project: 0

Next step:
  /tdd:build-feature <feature-name>

Example:
  /tdd:build-feature elastic-kubernetes-cluster

This will create specs and automatically build the entire feature using TDD.
```

**If initialized, has features, none active**:
```
📋 TDD Plugin Status

Status: Initialized ✓
Active feature: None
Features in project: X

Available features:
  - feature-1
  - feature-2
  - feature-3

Next steps:
  /tdd:build-feature <new-feature>  - Start a new feature
  /tdd:checkpoint                   - Review existing features
```

**If has active feature**:
```
📋 TDD Plugin Status

Status: Initialized ✓
Active feature: {feature-name}
Specifications: ✓ PRD, Tech Spec, Requirements

Test status:
  Passing: X tests
  Failing: Y tests
  Coverage: Z%

Next steps:
  /tdd:build-feature {feature-name}  - Continue building (auto TDD cycles)
  /tdd:run-cycle                     - Run single TDD cycle
  /tdd:checkpoint                    - Validate progress
```

6. **Quick reference**:
```
Common commands:
  /tdd:status          - Show this status (you are here)
  /tdd:build-feature   - Fully automated feature development
  /tdd:run-cycle       - Single TDD cycle
  /tdd:checkpoint      - Validate and report
  /tdd:init-project    - Initialize project structure
```

## Key Principles

- **Always show next step**: Never leave user wondering what to do
- **Context aware**: Different suggestions based on project state
- **Clear commands**: Show exact command to run
- **Brief**: Don't overwhelm with options

This command answers "what do I do now?"
