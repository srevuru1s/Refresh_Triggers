/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-11-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class ContactTriggerHandler {

    //* Handle before insert
    public static void handleBeforeInsert(List<Contact> newContacts) {
        ContactTriggerHelper.accountIdIsNotBlank(newContacts);
        ContactTriggerHelper.contactDuplicateCheck(newContacts);
        ContactTriggerHelper.updateContactBillingAddressFromAccount(newContacts);
        ContactTriggerHelper.maxContactsAllowed(newContacts);
    }
    //* Handle before update
    public static void handleBeforeUpdate(List<Contact> newContacts, Map<Id, Contact> oldMapContact) {
        ContactTriggerHelper.beforeUpdateduplicateContact(newContacts, oldMapContact);
        ContactTriggerHelper.limitContactEmailUpdate(newContacts, oldMapContact);
    }

    //* Handle after insert
    public static void handleAfterInsert(List<Contact> newContacts, Map<Id,Contact> newMapContact) {
        ContactTriggerHelper.shareContactToPublicGroup(newContacts, newMapContact);
        ContactTriggerHelper.sendWelcomeEmail(newMapContact);
        ContactTriggerHelper.updateAccountIndustry(newMapContact);
    }
    
    //* Handle after update
    public static void handleAfterUpdate(Map<Id,Contact> newMapContacts, Map<Id,Contact> oldMapContacts) {
        ContactTriggerHelper.sendEmailToAccountOwner(newMapContacts, oldMapContacts);
        ContactTriggerHelper.updateNlocationsRecords(newMapContacts, oldMapContacts);
    }

    //* Handle Before Delete
    public static void handleBeforeDelete(List<Contact> oldContacts, Map<Id,Contact> oldMapContacts) {
        ContactTriggerHelper.validateContactDeletion(oldMapContacts);
    }
}