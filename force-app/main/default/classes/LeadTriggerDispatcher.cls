/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 03-06-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class LeadTriggerDispatcher {
    
    public static void dispatcher(System.TriggerOperation operationType) {

        switch on operationType {
            
            WHEN BEFORE_INSERT {
                LeadTriggerHandler.assignLeadQueue(Trigger.new);
            }
            When BEFORE_UPDATE {
                LeadTriggerHandler.handleBeforeUpdate(Trigger.new, (Map<Id, Lead>) Trigger.oldMap);
            }
            WHEN BEFORE_DELETE {
                LeadTriggerHandler.handleBeforeDelete(Trigger.old);
            }
            WHEN AFTER_INSERT {
            }
            When AFTER_UPDATE {
                LeadTriggerHandler.updateOpportunityStageNameConvertedLead((Map<Id,Lead>) Trigger.newMap, (Map<Id,Lead>) Trigger.oldMap);
            }
            When AFTER_DELETE {
    
            }
            When AFTER_UNDELETE {
    
            }
            
        }
    }
}