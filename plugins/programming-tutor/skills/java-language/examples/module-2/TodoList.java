import java.io.*;
import java.util.*;

/**
 * Module 2: Working with Collections and File Persistence
 * Example: Todo list CLI application
 */
public class TodoList {
    // Inner class to represent a Todo item
    public static class TodoItem {
        private static int nextId = 1;

        private int id;
        private String text;
        private boolean completed;

        public TodoItem(String text) {
            this.id = nextId++;
            this.text = text;
            this.completed = false;
        }

        // Constructor for loading from file
        public TodoItem(int id, String text, boolean completed) {
            this.id = id;
            this.text = text;
            this.completed = completed;

            // Update nextId to avoid collisions
            if (id >= nextId) {
                nextId = id + 1;
            }
        }

        public int getId() {
            return id;
        }

        public String getText() {
            return text;
        }

        public boolean isCompleted() {
            return completed;
        }

        public void setCompleted(boolean completed) {
            this.completed = completed;
        }

        @Override
        public String toString() {
            String checkbox = completed ? "[x]" : "[ ]";
            return id + ". " + checkbox + " " + text;
        }

        // Format for file storage
        public String toFileFormat() {
            return id + "|" + text + "|" + completed;
        }

        // Parse from file format
        public static TodoItem fromFileFormat(String line) {
            String[] parts = line.split("\\|");
            int id = Integer.parseInt(parts[0]);
            String text = parts[1];
            boolean completed = Boolean.parseBoolean(parts[2]);
            return new TodoItem(id, text, completed);
        }
    }

    private List<TodoItem> todos;
    private String fileName;

    public TodoList(String fileName) {
        this.fileName = fileName;
        this.todos = new ArrayList<>();
        loadFromFile();
    }

    // Add a new todo
    public void add(String text) {
        TodoItem item = new TodoItem(text);
        todos.add(item);
        saveToFile();
        System.out.println("Added: " + text + " (ID: " + item.getId() + ")");
    }

    // List all todos
    public void list() {
        if (todos.isEmpty()) {
            System.out.println("No todos yet!");
            return;
        }

        System.out.println("\n=== Todo List ===");
        for (TodoItem item : todos) {
            System.out.println(item);
        }
        System.out.println("=================\n");
    }

    // Complete a todo
    public void complete(int id) {
        TodoItem item = findById(id);
        if (item == null) {
            System.err.println("Error: Todo with ID " + id + " not found");
            return;
        }

        item.setCompleted(true);
        saveToFile();
        System.out.println("Completed: " + item.getText());
    }

    // Delete a todo
    public void delete(int id) {
        TodoItem item = findById(id);
        if (item == null) {
            System.err.println("Error: Todo with ID " + id + " not found");
            return;
        }

        todos.remove(item);
        saveToFile();
        System.out.println("Deleted: " + item.getText());
    }

    // Find todo by ID
    private TodoItem findById(int id) {
        for (TodoItem item : todos) {
            if (item.getId() == id) {
                return item;
            }
        }
        return null;
    }

    // Save todos to file
    private void saveToFile() {
        try (PrintWriter writer = new PrintWriter(new FileWriter(fileName))) {
            for (TodoItem item : todos) {
                writer.println(item.toFileFormat());
            }
        } catch (IOException e) {
            System.err.println("Error saving todos: " + e.getMessage());
        }
    }

    // Load todos from file
    private void loadFromFile() {
        File file = new File(fileName);
        if (!file.exists()) {
            return;  // No file yet, start fresh
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                TodoItem item = TodoItem.fromFileFormat(line);
                todos.add(item);
            }
        } catch (IOException e) {
            System.err.println("Error loading todos: " + e.getMessage());
        }
    }

    // Main method - CLI interface
    public static void main(String[] args) {
        if (args.length == 0) {
            printUsage();
            System.exit(1);
        }

        TodoList todoList = new TodoList("todos.txt");
        String command = args[0];

        switch (command) {
            case "add":
                if (args.length < 2) {
                    System.err.println("Error: Please provide todo text");
                    System.exit(1);
                }
                String text = String.join(" ", Arrays.copyOfRange(args, 1, args.length));
                todoList.add(text);
                break;

            case "list":
                todoList.list();
                break;

            case "complete":
                if (args.length < 2) {
                    System.err.println("Error: Please provide todo ID");
                    System.exit(1);
                }
                int completeId = Integer.parseInt(args[1]);
                todoList.complete(completeId);
                break;

            case "delete":
                if (args.length < 2) {
                    System.err.println("Error: Please provide todo ID");
                    System.exit(1);
                }
                int deleteId = Integer.parseInt(args[1]);
                todoList.delete(deleteId);
                break;

            default:
                System.err.println("Unknown command: " + command);
                printUsage();
                System.exit(1);
        }
    }

    private static void printUsage() {
        System.out.println("Usage: java TodoList <command> [arguments]");
        System.out.println("\nCommands:");
        System.out.println("  add <text>       Add a new todo");
        System.out.println("  list             List all todos");
        System.out.println("  complete <id>    Mark todo as complete");
        System.out.println("  delete <id>      Delete a todo");
    }
}

/*
 * USAGE EXAMPLES:
 *
 * $ javac TodoList.java
 * $ java TodoList add "Buy groceries"
 * Added: Buy groceries (ID: 1)
 *
 * $ java TodoList add "Write code"
 * Added: Write code (ID: 2)
 *
 * $ java TodoList list
 * === Todo List ===
 * 1. [ ] Buy groceries
 * 2. [ ] Write code
 * =================
 *
 * $ java TodoList complete 1
 * Completed: Buy groceries
 *
 * $ java TodoList list
 * === Todo List ===
 * 1. [x] Buy groceries
 * 2. [ ] Write code
 * =================
 *
 * $ java TodoList delete 1
 * Deleted: Buy groceries
 *
 * CONCEPTS DEMONSTRATED:
 *
 * 1. INNER CLASSES
 *    - TodoItem defined inside TodoList
 *    - Encapsulates todo data and behavior
 *
 * 2. COLLECTIONS
 *    - ArrayList to store todos
 *    - Iteration with for-each loop
 *    - Adding and removing items
 *
 * 3. FILE PERSISTENCE
 *    - Save state to file
 *    - Load state on startup
 *    - Custom file format (pipe-delimited)
 *
 * 4. ID MANAGEMENT
 *    - Auto-incrementing IDs
 *    - Static variable for next ID
 *    - Restore next ID when loading
 *
 * 5. ERROR HANDLING
 *    - Check for missing arguments
 *    - Handle file I/O errors
 *    - Validate IDs exist
 *
 * 6. STRING OPERATIONS
 *    - Join multiple arguments
 *    - Split for parsing
 *    - String formatting
 *
 * ENHANCEMENT IDEAS:
 * 1. Add priorities (High, Medium, Low)
 * 2. Add due dates
 * 3. Add categories/tags
 * 4. Add search functionality
 * 5. Use JSON instead of custom format
 * 6. Add undo functionality
 * 7. Add sorting (by priority, date, etc.)
 * 8. Add edit command to modify todo text
 */
