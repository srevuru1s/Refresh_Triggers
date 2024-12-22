/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-21-2024
 * @last modified by  : sagar@salesforce.learning
**/
trigger FeatureTrigger on Feature__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    FeatureTriggerDispatcher.dispatcher(Trigger.operationType);
}