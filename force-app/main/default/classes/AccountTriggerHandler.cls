/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-27-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class AccountTriggerHandler {

    //*Handle Before Insert
        public static void handleBeforeInsert(List<Account> newAccounts) {

        }
    //* Handle After Insert
        public static void handleAfterInsert(List<Account> newAccounts, Map<Id,Account> newMapAccounts) {
            AccountTriggerHelper.createNContacts(newAccounts);
        }    
    //* Handle Before Update
        public static void handleBeforeUpdate(List<Account> newAccounts, Map<Id, Account> oldMapAccounts) {
            AccountTriggerHelper.verifyOwnership(newAccounts, oldMapAccounts);
        }
    //* Handle After Update
        public static void handleAfterUpdate(List<Account> newAccounts, Map<Id, Account> newMapAccounts, Map<Id, Account> oldMapAccounts) {
            AccountTriggerHelper.updateContactWebsiteField(newAccounts, newMapAccounts, oldMapAccounts);
            AccountTriggerHelper.updatedContactNumber(newAccounts, oldMapAccounts);
        }
}