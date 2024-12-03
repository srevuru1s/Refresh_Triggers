/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-29-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class LeadTriggerHandler {
    
    //* Handle Before Update
    //! Whenever a Lead record is updated, set the status to Working-Contacted
    public static void handleBeforeUpdate(List<Lead> newLeads, Map<Id, Lead> oldMapLeads) {

        if (newLeads?.size()>0) {
            for (Lead leadRecord : newLeads) {
                
                leadRecord.Status = 'Working-Contacted';
            }
        }    
    }

    //* Handle before delete 
    public static void handleBeforeDelete(List<Lead> oldLeads) {
        
        //* Don'e delete the records where the status is Working-Contacted'
        if (oldLeads?.size()>0) {
            for (Lead leadRecord : oldLeads) {
                if (leadRecord.Status == 'Working-Contacted') {
                    leadRecord.Status.addError('You can not delete the Lead which is Working-Contacted');
                }
                
            }
        }
    }
}