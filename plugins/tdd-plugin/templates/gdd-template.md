---
title: "[Game Name] - Game Design Document"
status: draft
created: YYYY-MM-DD
lastModified: YYYY-MM-DD
owner: "[Lead Designer]"
team:
  - "[Team Member 1]"
  - "[Team Member 2]"
version: "0.1.0"
engine: "[Unity/Godot/Unreal/Custom]"
platforms:
  - "[Platform 1]"
  - "[Platform 2]"
---

# [Game Name] - Game Design Document

## Executive Summary

A 2-3 sentence pitch for the game. What is it, what makes it unique, and why will players love it?

**Genre:** [e.g., Action RPG, Puzzle Platformer, Roguelike]
**Target Audience:** [e.g., Casual mobile gamers, Hardcore strategy fans]
**Comparable Titles:** [e.g., "Hollow Knight meets Celeste"]

## Core Concept

### High Concept
One paragraph describing the game's core idea and what makes it special.

### Core Pillars
The 3-5 guiding principles that every design decision should support:

1. **[Pillar 1]**: Description
2. **[Pillar 2]**: Description
3. **[Pillar 3]**: Description

### Player Fantasy
What fantasy or experience is the player living out? How should they feel while playing?

## Gameplay

### Core Loop
Describe the moment-to-moment gameplay cycle:

```
[Action] → [Feedback] → [Reward] → [Progression] → (repeat)
```

Example:
```
Explore → Discover enemies → Combat → Loot/XP → Upgrade → Explore deeper
```

### Primary Mechanics

#### Mechanic 1: [Name]
- **Description**: What the player does
- **Input**: How the player triggers it
- **Feedback**: Visual/audio/haptic response
- **Purpose**: Why this mechanic exists

#### Mechanic 2: [Name]
- **Description**: What the player does
- **Input**: How the player triggers it
- **Feedback**: Visual/audio/haptic response
- **Purpose**: Why this mechanic exists

### Secondary Mechanics
Supporting systems that enhance but aren't central to gameplay:
- [Mechanic]: Brief description
- [Mechanic]: Brief description

### Controls

| Action | Keyboard | Controller | Touch |
|--------|----------|------------|-------|
| Move | WASD | Left Stick | Virtual Joystick |
| Jump | Space | A/X | Tap |
| Attack | LMB | X/Square | Swipe |
| [Action] | [Key] | [Button] | [Gesture] |

## Progression

### Player Progression
How does the player grow stronger or gain new abilities over time?

- **[System 1]**: Description (e.g., XP/Leveling)
- **[System 2]**: Description (e.g., Skill tree)
- **[System 3]**: Description (e.g., Equipment upgrades)

### Content Progression
How is content unlocked or revealed?

- **[Method 1]**: Description (e.g., Linear levels)
- **[Method 2]**: Description (e.g., Metroidvania-style gating)

### Difficulty Curve
Describe how challenge scales throughout the game.

## Game World

### Setting
Where and when does the game take place? What's the tone/mood?

### Lore & Backstory
Brief overview of the world's history and context (if applicable).

### Key Locations

| Location | Description | Purpose |
|----------|-------------|---------|
| [Location 1] | Brief description | Gameplay role |
| [Location 2] | Brief description | Gameplay role |

## Narrative (if applicable)

### Story Synopsis
Brief overview of the main plot.

### Main Characters

#### [Character Name]
- **Role**: Protagonist/Antagonist/Supporting
- **Description**: Appearance and personality
- **Motivation**: What drives them

### Story Delivery
How is narrative conveyed? (Cutscenes, environmental storytelling, dialogue, etc.)

## Art Direction

### Visual Style
Describe the overall aesthetic (e.g., pixel art, low-poly, realistic, cel-shaded).

### Color Palette
Primary colors and their emotional associations.

### Reference Images
Links or descriptions of visual references and inspiration.

### UI/HUD Design
- **HUD Elements**: Health, ammo, minimap, etc.
- **Menu Style**: Aesthetic and navigation approach
- **Accessibility**: Colorblind modes, scaling options

## Audio Design

### Music
- **Style**: Genre and mood
- **Adaptive**: Does music change based on gameplay?
- **Key Themes**: Main menu, combat, exploration, boss

### Sound Effects
- **Player Actions**: Movement, attacks, abilities
- **Environment**: Ambient sounds, interactive objects
- **Feedback**: UI sounds, damage, rewards

### Voice (if applicable)
- **Dialogue**: Fully voiced, partial, or text-only
- **Style**: Tone and delivery approach

## Level Design

### Level Structure
How are levels/areas organized? (Linear, hub-based, open world, procedural)

### Level Design Principles
- [Principle 1]: Description
- [Principle 2]: Description

### Example Level Breakdown

**[Level Name]**
- **Setting**: Description
- **Objectives**: What the player must accomplish
- **Enemies/Challenges**: What stands in their way
- **Rewards**: What they gain
- **Duration**: Estimated playtime

## Systems & Economy (if applicable)

### Currency/Resources
| Resource | How Obtained | How Spent |
|----------|--------------|-----------|
| [Resource 1] | [Source] | [Use] |
| [Resource 2] | [Source] | [Use] |

### Inventory System
How do players manage items? Limits? Sorting?

### Save System
Auto-save, manual save, checkpoints, permadeath?

## Multiplayer (if applicable)

### Mode Type
Single-player only / Co-op / Competitive / MMO

### Network Architecture
P2P, dedicated servers, etc.

### Social Features
Friends, clans, leaderboards, trading, etc.

## Platform Considerations

### Target Platforms
- **Primary**: [Platform]
- **Secondary**: [Platform]

### Platform-Specific Adaptations
| Platform | Considerations |
|----------|----------------|
| PC | Control rebinding, graphics options |
| Console | Controller optimization, certification |
| Mobile | Touch controls, session length, battery |

### Performance Targets
- **Target FPS**: [e.g., 60fps]
- **Resolution**: [e.g., 1080p/4K]
- **Load Times**: [e.g., <5 seconds]

## Monetization (if applicable)

### Model
Premium / Free-to-play / Subscription / Hybrid

### Revenue Streams
- [Stream 1]: Description
- [Stream 2]: Description

### Ethical Guidelines
What monetization practices will you avoid?

## Scope & Milestones

### MVP Features
Minimum features required for a playable vertical slice:
- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3

### Full Release Features
- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3

### Post-Launch / DLC Ideas
- Idea 1
- Idea 2

## Technical Notes

### Engine & Tools
- **Game Engine**: [Unity/Godot/Unreal/Custom]
- **Version Control**: [Git/Perforce/etc.]
- **Key Plugins/Assets**: [List]

### Known Technical Constraints
- Constraint 1: Description and impact
- Constraint 2: Description and impact

## Open Questions

1. **[Question]**: Context and who needs to decide
2. **[Question]**: Context and who needs to decide

## References & Inspiration

### Games
- [Game 1]: What to learn from it
- [Game 2]: What to learn from it

### Other Media
- [Reference]: Relevance

## Appendix

### Glossary
- **[Term]**: Definition
- **[Term]**: Definition

### Change Log

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| YYYY-MM-DD | 0.1.0 | Initial draft | [Name] |
