---
name: Learning Science
description: This skill should be used when implementing spaced repetition, scheduling reviews, applying active recall techniques, determining mastery levels, or using evidence-based learning principles to improve retention and understanding. Trigger when considering how to reinforce learning, not just how to teach new content.
version: 0.1.0
---

# Learning Science

## Purpose

This skill provides evidence-based learning techniques proven to improve long-term retention, deeper understanding, and practical skill mastery in programming education. It explains how to apply principles from cognitive science to tutoring.

The core insight: How you practice matters more than how much you practice. Strategic review and application create lasting learning far better than passive repetition.

## Core Learning Principles

### 1. Spaced Repetition

**Principle**: Review information at increasing intervals for optimal long-term retention.

**The science**: Memory consolidation strengthens when information is retrieved just before forgetting. Spacing creates difficulty that enhances learning.

**Implementation for programming tutor**:

Use a **hybrid approach** combining:
- **Integrated reviews**: Weave earlier concepts into new lessons naturally
- **Custom intervals**: Schedule explicit reviews based on demonstrated retention

**How it works**:

1. **Initial learning**: Concept taught in lesson (Day 0)
2. **First review**: Embedded in next lesson (Day 1-2)
3. **Second review**: Mentioned in later exercise (Day 3-5)
4. **Explicit review**: If struggle detected, schedule formal review (Day 7+)
5. **Custom intervals**: Adjust based on mastery level

**Mastery-based interval calculation**:

```
If mastery_level >= 90: next_review = today + 30 days (strong)
If mastery_level 75-89: next_review = today + 14 days (good)
If mastery_level 60-74: next_review = today + 7 days (acceptable)
If mastery_level < 60: next_review = today + 3 days (needs work)
```

**Integrated review examples**:

- **Learned in Module 1, Lesson 3**: String manipulation for text search
- **Integrated review in Module 1, Lesson 5**: Todo list CLI requires string parsing
- **Integrated review in Module 2, Lesson 1**: JSON parsing includes string manipulation
- **Explicit review if struggling**: Scheduled review session if learner showed difficulty

**Recording reviews** in progress file:

```yaml
concepts_learned:
  - name: "string manipulation"
    mastery_level: 80
    last_reviewed: 2025-12-02
    next_review: 2025-12-16
    review_count: 3
```

**When to trigger explicit review**:
- Concept's `next_review` date has passed
- Learner struggles with concept in new context
- Before advancing to module requiring strong mastery

**See**: `references/spaced-repetition.md` for detailed scheduling algorithms

### 2. Active Recall

**Principle**: Actively retrieving information from memory strengthens learning far more than passive review.

**The science**: The retrieval process itself causes learning. Struggling to remember creates stronger memory traces than re-reading.

**Implementation techniques**:

#### Practice Testing
Ask learners to produce answers without hints:

**Instead of**: "Here's how loops work again..." (passive)
**Try**: "Can you explain how for loops work?" (active recall)

**Instead of**: "Remember, functions take parameters like this..." (recognition)
**Try**: "Write a function that takes two parameters and returns their sum" (production)

#### Blank-Slate Coding
Have learners write code from scratch rather than modify examples:

**Instead of**: "Here's a file reader. Modify it to count words."
**Try**: "Write a file reader that counts words. Start from scratch."

#### Explain-Back (Feynman Technique)
Have learners teach concepts back:

"Explain to me, as if I don't know, how error handling works."
"Walk me through this code line by line and tell me what each part does."

#### Spaced Retrieval Practice
When reviewing concepts, ask for retrieval before re-teaching:

"We learned about classes last week. Before I explain anything, what do you remember about them?"

**Recording active recall performance**:

When learner successfully recalls → increase mastery_level
When learner struggles → maintain or decrease mastery_level, schedule sooner review

### 3. Deliberate Practice

**Principle**: Practice at the edge of current ability with immediate feedback produces fastest skill growth.

**The science**: Too easy = no learning. Too hard = frustration and failure. Just beyond current ability ("Zone of Proximal Development") = optimal growth.

**Implementation**:

#### Identify Current Level
- What can learner do independently and confidently?
- What can they do with hints or guidance?
- What is beyond their current reach?

#### Target the Edge
Design exercises that:
- Build on solid foundation (not too hard)
- Introduce ONE new challenge (not overwhelming)
- Require focused effort (not trivial)

**Example progression**:
1. **Solid**: Write function with parameters ✓
2. **Edge**: Write function that returns a value (NEW)
3. **Too far**: Write recursive function with multiple base cases ✗

Target #2. Once mastered, #3 becomes the new edge.

#### Provide Immediate Feedback
- Run code frequently to see results
- Check understanding with questions
- Catch errors early before bad habits form

#### Focus on Weaknesses
Don't just practice what's already easy:

"I notice you're comfortable with loops but struggle with dictionaries. Let's build a project that really pushes your dictionary skills."

**Recording for deliberate practice**:

```yaml
struggle_points:
  - concept: "error handling"
    marked_date: 2025-12-01
    reason: "requested 3 hints, spent 45 minutes on try-catch"
    review_after_module: 2
    targeted_practice_needed: true
```

### 4. Interleaving

**Principle**: Mixing different topics during practice enhances learning and transfer better than blocking (mastering one topic completely before moving to next).

**The science**: Interleaving creates productive confusion that strengthens discrimination between concepts and improves problem-solving.

**Implementation**:

#### Within Lessons
Mix multiple concepts in exercises:

**Instead of** (blocked):
- Exercise 1-5: All loops
- Exercise 6-10: All functions
- Exercise 11-15: All file I/O

**Try** (interleaved):
- Exercise 1: Loops
- Exercise 2: Functions
- Exercise 3: File I/O
- Exercise 4: Loops + functions
- Exercise 5: Functions + file I/O

#### Within Projects
Require combining multiple concepts:

"Build a file organizer that uses:
- Loops (to process files)
- Functions (to organize code)
- Dictionaries (to group by extension)
- File I/O (to move files)"

#### During Reviews
Review multiple concepts in single session:

"Let's review: write a program that reads a file (file I/O), counts how many times each word appears (dictionaries, loops), and prints the top 5 most common words (sorting, functions)."

**Balance**: Learners may initially feel less confident with interleaving (it's harder), but learning is deeper and transfers better.

### 5. Metacognition

**Principle**: Awareness and understanding of one's own thought processes improves learning effectiveness.

**The science**: Learners who monitor their understanding, recognize what they don't know, and actively strategize learn more effectively.

**Implementation**:

#### Self-Assessment Questions
Regularly ask learners to evaluate themselves:

"On a scale of 1-5, how confident are you with functions?"
"What parts of this lesson did you understand well? What's still fuzzy?"
"How did your approach to this problem compare to what you'd do now?"

#### Reflection Prompts
After completing lessons or projects:

"What was the hardest part? Why do you think it was hard?"
"What debugging strategies worked for you? Which didn't?"
"If you were starting this project again, what would you do differently?"
"What surprised you about how this works?"

#### Strategy Discussion
Make thinking visible:

"When you encounter an error, what's your usual process?"
"How do you decide whether to ask for a hint or keep trying?"
"What helps you remember concepts between sessions?"

#### Growth Mindset Encouragement
Frame struggles as learning opportunities:

"Struggling is a sign you're learning something new - your brain is building new connections."
"Errors are feedback, not failures. What did this error teach you?"

**Recording metacognitive insights**:

Allow learners to add notes to progress file:

```yaml
---
[...progress data...]
---

# My Learning Notes

## Patterns I've Noticed
- I learn best when I code first, then understand theory
- I need to take breaks when stuck >20 minutes
- Drawing diagrams helps me understand data structures

## Debugging Strategies That Work
1. Read error message carefully
2. Add print statements to see variable values
3. Check assumptions about data types

## Goals for Next Session
- Get more comfortable with error handling
- Practice writing functions without hints
```

### 6. Desirable Difficulties

**Principle**: Introducing certain difficulties during learning improves long-term retention and transfer.

**The science**: Easy, smooth learning feels good but doesn't stick. Productive struggle creates deeper understanding.

**Desirable difficulties**:

#### Variation in Practice
Don't practice same thing repeatedly:

**Instead of**: 10 exercises all counting words in files
**Try**: Count words, find longest line, parse CSV, extract emails, etc.

#### Generation Effect
Have learners generate solutions rather than recognize them:

**Instead of**: "Here are 3 ways to reverse a string. Which is best?"
**Try**: "How would you reverse a string? Try to think of 2 different ways."

#### Testing Effect
Use testing as a learning tool, not just assessment:

Practice quizzes before learning → improves subsequent learning
Practice coding challenges → improves skill more than reading examples

#### Contextual Interference
Practice in varied contexts:

- Different file formats (txt, csv, json)
- Different problem domains (text processing, math, data analysis)
- Different project structures (single file, multiple modules)

**Implementation note**: Explain to learners that difficulty is intentional and productive:

"This might feel harder than just following an example, but research shows you'll remember it better because you figured it out yourself."

## Measuring Mastery

### Mastery Levels

Track mastery on 0-100 scale:

**90-100 (Mastery)**: Can teach concept to others, apply in novel contexts, no errors
**75-89 (Proficiency)**: Can use confidently with occasional reference, minor errors
**60-74 (Competence)**: Can use with some guidance, makes mistakes but corrects
**40-59 (Learning)**: Understands basics but needs significant support
**0-39 (Struggling)**: Fundamental misunderstandings, needs reteaching

### Updating Mastery Levels

Adjust based on performance:

**Increase mastery (+5 to +15)**:
- Successfully applies concept without hints
- Explains concept clearly when asked
- Uses concept correctly in new context
- Helps debug others' code using concept

**Maintain mastery (0)**:
- Uses concept correctly with 1-2 minor errors
- Needs brief reminder but then succeeds

**Decrease mastery (-5 to -15)**:
- Can't recall how concept works
- Makes multiple errors applying it
- Needs re-teaching of basics
- Confuses concept with similar ones

### Confidence Ratings

After each lesson, ask and record:

"How confident are you with the concepts from this lesson?"
- High: Understood everything, could teach it, ready to use it
- Medium: Understood most, might need to reference docs, can use with practice
- Low: Confused about key parts, need more practice or re-teaching

**Map to mastery adjustments**:
- High confidence → set mastery to 75-85 (depending on actual performance)
- Medium confidence → set mastery to 60-70
- Low confidence → set mastery to 40-55, add to review queue

## Review Sessions

### When to Trigger Review

**Scheduled reviews**:
- Check progress file daily for concepts where `next_review <= today`
- Prompt learner: "You have 3 concepts due for review. Would you like to review now or continue with new material?"

**Triggered reviews**:
- Learner struggles with concept in new context
- Learner explicitly requests review
- Before module transition (review all module concepts)

**Review session structure**:

1. **Active recall**: "Before I say anything, tell me what you remember about [concept]"
2. **Practical application**: "Let's write some code using [concept]"
3. **Interleaved practice**: Combine with other concepts
4. **Update mastery**: Based on performance
5. **Reschedule**: Calculate next review date

### Review Types

**Quick recall** (5-10 min):
- "Explain to me how [concept] works"
- "What's the syntax for [concept]?"
- "When would you use [concept]?"

**Code review** (10-20 min):
- "Write a quick program that uses [concept]"
- Show buggy code: "Fix the errors in this [concept] usage"
- "Add [concept] to this existing code"

**Project integration** (30-60 min):
- "Build a small project that combines [concept1], [concept2], [concept3]"
- "Refactor this code to use [concept]"

Match review depth to mastery level:
- High mastery (85+): Quick recall sufficient
- Medium mastery (65-84): Code review needed
- Low mastery (<65): Project integration or reteaching

## Integration with Other Skills

**Learning-science** complements:

- **curriculum-design**: Curriculum provides content, learning-science determines review and practice patterns
- **teaching-methodologies**: Teaching methods deliver content, learning-science ensures retention
- **debugging-pedagogy**: Debugging is a specific application of deliberate practice and metacognition

## Practical Application Checklist

When teaching new concepts:
- [ ] Ensure active recall (ask for retrieval, don't just explain)
- [ ] Target deliberate practice edge (not too easy, not too hard)
- [ ] Plan for spaced review (when will this be reinforced?)
- [ ] Use interleaving (combine with other concepts)
- [ ] Encourage metacognition (reflection, self-assessment)

When designing exercises:
- [ ] Include desirable difficulties (variation, generation, testing)
- [ ] Interleave concepts (don't block practice)
- [ ] Target zone of proximal development (appropriate challenge)
- [ ] Provide immediate feedback (run code, check understanding)

When reviewing concepts:
- [ ] Use active recall first (don't re-teach immediately)
- [ ] Adjust mastery based on performance
- [ ] Schedule next review appropriately
- [ ] Combine with other concepts (interleaving)

## Additional Resources

### Reference Files

For detailed algorithms and research foundations:
- **`references/spaced-repetition-algorithms.md`** - Scheduling calculations and interval formulas
- **`references/mastery-assessment.md`** - Rubrics for evaluating mastery levels
- **`references/research-foundations.md`** - Citations and explanations of learning science research

## Quick Reference

**Spaced Repetition**: Review at increasing intervals, integrate into new lessons
**Active Recall**: Make learners retrieve, don't just show again
**Deliberate Practice**: Work at the edge of ability with immediate feedback
**Interleaving**: Mix concepts, don't block practice by topic
**Metacognition**: Reflect on learning process and strategies
**Desirable Difficulties**: Productive struggle enhances learning

Apply these principles consistently for maximum long-term learning and retention.
