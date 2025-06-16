import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class PracticeLWC extends LightningElement {

    @api exposeProperty;
    motoofToday  = 'Learning LWC';
    dataFromHtml = null;
    @track arrayValues  = [20, 30, 40, 50]; 
    @track objectDetails = {
                            'Name' :'sagar', 
                            'Phone' : 1258989898,
                            'City' : 'Charlotte'
    }
    @track sendDetailsToChild;

    renderedCallback() {
        let refDetails = this.refs.input.label;
        console.log('This is the data from refs:' + refDetails);   
    }
    onkeyHandler(event) {
        event.preventDefault();
        this.dataFromHtml = event.target.value;
    }

    handleTrack(event) {
        event.preventDefault();
        // this.arrayValues = this.arrayValues.push(90);
        this.arrayValues = [...this.arrayValues, 90];
        this.objectDetails = {...this.objectDetails, 'Location' : 'Waxhaw'};
        this.sendDetailsToChild = {'Name' :'Ava', 'Color' : 'white'};
        //* calling ava
        let callDaughter = this.template.querySelector('c-practice-child-l-w-c');
        callDaughter.callMeDad('call from dada');

        const toastEvent = new ShowToastEvent({
            title : "toast event",
            message : "toast message",
            variant : "success"
        });
        this.dispatchEvent(toastEvent);
    }

    createTimeout() {
        
        clearTimeout(timerId);
        let timerId = setTimeout((data) => {
            if(data) {
                return 'I got the data';
            } else {
                return 'No data';
            }
        }, 500);
    }
    
    childCloseHandler(event)  {
        event.preventDefault();
        console.log(event.detail.message);
    }
}