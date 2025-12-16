/**
* @File Name : FlynxloanAnalysis.cls
* @Description :
* @Author :Rishabh Ranjan
* @Last Modified By :Ritik Raghwanshi
* @Last Modified On : January 27, 2025
* @Modification Log : This function calls the Flynx Api created in Flask.
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | January 27, 2025 |   | Initial Version
**/

public class FlynxloanAnalysis {
    public FlynxloanAnalysis() {

    }
    @AuraEnabled
    public static String analyse(String oppId){
        try{
            Map<String, Object> rootMap = new Map<String, Object>();        
            
            Opportunity opp = [select Id, AccountId, Account.Number_Of_Loans_Granted__c, Account.NUmber_Of_Loans_Paid__c, Contact__r.Id,Contact__r.MailingCity,Contact__r.MailingState,Contact__r.MailingCountry,StageName ,Opportunity_Origin__c,Current_Balance__c,Applicant_Type__c,Opp_Number__c,Multiple_Lenders_Hardship__c,income_as_a_of_DP200_income__c,Deposit_spent_on_DOD__c,DP_Monthly_avg_of_SACC_repayments__c,Monthly_ongoing_financial_commitments__c,DP_Primary_income_frequency__c,DP_Primary_income_last_pay_date__c,DP_enders_with_uncleared_dishonours_233__c ,Primary_regular_benefit_frequency__c,Last_pay_date_for_largest_inc_src_302__c,Largest_income_source_day_of_week__c,Next_pay_date_for_largest_income_source__c,Frequency_for_largest_income_source__c,Primary_regular_benefit_last_pay_date__c,loan_dishonours__c,Primary_regular_benefit_monthly_amount__c,Courts_and_Fines_transactions__c,Total_monthly_income_ongoin_Reg_231__c,DP_Total_Monthly_Benefit_Income__c,DP_Dishonours_Across_Primary_Acct_244__c,DP_No_Direct_Debits_On_Primary_Acct_355__c,DP_Budget_Management_Services__c,Hardship_Indicator_Gambling__c,Amount_of_SACC_commitments_due__c,Largest_income_Src_Avg_freq__c,Largest_income_Src_last_payment_amt__c,Deposits_since_last_SACC_dishonour__c,SACC_commitments_due_next_month__c,Total_monthly_credits__c,agency_collection_providers__c,Collection_agency_transactions__c,Average_monthly_amount_of_Courts_and_Fin__c,Courts_and_Fines_providers__c,income_DP200_spend_on_high_risk_merch__c,most_recent_loan_has_no_repayments__c,Deposits_since_last_dishonour__c,Income_source_is_other_income_549__c,Bank_Report_Gov_Benefit__c,Income_source_is_a_government_benefit__c,Summary_Income__c,Summary_Expenses__c,Rent_Mortgage__c,Summary_Total__c,Loan_Amount__c,Total_Repayment_Amount__c,Purpose_of_Loan__c,Total_Repayments__c,Amount,Payment_Frequency__c,Summary_Income_CV__c,CloseDate,Amount_Requested__c, Dishonours_203__c, DP_Days_in_Overdrawn_For_Period__c,Dishonours_For_Last_30_Days_DP907__c,Salary_Gov_Allowances_all_types_2117__c,CreatedDate From Opportunity WHERE Id =:oppId LIMIT 1];
            List<Map<String, Object>> bodyList = new List<Map<String, Object>>();
            Map<String, Object> body = new Map<String, Object>(); 
            
            //START
            body.put('Id', (opp.Id == null)? '0' : String.valueOf(opp.Id) );
            body.put('Account.Id', (opp.Account.Id == null)? '0' : String.valueOf(opp.Account.Id) );
            body.put('Account.Number_Of_Loans_Granted__c', (opp.Account.Number_Of_Loans_Granted__c == null)? '0' : String.valueOf(opp.Account.Number_Of_Loans_Granted__c) );
            body.put('Account.NUmber_Of_Loans_Paid__c', (opp.Account.NUmber_Of_Loans_Paid__c == null)? '0' : String.valueOf(opp.Account.NUmber_Of_Loans_Paid__c) );
            body.put('Contact__r.Id', (opp.Contact__r.Id == null)? '0' : String.valueOf(opp.Contact__r.Id) );
            body.put('Contact__r.MailingCity', (opp.Contact__r.MailingCity == null)? '0' : String.valueOf(opp.Contact__r.MailingCity) );
            body.put('Contact__r.MailingState', (opp.Contact__r.MailingState == null)? '0' : String.valueOf(opp.Contact__r.MailingState) );
            body.put('Contact__r.MailingCountry', (opp.Contact__r.MailingCountry == null)? '0' : String.valueOf(opp.Contact__r.MailingCountry) );
            body.put('StageName', (opp.StageName == null)? '0' : String.valueOf(opp.StageName) );
            body.put('Opportunity_Origin__c', (opp.Opportunity_Origin__c == null)? '0' : String.valueOf(opp.Opportunity_Origin__c) );
            body.put('Current_Balance__c', (opp.Current_Balance__c == null)? '0' : String.valueOf(opp.Current_Balance__c) );
            body.put('Applicant_Type__c', (opp.Applicant_Type__c == null)? '0' : String.valueOf(opp.Applicant_Type__c) );
            body.put('Opp_Number__c', (opp.Opp_Number__c == null)? '0' : String.valueOf(opp.Opp_Number__c) );
            body.put('Multiple_Lenders_Hardship__c', (opp.Multiple_Lenders_Hardship__c == null)? '0' : String.valueOf(opp.Multiple_Lenders_Hardship__c) );
            body.put('income_as_a_of_DP200_income__c', (opp.income_as_a_of_DP200_income__c == null)? '0' : String.valueOf(opp.income_as_a_of_DP200_income__c) );
            body.put('Deposit_spent_on_DOD__c', (opp.Deposit_spent_on_DOD__c == null)? '0' : String.valueOf(opp.Deposit_spent_on_DOD__c) );
            body.put('DP_Monthly_avg_of_SACC_repayments__c', (opp.DP_Monthly_avg_of_SACC_repayments__c == null)? '0' : String.valueOf(opp.DP_Monthly_avg_of_SACC_repayments__c) );
            body.put('Monthly_ongoing_financial_commitments__c', (opp.Monthly_ongoing_financial_commitments__c == null)? '0' : String.valueOf(opp.Monthly_ongoing_financial_commitments__c) );
            body.put('DP_Primary_income_frequency__c', (opp.DP_Primary_income_frequency__c == null)? '0' : String.valueOf(opp.DP_Primary_income_frequency__c) );
            body.put('DP_Primary_income_last_pay_date__c', (opp.DP_Primary_income_last_pay_date__c == null)? '0' : String.valueOf(opp.DP_Primary_income_last_pay_date__c) );
            body.put('DP_enders_with_uncleared_dishonours_233__c', (opp.DP_enders_with_uncleared_dishonours_233__c == null)? '0' : String.valueOf(opp.DP_enders_with_uncleared_dishonours_233__c) );
            body.put('Primary_regular_benefit_frequency__c', (opp.Primary_regular_benefit_frequency__c == null)? '0' : String.valueOf(opp.Primary_regular_benefit_frequency__c) );
            body.put('Last_pay_date_for_largest_inc_src_302__c', (opp.Last_pay_date_for_largest_inc_src_302__c == null)? '0' : String.valueOf(opp.Last_pay_date_for_largest_inc_src_302__c) );
            body.put('Largest_income_source_day_of_week__c', (opp.Largest_income_source_day_of_week__c == null)? '0' : String.valueOf(opp.Largest_income_source_day_of_week__c) );
            body.put('Next_pay_date_for_largest_income_source__c', (opp.Next_pay_date_for_largest_income_source__c == null)? '0' : String.valueOf(opp.Next_pay_date_for_largest_income_source__c) );
            body.put('Frequency_for_largest_income_source__c', (opp.Frequency_for_largest_income_source__c == null)? '0' : String.valueOf(opp.Frequency_for_largest_income_source__c) );
            body.put('Primary_regular_benefit_last_pay_date__c', (opp.Primary_regular_benefit_last_pay_date__c == null)? '0' : String.valueOf(opp.Primary_regular_benefit_last_pay_date__c) );
            body.put('loan_dishonours__c', (opp.loan_dishonours__c == null)? '0' : String.valueOf(opp.loan_dishonours__c) );
            body.put('Primary_regular_benefit_monthly_amount__c', (opp.Primary_regular_benefit_monthly_amount__c == null)? '0' : String.valueOf(opp.Primary_regular_benefit_monthly_amount__c) );
            body.put('Courts_and_Fines_transactions__c', (opp.Courts_and_Fines_transactions__c == null)? '0' : String.valueOf(opp.Courts_and_Fines_transactions__c) );
            body.put('Total_monthly_income_ongoin_Reg_231__c', (opp.Total_monthly_income_ongoin_Reg_231__c == null)? '0' : String.valueOf(opp.Total_monthly_income_ongoin_Reg_231__c) );
            body.put('DP_Total_Monthly_Benefit_Income__c', (opp.DP_Total_Monthly_Benefit_Income__c == null)? '0' : String.valueOf(opp.DP_Total_Monthly_Benefit_Income__c) );
            body.put('DP_Dishonours_Across_Primary_Acct_244__c', (opp.DP_Dishonours_Across_Primary_Acct_244__c == null)? '0' : String.valueOf(opp.DP_Dishonours_Across_Primary_Acct_244__c) );
            body.put('DP_No_Direct_Debits_On_Primary_Acct_355__c', (opp.DP_No_Direct_Debits_On_Primary_Acct_355__c == null)? '0' : String.valueOf(opp.DP_No_Direct_Debits_On_Primary_Acct_355__c) );
            body.put('DP_Budget_Management_Services__c', (opp.DP_Budget_Management_Services__c == null)? '0' : String.valueOf(opp.DP_Budget_Management_Services__c) );
            body.put('Hardship_Indicator_Gambling__c', (opp.Hardship_Indicator_Gambling__c == null)? '0' : String.valueOf(opp.Hardship_Indicator_Gambling__c) );
            body.put('Amount_of_SACC_commitments_due__c', (opp.Amount_of_SACC_commitments_due__c == null)? '0' : String.valueOf(opp.Amount_of_SACC_commitments_due__c) );
            body.put('Largest_income_Src_Avg_freq__c', (opp.Largest_income_Src_Avg_freq__c == null)? '0' : String.valueOf(opp.Largest_income_Src_Avg_freq__c) );
            body.put('Largest_income_Src_last_payment_amt__c', (opp.Largest_income_Src_last_payment_amt__c == null)? '0' : String.valueOf(opp.Largest_income_Src_last_payment_amt__c) );
            body.put('Deposits_since_last_SACC_dishonour__c', (opp.Deposits_since_last_SACC_dishonour__c == null)? '0' : String.valueOf(opp.Deposits_since_last_SACC_dishonour__c) );
            body.put('SACC_commitments_due_next_month__c', (opp.SACC_commitments_due_next_month__c == null)? '0' : String.valueOf(opp.SACC_commitments_due_next_month__c) );
            body.put('Total_monthly_credits__c', (opp.Total_monthly_credits__c == null)? '0' : String.valueOf(opp.Total_monthly_credits__c) );
            body.put('agency_collection_providers__c', (opp.agency_collection_providers__c == null)? '0' : String.valueOf(opp.agency_collection_providers__c) );
            body.put('Collection_agency_transactions__c', (opp.Collection_agency_transactions__c == null)? '0' : String.valueOf(opp.Collection_agency_transactions__c) );
            body.put('Average_monthly_amount_of_Courts_and_Fin__c', (opp.Average_monthly_amount_of_Courts_and_Fin__c == null)? '0' : String.valueOf(opp.Average_monthly_amount_of_Courts_and_Fin__c) );
            body.put('Courts_and_Fines_providers__c', (opp.Courts_and_Fines_providers__c == null)? '0' : String.valueOf(opp.Courts_and_Fines_providers__c) );
            body.put('income_DP200_spend_on_high_risk_merch__c', (opp.income_DP200_spend_on_high_risk_merch__c == null)? '0' : String.valueOf(opp.income_DP200_spend_on_high_risk_merch__c) );
            body.put('most_recent_loan_has_no_repayments__c', (opp.most_recent_loan_has_no_repayments__c == null)? '0' : String.valueOf(opp.most_recent_loan_has_no_repayments__c) );
            body.put('Deposits_since_last_dishonour__c', (opp.Deposits_since_last_dishonour__c == null)? '0' : String.valueOf(opp.Deposits_since_last_dishonour__c) );
            body.put('Income_source_is_other_income_549__c', (opp.Income_source_is_other_income_549__c == null)? '0' : String.valueOf(opp.Income_source_is_other_income_549__c) );
            body.put('Bank_Report_Gov_Benefit__c', (opp.Bank_Report_Gov_Benefit__c == null)? '0' : String.valueOf(opp.Bank_Report_Gov_Benefit__c) );
            body.put('Income_source_is_a_government_benefit__c', (opp.Income_source_is_a_government_benefit__c == null)? '0' : String.valueOf(opp.Income_source_is_a_government_benefit__c) );
            body.put('Summary_Income__c', (opp.Summary_Income__c == null)? '0' : String.valueOf(opp.Summary_Income__c) );
            body.put('Summary_Expenses__c', (opp.Summary_Expenses__c == null)? '0' : String.valueOf(opp.Summary_Expenses__c) );
            body.put('Rent_Mortgage__c', (opp.Rent_Mortgage__c == null)? '0' : String.valueOf(opp.Rent_Mortgage__c) );
            body.put('Summary_Total__c', (opp.Summary_Total__c == null)? '0' : String.valueOf(opp.Summary_Total__c) );
            body.put('Loan_Amount__c', (opp.Loan_Amount__c == null)? '0' : String.valueOf(opp.Loan_Amount__c) );
            body.put('Total_Repayment_Amount__c', (opp.Total_Repayment_Amount__c == null)? '0' : String.valueOf(opp.Total_Repayment_Amount__c) );
            body.put('Purpose_of_Loan__c', (opp.Purpose_of_Loan__c == null)? '0' : String.valueOf(opp.Purpose_of_Loan__c) );
            body.put('Total_Repayments__c', (opp.Total_Repayments__c == null)? '0' : String.valueOf(opp.Total_Repayments__c) );
            body.put('Amount', (opp.Amount == null)? '0' : String.valueOf(opp.Amount) );
            // body.put('Term_in_Weeks__c', (opp.Term_in_Weeks__c == null)? '0' : String.valueOf(opp.Term_in_Weeks__c) );
            body.put('Payment_Frequency__c', (opp.Payment_Frequency__c == null)? '0' : String.valueOf(opp.Payment_Frequency__c) );
            // body.put('Applicant_Age__c', (opp.Applicant_Age__c == null)? '0' : String.valueOf(opp.Applicant_Age__c) );
            body.put('Summary_Income_CV__c', (opp.Summary_Income_CV__c == null)? '0' : String.valueOf(opp.Summary_Income_CV__c) );
            body.put('CloseDate', (opp.CloseDate == null)? '0' : String.valueOf(opp.CloseDate) );
            body.put('Amount_Requested__c', (opp.Amount_Requested__c == null)? '0' : String.valueOf(opp.Amount_Requested__c) );
            // body.put('Employment_Status__c', (opp.Employment_Status__c == null)? '0' : String.valueOf(opp.Employment_Status__c) );
            body.put('Dishonours_203__c', (opp.Dishonours_203__c == null)? '0' : String.valueOf(opp.Dishonours_203__c) );
            // body.put('DP_Insolvency_Indicator__c', (opp.DP_Insolvency_Indicator__c == null)? '0' : String.valueOf(opp.DP_Insolvency_Indicator__c) );
            body.put('DP_Days_in_Overdrawn_For_Period__c', (opp.DP_Days_in_Overdrawn_For_Period__c == null)? '0' : String.valueOf(opp.DP_Days_in_Overdrawn_For_Period__c) );
            body.put('Dishonours_For_Last_30_Days_DP907__c', (opp.Dishonours_For_Last_30_Days_DP907__c == null)? '0' : String.valueOf(opp.Dishonours_For_Last_30_Days_DP907__c) );
            body.put('Salary_Gov_Allowances_all_types_2117__c', (opp.Salary_Gov_Allowances_all_types_2117__c == null)? '0' : String.valueOf(opp.Salary_Gov_Allowances_all_types_2117__c) );
            body.put('Loan_apply_date', (opp.CreatedDate == null)? '0' : String.valueOf(opp.CreatedDate) );
            //END
            
            bodyList.add(body);             
            rootMap.put('body', bodyList);       
            rootMap.put('evaluate','Binary_Class');
            
            String requestBodyString = JSON.serialize(rootMap);
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint('http://111.118.247.45:5001/api/QueryAnalysis');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-api-key', 'VALUE');
            req.setBody(requestBodyString);
            System.debug('Requestbody---'+ requestBodyString);
            Http h = new Http();
            HttpResponse res = h.send(req);
            System.debug('Response---'+ res.getBody());

            return res.getBody();
        }
        catch(exception e){
            System.debug(e.getMessage());
            return null;
        }
        
    }
}