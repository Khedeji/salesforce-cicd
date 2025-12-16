@RestResource(urlMapping='/api/*/*/*')
global with sharing class RuleEngineWebServices extends APIServicesM {
	@HttpGet
    global static void handleGetRequest(){
       
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
       
        try{           
            // CHECKING WHETHER THE REQUEST IS AUTHENTICATE OR NOT !!            
            /*if (!authenticateRequest(req)) {
                res = handleElse(req);
                return;
            }*/
           
            Map<String,Object> dataMap = requestContext(req,'GET');
            switch on (String)dataMap.get('type_of_request'){
                WHEN 'addwebNotifications'{
                    switch on (String)dataMap.get('action_name') {
                        when  'webNotifications'{
                            system.debug('web Notifications get CallOut!');
                        }
                        when else {
                            system.debug('Web Notification get Else Callout!');
                        }
                    }
                }
            }
			
        }
        Catch(Exception ex){
            System.debug('@@IMP Main GET Exception:\n' + 'line: ' + ex.getLineNumber() + '--\n' + ex.getCause() + '\n' + ex.getMessage());
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('{"error":"' + ex.getMessage() + '"}');
            res.addHeader('Content-Type', 'application/json');     
        }          
    }

    @HttpPost
    global static void handlePostRequest(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
       
        try{           
            // CHECKING WHETHER THE REQUEST IS AUTHENTICATE OR NOT !!            
            /*if (!authenticateRequest(req)) {
                res = handleElse(req);
                return;
            }*/
           
            Map<String,Object> dataMap = requestContext(req,'POST');
            
            switch on (String)dataMap.get('type_of_request'){
                WHEN 'updateLogikLeads'{
                    switch on (String)dataMap.get('action_name'){
                        WHEN 'LogikLeads'{
                            complianceLogikDocGeneration complianceLogikDocGenerationObj = new complianceLogikDocGeneration();
                            complianceLogikDocGenerationObj.updateComplianceLogikDocGeneration(dataMap);
                            // WebNotificationsServices webNotifService = new WebNotificationsServices();
                            // webNotifService.AddwebNotification(dataMap);
                            system.debug('Here 71');
                        }
                        WHEN else{
                            system.debug('Here 74');
                        }
                    }
                }
            }
			
        }
        Catch(Exception ex){
            System.debug('@@IMP Main GET Exception:\n' + 'line: ' + ex.getLineNumber() + '--\n' + ex.getCause() + '\n' + ex.getMessage());
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('{"error":"' + ex.getMessage() + '"}');
            res.addHeader('Content-Type', 'application/json');     
        }
    }
    
}