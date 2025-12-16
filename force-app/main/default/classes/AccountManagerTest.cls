@isTest
private class AccountManagerTest {

    @isTest
    static void testGetAccount() {
        // Create a test Account
        Account testAcc = new Account(Name='Test Account');
        insert testAcc;

        // Create test Contacts associated with the Account
        Contact testContact1 = new Contact(FirstName='John', LastName='Doe', AccountId=testAcc.Id);
        Contact testContact2 = new Contact(FirstName='Jane', LastName='Smith', AccountId=testAcc.Id);
        insert new List<Contact>{testContact1, testContact2};

        // Set up the Mock REST Request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Accounts/' + testAcc.Id + '/contacts';
        RestContext.request = req;
        RestContext.response = res;

        // Call the REST method
        Account result = AccountManager.getAccount();

        // Assertions to validate the response
        System.assertNotEquals(null, result, 'Account should not be null');
        System.assertEquals(testAcc.Id, result.Id, 'Account ID should match');
        System.assertEquals(testAcc.Name, result.Name, 'Account Name should match');
        System.assertEquals(2, result.Contacts.size(), 'Should return 2 contacts');

    }


}