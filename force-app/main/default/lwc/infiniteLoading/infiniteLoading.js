import { LightningElement } from 'lwc';
import getAccounts                from '@salesforce/apex/AccountController.getAccounts';

const columnsDetails = [ 
    {label : 'Id',       fieldName : 'Id',       type : 'text'},
    {label : 'Name',     fieldName : 'Name',     type : 'text'},
    {label : 'Industry', fieldName : 'Industry', type : 'text'},
    {label : 'Rating',   fieldName : 'Rating',   type : 'text'},
    {label : 'Phone',    fieldName : 'Phone',    type : 'Phone'},
    {label : 'Active',   fieldName : 'Active__c',type : 'Boolean'}
];
export default class InfiniteLoading extends LightningElement {

    //*Data Table Decleration
    columns = columnsDetails;
    data    = [];
    //* Declaring the Limit & OffSet
    limitValue  = 5;
    offSetValue = 0; 
    enableInfiniteLoading = false;

    connectedCallback() {
        this.loadData();
    }

    async loadData() {
        
        try {
            let apexResponse = await getAccounts({limitSize: this.limitValue, offSetSize: this.offSetValue});
            
            this.data = [...this.data, ...apexResponse];
            //* enabling the infinite loading
            this.enableInfiniteLoading = (apexResponse.length == this.limitValue || apexResponse.length != 0);
        } catch (error) {
            console.error(`Error while fetching the records : ${error}`);
        }
        
    }

    async loadMoreRecords(event) {
        //* we have an attribute on data table isLoading
        let loading      = event.target;
        loading.isLoading = true;

        this.offSetValue = this.offSetValue + this.limitValue;
        console.log(`Im in the loadMoreRecords : ${this.offSetValue}`);
        await this.loadData();
        loading.isLoading = false;
    }
}