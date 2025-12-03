---
name: ADR Practices
description: This skill should be used when the user asks about "architecture decision records", "ADR", "document decisions", "architecture decisions", "design decisions", "decision records", "create ADR", or needs guidance on documenting and managing architectural decisions in software projects.
version: 0.1.0
---

# Architecture Decision Records (ADR) Practices

## Overview

Architecture Decision Records (ADRs) document significant architectural and design decisions made during software development. This skill provides guidance on when to create ADRs, how to structure them effectively, and how to maintain them as living documentation.

## What are ADRs?

### Definition

An ADR is a short document that captures an important architectural decision along with its context and consequences.

**Key elements**:
- **Decision**: What was decided
- **Context**: Why the decision was needed
- **Consequences**: What results from the decision
- **Alternatives**: What other options were considered

### Purpose

**ADRs serve multiple roles**:
1. **Historical record**: Why decisions were made
2. **Knowledge transfer**: Onboard new team members
3. **Decision rationale**: Understand trade-offs
4. **Change management**: Track evolution of architecture
5. **Accountability**: Document who decided what and when

### Benefits

**For teams**:
- Shared understanding of architectural choices
- Avoid revisiting settled decisions
- Learn from past decisions
- Facilitate discussions about changes

**For projects**:
- Maintain architectural consistency
- Understand legacy decisions
- Plan migrations and refactors
- Audit compliance and governance

## When to Write an ADR

### Decision Significance

Write an ADR when a decision:

**Has lasting impact**:
- Affects multiple components or teams
- Is difficult or expensive to reverse
- Sets precedent for future decisions
- Influences system qualities (performance, security, scalability)

**Involves trade-offs**:
- Multiple viable options exist
- Each option has pros and cons
- Decision requires careful evaluation
- Team needs to align on approach

**Requires explanation**:
- Choice may seem non-obvious
- Future maintainers will question the decision
- Decision differs from industry norms
- External constraints influenced the choice

### Examples of ADR-Worthy Decisions

**Technology choices**:
- Database selection (PostgreSQL vs MongoDB vs DynamoDB)
- Framework selection (React vs Vue vs Angular)
- Language choice for microservice (Go vs Node.js vs Java)
- Third-party service selection (Auth0 vs custom auth)

**Architecture patterns**:
- Monolith vs microservices
- Event-driven vs request-response
- Synchronous vs asynchronous processing
- Client-side vs server-side rendering

**Infrastructure decisions**:
- Cloud provider (AWS vs GCP vs Azure)
- Deployment strategy (blue-green vs canary vs rolling)
- Container orchestration (Kubernetes vs ECS vs serverless)
- Data backup approach

**Security and compliance**:
- Authentication mechanism (JWT vs session-based)
- Encryption standards
- Data retention policies
- Access control model (RBAC vs ABAC)

**Development practices**:
- Branching strategy (Git Flow vs trunk-based)
- Testing approach (E2E vs integration-heavy)
- Code review process
- Documentation standards

### What Not to Document

**Don't write ADRs for**:
- Trivial implementation details
- Temporary or experimental changes
- Team process decisions (unless architectural impact)
- Personal coding preferences
- Obvious best practices

## ADR Structure

### Standard Format

Use the template at `../../templates/adr-template.md`.

**Minimal ADR sections**:
1. **Title**: Clear, concise decision name
2. **Status**: proposed, accepted, deprecated, superseded
3. **Context**: Why this decision is needed
4. **Decision**: What was decided
5. **Consequences**: What results from this decision

**Extended format** (recommended):
6. **Options Considered**: Alternatives evaluated
7. **Rationale**: Why this option was chosen
8. **Risks & Mitigations**: Potential issues and solutions

### Title Format

**Convention**: ADR-NNNN: [Decision Title]

**Examples**:
- ADR-0001: Use PostgreSQL for Primary Database
- ADR-0023: Adopt Microservices Architecture
- ADR-0045: Implement JWT-Based Authentication

**Numbering**:
- Sequential (0001, 0002, 0003, ...)
- Zero-padded for sorting
- Never reuse numbers

### Status Values

**proposed**: Decision under consideration
- Team reviewing options
- Not yet implemented
- May change based on feedback

**accepted**: Decision approved and implemented
- Active ADR guiding current architecture
- Implementation in progress or complete
- Team committed to this direction

**deprecated**: Decision no longer applicable
- Superseded by newer decision
- Technology/approach phased out
- Still useful for historical context

**superseded**: Replaced by another ADR
- Link to new ADR in status
- Explains why decision changed
- Maintains historical record

**Example status section**:
```markdown
## Status

accepted

*Superseded by*: ADR-0045 (Migration to OAuth2.0)
```

## Writing Effective ADRs

### Context Section

**Explain the situation**:

✅ **Good context**:
```markdown
## Context

### Background
We need to select a database for our new microservices architecture.
Each service will manage its own data with eventual consistency between
services. Expected load: 10,000 requests/sec, 500GB data in year one.

### Problem Statement
Current monolithic PostgreSQL database creates bottlenecks:
- All services contend for single database connection pool
- Schema changes require coordination across all teams
- Scaling requires vertical scaling only (expensive)
- Read replicas not utilized effectively

### Constraints
- Must support ACID transactions for payment data
- Development team experienced with SQL
- Budget: $5,000/month infrastructure
- Must integrate with existing AWS ecosystem
- Compliance requires encryption at rest
```

**Why good**:
- Quantifies the problem (10K req/sec, 500GB)
- Explains current pain points
- Lists concrete constraints
- Provides necessary context for decision

❌ **Bad context**:
```markdown
## Context

We need a database. PostgreSQL is old. We want something modern.
```

**Why bad**:
- Vague problem statement
- No quantifiable requirements
- No constraints mentioned
- Doesn't explain why change is needed

### Decision Section

**State clearly what was decided**:

✅ **Good decision**:
```markdown
## Decision

Adopt Amazon DynamoDB as the primary database for new microservices.

### What We're Doing
- New microservices will use DynamoDB for data storage
- Existing monolith continues using PostgreSQL
- Gradual migration over 12 months
- Each service owns its own DynamoDB tables
- Use DynamoDB Streams for event-driven integration

### Implementation Details
- One DynamoDB table per service (single-table design)
- On-demand billing mode initially
- Global tables for multi-region deployment
- Encryption at rest enabled by default
- Point-in-time recovery enabled
```

**Why good**:
- Clear statement of decision
- Specific implementation approach
- Timeline included
- Configuration details specified

### Options Considered

**Document alternatives thoroughly**:

```markdown
## Options Considered

### Option 1: Amazon DynamoDB (Chosen)

**Description**: Managed NoSQL database with automatic scaling

**Pros**:
- ✅ Auto-scaling to handle variable load
- ✅ Pay-per-request pricing model
- ✅ Global tables for multi-region
- ✅ Managed service (no maintenance)
- ✅ Sub-10ms latency at any scale

**Cons**:
- ❌ Learning curve for team (SQL background)
- ❌ No joins (must denormalize data)
- ❌ Query flexibility limited vs SQL

**Cost**: ~$3,000/month at projected scale

**Risk**: Medium - team training required

---

### Option 2: Amazon Aurora PostgreSQL

**Description**: Managed PostgreSQL with AWS enhancements

**Pros**:
- ✅ SQL familiarity for team
- ✅ Strong consistency
- ✅ Complex queries and joins
- ✅ Existing tooling works

**Cons**:
- ❌ Still requires connection pooling
- ❌ Vertical scaling limits
- ❌ More expensive at scale
- ❌ Doesn't solve microservices data isolation

**Cost**: ~$6,000/month at projected scale

**Risk**: Low - known technology

**Why Not Chosen**: Doesn't address core issues of service data
isolation and horizontal scaling. 2x more expensive than DynamoDB.

---

### Option 3: MongoDB Atlas

**Description**: Managed document database

**Pros**:
- ✅ Flexible schema
- ✅ Good query capabilities
- ✅ Horizontal scaling
- ✅ JSON-like documents

**Cons**:
- ❌ No AWS-native integration
- ❌ Team has no MongoDB experience
- ❌ More expensive than DynamoDB
- ❌ Requires additional security hardening

**Cost**: ~$4,500/month

**Risk**: High - new technology and platform

**Why Not Chosen**: Higher cost and risk with no significant
advantages over DynamoDB for our use case.
```

**Benefits of thorough comparison**:
- Shows due diligence
- Explains trade-offs accepted
- Helps future reviewers understand rationale
- Prevents rehashing old debates

### Consequences Section

**Document both positive and negative outcomes**:

```markdown
## Consequences

### Positive Consequences

✅ **Improved Scalability**
- Services can scale independently based on load
- No single database bottleneck
- Sub-10ms latency maintained at any scale

✅ **Cost Efficiency**
- 40% cost reduction vs Aurora ($3K vs $6K/month)
- Pay only for actual usage with on-demand billing
- No over-provisioning required

✅ **Operational Simplicity**
- Fully managed service (no database administration)
- Automatic backups and point-in-time recovery
- Built-in security features

### Negative Consequences

❌ **Learning Curve**
- Team requires DynamoDB training (3-4 weeks)
- Different mental model from SQL
- Initial velocity decrease expected

*Mitigation*: Allocate 2 weeks for team training, create internal
best practices guide, pair experienced developers with learners

❌ **Query Limitations**
- No joins (must denormalize data)
- Limited ad-hoc query capabilities
- Some reports require additional processing

*Mitigation*: Use DynamoDB Streams to populate reporting database
(Aurora or Redshift) for analytics queries

❌ **Data Modeling Complexity**
- Single-table design requires careful planning
- Access patterns must be known upfront
- Difficult to change after launch

*Mitigation*: Conduct thorough data modeling workshops before
implementation, maintain flexibility with GSIs (Global Secondary Indexes)

### Neutral Consequences

- Migration of existing data requires careful planning
- Need to maintain PostgreSQL knowledge for monolith
- Different deployment processes for different data stores
```

**Why thorough consequences matter**:
- Honest assessment of trade-offs
- Prepares team for challenges
- Documents mitigation strategies
- Sets realistic expectations

## ADR Lifecycle

### Creating ADRs

**Process**:
1. Identify decision needing documentation
2. Copy ADR template: `cp templates/adr-template.md docs/adrs/NNNN-title.md`
3. Fill in context and problem statement
4. List and evaluate options
5. Document chosen option and rationale
6. Set status to "proposed"
7. Share with team for review

**Initial status**: Always start with "proposed"

### Reviewing ADRs

**Review criteria**:
- Is context clear and complete?
- Are alternatives thoroughly evaluated?
- Is rationale well-justified?
- Are consequences realistic?
- Do mitigation strategies address risks?

**Review process**:
- Share ADR in team meeting or async review
- Collect feedback and questions
- Update ADR based on input
- Reach consensus on decision

### Accepting ADRs

**When to accept**:
- Team consensus reached
- Implementation beginning or complete
- Decision committed to

**Update ADR**:
1. Change status from "proposed" to "accepted"
2. Add acceptance date
3. Update change log
4. Commit to repository

**Example**:
```markdown
## Status

accepted

## Change Log

| Date | Status | Changes | Author |
|------|--------|---------|--------|
| 2025-01-15 | proposed | Initial draft | Alice |
| 2025-01-22 | accepted | Decision finalized after team review | Alice |
```

### Superseding ADRs

**When to supersede**:
- Technology evolves (better options available)
- Requirements change significantly
- Original decision proven suboptimal
- Migration to different approach

**Process**:
1. Create new ADR with updated decision
2. In new ADR, link to old ADR being superseded
3. In old ADR, update status to "superseded" and link to new ADR
4. Explain why decision changed

**Example (Old ADR)**:
```markdown
## Status

superseded

*Superseded by*: ADR-0045 (Migration to OAuth2.0)

## Supersession Notes

This decision was superseded in 2026 due to:
- Industry shift to OAuth2.0 standard
- Security vulnerabilities in custom JWT implementation
- Customer demand for SSO integration
- Higher maintenance burden than expected

See ADR-0045 for details on OAuth2.0 migration.
```

**Example (New ADR)**:
```markdown
## Status

accepted

## Related Decisions

### Supersedes
- ADR-0023: Implement JWT-Based Authentication

This ADR replaces our custom JWT implementation with industry-standard
OAuth2.0 to address security concerns and enable SSO integration.
```

## Organizing ADRs

### File Structure

**Standard location**: `docs/adrs/`

```
docs/
├── adrs/
│   ├── 0001-use-postgresql.md
│   ├── 0002-adopt-microservices.md
│   ├── 0023-implement-jwt-auth.md
│   ├── 0045-migrate-to-oauth2.md
│   └── README.md              # Index of all ADRs
└── specs/
    └── [feature specifications]
```

**Naming convention**:
- `NNNN-kebab-case-title.md`
- Zero-padded sequential numbers
- Descriptive, concise title
- Lowercase with hyphens

### ADR Index

**Create index** (`docs/adrs/README.md`):

```markdown
# Architecture Decision Records

## Active ADRs

| ADR | Title | Date | Status |
|-----|-------|------|--------|
| [0045](0045-migrate-to-oauth2.md) | Migrate to OAuth2.0 | 2025-02-01 | accepted |
| [0044](0044-implement-caching.md) | Implement Redis Caching | 2025-01-28 | accepted |
| [0043](0043-adopt-graphql.md) | Adopt GraphQL for API | 2025-01-20 | accepted |

## Deprecated ADRs

| ADR | Title | Date | Status | Superseded By |
|-----|-------|------|--------|---------------|
| [0023](0023-implement-jwt-auth.md) | JWT Authentication | 2024-06-15 | superseded | ADR-0045 |

## Index by Category

### Data Storage
- [0001](0001-use-postgresql.md) - Use PostgreSQL
- [0012](0012-adopt-dynamodb.md) - Adopt DynamoDB

### Architecture
- [0002](0002-adopt-microservices.md) - Microservices Architecture
- [0008](0008-event-driven.md) - Event-Driven Integration

### Security
- [0023](0023-implement-jwt-auth.md) - JWT Authentication (deprecated)
- [0045](0045-migrate-to-oauth2.md) - OAuth2.0 Migration
```

**Benefits**:
- Quick reference for all decisions
- Shows relationships between ADRs
- Easy to find relevant decisions
- Tracks superseded decisions

## ADRs in TDD Workflow

### Linking ADRs to Specifications

**Reference ADRs in technical specs**:

```markdown
---
title: "User Authentication - Technical Specification"
relatedADRs:
  - "docs/adrs/0045-migrate-to-oauth2.md"
  - "docs/adrs/0038-implement-rate-limiting.md"
---

# User Authentication Technical Specification

## Architecture

This specification implements the OAuth2.0 authentication approach
documented in ADR-0045...
```

**Benefits**:
- Connects decisions to implementation
- Provides context for specifications
- Helps understand design choices

### Tracking in Specs Manifest

```yaml
features:
  - name: user-authentication
    specifications:
      prd: docs/specs/user-authentication/prd.md
      technicalSpec: docs/specs/user-authentication/technical-spec.md
      adrs:
        - docs/adrs/0045-migrate-to-oauth2.md
        - docs/adrs/0038-implement-rate-limiting.md
```

## ADR Best Practices

### Write Concisely

**Target length**: 1-3 pages

**Focus on**:
- Decision and rationale
- Key trade-offs
- Critical consequences

**Avoid**:
- Excessive implementation details
- Lengthy background
- Redundant information

### Be Honest About Trade-offs

**Don't sugarcoat**:
- Document negative consequences
- Acknowledge risks
- Admit uncertainties
- Note limitations

**Builds trust**:
- Shows thorough analysis
- Demonstrates honesty
- Helps future decisions
- Prevents unrealistic expectations

### Update When Needed

**ADRs are living documents**:
- Add implementation notes
- Update risks as discovered
- Document lessons learned
- Cross-reference related ADRs

**Don't change**:
- Original decision (create new ADR instead)
- Status without reason
- Context that changes history

### Make ADRs Discoverable

**Strategies**:
- Maintain index file
- Link from relevant docs
- Discuss in team meetings
- Include in onboarding
- Reference in code comments

**Example code comment**:
```javascript
// OAuth2.0 implementation per ADR-0045
// See: docs/adrs/0045-migrate-to-oauth2.md
class OAuth2AuthProvider {
  // ...
}
```

## Common Mistakes

### Too Much Implementation Detail

❌ **Bad**:
```markdown
## Decision

We will use PostgreSQL with the following configuration:
- shared_buffers = 256MB
- effective_cache_size = 1GB
- work_mem = 16MB
- maintenance_work_mem = 128MB
[20 more config parameters...]
```

✅ **Good**:
```markdown
## Decision

We will use PostgreSQL as our primary database.

Configuration details are maintained in `config/database.yml`
and infrastructure-as-code in `terraform/database.tf`.
```

### Not Documenting Alternatives

❌ **Bad**:
```markdown
## Decision

We chose React for our frontend framework.
```

✅ **Good**:
```markdown
## Options Considered

### Option 1: React (Chosen)
[Pros, cons, rationale]

### Option 2: Vue.js
[Pros, cons, why not chosen]

### Option 3: Angular
[Pros, cons, why not chosen]
```

### Missing Context

❌ **Bad**:
```markdown
## Context

We need a better database.
```

✅ **Good**:
```markdown
## Context

### Background
Current PostgreSQL database handles 5,000 req/sec but projections
show 15,000 req/sec needed within 6 months. Vertical scaling costs
$10K/month beyond current $3K/month spend.

### Problem Statement
[Specific problems with quantifiable impact]

### Constraints
[Technical, budget, team skill constraints]
```

## Tools and Commands

### Create ADR

**Use template**:
```bash
# Copy template
cp templates/adr-template.md docs/adrs/0046-new-decision.md

# Edit with your information
```

**Or use TDD plugin**: ADR creation may be added to future commands.

### Validate ADR

**Check structure**:
- [ ] Has unique number
- [ ] Title is clear and concise
- [ ] Status is set (proposed/accepted/deprecated/superseded)
- [ ] Context explains why decision needed
- [ ] Decision clearly states what was decided
- [ ] Options considered with pros/cons
- [ ] Consequences documented (positive and negative)
- [ ] Mitigation strategies for negative consequences
- [ ] Change log updated

## Additional Resources

### Template

Complete ADR template: `../../templates/adr-template.md`

### Example Files

Real ADR examples in `examples/`:
- **`example-database-selection.md`** - Database technology choice
- **`example-architecture-pattern.md`** - Architecture decision
- **`example-security-decision.md`** - Security-related ADR

### Reference Files

For detailed guidance:
- **`references/adr-formats.md`** - Various ADR format options
- **`references/decision-frameworks.md`** - Decision-making frameworks

## Quick Reference

### When to Create ADR

Write ADR when decision:
- Has lasting impact
- Involves significant trade-offs
- Affects multiple teams/components
- May seem non-obvious to future maintainers
- Is difficult or expensive to reverse

### ADR Template Sections

1. **Title**: ADR-NNNN: [Decision Title]
2. **Status**: proposed | accepted | deprecated | superseded
3. **Context**: Why decision is needed
4. **Decision**: What was decided
5. **Options Considered**: Alternatives evaluated
6. **Consequences**: Positive and negative outcomes
7. **Related Decisions**: Links to related ADRs

### Numbering Convention

- Sequential: 0001, 0002, 0003, ...
- Zero-padded for sorting
- Never reuse numbers
- Start from 0001 for new projects

### File Naming

`docs/adrs/NNNN-kebab-case-title.md`

Use ADRs to maintain a clear record of architectural decisions and their rationale throughout the project lifecycle.
