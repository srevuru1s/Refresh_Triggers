/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-29-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class QueueableApex2 implements System.Queueable {
    
    public List<Id> accountId;
    //* Constructor
    public QueueableApex2(List<Id> accountIds) {

        this.accountId = accountIds;
    }
    //* execute method
    public void execute(System.QueueableContext ctx) {
        
        System.debug('getJobId from context variable :' + ctx.getJobId());

        List<Account> queryAccounts = [SELECT Id, Name FROM Account WHERE Id IN : this.accountId WITH USER_MODE LIMIT 50000];

        if (queryAccounts?.size() > 0) {
            
            for (Account accRecord : queryAccounts) {
                
                accRecord.Async_Apex__c = 'Queue Apex';
            }
            
            update as user queryAccounts;
        }
    }    
}