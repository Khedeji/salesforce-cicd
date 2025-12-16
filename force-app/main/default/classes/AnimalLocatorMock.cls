@IsTest
public class AnimalLocatorMock implements HttpCalloutMock {
    // This method is called during the test to mock the HTTP response
    public HTTPResponse respond(HTTPRequest req) {
        // Create a mock response
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setHeader('Content-Type', 'application/json');
        
        // Example JSON response with a name property
        res.setBody('{"animals":["majestic badger","fluffy bunny","scary bear","chicken"]}');
        res.setStatusCode(200);
        
        return res;
    }
}