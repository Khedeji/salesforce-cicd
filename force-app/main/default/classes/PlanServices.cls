public with sharing class PlanServices {
    public PlanServices() {

    }

    public static Plans__c getPlanByName(String PlanName){

        PlanName= '%'+PlanName+'%';
        Plans__c PlanObj  = [SELECT Id, Name FROM Plans__c WHERE Name like :PlanName];
    
        return PlanObj;
    } 


    public static Map<String, Id> getPlanByPlanName() {
        // Query all Plan records from the Plans__c object, selecting the Id and Name fields
        List<Plans__c> PlanObj = [SELECT Id, Name FROM Plans__c];
    
        // Initialize a map to store Plan names as keys and their corresponding Ids as values
        Map<String, Id> PlanName = new Map<String, Id>();
        if (PlanObj.isEmpty()) {
            System.debug('No plans found.');
            return PlanName; // It will still return an empty map.
        }
        // Iterate over each Plan record returned by the query
        for (Plans__c LoopPlanObj : PlanObj) {
            // Add the plan's Name as the key and its Id as the value to the map
            PlanName.put(LoopPlanObj.Name, LoopPlanObj.Id);
        }
    
        // Return the map of Plan names and Ids
        return PlanName;
    }

}