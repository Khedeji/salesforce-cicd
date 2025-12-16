public class ParkLocator {
    
    // Method to get park names by country
    public static List<String> country(String countryName) {
        // Create an instance of the SOAP service
        ParkService.ParksImplPort service = new ParkService.ParksImplPort();
        
        // Call the byCountry method from the service
        String[] parks = service.byCountry(countryName);
        
        // Convert the array to a list and return it
        return new List<String>(parks);
    }
}