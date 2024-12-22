import { LightningElement, wire, api, track } from 'lwc';
import { getRecord }              from 'lightning/uiRecordApi';
import ID                         from '@salesforce/schema/User.Id';
import NAME_FIELD                 from '@salesforce/schema/User.Name';
import EMAIL_FIELD                from '@salesforce/schema/User.Email';
import USER_NAME_FIELD            from '@salesforce/schema/User.Username';
import PROFILEID_FIELD            from '@salesforce/schema/User.ProfileId';
import Industry from '@salesforce/schema/Account.Industry';

const userFields = [ID,NAME_FIELD,EMAIL_FIELD, USER_NAME_FIELD, PROFILEID_FIELD]
                
export default class WireServicesGetRecord extends LightningElement {

    @api recordId;  
    @track wireOutput;
    

    @wire (getRecord, {recordId: '$recordId', fields: userFields})
        wireUserDetails({error, data}) {
        if(error) {
            console.log(error);
        } else if(data) {
            console.log(`i got the data : ${data}`);


            console.log(`Wire out put : ${this.wireOutput}`)
            console.log('Id details :' + JSON.stringify(this.userId));
        }
    };

}