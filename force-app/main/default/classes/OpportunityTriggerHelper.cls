    /**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-03-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class OpportunityTriggerHelper {

    //* Update the trigger Amount field
        public static void updateTriggerAmount(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldMapOpportunities) {
            
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
    
        //* Create a Task to Opportunity Account's owner when opp gets deleted'
        public static void createTaskToOpportunityOwner(List<Opportunity> oldOpportunities, Map<Id, Opportunity> oldMapOpportunities) {

            List<Task> newTaskForAccountOwner = new List<Task>();
            Map<Id,Opportunity> mapAccountIdOpportunity = new Map<Id,Opportunity>();

            //* fetch the Account Owner Details 
            for (Opportunity opportunityRecord : oldOpportunities) {
                mapAccountIdOpportunity.put(opportunityRecord.AccountId, opportunityRecord);
            }

            //* Fetch the Opportunity Accounts owner Id
            Map<Id,Account> opportunityAccountDetails = new Map<Id, Account> ([SELECT Id, OwnerId FROM Account WHERE Id IN: mapAccountIdOpportunity.keySet()]);
            
            if (oldOpportunities?.size() > 0) {

                for (Opportunity oldOpportunity : oldOpportunities) {
                    if (oldOpportunity.AccountId != null) {
                        
                        Task newTask = new Task();
                        newTask.OwnerId      = opportunityAccountDetails.get(oldOpportunity.AccountId).OwnerId;
                        newTask.Subject      = 'Created using Apex Trigger';
                        newTask.ActivityDate = System.today();
                        newTask.Description  = 'Opportunity was deleted';
                        newTask.Status       = 'Not Started';
                        newTask.Priority     = 'New';
                        newTask.WhatId       = oldOpportunity.AccountId;
        
                        newTaskForAccountOwner.add(newTask);
                    }
                }
            }

            if (newTaskForAccountOwner?.size() > 0) {
                
                ErrorHandler.handleInsertExceptions(newTaskForAccountOwner);
            }
        }
}