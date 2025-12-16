import { LightningElement, api, wire, track } from 'lwc';

// export default class BorrowerQualificationLogik extends LightningElement {}
import { loadScript } from "lightning/platformResourceLoader";
import gaugeJS from '@salesforce/resourceUrl/gaugeJS';

import GetLeadsLogikFunc from '@salesforce/apex/LeadsLogikServices.GetLeadsLogikFunc';
import analyse from '@salesforce/apex/borrowerQualificationLogik.analyse';

import lendingLogikLogo from '@salesforce/resourceUrl/lending_logik_logo'
import Yes_Icon from '@salesforce/resourceUrl/Yes_Icon'
import No_Icon from '@salesforce/resourceUrl/No_Icon'
export default class BorrowerQualificationLogik extends LightningElement {

  @track ChartRelationChart = {};

  Yes_Icon = Yes_Icon
  No_Icon = No_Icon

  // Gauge chart config
  chartConfig = {
     angle: 0, // The span of the gauge arc
     lineWidth: 0.12, // The line thickness
     radiusScale: 0.8, // Relative radius
     pointer: {
        length: 0.40, // // Relative to gauge radius
        strokeWidth: 0.06, // The thickness
        color: '#17324D' // Fill color
     },
     staticZones: [ // The red, yellow, green coloured zones on the gauge
        {
           strokeStyle: '#FDB75D',
           min: 0,
           max: 167
        },
        {
           strokeStyle: '#24716B',
           min: 167,
           max: 333
        },
        {
           strokeStyle: '#FDB75D',
           min: 333,
           max: 500
        }
     ],
     staticLabels: {
        font: "14px Arial",
        labels: [167, 330], // Print labels at these values
        color: "#818181", // Optional: Label text color
        fractionDigits: 0 // Optional: Numerical precision. 0=round off.
     },
     renderTicks: { // The grey tick lines on the gauge
        divisions: 5,
        divWidth: 0.6,
        divLength: 0.5,
        divColor: '#ecebea',
        subDivisions: 2,
        subLength: 0.3,
        subWidth: 0.6,
        subColor: '#ecebea'
     },
     limitMin: false, // If true, the min value of the gauge will be fixed
     limitMax: false, // If false, max value increases automatically if value > maxValue
     colorStart: '#6FADCF', // Colors
     colorStop: '#8FC0DA', // just experiment with them
     strokeColor: '#E0E0E0', // to see which ones work best for you
     generateGradient: true,
     highDpiSupport: true // High resolution support
  };

  connectedCallback() {
    this.GettingLeadsLogik();
  }


  createMappingbetweenLeandsAndLenders(){
    
    this.isLoading = true;
    analyse({ LeadId: this.recordId })
    .then(result => {
        try{
          if (result != null) {
            console.log("The Result Were :: ",result);
          }
          else if (result == 'Inactive') {
            this.errorMsg = 'Please activate Loan Analysis from Custom Setting';
          }
          else {
            console.log('OUTPUT : SOMETHING WENT WRONG!');
            //this.requestBodyStr = error;
          }
        }catch (error) {
          console.error("Error parsing JSON:", error.message);
        } 
        finally{
          this.isLoading = false;
        }
      })
      .catch(error => {
        console.log('error', error);
        this.requestBodyStr = error;
      })
  }


  createAssessmentTable(queryElement, LogsEligibility){
    const rowElement = this.template.querySelector(`[data-id="${queryElement}"]`);
    console.log('Row Element : ', rowElement);

    // Remove trailing ", ..."
    if (LogsEligibility.endsWith(", ...}")) {
      LogsEligibility = LogsEligibility.slice(0, -6) + "}";
    } 
    // Replace all = with :
    LogsEligibility = LogsEligibility.replace(/=/g, ":");
    // Wrap keys in double quotes for valid JSON
    LogsEligibility = LogsEligibility.replace(/(\w+):/g, '"$1":');

    const ParsedoanEligibility  = JSON.parse(LogsEligibility);

    let Fine  = `<table> <thead> <th> Header </th> <th> Log </th> <th> Pass/Fail </th> </thead> <tbody>`;
      for (let [key, value] of Object.entries(ParsedoanEligibility)) {
        // Fine.push({Key, value});
        Fine += `<tr> <td> ${key} </td> <td style="text-wrap: wrap;"> ${value.Remark} </td> <td>   <img style="max-width:1.2rem;" src="${value.Return_result?this.Yes_Icon:this.No_Icon}" /></td> </tr>`
      } 


    rowElement.innerHTML = Fine;

  }

    handleShowButtonClick(event){  
      for (let index = 0; index < this.responseLenders.length; index++) {
        this.createAssessmentTable(this.responseLenders[index]['AssesmentReport'], this.responseLenders[index]['Logs_of_Eligibility__c']);
        if (this.responseLenders[index]['Id'] == event.target.name){
          // this.responseLenders[index]['AIFeatures'] = !this.responseLenders[index]['AIFeatures']?true:false;
          let rowqueryselectorName  = this.responseLenders[index]['RowId']
          const rowElement = this.template.querySelector(`[data-id="${rowqueryselectorName}"]`);
          rowElement.style.display = rowElement.style.display == 'table-row'?'none':'table-row';
          rowElement.style.tramsition = 'all 1s ease-out';

          // Show and Hide the  Assesment Report Row > AssesmentReportRowId
          const AssesmentReportRowId = this.template.querySelector(`[data-id="${this.responseLenders[index]['AssesmentReportRowId']}"]`);
          AssesmentReportRowId.style.display = AssesmentReportRowId.style.display == 'table-row'?'none':'table-row';
          AssesmentReportRowId.style.tramsition = 'all 1s ease-out';


        
          let queryselectorName  = this.responseLenders[index]['CreditChart']
          const indicator = this.template.querySelector(`[data-id="${queryselectorName}"]`);
          // Load Gauge.js
          
          let minVal = this.generateAnumberBetween(200,450);  
          let maxVal = this.generateAnumberBetween(500,700);   
          
          let CreditScore = this.responseLenders[index]['CreditScore'];
          if (! this.ChartRelationChart[this.responseLenders[index]['Id']]){
            this.generateGuageElement(indicator, this.responseLenders[index]['Id'], CreditScore, minVal, maxVal);
          }


          // Linear Guage 

              // Guage Scale 


              minVal = this.generateAnumberBetween(20,35);
              maxVal = this.generateAnumberBetween(55,75);

              const DebtIncomeRatioScale = this.template.querySelector(`[data-id="${this.responseLenders[index]['DebtIncomeRatioScale']}"]`);
              const DebtIncomeRatioLabel = this.template.querySelector(`[data-id="${this.responseLenders[index]['DebtIncomeRatioLabel']}"]`);
              for(let index=0;index<DebtIncomeRatioScale.childNodes.length;index++){
                switch (index) {
                    case 0:
                      DebtIncomeRatioScale.childNodes[index].style.width = minVal+'%';
                      DebtIncomeRatioLabel.childNodes[index].style.width = minVal+'%';
                      break;
                    case 1:
                      DebtIncomeRatioScale.childNodes[index].style.width = maxVal - minVal+'%';
                      DebtIncomeRatioLabel.childNodes[index].style.width = maxVal - minVal+'%';
                      DebtIncomeRatioLabel.childNodes[index].textContent = minVal;
                      break;
                    case 2:
                      DebtIncomeRatioScale.childNodes[index].style.width = 100 - maxVal+'%';
                      DebtIncomeRatioLabel.childNodes[index].style.width = 100 - maxVal+'%';
                      DebtIncomeRatioLabel.childNodes[index].textContent = maxVal +'%';
                      break;
                  
                }
              }


          let LinearGuageQuerySelectorName = this.responseLenders[index]['DebtIncomeRatioPointer'];
          const linearGuageIndicator = this.template.querySelector(`[data-id="${LinearGuageQuerySelectorName}"]`);
          const leftPercentage = Math.min(Math.max(this.responseLenders[index]['DebtToIncomeRatio'], 0), 100);
          linearGuageIndicator.style.left =  leftPercentage+`%`;
          
          
          const ShowHideBtn = this.template.querySelector(`[data-id="${this.responseLenders[index]['ShowHideBtn']}"]`);
          ShowHideBtn.iconName = ShowHideBtn.iconName == 'utility:add' ? 'utility:dash':'utility:add';
 
          
        }
        else{
          const ShowHideBtn = this.template.querySelector(`[data-id="${this.responseLenders[index]['ShowHideBtn']}"]`); 
          ShowHideBtn.iconName =  'utility:add';
          let rowqueryselectorName  = this.responseLenders[index]['RowId']
          const rowElement = this.template.querySelector(`[data-id="${rowqueryselectorName}"]`);
          rowElement.style.display = 'none';
          rowElement.style.tramsition = 'all 1s ease-out';

          // Show & hide Assesment Report Row  AssesmentReportRowId
          const AssesmentReportRowId = this.template.querySelector(`[data-id="${this.responseLenders[index]['AssesmentReportRowId']}"]`);
          AssesmentReportRowId.style.display = 'none';
          AssesmentReportRowId.style.tramsition = 'all 1s ease-out';


        }

      }
      this.responseLenders = this.responseLenders;
    }

    generateAnumberBetween(minimum, maximum){
      return Math.floor(Math.random() * (maximum - minimum + 1)) + minimum;
    }

    generateGuageElement(LWCElement, unqID, CreditScore, MinValue, MaxValue){
      loadScript(this, gaugeJS).then(() => {
        // HTML canvas for gauge chart
        if(LWCElement && CreditScore) {
          for (let i = 0; i < this.chartConfig.staticZones.length; i++) {
            switch (i) {
              case 0:
                this.chartConfig.staticZones[i]['min'] = 100;
                this.chartConfig.staticZones[i]['max'] = MinValue;
                break;
              case 1:
                this.chartConfig.staticZones[i]['min'] = MinValue;
                this.chartConfig.staticLabels.labels[0] = MinValue;
                this.chartConfig.staticLabels.labels[1] = MaxValue;
                this.chartConfig.staticZones[i]['max'] = MaxValue;
                break;
              case 2:
                this.chartConfig.staticZones[i]['min'] = MaxValue;
                this.chartConfig.staticZones[i]['max'] = 900;
                break;
            }
          }
          // Draw the gauge chart
          this.Chart = new Gauge(LWCElement).setOptions(this.chartConfig);
          // You can also set other chart options this way
          this.Chart.maxValue = 900;
          this.Chart.setTextField(CreditScore);
          this.Chart.setMinValue(100);
          this.Chart.animationSpeed = 10;
          this.Chart.set(CreditScore);
          this.ChartRelationChart[unqID] = this.Chart;
        }
    })
    .catch(error => {
      console.error("Error loading gauge.js", error);
  });


    }







  // This is Sonething new 


    @api recordId;
    lendingLogikLogo = lendingLogikLogo;

    requestBodyStr = '';
    @track responseLenders = [];

    errorMsg = '';
  
  GettingLeadsLogik() {

    this.isLoading = true;
    GetLeadsLogikFunc({ LeadId: this.recordId })
    .then(result => {
        if (result != null) {
            console.log("The Result Were : ",result);
            const creditScore = this.generateAnumberBetween(550,700) ;
            const DebtToIncomeRatio = this.generateAnumberBetween(10,35) ;
            for (let index = 0; index < result.length; index++) {
              result[index]['CreditChart'] = `Chart_${result[index]['Id']}`;
              result[index]['DebtIncomeRatioPointer'] = `DebtIncome_${result[index]['Id']}`;
              result[index]['DebtIncomeRatioScale'] = `DebtIncomeRatioScale_${result[index]['Id']}`;
              result[index]['DebtIncomeRatioLabel'] = `DebtIncomeRatioLabel_${result[index]['Id']}`;
              result[index]['AssesmentReport'] = `AssesmentReport_${result[index]['Id']}`;
              
              result[index]['RowId'] = `RowId_${result[index]['Id']}`;
              result[index]['AssesmentReportRowId'] = `AssesmentReportRowId_${result[index]['Id']}`;
              
              // show hide button 
              result[index]['ShowHideBtn'] = `ShowHideBtn_${result[index]['Id']}`;
              // const buttonIcon = this.template.querySelector(`lightning-button-icon[data-id="${LenderPlan.Id}"]`);


              this.ChartRelationChart[result[index]['CreditChart']] = result[index]['CreditChart'];

              result[index]['DebtToIncomeRatio']  = DebtToIncomeRatio;  
              result[index]['CreditScore'] = creditScore;      
              // result[index]['CreditScoreLabel'] = this.getCreditScoreLabel(result[index]['CreditScore']);
              result[index]['AIFeatures'] = false;
            }
            this.responseLenders = result;
            console.log("The Result After Were : ",result);

        }
        else if (result == 'Inactive') {
          this.errorMsg = 'Please activate Loan Analysis from Custom Setting';
        }
        else {
          console.log('OUTPUT : SOMETHING WENT WRONG!');
          //this.requestBodyStr = error;
        }
      })
      .catch(error => {
        console.log('error', error);
        this.requestBodyStr = error;
      })
    this.isLoading = false;
  }
}