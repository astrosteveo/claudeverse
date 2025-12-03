---
name: Java Language Support
description: This skill should be used when teaching programming concepts using Java. Contains Java syntax, OOP patterns, conventions, and best practices for building CLI tools, data processing applications, and web services. Trigger when learner has chosen Java or when providing Java-specific guidance.
version: 0.1.0
---

# Java Language Support

## Purpose

This skill provides comprehensive Java language support for the programming tutor. It includes syntax, Object-Oriented Programming (OOP) concepts, conventions, patterns, and practical examples for all curriculum modules.

Java is an excellent language for learning OOP principles without the complexity of manual memory management (C/C++) while providing strong typing, clear structure, and industry relevance.

## Why Java for Learning OOP

**Advantages for teaching**:
- **Pure OOP design**: Everything is a class, reinforcing OOP thinking
- **Clear syntax**: Explicit type declarations make code self-documenting
- **Strong typing**: Catches errors early, teaches type thinking
- **No manual memory management**: Focus on concepts, not pointers
- **Industry standard**: Skills directly transfer to professional development
- **Rich standard library**: Built-in tools for common tasks
- **Excellent tooling**: IDEs with autocomplete, refactoring, debugging
- **Platform independent**: Write once, run anywhere (WORA)

**Teaching progression**:
- Module 1: Basics (variables, methods, control flow, File I/O)
- Module 2: OOP fundamentals (classes, objects, encapsulation, inheritance)
- Module 3: Advanced OOP (interfaces, polymorphism, design patterns)
- Module 4: Software architecture (packages, modules, testing, deployment)

## Java Basics

### Compilation and Execution

```bash
# Compile Java source to bytecode
javac HelloWorld.java

# Run compiled class
java HelloWorld

# Compile and run in one step (Java 11+)
java HelloWorld.java
```

### Project Structure

Standard Java project layout:
```
project-name/
├── src/
│   └── com/
│       └── example/
│           └── MainClass.java
├── bin/              # Compiled .class files
├── lib/              # External libraries
└── README.md
```

### Naming Conventions

- **Classes**: PascalCase (UserAccount, FileProcessor)
- **Methods**: camelCase (processFile, getUserName)
- **Variables**: camelCase (fileName, totalCount)
- **Constants**: UPPER_SNAKE_CASE (MAX_SIZE, DEFAULT_PORT)
- **Packages**: lowercase (com.example.util)

## Module 1: Java Fundamentals

### Basic Program Structure

```java
public class HelloWorld {
    // main method - program entry point
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

**Key concepts**:
- `public`: Access modifier (visible everywhere)
- `class`: Everything in Java is inside a class
- `static`: Method belongs to class, not instance
- `void`: Method returns nothing
- `String[] args`: Command-line arguments array

### Variables and Types

```java
// Primitive types
int count = 42;
double price = 19.99;
boolean isActive = true;
char grade = 'A';

// Reference types
String name = "Alice";
int[] numbers = {1, 2, 3, 4, 5};

// Type inference (Java 10+)
var message = "Hello";  // Inferred as String
var total = 100;        // Inferred as int
```

**Teaching points**:
- Primitives vs reference types
- Type safety and compile-time checking
- Variable initialization requirements

### Command-Line Arguments

```java
public class Greeter {
    public static void main(String[] args) {
        // Check if arguments provided
        if (args.length == 0) {
            System.out.println("Usage: java Greeter <name>");
            return;
        }

        String name = args[0];
        System.out.println("Hello, " + name + "!");

        // Check for optional flag
        if (args.length > 1 && args[1].equals("--formal")) {
            System.out.println("Good day, " + name + ".");
        }
    }
}
```

**Usage**:
```bash
java Greeter Alice
java Greeter Bob --formal
```

### File I/O

**Reading files** (modern approach with try-with-resources):
```java
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class FileReader {
    public static void main(String[] args) throws IOException {
        // Read all lines at once
        Path filePath = Path.of("example.txt");
        List<String> lines = Files.readAllLines(filePath);

        for (String line : lines) {
            System.out.println(line);
        }
    }
}
```

**Line-by-line processing** (memory efficient):
```java
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class LineCounter {
    public static void main(String[] args) {
        String fileName = args[0];
        int count = 0;

        // Try-with-resources ensures file closes
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            while (reader.readLine() != null) {
                count++;
            }
            System.out.println(fileName + " has " + count + " lines");
        } catch (IOException e) {
            System.err.println("Error: File '" + fileName + "' not found");
        }
    }
}
```

**Writing files**:
```java
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class FileWriter {
    public static void main(String[] args) throws IOException {
        List<String> lines = List.of(
            "First line",
            "Second line",
            "Third line"
        );

        Path filePath = Path.of("output.txt");
        Files.write(filePath, lines);
    }
}
```

**Teaching points**:
- Try-with-resources pattern (automatic resource management)
- IOException handling
- Path API (modern) vs File class (legacy)
- BufferedReader for efficiency

### String Manipulation

```java
public class StringExamples {
    public static void main(String[] args) {
        String text = "  Hello, World!  ";

        // Common operations
        System.out.println(text.trim());              // "Hello, World!"
        System.out.println(text.toLowerCase());       // "  hello, world!  "
        System.out.println(text.contains("World"));   // true
        System.out.println(text.replace("World", "Java")); // "  Hello, Java!  "

        // Splitting
        String csv = "apple,banana,orange";
        String[] fruits = csv.split(",");

        // Formatting
        String formatted = String.format("Name: %s, Age: %d", "Alice", 30);

        // StringBuilder for efficient concatenation
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < 5; i++) {
            builder.append("Line ").append(i).append("\n");
        }
        String result = builder.toString();
    }
}
```

### Control Flow

```java
public class ControlFlowExamples {
    public static void main(String[] args) {
        // If-else
        int score = 85;
        if (score >= 90) {
            System.out.println("Grade: A");
        } else if (score >= 80) {
            System.out.println("Grade: B");
        } else {
            System.out.println("Grade: C");
        }

        // For loop
        for (int i = 0; i < 5; i++) {
            System.out.println("Count: " + i);
        }

        // Enhanced for loop (for-each)
        String[] names = {"Alice", "Bob", "Charlie"};
        for (String name : names) {
            System.out.println("Hello, " + name);
        }

        // While loop
        int count = 0;
        while (count < 5) {
            System.out.println(count);
            count++;
        }

        // Switch expression (Java 14+)
        String day = "Monday";
        String result = switch (day) {
            case "Monday", "Friday" -> "Work day";
            case "Saturday", "Sunday" -> "Weekend";
            default -> "Other day";
        };
    }
}
```

## Module 2: Object-Oriented Programming

### Classes and Objects

```java
// Define a class
public class BankAccount {
    // Instance variables (fields)
    private String accountNumber;
    private double balance;

    // Constructor
    public BankAccount(String accountNumber, double initialBalance) {
        this.accountNumber = accountNumber;
        this.balance = initialBalance;
    }

    // Methods
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            System.out.println("Deposited: $" + amount);
        }
    }

    public boolean withdraw(double amount) {
        if (amount > 0 && balance >= amount) {
            balance -= amount;
            System.out.println("Withdrew: $" + amount);
            return true;
        }
        return false;
    }

    public double getBalance() {
        return balance;
    }

    public String getAccountNumber() {
        return accountNumber;
    }
}

// Using the class
public class BankingApp {
    public static void main(String[] args) {
        BankAccount account = new BankAccount("12345", 1000.00);
        account.deposit(500);
        account.withdraw(200);
        System.out.println("Balance: $" + account.getBalance());
    }
}
```

**Teaching points**:
- **Encapsulation**: Private fields, public methods
- **Constructors**: Initialize object state
- **this keyword**: Refer to current instance
- **Getters/setters**: Controlled access to fields
- **Instance vs static**: Object-level vs class-level

### Encapsulation

```java
public class User {
    // Private fields - cannot be accessed directly
    private String email;
    private int age;

    // Constructor with validation
    public User(String email, int age) {
        setEmail(email);
        setAge(age);
    }

    // Getter
    public String getEmail() {
        return email;
    }

    // Setter with validation
    public void setEmail(String email) {
        if (email != null && email.contains("@")) {
            this.email = email;
        } else {
            throw new IllegalArgumentException("Invalid email");
        }
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        if (age >= 0 && age <= 120) {
            this.age = age;
        } else {
            throw new IllegalArgumentException("Invalid age");
        }
    }
}
```

**Why encapsulation matters**:
- Control how data is accessed and modified
- Add validation logic
- Change internal implementation without breaking code
- Maintain invariants (rules about object state)

### Inheritance

```java
// Base class
public class Animal {
    protected String name;

    public Animal(String name) {
        this.name = name;
    }

    public void eat() {
        System.out.println(name + " is eating");
    }

    public void sleep() {
        System.out.println(name + " is sleeping");
    }
}

// Derived class
public class Dog extends Animal {
    private String breed;

    public Dog(String name, String breed) {
        super(name);  // Call parent constructor
        this.breed = breed;
    }

    // Override parent method
    @Override
    public void eat() {
        System.out.println(name + " is munching on dog food");
    }

    // Add new method
    public void bark() {
        System.out.println(name + " says: Woof!");
    }
}

// Usage
public class AnimalDemo {
    public static void main(String[] args) {
        Dog dog = new Dog("Buddy", "Golden Retriever");
        dog.eat();    // Calls overridden method
        dog.sleep();  // Inherited from Animal
        dog.bark();   // Dog-specific method
    }
}
```

**Teaching points**:
- **extends keyword**: Create subclass
- **super**: Access parent class
- **@Override**: Indicate method override (compiler check)
- **protected**: Visible to subclasses
- **IS-A relationship**: Dog IS-A Animal

### Working with JSON

```java
// Using Gson library for JSON parsing
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;

// Data class
public class Person {
    private String name;
    private int age;
    private String email;

    // Constructor, getters, setters
    public Person(String name, int age, String email) {
        this.name = name;
        this.age = age;
        this.email = email;
    }

    // Getters
    public String getName() { return name; }
    public int getAge() { return age; }
    public String getEmail() { return email; }
}

// JSON parsing
public class JsonExample {
    public static void main(String[] args) throws IOException {
        Gson gson = new Gson();

        // Parse JSON file to object
        FileReader reader = new FileReader("person.json");
        Person person = gson.fromJson(reader, Person.class);

        // Parse JSON array
        FileReader arrayReader = new FileReader("people.json");
        List<Person> people = gson.fromJson(
            arrayReader,
            new TypeToken<List<Person>>(){}.getType()
        );

        // Convert object to JSON
        String json = gson.toJson(person);
        System.out.println(json);
    }
}
```

**Alternative: Using Jackson**:
```java
import com.fasterxml.jackson.databind.ObjectMapper;

public class JacksonExample {
    public static void main(String[] args) throws IOException {
        ObjectMapper mapper = new ObjectMapper();

        // Read JSON
        Person person = mapper.readValue(
            new File("person.json"),
            Person.class
        );

        // Write JSON
        mapper.writeValue(new File("output.json"), person);
    }
}
```

### Exception Handling

```java
public class ExceptionExample {
    public static void main(String[] args) {
        try {
            // Code that might throw exception
            int result = divide(10, 0);
            System.out.println("Result: " + result);
        } catch (ArithmeticException e) {
            System.err.println("Error: Division by zero");
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
        } finally {
            // Always executes (cleanup code)
            System.out.println("Cleanup complete");
        }
    }

    // Method that throws checked exception
    public static int readNumber(String fileName) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader(fileName));
        String line = reader.readLine();
        return Integer.parseInt(line);
    }

    public static int divide(int a, int b) {
        if (b == 0) {
            throw new ArithmeticException("Cannot divide by zero");
        }
        return a / b;
    }
}
```

**Teaching points**:
- **try-catch-finally**: Handle exceptions gracefully
- **Checked vs unchecked**: IOException (checked) vs RuntimeException (unchecked)
- **throws**: Declare that method may throw exception
- **throw**: Explicitly throw exception
- **Multiple catch blocks**: Handle different exception types

## Module 3: Advanced OOP and Collections

### Interfaces and Polymorphism

```java
// Interface definition
public interface PaymentMethod {
    boolean processPayment(double amount);
    String getPaymentType();
}

// Implementations
public class CreditCard implements PaymentMethod {
    private String cardNumber;

    public CreditCard(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    @Override
    public boolean processPayment(double amount) {
        System.out.println("Processing $" + amount + " via credit card");
        return true;
    }

    @Override
    public String getPaymentType() {
        return "Credit Card";
    }
}

public class PayPal implements PaymentMethod {
    private String email;

    public PayPal(String email) {
        this.email = email;
    }

    @Override
    public boolean processPayment(double amount) {
        System.out.println("Processing $" + amount + " via PayPal");
        return true;
    }

    @Override
    public String getPaymentType() {
        return "PayPal";
    }
}

// Polymorphism in action
public class PaymentProcessor {
    public void processPayments(List<PaymentMethod> payments, double amount) {
        for (PaymentMethod payment : payments) {
            System.out.println("Using: " + payment.getPaymentType());
            payment.processPayment(amount);
        }
    }

    public static void main(String[] args) {
        List<PaymentMethod> methods = List.of(
            new CreditCard("1234-5678-9012-3456"),
            new PayPal("user@example.com")
        );

        PaymentProcessor processor = new PaymentProcessor();
        processor.processPayments(methods, 99.99);
    }
}
```

**Teaching points**:
- **Interface**: Contract defining behavior
- **implements**: Class fulfills interface contract
- **Polymorphism**: Treat different types uniformly
- **Program to interface**: Flexible, extensible design

### Collections Framework

```java
import java.util.*;

public class CollectionsExample {
    public static void main(String[] args) {
        // List - ordered, allows duplicates
        List<String> names = new ArrayList<>();
        names.add("Alice");
        names.add("Bob");
        names.add("Alice");  // Duplicate allowed

        // Set - no duplicates
        Set<String> uniqueNames = new HashSet<>(names);
        System.out.println(uniqueNames);  // [Alice, Bob]

        // Map - key-value pairs
        Map<String, Integer> ages = new HashMap<>();
        ages.put("Alice", 30);
        ages.put("Bob", 25);
        ages.put("Charlie", 35);

        // Iterate map
        for (Map.Entry<String, Integer> entry : ages.entrySet()) {
            System.out.println(entry.getKey() + ": " + entry.getValue());
        }

        // Common operations
        List<Integer> numbers = Arrays.asList(5, 2, 8, 1, 9);
        Collections.sort(numbers);
        System.out.println("Sorted: " + numbers);
        System.out.println("Max: " + Collections.max(numbers));
    }
}
```

**Collections hierarchy**:
- **List**: ArrayList, LinkedList (ordered, indexed)
- **Set**: HashSet, TreeSet (unique elements)
- **Map**: HashMap, TreeMap (key-value)
- **Queue**: LinkedList, PriorityQueue (FIFO)

## Module 4: Software Engineering Practices

### Package Organization

```java
// File: src/com/example/banking/model/Account.java
package com.example.banking.model;

public class Account {
    // Class implementation
}

// File: src/com/example/banking/service/BankingService.java
package com.example.banking.service;

import com.example.banking.model.Account;

public class BankingService {
    public void processAccount(Account account) {
        // Use Account class from model package
    }
}
```

**Package conventions**:
- `com.company.project.module` format
- Group related classes
- `model` / `entity`: Data classes
- `service`: Business logic
- `util`: Helper classes
- `controller`: Web endpoints (web apps)

### JUnit Testing

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CalculatorTest {
    @Test
    public void testAddition() {
        Calculator calc = new Calculator();
        assertEquals(5, calc.add(2, 3));
    }

    @Test
    public void testDivisionByZero() {
        Calculator calc = new Calculator();
        assertThrows(ArithmeticException.class, () -> {
            calc.divide(10, 0);
        });
    }

    @Test
    public void testSubtraction() {
        Calculator calc = new Calculator();
        assertEquals(3, calc.subtract(5, 2));
        assertEquals(-3, calc.subtract(2, 5));
    }
}
```

### Build Tools

**Maven** (pom.xml):
```xml
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>myapp</artifactId>
    <version>1.0.0</version>

    <dependencies>
        <dependency>
            <groupId>com.google.code.gson</groupId>
            <artifactId>gson</artifactId>
            <version>2.10.1</version>
        </dependency>
    </dependencies>
</project>
```

**Gradle** (build.gradle):
```gradle
plugins {
    id 'java'
    id 'application'
}

dependencies {
    implementation 'com.google.code.gson:gson:2.10.1'
    testImplementation 'org.junit.jupiter:junit-jupiter:5.9.2'
}

application {
    mainClass = 'com.example.Main'
}
```

## Common Java Patterns for Curriculum

### Pattern: Command-Line Tool

```java
public class ToolTemplate {
    public static void main(String[] args) {
        // Parse arguments
        if (args.length == 0) {
            printUsage();
            System.exit(1);
        }

        try {
            // Execute main logic
            run(args);
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            System.exit(1);
        }
    }

    private static void run(String[] args) throws Exception {
        // Tool implementation
    }

    private static void printUsage() {
        System.out.println("Usage: java ToolTemplate <options>");
    }
}
```

### Pattern: Data Processing

```java
public class DataProcessor {
    public List<Record> loadData(String fileName) throws IOException {
        // Load from file
    }

    public List<Record> filterData(List<Record> data, Predicate<Record> filter) {
        return data.stream()
                   .filter(filter)
                   .collect(Collectors.toList());
    }

    public void saveData(List<Record> data, String fileName) throws IOException {
        // Save to file
    }
}
```

### Pattern: Builder for Complex Objects

```java
public class User {
    private final String name;
    private final String email;
    private final int age;
    private final String address;

    private User(Builder builder) {
        this.name = builder.name;
        this.email = builder.email;
        this.age = builder.age;
        this.address = builder.address;
    }

    public static class Builder {
        private String name;
        private String email;
        private int age;
        private String address;

        public Builder name(String name) {
            this.name = name;
            return this;
        }

        public Builder email(String email) {
            this.email = email;
            return this;
        }

        public Builder age(int age) {
            this.age = age;
            return this;
        }

        public Builder address(String address) {
            this.address = address;
            return this;
        }

        public User build() {
            return new User(this);
        }
    }
}

// Usage
User user = new User.Builder()
    .name("Alice")
    .email("alice@example.com")
    .age(30)
    .build();
```

## Teaching Tips for Java

### Start Simple, Add Complexity

**Lesson 1 approach**:
```java
// Start with this
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello!");
    }
}
```

Don't explain `public`, `static`, `void`, `String[]` on day one. Say: "This is the template every Java program needs. We'll learn what each word means as we go."

### Emphasize Type Thinking

Help learners think about types:
- "What kind of data is this? A number? Text? True/false?"
- "What type does this method return?"
- "What types does this method accept?"

### Use Real Error Messages

When code doesn't compile, use the actual error message:
```
error: cannot find symbol
  symbol:   variable nmae
  location: class Main
```

Teach: "Read the error. What is it telling you? Where is the problem?"

### Compile Often

Encourage frequent compilation:
- "Compile after every small change"
- "Don't write 50 lines before compiling"
- "The compiler is your friend - it catches mistakes early"

### Connect to OOP Concepts

Constantly connect code to OOP principles:
- "Notice how we made balance private? That's encapsulation."
- "See how Dog extends Animal? That's inheritance."
- "Look how we can pass any PaymentMethod? That's polymorphism."

## Common Pitfalls and How to Address

### Pitfall: Forgetting Semicolons

**Error**: `error: ';' expected`

**Teaching approach**: "Java requires semicolons at the end of statements. Think of it like a period at the end of a sentence."

### Pitfall: Using == for String Comparison

**Wrong**:
```java
if (name == "Alice") { ... }
```

**Right**:
```java
if (name.equals("Alice")) { ... }
```

**Teaching**: "== compares if two variables point to the same object in memory. .equals() compares the actual content. For strings, always use .equals()."

### Pitfall: Not Closing Resources

**Teaching try-with-resources early**:
```java
// Good - automatically closes
try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
    // Use reader
}
```

### Pitfall: NullPointerException

**Teaching defensive programming**:
```java
if (name != null && name.equals("Alice")) {
    // Safe
}
```

## Integration with Curriculum Modules

### Module 1 Focus
- Basic syntax, types, methods
- Command-line I/O
- File reading/writing
- Simple classes (data holders)

### Module 2 Focus
- Full OOP (encapsulation, classes, objects)
- Collections (List, Map, Set)
- JSON/CSV processing
- Exception handling
- Testing basics

### Module 3 Focus
- Inheritance and interfaces
- Polymorphism
- Design patterns (Factory, Strategy, Builder)
- Web applications (Servlets, Spring Boot basics)

### Module 4 Focus
- Package organization
- Maven/Gradle
- Comprehensive testing
- Logging frameworks
- Deployment (JAR packaging)

## Resources for Learners

### Official Documentation
- Oracle Java Tutorials: https://docs.oracle.com/javase/tutorial/
- Java API Documentation: https://docs.oracle.com/en/java/javase/17/docs/api/

### Development Tools
- **IDEs**: IntelliJ IDEA (Community), Eclipse, VS Code with Java extensions
- **JDK**: Install OpenJDK 17 or 21 (LTS versions)
- **Build tools**: Maven, Gradle

### Best Practices
- Follow Java naming conventions
- Write self-documenting code (good variable names)
- Use meaningful method names
- Keep methods short and focused
- Comment complex logic, not obvious code
- Use interfaces for abstraction
- Favor composition over inheritance
- Write tests for critical logic

## When to Use This Skill

Use this Java language skill when:
- Learner has selected Java as their learning language
- Providing Java-specific code examples
- Teaching OOP concepts (Java's strength)
- Answering Java syntax questions
- Debugging Java-specific errors
- Recommending Java libraries and tools
- Setting up Java development environment
- Creating Java project structures

Always adapt examples to learner's current module and skill level. Use simpler patterns in Module 1, introduce OOP gradually in Module 2, and showcase advanced patterns in Modules 3-4.
