import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Module 1, Lesson 2: File Reader
 * Mini-Project: Display statistics about a text file
 */
public class FileStats {
    public static void main(String[] args) {
        if (args.length == 0) {
            System.err.println("Usage: java FileStats <filename>");
            System.exit(1);
        }

        String fileName = args[0];
        displayFileStats(fileName);
    }

    public static void displayFileStats(String fileName) {
        int lineCount = 0;
        int wordCount = 0;
        int charCount = 0;
        int longestLineLength = 0;

        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lineCount++;
                charCount += line.length();

                // Count words (split by whitespace)
                String[] words = line.trim().split("\\s+");
                if (!line.trim().isEmpty()) {
                    wordCount += words.length;
                }

                // Track longest line
                if (line.length() > longestLineLength) {
                    longestLineLength = line.length();
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading file: " + e.getMessage());
            System.exit(1);
        }

        // Calculate average line length
        double avgLineLength = lineCount > 0 ? (double) charCount / lineCount : 0;

        // Display results
        System.out.println("File: " + fileName);
        System.out.println("Lines: " + lineCount);
        System.out.println("Words: " + wordCount);
        System.out.println("Characters: " + charCount);
        System.out.printf("Avg line length: %.1f characters%n", avgLineLength);
        System.out.println("Longest line: " + longestLineLength + " characters");
    }
}

/*
 * USAGE EXAMPLE:
 *
 * $ javac FileStats.java
 * $ java FileStats example.txt
 * File: example.txt
 * Lines: 42
 * Words: 327
 * Characters: 1893
 * Avg line length: 45.1 characters
 * Longest line: 89 characters
 *
 * CONCEPTS DEMONSTRATED:
 * - Multiple accumulators (lineCount, wordCount, etc.)
 * - String manipulation (split, trim)
 * - Regular expressions (\\s+ for whitespace)
 * - Finding maximum value
 * - Calculating averages
 * - Formatted output (printf)
 * - Reading files line-by-line
 *
 * CHALLENGES FOR LEARNERS:
 * 1. Add word frequency analysis (most common words)
 * 2. Add character frequency (letter distribution)
 * 3. Support multiple files and compare them
 * 4. Add filters (e.g., count only lines containing certain text)
 */
