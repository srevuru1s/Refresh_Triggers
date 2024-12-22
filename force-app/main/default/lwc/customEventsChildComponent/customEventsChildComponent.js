import { LightningElement } from 'lwc';

export default class CustomEventsChildComponent extends LightningElement {

    handleClick(event) {
        //* create new custom event
        const childEvent = new CustomEvent('customevent', {
            detail: {
                tag: 'Im calling from child component',
                message: 'This is a custom event from child'
            },
            bubbles  : false,
            composed : false
        });
        //* dispatch the event
        this.dispatchEvent(childEvent);
    }
}