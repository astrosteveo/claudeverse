# Module 1: Tool Building

## Module Overview

**Goal**: Build confidence with fundamental concepts by creating useful command-line tools.

**Target Audience**: Learners who understand basic programming syntax but have never built complete, useful programs.

**Duration**: 10-14 hours total (variable by pace)

**Concepts Covered**: Variables, functions, control flow, file I/O, string manipulation, command-line arguments, error handling basics

## Lesson 1: Hello CLI

**Duration**: 1-1.5 hours
**Type**: Quick exercise + mini-project
**Objective**: Create a command-line tool that takes arguments and produces formatted output

### Concepts Introduced
- Command-line arguments
- String formatting and interpolation
- Basic functions
- Return values vs print statements

### Learning Outcomes
By the end of this lesson, learners will:
- Parse command-line arguments in their chosen language
- Format strings with variables
- Write functions that take parameters
- Understand when to return vs print

### Exercise: Greeter

Build a program that greets users by name with custom messages.

**Requirements**:
```bash
$ greet Alice
Hello, Alice! Welcome to programming.

$ greet Bob --formal
Good day, Bob. Welcome to programming.

$ greet
Error: Please provide a name
```

**Skills practiced**: Arguments, string formatting, conditionals

### Mini-Project: Personal CLI Tool

Build a tool that provides personalized information.

**Example**: A quote generator, calculator, or unit converter
**Requirements**:
- Take 2+ arguments
- Format output nicely
- Handle missing arguments gracefully
- Include help message

**Checkpoints**:
1. ✓ Parse arguments correctly
2. ✓ Basic functionality works
3. ✓ Error handling for missing args
4. ✓ Formatted output looks good

### Common Struggles

**Struggle**: Confusion between print and return
**Hint**: Ask "What's the difference between showing something to a user vs giving a value to another function?"

**Struggle**: String formatting syntax
**Hint**: Point to language documentation for string interpolation

### Assessment Criteria

**High Confidence**: Completed quickly (<60 min), no hints needed, clean code
**Medium Confidence**: Completed with 1-2 hints, took standard time
**Low Confidence**: Needed 3+ hints, took >90 min, struggled with concepts

---

## Lesson 2: File Reader

**Duration**: 1.5-2 hours
**Type**: Exercise + mini-project
**Objective**: Read and process files line by line

### Concepts Introduced
- Opening and closing files
- Reading files line by line
- File paths (relative vs absolute)
- Basic string operations (strip, split)
- Loop patterns for file processing

### Learning Outcomes
- Open files safely in chosen language
- Process files line by line efficiently
- Handle file not found errors
- Understand file paths

### Exercise: Line Counter

Count lines in a text file.

**Requirements**:
```bash
$ linecount myfile.txt
myfile.txt has 42 lines

$ linecount nonexistent.txt
Error: File 'nonexistent.txt' not found
```

### Mini-Project: File Statistics

Build a tool that provides statistics about a text file.

**Requirements**:
- Line count
- Word count
- Character count
- Average line length
- Longest line

**Example output**:
```
File: example.txt
Lines: 42
Words: 327
Characters: 1893
Avg line length: 45 characters
Longest line: 89 characters
```

### Common Struggles

**Struggle**: File not found errors
**Hint**: "How might you check if a file exists before trying to open it?"

**Struggle**: Not closing files
**Hint**: "What happens if a program crashes while a file is open? How can you ensure files always close?"

### Concepts to Reinforce
- Context managers / with statements / try-finally patterns
- Error handling with try-catch
- String methods for processing

---

## Lesson 3: Text Search Tool

**Duration**: 1.5-2 hours
**Type**: Mini-project
**Objective**: Search for patterns in text files

### Concepts Introduced
- String searching (substring, contains)
- Basic regular expressions
- Case-sensitive vs insensitive matching
- Collecting and displaying results

### Learning Outcomes
- Search for text patterns in files
- Understand basic regex patterns
- Display results with context
- Count occurrences

### Mini-Project: Grep Clone

Build a simplified version of grep.

**Requirements**:
```bash
$ search "error" logfile.txt
Line 12: ERROR: Connection failed
Line 45: ERROR: Timeout occurred
Found 2 matches

$ search "error" logfile.txt --ignore-case
Line 12: ERROR: Connection failed
Line 23: Error in processing
Line 45: ERROR: Timeout occurred
Found 3 matches

$ search "error" logfile.txt --count
Found 2 matches
```

**Bonus**: Add line numbers, context lines (show lines before/after match)

### Common Struggles

**Struggle**: Case-insensitive matching
**Hint**: "How could you transform both the search term and the line to compare them fairly?"

**Struggle**: Regular expression syntax
**Hint**: Start with simple string contains, add regex later

---

## Lesson 4: File Organizer

**Duration**: 2-2.5 hours
**Type**: Mini-project
**Objective**: Organize files in a directory based on extension or other criteria

### Concepts Introduced
- Directory operations (list files, create dirs)
- File extension extraction
- Moving/copying files
- Path manipulation
- Dictionaries/maps for categorization

### Learning Outcomes
- List files in a directory
- Extract file extensions
- Create directories programmatically
- Move or copy files safely
- Group items by category

### Mini-Project: Extension Organizer

Build a tool that organizes files by extension into subdirectories.

**Before**:
```
downloads/
  photo.jpg
  document.pdf
  script.py
  image.png
  report.pdf
```

**After running** `organize downloads/`:
```
downloads/
  images/
    photo.jpg
    image.png
  documents/
    document.pdf
    report.pdf
  code/
    script.py
```

**Requirements**:
- Scan directory for files
- Group by extension
- Create category directories
- Move files safely
- Preserve original if move fails

**Bonus**: Add dry-run mode, undo functionality

### Common Struggles

**Struggle**: Creating directories that may already exist
**Hint**: "What should happen if the directory already exists? How can you handle that gracefully?"

**Struggle**: Moving files safely
**Hint**: "What if a file with the same name already exists in the destination? How can you prevent data loss?"

---

## Lesson 5: Todo List CLI

**Duration**: 2.5-3 hours
**Type**: Mini-project
**Objective**: Build a persistent todo list with add, list, complete, and delete operations

### Concepts Introduced
- Data structures (lists, dictionaries)
- Data persistence (saving to file)
- JSON or CSV for storage
- CRUD operations (Create, Read, Update, Delete)
- State management

### Learning Outcomes
- Design data structures for real-world problems
- Persist data between program runs
- Implement CRUD operations
- Handle edge cases (empty list, invalid IDs)

### Mini-Project: Todo CLI

Build a command-line todo list manager.

**Requirements**:
```bash
$ todo add "Buy groceries"
Added: Buy groceries (ID: 1)

$ todo add "Write code"
Added: Write code (ID: 2)

$ todo list
1. [ ] Buy groceries
2. [ ] Write code

$ todo complete 1
Completed: Buy groceries

$ todo list
1. [x] Buy groceries
2. [ ] Write code

$ todo delete 1
Deleted: Buy groceries
```

**Data structure example** (JSON):
```json
{
  "todos": [
    {"id": 1, "text": "Buy groceries", "completed": true},
    {"id": 2, "text": "Write code", "completed": false}
  ],
  "next_id": 3
}
```

**Checkpoints**:
1. ✓ Add todos (in-memory only)
2. ✓ List todos
3. ✓ Save to file
4. ✓ Load from file on startup
5. ✓ Complete todos
6. ✓ Delete todos

### Common Struggles

**Struggle**: Choosing data structure
**Hint**: "What information do you need to store about each todo? What makes a good unique identifier?"

**Struggle**: Loading and saving correctly
**Hint**: "When should you load data? When should you save it? What if the file doesn't exist yet?"

**Struggle**: ID management
**Hint**: "How can you ensure each todo gets a unique ID, even after deleting some?"

---

## Lesson 6: Log Parser

**Duration**: 2-2.5 hours
**Type**: Mini-project
**Objective**: Parse log files and extract meaningful statistics

### Concepts Introduced
- String parsing techniques
- Regular expressions (intermediate)
- Aggregation (counting, grouping)
- Sorting and ranking
- Dictionaries for accumulation

### Learning Outcomes
- Parse structured text formats
- Extract patterns with regex
- Aggregate data (count by category)
- Sort results
- Format tables for output

### Mini-Project: Log Analyzer

Build a tool that analyzes log files and reports statistics.

**Example log format**:
```
2025-12-01 10:15:32 INFO User login: alice
2025-12-01 10:16:45 ERROR Database connection failed
2025-12-01 10:17:12 WARNING Slow query detected
2025-12-01 10:18:03 INFO User login: bob
2025-12-01 10:19:21 ERROR Database connection failed
```

**Output**:
```bash
$ logparse server.log

Log Summary
-----------
Total entries: 5

By Level:
  INFO: 2 (40%)
  ERROR: 2 (40%)
  WARNING: 1 (20%)

Most common errors:
  1. Database connection failed (2 times)

Time range: 2025-12-01 10:15:32 to 10:19:21
```

**Requirements**:
- Parse timestamp, level, message
- Count by log level
- Find most common error messages
- Calculate time range
- Format output as table

**Bonus**: Filter by date range, level, or search term

### Common Struggles

**Struggle**: Regex for log line parsing
**Hint**: Break the problem down - "What parts does each log line have? Can you match them one at a time?"

**Struggle**: Counting efficiently
**Hint**: "What data structure works well for counting occurrences of items?"

---

## Lesson 7 (Capstone): Personal Automation Tool

**Duration**: 4-5 hours
**Type**: Capstone project
**Objective**: Build a complete CLI tool that solves a real problem using all Module 1 concepts

### Project Options

Learners choose one of these or propose their own:

#### Option 1: Backup Tool
Create timestamped backups of important directories.
- Take directory path as argument
- Create compressed backup with timestamp
- List previous backups
- Restore from backup
- Clean old backups

**Concepts used**: File I/O, directory ops, compression, command-line args, error handling

#### Option 2: Journal CLI
A personal journal with entries, tags, and search.
- Add entries with automatic timestamps
- Tag entries (work, personal, ideas, etc.)
- Search entries by text or tag
- View entries by date range
- Export to readable format

**Concepts used**: Data structures, persistence, string search, formatting, CRUD

#### Option 3: Expense Tracker
Track personal expenses and generate reports.
- Add expenses (amount, category, description)
- List expenses with filters
- Calculate totals by category
- Generate monthly summary
- Budget warnings

**Concepts used**: Data structures, calculations, aggregation, persistence, reporting

#### Option 4: Custom Proposal
Learner proposes their own automation tool.
- Must use at least 4 concepts from Module 1
- Must solve a real problem
- Must have persistent data
- Requires approval before starting

### Requirements

**All projects must include**:
- Command-line argument parsing
- File I/O (reading and writing)
- Data persistence
- Error handling
- Formatted output
- Help message

**Assessment Criteria**:
- Code organization (functions, clear structure)
- Error handling (graceful failures)
- User experience (clear messages, helpful errors)
- Data persistence (survives program restarts)
- Testing (learner tests their own code)

### Capstone Completion

Upon completion:
- Self-test against requirements
- Write brief documentation (README)
- Demonstrate to tutor with various test cases
- Reflect on what was learned and what was challenging

**Success indicators**:
- Tool works reliably for intended use case
- Code is reasonably organized and readable
- Learner can explain their design decisions
- Learner successfully debugged issues independently

---

## Module 1 Assessment

### Concept Mastery Checklist

After completing Module 1, learners should demonstrate mastery of:

- [ ] **Variables and data types** - Can declare and use appropriate types
- [ ] **Functions** - Can write functions with parameters and return values
- [ ] **Control flow** - Can use if/else, loops appropriately
- [ ] **File I/O** - Can read from and write to files safely
- [ ] **String manipulation** - Can parse, format, and transform strings
- [ ] **Command-line arguments** - Can build CLI tools that take input
- [ ] **Error handling** - Can handle common errors gracefully
- [ ] **Data structures** - Can use lists and dictionaries effectively
- [ ] **Problem decomposition** - Can break problems into functions

### Readiness for Module 2

Learners are ready for Module 2 if:
- Completed capstone project with high or medium confidence
- No more than 2 concepts in struggle queue
- Can independently write a basic CLI tool from scratch
- Comfortable debugging simple errors

### Review Recommendations

If learner shows low confidence or multiple struggle points:
- Review specific weak concepts with targeted exercises
- Rebuild a simplified version of a previous project
- Pair program a new small tool with tutor guidance
- Practice debugging with intentionally buggy code

Only advance to Module 2 when Module 1 concepts are solid. Building on shaky foundations leads to frustration and slower overall progress.
