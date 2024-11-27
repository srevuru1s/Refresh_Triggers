/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-26-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class AccountTriggerHandler {

    //* Handle Before Update
        public static void handleBeforeUpdate(List<Account> newAccounts, Map<Id, Account> oldMapAccounts) {
            AccountTriggerHelper.verifyOwnership(newAccounts, oldMapAccounts);
        }
    //* Handle After Update
        public static void handleAfterUpdate(List<Account> newAccounts, Map<Id, Account> newMapAccounts, Map<Id, Account> oldMapAccounts) {
            AccountTriggerHelper.updateContactWebsiteField(newAccounts, newMapAccounts, oldMapAccounts);
        }
}