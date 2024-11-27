/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-26-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class ContactTriggerHandler {

    //* Handle before insert
    public static void handleBeforeInsert(List<Contact> newContacts) {

        if (newContacts?.size() > 0) {

            for (Contact contactRecord : newContacts) {
                //* check for the condition
                if (contactRecord.AccountId == null || String.isBlank(contactRecord.AccountId)) {   
                    //Through an error
                    contactRecord.AccountId.addError('Account is Mandatory');
                }
            }
        }
    }
}