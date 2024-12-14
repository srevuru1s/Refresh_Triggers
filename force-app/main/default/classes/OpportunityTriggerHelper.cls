    /**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-09-2024
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

        //* Remove Opportunity Team Members when Opportunity is set to closed lost
        public static void removeOpportnityTeam(List<Opportunity> newOpportunities, Map<Id,Opportunity> oldMapOpportunities) {
            Map<Id,Opportunity> mapClosedLostOpportunities = new Map<Id,Opportunity>();

            if (newOpportunities?.size() > 0) {

                for (Opportunity opportunityRecord : newOpportunities) {
                    if (opportunityRecord.StageName == 'Closed Lost') {
                        mapClosedLostOpportunities.put(opportunityRecord.Id, opportunityRecord);
                    }
                }
            }

            if (mapClosedLostOpportunities?.size() > 0) {
                //Query the opp team records
                Map<Id,OpportunityTeamMember> mapOppTeamMembers = new Map<Id,OpportunityTeamMember>([SELECT Id FROM OpportunityTeamMember WHERE OpportunityId IN :mapClosedLostOpportunities.keySet() WITH USER_MODE LIMIT 50000]);
                
                if (mapOppTeamMembers?.size() > 0) {

                    ErrorHandler.handleDeleteExceptions(mapOppTeamMembers.values());
                }
            }
        }

        //* Add the Opportunity Teams when Opp updates to Needs Analysis
        public static void addOpportunityTeamMembers(List<Opportunity> newOpportunity) {
            
            List<OpportunityTeamMember> listNewTeamMembers = new List<OpportunityTeamMember>();

            if (newOpportunity?.size() > 0) {
                //* check for the condition 
                for (Opportunity newRecordOpportunity : newOpportunity) {
                    if (newRecordOpportunity.StageName == 'Needs Analysis') {
                        
                        OpportunityTeamMember newTeamMembers  = new OpportunityTeamMember();
                        newTeamMembers.OpportunityId          = newRecordOpportunity.Id;
                        newTeamMembers.TeamMemberRole         = 'Account Manager';
                        newTeamMembers.UserId                 = UserInfo.getUserId();
                        newTeamMembers.OpportunityAccessLevel = 'Read';

                        listNewTeamMembers.add(newTeamMembers);
                    }
                }
            }
            
            if (listNewTeamMembers?.size() > 0) {
                ErrorHandler.handleInsertExceptions(listNewTeamMembers);
            }


        }

}