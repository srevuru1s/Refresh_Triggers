Account acc = [SELECT Id, Name FROM Account LIMIT 1];
System.debug('Main :' + acc);
Account copy = acc.clone(true, true, true, false);
System.debug('Copy :' + copy);
System.debug('get method:' + acc.get('Name'));
System.debug('get method:' + acc.get(Account.Name));

Account acc1 = new Account(Name = 'Sagar');
Database.DMLOptions options = acc1.getOptions();
System.debug('DML Options:' + options);

Contact con = [SELECT Id, Account.Name FROM Contact LIMIT 1];
System.debug('Account Name :' + con.Account.Name);
Schema.SObjectType objType = con.getSObjectType();
System.debug('Object Type :' + objType);