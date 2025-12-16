public with sharing class AssistantChatController {
    @AuraEnabled(cacheable=false)
    public static String getAIResponse(String question, String sessionId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://111.118.247.45:3005/api/chat');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(10000);
        // Include sessionId in the body
        request.setBody('{"message":' + JSON.serialize(question) + ', "sessionId":' + JSON.serialize(sessionId) + '}');
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                if (result.containsKey('response')) {
                    return (String)result.get('response');
                } else {
                    return 'Sorry, I could not understand.';
                }
            } else {
                return 'Error: ' + response.getStatusCode() + ' - ' + response.getStatus();
            }
        } catch (Exception e) {
            return 'Error contacting AI service: ' + e.getMessage();
        }
    }
}