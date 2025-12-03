/**
 * Module 1, Lesson 1: Hello CLI
 * Example: Command-line greeter with optional formal flag
 */
public class Greeter {
    public static void main(String[] args) {
        // Check if name argument provided
        if (args.length == 0) {
            System.err.println("Error: Please provide a name");
            System.out.println("Usage: java Greeter <name> [--formal]");
            System.exit(1);
        }

        String name = args[0];

        // Check for optional --formal flag
        boolean isFormal = args.length > 1 && args[1].equals("--formal");

        if (isFormal) {
            System.out.println("Good day, " + name + ". Welcome to programming.");
        } else {
            System.out.println("Hello, " + name + "! Welcome to programming.");
        }
    }
}

/*
 * USAGE EXAMPLES:
 *
 * $ javac Greeter.java
 * $ java Greeter Alice
 * Hello, Alice! Welcome to programming.
 *
 * $ java Greeter Bob --formal
 * Good day, Bob. Welcome to programming.
 *
 * $ java Greeter
 * Error: Please provide a name
 * Usage: java Greeter <name> [--formal]
 *
 * CONCEPTS DEMONSTRATED:
 * - Command-line arguments (args array)
 * - Conditional logic (if-else)
 * - String comparison with .equals()
 * - Array length checking
 * - System.out vs System.err
 * - String concatenation
 */
