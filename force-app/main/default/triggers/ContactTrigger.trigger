/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-25-2024
 * @last modified by  : sagar@salesforce.learning
**/
trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    ContactTriggerDispatcher.dispatcher(Trigger.operationType);
    
}