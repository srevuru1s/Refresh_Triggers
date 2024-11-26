/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-25-2024
 * @last modified by  : sagar@salesforce.learning
**/
trigger LeadTrigger on Lead (before insert, after insert, before update, after update, before delete, after delete, after undelete) {

    LeadTriggerDispatcher.dispatcher(Trigger.operationType);
}