/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-25-2024
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
}