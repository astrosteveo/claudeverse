---
name: tutor:review
description: Start a spaced repetition review session for concepts due for reinforcement
argument-hint: "[--test]"
allowed-tools:
  - Read
  - Write
  - Task
  - Skill
---

# Tutor: Review Command

Conduct a spaced repetition review session to reinforce concepts and improve long-term retention.

## Purpose

Reviews help move knowledge from short-term to long-term memory using evidence-based spaced repetition. Concepts are reviewed at optimal intervals based on mastery levels.

## Implementation

1. **Read progress file** (use --test flag for test progress file)
2. **Check review_queue** for concepts where `due_date <= today`
3. **If no reviews due**: "No reviews due today! Next review: {earliest_due_date}"
4. **If reviews due**: Launch review-scheduler agent to conduct review session
5. **For each concept**:
   - Active recall: "What do you remember about {concept}?"
   - Practical application: Code exercise using concept
   - Update `mastery_level` based on performance
   - Calculate `next_review` date using learning-science intervals
6. **Update progress file** with new mastery levels and review dates

## Review Types

- **Quick recall** (5-10 min): Explain concept, answer questions
- **Code review** (10-20 min): Write or fix code using concept
- **Integration** (20-30 min): Combine multiple reviewed concepts in project

Match depth to current mastery:
- High mastery (85+): Quick recall
- Medium mastery (65-84): Code review
- Low mastery (<65): Integration or reteaching

## Example

```
$ /tutor:review

You have 3 concepts due for review:
1. String manipulation (last reviewed 7 days ago, mastery: 80%)
2. Functions (last reviewed 14 days ago, mastery: 90%)
3. File I/O (last reviewed 5 days ago, mastery: 65%)

Starting review session...
[Review exercises follow]

Review complete!
- String manipulation: 80% → 85%  (next review: Dec 20)
- Functions: 90% → 92% (next review: Jan 5)
- File I/O: 65% → 75% (next review: Dec 10)
```
