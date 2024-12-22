import { LightningElement, track } from 'lwc';

export default class CustomEventsParentComponent extends LightningElement {
    
    @track parentDetails;
    @track parentTag;
    @track parentMessage;

    handleChildEvent(event) {

        console.log('Received event:', event); // Ensure the event is received
        console.log('Event detail:', JSON.stringify(event.detail)); // Check the detail content
        this.parentDetails = event.detail; // Assign the detail
        console.log('Updated parentDetails:', JSON.stringify(this.parentDetails)); // Verify assignment

    }
}