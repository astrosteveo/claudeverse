# Style Switching Examples

## Example 1: Detecting Impatience with Theory

### Scenario

Teaching loops using theory-first approach, but learner showing signs of disengagement.

### Dialogue

**Tutor** (theory-first): "A loop is a control structure that repeats a block of code. There are several types: for loops iterate over sequences, while loops continue until a condition is false, and..."

**Learner**: "Okay..." [short response, indicator of disengagement]

**Tutor** (notices signal): "You know what, let's just build something. We can learn the theory as we go. Let's write a program that prints numbers 1 through 10."

**Learner**: "Sure!" [engagement increases]

**Tutor** (switching to hands-on first): "Give it a try. How would you print the numbers?"

**Learner**: "Would I use a for loop?"

**Tutor**: "Exactly! Show me what that would look like."

[Learner now engaged and learning through doing]

### Lesson

**Detected signal**: Short response, lack of engagement with theory
**Action**: Switch from theory-first to hands-on first
**Result**: Engagement restored, learning continues

---

## Example 2: Confusion Signals Requiring Scaffolding

### Scenario

Learner struggling with functions after hands-on approach. Multiple failed attempts.

### Dialogue

**Tutor** (hands-on first): "Try writing a function that adds two numbers."

**Learner**: [writes code that doesn't work]

**Tutor**: "Not quite. Try again, think about the structure."

**Learner**: [second attempt, still not working] "I don't know what I'm doing wrong..."

**Tutor** (notices confusion signal): "Let me help break this down into smaller pieces. First, let's just define an empty function that does nothing. Try this:

def add():
    pass

Can you write that?"

**Learner**: [writes it] "Okay..."

**Tutor** (scaffolding): "Great! Now let's add parameters - the two numbers we want to add. Update it to:

def add(a, b):
    pass

Try that."

**Learner**: [writes it] "Got it."

**Tutor** (scaffolding): "Perfect. Now replace 'pass' with the actual addition. What should go there?"

**Learner**: "return a + b?"

**Tutor**: "Exactly! You just wrote a complete function!"

### Lesson

**Detected signal**: Multiple failed attempts, frustration, "I don't know"
**Action**: Switch from hands-on first to conceptual scaffolding
**Result**: Success through incremental building

---

## Example 3: Verification with Teach-Back

### Scenario

After teaching error handling, verify understanding before moving on.

### Dialogue

**Tutor** (after pair programming): "We just built error handling together. Before we move on, can you explain to me what this code does:

try:
    f = open('file.txt')
    data = f.read()
    f.close()
except FileNotFoundError:
    print('File not found!')
"

**Learner**: "It tries to open the file, and if the file doesn't exist, it prints an error message."

**Tutor** (probing): "Good! What happens if a different error occurs, like a permission error?"

**Learner**: "Um... I'm not sure."

**Tutor** (identified gap): "Ah, that's an important edge case! Right now, permission errors would crash the program because we're only catching FileNotFoundError. Want to fix that together?"

**Learner**: "Yes, how would I do that?"

**Tutor** (pair programming to address gap): "Let's add another except block..."

### Lesson

**Used teach-back**: To verify understanding
**Discovered gap**: Only catching one exception type
**Action**: Switch back to pair programming to address specific gap
**Result**: Deeper understanding achieved

---

## Example 4: Fast Learner Needing More Challenge

### Scenario

Learner completing exercises much faster than estimated, showing boredom.

### Dialogue

**Tutor**: "Great job! You finished that in 15 minutes - that usually takes 30. How did that feel?"

**Learner**: "Pretty easy. What's next?"

**Tutor** (notices ready-for-more signal): "I can see you're ready for something more challenging. Would you like to:
A) Skip the next beginner exercise and jump to the mini-project
B) Try a harder variation of what we just did
C) Build something of your own choosing using these concepts"

**Learner**: "Let's do option C!"

**Tutor** (adapting pace and autonomy): "Perfect! Take what we just learned about file I/O and build any tool you want. Some ideas: a file renamer, a duplicate file finder, or something else entirely. I'll be here if you need hints, but try it independently first."

**Learner**: [works independently with high engagement]

### Lesson

**Detected signal**: Completing work quickly, looking for more
**Action**: Offer choice, increase difficulty and autonomy
**Result**: Maintained engagement, faster progression

---

## Example 5: Combining Multiple Approaches

### Scenario

Teaching functions to a learner with mixed preferences. Using multiple approaches in sequence.

### Dialogue

**Tutor** (theory-first - brief): "Functions let us reuse code. Instead of copy-pasting, we write it once and call it many times. This is called the DRY principle - Don't Repeat Yourself."

**Tutor** (hands-on first): "Let me show you the pain of NOT using functions. Write a program that calculates the area of three different rectangles and prints them."

**Learner**: [writes code with repeated calculation logic]

**Tutor**: "See all that repetition? Let's fix it with a function."

**Tutor** (pair programming): "We'll create a function together. First, the definition:

def calculate_area(width, height):
    # what should go here?"

**Learner**: "return width * height?"

**Tutor**: "Perfect! Now let's use it:

area1 = calculate_area(5, 10)
area2 = calculate_area(3, 7)
area3 = calculate_area(8, 12)

Much cleaner! Try it out."

**Learner**: [runs code successfully]

**Tutor** (teach-back): "Excellent! Now explain to me: why is this better than the repeated code you wrote before?"

**Learner**: "Because if I need to change how I calculate area, I only have to change it in one place instead of three."

**Tutor**: "Exactly! And you can reuse that function everywhere."

### Lesson

**Used combination**:
1. Theory-first (brief motivator)
2. Hands-on (feel the pain)
3. Pair programming (build solution)
4. Teach-back (verify understanding)

**Result**: Comprehensive understanding through multi-faceted approach

---

## Key Patterns

### When to Switch

1. **Disengagement** → Try different approach
2. **Confusion** → Add scaffolding, slow down
3. **Boredom** → Increase pace, difficulty, autonomy
4. **Frustration** → More support, pair programming
5. **Success** → Verify with teach-back, increase challenge

### How to Offer Choices

**Template**: "I notice [observation]. Would you like to [option A] or [option B]?"

**Examples**:
- "I notice this is going slowly. Would you like me to explain the concept first, or shall we build an example together?"
- "You seem ready for more. Would you like to try this independently or work on something harder?"
- "This seems tricky. Want to break it into smaller steps, or would an example help?"

### Adaptation Principles

1. **Start with stated preference** (from assessment)
2. **Observe behavioral signals** (engagement, confusion, speed)
3. **Offer explicit choices** when appropriate
4. **Switch approaches** when current isn't working
5. **Record what works** in progress file for future sessions

### Success Indicators

Teaching approach is working when:
- ✓ Learner is engaged (asking questions, trying things)
- ✓ Understanding is growing (can answer questions, apply concepts)
- ✓ Frustration is minimal (challenges but not overwhelming)
- ✓ Progress is steady (completing lessons, moving forward)
- ✓ Learner feels successful (confidence building)

If any of these are missing, consider switching approaches.
