@isTest
public class AddPrimaryContactTest {
    @isTest
    static void testAddPrimaryContact() {
        // ✅ Step 1: Insert 50 Accounts for NY and 50 for CA
        List<Account> accountsNY = new List<Account>();
        List<Account> accountsCA = new List<Account>();

        for (Integer i = 0; i < 50; i++) {
            accountsNY.add(new Account(Name = 'NY Account ' + i, BillingState = 'NY'));
            accountsCA.add(new Account(Name = 'CA Account ' + i, BillingState = 'CA'));
        }
        insert accountsNY;
        insert accountsCA;

        // ✅ Step 2: Create a Contact Template
        Contact sampleContact = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john.doe@example.com');

        // ✅ Step 3: Enqueue the Job for CA Accounts
        Test.startTest();
        System.enqueueJob(new AddPrimaryContact(sampleContact, 'CA'));
        Test.stopTest();

        // ✅ Step 4: Validate that Contacts were inserted for CA Accounts
        Integer contactCount = [SELECT COUNT() FROM Contact WHERE Email = 'john.doe@example.com'];
        System.assertEquals(50, contactCount, 'There should be 50 contacts created for CA accounts.');
    }
}