/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 05-12-2025
 * @last modified by  : sagar@salesforce.learning
**/
trigger MarketPlaceTrigger on Market_Place__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {

    MarketPlaceTriggerDispatcher.dispatcher(Trigger.operationType);
}