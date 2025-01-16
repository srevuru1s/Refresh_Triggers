    /**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-14-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class OpportunityTriggerHelper {

         //* Update the trigger Amount field
        public static void updateTriggerAmount(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldMapOpportunities) {
                
            if (newOpportunities?.size() > 0) {

                for (Opportunity opportunityRecord : newOpportunities) {
                        //* condition to check the opp stage is Modified
                        if (opportunityRecord.StageName != oldMapOpportunities.get(opportunityRecord.Id).StageName) {
                            opportunityRecord.Amount  = (opportunityRecord.Probability * opportunityRecord?.ExpectedRevenue);
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
        //* Update account with Highest Opportunity Name
        public static void updateAccountWithHighestOpportunity(List<Opportunity> newOpportunities, Map<Id,Opportunity> newMapOpportunities) {
            //* Collect the accountid of opportunity
            Map<Id,Opportunity> accountIdToOpportunity = new Map<Id,Opportunity>();
            //* List of account records that need to be updated
            List<Account> accountListToUpdate = new List<Account>();
            
            if (newOpportunities?.size() > 0) {
                
                for (Opportunity oppRecord : newOpportunities) {
                    
                    if (oppRecord.AccountId != null) {
                        accountIdToOpportunity.put(oppRecord.AccountId, oppRecord);
                    }
                }
            }
            if (accountIdToOpportunity?.size() > 0) {
                
                List<Account> accountOpportunityRecords = [SELECT Id, Name, (SELECT Id, Name FROM Opportunities ORDER BY Amount DESC LIMIT 1) FROM Account WHERE Id IN : accountIdToOpportunity.keySet() WITH USER_MODE LIMIT 5000]; 

                if (accountOpportunityRecords?.size() > 0) {
                    
                    for (Account accountRecord : accountOpportunityRecords) {
                        
                        for (Opportunity oppRecords : accountRecord.Opportunities) {
                            
                            Account accToUpdate                      = new Account();
                            accToUpdate.Highest_Value_Opportunity__c = oppRecords.Name;
                            accToUpdate.Id                           = accountRecord.Id;

                            accountListToUpdate.add(accToUpdate);
                        }
                        
                    }
                }
            }

            if (accountListToUpdate?.size() > 0) {
                
                ErrorHandler.handleUpdateExceptions(accountListToUpdate);
            }
        }
}