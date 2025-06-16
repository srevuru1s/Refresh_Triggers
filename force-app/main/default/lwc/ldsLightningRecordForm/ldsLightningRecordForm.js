import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ACCOUNT_OBJECT   from '@salesforce/schema/Account';
import ACCOUNT_NAME     from '@salesforce/schema/Account.Name';
import ACCOUNT_INDUSTRY from '@salesforce/schema/Account.Name';
import ACCOUNT_STATUS from '@salesforce/schema/Account.Active__c';


export default class LdsLightningRecordForm extends LightningElement {

    columns = 2;
    @api objectApiName;
    @api recordId;
    @api fields = [
        {objectApiName : this.objectApiName, fieldApiName : 'AccountNumber'},
        {objectApiName : this.objectApiName, fieldApiName : 'Rating'},
        ACCOUNT_NAME,
        ACCOUNT_INDUSTRY,
        ACCOUNT_STATUS
    ];

    successHandler(event) {
        console.log(`${JSON.stringify(event.detail, null, 2)}`);

        const toastMessage = new ShowToastEvent({
            title : 'showing toast message',
            message : 'This account updated' + event.detail.id,
            variant : 'success',
            mode: 'String'
        });

        dispatchEvent(toastMessage);
    }
}