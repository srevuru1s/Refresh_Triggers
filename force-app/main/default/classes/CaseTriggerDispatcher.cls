/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 02-28-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class CaseTriggerDispatcher {
    
    public static void dispatcher(System.TriggerOperation operationType) {

        switch on operationType {
            
            WHEN BEFORE_INSERT {
                
                CaseTriggerHandler.handleBeforeInsert(Trigger.new);
            }
            WHEN BEFORE_UPDATE {

            }
            WHEN BEFORE_DELETE {
                CaseTriggerHandler.handleBeforeDelete(Trigger.old);
            }
            WHEN AFTER_INSERT {
                
            }
            WHEN AFTER_UPDATE {

            }
            WHEN AFTER_DELETE {

            }
            WHEN AFTER_UNDELETE {

            }
        }
    }
}