---
description: Scaffold a new feature with PRD, technical spec, requirements, and test placeholders
argument-hint: <feature-name>
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
---

# Start New Feature

Create complete feature scaffold with specification documents and test placeholders.

## Task

Given feature name (kebab-case), create:

1. Feature directory in `docs/specs/<feature-name>/`
2. PRD, technical spec, and requirements from templates
3. Entry in `.claude/specs-manifest.yaml`
4. Set as current feature in `.claude/current-feature.txt`

## Implementation

1. **Validate input**: Ensure feature name provided and in kebab-case
2. **Check if exists**: Verify feature not already in manifest
3. **Create directory**: `mkdir -p docs/specs/<feature-name>`
4. **Copy templates**:
   - `prd.md` from template, replace `[Feature Name]` with actual name
   - `technical-spec.md` from template
   - `requirements.md` from template
5. **Update manifest**: Add feature entry with status `planning`
6. **Set current**: Write feature name to `.claude/current-feature.txt`
7. **Display next steps**:
   ```
   Created feature: <feature-name>

   Location: docs/specs/<feature-name>/
   Files:
   - prd.md (Product Requirements)
   - technical-spec.md (Technical Specification)
   - requirements.md (Functional Requirements)

   Next steps:
   1. Fill out PRD: /tdd:create-prd
   2. Generate spec: /tdd:create-spec
   3. Create tests: /tdd:create-test
   ```

Use Read to get templates, Write to create files, Edit to update manifest.
