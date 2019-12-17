import { LightningElement, track} from 'lwc';

// importing apex class to make callout
import getRates from '@salesforce/apex/RatingController.retriveRates';


export default class InputAddressBase extends LightningElement {
    @track conversionData;
    @track originStreet;
    @track originCity;
    @track originState;
    @track originCountry;
    @track originPostalCode;
    @track destinationStreet;
    @track destinationCity;
    @track destinationState;
    @track destinationCountry;
    @track destinationPostalCode;
    @track mapOfValues = [];
    
    genericInputChange(event) {
        this.originStreet = event.target.street;
        this.originCity = event.target.city;
        this.originState = event.target.province;
        this.originCountry =event.target.country;
        this.originPostalCode = event.target.postalCode;
    }

    destinationInputChange(event) {
        this.destinationStreet = event.target.street;
        this.destinationCity = event.target.city;
        this.destinationState = event.target.province;
        this.destinationCountry =event.target.country;
        this.destinationPostalCode = event.target.postalCode;
    }


    // Making Callout using apex class
    handleGetRates() {
        // endpoint URL
        let endpointURL = 'https://wwwcie.ups.com/rest/Rate';
                                
        
        // calling apex class method to make callout
        getRates({strEndPointURL : endpointURL, originStreet : this.originStreet,
            originCity: this.originCity, originState : this.originState,
            originCountry : this.originCountry, originPostalCode : this.originPostalCode,
            destinationStreet : this.destinationStreet, destinationCity : this.destinationCity,
            destinationState : this.destinationState, destinationCountry : this.destinationCountry,
            destinationPostalCode : this.destinationPostalCode} )
        .then(data => {
        
            if(data) {
                for(let key in data) {
                    // Preventing unexcepted data
                    if (data.hasOwnProperty(key)) { // Filtering the data in the loop
                        this.mapOfValues.push({value:data[key], key:key});
                    }
                }
            }
            else if(error) {
                window.console.log(error);
            }
        })
        .catch(error => {
            window.console.log('error ====> '+JSON.stringify(error));
        })

    } 

}