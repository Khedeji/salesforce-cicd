/**
* @File Name : LoanAnalysisController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : September 12, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | September 12, 2025 |   | Initial Version
**/
 
public class LoanAnalysisController {
    @AuraEnabled
    public static String analyse(String oppId){
        try {
 
            //response: {"Input query": {"Amount_of_SACC_commitments_due__c": {"0": "0"},"Applicant_Type__c": {"0": 0},"DP_Dishonours_Across_Primary_Acct_244__c": {"0": "0"},"DP_Monthly_avg_of_SACC_repayments__c": {"0": "586"},"DP_No_Direct_Debits_On_Primary_Acct_355__c": {"0": "10"},"DP_Primary_income_frequency__c": {"0": "1"},"DP_enders_with_uncleared_dishonours_233__c": {"0": "0"},"Deposit_spent_on_DOD__c": {"0": "59.95"},"Frequency_for_largest_income_source__c": {"0": "1"},"Income_source_is_other_income_549__c": {"0": "1"},"Largest_income_Src_Avg_freq__c": {"0": "1099.3607"},"Largest_income_Src_last_payment_amt__c": {"0": "3030.69"},"Largest_income_source_day_of_week__c": {"0": "4"},"Loan_Amount__c": {"0": 42920},"Monthly_ongoing_financial_commitments__c": {"0": "1529.4908"},"Primary_regular_benefit_frequency__c": {"0": "0"},"Rent_Mortgage__c": {"0": "600"},"Summary_Expenses__c": {"0": "899"},"Summary_Income__c": {"0": "3519.64"},"Summary_Total__c": {"0": "2020.64"},"Total_Repayment_Amount__c": {"0": "4934.39"},"Total_monthly_income_ongoin_Reg_231__c": {"0": "5353.9583"},"agency_collection_providers__c": {"0": "0"},"income_DP200_spend_on_high_risk_merch__c": {"0": "0"},"income_as_a_of_DP200_income__c": {"0": "0"},"most_recent_loan_has_no_repayments__c": {"0": "0"}},"Predicted result": {"001AB": "Red"}}
 
            Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c, Discount_Per__c, Discounted_Amount__c, Discount_Percentage__c, Approval_Status__c, Created_Month_Smaller__c, Contact__c, Opportunity_Origin__c, DNB_Scoring_Rate__c, Current_Balance__c, Applicant_Type__c, Opp_number__c, Multiple_Lenders_Hardship__c, income_as_a_of_DP200_income__c, Deposit_spent_on_DOD__c, DP_Monthly_avg_of_SACC_repayments__c, Monthly_ongoing_financial_commitments__c, DP_Primary_income_frequency__c, DP_Primary_income_last_pay_date__c, DP_enders_with_uncleared_dishonours_233__c, Primary_regular_benefit_frequency__c, Last_pay_date_for_largest_inc_src_302__c, Largest_income_source_day_of_week__c, Next_pay_date_for_largest_income_source__c, Frequency_for_largest_income_source__c, Primary_regular_benefit_last_pay_date__c, loan_dishonours__c, Primary_regular_benefit_monthly_amount__c, Courts_and_Fines_transactions__c, Total_monthly_income_ongoin_Reg_231__c, DP_Total_Monthly_Benefit_Income__c, DP_Dishonours_Across_Primary_Acct_244__c, DP_No_Direct_Debits_On_Primary_Acct_355__c, DP_Budget_Management_Services__c, Hardship_Indicator_Gambling__c, DP_Monthly_rent_amount_236__c, Amount_of_SACC_commitments_due__c, Largest_income_Src_Avg_freq__c, Largest_income_Src_last_payment_amt__c, Deposits_since_last_SACC_dishonour__c, SACC_commitments_due_next_month__c, Total_monthly_credits__c, agency_collection_providers__c, Collection_agency_transactions__c, Average_monthly_amount_of_Courts_and_Fin__c, Courts_and_Fines_providers__c, income_DP200_spend_on_high_risk_merch__c, most_recent_loan_has_no_repayments__c, Deposits_since_last_dishonour__c, Income_source_is_other_income_549__c, Bank_Report_Gov_Benefit__c, Income_source_is_a_government_benefit__c, Summary_Income__c, Summary_Expenses__c, Rent_Mortgage__c, Summary_Total__c, Loan_Amount__c, Total_Repayment_Amount__c
                               FROM Opportunity WHERE Id =:oppId LIMIT 1];
 
            LoanAnalysis_CS__c loanAnalysis = LoanAnalysis_CS__c.getOrgDefaults();
 
            String loanAmount = 'null';
            if (opp.Loan_Amount__c != null) {
                loanAmount = '$' + Integer.valueOf(opp.Loan_Amount__c.setScale(0));
            }
 
            String reqBody = '{"body": [{"id": "'+opp.Id+'","Opportunity_Origin__c": "'+opp.Opportunity_Origin__c+'","DNB_Scoring_Rate__c": "'+opp.DNB_Scoring_Rate__c+'","Current_Balance__c": "'+opp.Current_Balance__c+'","Applicant_Type__c": "'+opp.Applicant_Type__c+'","Opp_number__C": "'+opp.Opp_number__C+'","Multiple_Lenders_Hardship__c": "'+opp.Multiple_Lenders_Hardship__c+'","income_as_a_of_DP200_income__c": "'+opp.income_as_a_of_DP200_income__c+'","Deposit_spent_on_DOD__c": "'+opp.Deposit_spent_on_DOD__c+'","DP_Monthly_avg_of_SACC_repayments__c": "'+opp.DP_Monthly_avg_of_SACC_repayments__c+'","Monthly_ongoing_financial_commitments__c": "'+opp.Monthly_ongoing_financial_commitments__c+'","DP_Primary_income_frequency__c": "'+opp.DP_Primary_income_frequency__c+'","DP_Primary_income_last_pay_date__c": "18/08/2023","DP_enders_with_uncleared_dishonours_233__c": "'+opp.DP_enders_with_uncleared_dishonours_233__c+'","Primary_regular_benefit_frequency__c": "'+opp.Primary_regular_benefit_frequency__c+'","Last_pay_date_for_largest_inc_src_302__c": "18/08/2023","Largest_income_source_day_of_week__c": "'+opp.Largest_income_source_day_of_week__c+'","Next_pay_date_for_largest_income_source__c": "25/08/2023","Frequency_for_largest_income_source__c": "'+opp.Frequency_for_largest_income_source__c+'","Primary_regular_benefit_last_pay_date__c": "'+opp.Primary_regular_benefit_last_pay_date__c+'","loan_dishonours__c": "'+opp.loan_dishonours__c+'","Primary_regular_benefit_monthly_amount__c": "'+opp.Primary_regular_benefit_monthly_amount__c+'","Courts_and_Fines_transactions__c": "'+opp.Courts_and_Fines_transactions__c+'","Total_monthly_income_ongoin_Reg_231__c": "'+opp.Total_monthly_income_ongoin_Reg_231__c+'","DP_Total_Monthly_Benefit_Income__c": "'+opp.DP_Total_Monthly_Benefit_Income__c+'","DP_Dishonours_Across_Primary_Acct_244__c": "'+opp.DP_Dishonours_Across_Primary_Acct_244__c+'","DP_No_Direct_Debits_On_Primary_Acct_355__c": "'+opp.DP_No_Direct_Debits_On_Primary_Acct_355__c+'","DP_Budget_Management_Services__c": "'+opp.DP_Budget_Management_Services__c+'","Hardship_Indicator_Gambling__c": "'+opp.Hardship_Indicator_Gambling__c+'","DP_Monthly_rent_amount_236__c": "'+opp.DP_Monthly_rent_amount_236__c+'","Amount_of_SACC_commitments_due__c": "'+opp.Amount_of_SACC_commitments_due__c+'","Largest_income_Src_Avg_freq__c": "'+opp.Largest_income_Src_Avg_freq__c+'","Largest_income_Src_last_payment_amt__c": "'+opp.Largest_income_Src_last_payment_amt__c+'","Deposits_since_last_SACC_dishonour__c": "'+opp.Deposits_since_last_SACC_dishonour__c+'","SACC_commitments_due_next_month__c": "'+opp.SACC_commitments_due_next_month__c+'","Total_monthly_credits__c": "'+opp.Total_monthly_credits__c+'","agency_collection_providers__c": "'+opp.agency_collection_providers__c+'","Collection_agency_transactions__c": "'+opp.Collection_agency_transactions__c+'","Average_monthly_amount_of_Courts_and_Fin__c": "'+opp.Average_monthly_amount_of_Courts_and_Fin__c+'","Courts_and_Fines_providers__c": "'+opp.Courts_and_Fines_providers__c+'","income_DP200_spend_on_high_risk_merch__c": "'+opp.income_DP200_spend_on_high_risk_merch__c+'","most_recent_loan_has_no_repayments__c": "'+opp.most_recent_loan_has_no_repayments__c+'","Deposits_since_last_dishonour__c": "'+opp.Deposits_since_last_dishonour__c+'","Income_source_is_other_income_549__c": "'+opp.Income_source_is_other_income_549__c+'","Bank_Report_Gov_Benefit__c": "'+opp.Bank_Report_Gov_Benefit__c+'","Income_source_is_a_government_benefit__c": "'+opp.Income_source_is_a_government_benefit__c+'","Summary_Income__c": "'+opp.Summary_Income__c+'","Summary_Expenses__c": "'+opp.Summary_Expenses__c+'","Rent_Mortgage__c": "'+opp.Rent_Mortgage__c+'","Summary_Total__c": "'+opp.Summary_Total__c+'","Loan_Amount__c": "'+loanAmount+'","Total_Repayment_Amount__c": "'+opp.Total_Repayment_Amount__c+'"}]}';
 
            reqBody = reqBody.remove('null');
            System.debug('request: ' + reqBody);
            // Instantiate a new Http object
            Http h = new Http();
 
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint(loanAnalysis.Endpoint__c);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-api-key', loanAnalysis.Api_Key__c);
            req.setBody(reqBody);
 
            if (loanAnalysis.Activate_Loan_Analysis__c) {
                // Send the request, and return a response
                HttpResponse res = h.send(req);
                System.debug('response: '+res.getBody());
                return res.getBody();
            }
            else {
                return 'Inactive';
            }
           
 
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }
}