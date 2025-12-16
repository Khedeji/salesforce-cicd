public abstract class APIServicesM {
    
    // Abstract method to get records
    //public abstract List<SObject> getRecords(Map<String, Object> dataMap);
    //public abstract List<Map<String,Object>> getRecords(String objectName, Map<String, Object> dataMap);

    // Static Method to call the
    public static Map<String,Object> requestContext(RestRequest req, String reqType){
        String requestURI = req.requestURI;
        List<String> urlPram =  requestURI.split('/');
                
        Map<String,Object> MapObj = new Map<String,Object>{
                                                        'Link'=>'http://www.salesforce.com',
                                                        'type_of_request'=>'',
                                                        'action_name'=>'',
                                                        'params'=>''
                                                      };
       try{                                           
            if(urlPram[2]!= Null){
                MapObj.put('type_of_request', urlPram[2]);                                                     
            }
            if(urlPram[3]!= Null){
                MapObj.put('action_name', urlPram[3]);
            }
            if(reqType =='GET' && urlPram.size() > 4 && urlPram[4] != null){
                MapObj.put('params', urlPram[4]);
            }
            if(reqType == 'POST'){
                String requestBody = req.requestBody.toString();
                MapObj.put('body', JSON.deserializeUntyped(requestBody));
            }
            return MapObj;
        }   
        catch(Exception E){
            system.debug('The error Reaching out is :'+E);
            return MapObj;
        }
    }

    public static RestResponse handleElse(RestRequest req){
    	RestResponse res = RestContext.response;
        res.statusCode = 400;
        res.responseBody = Blob.valueOf('{"error":"Invalid request"}');
        res.addHeader('Content-Type', 'application/json');
        return res;
    }
}