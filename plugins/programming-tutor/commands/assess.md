---
name: tutor:assess
description: Take or retake the skill assessment to determine appropriate starting module
argument-hint: "[--test]"
allowed-tools:
  - Read
  - Write
  - Task
  - AskUserQuestion
---

# Tutor: Assess Command

Conduct or retake the skill assessment to determine the appropriate starting module in the curriculum.

## Purpose

The assessment determines which module a learner should start at based on their current programming knowledge. It prevents boredom from reviewing concepts already mastered and prevents frustration from starting too advanced.

## Implementation

1. **Check for test flag**
   - If `--test`, use `.claude/tutor-test.local.md`
   - Otherwise, use `.claude/tutor.local.md`

2. **Check if retaking assessment**
   - If progress file exists, confirm: "You've already been assessed. Retaking will reset your module placement. Continue?"
   - If canceled, exit

3. **Launch assessment-agent**
   - Use Task tool with subagent_type="assessment-agent"
   - Assessment agent conducts conversational assessment
   - Returns: starting_module (1-4), learning_preferences

4. **Update or create progress file**
   - If file exists: Update `current_module`, `current_lesson: 1`, `learning_preferences`
   - If new: Create full progress structure
   - Use Write tool to save

5. **Report results**
   - "Based on your assessment, you'll start at Module {X}: {Module Name}"
   - "Your learning preference: {teaching_style}"
   - "Ready to begin? Run `/tutor:learn` to start your first lesson!"

## Assessment Agent Instructions

The assessment-agent should:
- Ask about specific skills (functions, loops, file I/O, APIs, web dev, etc.)
- Not require code writing (conversational only)
- Be friendly and encouraging
- Take 5-10 minutes
- Return clear module recommendation (1, 2, 3, or 4)

Placement criteria:
- **Module 1**: Cannot confidently explain functions with parameters, or has minimal coding experience
- **Module 2**: Comfortable with basic control flow and functions, never worked with APIs or external data
- **Module 3**: Has worked with APIs and data processing, never built web applications
- **Module 4**: Has built web applications, ready for production-level project

## Example

```
$ /tutor:assess

Let's figure out where you should start in the curriculum. I'll ask about your
current programming experience - this should take about 5-10 minutes.

[Assessment conversation]

Based on your assessment, you'll start at Module 2: Data Processing
Your learning preference: hands-on first, then theory

Ready to begin? Run `/tutor:learn` to start your first lesson!
```
