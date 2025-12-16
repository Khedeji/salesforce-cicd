/**
* @File Name : AcceptFormData.cls
* @Description : Accepts API Callouts & create Opportunity Records
* @Author : Ritik Raghuwanshi
* @Last Modified By : Ritik
* @Last Modified On : July 25, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | July 25, 2025 |   | Initial Version
**/

//https://brave-hawk-6yrll5-dev-ed.trailblaze.my.salesforce-sites.com/services/apexrest/Form/Data/
@RestResource(urlMapping='/Form/Data/*')
global without sharing class AcceptFormData {
    
    // Method: POST
    // Content-Type: application/json
    // reqBody: {"first_name":"Loan","last_name":"Analysis Green","mailto:email":"yash.navik@mindruby.com","mobile":"9427779484","pay_frequency":"WEEKLY","loan_reason":"Insurance","amount":300,"opp_fields" : {"Opportunity_Origin__c": "QuickCash","DNB_Scoring_Rate__c": "","Current_Balance__c": 0,"Applicant_Type__c": "Existing Client-Granted Loan Before","Opp_number__C": "1026772","Multiple_Lenders_Hardship__c": 47.21,"income_as_a_of_DP200_income__c": 0,"Deposit_spent_on_DOD__c": 34.1,"DP_Monthly_avg_of_SACC_repayments__c": 1455,"Monthly_ongoing_financial_commitments__c": 2005.3034,"DP_Primary_income_frequency__c": 1,"DP_Primary_income_last_pay_date__c": "28/07/2020","DP_enders_with_uncleared_dishonours_233__c": 0,"Primary_regular_benefit_frequency__c": 0,"Last_pay_date_for_largest_inc_src_302__c": "28/07/2020","Largest_income_source_day_of_week__c": 2,"Next_pay_date_for_largest_income_source__c": "04/08/2020","Frequency_for_largest_income_source__c": 1,"Primary_regular_benefit_last_pay_date__c": "","loan_dishonours__c": 0,"Primary_regular_benefit_monthly_amount__c": 0,"Courts_and_Fines_transactions__c": 0,"Total_monthly_income_ongoin_Reg_231__c": 7416.4855,"DP_Total_Monthly_Benefit_Income__c": 0,"DP_Dishonours_Across_Primary_Acct_244__c": 0,"DP_No_Direct_Debits_On_Primary_Acct_355__c": 36,"DP_Budget_Management_Services__c": 0,"Hardship_Indicator_Gambling__c": 21.44,"DP_Monthly_rent_amount_236__c": 0,"Amount_of_SACC_commitments_due__c": 810.3869,"Largest_income_Src_Avg_freq__c": 1473.8769,"Largest_income_Src_last_payment_amt__c": 1001.72,"Deposits_since_last_SACC_dishonour__c": 13,"SACC_commitments_due_next_month__c": 16.71,"Total_monthly_credits__c": 10742,"agency_collection_providers__c": 0,"Collection_agency_transactions__c": 0,"Average_monthly_amount_of_Courts_and_Fin__c": 0,"Courts_and_Fines_providers__c": 0,"income_DP200_spend_on_high_risk_merch__c": 12.78,"most_recent_loan_has_no_repayments__c": 0,"Deposits_since_last_dishonour__c": 13,"Income_source_is_other_income_549__c": 0,"Bank_Report_Gov_Benefit__c": 0,"Income_source_is_a_government_benefit__c": "","Summary_Income__c": 3466.67,"Summary_Expenses__c": 599,"Rent_Mortgage__c": 300,"Summary_Total__c": 2567.67,"Loan_Amount__c": 2000,"Total_Repayment_Amount__c": 2640    }
    // Success response: {"opportunity_url": "https://brave-hawk-6yrll5-dev-ed.trailblaze.my.salesforce.com/0062w00000OqZC7AAN","time_stamp": "2023-11-01T06:23:19.378Z","success": true}
    @HttpPost
    global static void doPost() {

        RestRequest requestData = RestContext.request;
        RestResponse responseData = RestContext.response;

        Map<String,Object> sendDataMap = new Map<String,Object>();
        sendDataMap.put('success',true);
        responseData.statusCode = 200;
        responseData.addHeader('Content-Type','application/json');

        try {
            
            String requestBody = requestData.requestBody.toString(); 
            Object untypedJson = JSON.deserializeUntyped(requestBody);       
            Map<String,Object> requestBodyMap = (Map<String,Object>) untypedJson;
            
            Account accInfo = new Account();
            accInfo.Name = (String)requestBodyMap.get('first_name') + ' ' + (String)requestBodyMap.get('last_name');
            insert accInfo;
            
            Contact conInfo = new Contact();
            conInfo.AccountId = accInfo.Id;
            conInfo.FirstName = (String)requestBodyMap.get('first_name');
            conInfo.LastName = (String)requestBodyMap.get('last_name');
            conInfo.Email = (String)requestBodyMap.get('email');
            conInfo.Phone = String.valueOf(requestBodyMap.get('mobile'));
            conInfo.MobilePhone = String.valueOf(requestBodyMap.get('mobile'));
            insert conInfo;

            Opportunity oppInfo = new Opportunity();
            oppInfo.ContactId = conInfo.Id;
            oppInfo.Contact__c = conInfo.Id;
            oppInfo.AccountID = accInfo.Id;
            oppInfo.Type = 'Existing Customer - Upgrade';
            oppInfo.StageName = 'Loan Application Submitted';
            
            oppInfo.Pay_frequency__c = (String)requestBodyMap.get('pay_frequency');
            oppInfo.Reason_for_your_loan__c = (String)requestBodyMap.get('loan_reason');
            oppInfo.Amount = (Decimal)requestBodyMap.get('amount');
            oppInfo.CloseDate = Date.Today().addDays(5);
            oppInfo.Name = (String)requestBodyMap.get('first_name')+' '+(String)requestBodyMap.get('last_name');

            Map<String, String> fieldTypeMap = HelperClass.getObjFieldTypes('Opportunity');
            
            if (requestBodyMap.containsKey('opp_fields')) {
                Map<String, Object> oppFields = (Map<String,Object>) requestBodyMap.get('opp_fields');
                for (String key : oppFields.keySet()) {
                    String apiKey = key.toLowerCase();

                    if (oppFields.get(key) == null || oppFields.get(key) == '') {
                        oppInfo.put(apiKey, null);
                        continue;
                    }

                    if (fieldTypeMap.containsKey(apiKey)) {
                        switch on fieldTypeMap.get(apiKey) {
                            when 'DATE'{
                                List<String> dt = String.valueOf(oppFields.get(key)).split('/');
                                oppInfo.put(apiKey, Date.valueOf(dt[2]+'-'+dt[1]+'-'+dt[0]));
                            }
                            when 'CURRENCY', 'PERCENT', 'DOUBLE'{
                                Decimal field = (Decimal) oppFields.get(key);
                                oppInfo.put(apiKey, field.setScale(2));
                            }
                            when 'INTEGER' {
                                System.debug('this is AP Key '+ apiKey);
                                oppInfo.put(apiKey, Integer.valueOf(oppFields.get(key)));
                            }
                            when 'STRING' {
                                oppInfo.put(apiKey, String.valueOf(oppFields.get(key)));
                            }
                            when 'BOOLEAN' {
                                oppInfo.put(apiKey, Integer.valueOf(oppFields.get(key)) == 1 ? true : false);
                            }
                            when else {
                                oppInfo.put(apiKey, oppFields.get(key));
                            }
                        }
                    }
                }
            }
            
            insert oppInfo;

            sendDataMap.put('time_stamp',DateTime.now());
            String url = Url.getOrgDomainUrl().toExternalForm() + '/' + oppInfo.Id;
            sendDataMap.put('opportunity_url',url);
            responseData.responseBody = Blob.valueOf(JSON.serializePretty(sendDataMap));

        } catch (Exception ex) {
            responseData.statusCode = 500;
            responseData.responseBody = Blob.valueOf(JSON.serializePretty(ex.getMessage()) + ex.getStackTraceString());
        }
    }
}