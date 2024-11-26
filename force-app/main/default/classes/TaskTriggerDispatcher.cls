/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-24-2024
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
        
            }
            When AFTER_UPDATE {
    
            }
            When AFTER_DELETE {
    
            }
            When AFTER_UNDELETE {
    
            }
            
        }
    }
}