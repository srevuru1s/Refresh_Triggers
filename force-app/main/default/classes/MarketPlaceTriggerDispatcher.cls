/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 05-14-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class MarketPlaceTriggerDispatcher {
    
    public static void dispatcher(System.TriggerOperation operationType) {
        switch on operationType {
            WHEN BEFORE_INSERT {
                
            }
            When BEFORE_UPDATE {
                
            }
            When BEFORE_DELETE {
                
            }
            When AFTER_INSERT {
                MarketPlaceTriggerHandler.handleAfterInsert(Trigger.new, (Map<Id,Market_Place__c>)Trigger.newMap);
            }
            When AFTER_UPDATE {
                MarketPlaceTriggerHandler.handleAfterUpdate((Map<Id,Market_Place__c>)Trigger.oldMap, (Map<Id,Market_Place__c>)Trigger.newMap);
            }
            When AFTER_DELETE {
                MarketPlaceTriggerHandler.handleAfterDelete((Map<Id,Market_Place__c>)Trigger.oldMap);
            }
            When AFTER_UNDELETE {
    
            }
            
        }
    }
}