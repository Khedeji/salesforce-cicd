public class AddPrimaryContact implements Queueable {
    private Contact contactTemplate;
    private String stateAbbreviation;

    // ✅ Constructor accepting a Contact and a State abbreviation
    public AddPrimaryContact(Contact contact, String stateAbbr) {
        this.contactTemplate = contact;
        this.stateAbbreviation = stateAbbr;
    }

    // ✅ Execute method to insert contacts for accounts in the specified state
    public void execute(QueueableContext context) {
        // Query up to 200 Accounts with the specified BillingState
        List<Account> accounts = [SELECT Id FROM Account WHERE BillingState = :stateAbbreviation LIMIT 200];

        List<Contact> contactsToInsert = new List<Contact>();
        for (Account acc : accounts) {
            // Clone the contact template and associate it with the current Account
            Contact newContact = contactTemplate.clone(false, false, false, false);
            newContact.AccountId = acc.Id;
            contactsToInsert.add(newContact);
        }

        // Bulk insert all contacts
        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
}