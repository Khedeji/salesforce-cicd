public class ContactSearch {
    
    // Public static method to search for Contacts
    public static List<Contact> searchForContacts(String lastName, String postalCode) {
        // Query Contacts that match the last name and mailing postal code
        List<Contact> contacts = [
            SELECT Id, Name
            FROM Contact
            WHERE LastName = :lastName
            AND MailingPostalCode = :postalCode
        ];
        
        // Return the list of Contacts
        return contacts;
    }
}