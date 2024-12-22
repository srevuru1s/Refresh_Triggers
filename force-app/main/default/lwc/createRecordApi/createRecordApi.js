import { LightningElement } from 'lwc';
import { createRecord }     from 'lightning/uiRecordApi';
import ACCOUNT_OBJECT       from '@salesforce/schema/Account';
import CONTACT_OBJECT       from '@salesforce/schema/Contact';

export default class CreateRecordApi extends LightningElement {

    inputFields = {};
    inputContactFields = {};

    //* Handle Account field Capture
    changeHandler(event) {
        let {name, value} = event.target;
        this.inputFields[name] = value; 
        console.log(`all fields : ${JSON.stringify(this.inputFields)}`);
    }
    //* Handle Contact field Capture
    contactHandler(event) {
        let {name, value} = event.target;
        this.inputContactFields= {...this.inputContactFields, [name] : value};
    }
    
    async handleClick() {
        try {
            //Create Account
            const accountInput = {
                                    apiName : ACCOUNT_OBJECT.objectApiName,
                                    fields  : this.inputFields
                                };
            const accountData = await createRecord(accountInput);
            console.log(`Account Details : ${accountData}`);
            
            //Set AccountId in the contact fields
            this.inputContactFields = {...this.inputContactFields, AccountId : accountData.id};
            console.log(`Contact Object : ${JSON.stringify(this.inputContactFields)}`);
            // Create contact input
            const contactInput =  {
                                    apiName : CONTACT_OBJECT.objectApiName,
                                    fields  : this.inputContactFields
                                };
            //Create contact record
            const contactData = await createRecord(contactInput);
            console.log(`Contact Record : ${contactData}`);
        } catch {
            console.log(`Error : ${error}`);
        }
    }
    
}