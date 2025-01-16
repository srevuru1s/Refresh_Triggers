/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-14-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class OpportunityTriggerDispatcher {
    public static void dispatcher(System.TriggerOperation triggerOperationType) {

        switch on triggerOperationType {
            when BEFORE_INSERT {
                
            }
            when BEFORE_UPDATE {
                OpportunityTriggerHandler.handleBeforeUpdate(Trigger.new, (Map<Id, Opportunity>)Trigger.oldMap);
            }
            when BEFORE_DELETE {
                OpportunityTriggerHandler.handleBeforeDelete(Trigger.old, (Map<Id,Opportunity>) Trigger.oldMap);
            }
            when AFTER_INSERT {
                OpportunityTriggerHandler.handleAfterInsert(Trigger.new, (Map<Id, Opportunity>)Trigger.newMap);
            }
            when AFTER_UPDATE {
                OpportunityTriggerHandler.handleAfterUpdate(Trigger.new, (Map<Id,Opportunity>) Trigger.newMap, (Map<Id,Opportunity>) Trigger.oldMap);
            }
            when AFTER_DELETE {
                OpportunityTriggerHandler.handleAfterDelete(Trigger.old, (Map<Id, Opportunity>) Trigger.oldMap);
            }
            when AFTER_UNDELETE {
            }
        }
    }    
}