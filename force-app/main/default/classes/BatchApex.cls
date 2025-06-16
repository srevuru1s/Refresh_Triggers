/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 06-11-2025
 * @last modified by  : sagar@salesforce.learning
**/
global with sharing class BatchApex implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful, Schedulable{

    public String filterField; //* Class variable
    //* Constructor 
    public BatchApex(String queryField) {
        this.filterField = queryField;
    }
    //* Start Method
    public Database.QueryLocator start(Database.BatchableContext batchContext) {
        
        System.debug('The id for the main batch :' + batchContext);
        String filterField = 'Hello'; //*Just to know that we have to use this keyword if we need to acces class variable
                
        //*Construct the dynamic query or we can pass directly the query in locator
        //String query = 'SELECT Id FROM Account WHERE Async_Apex__c != \'' + this.filterField +'\'' ;
        return Database.getQueryLocator('SELECT Id FROM Account WHERE Async_Apex__c !=: this.filterField LIMIT 50000');
    }
    //* Execute Method
    public void execute(Database.BatchableContext bc, List<sObject> sObjectList) {

        List<sObject> listAllRecords = new List<sObject>(); 
        if (sObjectList?.size() > 0) {
            for (sObject accRecord : sObjectList) {
                
                Schema.SObjectType typeOfSObject = accRecord.getSObjectType();
                
                if(typeOfSObject == Account.SObjectType) {

                    Account myAcc = (Account) accRecord;
                    myAcc.Async_Apex__c = 'Future Apex';
                    //Account acc = new Account(Id = accRecord.Id, Async_Apex__c = 'Future Apex');
                    listAllRecords.add(myAcc);
                }

            }
        }

        if (listAllRecords?.size() > 0) {
            
            ErrorHandler.handleUpdateExceptions(listAllRecords);
        }
        System.debug('The main batch Id :' + bc.getJobId());
        System.debug('The child batch Id :' + bc.getChildJobId());
    }

    public void finish(Database.BatchableContext batchContext) {

        System.debug('The batch Id has been completed :' + batchContext.getJobId());
    }

    global void execute(System.SchedulableContext sc) {
        Id BatchJobId = Database.executeBatch(new BatchApex('Batch Apex'), 10);
    }
    //* Fianlly after a gap
}