import { LightningElement, track } from 'lwc';
import listOfAccounts from '@salesforce/apex/LwcAccountHandler.listOfAccounts';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class LightningDataTable extends LightningElement {

    @track columns = [
        {label : 'Name',     fieldName : 'Name',     type : 'text'},
        {label : 'Industry', fieldName : 'Industry', type : 'text'},
        {label : 'Rating',   fieldName : 'Rating',   type : 'text'},
        {label : 'Phone',    fieldName : 'Phone',    type : 'text'}
    ];

    @track data = [];
    showData ;

    connectedCallback() {
        
    }

    renderedCallback() {


    }
    
    handleClick() {

        this.getAccounts();
        
    }

    getAccounts() {
        listOfAccounts()
            .then((result) => {
                console.log(`results : ${result}`);
                this.data = result;
                this.showData = !this.showData;
            })
            .catch((error) => {
                console.error(`We got error while calling apex ${error}`);
            })
    }
}