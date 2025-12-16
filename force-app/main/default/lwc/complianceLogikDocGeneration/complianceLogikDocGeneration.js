import { LightningElement, api, wire, track } from 'lwc';

import { subscribe } from 'lightning/empApi';
// import GetLeadsLogikFunc from '@salesforce/apex/LeadsLogikServices.GetLeadsLogikFunc';


import analyse from '@salesforce/apex/complianceLogik.analyse';

import lendingLogikLogo from '@salesforce/resourceUrl/lending_logik_logo'
export default class ComplianceLogikDocGeneration extends LightningElement {
  @api recordId;
  @track plans = [];
  @track error;
  @track errorMsg;
  @track isLoading = false;
  lendingLogikLogo = lendingLogikLogo

  connectedCallback() {
      this.gettingLeadsLogik();
  }

  gettingLeadsLogik() {
      this.isLoading = true;
      analyse({ LeadId: this.recordId })
      .then(result => {
          if (result != null) {
            try{
              let jsonObject = JSON.parse(result);
              this.plans = this.transformData(jsonObject);

            } catch (error) {
              console.error("Error parsing JSON:", error.message);
            } finally {
              this.isLoading = false;
            }
            
          }
          else if (result == 'Inactive') {
            this.errorMsg = 'Please activate Loan Analysis from Custom Setting';
          }
          else {
            console.log('OUTPUT : SOMETHING WENT WRONG!');
          }
        })
  }

  transformData(data) {
      const plans = [];
      Object.keys(data).forEach(ComplianceName =>{
        const ComplianceNameItems = [];
         

        Object.keys(data[ComplianceName]).forEach(subItemName =>{
          const planItems = [];
          const subItemFields = data[ComplianceName][subItemName];
          
          if(subItemFields['Return_result']){
            planItems.push({
              name: subItemName,
              Return_result:subItemFields['Return_result'],
              Remark: subItemFields['Remark'],
            });
          }
          else{
            Object.keys(subItemFields).forEach(subItemFieldName =>{
              const itemFields = subItemFields[subItemFieldName];
              const skipableRules = ["Lender Name","Plan Name","LeadId"]; 
              if (skipableRules.includes(subItemFieldName)){
                  return;
              }
              if(subItemFieldName == "Document Trail"){
                const planItemElemtIndx = planItems.length-1;
                planItems[planItemElemtIndx].name = planItems[planItemElemtIndx].name;
                planItems[planItemElemtIndx].DOC_URL = itemFields['DOC_URL'];
                planItems[planItemElemtIndx].Remark = planItems[planItemElemtIndx].Remark;
                planItems[planItemElemtIndx].fields = planItems[planItemElemtIndx].fields;
              }
              else{
                planItems.push({
                      name: subItemFieldName,
                      Return_result:itemFields['Return_result'],
                      DOC_URL: itemFields['DOC_URL'],
                      Remark: itemFields['Remark'],
                      fields: itemFields
                  });
              }
            });
          }
          ComplianceNameItems.push({
            name: subItemName,
            icon: 'utility:add',
            expanded: false,
            fields: planItems
          });
        });
        plans.push({
            name: ComplianceName,
            icon: 'utility:add',
            expanded: false,
            Compliance_Items:ComplianceNameItems
        });

      });        
      return plans;
  }

  toggleComplianceRules(event) {
      const planName = event.target.dataset.id;
      this.plans = this.plans.map(plan => {
          if (plan.name === planName) {
              plan.expanded = !plan.expanded;
              plan.icon = plan.expanded ? 'utility:dash' : 'utility:add';
          }
          return plan;
      });
  }


  togglePlans(event){
    const complainceName = event.target.id;
    const complianceNameClass = event.target.name;
    const PlanName = event.target.dataset.id;
    
    
    this.plans = this.plans.map(plan => {
      
      if (plan.name === complianceNameClass) {
          plan.Compliance_Items = plan.Compliance_Items.map(compliance_item => {
              if (compliance_item.name === PlanName) {
                compliance_item.expanded = !compliance_item.expanded;
                plan.icon = plan.expanded ? 'utility:dash' : 'utility:add';
              }
              return compliance_item;
          });
        }
        return plan;
    });
    

  }
     
}