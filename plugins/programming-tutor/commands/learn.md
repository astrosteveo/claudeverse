---
name: tutor:learn
description: Start or resume your programming learning journey. On first run, launches skill assessment. On subsequent runs, resumes from last lesson.
argument-hint: "[--test]"
allowed-tools:
  - Read
  - Write
  - AskUserQuestion
  - Skill
  - Task
---

# Tutor: Learn Command

Start or resume the interactive programming tutorial.

## Behavior

### First Run (No Progress File)
If `.claude/tutor.local.md` does not exist:
1. Launch the assessment-agent to determine starting module
2. Assessment agent will conduct conversational skill assessment
3. Based on assessment, create initial progress file
4. Begin first lesson in determined module

### Subsequent Runs (Progress File Exists)
If `.claude/tutor.local.md` exists:
1. Read the progress file to determine current state
2. Check for due reviews in `review_queue`
3. If reviews are due, offer choice:
   - "You have {count} concepts due for review. Review now or continue with new material?"
4. If no urgent reviews, resume current lesson or advance to next

### Test Mode
If `--test` flag is provided:
- Use `.claude/tutor-test.local.md` instead of `.claude/tutor.local.md`
- All progress stored in test file (does not affect real progress)
- Allows testing the tutor without modifying actual learning progress

## Implementation Steps

1. **Check for test flag**
   - If `--test` present, set progress file to `.claude/tutor-test.local.md`
   - Otherwise, use `.claude/tutor.local.md`

2. **Check if progress file exists**
   - Use Read tool to attempt reading progress file
   - If file doesn't exist → First run workflow
   - If file exists → Resume workflow

3. **First Run Workflow**
   - Explain: "Welcome to the Programming Tutor! I'll help you go from knowing basic syntax to building real, useful programs."
   - Explain: "First, let's figure out where you should start. I'll ask you some questions about your current skills."
   - Use Task tool to launch assessment-agent
   - Wait for assessment agent to complete and return starting module
   - Create progress file with initial state:
   ```yaml
   ---
   version: 1.0.0
   current_module: [from assessment]
   current_lesson: 1
   last_activity: [today's date]
   learning_preferences:
     language: [from assessment - e.g., java, python, javascript]
     teaching_style: [from assessment]
     help_level: moderate
     pace: normal
   completed_lessons: []
   concepts_learned: []
   struggle_points: []
   review_queue: []
   ---
   ```
   - Use Write tool to create progress file
   - Begin Module [X], Lesson 1

4. **Resume Workflow**
   - Read progress file
   - Parse YAML frontmatter to extract:
     - `current_module`
     - `current_lesson`
     - `review_queue`
     - `last_activity`
   - Check review_queue for concepts where `due_date <= today`
   - If reviews due:
     - Count reviews: `review_count = len([r for r in review_queue if r.due_date <= today])`
     - Use AskUserQuestion: "You have {review_count} concepts due for review. Would you like to review them now or continue with new material?"
     - If "Review": Invoke `/tutor:review` command
     - If "Continue": Proceed to current lesson
   - Load current lesson using curriculum-design skill
   - Apply teaching-methodologies based on `learning_preferences.teaching_style`
   - Begin teaching the lesson

5. **Load and Teach Lesson**
   - Use Skill tool to load curriculum-design skill
   - Reference the appropriate module file (e.g., `references/module-1.md`)
   - Extract lesson plan for current_module, current_lesson
   - Use Skill tool to load teaching-methodologies skill
   - Apply preferred teaching approach
   - Teach the lesson using adaptive-tutor agent (via Task tool)

6. **During Lesson**
   - If learner requests hints, use debugging-pedagogy skill
   - If learner struggles (multi-factor detection), mark concept for review
   - If learner completes exercise/project, update progress file

7. **After Lesson Completion**
   - Ask confidence level: High, Medium, or Low
   - Update progress file:
     - Add to `completed_lessons`
     - Increment `current_lesson` or advance `current_module`
     - Add learned concepts to `concepts_learned` with initial mastery
     - Schedule reviews using learning-science principles
     - Update `last_activity`
   - Use Write tool to update progress file
   - Offer next steps: continue to next lesson, take break, review, etc.

## Skills to Use

- **curriculum-design**: For lesson content and structure
- **teaching-methodologies**: For adaptive teaching approach
- **learning-science**: For spaced repetition and mastery tracking
- **debugging-pedagogy**: When learner encounters problems

## Agents to Use

- **assessment-agent**: For initial skill assessment (first run only)
- **adaptive-tutor**: For teaching lessons with style adaptation
- **review-scheduler**: For managing review queue

## Progress File Format

The progress file (`.claude/tutor.local.md`) uses YAML frontmatter:

```yaml
---
version: 1.0.0
current_module: 2
current_lesson: 3
last_activity: 2025-12-02
learning_preferences:
  language: java
  teaching_style: pair_programming
  help_level: moderate
  pace: normal
  inferred_style: hands_on_first
completed_lessons:
  - module: 1
    lesson: 7
    date: 2025-11-28
    confidence: high
  - module: 2
    lesson: 1
    date: 2025-11-30
    confidence: medium
  - module: 2
    lesson: 2
    date: 2025-12-01
    confidence: high
concepts_learned:
  - name: "for loops"
    mastery_level: 85
    last_reviewed: 2025-12-01
    next_review: 2025-12-15
    review_count: 2
  - name: "functions with parameters"
    mastery_level: 75
    last_reviewed: 2025-12-02
    next_review: 2025-12-09
    review_count: 1
struggle_points:
  - concept: "error handling"
    marked_date: 2025-12-01
    reason: "requested 3 hints, spent 40 minutes"
    review_after_module: 2
    current_lesson: "Module 2, Lesson 3"
review_queue:
  - concept: "string manipulation"
    due_date: 2025-12-03
    mastery_level: 80
---

# My Learning Notes

[Optional learner notes in markdown]
```

## Example Usage

```
$ /tutor:learn
Welcome to the Programming Tutor! I'll help you go from knowing basic syntax
to building real, useful programs.

First, let's figure out where you should start. I'll ask you some questions
about your current skills...

[Assessment conversation follows]
```

```
$ /tutor:learn
Welcome back! Last session: Module 2, Lesson 2 (completed 2025-12-01)

You have 1 concept due for review today. Would you like to:
A) Review now
B) Continue with Module 2, Lesson 3

[Continue with chosen path]
```

```
$ /tutor:learn --test
[Test mode] Welcome to the Programming Tutor!
Progress will be saved to .claude/tutor-test.local.md

[Assessment conversation follows]
```

## Tips

- The --test flag is useful for developers testing the plugin or learners wanting to explore without affecting their real progress
- If resuming after a long break (>7 days), consider offering a review session first
- Always check for due reviews before starting new content
- Use adaptive-tutor agent for actual teaching to ensure style adaptation
- Record all struggle points for later review scheduling

## Error Handling

- If progress file is corrupted, offer to create new one (warn about losing progress)
- If curriculum files are missing, provide helpful error message
- If learner is on non-existent lesson, reset to last valid lesson or offer restart
- Gracefully handle missing fields in progress file (use sensible defaults)
