@IsTest
private class AnimalLocatorTest {
    
    @IsTest
    static void testGetAnimalNameById() {
        // Set up the mock callout for a successful response
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        
        // Call the method to test
        String animalName = AnimalLocator.getAnimalNameById(1);
        
        // Verify the result
        System.assertEquals('Lion', animalName);
    }
}