/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-22-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class FeatureTriggerDispatcher {
    public static void dispatcher(System.TriggerOperation operationType) {

        switch on operationType {
            WHEN BEFORE_INSERT {
                
            }
            When BEFORE_UPDATE {
                
            }
            When BEFORE_DELETE {
            
            }
            When AFTER_INSERT {
                FeatureTriggerHandler.updateSubscriptionRecord((Map<Id,Feature__c>) Trigger.newMap);
            }
            When AFTER_UPDATE {
                FeatureTriggerHandler.handleAfterUpdate((Map<Id,Feature__c>) Trigger.newMap, (Map<Id,Feature__c>) Trigger.oldMap);
            }
            When AFTER_DELETE {
    
            }
            When AFTER_UNDELETE {
    
            }
            
        }
    }
}