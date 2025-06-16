import { LightningElement, api, track } from 'lwc';

export default class PracticeChildLWC extends LightningElement {

    myArray = [30];
    @track daughterdetails;
    @api 
    get parentinfo() {
        return this.daughterdetails;
    }
    
    set parentinfo(data) {
        let localInfo = {...data};
        this.daughterdetails = {...localInfo, 'Dad' : 'Iloveu'};
    }

    @api callMeDad(event) {
        console.log(event);
        console.log('Hello Eva');
    }

    get arryDetails() {
        return this.myArray[0];
    }
    handleChildClick() {
        const childEvent = new CustomEvent("childdata", {
            detail : {
                message: "Child component data"
            },
            bubbles : true,
            composed : true,
        });
        console.log('Custom event data:' + childEvent.detail.message);
        this.dispatchEvent(childEvent);
    }
    

    handlesecondChildClick() {
        console.log('The second button clicked');
    }
}