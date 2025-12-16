public class AccountProcessor {
    
    @future(callout = true)
    public static void countContacts(List<ID> accountIds){
        
        // Map to store Account ID -> Contact Count
        Map<Id, Integer> contactCounts = new Map<Id, Integer>();

        // Query to count contacts for each Account
        for (AggregateResult result : [
            SELECT AccountId, COUNT(Id) contactCount
            FROM Contact 
            WHERE AccountId IN :accountIds 
            GROUP BY AccountId
        ]) {
            contactCounts.put((Id) result.get('AccountId'), (Integer) result.get('contactCount'));
        }

        // List to store Accounts to update
        List<Account> accountsToUpdate = new List<Account>();

        // Fetch Accounts and update the "noc" field
        for (Account acc : [SELECT Id, Number_Of_Contacts__C FROM Account WHERE Id IN :accountIds]) {
            if (contactCounts.containsKey(acc.Id)) {
                acc.Number_Of_Contacts__C = contactCounts.get(acc.Id);  // Set the count
                accountsToUpdate.add(acc);
            }
        }
        // Perform update if there are changes
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

}