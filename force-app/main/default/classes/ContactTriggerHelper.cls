/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-07-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class ContactTriggerHelper {
    
    //* verify the account id field should not be blank
    public static void accountIdIsNotBlank(List<Contact> newContacts) {
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
    //* Duplicate contact check
    public static void contactDuplicateCheck(List<Contact> newContacts) {

        List<String> contactEmailList = new List<String>();
        
        if (newContacts?.size() > 0) {
            
            for (Contact contactRecord : newContacts) {

                if (!String.isBlank(contactRecord.Email)) {
                    contactEmailList.add(contactRecord.Email);
                }
                
            }
        }
        Map<String, Contact> mapContcatsEmailKey = new Map<String, Contact>();

        if (contactEmailList?.size() > 0) {
            List<Contact> existingContacts = [SELECT Id, LastName, Email, Phone FROM Contact WHERE Email IN : contactEmailList WITH USER_MODE LIMIT 50000];
            //* Loop through the existing records to add in MAP
            if (existingContacts?.size() > 0) {
                for (Contact contactRecord : existingContacts) {
                    mapContcatsEmailKey.put(contactRecord.Email, contactRecord);
                }
            }
            //* Duplicate Email check
            if (newContacts?.size() > 0) {

                for (Contact newContact : newContacts) {
                    if (!String.isBlank(newContact.Email) && mapContcatsEmailKey.containsKey(newContact.Email)) {

                        if (mapContcatsEmailKey.get(newContact.Email).Phone == newContact.Phone && mapContcatsEmailKey.get(newContact.Email).LastName == newContact.LastName) {
                            newContact.LastName.addError('Duplicate Contact LastName');
                            newContact.Phone.addError('Duplicate Contact Phone');
                            newContact.Email.addError('Duplicate Email Address');
                        }
                        
                    } else {
                        mapContcatsEmailKey.put(newContact.Email, newContact);
                    }
                }
            }
        }  
    } 

    //* Before Update duplicate check
    public static void beforeUpdateduplicateContact(List<Contact> newContacts, Map<Id, Contact> oldMapContact) {
        
        Map<String, Contact> mapContactKeyEmail = new Map<String, Contact>();

        if (newContacts?.size() > 0) {
            //* Check the update conditions
            for (Contact newContactRecord : newContacts) {

                if (newContactRecord.Email != oldMapContact.get(newContactRecord.Id).Email || newContactRecord.LastName != oldMapContact.get(newContactRecord.Id).LastName
                || newContactRecord.Phone != oldMapContact.get(newContactRecord.Id).Phone) {
                    
                    mapContactKeyEmail.put(newContactRecord.Email, newContactRecord);
                }
            }
        }
        //* Query the records
        if (mapContactKeyEmail?.size() > 0) {

            Map<String,Contact> existingMapEmailKeyContact = new Map<String,Contact>();
            
            //* Query the old records
            for (Contact oldContact : [SELECT Id, Email, Phone, LastName FROM Contact WHERE  Email IN :mapContactKeyEmail.keySet() AND Id NOT IN :oldMapContact.keySet() WITH USER_MODE LIMIT 50000]) {
                existingMapEmailKeyContact.put(oldContact.Email, oldContact);
            }
            
            //* Loop through the new contacts
            if (existingMapEmailKeyContact?.size() > 0) {

                for (Contact newContactRecord : newContacts) {

                    if (existingMapEmailKeyContact.containsKey(newContactRecord.Email) && existingMapEmailKeyContact.get(newContactRecord.Email).Phone == newContactRecord.Phone &&
                    existingMapEmailKeyContact.get(newContactRecord.Email).LastName == newContactRecord.LastName) {
    
                        newContactRecord.LastName.addError('Duplicate Contact LastName');
                        newContactRecord.Phone.addError('Duplicate Contact Phone');
                        newContactRecord.Email.addError('Duplicate Email Address');
                    }
                }
            }
            
        }
        
    }
    //* Sharing the contact record to the public group
    public static void shareContactToPublicGroup(List<Contact> newContacts, Map<Id,Contact> newMapContact) {

        Id publicGroupId = [SELECT Id FROM GROUP WITH USER_MODE LIMIT 1].Id;
        List<ContactShare> listContactShareRecords = new List<ContactShare>();

        if (newContacts?.size() >0) {
            for (Contact contactRecord : newContacts) {
                
                ContactShare conShare       = new ContactShare();
                conShare.ContactId          = contactRecord.Id;
                conShare.RowCause           = 'Manual';
                conShare.UserOrGroupId      = publicGroupId;
                conShare.ContactAccessLevel = 'Read';

                listContactShareRecords.add(conShare);
            }
        }

        if (listContactShareRecords?.size() > 0) {
            ErrorHandler.handleInsertExceptions(listContactShareRecords);
        }
    }
}