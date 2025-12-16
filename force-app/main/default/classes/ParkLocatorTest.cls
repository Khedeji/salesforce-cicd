@IsTest
public class ParkLocatorTest {
    
    @IsTest
    static void testCountryWithResults() {
        // Set up the SOAP mock
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        
        // Call the method to test with a valid country name
        List<String> parks = ParkLocator.country('United States');
        
        // Verify the result
        System.assertEquals(3, parks.size());
        System.assertEquals('Yellowstone', parks[0]);
        System.assertEquals('Yosemite', parks[1]);
        System.assertEquals('Grand Canyon', parks[2]);
    }
    
    @IsTest
    static void testCountryWithNoResults() {
        // Mock a scenario where no parks are returned
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        
        // Call the method with a country name expecting no results
        List<String> parks = ParkLocator.country('Atlantis');
        
        // Verify that an empty list is returned
        System.assertEquals(0, parks.size());
    }
}