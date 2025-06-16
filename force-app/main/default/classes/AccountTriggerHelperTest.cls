@isTest
private class AccountTriggerHelperTest {


@IsTest
    static void verifyOwnershipTest() {
        List<Account> accList = new List<Account>();
        Account acc1 = new Account(Name = 'Test Account 1', Industry = 'Agriculture', Type = 'Prospect', Ownership = 'Private');
        Account acc2 = new Account(Name = 'Test Account 2', Industry = 'Energy', Type = 'Customer', Ownership = 'Public');
        accList.add(acc1);
        accList.add(acc2);
        insert accList;

        Test.startTest();
        acc1.Industry = 'Energy';
        acc1.Type = 'Customer';
        update acc1;
        Test.stopTest();

        List<Account> updatedAccounts = [SELECT Id, Industry, Type, Ownership FROM Account WHERE Id = :acc1.Id];
        System.assertEquals('Energy', updatedAccounts[0].Industry, 'Industry should be updated');
        System.assertEquals('Customer', updatedAccounts[0].Type, 'Type should be updated');
        System.assertEquals('Private', updatedAccounts[0].Ownership, 'Ownership should remain unchanged');
    }

}