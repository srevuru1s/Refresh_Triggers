/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-25-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class LeadTriggerHandler {
    
    //* Handle Before Update
    //! Whenever a Lead record is updated, set the status to Working-Contacted
    public static void handleBeforeUpdate(List<Lead> newLeads) {

        if (newLeads?.size()>0) {
            for (Lead leadRecord : newLeads) {
                
                leadRecord.Status = 'Working-Contacted';
            }
        }    
    }
}