/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-29-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class QueueableApex implements System.Queueable, Database.AllowsCallouts{
    
    public List<Id> accountId;
    //* Constructor
    public QueueableApex(List<Id> accountIds) {

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
        //* calling future method
        FutureMethodClass.updateAccount(this.accountId);
        
        //* Calling the second queueable Job
        QueueableApex2 queueApex2 = new QueueableApex2(accountId);
        //* adding the delay to enque job will over rise the org async delay.
        //* minumum delay (0-10 minutes)
        Id jobId2 = System.enqueueJob(queueApex2, 10);
    }
}