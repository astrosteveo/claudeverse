---
description: Initialize TDD project structure with templates, directories, and settings
argument-hint: none
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
---

# Initialize TDD Project

Initialize the project for Test-Driven Development with directory structure, templates, and configuration.

## Task

Perform one-time setup to enable TDD workflow in the current project:

1. **Create directory structure**
2. **Install templates**
3. **Initialize settings file**
4. **Create specs manifest**
5. **Set up Git hooks** (optional)
6. **Generate initial report**

## Implementation Steps

### Step 1: Check if already initialized

Check for `.claude/tdd-plugin.local.md` to see if project is already initialized.

If exists, inform user and ask if they want to reinitialize (will preserve existing settings).

### Step 2: Create directory structure

Create the following directories:

```
docs/
├── specs/           # Feature specifications
└── adrs/            # Architecture Decision Records

.claude/             # TDD plugin data
```

Use Bash tool to create directories:
```bash
mkdir -p docs/specs docs/adrs .claude
```

### Step 3: Copy templates

Copy all templates from plugin to project:

```bash
# Templates are in ${CLAUDE_PLUGIN_ROOT}/templates/
cp ${CLAUDE_PLUGIN_ROOT}/templates/prd-template.md docs/specs/
cp ${CLAUDE_PLUGIN_ROOT}/templates/technical-spec-template.md docs/specs/
cp ${CLAUDE_PLUGIN_ROOT}/templates/functional-requirements-template.md docs/specs/
cp ${CLAUDE_PLUGIN_ROOT}/templates/adr-template.md docs/adrs/
cp ${CLAUDE_PLUGIN_ROOT}/templates/test-case-template.md docs/specs/
cp ${CLAUDE_PLUGIN_ROOT}/templates/specs-manifest-template.yaml .claude/specs-manifest.yaml
```

Confirm templates copied successfully.

### Step 4: Initialize settings file

Create `.claude/tdd-plugin.local.md` with default configuration:

```yaml
---
enforcementLevel: advisory  # advisory | strict | graduated
graduatedThreshold: 3       # violations before strict mode kicks in
coverage:
  lineThreshold: 80
  branchThreshold: 75
  enabled: true
testFramework: auto         # auto | jest | pytest | gotest | rspec
autoRunTests: false         # Auto-run tests after code changes
blockWithoutSpecs: false    # Require spec before writing tests
trackingEnabled: true       # Log violations and metrics
gracePeriodDays: 7          # Days before enforcement starts
exemptions:
  - "scripts/**"
  - "docs/**"
  - "*.config.js"
  - "*.config.ts"
directoryOverrides: {}
  # Example:
  # "src/core/**":
  #   enforcementLevel: strict
  #   coverage:
  #     lineThreshold: 90
  #     branchThreshold: 85
---

# TDD Plugin Settings

This file configures the TDD Plugin for this project.

## Quick Start

1. Run `/tdd:start-feature <name>` to begin a new feature
2. Follow red-green-refactor cycle: `/tdd:run-cycle`
3. Validate progress: `/tdd:checkpoint`

## Enforcement Levels

- **advisory**: Warns about violations but allows them (recommended for adoption)
- **strict**: Blocks code changes without tests
- **graduated**: Advisory for first N violations, then strict

## Coverage Thresholds

Adjust based on project needs:
- Critical code: 90%+ line, 85%+ branch
- Standard code: 80% line, 75% branch
- Legacy code: Lower thresholds acceptable

## Test Framework

Set to specific framework or `auto` for automatic detection.

## Customization

Edit this file to adjust TDD plugin behavior for your project.
```

### Step 5: Initialize specs manifest

Create initial `.claude/specs-manifest.yaml` based on template:

```yaml
project:
  name: "[Project Name]"
  initialized: [YYYY-MM-DD]
  tddEnforcement: advisory
  defaultCoverage:
    line: 80
    branch: 75

features: []

globalExemptions:
  - "scripts/**"
  - "docs/**"
  - "*.config.js"
  - "migrations/**"

languages: {}

violations:
  total: 0
  byType:
    missingTests: 0
    missingSpecs: 0
    lowCoverage: 0
    testAfterCode: 0
  history: []

metadata:
  manifestVersion: "1.0.0"
  lastUpdated: [YYYY-MM-DD]
  generatedBy: "tdd-plugin"
```

Replace `[Project Name]` with actual project name (from package.json, README, or ask user).

Replace `[YYYY-MM-DD]` with current date.

### Step 6: Detect test framework

Run framework detection script:

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/detect-test-framework.sh -o json
```

If framework detected, update settings file with detected framework.

If not detected, keep as `auto`.

### Step 7: Create ADR index

Create `docs/adrs/README.md`:

```markdown
# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) documenting significant architectural and design decisions for this project.

## What are ADRs?

ADRs capture important decisions along with their context and consequences. Each ADR includes:
- The decision made
- The context requiring the decision
- Alternatives considered
- Consequences of the decision

## ADR Format

ADRs follow the format defined in `adr-template.md`.

## Active ADRs

(None yet - ADRs will be listed here as they're created)

## Creating ADRs

Use the template:
```bash
cp adr-template.md NNNN-decision-title.md
```

Then fill in the sections and update this index.

For guidance, see the TDD plugin's ADR Practices skill.
```

### Step 8: Git hooks setup (Optional)

Ask user: "Would you like to install Git hooks for TDD validation? (pre-commit hook will validate test-first ordering)"

If yes:
1. Create `.claude/git-hooks/pre-commit`:

```bash
#!/usr/bin/env bash
# TDD Plugin Pre-Commit Hook
# Validates test-first ordering and coverage thresholds

echo "Running TDD validation..."

# Check test ordering
${CLAUDE_PLUGIN_ROOT}/scripts/check-test-ordering.sh -o text

if [ $? -ne 0 ]; then
  echo ""
  echo "❌ Test ordering violations found!"
  echo "Tests must be created before implementation code."
  echo ""
  echo "To commit anyway, use: git commit --no-verify"
  exit 1
fi

# Check coverage if enabled
if [ -f ".claude/tdd-plugin.local.md" ]; then
  # Extract coverage settings (simplified check)
  if grep -q "enabled: true" ".claude/tdd-plugin.local.md"; then
    # Find coverage file
    coverage_file=""
    if [ -f "coverage/lcov.info" ]; then
      coverage_file="coverage/lcov.info"
    elif [ -f "coverage.xml" ]; then
      coverage_file="coverage.xml"
    fi

    if [ -n "$coverage_file" ]; then
      ${CLAUDE_PLUGIN_ROOT}/scripts/validate-coverage.sh \
        -f "$coverage_file" \
        -l 80 \
        -b 75 \
        -o text

      if [ $? -ne 0 ]; then
        echo ""
        echo "⚠️  Coverage below threshold"
        echo "Run tests with coverage and improve before committing."
        echo ""
        echo "To commit anyway, use: git commit --no-verify"
        exit 1
      fi
    fi
  fi
fi

echo "✓ TDD validation passed"
exit 0
```

2. Make hook executable:
```bash
chmod +x .claude/git-hooks/pre-commit
```

3. Install hook:
```bash
cp .claude/git-hooks/pre-commit .git/hooks/pre-commit
```

4. Inform user: "Git pre-commit hook installed. Run `git commit --no-verify` to bypass if needed."

If no or git not available:
- Inform user they can manually install hooks later
- Hook template is in `.claude/git-hooks/pre-commit`

### Step 9: Generate initial report

Run report generation:

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/generate-report.sh -o .claude/tdd-report.md
```

Inform user that initial report is available at `.claude/tdd-report.md`.

### Step 10: Summary

Display initialization summary:

```
✓ TDD Plugin Initialized Successfully!

Created:
- docs/specs/ (specification templates)
- docs/adrs/ (Architecture Decision Records)
- .claude/tdd-plugin.local.md (settings)
- .claude/specs-manifest.yaml (tracking)
- .claude/tdd-report.md (initial report)

Next Steps:
1. Review settings in .claude/tdd-plugin.local.md
2. Start your first feature: /tdd:start-feature <name>
3. Follow TDD cycle: /tdd:run-cycle
4. Validate progress: /tdd:checkpoint

Documentation:
- ADR Template: docs/adrs/adr-template.md
- PRD Template: docs/specs/prd-template.md
- Technical Spec Template: docs/specs/technical-spec-template.md

For help, ask about TDD workflow, spec writing, or test patterns.
```

## Error Handling

**If directories already exist**: Inform user, ask if they want to continue (will not overwrite existing files).

**If templates fail to copy**: Show error, suggest manual copy from plugin directory.

**If Git not available**: Skip Git hooks setup, inform user.

**If framework detection fails**: Keep settings at `auto`, user can manually configure.

## Notes

- This is a one-time setup command
- Re-running is safe (won't overwrite existing settings)
- User can customize settings after initialization
- Templates provide starting points, not requirements

Initialize the project and provide clear next steps for the user.
