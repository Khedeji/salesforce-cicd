public class StringListTest {
     // Public static method that returns a list of strings
    public static List<String> generateStringList(Integer numberOfStrings) {
        // Initialize an empty list to store the strings
        List<String> resultList = new List<String>();
        
        // Loop from 0 to the given number of strings
        for (Integer i = 0; i < numberOfStrings; i++) {
            // Add the formatted string to the list
            resultList.add('Test ' + i);
        }
        
        // Return the list of strings
        return resultList;
    }

}