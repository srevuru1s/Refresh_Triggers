/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-26-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class AccountTriggerDispatcher {
    
    public static void dispatcher(System.TriggerOperation operationType) {

        switch on operationType {
            WHEN BEFORE_INSERT {
            
            }
            When BEFORE_UPDATE {
                AccountTriggerHandler.handleBeforeUpdate(Trigger.new, (Map<Id, Account>) Trigger.oldMap);
            }
            When BEFORE_DELETE {
            
            }
            When AFTER_INSERT {
        
            }
            When AFTER_UPDATE {
                AccountTriggerHandler.handleAfterUpdate(Trigger.new, (Map<Id, Account>) Trigger.newMap, (Map<Id, Account>) Trigger.oldMap);
            }
            When AFTER_DELETE {
    
            }
            When AFTER_UNDELETE {
    
            }
            
        }
    }
}