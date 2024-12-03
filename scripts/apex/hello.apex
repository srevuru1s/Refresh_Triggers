Map<Id,Account> accountDetails = new Map<Id, Account> ([SELECT Id, Name FROM Account ]);
System.debug('Account Map:' + accountDetails.size());