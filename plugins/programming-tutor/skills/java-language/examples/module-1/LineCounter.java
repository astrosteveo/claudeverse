import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Module 1, Lesson 2: File Reader
 * Example: Count lines in a text file
 */
public class LineCounter {
    public static void main(String[] args) {
        if (args.length == 0) {
            System.err.println("Error: Please provide a filename");
            System.out.println("Usage: java LineCounter <filename>");
            System.exit(1);
        }

        String fileName = args[0];
        int lineCount = countLines(fileName);

        if (lineCount >= 0) {
            System.out.println(fileName + " has " + lineCount + " lines");
        }
    }

    /**
     * Count the number of lines in a file
     * @param fileName The file to count
     * @return Number of lines, or -1 if error
     */
    public static int countLines(String fileName) {
        int count = 0;

        // Try-with-resources: automatically closes the reader
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            while (reader.readLine() != null) {
                count++;
            }
        } catch (IOException e) {
            System.err.println("Error: File '" + fileName + "' not found");
            return -1;
        }

        return count;
    }
}

/*
 * USAGE EXAMPLES:
 *
 * $ javac LineCounter.java
 * $ java LineCounter myfile.txt
 * myfile.txt has 42 lines
 *
 * $ java LineCounter nonexistent.txt
 * Error: File 'nonexistent.txt' not found
 *
 * CONCEPTS DEMONSTRATED:
 * - File I/O with BufferedReader
 * - Try-with-resources (automatic resource management)
 * - Exception handling (IOException)
 * - Method extraction (countLines)
 * - Return values vs side effects
 * - Error handling patterns
 *
 * TEACHING POINTS:
 * - Why BufferedReader? More efficient than reading character by character
 * - Why try-with-resources? Ensures file is closed even if exception occurs
 * - Why separate method? Separation of concerns, testability
 */
