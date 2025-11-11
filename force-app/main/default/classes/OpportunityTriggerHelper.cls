/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 09-30-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class OpportunityTriggerHelper {
        //* Update Highest Amount field on opportunity
        public static void updateHighestAmount(List<Opportunity> newOpportunities) {

            //* Map of AccountId for the opportunities
            Map<Id,Opportunity> accountIdKeyMap = new Map<Id,Opportunity>();

            //* Map existing opp with AccountId key
            Map<Id,Decimal> existingOppAccountIdkey = new Map<Id,Decimal>();
            
            if (newOpportunities?.size() > 0) {
                //* loop through the opp records to collect accountId
                for (Opportunity newOppRecord : newOpportunities) {
                    
                    if (newOppRecord.Amount != null) {
                        accountIdKeyMap.put(newOppRecord.AccountId, newOppRecord);
                    }
                }
            }

            //* Query the max existing opprtunity value
            if (accountIdKeyMap?.size() > 0) {
                
                List<AggregateResult> listAggResults = [SELECT MAX(Amount) heighest, AccountId accId FROM Opportunity WHERE AccountId IN : accountIdKeyMap.keySet() WITH USER_MODE GROUP BY AccountId LIMIT 50000];

                if (listAggResults?.size() > 0) {
                    
                    for (AggregateResult aggRecord : listAggResults) {
                        
                        Decimal oldHeighest = (Decimal) aggRecord.get('heighest');
                        String idAccount    = (String) aggRecord.get('accId');

                        existingOppAccountIdkey.put(idAccount, oldHeighest);
                    }
                }
            }

            //* check the condition to update the opp
            if (existingOppAccountIdkey?.size() > 0) {
                
                for (Opportunity newOppRecords : newOpportunities) {
                    
                    if (existingOppAccountIdkey.containsKey(newOppRecords.AccountId)) {
                        
                        newOppRecords.Highest_Amount__c = existingOppAccountIdkey.get(newOppRecords.AccountId) < newOppRecords.Amount ? true : false; 

                    } else {
                        
                        newOppRecords.Highest_Amount__c = true;
                    }
                }
            }

        } 
         //* Update the trigger Amount field
        public static void updateTriggerAmount(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldMapOpportunities) {
                
            if (newOpportunities?.size() > 0) {

                for (Opportunity opportunityRecord : newOpportunities) {
                        //* condition to check the opp stage is Modified
                        if (opportunityRecord.StageName != oldMapOpportunities.get(opportunityRecord.Id).StageName && opportunityRecord.Amount != null) {
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
        //* Spliting Account Amount evenly to newly created opportunities
        public static List<Opportunity> splitAccountAmountToNewOpportunitiesEvenly(List<Opportunity> newOpportunities) {

            //* collect opportunity and amount
            Integer totalNumberOfOpps = 1;
            Decimal amountFromAccount;

            //* List of Opportunities that need to update
            List<Opportunity> oldOppListToUpdate = new List<Opportunity>();

            //* collect the account Id associated to the new opportunity
            Map<Id,Opportunity> mapOfAccIdKeyOpportunity = new Map<Id, Opportunity>();

            //* check the newOpportunities list 
            if(newOpportunities?.size() > 0) {
                for (Opportunity newOpps : newOpportunities) {
                    //* check the condition opp has associated account
                    if (newOpps?.AccountId != null) {
                        
                        mapOfAccIdKeyOpportunity.put(newOpps.AccountId, newOpps);
                    }
                }
            }
            //*Query the account record Amount that need to be split amoung all opps equally
            if (mapOfAccIdKeyOpportunity?.size() > 0) {
                
                //* collect account Id and its number of opportunities
                Map<Id,Integer> mapOfAccIdKeyToNumberOpportunities = new Map<Id, Integer>();
                Map<Id,Account> accountDetails = new Map<Id,Account> ([SELECT Id, Opportunity_Split__c FROM Account WHERE Id IN: mapOfAccIdKeyOpportunity.keySet() AND Opportunity_Split__c != NULL WITH USER_MODE LIMIT 50000]);
                
                if (accountDetails?.size() > 0) {
                    
                    //* count the number of existing opportunities
                    List<AggregateResult> oppAggRecords = [SELECT COUNT(ID) numberOfOpps, AccountId accId  FROM Opportunity WHERE AccountId IN: accountDetails.keySet()  WITH USER_MODE GROUP BY AccountId LIMIT 50000];
                        
                        if (oppAggRecords?.size() > 0) {

                            for (AggregateResult oppAggRec : oppAggRecords) {
                                
                                Integer totalOpps = (Integer) oppAggRec.get('numberOfOpps');
                                String accId      = (String) oppAggRec.get('accId');

                                mapOfAccIdKeyToNumberOpportunities.put(accId, totalOpps);
        
                            }
                            //*Query the old opportunities associated to account that need to be updated too
                            
                            oldOppListToUpdate = ( [SELECT Id FROM Opportunity WHERE AccountId IN : accountDetails.keySet() WITH USER_MODE LIMIT 50000] );
                            
                        }
                }
                //* Loop through the new opp records to update the field
                if (mapOfAccIdKeyOpportunity?.size() > 0) {
                    
                    for (Opportunity newOppRec : mapOfAccIdKeyOpportunity.values()) {
                        
                        //* Just to validate the information
                        totalNumberOfOpps += mapOfAccIdKeyToNumberOpportunities?.get(newOppRec.AccountId);
                        amountFromAccount = accountDetails?.get(newOppRec.AccountId)?.Opportunity_Split__c;

                        newOppRec.Opportunity_Share__c = (amountFromAccount/totalNumberOfOpps);     
                        
                    }
                }
                //* Loop through the old opps to update the value
                if (oldOppListToUpdate?.size() > 0) {
                    
                    for (Opportunity oldOpp : oldOppListToUpdate) {
                        
                        oldOpp.Opportunity_Share__c = (amountFromAccount/totalNumberOfOpps);
                        
                    }
                    //* update the old opportunities 
                    ErrorHandler.handleUpdateExceptions(oldOppListToUpdate);
                }

            }

            return oldOppListToUpdate;
            
        }

}