import { LightningElement, wire } from 'lwc';
import { getObjectInfo }    from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT       from '@salesforce/schema/Account';
const object = ACCOUNT_OBJECT;

export default class WireGetObjectInfo extends LightningElement {

    @wire (getObjectInfo, {objectApiName : object})
    objectInfo;

    get objectDetails() {
        console.log(`Object Details : ${JSON.stringify(this.objectInfo)}`);
        return this.objectInfo;
    }
    handleClick() {
        this.objectDetails();
    }
}