public class ApiHelper {
	public static Map<String,String> ParameterExtractor(String inputString) {
        // Initialize the values to null or empty string
        Map<String,String> GetParams = new Map<String,String>();
                
        // Split the input string by '&' to get individual key-value pairs
        List<String> pairs = inputString.split('&');
        
        // Loop through each pair
        for (String pair : pairs) {
            // Split each pair by '=' to get the name and value
            List<String> nameValue = pair.split('=');
            
            if (nameValue.size() == 2) {
                String name = nameValue[0];
                String value = nameValue[1];
                GetParams.put(name,value);
            }
        }
        return GetParams;
    }
}