/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-01-2024
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
                
            }
            when AFTER_UPDATE {
                OpportunityTriggerHandler.handleAfterUpdate(Trigger.new);
            }
            when AFTER_DELETE {
                OpportunityTriggerHandler.handleAfterDelete(Trigger.old, (Map<Id, Opportunity>) Trigger.oldMap);
            }
            when AFTER_UNDELETE {
            }
        }
    }    
}