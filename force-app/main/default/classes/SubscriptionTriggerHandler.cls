/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-22-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class SubscriptionTriggerHandler {
    
    //* Handle before insert
    public static void handleBeforeInsert(List<Subscription__c> newSubscriptions) {

    }

    //* Handle after insert
    public static void handleAfterInsert(List<Subscription__c> newSubscriptions, Map<Id,Subscription__c> newMapSubscriptions) {
        
        SubscriptionTriggerHelper.createFeatureRecords(newSubscriptions, newMapSubscriptions);
    }
    
    //* Handle After Update
    public static void handleAfterUpdate(Map<Id,Subscription__c> newMapSubscriptions, Map<Id,Subscription__c> oldMapSubscriptions) {
        SubscriptionTriggerHelper.updateFeatureRecords(newMapSubscriptions, oldMapSubscriptions);
    }
}