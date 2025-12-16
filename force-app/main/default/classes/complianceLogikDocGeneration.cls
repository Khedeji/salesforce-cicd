global with sharing class complianceLogikDocGeneration {
    public complianceLogikDocGeneration() {

    }


    global class ResponseWrapper{
        public Integer StatusCode; 
        public String Success;
        public Object Response;
        public Datetime DTStamp;
    }


    private RestResponse createResponse(RestResponse response, ResponseWrapper wrapper) {
        response.responseBody = Blob.valueOf(JSON.serializePretty(wrapper));
        response.addHeader('Content-Type', 'application/json');
        return response;
    }

   /**
     * Updates the Logik Lead record with the provided document URL and returns the record ID.
     *
     * @param requestBody The map containing LeadId, LenderName, RelatedDocURL, and PlanName.
     * @return String Updated Logik Lead record ID.
     * @throws Exception if required fields are missing or if DML operations fail.
     */
    private String updateLeadLogikForURL(Map<String, Object> requestBody) {
        String error = '';
        try {
            // Retrieve and validate required fields from requestBody
            Id LeadID = (Id) requestBody.get('LeadId');
            String LenderName = (String) requestBody.get('LenderName');
            String RelatedDocURL = (String) requestBody.get('RelatedDocURL');
            String PlanName = (String) requestBody.get('PlanName');
            system.debug('LeadID : '+LeadID);
            // Validate that all required fields are present
            if (LeadID == null || String.isBlank(RelatedDocURL) || String.isBlank(PlanName)) {
                throw new IllegalArgumentException('Missing required fields in request body.');
            }

            // Fetch the Plan record by its name, assuming PlanServices.getPlanByName can throw an exception
            Plans__c PlanRecord = PlanServices.getPlanByName(PlanName);
            if (PlanRecord == null) {
                throw new IllegalArgumentException('No matching Plan record found for PlanName: ' + PlanName);
            }

            // Retrieve the Logik Lead record matching the LeadID and Plan ID
            Logik_Leads__c LogikLeadsObj = [
                SELECT Id, Document_URL__c
                FROM Logik_Leads__c
                WHERE Lead_Logik__c = :LeadID AND Plans_Eligible__c = :PlanRecord.Id LIMIT 1
            ];

            // Update the Document URL field with the provided RelatedDocURL
            LogikLeadsObj.Document_URL__c = RelatedDocURL;
            update LogikLeadsObj;

            // Return the updated Logik Lead record ID
            return LogikLeadsObj.Id;
        } catch (QueryException e) {
            error += 'No Logik Lead record found matching the provided criteria: ' + e.getMessage();
            system.debug('No Logik Lead record found matching the provided criteria: ' + e.getMessage());
        } catch (DmlException e) {
            error += 'No Logik Lead record found matching the provided criteria: ' + e.getMessage();
            system.debug('No Logik Lead record found matching the provided criteria: ' + e.getMessage());
        } catch (Exception e) {
            error += 'No Logik Lead record found matching the provided criteria: ' + e.getMessage();
            system.debug('No Logik Lead record found matching the provided criteria: ' + e.getMessage());
        }
        return error;
    }

    /**
     * Updates the compliance log for a Logik Lead record with a generated document URL.
     *
     * @param dataMap The map containing the request body.
     * @return RestResponse with status and message regarding the update operation.
     */
    public RestResponse updateComplianceLogikDocGeneration(Map<String, Object> dataMap) {
        // Initialize response structure
        ResponseWrapper respWrapper = new ResponseWrapper();
        RestResponse mainResponse = RestContext.response;
        respWrapper.StatusCode = 200;
        respWrapper.Success = 'True';
        respWrapper.Response = 'Record Updated QC : ';
        respWrapper.DTStamp = DateTime.now();

        // Extract and validate the request body from dataMap
        Map<String, Object> requestBody = (Map<String, Object>) dataMap.get('body');
        if (requestBody == null || requestBody.isEmpty()) {
            respWrapper.StatusCode = 404;
            respWrapper.Success = 'False';
            respWrapper.Response = 'Request Body Not Found!';
            return createResponse(mainResponse, respWrapper);
        }

        try {
            // Update the Logik Lead record and append the updated record ID to the response
            String updatedRecord = updateLeadLogikForURL(requestBody);
            respWrapper.Response += updatedRecord;
        } catch (Exception e) {
            respWrapper.StatusCode = 500;
            respWrapper.Success = 'False';
            respWrapper.Response = 'An unexpected error occurred during update.';
        }

        return createResponse(mainResponse, respWrapper);
    }




}