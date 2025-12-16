public with sharing class LeadServices {
    public LeadServices() {

    }
    /***
        Ritik Raghuwanshi - 17/10/2024
        Method of LeadServices used to Query the Opportunity Lead Object using ID! 
    **/
    public static Lead getLeadById(Id LeadId){
        return [SELECT Id, Name FROM Lead WHERE Id = :LeadId];
    }

    public static Map<Id, Lead> getLeadById(Set<Id> LeadIdSet) {
        if (LeadIdSet == null || LeadIdSet.isEmpty()) {
            return new Map<Id, Lead>();
        }
        try {
            // Query the Lead records for the provided IDs
            List<Lead> LeadObjList = [SELECT Id, Name FROM Lead WHERE Id in :LeadIdSet];
            return new Map<Id, Lead>(LeadObjList);
        } catch (Exception e) {
            // Handle the exception, e.g., log the error and return an empty map
            System.debug('Error querying Leads: ' + e.getMessage());
            return new Map<Id, Lead>();
        }
    }
    
}