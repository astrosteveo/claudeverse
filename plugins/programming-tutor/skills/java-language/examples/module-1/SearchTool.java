import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

/**
 * Module 1, Lesson 3: Text Search Tool
 * Mini-Project: Search for text patterns in files (grep clone)
 */
public class SearchTool {
    public static void main(String[] args) {
        if (args.length < 2) {
            printUsage();
            System.exit(1);
        }

        String searchTerm = args[0];
        String fileName = args[1];
        boolean ignoreCase = false;
        boolean countOnly = false;

        // Parse optional flags
        for (int i = 2; i < args.length; i++) {
            if (args[i].equals("--ignore-case") || args[i].equals("-i")) {
                ignoreCase = true;
            } else if (args[i].equals("--count") || args[i].equals("-c")) {
                countOnly = true;
            }
        }

        searchFile(searchTerm, fileName, ignoreCase, countOnly);
    }

    public static void searchFile(String searchTerm, String fileName,
                                   boolean ignoreCase, boolean countOnly) {
        int matchCount = 0;
        int lineNumber = 0;

        String searchTermToUse = ignoreCase ? searchTerm.toLowerCase() : searchTerm;

        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                String lineToSearch = ignoreCase ? line.toLowerCase() : line;

                if (lineToSearch.contains(searchTermToUse)) {
                    matchCount++;
                    if (!countOnly) {
                        System.out.println("Line " + lineNumber + ": " + line);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading file: " + e.getMessage());
            System.exit(1);
        }

        // Always print match count at the end
        System.out.println("Found " + matchCount + " matches");
    }

    private static void printUsage() {
        System.out.println("Usage: java SearchTool <search-term> <filename> [options]");
        System.out.println("Options:");
        System.out.println("  --ignore-case, -i    Case-insensitive search");
        System.out.println("  --count, -c          Only display count, not matches");
    }
}

/*
 * USAGE EXAMPLES:
 *
 * $ javac SearchTool.java
 * $ java SearchTool "error" logfile.txt
 * Line 12: ERROR: Connection failed
 * Line 45: ERROR: Timeout occurred
 * Found 2 matches
 *
 * $ java SearchTool "error" logfile.txt --ignore-case
 * Line 12: ERROR: Connection failed
 * Line 23: Error in processing
 * Line 45: ERROR: Timeout occurred
 * Found 3 matches
 *
 * $ java SearchTool "error" logfile.txt --count
 * Found 2 matches
 *
 * CONCEPTS DEMONSTRATED:
 * - Command-line flag parsing
 * - Boolean flags for behavior control
 * - Case-insensitive string comparison
 * - Line number tracking
 * - Conditional output
 * - String contains() method
 * - toLowerCase() for normalization
 *
 * BONUS CHALLENGES:
 * 1. Add --line-number flag to toggle line numbers
 * 2. Add --context N to show N lines before/after match
 * 3. Add regex support (Pattern.compile)
 * 4. Support searching multiple files
 * 5. Add --invert to show non-matching lines
 * 6. Color-code matches (ANSI escape codes)
 */
