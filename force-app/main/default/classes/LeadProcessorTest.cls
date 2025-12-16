@isTest
public class LeadProcessorTest {
    @isTest
    static void testLeadProcessor() {
        // ✅ Step 1: Insert 200 test Lead records
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            testLeads.add(new Lead(LastName = 'TestLead' + i, Company = 'TestCompany', LeadSource = 'Web'));
        }
        insert testLeads;

        // ✅ Step 2: Execute the Batch Job
        Test.startTest();
            LeadProcessor batchJob = new LeadProcessor();
            Database.executeBatch(batchJob, 200); // Batch size 50
        Test.stopTest();

        // ✅ Step 3: Verify that all Leads were updated
        List<Lead> updatedLeads = [SELECT LeadSource FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, updatedLeads.size(), 'All leads should have LeadSource updated to Dreamforce');
    }
}