/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-26-2024
 * @last modified by  : sagar@salesforce.learning
**/
trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete, after delete, after undelete) {

    AccountTriggerDispatcher.dispatcher(Trigger.operationType);
}