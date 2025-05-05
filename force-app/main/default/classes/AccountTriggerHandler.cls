    /**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 05-05-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class AccountTriggerHandler {

    //*Handle Before Insert
        public static void handleBeforeInsert(List<Account> newAccounts) {
            AccountTriggerHelper.batchJobExecution();
        }
    //* Handle After Insert
        public static void handleAfterInsert(List<Account> newAccounts, Map<Id,Account> newMapAccounts) {
            AccountTriggerHelper.createNContacts(newAccounts);
            AccountTriggerHelper.shareAccountRecordToSecondaryUser(newMapAccounts);
        }    
    //* Handle Before Update
        public static void handleBeforeUpdate(List<Account> newAccounts, Map<Id, Account> oldMapAccounts) {
            AccountTriggerHelper.verifyOwnership(newAccounts, oldMapAccounts);
        }
    //* Handle After Update
        public static void handleAfterUpdate(List<Account> newAccounts, Map<Id, Account> newMapAccounts, Map<Id, Account> oldMapAccounts) {
            AccountTriggerHelper.updateContactWebsiteField(newAccounts, newMapAccounts, oldMapAccounts);
            AccountTriggerHelper.updatedContactNumber(newAccounts, oldMapAccounts);
            AccountTriggerHelper.updateOpportunitySatgeName(newMapAccounts, oldMapAccounts);
        }
    //* Handle Before Delete
        public static void handleBeforeDelete(List<Account> oldAccounts, Map<Id,Account> oldMapAccounts) {
            AccountTriggerHelper.stopDeletingAccountWithContact(oldAccounts, oldMapAccounts);
        }    
}