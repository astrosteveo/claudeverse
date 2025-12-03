---
name: tutor:progress
description: View your learning statistics, completed lessons, concept mastery, and upcoming reviews
allowed-tools:
  - Read
---

# Tutor: Progress Command

Display comprehensive learning progress statistics and insights.

## Purpose

Provides visibility into learning journey, mastery levels, and upcoming reviews. Helps learners see their growth and identify areas needing attention.

## Implementation

1. **Read progress file** (`.claude/tutor.local.md`)
2. **Parse and display**:
   - Current position
   - Completed lessons
   - Concept mastery levels
   - Upcoming reviews
   - Struggle points marked for review
   - Learning streaks and patterns

3. **Format output** clearly with sections and visual indicators

## Output Format

```
==============================================
PROGRAMMING TUTOR - LEARNING PROGRESS
==============================================

CURRENT POSITION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Module: 2 - Data Processing
Lesson: 3 - API Consumer
Last activity: 2025-12-02
Learning streak: 5 days

COMPLETED LESSONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ Module 1 - Tool Building (7/7 lessons, 100%)
  Completed: 2025-11-28
  Confidence: High

✓ Module 2 - Data Processing (2/8 lessons, 25%)
  Lesson 1: JSON Explorer (High confidence)
  Lesson 2: CSV Analyzer (High confidence)

Total: 9 lessons completed

CONCEPT MASTERY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🟢 for loops ..................... 92% (Mastery)
🟢 functions ..................... 88% (Proficiency)
🟢 string manipulation ........... 85% (Proficiency)
🟡 file I/O ...................... 75% (Proficiency)
🟡 error handling ................ 68% (Competence)
🟡 JSON parsing .................. 70% (Competence)

Legend: 🟢 90-100% (Mastery) | 🟢 75-89% (Proficiency) | 🟡 60-74% (Competence)

UPCOMING REVIEWS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📅 Due today (0)
📅 Next 7 days (2)
  - String manipulation (Dec 5)
  - Functions (Dec 7)
📅 Next 30 days (3)
  - File I/O (Dec 15)
  - for loops (Dec 28)
  - Error handling (Jan 2)

CONCEPTS MARKED FOR LATER REVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ None - great job!

LEARNING PREFERENCES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Teaching style: Pair programming
Help level: Moderate
Pace: Normal
Inferred preference: Hands-on first

INSIGHTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💡 You're making great progress! Module 1 complete with high confidence.
💡 Keep up the learning streak - you've studied 5 days in a row!
💡 Consider reviewing error handling - it's below 70% mastery.

==============================================
Ready to continue? Run `/tutor:learn`
==============================================
```

## Insights Generation

Generate helpful insights based on progress data:
- Celebrate completed modules and streaks
- Suggest reviews for concepts below 70% mastery
- Note if no activity in >7 days
- Highlight upcoming reviews
- Recognize consistent learning patterns

## Example Scenarios

**New learner** (minimal progress):
```
$ /tutor:progress

You're just getting started! Complete the assessment to begin.
Run `/tutor:assess` to find your starting point.
```

**Mid-progress learner**:
```
[Shows detailed progress as above]
```

**Completed curriculum**:
```
🎉 CONGRATULATIONS! You've completed all 4 modules!

You've gone from basic syntax to building production-ready applications.
Skills mastered: [list]
Projects completed: [list]

What's next?
- Build personal projects using your new skills
- Contribute to open source
- Continue learning advanced topics
```
