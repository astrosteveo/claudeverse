---
description: Initialize TDD project structure and settings
argument-hint: none
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
---

# Initialize TDD Project

One-time setup for TDD workflow in current project.

## Task

Create directory structure, copy templates, and initialize settings for TDD workflow.

## Implementation

1. **Check if already initialized**:
   - Look for `.claude/specs-manifest.yaml`
   - If exists, inform user and ask if they want to reinitialize

2. **Create directories**:
   ```bash
   mkdir -p docs/specs
   mkdir -p docs/adrs
   mkdir -p .claude
   ```

3. **Create specs manifest**:
   Write `.claude/specs-manifest.yaml`:
   ```yaml
   # TDD Plugin - Specifications Manifest
   # Tracks feature specs, tests, and implementation status

   version: "1.0"
   project: "<project-name>"

   features: []

   # Settings
   settings:
     enforcementLevel: advisory  # advisory | strict
     autoRunTests: false
     coverage:
       enabled: true
       lineThreshold: 80
       branchThreshold: 75
   ```

4. **Create default settings**:
   Write `.claude/tdd-plugin.local.md`:
   ```yaml
   ---
   enforcementLevel: advisory
   coverage:
     lineThreshold: 80
     branchThreshold: 75
     enabled: true
   testFramework: auto
   autoRunTests: false
   exemptions:
     - "scripts/**"
     - "docs/**"
     - "*.config.js"
     - "*.config.ts"
   ---

   # TDD Plugin Settings

   This file configures the TDD plugin for this project.
   Edit the YAML frontmatter above to customize behavior.

   ## Enforcement Levels

   - **advisory**: Warns about missing tests, allows code changes
   - **strict**: Blocks code changes without tests

   ## Coverage Thresholds

   Set per-language or per-directory thresholds:

   ```yaml
   directoryOverrides:
     "src/core/**":
       lineThreshold: 90
       branchThreshold: 85
     "src/legacy/**":
       lineThreshold: 60
   ```
   ```

5. **Detect test framework**:
   Run framework detection and update settings if found

6. **Display completion**:
   ```
   TDD Project Initialized

   Created:
   - docs/specs/           (feature specifications)
   - docs/adrs/            (architecture decision records)
   - .claude/specs-manifest.yaml
   - .claude/tdd-plugin.local.md

   Next steps:
   1. Review settings in .claude/tdd-plugin.local.md
   2. Start a feature: /tdd <feature-name>
   3. Check status: /tdd:check
   ```

## Notes

- Does not overwrite existing files unless user confirms
- Detects and respects existing test framework
- Settings file is gitignored by default (add to .claude/.gitignore)
