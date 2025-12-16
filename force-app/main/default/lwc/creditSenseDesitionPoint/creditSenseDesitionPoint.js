import { LightningElement, api, wire } from 'lwc';
import { subscribe } from 'lightning/empApi';
import analyse from '@salesforce/apex/FlynxloanAnalysis.analyse';

import greenSignal from '@salesforce/resourceUrl/GreenSignal';
import redSignal from '@salesforce/resourceUrl/RedSignal';
import yellowSignal from '@salesforce/resourceUrl/YellowSignal';
import greySignal from '@salesforce/resourceUrl/GreySignal';
import lendingLogikLogo from '@salesforce/resourceUrl/lending_logik_logo'
export default class CreditSenseDesitionPoint extends LightningElement {
 
  @api recordId;

  // Setting signal url
  greenSignalUrl = greySignal;
  redSignalUrl = greySignal;
  yellowSignalUrl = greySignal;
  lendingLogikLogo = lendingLogikLogo
  confidenceMeasure = '0';

  predictedResult;

  requestBodyStr = '';
  responseStr = '';

  errorMsg = '';
  isLoading = true;

  data = {};

  subscription = {};
  channelName = '/event/Opp_update__e';
  myPlatformEventData;

  

  connectedCallback() {

    this.platformEvent();
    this.runAnalysis();
  }

  platformEvent() {
    // Callback invoked whenever a new event message is received
    const messageCallback = (response) => {
      if (response.data.payload.recordId__c === this.recordId) {
        this.runAnalysis();
      }
    };
    // Invoke subscribe method of empApi. Pass reference to messageCallback
    subscribe(this.channelName, -1, messageCallback).then(response => {
      // Response contains the subscription information on subscribe call
      this.subscription = response;
    });
  }

  runAnalysis() {
    this.isLoading = true;

    // Setting signal url
    this.greenSignalUrl = greySignal;
    this.redSignalUrl = greySignal;
    this.yellowSignalUrl = greySignal;

    analyse({ oppId: this.recordId })
      .then(result => {
        if (result != null) {
          this.responseStr = result;
          console.log("The Results were ",result);
          this.data = JSON.parse(result);
          console.log('OUTPUT : ', this.data["Predicted result"]);
          //this.predictedResult = this.data["Predicted result"][this.recordId];
          this.predictedResult = this.data["Predicted result"]["predicted_result"];
          this.confidenceMeasure = this.data["Predicted result"]["predict_probability"];
          this.confidenceMeasure = parseInt(this.confidenceMeasure * 100);
          console.log('confidence : ', this.confidenceMeasure);

          console.log('OUTPUT : predictedResult', this.predictedResult);
          switch (this.predictedResult) {
            case 1:
              this.redSignalUrl = redSignal;
              break;
            // case 1:
            //   this.yellowSignalUrl = yellowSignal;
            //   break;
            case 0:
              this.greenSignalUrl = greenSignal;
              break;

            default:

              break;
          }
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

  get confidenceClass() {
    if (this.confidenceMeasure < 15) {
      return 'error-clr';
    } else if (this.confidenceMeasure >= 15 && this.confidenceMeasure <= 50) {
      return 'warning-clr';
    } else {
      return 'success-clr';
    }
  }
}