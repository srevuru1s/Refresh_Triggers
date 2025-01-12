
List<Account> allAccount = [SELECT Id, Name, Industry FROM Account LIMIT 5000];
System.debug('The size of accounts:' + allAccount.size());

Integer batchSize = 20;

for (Account accountRecord : allAccount) {
    
    
}