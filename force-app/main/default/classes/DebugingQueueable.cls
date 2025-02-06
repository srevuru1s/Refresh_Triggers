/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-29-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class DebugingQueueable {
    
    public static List<Id> accountId = new List<Id>();
    //* execute method
    public void execute(List<Id> accId) {

        accountId = accId;
        List<Account> queryAccounts = [SELECT Id, Name FROM Account WHERE Id IN : accId WITH USER_MODE LIMIT 50000];

        if (queryAccounts?.size() > 0) {
            
            for (Account accRecord : queryAccounts) {
                
                accRecord.Async_Apex__c = 'Queue Apex';
            }
            System.debug('List of record after update :' + queryAccounts);
            update as user queryAccounts;
        }
    }

    public static void end() {
        System.debug('The static variabel :' + accountId);
    }
}