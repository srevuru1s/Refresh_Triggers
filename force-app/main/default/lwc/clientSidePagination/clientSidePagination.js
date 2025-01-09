import { LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/PaginationDemoController.getContacts';

const COLUMNS = [
                { label: 'Name', fieldName: 'Name' },
                { label: 'Email', fieldName: 'Email' },
                { label: 'Phone', fieldName: 'Phone' },
                { label: 'Department', fieldName: 'Department' },
                ];
export default class ClientSidePagination extends LightningElement {
    columns   = COLUMNS;
    isLoading = true;
    records   = [];
    //* Pagination Properties
    pageSize        = 10;
    pageNumber      = 1;
    totalRecords    = 0;
    enablePagination = true;

    get hasRecords() {
        return (this.records.length > 0);
    }
    
    //* Pagination Property - Calculate & Return Records to Display
    get recordsToDisplay() {
        let from = (this.pageNumber -1)* this.pageSize;
        let to   = this.pageSize * this.pageNumber;
        
        return this.records?.slice(from, to);
    }
    //* Pagination Property - Calculaye Weather Pagination Needed to Show or Not
    get showPaginator() {
        return this.enablePagination && this.hasRecords;
    }
    //* Calling wire services
    @wire(getContacts)
        wiredGetContacts(result) {
            if (result?.data) {
                this.isLoading    = false;
                this.records      = result.data;
                this.totalRecords = this.records.length;
            } else if(result?.error) {
                this.isLoading = false;
                console.error('Error while fetching data-', result.error);
            }
        }
    
        //* Will Automatically called From Paginator on Page Number or Size
        paginationChangeHandler(event) {
            
            if(event?.detail) {
                this.pageNumber = event.detail.pageNumber;
                this.pageSize   = event.detail.pageSize;
            }
        }
        
}