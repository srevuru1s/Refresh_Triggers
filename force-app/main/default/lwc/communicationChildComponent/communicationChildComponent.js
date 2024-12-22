import { LightningElement, api } from 'lwc';

export default class CommunicationChildComponent extends LightningElement {

    @api userDetails;

    @api childMethod() {
        
        console.log(`Child method got invoked`);
        this.userDetails = [...this.userDetails,{firstName : 'Child Sagar', lastName : 'Revuru', city : 'Charlotte'},
                                                {firstName : 'Child Ava',   lastName : 'Revuru1', city : 'Nellore'},
                                                {firstName : 'Child Joy',   lastName : 'Revuru2', city : 'Ramagundam'},
                                                {firstName : 'Child Hani', lastName : 'Revuru3', city : 'Warangal'} ];
    }
}