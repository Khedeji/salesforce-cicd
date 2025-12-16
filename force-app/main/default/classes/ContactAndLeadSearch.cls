public class ContactAndLeadSearch {
    
    // Public static method to search for Contacts and Leads
    public static List<List<sObject>> searchContactsAndLeads(String name) {
        // Perform a SOSL search to find Contacts and Leads by first or last name
        List<List<sObject>> results = [FIND :name IN NAME FIELDS RETURNING 
            Contact (Id, FirstName, LastName), 
            Lead (Id, FirstName, LastName)
        ];
        
        // Return the list of lists of sObjects
        return results;
    }
}