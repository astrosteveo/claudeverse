# Programming Tutor

An interactive programming tutor plugin for Claude Code that helps learners bridge the gap from basic syntax knowledge to building real, useful programs.

## Overview

Programming Tutor is designed for learners who understand fundamental programming concepts (variables, functions, loops) but struggle to apply these skills to build practical applications. The plugin provides:

- **Full Java support** - Comprehensive Java examples and OOP-focused teaching, perfect for learning object-oriented programming
- **Multi-language support** - Choose Java, Python, JavaScript, or other languages
- **Adaptive teaching methodology** - Adjusts to your learning style (pair programming, theory-first, hands-on)
- **Progress tracking** - Resume exactly where you left off across sessions
- **Skill-based assessment** - Start at the right level without reviewing concepts you already know
- **Spaced repetition** - Reinforce concepts at optimal intervals for long-term retention
- **Struggle detection** - Identifies difficult concepts and schedules them for review after mastery of prerequisites
- **Socratic guidance** - Progressive hints through questions, not direct answers

## Curriculum

The tutor follows a structured, linear curriculum with four modules:

1. **Module 1: Tool Building** - Build CLI tools, scripts, and automation while learning variables, functions, control flow, and basic I/O
2. **Module 2: Data Processing** - Work with APIs, JSON/CSV, and data transformations while learning classes, methods, and error handling
3. **Module 3: Web Basics** - Create web servers, REST APIs, and basic frontends while learning async programming and state management
4. **Module 4: Real Application** - Build a complete integrated project while learning architecture, testing, and deployment practices

Each module contains a mix of:
- **Quick exercises** - Practice specific skills in isolation
- **Projects** - Integrate multiple skills into complete, working programs

Choose your preferred programming language during assessment - Java is fully supported with comprehensive examples and is highly recommended for learning OOP concepts. Python, JavaScript, and other languages are also supported.

## Installation

### From Marketplace (when published)
```bash
claude plugins install programming-tutor
```

### Local Development
```bash
# Clone or copy the plugin directory
git clone <repository-url>

# Install the plugin
claude plugins install ./programming-tutor
```

## Commands

### `/tutor:learn [--test]`
Start or resume your learning journey.
- **First run**: Launches skill assessment to determine starting point
- **Subsequent runs**: Resumes from last lesson
- **`--test` flag**: Use temporary progress state for testing

### `/tutor:assess [--test]`
Take or retake the skill assessment conversation.
- Determines your current skill level through targeted questions
- Places you in the appropriate module to begin learning

### `/tutor:review [--test]`
Start a spaced repetition review session.
- Reviews concepts that are due for reinforcement
- Helps move knowledge from short-term to long-term memory

### `/tutor:project [--test]`
Begin a new project or exercise.
- Provides smart suggestions based on your progress
- Shows available projects in current module
- Can review prerequisite concepts before starting

### `/tutor:hint`
Request progressive hints when stuck.
- Provides Socratic questions to guide your thinking
- Never gives away the solution directly
- Teaches debugging and problem-solving process

### `/tutor:progress`
View your learning statistics and progress.
- Current module and lesson
- Completed lessons and dates
- Concept mastery levels
- Upcoming reviews
- Concepts marked for later review

### `/tutor:reset`
Reset your learning progress (with confirmation).
- Useful for starting fresh or testing
- Cannot be undone

## Progress Tracking

Your progress is stored in `.claude/tutor.local.md` with YAML frontmatter containing:

- **Current position** - Module, lesson, last activity date
- **Learning preferences** - Teaching style, help level, pace
- **Completed lessons** - List with completion dates and confidence levels
- **Concept mastery** - Which concepts learned, mastery levels, review schedule
- **Struggle points** - Concepts marked for later review with context
- **Review queue** - Upcoming spaced repetition reviews

The progress file is git-friendly and can include personal notes in the markdown body.

### Example Progress File

```markdown
---
version: 1.0.0
current_module: 2
current_lesson: 3
last_activity: 2025-12-02
learning_preferences:
  teaching_style: pair_programming
  help_level: moderate
  pace: normal
completed_lessons:
  - module: 1
    lesson: 1
    date: 2025-11-28
    confidence: high
concepts_learned:
  - name: "for loops"
    mastery_level: 85
    next_review: 2025-12-10
struggle_points:
  - concept: "error handling"
    marked_date: 2025-12-01
    review_after_module: 2
---

# My Learning Notes

Great progress today on file I/O! Finally understand the difference between read() and readline().
```

## Learning Methodology

The tutor uses evidence-based learning techniques:

- **Deliberate practice** - Focus on skills just beyond current ability
- **Active recall** - Test yourself rather than passive review
- **Spaced repetition** - Review at increasing intervals for retention
- **Interleaving** - Mix concepts to strengthen understanding
- **Immediate feedback** - Learn from mistakes in real-time
- **Metacognition** - Reflect on learning process and strategies

### Adaptive Teaching Styles

The tutor adapts to how you learn best:

- **Pair programming** - Build together with step-by-step guidance
- **Theory-first** - Explain concepts before applying them
- **Hands-on first** - Jump into code, explain theory as needed
- **Teach-back** - Explain concepts back to verify understanding
- **Socratic dialogue** - Guide discovery through questions

The tutor will ask your preference during assessment and continue to adapt based on your behavior.

## Philosophy

### No Direct Solutions
When you're stuck, the tutor will NOT give you the answer. Instead, it will:
1. Ask guiding questions to help you think through the problem
2. Explain the debugging process
3. Suggest relevant documentation or examples
4. Mark the concept for review later if you continue struggling

This approach builds genuine problem-solving skills rather than dependency.

### Focus on Practical Skills
Every lesson and project builds something useful:
- Tools you can actually use
- Skills directly applicable to real development
- Understanding of why, not just how

### Multi-Language Support with Full Java Integration

The tutor supports multiple programming languages and adapts to your choice:

**Fully Supported Languages**:
- **Java** - Comprehensive support with complete OOP focus, perfect for learning object-oriented programming without the complexity of C/C++
- **Python** - Popular, beginner-friendly, versatile
- **JavaScript** - Web-focused, modern syntax
- **Other languages** - Adaptable curriculum structure

**Why Java is Excellent for Learning OOP**:
- Pure object-oriented design - everything is a class
- Strong typing catches errors early and teaches type thinking
- No manual memory management - focus on concepts, not pointers
- Industry-standard language with excellent tooling
- Clear, explicit syntax makes concepts visible
- Perfect bridge between academic learning and professional development

The tutor focuses on universal programming concepts that transfer across languages, but provides language-specific examples and guidance to ensure you learn proper idioms and conventions.

## Testing the Plugin

Use the `--test` flag on any command to avoid affecting your real progress:

```bash
# Test the assessment without saving results
/tutor:assess --test

# Try a lesson in test mode
/tutor:learn --test
```

Test mode uses temporary state that doesn't persist across sessions.

## Development

### Directory Structure
```
programming-tutor/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/                 # Slash commands
│   ├── learn.md
│   ├── assess.md
│   ├── review.md
│   ├── project.md
│   ├── hint.md
│   ├── progress.md
│   └── reset.md
├── agents/                   # Autonomous agents
│   ├── assessment-agent.md
│   ├── curriculum-planner.md
│   ├── adaptive-tutor.md
│   └── review-scheduler.md
├── skills/                   # Teaching knowledge
│   ├── curriculum-design/
│   ├── teaching-methodologies/
│   ├── learning-science/
│   └── debugging-pedagogy/
├── examples/                 # Curriculum content
│   ├── projects/
│   └── exercises/
├── scripts/                  # Utility scripts
└── README.md
```

## Contributing

Contributions are welcome! Areas for improvement:
- Additional curriculum modules
- More project templates
- Language-specific examples
- Assessment question refinement
- Progress visualization tools

## License

MIT License - See LICENSE file for details

## Support

For issues, questions, or feedback:
- GitHub Issues: [Link when published]
- Documentation: [Link when published]
- Claude Code Forums: https://github.com/anthropics/claude-code/discussions
