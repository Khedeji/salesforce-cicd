@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {
    
    // Method to get Account and its Contacts by Account ID
    @HttpGet
    global static Account getAccount() {
        // Get the Account ID from the URL
        RestRequest req = RestContext.request;
        String[] urlParts = req.requestURI.split('/');
        Integer size = urlParts.size();

        // Extract the last part of the URL (Account_ID)
        String accountId = (size > 2) ? urlParts[size - 2] : null;
        System.debug('Extracted Account ID: ' + accountId);

        // Query the Account with its Contacts
        Account accList = [
            SELECT ID, Name, 
                (SELECT ID, FirstName, LastName FROM Contacts) 
            FROM Account 
            WHERE ID = :accountId
        ];

     
        // Return the Account object (automatically serialized to JSON)
        return accList;
    }
}