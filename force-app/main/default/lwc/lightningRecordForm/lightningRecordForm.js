import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
import ACCOUNT_STATUS from '@salesforce/schema/Account.Active__c';
import ACCOUNT_INDUSTRY from '@salesforce/schema/Account.Industry';
import ACCOUNT_WEBSITE from '@salesforce/schema/Account.Website';
import ACCOUNT_RATING from '@salesforce/schema/Account.Rating';
import ACCOUNT_OWNER from '@salesforce/schema/Account.OwnerId';
import ACCOUNT_BILLING_ADDRESS from '@salesforce/schema/Account.BillingAddress';
import ACCOUNT_SHIPPING_ADDRESS from '@salesforce/schema/Account.ShippingAddress';

export default class LightningRecordForm extends LightningElement {
    @api objectApiName = ACCOUNT_OBJECT;
    @api recordId = '001aj00000j8rd7AAA';
    columns = 4;
    accountFields = [
        {"objectApiName":"Account", "fieldApiName":"Phone"},
        ACCOUNT_NAME,
        ACCOUNT_STATUS,
        ACCOUNT_INDUSTRY,
        ACCOUNT_WEBSITE,
        ACCOUNT_RATING,
        ACCOUNT_OWNER,
        ACCOUNT_BILLING_ADDRESS,
        ACCOUNT_SHIPPING_ADDRESS
    ];
    constructor() {
        super();
        console.log(`Account Name field ${JSON.stringify(ACCOUNT_NAME)}`);
    }
    successHandler(event) {
        console.log('updated account details:' + JSON.stringify(event.detail));

        this.toastMessage('Account Updated', 'RecordID :'+ event.detail.id, 'success');
    }
    
    toastMessage(title, message, variant) {
        const toastEvent = new ShowToastEvent( {
            title   : title,
            message : message,
            variant : variant
        })
        this.dispatchEvent(toastEvent);
    }
}
