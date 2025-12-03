---
name: Curriculum Design
description: This skill should be used when working with the programming tutor curriculum, learning paths, module structure, lesson sequencing, or progression logic. Trigger when planning next lessons, determining module placement, or organizing learning content.
version: 0.1.0
---

# Curriculum Design

## Purpose

This skill provides the complete curriculum structure for the programming tutor, including modules, lessons, exercises, and projects. It defines the linear learning path that takes learners from basic programming knowledge to building practical, useful applications.

The curriculum follows a project-based learning approach with integrated concept teaching. Each module builds on previous knowledge while introducing new skills through hands-on exercises and real-world projects.

## Curriculum Overview

The curriculum consists of **4 modules** with variable lesson counts based on complexity:

1. **Module 1: Tool Building (5-7 lessons)** - Fundamentals through building CLI tools
2. **Module 2: Data Processing (6-8 lessons)** - Data manipulation and API integration
3. **Module 3: Web Basics (7-9 lessons)** - Web servers, APIs, and frontend interaction
4. **Module 4: Real Application (8-10 lessons)** - Complete integrated project

Each module contains a mix of:
- **Quick exercises** - Practice specific concepts (15-30 minutes)
- **Mini-projects** - Apply multiple skills (1-2 hours)
- **Capstone project** - Integrate module skills (3-5 hours)

**Total curriculum duration**: Approximately 40-60 hours depending on pace and prior knowledge.

## Module Structure

### Module 1: Tool Building

**Goal**: Build confidence with fundamental concepts by creating useful command-line tools.

**Prerequisites**: Basic understanding of variables, functions, and control flow (even if rusty)

**Concepts introduced**:
- Variables and data types
- Functions and parameters
- Control flow (if/else, loops)
- File I/O
- String manipulation
- Command-line arguments
- Error handling basics

**Lesson progression** (see `references/module-1.md` for complete details):
1. Hello CLI - Command-line arguments, string formatting
2. File Reader - Reading files, line-by-line processing
3. Text Search Tool - String searching, basic regex
4. File Organizer - Directory operations, file manipulation
5. Todo List CLI - Data structures, persistence
6. Log Parser - String parsing, aggregation
7. **Capstone**: Personal Automation Tool (combines all skills)

### Module 2: Data Processing

**Goal**: Learn to work with external data sources and APIs to build data-driven tools.

**Prerequisites**: Completion of Module 1 or equivalent

**Concepts introduced**:
- Classes and objects
- Methods and attributes
- JSON and CSV parsing
- HTTP requests and APIs
- Data transformation
- Error handling and exceptions
- Testing basics

**Lesson progression** (see `references/module-2.md` for details):
1. JSON Explorer - Parse and navigate JSON data
2. CSV Analyzer - Read and analyze CSV files
3. API Consumer - Fetch data from public APIs
4. Data Transformer - Clean and reshape data
5. Weather Dashboard - Multi-API integration
6. Data Pipeline - Chained transformations
7. Test Writing - Unit tests for data functions
8. **Capstone**: Personal Data Aggregator (API + file + transformation)

### Module 3: Web Basics

**Goal**: Create web applications with backends and frontends.

**Prerequisites**: Completion of Module 2 or equivalent

**Concepts introduced**:
- HTTP protocol basics
- Web servers and routing
- REST API design
- HTML/CSS fundamentals
- JavaScript basics (if language-agnostic)
- Asynchronous programming
- State management
- Frontend-backend communication

**Lesson progression** (see `references/module-3.md` for details):
1. Simple HTTP Server - Basic web server, routes
2. Static File Server - Serving HTML/CSS/JS
3. REST API Design - CRUD operations, JSON responses
4. Dynamic Frontend - Interactive web page
5. Form Handling - POST requests, validation
6. Session Management - User state, cookies/tokens
7. Database Basics - Storing and retrieving data
8. Authentication - Login/logout, protected routes
9. **Capstone**: Full-Stack Mini App (backend + frontend + database)

### Module 4: Real Application

**Goal**: Build a complete, production-ready application integrating all learned skills.

**Prerequisites**: Completion of Module 3 or equivalent

**Concepts introduced**:
- Software architecture patterns
- Code organization and modules
- Configuration management
- Logging and monitoring
- Deployment basics
- Testing strategies
- Documentation
- Performance optimization
- Security best practices

**Lesson progression** (see `references/module-4.md` for details):
1. Project Planning - Architecture design, requirements
2. Project Setup - Structure, configuration, dependencies
3. Core Functionality - Building main features
4. Testing Suite - Comprehensive testing
5. Error Handling - Graceful failures, logging
6. Performance Optimization - Profiling, improvements
7. Security Hardening - Common vulnerabilities, fixes
8. Documentation - README, API docs, inline comments
9. Deployment - Hosting, environment config
10. **Capstone**: Personal Project (learner's choice from provided options)

## Progression Logic

### Determining Next Lesson

To determine what lesson a learner should work on next:

1. **Check progress file** (`.claude/tutor.local.md`):
   - Read `current_module` and `current_lesson`
   - Verify `completed_lessons` list for completed work

2. **Evaluate readiness**:
   - Check if previous lesson is marked complete with `confidence: high` or `medium`
   - If `confidence: low`, suggest review of previous concepts
   - Review `struggle_points` to see if any concepts need revisiting

3. **Check review queue**:
   - If `review_queue` has concepts due today, prioritize review session
   - Use `/tutor:review` command instead of advancing

4. **Advance to next lesson**:
   - If current lesson is complete and no urgent reviews, move to next sequential lesson
   - Load lesson content from appropriate module reference file
   - Update progress file with new position

### Handling Module Transitions

When transitioning between modules:

1. **Module completion check**:
   - Verify capstone project is complete
   - Ensure all core concepts have `mastery_level >= 70`
   - Review any `struggle_points` from the module

2. **Offer choice**:
   - Continue to next module
   - Take a break and do comprehensive review
   - Explore side projects using module skills

3. **Next module introduction**:
   - Explain module goals and what will be built
   - Preview concepts to be learned
   - Set expectations for difficulty increase

### Skill Level Placement

Based on assessment results, place learners at appropriate starting module:

**Module 1 (Beginner)**:
- Cannot write a function that takes parameters
- Struggles with basic control flow (loops, conditionals)
- Has never worked with files programmatically
- Minimal or no practical coding experience

**Module 2 (Early Intermediate)**:
- Can write basic functions and use control flow
- Has created simple scripts or programs
- Understands variables and basic data structures
- Never worked with APIs or external data

**Module 3 (Intermediate)**:
- Comfortable with functions, classes, and data structures
- Has worked with APIs and parsed JSON/CSV
- Understands error handling and testing basics
- Never built a web application

**Module 4 (Advanced Intermediate)**:
- Has built basic web applications
- Understands REST APIs and frontend-backend communication
- Familiar with databases and authentication
- Ready to build complete, production-ready applications

### Adaptive Pacing

Adjust lesson difficulty and support based on learner behavior:

**Fast pace indicators**:
- Completes lessons quickly (<50% estimated time)
- Rarely requests hints
- High confidence ratings on completed lessons
- No concepts in struggle queue

**Response**: Offer optional challenge exercises, suggest exploring variations

**Normal pace indicators**:
- Completes lessons within estimated time range
- Requests occasional hints (1-2 per lesson)
- Mix of high/medium confidence ratings

**Response**: Continue standard progression, maintain current support level

**Slow pace indicators**:
- Takes longer than estimated time (>150%)
- Frequently requests hints (3+ per lesson)
- Low confidence ratings or incomplete lessons
- Multiple concepts in struggle queue

**Response**: Increase support, break lessons into smaller chunks, add review sessions

## Integration with Teaching Methodologies

The curriculum works in tandem with the teaching-methodologies skill to deliver adaptive instruction:

- **Curriculum-design** defines WHAT to teach and WHEN
- **Teaching-methodologies** defines HOW to teach it

When presenting a lesson:
1. Load lesson content from curriculum-design references
2. Apply teaching approach from teaching-methodologies based on learner preferences
3. Use learning-science patterns for retention and mastery
4. Apply debugging-pedagogy when learner encounters problems

## Working with Progress File

### Reading Progress

Parse the `.claude/tutor.local.md` file to extract:

```yaml
current_module: 2
current_lesson: 3
completed_lessons:
  - module: 1
    lesson: 7
    confidence: high
  - module: 2
    lesson: 1
    confidence: medium
  - module: 2
    lesson: 2
    confidence: high
struggle_points:
  - concept: "error handling"
    review_after_module: 2
```

### Updating Progress

After lesson completion, update the progress file:

1. Append to `completed_lessons` list with completion date and confidence
2. Increment `current_lesson` or advance `current_module` if module complete
3. Add newly learned concepts to `concepts_learned` with initial mastery level
4. Update `last_activity` timestamp
5. If learner struggled, add to `struggle_points` with context

Example update:
```yaml
completed_lessons:
  - module: 2
    lesson: 3
    date: 2025-12-02
    confidence: medium  # Based on hints used, time taken
current_module: 2
current_lesson: 4
last_activity: 2025-12-02
concepts_learned:
  - name: "JSON parsing"
    mastery_level: 75
    last_reviewed: 2025-12-02
    next_review: 2025-12-05
```

## Exercise and Project Types

### Quick Exercises

**Purpose**: Practice a single concept in isolation
**Duration**: 15-30 minutes
**Structure**:
- Clear objective (e.g., "Write a function that reverses a string")
- Minimal setup required
- Immediate feedback
- Progressive hints available

**Example**: See `examples/exercise-template.md`

### Mini-Projects

**Purpose**: Integrate 2-3 concepts
**Duration**: 1-2 hours
**Structure**:
- Practical goal (e.g., "Build a file organizer that sorts by extension")
- Starter code or template provided
- Checkpoints for progressive completion
- Testing criteria

**Example**: See `examples/mini-project-template.md`

### Capstone Projects

**Purpose**: Demonstrate mastery of all module concepts
**Duration**: 3-5 hours
**Structure**:
- Open-ended problem with requirements
- No starter code
- Multiple valid approaches
- Self-testing and validation
- Code review and feedback

**Example**: See `examples/capstone-template.md`

## Additional Resources

### Reference Files

For complete module details, lesson plans, and learning objectives:
- **`references/module-1.md`** - Module 1: Tool Building (complete lesson plans)
- **`references/module-2.md`** - Module 2: Data Processing (complete lesson plans)
- **`references/module-3.md`** - Module 3: Web Basics (complete lesson plans)
- **`references/module-4.md`** - Module 4: Real Application (complete lesson plans)
- **`references/progression-logic.md`** - Detailed progression algorithms and decision trees

### Example Files

Lesson and project templates:
- **`examples/exercise-template.md`** - Template for quick exercises
- **`examples/mini-project-template.md`** - Template for mini-projects
- **`examples/capstone-template.md`** - Template for capstone projects

### Language-Specific Examples

The curriculum supports multiple programming languages with full examples:

**Java Support** (fully integrated):
- Complete working examples for all Module 1 and Module 2 lessons
- Located in `skills/java-language/examples/`
- Includes OOP-focused teaching approach
- Use the `java-language` skill when teaching with Java
- Examples: Greeter.java, LineCounter.java, FileStats.java, SearchTool.java, BankAccount.java, TodoList.java

**When teaching with Java**:
1. Load the `java-language` skill at start of lesson
2. Reference Java examples from `skills/java-language/examples/module-X/`
3. Emphasize OOP concepts (encapsulation, classes, objects, inheritance)
4. Use strong typing as a teaching aid
5. Apply Java conventions (PascalCase for classes, camelCase for methods)

**Other languages**: Apply curriculum concepts using language-appropriate syntax and idioms.

## Usage Notes

When using this skill:

1. **Always check progress file first** to understand learner's current state
2. **Reference appropriate module file** for lesson details
3. **Consider learner's pace and confidence** when determining next steps
4. **Integrate with other skills** (teaching-methodologies, learning-science) for complete instruction
5. **Update progress file consistently** after each session

The curriculum is designed to be flexible while maintaining structure—adapt pacing and support level to individual learners while following the proven progression path.
