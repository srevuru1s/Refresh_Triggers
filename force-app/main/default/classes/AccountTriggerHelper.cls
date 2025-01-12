/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-10-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class AccountTriggerHelper {

    //* Method to verify the ownership
        public static void verifyOwnership(List<Account> newAccounts, Map<Id, Account> oldMapAccounts) {

            if (newAccounts?.size() > 0) {

                for (Account accountRecord : newAccounts) {
                    //* check the condition for ownership
                    if (accountRecord.Industry != oldMapAccounts.get(accountRecord.Id).Industry && accountRecord.Type != oldMapAccounts.get(accountRecord.Id).Type) {

                        if (accountRecord.Industry == 'Agriculture' && accountRecord.Type == 'Prospect' && accountRecord.Ownership == 'Private') {

                            accountRecord.Ownership.addError('We can set the ownership to private for Industry & Type for this');
                        }
                    }
                    
                }
            }
        }

    //* Method to update the Accounts contacts website field
        public static void updateContactWebsiteField(List<Account> newAccounts, Map<Id, Account> newMapAccounts, Map<Id,Account> oldMapAccounts) {

            //* Map of Accounts where website got updated
                Map<Id, Account> websiteUpdatedAccounts = new map<Id, Account>();
            //* List of Contacts that need to be updated     
                List<Contact> contactsToUpdate = new List<Contact>();

            if (newMapAccounts?.size() > 0) {

                for (Account accountRecord : newMapAccounts.values()) {

                    //* verify the condition
                    if (accountRecord.Website != oldMapAccounts.get(accountRecord.Id).Website) {

                        //* add the account in map
                        websiteUpdatedAccounts.put(accountRecord.Id, accountRecord);
                    }
                }
            }
            //* Query the contact records associated with updated website accounts

            if (websiteUpdatedAccounts?.size() > 0) {

                for (Contact contactRecord : [SELECT Id, AccountId FROM Contact WHERE AccountId IN : websiteUpdatedAccounts.keySet() WITH USER_MODE]) {

                    //* update the Account Website field
                    contactRecord.Account_Website__c = websiteUpdatedAccounts.get(contactRecord.AccountId).Website;

                    //* add the contact in list
                    contactsToUpdate.add(contactRecord);
                }
            }

            if (contactsToUpdate?.size() > 0) {

                ErrorHandler.handleUpdateExceptions(contactsToUpdate);
            }
        }
    //* Method to create N contacts for each account AFTER UPDATE
        public static void updatedContactNumber (List<Account> newAccounts, Map<Id, Account> oldAccounts) {
            //* Updated new map of contacts
            Map<Id,Account> newUpdatedContacts = new Map<Id,Account>();
            Map<Id, Account> deleteNContact = new Map<Id, Account>();

            if (newAccounts?.size() > 0) {
                for (Account accountRecord : newAccounts) {

                    if (accountRecord.Create_N_Contacts__c != null && accountRecord.Create_N_Contacts__c != oldAccounts.get(accountRecord.id).Create_N_Contacts__c) {

                        //* check the new value is greater than the old one
                        if (accountRecord.Create_N_Contacts__c > oldAccounts.get(accountRecord.Id).Create_N_Contacts__c) {

                            //* create N difference contacts
                            Account newAccount  = new Account();
                            newAccount.Id       = accountRecord.Id;
                            newAccount.Industry = accountRecord.Industry;
                            newAccount.Name     = accountRecord.Name;
                            newAccount.Create_N_Contacts__c = accountRecord.Create_N_Contacts__c - oldAccounts.get(accountRecord.Id).Create_N_Contacts__c;
                            
                            newUpdatedContacts.put(newAccount.Id, newAccount);
                            
                        } else {
                            
                            //* delete N contacts
                            Account newAccount  = new Account();
                            newAccount.Id       = accountRecord.Id;
                            newAccount.Create_N_Contacts__c = oldAccounts.get(accountRecord.Id).Create_N_Contacts__c - accountRecord.Create_N_Contacts__c;
                            
                            deleteNContact.put(newAccount.Id, newAccount);
                        }
                    }
                }
            }

            //* for creating new contacts 
                if (newUpdatedContacts?.size() > 0) {
                    createNContacts(newUpdatedContacts.values());
                }
        }    
    //* Method to create N number of contact records
        public static void createNContacts(List<Account> newAccounts) {

            //* Map Account and number of contacts to be created
                Map<Id, Account> numberOfContactsToBeCreated = new Map<Id, Account>();
            //* List of number of contacts to be created
                List<Contact> listContacts = new List<Contact>();
            
                if (newAccounts.size() > 0) {
                
                    for (Account accountRecord : newAccounts) {

                        if (accountRecord?.Create_N_Contacts__c > 0 && accountRecord.Create_N_Contacts__c != null) {
                            
                            numberOfContactsToBeCreated.put(accountRecord.Id, accountRecord);
                            
                        }
                    }
                }
            //* iterate over the number of contacts record
            
                if (numberOfContactsToBeCreated.size() > 0) {
                    for (Id accountId : numberOfContactsToBeCreated.keySet()) {

                        for (Integer i = 0; i < numberOfContactsToBeCreated.get(accountId).Create_N_Contacts__c; i++) {

                            Contact contactRecord   = new Contact();
                            contactRecord.AccountId = accountId;
                            contactRecord.FirstName = numberOfContactsToBeCreated.get(accountId).Name + ' Contact ' + i;
                            contactRecord.LastName  = numberOfContactsToBeCreated.get(accountId).Industry + 'Contact ' + i;
                            listContacts.add(contactRecord);
                        }
                    }
                }
            //* Insert the list of contacts
            
                if (listContacts.size() > 0) {
                    ErrorHandler.handleInsertExceptions(listContacts);
                }
        }    
    //! Method to delete contacts from account
        public static void deleteNContactsFromAccount(Map<Id,Account> mapAccounts) {
            Map<Id, List<Contact>> mapOfContactsList = new Map<Id, List<Contact>>();

            if (mapAccounts?.size() > 0) {

                List<Contact> listOfContactsToDelete = [SELECT Id FROM Contact WHERE AccountId IN: mapAccounts.keySet() WITH USER_MODE];

                for (Contact contactRecord : listOfContactsToDelete) {
                    
                    if (!mapOfContactsList.containsKey(contactRecord.AccountId)) {
                        mapOfContactsList.put(contactRecord.AccountId, new List<Contact>());
                    }

                    mapOfContactsList.get(contactRecord.AccountId).add(contactRecord);
                }
            }

        }
    //* Method to update Opportunity StageName = Prospecting when Account Industry = 'Technology'
        public static void updateOpportunitySatgeName(Map<Id,Account> newMapAccounts, Map<Id,Account> oldMapAccounts) {

            //* Map accountId records to update
            Map<Id,Account> accountToMap = new Map<Id,Account>();

            if (newMapAccounts?.size() > 0)  {
                
                for (Account accountRecord : newMapAccounts.values()) {
                    
                    //* condition to be checked
                    if (accountRecord.Industry != oldMapAccounts.get(accountRecord.Id).Industry && accountRecord.Industry == 'Technology') {
                        
                        accountToMap.put(accountRecord.Id, accountRecord);
                    }
                }
            }
            //* Collect the list of Opportunities that need to be updated 
            List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

            //* Query all the opportunities associated with the account
            if (accountToMap?.size() > 0) {
                
                Map<Id,Opportunity> mapOpportunities = new Map<Id,Opportunity>([SELECT Id, StageName FROM Opportunity 
                                                                                WHERE AccountId IN : accountToMap.keySet() WITH USER_MODE LIMIT 50000]);
                if (mapOpportunities?.size()> 0) {
                    
                    for (Opportunity opportunityRecord : mapOpportunities.values()) {
                        
                        opportunityRecord.StageName          = 'Prospecting';

                        opportunitiesToUpdate.add(opportunityRecord);
                    }
                }
            }
            //* Update the opportuities 
            if (opportunitiesToUpdate?.size() > 0) {
                
                ErrorHandler.handleUpdateExceptions(opportunitiesToUpdate);
            }
        }

    //* Method to stop deleting the Accounts if it has Contact record
        public static void stopDeletingAccountWithContact(List<Account> oldAccounts, Map<Id,Account> oldMapAccounts) {
            //* Set of Account Id's with contact records
            Set<Id> accId = new Set<Id>();

            if (oldMapAccounts.keySet()?.size() > 0) {
                
                //* Query if an account has contact or not
                List<AggregateResult> aggResults = [SELECT AccountId accId FROM Contact 
                                                    WHERE AccountId IN : oldMapAccounts.keySet() WITH USER_MODE GROUP BY AccountId HAVING COUNT(ID) >= 1];
                if (aggResults?.size() > 0) {
                    
                    for (AggregateResult aggRecord : aggResults) {
                        
                        Id accountRecordId = (Id) aggRecord.get('accId');
                        accId.add(accountRecordId);
                    }
                }
            }
            if (accId?.size() > 0) {
                
                for (Account accountRecord : oldMapAccounts.values()) {
                    
                    if (accId.contains(accountRecord.Id)) {
                        
                        accountRecord.addError('You can\'t delete account');
                    }
                }
            }
        }
}