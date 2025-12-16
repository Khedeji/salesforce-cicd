public class AccountsNames {
    
    public static List<Account> getAccounts(String token) {
        return [
            SELECT Name, AccountNumber
            FROM Account
            WHERE Name LIKE :('%' + token + '%')
        ];
    }

}