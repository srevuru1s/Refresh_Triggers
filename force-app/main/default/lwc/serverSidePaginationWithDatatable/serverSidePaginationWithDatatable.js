import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/PaginationDemoController.getAccounts';
import getTotalAccountsCount from '@salesforce/apex/PaginationDemoController.getTotalAccountsCount';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Type', fieldName: 'Type' },
    { label: 'Rating', fieldName: 'Rating' }
]
export default class ServerSidePaginationWithDatatable extends LightningElement {
    // Data Table Properties
    columns = COLUMNS;
    isLoading = true;
    records = [];

    // Pagination Properties
    totalRecords = 0;
    lastRecordId = '';
    pageSize = 10;
    recordsToDisplay;
    enablePagination = true;

    get hasRecords() {
        return this.records.length > 0;
    }

    // PAGINATION PROPERTY - CHECK WEATHER PAGINATION NEEDS TO SHOW OR NOT
    get showPaginator() {
        return this.enablePagination && this.hasRecords;
    }

        // GET TOTAL RECORDS COUNT
        @wire(getTotalAccountsCount)
        wiredGetTotalAccountsCount(result) {
            if (result.data) {

                let aggResult = result.data;
                let {expr0} = aggResult[0];
                this.totalRecords = expr0;
                
            }
            else if (result.error) {
                console.log('Error while fetching total count- ', result.error);
            }
        }

        connectedCallback() {
            this.fetchRecordsFromServer();
        }

        async fetchRecordsFromServer() {
            try {
                let reponse = await getAccounts({ pageSize: this.pageSize, lastRecordId: this.lastRecordId });
    
                this.isLoading = false;
                this.recordsToDisplay = reponse;
                this.records = [...this.records,...this.recordsToDisplay];
                
            }
            catch (error) {
                this.isLoading = false;
                console.log('Error while fetching data : ', JSON.stringify(error));
            }
        }

        //* Automatically Called From Pagination when the page number or size changes

        paginationChangeHandler(event) {

            if (event.detail) {
                if (this.pageSize != event.detail.pageSize) {
                    this.records = []; //Reset the records array on page size change
                    this.pageSize = event.detail.pageSize;
                }
                this.pageNumber = event.detail.pageNumber;
                //* if (event.detail.operationType == 'NEXT')
                    if (this.records.length > this.pageSize * (this.pageNumber -1)) { //Get and show data from record list..
                        let from = (this.pageNumber -1) * this.pageSize;
                        let to   = this.pageSize * this.pageNumber;

                        this.recordsToDisplay = this.records?.slice(from, to);
                    }
                    else { //Get More Data From the server
                        this.lastRecordId = this.records[this.records.length - 1]?.Id;
                        this.isLoading = true;
                        this.fetchRecordsFromServer();
                    }
            }
        }
}