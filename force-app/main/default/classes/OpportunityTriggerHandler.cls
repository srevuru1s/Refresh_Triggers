/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 09-10-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class OpportunityTriggerHandler {
    //* Handle Before Insert
    public static void handleBeforeInsert(List<Opportunity> newOpportunities) {
        OpportunityTriggerHelper.updateHighestAmount(newOpportunities);
        OpportunityTriggerHelper.splitAccountAmountToNewOpportunitiesEvenly(newOpportunities);
    }
    //* Handle Before Update

    public static void handleBeforeUpdate(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldMapOpportunities) {

        OpportunityTriggerHelper.updateTriggerAmount(newOpportunities, oldMapOpportunities);
    }
    //* Handle After Delete

    public static void handleAfterDelete(List<Opportunity> oldOpportunities, Map<Id, Opportunity> oldMapOpportunities) {
        OpportunityTriggerHelper.createTaskToOpportunityOwner(oldOpportunities, oldMapOpportunities);
        OpportunityTriggerHelper.updateAccountWithHighestOpportunity(oldOpportunities, oldMapOpportunities);
    }
    //* Handle After Update
    
    //!When Opp is closed won, create a Task for the Opp owner 
    public static void handleAfterUpdate(List<Opportunity> newOpportunities, Map<Id,Opportunity> newMapOpportunities, Map<Id,Opportunity> oldMapOpportunities) {
        //* Update account field with highest opp name
        OpportunityTriggerHelper.updateAccountWithHighestOpportunity(newOpportunities, newMapOpportunities);
        
        //* Method to add team members to opp
        OpportunityTriggerHelper.addOpportunityTeamMembers(newOpportunities);

        List<Task> newTasksForOpportunity = new List<Task>();

        if (newOpportunities?.size()>0) {
            for (Opportunity opportunityRecord : newOpportunities) {
                
                if (opportunityRecord.StageName == 'Closed Won') {
                    
                    Task taskRecord = new Task(
                        Priority    = 'High', 
                        Subject     = 'Split the opp Amount',
                        OwnerId     = opportunityRecord.OwnerId,
                        WhatId      = opportunityRecord.Id,
                        Status      = 'Not Started',
                        Description = 'Updated from Trigger'  
                    );

                    newTasksForOpportunity.add(taskRecord);
                }
            }

            if (newTasksForOpportunity?.size()>0) {
                
                ErrorHandler.handleInsertExceptions(newTasksForOpportunity);
            }    
        }

        //* Remove Opportunity Team Members
        OpportunityTriggerHelper.removeOpportnityTeam(newOpportunities,oldMapOpportunities);
    }

    //* Handle Before Delete
    public static void handleBeforeDelete(List<Opportunity> oldOpportunities, Map<Id,Opportunity> oldMapOpportunities) {

        //* Testing the Trigger.old variables
        Set<Id> accountId = new Set<Id>();

        if (oldOpportunities?.size() > 0) {
            
            for (Opportunity opportunityRecord : oldOpportunities) {
                accountId.add(opportunityRecord.AccountId);
            }
            
            for (Account accountRecord : [SELECT Id, OwnerId FROM Account WHERE Id IN :accountId]) {

                System.debug('I have found the account owner :' + accountRecord.OwnerId);
            }

            List<Opportunity> oppList = [SELECT Id, Name FROM Opportunity WHERE Id IN : oldOpportunities];
            System.debug('Query from the old opps :' + oppList.size());
            
        }
    }

    //* Handle After Insert
    public static void handleAfterInsert(List<Opportunity> newOpportunities, Map<Id,Opportunity> newMapOpportunities) {
        OpportunityTriggerHelper.updateAccountWithHighestOpportunity(newOpportunities, newMapOpportunities);
       // OpportunityTriggerHelper.splitAccountAmountToOldOpportunitiesEvenly(newMapOpportunities);
    }
}