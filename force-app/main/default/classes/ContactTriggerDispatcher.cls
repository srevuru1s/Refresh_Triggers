/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-13-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class ContactTriggerDispatcher {

    public static void dispatcher(System.TriggerOperation operationType) {

        switch on operationType {
            
            WHEN BEFORE_INSERT {
                
                ContactTriggerHandler.handleBeforeInsert(Trigger.new);
            }
            WHEN BEFORE_UPDATE {
                ContactTriggerHandler.handleBeforeUpdate(Trigger.new, (Map<Id, Contact>)Trigger.oldMap);
            }
            WHEN BEFORE_DELETE {
                
            }
            WHEN AFTER_INSERT {
                ContactTriggerHandler.handleAfterInsert(Trigger.new, (Map<Id,Contact>)Trigger.newMap);
            }
            WHEN AFTER_UPDATE {
                ContactTriggerHandler.handleAfterUpdate((Map<Id,Contact>) Trigger.newMap, (Map<Id,Contact>) Trigger.oldMap);
            }
            WHEN AFTER_DELETE {     
                
            }
            WHEN AFTER_UNDELETE {
                
            }
        }
    }        
}