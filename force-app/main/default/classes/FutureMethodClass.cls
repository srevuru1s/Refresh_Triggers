/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-29-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class FutureMethodClass {
    
    public FutureMethodClass() {
        System.debug('This class is for calling a future method');
    }

    @future
    public static void updateAccount(List<Id> accountIds) {
        
        List<Account> updatedAccountList = [SELECT Id, Name, Async_Apex__c FROM Account WHERE Id IN : accountIds 
                                            WITH USER_MODE LIMIT 50000];
        for (Account acc : updatedAccountList) {
            acc.Async_Apex__c     = 'Batch Apex';
        }
        update as user updatedAccountList;
        
        //* calling queueable-apex
        List<Id> accIds = new List<Id>{'001aj00000ruyRRAAY', '001aj00000ruyRSAAY'};
        QueueableApex queueApex = new QueueableApex(accIds);
        //* To get the job id of queueable apex
        Id jobId = System.enqueueJob(queueApex);
        System.debug('Job Id :' + jobId);
    }
}