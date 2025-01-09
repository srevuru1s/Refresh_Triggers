import { LightningElement } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
export default class PaginationAccountRecords extends LightningElement {

    columns = [
                { label: 'Account Name', fieldName: 'Name' },
                { label: 'Phone', fieldName: 'phone', type: 'phone' },
                { label: 'Industry', fieldName: 'Industry', type: 'text' },
                { label: 'Rating', fieldName: 'Rating', type: 'text' },
                { label: 'Industry', fieldName: 'Industry', type: 'text' }
            ];
    data = [];
    //* Pagination Details
    currentPage = 1;
    pageRecordSize = 5;
    hidePreviousButton = false;
    

    connectedCallback() {
        this.loadData();
    }

    async loadData() {

        //* Updating the offset value
        this.hidePreviousButton = (this.currentPage === 1);
        console.log(this.hidePreviousButton);
        const offSetValue = (this.currentPage -1)* (this.pageRecordSize);
        try {
            let apexResponse = await getAccounts({limitSize: this.pageRecordSize, offSetSize: offSetValue});
            this.data        = [...this.data, ...apexResponse]; 
        } catch (error) {
            console.error(`Error fecthing records : ${error}`);
        }
    }

    nextPageHandler() {
        this.currentPage++;
        this.loadData();
    }

    previousPageHandler() {
        this.currentPage--;
        this.loadData();
    }
}