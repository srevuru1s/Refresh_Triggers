import { LightningElement, track } from 'lwc';

export default class CommunicationParentComponent extends LightningElement {

    @track parentUserDetails = [];

    handleClick() {
        this.parentUserDetails = [  {firstName : 'Sagar', lastName : 'Revuru', city : 'Charlotte'},
                                    {firstName : 'Ava',   lastName : 'Revuru1', city : 'Nellore'},
                                    {firstName : 'Joy',   lastName : 'Revuru2', city : 'Ramagundam'},
                                    {firstName : 'Hani', lastName : 'Revuru3', city : 'Warangal'}  
                                ]
    }

    callChildMethod() {
        const childTag = this.template.querySelector(['c-communication-child-component']);
        console.log(`got the child tag : ${JSON.stringify(childTag)}`);
        childTag.childMethod();
    }
}