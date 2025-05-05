/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 03-20-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class AccountTriggerDispatcher {
    
    public static void dispatcher(System.TriggerOperation operationType) {

        switch on operationType {
            WHEN BEFORE_INSERT {
                AccountTriggerHandler.handleBeforeInsert(Trigger.new);
            }
            When BEFORE_UPDATE {
                AccountTriggerHandler.handleBeforeUpdate(Trigger.new, (Map<Id, Account>) Trigger.oldMap);
            }
            When BEFORE_DELETE {
                AccountTriggerHandler.handleBeforeDelete(Trigger.old, (Map<Id,Account>) Trigger.oldMap);
            }
            When AFTER_INSERT {
                AccountTriggerHandler.handleAfterInsert(Trigger.new, (Map<Id, Account>)Trigger.newMap);
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