import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/WireServicesClass.getAccountRecords';

export default class WireUsingApex extends LightningElement {

    selectedIndustryType ;
    apexAccountDetails ;
    @track dataTable = [];
    //Create a combo box for selecting the values
    get selectListOptions() {
        return [
            {label: 'Industry - Education', value : 'Education'},
            {label: 'Industry - Energy', value : 'Energy'}
        ]
    }
    //data table columns
    @track columns = [
                        {label : 'Name',     fieldName : 'Name',     type : 'text'},
                        {label : 'Industry', fieldName : 'Industry', type : 'text'},
                        {label : 'Id', fieldName : 'Id', type : 'text'}
                        ]
    //Handle the combo box changes
    handleChange(event) {
        console.log(event.target);
        this.selectedIndustryType = event.target.value;
    }
    // calling the wire method
    @wire(getAccounts, {value : '$selectedIndustryType'})
    accountDetails({data, error}) {
        if (data) {
            console.log(`data received : ${JSON.stringify(data)}`)
            this.apexAccountDetails = data;
            this.dataTable = data; 
            // as the data from apex coming in same way as needed so no need to run map to transform
            // this.dataTable = this.apexAccountDetails.map((item) => {
            //                     return {
            //                             Name : item.Name,
            //                             Industry : item.Industry,
            //                             Id : item.Id}
            //                     });


        }else if(error) {
            console.log(error);
        }
    }
}