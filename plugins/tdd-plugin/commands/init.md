---
description: Initialize TDD project structure and settings
argument-hint: none
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
  - Grep
---

# Initialize TDD Project

One-time setup for TDD workflow in current project.

## Task

Create directory structure, copy templates, initialize settings, and create CLAUDE.md for project context.

## Implementation

1. **Check if already initialized**:
   - Look for `.claude/specs-manifest.yaml`
   - If exists, inform user and ask if they want to reinitialize

2. **Gather project info**:
   - Detect project name from package.json, go.mod, Cargo.toml, or directory name
   - Detect primary language/framework
   - Check for existing test files
   - Check for existing CLAUDE.md

3. **Create directories**:
   ```bash
   mkdir -p docs/specs
   mkdir -p docs/adrs
   mkdir -p .claude
   ```

4. **Create specs manifest**:
   Write `.claude/specs-manifest.yaml`:
   ```yaml
   # TDD Plugin - Specifications Manifest
   # Tracks feature specs, tests, and implementation status

   version: "1.0"
   project: "<detected-project-name>"
   initialized: "<timestamp>"

   features: []

   adrs: []

   settings:
     enforcementLevel: advisory
     autoRunTests: false
     coverage:
       enabled: true
       lineThreshold: 80
       branchThreshold: 75
   ```

5. **Create default settings**:
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

6. **Create or update CLAUDE.md**:
   If CLAUDE.md doesn't exist, create it. If it exists, append TDD section.

   **New CLAUDE.md template** (customize based on detected language):

   ```markdown
   # Project: <project-name>

   ## Overview

   [Brief project description - fill this in]

   ## Tech Stack

   - **Language**: <detected>
   - **Test Framework**: <detected>
   - **Package Manager**: <detected>

   ## Architecture Guidelines

   [Include language-specific section from below]

   ## Development Workflow

   This project uses Test-Driven Development (TDD).

   ### Quick Reference

   | Command | Purpose |
   |---------|---------|
   | `/tdd-plugin:tdd <feature>` | Full TDD workflow for new features |
   | `/tdd-plugin:fix <issue>` | Quick fix with test-first approach |
   | `/tdd-plugin:check` | Compliance and coverage report |
   | `/tdd-plugin:adr <title>` | Create architecture decision record |

   ### TDD Workflow

   1. **Specs First**: Define requirements in `docs/specs/<feature>/`
   2. **Tests First**: Write failing tests before implementation
   3. **Minimal Code**: Implement just enough to pass tests
   4. **Refactor**: Improve code while keeping tests green

   ## Current Status

   **TDD Initialized**: <timestamp>
   **Enforcement**: advisory
   **Active Feature**: None

   ---

   *This file is maintained by the TDD plugin. Run `/tdd-plugin:check` to update status.*
   ```

   **Language-specific Architecture sections** (include appropriate one):

   **For Rust projects:**
   ```markdown
   ## Architecture Guidelines

   ### Project Structure
   ```
   src/
   ├── lib.rs              # Library root, re-exports public API
   ├── main.rs             # Binary entry point (if applicable)
   ├── bin/                # Additional binaries
   │   └── <name>.rs
   ├── <domain>/           # Domain modules (e.g., combat/, galaxy/)
   │   ├── mod.rs          # Module root, re-exports
   │   ├── <component>.rs  # Individual components
   │   └── ...
   └── ...
   tests/                  # Integration tests
   ├── fr001_<name>.rs     # Tests by requirement
   └── ...
   ```

   ### Code Organization
   - **Domain modules**: Group related functionality (e.g., `combat/`, `network/`, `scanning/`)
   - **mod.rs pattern**: Each directory has `mod.rs` that re-exports public items
   - **Flat over nested**: Prefer `src/combat/damage.rs` over deeply nested structures
   - **Tests**: Integration tests in `tests/`, unit tests inline with `#[cfg(test)]`

   ### Naming Conventions
   - Files: `snake_case.rs`
   - Modules: `snake_case`
   - Types: `PascalCase`
   - Functions: `snake_case`
   - Test files: `fr###_<description>.rs` (links to requirements)
   ```

   **For TypeScript/JavaScript projects:**
   ```markdown
   ## Architecture Guidelines

   ### Project Structure
   ```
   src/
   ├── index.ts            # Entry point, exports public API
   ├── <domain>/           # Domain modules
   │   ├── index.ts        # Barrel exports
   │   ├── <name>.ts       # Implementation
   │   ├── <name>.test.ts  # Co-located tests
   │   └── types.ts        # Domain types
   ├── shared/             # Cross-cutting utilities
   │   ├── utils/
   │   └── types/
   └── ...
   ```

   ### Code Organization
   - **Feature folders**: Group by domain, not by type (avoid `components/`, `utils/`, `types/` at root)
   - **Barrel exports**: Each folder has `index.ts` for clean imports
   - **Co-located tests**: `<name>.test.ts` next to `<name>.ts`
   - **Types near usage**: Domain types in domain folders, shared types in `shared/types/`

   ### Naming Conventions
   - Files: `kebab-case.ts` or `camelCase.ts` (be consistent)
   - Exports: `PascalCase` for classes/types, `camelCase` for functions
   - Test files: `<name>.test.ts` or `<name>.spec.ts`
   ```

   **For Python projects:**
   ```markdown
   ## Architecture Guidelines

   ### Project Structure
   ```
   src/<package_name>/     # Or just <package_name>/
   ├── __init__.py         # Package root
   ├── <domain>/           # Domain modules
   │   ├── __init__.py
   │   ├── <module>.py
   │   └── ...
   ├── shared/             # Cross-cutting utilities
   └── ...
   tests/
   ├── conftest.py         # Pytest fixtures
   ├── test_<domain>/      # Mirror src structure
   │   ├── test_<module>.py
   │   └── ...
   └── ...
   ```

   ### Code Organization
   - **src layout**: Use `src/<package>/` for installable packages
   - **Domain modules**: Group by business domain, not technical layer
   - **Test structure**: Mirror `src/` structure in `tests/`
   - **Fixtures**: Shared fixtures in `conftest.py`

   ### Naming Conventions
   - Files: `snake_case.py`
   - Modules: `snake_case`
   - Classes: `PascalCase`
   - Functions: `snake_case`
   - Test files: `test_<name>.py`
   ```

   **For Go projects:**
   ```markdown
   ## Architecture Guidelines

   ### Project Structure
   ```
   cmd/
   ├── <app>/              # Application entry points
   │   └── main.go
   internal/               # Private application code
   ├── <domain>/           # Domain packages
   │   ├── <name>.go
   │   └── <name>_test.go
   pkg/                    # Public library code (if any)
   └── ...
   ```

   ### Code Organization
   - **cmd pattern**: Entry points in `cmd/<app>/main.go`
   - **internal/**: Application-specific code, not importable externally
   - **pkg/**: Reusable library code (optional, use sparingly)
   - **Domain packages**: One package per bounded context
   - **Co-located tests**: `<name>_test.go` next to `<name>.go`

   ### Naming Conventions
   - Files: `snake_case.go`
   - Packages: short, lowercase, no underscores
   - Types: `PascalCase` (exported), `camelCase` (unexported)
   - Functions: `PascalCase` (exported), `camelCase` (unexported)
   ```

   **If CLAUDE.md exists**, append:
   ```markdown

   ---

   ## TDD Workflow

   This project uses Test-Driven Development.

   ### Commands

   | Command | Purpose |
   |---------|---------|
   | `/tdd-plugin:tdd <feature>` | Full TDD workflow for new features |
   | `/tdd-plugin:fix <issue>` | Quick fix with test-first approach |
   | `/tdd-plugin:check` | Compliance and coverage report |
   | `/tdd-plugin:adr <title>` | Create architecture decision record |

   ### Key Locations

   - Specifications: `docs/specs/`
   - ADRs: `docs/adrs/`
   - Settings: `.claude/tdd-plugin.local.md`

   *TDD initialized: <timestamp>*
   ```

7. **Detect test framework**:
   Run framework detection and update settings if found

8. **Display completion**:
   ```
   TDD Project Initialized

   Created:
   ✓ docs/specs/              (feature specifications)
   ✓ docs/adrs/               (architecture decision records)
   ✓ .claude/specs-manifest.yaml
   ✓ .claude/tdd-plugin.local.md
   ✓ CLAUDE.md                (project context)

   Detected:
   - Project: <name>
   - Language: <lang>
   - Test Framework: <framework>

   Next steps:
   1. Review CLAUDE.md and add project description
   2. Review settings in .claude/tdd-plugin.local.md
   3. Start a feature: /tdd <feature-name>
   4. Or fix something: /tdd-plugin:fix <description>
   ```

## Notes

- Does not overwrite existing files unless user confirms
- Detects and respects existing test framework
- Settings file (.local.md) should be gitignored
- CLAUDE.md should be committed to share context with team
