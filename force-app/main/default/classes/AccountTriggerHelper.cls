/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-26-2024
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
}