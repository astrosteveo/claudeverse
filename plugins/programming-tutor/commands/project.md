---
name: tutor:project
description: Start a new project or exercise with smart suggestions based on your progress
argument-hint: "[--test]"
allowed-tools:
  - Read
  - Skill
  - Task
  - AskUserQuestion
---

# Tutor: Project Command

Begin a new project or exercise with smart recommendations based on current progress and readiness.

## Purpose

Provides guided project selection, optionally reviewing prerequisite concepts before starting to ensure readiness for success.

## Implementation

1. **Read progress file** to determine current module and lesson
2. **Load curriculum-design skill** to get available projects for current module
3. **Smart suggestion logic**:
   - Check if previous lesson/project is complete
   - Review struggle_points to see if concepts are ready
   - Suggest next appropriate project
4. **Offer choice**:
   ```
   Based on your progress, I suggest: [Project Name]
   This project will practice: [concepts]

   Would you like to:
   A) Start suggested project
   B) Browse other projects in this module
   C) Quick review of concepts before starting
   ```
5. **If review chosen**: Brief active recall of key concepts
6. **Launch adaptive-tutor agent** to guide project work
7. **During project**: Apply teaching-methodologies and debugging-pedagogy as needed

## Project Guidance

- Use pair programming if learner prefers
- Provide checkpoints for progressive completion
- Offer hints via debugging-pedagogy (never give solutions)
- Mark struggle points for later review
- Celebrate milestones and progress

## Example

```
$ /tutor:project

Based on your progress in Module 1, I suggest: Todo List CLI

This project will practice:
- Data structures (lists, dictionaries)
- File I/O and persistence
- CRUD operations
- User input handling

Estimated time: 2.5-3 hours

Would you like to:
A) Start this project
B) Browse other Module 1 projects
C) Quick review of data structures first

[Continues based on choice]
```
