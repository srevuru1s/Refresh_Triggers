/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-13-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class TaskTriggerDispatcher {
    
    public static void dispatcher(System.TriggerOperation operationType) {

        switch on operationType {
            WHEN BEFORE_INSERT {
                TaskTriggerHandler.handleBeforeInsert(Trigger.new);
            }
            When BEFORE_UPDATE {
            
            }
            When BEFORE_DELETE {
            
            }
            When AFTER_INSERT {
                TaskTriggerHandler.handleAfterInsert(Trigger.new);
            }
            When AFTER_UPDATE {
                TaskTriggerHandler.handleAfterUpdate(Trigger.new, (Map<Id,Task>) Trigger.oldMap);
            }
            When AFTER_DELETE {
    
            }
            When AFTER_UNDELETE {
    
            }
            
        }
    }
}