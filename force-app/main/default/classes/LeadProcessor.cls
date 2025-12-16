public class LeadProcessor implements Database.Batchable<sObject> {
     public Database.QueryLocator start(Database.BatchableContext bc){
         return Database.getQueryLocator(
            'SELECT ID, LEADSOURCE FROM LEAD'
        );
     }
     
     public void execute(Database.BatchableContext bc, List<Lead> scope){
        for (Lead l : scope) {
            l.LeadSource = 'Dreamforce';
        }
        update scope; // Bulk update
     }
     
     public void finish(Database.BatchableContext bc) {
        System.debug('Batch process completed successfully.');
    }

}