Map<Id,Contact> accountDetails = new Map<Id,Contact> ([SELECT Id, Account.Modify_Task_Permission__c FROM Contact WITH USER_MODE LIMIT 50000]);
for (Contact con : accountDetails.values()) {
    System.debug('The field value:' + accountDetails.get(con.Id));
}
