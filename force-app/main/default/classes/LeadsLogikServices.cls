public with sharing class LeadsLogikServices {
    public LeadsLogikServices() {

    }

    /***
        Ritik Raghuwanshi - 18/10/2024
        Method of creating the Logik_Leads__c records by extracting the Lead and Plans ID Present In the SF System 
    **/
    @AuraEnabled
    public static List<Map<String, String>> GetLeadsLogikFunc(String LeadId) {

        borrowerQualificationLogik.analyse(LeadId);

        List<Map<String, String>> LeadsLogikCustom = new List<Map<String, String>>();
        // Extracting the Logik_Leads__c
        List<Logik_Leads__c> LeadsLogik = [SELECT Id,Name, Lead_Logik__c, Plans_Eligible__c, Document_URL__c, Logs_of_Eligibility__c  from Logik_Leads__c WHERE Lead_Logik__c = :LeadId];
        system.debug('1LeadsLogik --->'+LeadsLogik);
        Map<Id, Logik_Leads__c> LeadsLogikMapper =  new Map<Id, Logik_Leads__c>(LeadsLogik);
        // Getting Plan Names
        List<Id> EligiblePlans = new List<Id>();
        for (Logik_Leads__c LLC : LeadsLogik){
            Map<String, String> TempMap = new Map<String, String>();
            TempMap.put('Id',LLC.Id);
            TempMap.put('Name',LLC.Name);
            TempMap.put('Lead_Logik__c',LLC.Lead_Logik__c);
            TempMap.put('Plans_Eligible__c',LLC.Plans_Eligible__c);
            TempMap.put('Logs_of_Eligibility__c',LLC.Logs_of_Eligibility__c);
            TempMap.put('Document_URL__c',LLC.Document_URL__c);
            
            LeadsLogikCustom.add(TempMap);
            EligiblePlans.add(LLC.Plans_Eligible__c);
        }
        system.debug('1EligiblePlans --->'+EligiblePlans);
        system.debug('1LeadsLogikCustom --->'+LeadsLogikCustom);

        List<Plans__c> PlansObjList = [SELECT Id, Name, Lender_Plans__c FROM Plans__c WHERE Id in :EligiblePlans];
        Map<Id, Plans__c> PlansObjMapper =  new Map<Id, Plans__c>(PlansObjList);
        system.debug('PlansObjMapper --->'+PlansObjMapper);
        system.debug('PlansObjList --->'+PlansObjList);
        
        // Getting Lenders Name per Plan
        List<Id> EligibleLenders = new List<Id>();
        for (Plans__c POL : PlansObjList){
            EligibleLenders.add(POL.Lender_Plans__c);
        }
        system.debug('EligibleLenders --->'+EligibleLenders);
        List<Lenders__c> LendersObjList = [SELECT Id, Name FROM Lenders__c WHERE Id in :EligibleLenders];
        Map<Id, Lenders__c> LenderssObjMapper =  new Map<Id, Lenders__c>(LendersObjList);
        system.debug('PlansObjMapper --->'+PlansObjMapper);
        system.debug('LenderssObjMapper --->'+LenderssObjMapper);
        for (Map<String, String> LLC : LeadsLogikCustom){
            LLC.put('Eligible_Plan',PlansObjMapper.get(LLC.get('Plans_Eligible__c')).Name);
            LLC.put('Eligible_Lender',LenderssObjMapper.get(PlansObjMapper.get(LLC.get('Plans_Eligible__c')).Lender_Plans__c).Name);
        }
        system.debug('LeadsLogikCustom --->'+LeadsLogikCustom);
        return LeadsLogikCustom;
    }

    /***
        Ritik Raghuwanshi - 17/10/2024
        Method of creating the Logik_Leads__c records by extracting the Lead and Plans ID Present In the SF System 
    **/
    
    public static List<Logik_Leads__c> LeadEligiblePlanMapperFunc(Map<String, Object> LeadPlanMap) {
        // Initialize a map to store Lead information, including plan and rule evaluation results
        Map<String, Map<String, Map<String, String>>> LeadPlan = new Map<String, Map<String, Map<String, String>>>();

        // Iterate over each Lead in LeadPlanMap
        for (String LeadKey : LeadPlanMap.keySet()) {
            // Retrieve the lead value and deserialize it into a Map
            Object value = LeadPlanMap.get(LeadKey);
            Map<String, Object> LeadInfo = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(LeadPlanMap.get(LeadKey)));

            // Initialize a map to store plans and their rule evaluation results
            Map<String, Map<String, String>> PlanSetting = new Map<String, Map<String, String>>();
            
            // Iterate through Lender information for the current Lead
            for (String FirstInnerKey : LeadInfo.keySet()) {
                Map<String, Object> LenderInfo = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(LeadInfo.get(FirstInnerKey)));

                // Iterate through plans for the current Lender
                for (String SecondInnerKey : LenderInfo.keySet()) {
                    Map<String, Object> PlanInfo = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(LenderInfo.get(SecondInnerKey)));
                    // System.debug('Secound Inner Key '+PlanInfo);
                    // If the plan evaluation result is true, process the plan
                    if (Boolean.valueOf(PlanInfo.get('Evaluation_result'))) {
                        // Initialize a map to store rule evaluation results for the plan
                        Map<String, String> Rule_Evaluation_result = new Map<String, String>();

                        // Iterate through the plan details and store key-value pairs (except 'Evaluation_result')
                        for (String ThirdInnerKey : PlanInfo.keySet()) {
                            if (ThirdInnerKey != 'Evaluation_result') {
                                Rule_Evaluation_result.put(ThirdInnerKey, JSON.serialize(PlanInfo.get(ThirdInnerKey)));
                            }
                        }
                        // Store the rule evaluation results for the plan in PlanSetting
                        PlanSetting.put(SecondInnerKey, Rule_Evaluation_result);
                    }
                }
            }
            // Store the plan settings for the Lead in LeadPlan
            LeadPlan.put(LeadKey, PlanSetting);
        }

        // Retrieve a map of Plan names and their corresponding Ids
        Map<String, Id> PlansNameAndId = PlanServices.getPlanByPlanName();

        // Iterate over each Lead in LeadPlan to map the plan name to Plan Id
        for (String LeadID : LeadPlan.keySet()) {
            Map<String, Map<String, String>> LeadMapper = new Map<String, Map<String, String>>();
            
            // Iterate through plans of the current Lead
            for (String PlanName : LeadPlan.get(LeadID).keySet()) {
                String SplittedPlanName = PlanName; // Retain original plan name without splitting

                // Iterate over all record plan names and match with plan name from LeadPlan
                for (String RecordPlanName : PlansNameAndId.keySet()) {
                    System.debug('The Plan Name: ' + PlanName + ' The Record Plan Name: ' + RecordPlanName);
                    
                    // If the plan names match, map the Plan Id with the lead's eligible plan information
                    if (SplittedPlanName == RecordPlanName) {
                        LeadMapper.put(PlansNameAndId.get(RecordPlanName), LeadPlan.get(LeadID).get(PlanName));
                        System.debug('They Are Equal: ' + PlanName);
                    }
                }
            }
            // Update LeadPlan with the mapped plans
            LeadPlan.put(LeadID, LeadMapper);
        }
        // Deleting Existing  Logik_Leads__c if exists for the above Lead Object.
        List<String> LeadsRelationForDelete = new List<String>(LeadPlan.keySet());
        Logik_Leads__c[] DeleteLogikLeads = [SELECT Id FROM Logik_Leads__c WHERE Lead_Logik__c IN :LeadsRelationForDelete]; 
        // System.debug('DeleteLogikLeads'+DeleteLogikLeads);
        delete DeleteLogikLeads;
         

        // System.debug('Lead Plan -> '+LeadPlan);


        // Create a list to store Logik Leads records
        List<Logik_Leads__c> LogikLeadsObjsList = new List<Logik_Leads__c>();
        
        // Iterate over each Lead and create Logik Leads records
        for (String LeadID : LeadPlan.keySet()) {
            System.debug('Lead Id -> '+LeadID);
            for (String PlanId : LeadPlan.get(LeadID).keySet()) {
                // Create a new Logik Leads record for each eligible plan
                Logik_Leads__c Logik_LeadsObj = new Logik_Leads__c();
                Logik_LeadsObj.Name = PlanId + ' L_L ' + LeadID;
                Logik_LeadsObj.Lead_Logik__c = LeadID;
                Logik_LeadsObj.Plans_Eligible__c = PlanId;
                Logik_LeadsObj.Logs_of_Eligibility__c = String.valueOf(LeadPlan.get(LeadID).get(PlanId));
                LogikLeadsObjsList.add(Logik_LeadsObj);
            }
        }

        System.debug('LogikLeadsObjsList : '+LogikLeadsObjsList);
        // Insert the newly created Logik Leads records
        insert LogikLeadsObjsList;
        
        // System.debug('Logik Leads: ' + LogikLeadsObjsList);
        // System.debug('Lead Plan: ' + LeadPlan);

        // Return a dummy string (e.g., 'Ritik') after the process is completed
        return LogikLeadsObjsList; 
}
    
}