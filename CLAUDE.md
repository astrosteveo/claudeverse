# Project Context for Claude

This file is automatically maintained by the TDD plugin to keep Claude informed about the project state.


---

## TDD Workflow Status

**Last Updated**: 2025-12-02 20:41:16

### Project Configuration
- **Project**: unknown
- **Enforcement Mode**: advisory
- **TDD Violations**: 0 unresolved (0 total)

### Key Documentation Locations

**Specifications & Requirements**
- Feature specs: `docs/specs/<feature-name>/`
- PRD template: `docs/specs/prd-template.md`
- Technical specs: `docs/specs/technical-spec-template.md`
- Manifest: `.claude/specs-manifest.yaml`

**Testing & Validation**
- Test framework: Auto-detected (check `.claude/tdd-plugin.local.md`)
- Coverage targets: See `.claude/tdd-plugin.local.md`
- Violations log: `.claude/tdd-violations.json`

**Session Data**
- Current feature: `.claude/current-feature.txt` (if exists)
- Session log: `.claude/tdd-session-log.md`
- Plugin settings: `.claude/tdd-plugin.local.md`

### Recent Activity### Quick Commands

- `/tdd-plugin:status` - Check current TDD workflow status
- `/tdd-plugin:run-cycle` - Run guided TDD cycle
- `/tdd-plugin:start-feature <name>` - Begin new feature with spec
- `/tdd-plugin:checkpoint` - Validate current state

### How to Use This Context

When starting a new session:
1. Check `.claude/current-feature.txt` for active feature
2. Review recent violations in `.claude/tdd-violations.json`
3. Read feature spec from `docs/specs/<feature>/`
4. Follow TDD workflow: Spec → Test → Implement

---

