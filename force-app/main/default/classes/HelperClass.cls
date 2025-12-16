/**
* @File Name : HelperClass.cls
* @Description : Helper class
* @Author : Ritik Raghuwanshi
* @Last Modified By : Ritik
* @Last Modified On : July 25, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | July 25, 2025 |   | Initial Version
**/
public class HelperClass {
   
    // Get a map of FieldName and FieldType
    // Map<String, String>
    public static Map<String, String> getObjFieldTypes(String objectApiName) {

        Map<String, String> fieldTypeMap = new Map<String, String>();   
        try {
            Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectApiName);

            if (objType != null) {
                // Get the fields for the object
                Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
                // Iterate through the fields and print information
                for (String fieldName : fieldMap.keySet()) {
                    Schema.DisplayType fieldType = fieldMap.get(fieldName).getDescribe().getType();
                    fieldTypeMap.put(fieldName, String.valueOf(fieldType));
                }
            } else {
                System.debug('Object not found: ' + objectApiName);
            }
        } catch (Exception ex) {
            System.debug('Exception: ' + ex.getMessage());
            fieldTypeMap.put('error', ex.getMessage());
            return fieldTypeMap;
        }
        return fieldTypeMap;
    }
}