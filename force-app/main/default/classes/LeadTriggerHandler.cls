/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 03-06-2025
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

    //* Handle Before delete 
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
    //* Handle Before Insert
    //! Assiign the lead to Leads queue if the Lead Source is Web
    public static void assignLeadQueue(List<Lead> newLeads) {
        
        //* Query the Queue Id
        Id queueId = [SELECT Id, QueueId FROM QueueSobject WITH USER_MODE].QueueId;

        if (newLeads?.size() > 0) {
            
            for (Lead newLeadRecord : newLeads) {
                
                if (newLeadRecord.LeadSource == 'Web' && newLeadRecord.LeadSource != 'None') {
                    newLeadRecord.OwnerId = queueId;
                }
            }
        }
    }
    //* Handle After Update
    //! Create an opportunity record if the Account Industry is Education
    public static void updateOpportunityStageNameConvertedLead(Map<Id,Lead> newMapLead, Map<Id,Lead> oldMapLead) {

        Set<Id> setAccId = new Set<Id>();
        
        if(newMapLead?.size() > 0) {
            
            for(Lead leadRecord : newMapLead.values()) {
                //* check the condition for lead is converted or not
                if(leadRecord.IsConverted && oldMapLead.get(leadRecord.Id)?.IsConverted != leadRecord.IsConverted) {

                    //* collect all the accountIds for the lead record
                    setAccId.add(leadRecord.ConvertedAccountId);
                }
            }
        }
        //* collect the list of opportunities to update
        List<Opportunity> listOpportunityToUpdate = new List<Opportunity>();

        //* Query the opportunity related to accountId to update the stage name
        if(setAccId?.size() > 0) {
            for(Opportunity oppRecord : [SELECT Id FROM Opportunity WHERE AccountId IN: setAccId WITH USER_MODE LIMIT 50000]) {

                Opportunity opp = new Opportunity();
                opp.Id          = oppRecord.Id;
                opp.StageName   = 'Qualification';

                listOpportunityToUpdate.add(opp);
            }
        }

        if(listOpportunityToUpdate?.size()> 0) {

            ErrorHandler.handleUpdateExceptions(listOpportunityToUpdate);
        }
    }
}