import { LightningElement, wire } from 'lwc';
import insertAccount from '@salesforce/apex/WireServicesClass.insertAccountRecords';

export default class CreateAccountUsingWire extends LightningElement {

    accountName;
    accountPhone;
    accountIndustry;

        //Reactive field property capture

        handleChange(event) {

            let field = event.target.name;
            if (field == 'aname') {
                this.accountName = event.target.value;
            } else if (field == 'accIndustry') {
                this.accountIndustry = event.target.value;
            } else if (field == 'accPhone') {
                this.accountPhone = event.target.value;
            }
            clearTimeout(this.debounceTimeout);
            // Set a new timeout to wait for 2 seconds after the last keystroke
            this.debounceTimeout = setTimeout(() => {
                console.log('Debounced values:', this.accountName, this.accountPhone, this.accountIndustry);
            }, 5000);  // 2000 ms = 2 seconds (waiting for user to stop typing)
        }

        //Imperative call to apex
        async handleClick() {
                try{
                    let accountRecords = await insertAccount({ accname: this.accountName, accphone: this.accountPhone, accindustry: this.accountIndustry});
                    console.log('Account inserted :', accountRecords);
                } catch(error) {
                    console.log('Error :', error.message);
                }             
        }
        
}