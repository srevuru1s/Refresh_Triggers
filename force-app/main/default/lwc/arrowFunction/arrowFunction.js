import { LightningElement, api } from 'lwc';

export default class ArrowFunction extends LightningElement {

    message;
    @api userdetails;
    @api address;
    

    display = () => {
        this.message = 'Hello => Function';
    }

    handleClick() {
        console.log(this.display());
        console.log(this.message);
    }

    @api childMethod() {

        console.log('Method called from parent');
    }


}