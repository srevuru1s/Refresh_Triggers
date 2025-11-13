/**
 * @description       :
 * @author            : sagar@salesforce.learning
 * @group             :
 * @last modified on  : 11-11-2025
 * @last modified by  : sagar@salesforce.learning
 */
import { LightningElement, track } from 'lwc';

export default class HelloWorldButton extends LightningElement {
    @track showMessage = false;

    handleClick() {
        this.showMessage = true;
    }
}
