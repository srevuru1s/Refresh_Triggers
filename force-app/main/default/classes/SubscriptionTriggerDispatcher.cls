/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 05-21-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class SubscriptionTriggerDispatcher {
    public static void dispatcher(System.TriggerOperation operationType) {

        switch on operationType {
            WHEN BEFORE_INSERT {
                SubscriptionTriggerHandler.handleBeforeInsert(Trigger.new);
            }
            When BEFORE_UPDATE {
                
            }
            When BEFORE_DELETE {
            
            }
            When AFTER_INSERT {
                SubscriptionTriggerHandler.handleAfterInsert(Trigger.new, (Map<Id,Subscription__c>) Trigger.newMap);
            }
            When AFTER_UPDATE {
                SubscriptionTriggerHandler.handleAfterUpdate((Map<Id,Subscription__c>) Trigger.newMap, (Map<Id,Subscription__c>) Trigger.oldMap);
            }
            When AFTER_DELETE {
                SubscriptionTriggerHandler.handleAfterDelete((Map<Id,Subscription__c>) Trigger.oldMap);
            }
            When AFTER_UNDELETE {
                
            }
            
        }
    }
}