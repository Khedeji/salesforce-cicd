/**
 * Created by : Ritik Raghwanshi
 * Updated on : 16/10/2024
 * Updated by : Ritik Raghwanshi
 * Updated on : 16/10/2024
 * Desc : This function calls the borrower Qualification Logik Api created in Flask.
 */

public with sharing class borrowerQualificationLogik {
    public borrowerQualificationLogik() {
        
    }
    @AuraEnabled
    public static String analyse(String LeadId){
        try{
            Map<String, Object> rootMap = new Map<String, Object>();        
            Lead LeadObj = [SELECT ABN_Registered_Date__c, Applicant_Entity_Type__c, Asset_Manufacture_Year__c, Asset_Supplier_Type__c, Asset_Type__c, Ballon_Amount__c, Deposit_Amount__c, GST_Registered_Date__c,  Guarantor_1_Residential_Status__c, Id, Name,  Primary__c, ProductInterest__c, Rating, Repayment_Term__c, Requested_Amount__c, State, Status, Street, Title, Used_Asset__c FROM Lead WHERE Id =:LeadId LIMIT 1];
            List<Map<String, Object>> bodyList = new List<Map<String, Object>>();
            Map<String, Object> body = new Map<String, Object>(); 
            
            // START
            body.put('application_number', (LeadObj.Id == null)? '0' : String.valueOf(LeadObj.Id) );                                                                                            // Id
            body.put('Name', (LeadObj.Name == null)? '0' : String.valueOf(LeadObj.Name) );                                                                                      // Name
            body.put('amount_financed', (LeadObj.Requested_Amount__c == null)? '0' : String.valueOf(LeadObj.Requested_Amount__c) );                                         // Requested_Amount__c
            body.put('deposit_amount', (LeadObj.Deposit_Amount__c == null)? '0' : String.valueOf(LeadObj.Deposit_Amount__c) );                                               // Deposit_Amount__c
            body.put('balloon_amount', (LeadObj.Ballon_Amount__c == null)? '0' : String.valueOf(LeadObj.Ballon_Amount__c) );                                                  // Ballon_Amount__c
            body.put('repayment_term_month', (LeadObj.Repayment_Term__c == null)? '0' : String.valueOf(LeadObj.Repayment_Term__c) );                                               // Repayment_Term__c
            body.put('applicant_entity_type', (LeadObj.Applicant_Entity_Type__c == null)? '0' : String.valueOf(LeadObj.Applicant_Entity_Type__c) );                          // Applicant_Entity_Type__c
            body.put('asset_supplier_type', (LeadObj.Asset_Supplier_Type__c == null)? '0' : String.valueOf(LeadObj.Asset_Supplier_Type__c) );                                // Asset_Supplier_Type__c
            body.put('asset_type', (LeadObj.Asset_Type__c == null)? '0' : String.valueOf(LeadObj.Asset_Type__c) );                                                           // Asset_Type__c
            body.put('asset_manufacture_year', (LeadObj.Asset_Manufacture_Year__c == null)? '0' : String.valueOf(LeadObj.Asset_Manufacture_Year__c) );                       // Asset_Manufacture_Year__c
            body.put('usage_type', (LeadObj.Used_Asset__c == null)? '0' : String.valueOf(LeadObj.Used_Asset__c) );                                                           // Used_Asset__c
            body.put('gst_registered_date', (LeadObj.GST_Registered_Date__c == null)? '0' : String.valueOf(LeadObj.GST_Registered_Date__c) );                                // GST_Registered_Date__c
            body.put('abn_registered_date', (LeadObj.ABN_Registered_Date__c == null)? '0' : String.valueOf(LeadObj.ABN_Registered_Date__c) );                                // ABN_Registered_Date__c
            body.put('guarantor_1_residential_status', (LeadObj.Guarantor_1_Residential_Status__c == null)? '0' : String.valueOf(LeadObj.Guarantor_1_Residential_Status__c) );// Guarantor_1_Residential_Status__c
            
            body.put('Primary__c', (LeadObj.Primary__c == null)? '0' : String.valueOf(LeadObj.Primary__c) );                                                                     // Primary__c
            body.put('ProductInterest__c', (LeadObj.ProductInterest__c == null)? '0' : String.valueOf(LeadObj.ProductInterest__c) );                                             // ProductInterest__c
            body.put('Rating', (LeadObj.Rating == null)? '0' : String.valueOf(LeadObj.Rating) );                                                                                 // Rating
            body.put('State', (LeadObj.State == null)? '0' : String.valueOf(LeadObj.State) );                                                                                   // State
            body.put('Status', (LeadObj.Status == null)? '0' : String.valueOf(LeadObj.Status) );                                                                                // Status
            body.put('Street', (LeadObj.Street == null)? '0' : String.valueOf(LeadObj.Street) );                                                                                // Street
            body.put('Title', (LeadObj.Title == null)? '0' : String.valueOf(LeadObj.Title) );                                                                                   // Title
            //END
            
            // bodyList.add(body);             
            rootMap.put('body', body);    
            System.debug('Checking for deploy vikas Khede:');   
            System.debug('Body List Obj Map :'+bodyList);
            String requestBodyString = JSON.serialize(rootMap);
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://111.118.247.45:5000/api/request-rules');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-api-key', 'VALUE'); 
            req.setBody(requestBodyString);
            req.setTimeout(60000); 
            System.debug('Requestbody---'+ requestBodyString);
            Http h = new Http();
            HttpResponse res = h.send(req);
 
            System.debug('Response---'+ res.getBody());
            // Assuming res is an instance of HttpResponse
            String responseBody = res.getBody();
            

            // Deserialize the JSON string to a Map<String, Object>
            Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

            for (String key : resultMap.keySet()) {
                for (String innerKey : ((Map<String, Object>)resultMap.get(key)).keySet()) {
                    // System.debug('Key: ' + innerKey + ', Value: ' + ((Map<String, Object>)resultMap.get(key)).get(innerKey));
                    System.debug('Key: ' + innerKey + ' ------>');
                    for(String innermostKey : ((Map<String, Object>)((Map<String, Object>)resultMap.get(key)).get(innerKey)).keySet()){
                        // System.debug('Key: ' + innermostKey + ', Value: ' + ((Map<String, Object>)((Map<String, Object>)resultMap.get(key)).get(innerKey)).get(innermostKey));
                        System.debug('Key: ' + innermostKey + ' ------>');
                        for(String innermostMostKey : ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)resultMap.get(key)).get(innerKey)).get(innermostKey)).keySet()){
                            System.debug('Key: ' + innermostMostKey + ', Value: ' + ((Map<String, Object>)((Map<String, Object>)((Map<String, Object>)resultMap.get(key)).get(innerKey)).get(innermostKey)).get(innermostMostKey));
                        }
                    }
                }
            }
            // Now, resultMap holds the JSON data as a Map


            LeadsLogikServices.LeadEligiblePlanMapperFunc(resultMap);

            system.debug('After Calling other func');


            return res.getBody();
        }
        catch(exception e){
            System.debug(e.getMessage());
            return null;
        }
        
    }
}