public with sharing class complianceLogik {
    public complianceLogik() {

    }

    @AuraEnabled
    public static String analyse(String LeadId){
        try{
            System.debug('LeadId : ' + LeadId);
            Map<String, Object> rootMap = new Map<String, Object>();        
            Lead LeadObj = [
                SELECT Id, Status,  Residence_status__c, KYC_Status__c, Debt_to_income_ratio__c, Requested_payslips__c, Credit_Score__c, Product_Disclosure_Statements__c, Key_Facts_Sheets_Highlighted__c, Interest_Rate_Calculations__c, Unconscionable_Conduct__c, Unfair_Contract_Terms__c FROM Lead WHERE Id =:LeadId LIMIT 1];
            List<Map<String, Object>> bodyList = new List<Map<String, Object>>();
            Map<String, Object> body = new Map<String, Object>(); 
            
            // START
            body.put('application_number', (LeadObj.Id == null)? '0' : String.valueOf(LeadObj.Id) );                                                                               // Id

            body.put('residence_status', (LeadObj.Residence_status__c == null)? '0' : String.valueOf(LeadObj.Residence_status__c) );                                            // Requested_Amount__c
            body.put('kyc_status', (LeadObj.KYC_Status__c == null)? '0' : String.valueOf(LeadObj.KYC_Status__c) );                                                              // KYC_Status__c
            body.put('debt_to_income_ratio', (LeadObj.Debt_to_income_ratio__c == null)? '0' : String.valueOf(LeadObj.Debt_to_income_ratio__c) );                                // Debt_to_income_ratio__c
            body.put('requested_payslips', (LeadObj.Requested_payslips__c == null)? '0' : String.valueOf(LeadObj.Requested_payslips__c) );                                      // Requested_payslips__c
            body.put('credit_score', (LeadObj.Credit_Score__c == null)? '0' : String.valueOf(LeadObj.Credit_Score__c) );                                                        // Credit_Score__c
            
            body.put('product_disclosure_statements', (LeadObj.Product_Disclosure_Statements__c == null)? '0' : String.valueOf(LeadObj.Product_Disclosure_Statements__c) );     // Product_Disclosure_Statements__c
            body.put('key_facts_sheets_highlighted', (LeadObj.Key_Facts_Sheets_Highlighted__c == null)? '0' : String.valueOf(LeadObj.Key_Facts_Sheets_Highlighted__c) );        // Key_Facts_Sheets_Highlighted__c
            body.put('interest_rate_calculations', (LeadObj.Interest_Rate_Calculations__c == null)? '0' : String.valueOf(LeadObj.Interest_Rate_Calculations__c) );              // Interest_Rate_Calculations__c
            body.put('unconscionable_conduct', (LeadObj.Unconscionable_Conduct__c == null)? '0' : String.valueOf(LeadObj.Unconscionable_Conduct__c) );                          // Unconscionable_Conduct__c
            body.put('Unfair_Contract_Terms', (LeadObj.Unfair_Contract_Terms__c == null)? '0' : String.valueOf(LeadObj.Unfair_Contract_Terms__c) );                             // Unfair_Contract_Terms__c
            body.put('CreditReportDuration', 2);                             // Unfair_Contract_Terms__c
            
            
            
            //END
            
            // bodyList.add(body);             
            rootMap.put('body', body);       
            System.debug('Body List Obj Map :'+bodyList);
            String requestBodyString = JSON.serialize(rootMap);
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://111.118.247.45:5002/api/request-compliance-rules');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-api-key', 'VALUE'); 
            req.setBody(requestBodyString);
            System.debug('Requestbody---'+ requestBodyString);
            Http h = new Http();
            HttpResponse res = h.send(req);
            System.debug('Response---'+ res.getBody());
            // Assuming res is an instance of HttpResponse
            // String responseBody = res.getBody();

            // Deserialize the JSON string to a Map<String, Object>
            // Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

            // Now, resultMap holds the JSON data as a Map
            


            system.debug('After Calling other func');


            return res.getBody();
        }
        catch(exception e){
            System.debug(e.getMessage());
            return null;
        }
        
    }
}