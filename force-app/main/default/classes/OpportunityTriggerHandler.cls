/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-25-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class OpportunityTriggerHandler {
    
    //* Handle Before Update

    public static void handleBeforeUpdate(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldMapOpportunities) {

        if (newOpportunities?.size() > 0) {

            for (Opportunity opportunityRecord : newOpportunities) {
                //* condition to check the opp stage is Modified
                if (opportunityRecord.StageName != oldMapOpportunities.get(opportunityRecord.Id).StageName) {
                    opportunityRecord.Amount  = (opportunityRecord.Probability * opportunityRecord.ExpectedRevenue);
                    opportunityRecord.Description = 'Updated From Trigger';
                    
                }
            }
        }
    }
    //* Handle After Update
    
    //!When Opp is closed won, create a Task for the Opp owner 
    public static void handleAfterUpdate(List<Opportunity> newOpportunities) {
        
        List<Task> newTasksForOpportunity = new List<Task>();

        if (newOpportunities?.size()>0) {
            for (Opportunity opportunityRecord : newOpportunities) {
                
                if (opportunityRecord.StageName == 'Closed Won') {
                    
                    Task taskRecord = new Task(
                        Priority  = 'High', 
                        Subject   = 'Please Split the Revenue of opportunity',
                        OwnerId   = opportunityRecord.OwnerId,
                        WhatId    = opportunityRecord.Id,
                        Status    = 'Not Started');

                    newTasksForOpportunity.add(taskRecord);
                }
            }

            if (newTasksForOpportunity?.size()>0) {
                
                ErrorHandler.handleInsertExceptions(newTasksForOpportunity);
            }    
        }
    }
}