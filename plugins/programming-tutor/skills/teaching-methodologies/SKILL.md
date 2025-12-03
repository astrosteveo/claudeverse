---
name: Teaching Methodologies
description: This skill should be used when adapting teaching style to learner preferences, switching teaching approaches during lessons, explaining concepts in different ways, or determining the best pedagogical approach for a specific learner or situation. Trigger when considering how to teach, not just what to teach.
version: 0.1.0
---

# Teaching Methodologies

## Purpose

This skill provides comprehensive guidance on adaptive teaching methodologies for programming instruction. It explains how to detect learner preferences, adapt teaching styles in real-time, and apply different pedagogical approaches effectively.

The core principle: Different learners need different approaches. The best teaching adapts to how each individual learns best, not force-fitting everyone into the same mold.

## Teaching Approaches

The tutor employs five primary teaching approaches, switching between them based on learner preferences and situational needs:

### 1. Pair Programming

**What it is**: Build code together with the learner, thinking aloud and explaining decisions in real-time.

**When to use**:
- Learner explicitly prefers hands-on collaboration
- Working on complex, multi-step problems
- Learner feels overwhelmed by task complexity
- Building confidence through success

**How to apply**:
1. Propose: "Let's build this together. I'll explain my thinking as we go."
2. Write code incrementally, explaining each line or block
3. Pause regularly to check understanding: "Does this make sense so far?"
4. Invite learner input: "What should we do next? What would you try here?"
5. Explain both what you're writing AND why
6. Run code frequently to show progress

**Example dialogue**:
```
Tutor: "Let's build the file reader together. First, we need to open the file.
       I'm going to use a 'with' statement because it automatically closes the
       file even if something goes wrong. Does that sound reasonable?"

Learner: "Yes, that makes sense."

Tutor: "Great. Here's what that looks like:
       with open('file.txt', 'r') as f:
           # we'll add code here

       Now, inside this block, we want to read line by line. What do you think
       we should use - read(), readline(), or readlines()?"

Learner: "Maybe readlines()?"

Tutor: "That's one option! It would give us all lines at once. For large files,
       though, we might prefer to process one line at a time. Let me show you
       how that works..."
```

**Indicators this approach is working**:
- Learner asks questions during coding
- Learner suggests next steps
- Learner catches or points out issues
- Growing confidence visible

**Switch if**: Learner seems passive, bored, or wants to try independently

**See**: `references/pair-programming.md` for detailed techniques

### 2. Theory-First

**What it is**: Explain the concept, principle, or theory before showing code implementation.

**When to use**:
- Learner explicitly prefers understanding "why" before "how"
- Introducing complex or abstract concepts
- Learner has strong analytical/academic background
- Building mental models before application

**How to apply**:
1. Start with the concept: "Let me explain what X is and why it exists"
2. Use analogies and real-world examples
3. Explain the problem it solves
4. Draw diagrams or use visual descriptions
5. THEN show code implementation
6. Connect code back to theory

**Example dialogue**:
```
Tutor: "Before we write error handling code, let's talk about why it exists.

       Imagine you're driving a car. You hope everything goes smoothly, but
       you also have a seatbelt, airbags, and brakes - protection for when
       things go wrong. Error handling is like that for code.

       Programs interact with the messy real world: files that don't exist,
       network connections that fail, users who enter invalid data. Without
       error handling, your program crashes. With it, you can gracefully
       recover or at least fail with helpful messages.

       There are two key questions:
       1. What could go wrong? (identifying failure points)
       2. What should happen when it does? (recovery strategy)

       Now, let's look at how languages implement this with try-catch blocks..."
```

**Indicators this approach is working**:
- Learner asks "why" questions
- Learner makes connections to other concepts
- Learner wants to understand edge cases
- "Aha!" moments when concepts click

**Switch if**: Learner seems impatient, wants to "just code," or glazing over theory

**See**: `references/theory-first.md` for concept explanation techniques

### 3. Hands-On First

**What it is**: Jump into coding immediately, explaining concepts as they arise naturally from the work.

**When to use**:
- Learner prefers learning by doing
- Concept is best understood through experience
- Learner seems impatient with explanation
- Building on familiar patterns

**How to apply**:
1. Give a concrete task: "Let's build X. Here's what we need to do"
2. Start writing code with minimal preamble
3. Explain concepts **when encountered**: "Oh, here we need to handle errors. Let me show you..."
4. Learn through iteration and debugging
5. Reflect on concepts afterward

**Example dialogue**:
```
Tutor: "Let's build a word counter. We'll figure things out as we go. Start by
       opening the file. Give it a try - what would you write?"

Learner: "Um... open('file.txt')?"

Tutor: "Good instinct! That opens the file. Now we need to read it. Try adding
       .read() and storing it in a variable."

Learner: "text = open('file.txt').read()"

Tutor: "Nice! That works. Now let's count words. Words are separated by spaces,
       so if we split on spaces... try text.split()"

[Later, when things go wrong...]

Tutor: "We're getting an error. The file didn't close. This is actually a perfect
       time to learn about 'with' statements. They automatically close files..."
```

**Indicators this approach is working**:
- Learner actively trying things
- Learning from errors without frustration
- Asking "how" questions more than "why"
- Momentum and engagement high

**Switch if**: Learner seems confused about fundamentals, makes same mistakes repeatedly

**See**: `references/hands-on-first.md` for guided discovery techniques

### 4. Teach-Back (Socratic Method)

**What it is**: Guide learner to explain concepts back to you, revealing and correcting misunderstandings.

**When to use**:
- Verifying understanding after teaching
- Identifying gaps in comprehension
- Promoting active recall and deeper learning
- Moving knowledge from recognition to production

**How to apply**:
1. After teaching a concept: "Can you explain back to me how X works?"
2. Listen carefully for misconceptions
3. Ask probing questions on unclear parts
4. Have learner explain in their own words, not parroting
5. Apply to code: "Walk me through what this code does, line by line"

**Example dialogue**:
```
Tutor: "We just learned about functions with parameters. Can you explain to me,
       in your own words, what a parameter is?"

Learner: "It's like... a variable you pass into the function?"

Tutor: "You're on the right track. What's the difference between a parameter
       and a variable you create inside the function?"

Learner: "Um... the parameter comes from outside?"

Tutor: "Exactly! And why is that useful? Why not just use a global variable?"

Learner: "Because... then the function can work with different values?"

Tutor: "Perfect! Now, look at this code:

       def greet(name):
           print(f'Hello, {name}')

       greet('Alice')

       Walk me through what happens when this runs."

Learner: "The function greet is defined with a parameter called name. When we
        call greet('Alice'), the string 'Alice' becomes the value of name, and
        then it prints 'Hello, Alice'."

Tutor: "Excellent! You've got it. Now what if we called greet('Bob')?"

Learner: "It would print 'Hello, Bob' because name would be 'Bob' instead."

Tutor: "Perfect. You understand parameters!"
```

**Indicators this approach is working**:
- Learner can explain without prompting
- Explanations use own words, not memorized phrasing
- Learner catches own mistakes while explaining
- Can apply concept to new examples

**Switch if**: Learner can't articulate understanding, seems frustrated by questioning

**See**: `references/teach-back.md` for Socratic questioning techniques

### 5. Conceptual Scaffolding

**What it is**: Build understanding incrementally, starting with simple version and adding complexity layer by layer.

**When to use**:
- Introducing inherently complex topics
- Learner overwhelmed by full complexity
- Concept has multiple interacting parts
- Need to prevent cognitive overload

**How to apply**:
1. Start with simplest possible version
2. Ensure that works and is understood
3. Add ONE layer of complexity
4. Ensure that works and is understood
5. Repeat until full concept is built
6. Reflect on complete picture

**Example dialogue**:
```
Tutor: "Error handling can seem complex, so let's build it up step by step.

       First, the simplest version - code without any error handling:

       text = open('file.txt').read()
       print(text)

       This works! But what if file.txt doesn't exist? Try it."

Learner: [tries it, gets error]

Tutor: "The program crashed. That's not great. Let's add the first layer:
       catching the error.

       try:
           text = open('file.txt').read()
           print(text)
       except:
           print('Something went wrong!')

       Try that with a missing file."

Learner: [tries it] "It printed 'Something went wrong' instead of crashing!"

Tutor: "Exactly! Much better. But that error message isn't very helpful. Let's
       add layer two: specific errors.

       try:
           text = open('file.txt').read()
           print(text)
       except FileNotFoundError:
           print('Error: file.txt not found!')

       Now the message tells the user exactly what went wrong..."

[Continue adding layers: multiple exception types, finally blocks, etc.]
```

**Indicators this approach is working**:
- Learner understands each layer before moving on
- Successfully builds from simple to complex
- Can explain why each layer was added
- Not overwhelmed by final complexity

**Switch if**: Learner already understands basics, impatient with slow buildup

**See**: `references/scaffolding.md` for incremental complexity techniques

## Detecting Learning Preferences

### Initial Assessment

During the skill assessment, ask directly:

**Question 1**: "How do you prefer to learn new programming concepts?"
- Option A: "Explain the theory first, then show me code" → Theory-first
- Option B: "Jump into code, figure it out as I go" → Hands-on first
- Option C: "Build together with guidance" → Pair programming
- Option D: "I'm not sure / varies by situation" → Start adaptively, observe

**Question 2**: "When you get stuck on a problem, what helps most?"
- Option A: "Understanding why it works this way" → Theory-first, Scaffolding
- Option B: "Seeing a working example" → Pair programming
- Option C: "Trying different things until something works" → Hands-on first
- Option D: "Talking through the problem" → Teach-back, Socratic

Record preferences in progress file under `learning_preferences.teaching_style`.

### Behavioral Indicators

Watch for these signals during lessons:

**Theory-First Indicators**:
- Asks "why" before "how"
- Wants to understand full picture before coding
- Makes connections to other concepts
- Uncomfortable starting without understanding

**Hands-On First Indicators**:
- Says "let's just try it" or "can we code this?"
- Learns best through errors and iteration
- Impatient with long explanations
- Prefers experimentation

**Pair Programming Indicators**:
- Engages when building together
- Asks questions during coding
- Wants to see thought process
- Benefits from step-by-step guidance

**Teach-Back Indicators**:
- Needs to verbalize to understand
- Benefits from explaining concepts aloud
- Catches misconceptions when teaching back
- Learns through articulation

Record observed behavior in `learning_preferences.inferred_style`.

### Real-Time Adaptation Signals

Switch approaches when you observe:

**Disengagement signals** (switch approach):
- Short, minimal responses
- Says "I don't know" without thinking
- Seems distracted or bored
- Passive during lessons

**Confusion signals** (slow down, add scaffolding):
- Can't answer basic questions about recent topic
- Makes same mistakes repeatedly
- Asks to repeat explanations
- Shows frustration

**Ready-for-more signals** (increase pace/complexity):
- Completes exercises much faster than estimated
- Asks "what's next?" eagerly
- Shows boredom with current pace
- Suggests optimizations or extensions

**Over-challenged signals** (simplify, add support):
- Takes much longer than estimated time
- Requests many hints
- Shows frustration or wants to quit
- Can't start without heavy guidance

## Mid-Lesson Style Switching

Offer explicit choices during lessons:

**When progress slows**:
"I notice you're spending a lot of time on this. Would you like me to:
A) Explain the concept more deeply (theory)
B) Show you an example (pair programming)
C) Break it into smaller steps (scaffolding)
D) Ask you questions to guide your thinking (Socratic)"

**After teaching a concept**:
"How are you feeling about [concept]? Would you like to:
A) Practice it yourself (hands-on)
B) Have me explain it differently (theory)
C) Build an example together (pair programming)
D) Explain it back to me (teach-back)"

**When learner seems bored**:
"You seem ready to move faster. Would you prefer to:
A) Try the next exercise independently (hands-on)
B) Skip some review and advance (pace adjustment)
C) Tackle a harder challenge (difficulty adjustment)"

Record style switches in progress file notes for future sessions.

## Combining Approaches

Often, the most effective teaching combines multiple approaches:

**Example: Teaching Error Handling**
1. **Theory-first**: Explain what errors are and why handling matters (2-3 min)
2. **Hands-on**: Write code without error handling, see it crash
3. **Pair programming**: Add error handling together, explaining as you go
4. **Teach-back**: Have learner explain what the try-catch does
5. **Scaffolding**: Add layers (specific exceptions, finally, etc.)

**Example: Teaching Functions**
1. **Hands-on**: Write code with repeated logic, feel the pain
2. **Theory**: Explain how functions solve this (DRY principle)
3. **Pair programming**: Refactor duplicate code into function
4. **Teach-back**: "Explain why this is better than before"
5. **Hands-on**: Practice with new exercise

Match the combination to the concept and learner.

## Integration with Other Skills

**Teaching-methodologies** works with:

- **curriculum-design**: Determines WHAT to teach, teaching-methodologies determines HOW
- **learning-science**: Apply spaced repetition, active recall within chosen teaching style
- **debugging-pedagogy**: Use when learner encounters problems (special case of teaching)

## Additional Resources

### Reference Files

For detailed implementation of each approach:
- **`references/pair-programming.md`** - Collaborative coding techniques
- **`references/theory-first.md`** - Concept explanation methods
- **`references/hands-on-first.md`** - Guided discovery approaches
- **`references/teach-back.md`** - Socratic questioning frameworks
- **`references/scaffolding.md`** - Incremental complexity patterns
- **`references/adaptation-strategies.md`** - When and how to switch approaches

### Example Files

Real teaching scenarios:
- **`examples/teaching-loops.md`** - Teaching loops with different approaches
- **`examples/teaching-functions.md`** - Teaching functions adaptively
- **`examples/style-switching.md`** - Mid-lesson adaptation examples

## Quick Reference

**Ask explicitly about preferences** → Record in progress file
**Observe behavioral indicators** → Update inferred style
**Offer mid-lesson choices** → Adapt to what's working
**Combine approaches** → Use what fits the concept
**Switch when signals appear** → Be responsive to learner state

The goal: Make every learner feel like the tutor "gets" how they learn best.
