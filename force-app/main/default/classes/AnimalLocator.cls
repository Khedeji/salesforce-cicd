public class AnimalLocator {
    
    // Public static method as required
    public static String getAnimalNameById(Integer id) {
        // Prepare the endpoint URL
        String endpoint = 'https://th-apex-http-callout.herokuapp.com/animals/' + id;
        
        // Create an HTTP request and response
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        Map<String, Object> animal = new Map<String, Object>();
        // Check for success and parse the JSON response to get the name property
        if (res.getStatusCode() == 200) {
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            animal = (Map<String, Object>) jsonResponse.get('animal');
            
            
        }
        return (String) animal.get('name');
    }
}