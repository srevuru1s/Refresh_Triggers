/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-03-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class ContactTriggerHandler {

    //* Handle before insert
    public static void handleBeforeInsert(List<Contact> newContacts) {
        ContactTriggerHelper.accountIdIsNotBlank(newContacts);
        ContactTriggerHelper.contactDuplicateCheck(newContacts);
    }
    //* Handle before update
    public static void handleBeforeUpdate(List<Contact> newContacts, Map<Id, Contact> oldMapContact) {
        ContactTriggerHelper.beforeUpdateduplicateContact(newContacts, oldMapContact);
    }
    
}