@IsTest
global class ParkServiceMock implements WebServiceMock {
    
    // This method is called during the test to mock the SOAP response
    public void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNs,
        String responseName,
        String responseType
    ) {
        // Create a mock response object
        ParkService.byCountryResponse response_x = new ParkService.byCountryResponse();
        
        // Mocking park names for the given country
        response_x.return_x = new String[]{'Yellowstone', 'Yosemite', 'Grand Canyon'};
        
        // Add the mock response to the response map
        response.put('response_x', response_x);
    }
}