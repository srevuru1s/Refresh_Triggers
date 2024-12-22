import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {

    parentUser = {
        name   : "Sagar",
        number : 941
    }
    parentAddress = [
        {city : 'Charlotte', State : 'NC'},
        {city : 'Ramagundam', State : 'TG'},
        {city : 'Nellore', State : 'AP'},
        {city : 'Atlanta', State : 'GA'},

    ]
    get arrayRecords () {
        return this.parentAddress[3];
    }
    set arrayRecords(data) {
        this.parentAddress = [...data, ...{city : 'waxhaw', State : 'NC'}];
        
        console.log(this.parentAddress);
    }
    handleClick(event) {

        event.preventDefault();
        let childComponent = this.template.querySelector('c-arrow-function');
        childComponent.childMethod();
        this.arrayRecords(this.parentAddress);
    }
    handleDateChange(event) {
        let tagDetails = event.target;
        console.log(`The date tag : ${JSON.stringify(tagDetails)}`);
        console.log(`The date tag : ${tagDetails.value}`);
        
    }

    handleDivClick(event) {
        
        console.log(`Event Target : ${JSON.stringify(event.target.label)}`); //Button 1
        console.log(`Event Current Target : ${JSON.stringify(event.currentTarget.title)}`); //Div Tag
    }

    handleClickButton1(event) {
        // event.stopPropagation();

        console.log(`Event Target : ${JSON.stringify(event.target.label)}`); //Button 1
        console.log(`Event Current Target : ${JSON.stringify(event.currentTarget.title)}`);

        let timeOutId = setTimeout(() => {
            console.log('Im in the set time out🎁');
        }, 2000);

        console.log(`The time out id : ${timeOutId}`);
        setTimeout(() => {
            clearTimeout(timeOutId);
            console.log('im in the clear timeout');
        }, 3000);
    }
   
}