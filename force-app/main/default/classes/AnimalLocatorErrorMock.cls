@IsTest
public class AnimalLocatorErrorMock implements HttpCalloutMock {
    // This method is called during the test to mock the HTTP response with a non-200 status
    public HTTPResponse respond(HTTPRequest req) {
        // Create a mock error response
        HttpResponse res = new HttpResponse();
        res.setStatusCode(500); // Simulating a server error
        res.setHeader('Content-Type', 'application/json');
        
        res.setBody('{"error":"Internal Server Error"}');
        
        return res;
    }
}