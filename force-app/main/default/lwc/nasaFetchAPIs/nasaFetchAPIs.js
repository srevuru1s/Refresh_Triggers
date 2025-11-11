import { LightningElement } from 'lwc';
import apiKey from "@salesforce/label/c.NASA_APOD"

export default class NasaFetchAPIs extends LightningElement {

    imageURL;
    apodDate;

    dataChangeHandler(event) {
        console.log("🚀 ~ NasaFetchAPIs ~ dataChangeHandler ~ event:", event)
        this.apodDate = event.detail.value;

        fetch('https://api.nasa.gov/planetary/apod?api_key=' + apiKey+'&date='+this.apodDate, {method :'GET'})
        .then((response) => response.json())
        .then((data) => {
            console.log(`data found from Nasa :${JSON.stringify(data, null, 4)}`)
            this.imageURL = data.hdurl;
        });
    }

}