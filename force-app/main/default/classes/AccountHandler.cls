public class AccountHandler {
    
    // Public static method to insert a new Account
    public static Account insertNewAccount(String accountName) {
        try {
            // Create a new Account instance
            Account newAcc = new Account(Name = accountName);
            
            // Insert the Account
            insert newAcc;
            
            // Return the Account record if successful
            return newAcc;
        } catch (DmlException e) {
            // Catch any DML exceptions and return null
            return null;
        }
    }
}