@isTest
public class DailyLeadProcessorTest {

    @isTest
    public static void testDailyLeadProcessor() {
        
        // Insert 200 Lead records with blank LeadSource
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(FirstName = 'Test', LastName = 'Lead' + i, Company = 'Test Company', LeadSource = null));
        }
        insert leads;
        
        // Verify initial LeadSource is NULL
        List<Lead> insertedLeads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = NULL];
        System.assertEquals(200, insertedLeads.size(), '200 leads should be inserted with a NULL LeadSource');
        
        // Schedule the job
        String cronExpression = '0 0 0 1 1 ?'; // This runs the job at midnight every day
        DailyLeadProcessor leadProcessor = new DailyLeadProcessor();
        System.schedule('DailyLeadProcessorJob', cronExpression, leadProcessor);
        
        // Wait for the job to finish and execute
        Test.startTest();
        // The job will run within this test context
        Test.stopTest();

        // Verify that all Lead records were updated with LeadSource 'Dreamforce'
        List<Lead> updatedLeads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, updatedLeads.size(), 'All 200 leads should have their LeadSource updated to Dreamforce');
    }
}