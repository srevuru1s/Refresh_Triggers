/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-14-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class TaskTriggerHandler {
    
    //* Handle Before Insert
    public static void handleBeforeInsert(List<Task> newTasks){
        
        //! Whenever a Task is created, set the priority to High
        if (newTasks?.size()>0) {
            for (Task taskRecord: newTasks) {
                taskRecord.Priority = 'High';
            }
        }
    }
    //* Handle After Inset
    public static void handleAfterInsert(List<Task> newTasks) {
        TaskTriggerHelper.addNumberOfTasksOnContact(newTasks);
    }
    
    //* Handle After Update
    public static void handleAfterUpdate(List<Task> newTasks, Map<Id,Task> oldMapTasks) {
        TaskTriggerHelper.updateNumberOfTaskOnContact(newTasks, oldMapTasks);
    }
    //* Handle Before Update
    public static void verifyTaskUpdatePermissionOnAccount(List<Task> newTasks, Map<Id,Task> oldMapTasks) {
        //* Collect the map task records to verify where contact Id as key

        Map<Id,Task> mapTaskRecords = new Map<Id,Task>();

        if (newTasks?.size() > 0) {
            for (Task taskRecord : newTasks) {
                if (taskRecord.WhoId.toString().contains('003')) {
                    
                    mapTaskRecords.put(taskRecord.WhoId, taskRecord);
                }
            }
        }
        //* Query the account field to verify the permission
        if (mapTaskRecords?.size() > 0) {
            Map<Id,Contact> accountDetails = new Map<Id,Contact> ([SELECT Id, Account.Modify_Task_Permission__c FROM Contact WHERE Id IN : mapTaskRecords.keySet() WITH USER_MODE LIMIT 50000]);
            
            if (accountDetails?.size() > 0) {

                for (Contact conRecord : accountDetails.values()) {
                    
                    if (conRecord.Account.Modify_Task_Permission__c == false) {
                        
                        mapTaskRecords.get(conRecord.Id).WhoId.addError('We can\'t edit the record when the contacts account\'s task permission is false');
                    }
                }
            }
            
        }
    }
}