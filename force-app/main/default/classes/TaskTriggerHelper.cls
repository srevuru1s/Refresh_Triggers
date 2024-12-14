/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-13-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class TaskTriggerHelper {

    public static void addNumberOfTasksOnContact(List<Task> newTasks) {

        //* Collect the Map tasks related to contact records where we need to update the field
        Map<Id,Task> taskIdToContact = new Map<Id,Task>();
        //* List of contact records that need to be updated

        if (newTasks?.size() > 0) {
            for (Task newTaskRecord : newTasks) {
                    
                if (newTaskRecord.WhoId != null && newTaskRecord.WhoId.toString().startsWith('003') ) {
                        
                    taskIdToContact.put(newTaskRecord.WhoId, newTaskRecord);
                }           
            }
        }
        
        //* query total number of Tasks associated with contact
        if (taskIdToContact?.size() > 0) {
            
            List<Contact> listContactToUpdate = aggregateQueryForTask(taskIdToContact.keySet());

            //* update the contact record 
            if (listContactToUpdate?.size() > 0) {
                ErrorHandler.handleUpdateExceptions(listContactToUpdate);
            }
        }


    }

    public static void updateNumberOfTaskOnContact(List<Task> newTasks, Map<Id,Task> oldMapTasks) {

        Map<Id,Task> newContactIdTask = new Map<Id,Task>();
        Set<Id> oldContactId = new Set<Id>();

        if (newTasks?.size() > 0) {
            for (Task newTaskRecord : newTasks) {
                
                //* check the contact updated on the case?
                if ( newTaskRecord.WhoId != null && newTaskRecord.WhoId != oldMapTasks.get(newTaskRecord.Id).WhoId ) {

                    newContactIdTask.put(newTaskRecord.WhoId, newTaskRecord);
                    oldContactId.add(oldMapTasks.get(newTaskRecord.Id).WhoId);

                } else if (newTaskRecord.WhoId != oldMapTasks.get(newTaskRecord.Id).WhoId && !(newTaskRecord.WhatId.toString().contains('003'))) {

                    oldContactId.add(oldMapTasks.get(newTaskRecord.Id).WhoId);
                }
            }
        }

        //* Call the addNumberOfTask Method to update the new Task Record
        if (newContactIdTask?.size() > 0) {
            addNumberOfTasksOnContact(newContactIdTask.values());
        }
        //* Updating the old contact records
        if (oldContactId?.size() > 0) {
            //* query all the Task records associated with the contactId
            List<Contact> listContactToUpdate = aggregateQueryForTask(oldContactId);

            if (listContactToUpdate?.size() > 0) {
                ErrorHandler.handleUpdateExceptions(listContactToUpdate);
            }
        }
    }

    public static List<Contact> aggregateQueryForTask(Set<Id> listTaskContactId) {
        
        List<Contact> listContactToUpdate = new List<Contact>();

        if (listTaskContactId?.size() > 0) {

            List<AggregateResult> totalTasksForContact = [SELECT Count(ID) numberOfTasks, WhoId contactId FROM Task WHERE WhoId IN : listTaskContactId WITH USER_MODE GROUP BY WhoId ];

            if (totalTasksForContact.size() > 0) {

                for (AggregateResult taskAggResult : totalTasksForContact) {

                    Integer totalTasks = (Integer) taskAggResult.get('numberOfTasks');
                    Id taskContactId = (Id) taskAggResult.get('contactId');
                    
                    Contact updateContactRecord = new Contact();
                    updateContactRecord.Number_of_Tasks_Associated__c = 0;
                    updateContactRecord.Number_of_Tasks_Associated__c += totalTasks;
                    updateContactRecord.Id = taskContactId;
    
                    listContactToUpdate.add(updateContactRecord);
                }
            } else {
                for (Id contactId : listTaskContactId) {
                    
                    Contact updateContactRecord = new Contact();
                    updateContactRecord.Number_of_Tasks_Associated__c = 0;
                    updateContactRecord.Id = contactId;
    
                    listContactToUpdate.add(updateContactRecord);
                }
            }
            
        }
        return listContactToUpdate;
        
    }
}
