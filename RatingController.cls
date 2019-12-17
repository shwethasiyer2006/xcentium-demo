public inherited sharing class RatingController {

    @AuraEnabled
    public static Map<String, String> retriveRates(String strEndPointURL, String originStreet,String originCity,
                                                    String originState, String originCountry, String originPostalCode,
                                                    String destinationStreet,String destinationCity,String destinationState,
                                                    String destinationCountry, String destinationPostalCode) {
        map<String, Object> mapJsonData = new map<String, Object>();
        Map<String, String> mapCurrencyAndMonetaryValue = new Map<String, String>();
        String strResponse = null;
        if ( originCountry  == 'United States' || destinationCountry == 'United States' ) {
            originCountry = 'US';
            destinationCountry = 'US';
        }
        
        if(String.isNotBlank(strEndPointURL)) {
            HttpRequest httpRequest = new HttpRequest(); 
            RatingRequest req = new RatingRequest(); 
            System.debug('req:'+ req);
            req.UPSSecurity = new RatingRequest.UPSSecurity();
            req.UPSSecurity.UsernameToken = new RatingRequest.UserNameToken();
            req.UPSSecurity.UsernameToken.Username = 'shwetha2019';
            req.UPSSecurity.UsernameToken.Password = 'Xcentium2019';
            req.UPSSecurity.ServiceAccessToken = new RatingRequest.ServiceAccessToken();
            req.UPSSecurity.ServiceAccessToken.AccessLicenseNumber = '5D725B2017037535';
            System.debug('upsSecurity:'+  req.UPSSecurity.UsernameToken);
            
            req.RateRequest = new RatingRequest.RateRequest();
            req.RateRequest.Request = new RatingRequest.Request();
            req.RateRequest.Request.RequestOption  = 'Rate';

            req.RateRequest.Shipment = new RatingRequest.Shipment();
            req.RateRequest.Shipment.Shipper = new RatingRequest.Shipper();
            req.RateRequest.Shipment.ShipTo = new RatingRequest.ShipTo();
            req.RateRequest.Shipment.ShipFrom = new RatingRequest.ShipFrom();

            req.RateRequest.Shipment.Shipper.Name = 'Test';
            req.RateRequest.Shipment.ShipTo.Name = 'Test';
            req.RateRequest.Shipment.ShipFrom.Name = 'Test';
            req.RateRequest.Shipment.Shipper.ShipperNumber = '1234';

            req.RateRequest.Shipment.Shipper.Address = new RatingRequest.Address();
            req.RateRequest.Shipment.Shipper.Address.AddressLine = new List<String>();
            req.RateRequest.Shipment.Shipper.Address.AddressLine.add( originStreet );
            req.RateRequest.Shipment.Shipper.Address.City = originCity;
            req.RateRequest.Shipment.Shipper.Address.StateProvinceCode = originState;
            req.RateRequest.Shipment.Shipper.Address.PostalCode = originPostalCode;
            req.RateRequest.Shipment.Shipper.Address.CountryCode = originCountry;

            req.RateRequest.Shipment.ShipFrom.Address = new RatingRequest.Address();
            req.RateRequest.Shipment.ShipFrom.Address.AddressLine = new List<String>();
            req.RateRequest.Shipment.ShipFrom.Address.AddressLine.add( originStreet );
            req.RateRequest.Shipment.ShipFrom.Address.City = originCity;
            req.RateRequest.Shipment.ShipFrom.Address.StateProvinceCode = originState;
            req.RateRequest.Shipment.ShipFrom.Address.PostalCode = originPostalCode;
            req.RateRequest.Shipment.ShipFrom.Address.CountryCode = originCountry;

            req.RateRequest.Shipment.ShipTo.Address = new RatingRequest.Address();
            req.RateRequest.Shipment.ShipTo.Address.AddressLine = new List<String>();
            req.RateRequest.Shipment.ShipTo.Address.AddressLine.add( originStreet );
            req.RateRequest.Shipment.ShipTo.Address.City = destinationCity;
            req.RateRequest.Shipment.ShipTo.Address.StateProvinceCode = destinationState;
            req.RateRequest.Shipment.ShipTo.Address.PostalCode = destinationPostalCode;
            req.RateRequest.Shipment.ShipTo.Address.CountryCode = destinationCountry;
            req.RateRequest.Shipment.Service = new RatingRequest.Service();
            req.RateRequest.Shipment.Service.Code = '03';
            req.RateRequest.Shipment.Service.Description = 'test';
            req.RateRequest.Shipment.Package_Z = new RatingRequest.Package_Z();
            req.RateRequest.Shipment.Package_Z.PackagingType = new RatingRequest.Service();
            req.RateRequest.Shipment.Package_Z.PackagingType.Code = '02';
            req.RateRequest.Shipment.Package_Z.PackagingType.Description = 'test';
            req.RateRequest.Shipment.Package_Z.PackageWeight = new RatingRequest.PackageWeight();
            req.RateRequest.Shipment.Package_Z.PackageWeight.UnitOfMeasurement = new RatingRequest.Service();
            req.RateRequest.Shipment.Package_Z.PackageWeight.UnitOfMeasurement.Code ='Lbs';
            req.RateRequest.Shipment.Package_Z.PackageWeight.UnitOfMeasurement.Description = 'pounds';
            req.RateRequest.Shipment.Package_Z.PackageWeight.Weight = '1';
            
            String jsonStringinput  = '';
            
            
            jsonStringinput = JSON.serialize( req );
            jsonStringinput = jsonStringinput.replace('Package_Z','Package');


            System.debug('jsonStringinput:'+ jsonStringinput);
           
            httpRequest.setEndpoint(strEndPointURL);
            httpRequest.setMethod('POST');   
            httpRequest.setHeader('Content-Type', 'application/json');       
            httpRequest.setBody( jsonStringinput );
            try {  
                Http http = new Http();   
                HttpResponse httpResponse = http.send(httpRequest);  
                System.debug('httpResponse.getStatusCode():'+ httpResponse.getStatusCode());
                while(httpResponse.getStatusCode() == 302) {
                    httpRequest.setEndpoint(httpResponse.getHeader('Location'));
                    httpResponse = new Http().send(httpRequest);
                }

                if (httpResponse.getStatusCode() == 200 ) {  
                    strResponse = httpResponse.getBody();
                    if ( strresponse.contains( 'Error' ) ) {
                          // handle error here  
                    }
                    System.debug('strResponse:'+ strResponse);  
                } 
                else {  
                    throw new CalloutException(httpResponse.getBody());  
                }   
            } 
            catch(Exception ex) {  
                throw ex;  
            }  
        } 

        if(!String.isBlank(strResponse)) {
            String currencyCode = '';
            String monetaryValue = '';
            Map<String, Object> data = ( Map<String, Object>) JSON.deserializeUntyped( strResponse );
            Map<String, Object> rateResponse = ( Map<String, Object> ) data.get( 'RateResponse' );
            Map<String, Object> ratedShipment = ( Map<String, Object> ) rateResponse.get( 'RatedShipment' );
            Map<String, Object> transportationCharges = ( Map<String, Object> ) ratedShipment.get( 'TransportationCharges' );
            if ( transportationCharges != null ) {
                currencyCode = ( String )transportationCharges.get( 'CurrencyCode' );
                monetaryValue = ( String )transportationCharges.get( 'MonetaryValue' ); 
                mapCurrencyAndMonetaryValue.put( currencyCode, monetaryValue );
            }
            System.debug('mapCurrencyAndMonetaryValue:'+ mapCurrencyAndMonetaryValue);
            


            mapJsonData = (map<String, Object>)JSON.deserializeUntyped(strResponse);
            System.debug('mapJsonData ===> '+mapJsonData);
        }

       return mapCurrencyAndMonetaryValue;
    }
}