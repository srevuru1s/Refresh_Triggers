/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-25-2024
 * @last modified by  : sagar@salesforce.learning
**/
trigger CaseTrigger on Case (before insert, after insert, before update, after update, before delete, after delete, after undelete) {

    CaseTriggerDispatcher.dispatcher(Trigger.operationType);
}