/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-25-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class ContactTriggerDispatcher {

    public static void dispatcher(System.TriggerOperation operationType) {

        switch on operationType {
            
            WHEN BEFORE_INSERT {
                
                ContactTriggerHandler.handleBeforeInsert(Trigger.new);
            }
            WHEN BEFORE_UPDATE {
                
            }
            WHEN BEFORE_DELETE {
                
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