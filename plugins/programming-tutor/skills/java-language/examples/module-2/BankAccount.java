/**
 * Module 2: Object-Oriented Programming Fundamentals
 * Example: BankAccount class demonstrating encapsulation
 */
public class BankAccount {
    // Private fields - encapsulation
    private String accountNumber;
    private String ownerName;
    private double balance;

    // Constructor
    public BankAccount(String accountNumber, String ownerName, double initialBalance) {
        this.accountNumber = accountNumber;
        this.ownerName = ownerName;

        // Validation in constructor
        if (initialBalance < 0) {
            throw new IllegalArgumentException("Initial balance cannot be negative");
        }
        this.balance = initialBalance;
    }

    // Deposit method
    public void deposit(double amount) {
        if (amount <= 0) {
            System.err.println("Error: Deposit amount must be positive");
            return;
        }

        balance += amount;
        System.out.println("Deposited: $" + String.format("%.2f", amount));
        System.out.println("New balance: $" + String.format("%.2f", balance));
    }

    // Withdraw method
    public boolean withdraw(double amount) {
        if (amount <= 0) {
            System.err.println("Error: Withdrawal amount must be positive");
            return false;
        }

        if (amount > balance) {
            System.err.println("Error: Insufficient funds");
            System.out.println("Current balance: $" + String.format("%.2f", balance));
            return false;
        }

        balance -= amount;
        System.out.println("Withdrew: $" + String.format("%.2f", amount));
        System.out.println("New balance: $" + String.format("%.2f", balance));
        return true;
    }

    // Transfer to another account
    public boolean transferTo(BankAccount recipient, double amount) {
        if (this.withdraw(amount)) {
            recipient.deposit(amount);
            System.out.println("Transfer successful to account " + recipient.getAccountNumber());
            return true;
        }
        return false;
    }

    // Getters (no setters for security)
    public String getAccountNumber() {
        return accountNumber;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public double getBalance() {
        return balance;
    }

    // Display account info
    public void displayInfo() {
        System.out.println("\n=== Account Information ===");
        System.out.println("Account Number: " + accountNumber);
        System.out.println("Owner: " + ownerName);
        System.out.println("Balance: $" + String.format("%.2f", balance));
        System.out.println("===========================\n");
    }

    // Main method for testing
    public static void main(String[] args) {
        // Create accounts
        BankAccount account1 = new BankAccount("12345", "Alice Johnson", 1000.00);
        BankAccount account2 = new BankAccount("67890", "Bob Smith", 500.00);

        // Display initial state
        account1.displayInfo();
        account2.displayInfo();

        // Perform operations
        account1.deposit(250.00);
        account1.withdraw(100.00);

        // Transfer money
        account1.transferTo(account2, 150.00);

        // Display final state
        account1.displayInfo();
        account2.displayInfo();

        // Try invalid operations
        account1.withdraw(2000.00);  // Insufficient funds
        account1.deposit(-50.00);     // Invalid amount
    }
}

/*
 * CONCEPTS DEMONSTRATED:
 *
 * 1. ENCAPSULATION
 *    - Private fields (accountNumber, balance, ownerName)
 *    - Public methods for controlled access
 *    - No direct access to internal state
 *
 * 2. CONSTRUCTORS
 *    - Initialize object state
 *    - Validation of initial values
 *    - this keyword to distinguish fields from parameters
 *
 * 3. METHODS
 *    - Instance methods operate on object state
 *    - Return values indicate success/failure
 *    - Side effects (printing, modifying state)
 *
 * 4. VALIDATION
 *    - Check parameters before use
 *    - Maintain invariants (balance can't go negative)
 *    - Provide meaningful error messages
 *
 * 5. OBJECT INTERACTION
 *    - transferTo() method shows objects working together
 *    - Method takes another object as parameter
 *
 * DISCUSSION QUESTIONS:
 * - Why are fields private? What would happen if they were public?
 * - Why don't we have setBalance()? Is that a good design choice?
 * - What's the purpose of the return value in withdraw()?
 * - How does transferTo() demonstrate object collaboration?
 *
 * ENHANCEMENT IDEAS:
 * 1. Add transaction history (List<Transaction>)
 * 2. Add account types (Checking, Savings) with different rules
 * 3. Add interest calculation for savings accounts
 * 4. Add overdraft protection
 * 5. Add monthly fee deduction
 * 6. Save/load account data to/from file
 */
