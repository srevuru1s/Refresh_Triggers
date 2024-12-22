import { LightningElement } from 'lwc';
export default class TwoWayDataBinding extends LightningElement {

    greeting = 'Hello LWC';
    userName ;
    showText ;
    labelOnButton ;
    onChangeHandler(event) {
        this.userName = event.target.value;
    }

    get getLabel() {
        return this.labelOnButton ? 'HideText' : 'ShowText';
    }

    set getLabel(value) {
        if (this.labelOnButton == value) {
            this.labelOnButton = true;
        } else {
            this.labelOnButton = false;
        }
    }
    handleClick() {
        this.showText = true;
        this.getLabel(true);
    }


}