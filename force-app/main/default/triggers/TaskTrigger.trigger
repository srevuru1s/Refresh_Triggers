/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-24-2024
 * @last modified by  : sagar@salesforce.learning
**/
trigger TaskTrigger on Task (before insert, after insert, before update, after update, before delete, after delete, after undelete) {

    TaskTriggerDispatcher.dispatcher(Trigger.operationType);
}