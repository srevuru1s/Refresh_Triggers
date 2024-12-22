import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ShowToastMessage extends LightningElement {
    name = 'Initial Value' ;
    refValue = 'Ref Value 1';
    reactiveValue = 'Im Reactive';

    @track userDetails = [
        {firstName : 'Sagar', lastName : 'Revuru', location : 'USA', index : 0},
        {firstName : 'Hani', lastName : 'Revuru1', location : 'USA', index : 1},
        {firstName : 'Joy', lastName : 'Revuru2', location : 'USA', index : 2},
        {firstName : 'Ava', lastName : 'Revuru3', location : 'USA', index : 3}
    ];
    showToast() {

        const toastMessage = new ShowToastEvent( {
                title: 'Success!',
                message: 'The record has been saved successfully.',
                variant: 'success',
                mode: 'dismissable' // Modes: dismissable, sticky, pester
            }
        );

        this.dispatchEvent(toastMessage);

        this.userDetails = [...this.userDetails,{lastName : 'Template'}];
        console.log(this.userDetails);

  
        
    }

    handleInputChange(event) {

        this.name = event.target.value;

        const nameInput = this.refs.nameInput;
        console.log(nameInput.value); // Access input value via ref
        this.refValue = nameInput.value;
        this.reactiveValue = 'Updated Reactive';

    }
}