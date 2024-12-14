/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-14-2024
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
    //* Send email to account owner if the contact phone or email gets updated
    public static void sendEmailToAccountOwner(Map<Id,Contact> newMapContacts, Map<Id,Contact> oldMapContacts) {

        //* Collect the contacts details to send email
        Map<Id,Contact> accountIdContact = new Map<Id,Contact>();
        //* List of Accounts owner email Id's
        List<String> accountOwnerEmail = new List<String>();

        if (newMapContacts?.size() > 0) {

            for (Contact newContactRecord : newMapContacts.values()) {
                //* check for the condition
                if (newContactRecord.Phone != oldMapContacts.get(newContactRecord.Id).Phone || newContactRecord.Email != oldMapContacts.get(newContactRecord.Id).Email) {

                    accountIdContact.put(newContactRecord.AccountId, newContactRecord);
                }
            }
        }

        //* Query the account contact Email Id's
        if (accountIdContact?.size() > 0) {
            
            for (Account accountRecord : [SELECT Owner.Email, Id FROM Account WHERE Id IN : accountIdContact.keySet() AND Active__c = 'Yes' WITH USER_MODE LIMIT 50000]) {
                
                accountOwnerEmail.add(accountRecord.Owner.Email);
            }
        }
        //* lets send the email 
        if (accountOwnerEmail?.size() > 0) {
            
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> ();

            for (String emailIds : accountOwnerEmail) {
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

                message.toaddresses   = accountOwnerEmail;
                message.optoutpolicy  = 'FILTER';
                message.subject       = 'Contact Email or Phone updated';
                message.plaintextbody = 'The email or phone information of your child contact has been modified';

                messages.add(message);
            }

            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
        }
    }

    //* Update Contact Billing Address from Account 
    public static void updateContactBillingAddressFromAccount(List<Contact> newContacts) {
        //* Map of accountId to contact records
        Map<Id,Contact> accountIdContacts = new Map<Id,Contact>();

        if (newContacts?.size() > 0) {
            for (Contact contactRecord : newContacts) {
                if (contactRecord.AccountId != null && String.isNotBlank(contactRecord.AccountId)) {
                    accountIdContacts.put(contactRecord.AccountId, contactRecord);
                }
            }
        }
        //* Query the account records 
        if (accountIdContacts?.size() > 0) {
            Map<Id, Account> accountRecords = new Map<Id,Account> ([SELECT Id, BillingCity, BillingAddress, BillingCountry, BillingPostalCode, BillingStreet, BillingState  FROM Account WHERE Id IN : accountIdContacts.keySet() WITH USER_MODE LIMIT 50000]);

            if (accountRecords?.size() > 0) {
                for (Contact contactRecord : newContacts) {
                    
                    contactRecord.MailingCity       = accountRecords.get(contactRecord.AccountId).BillingCity;
                    contactRecord.MailingCountry    = accountRecords.get(contactRecord.AccountId).BillingCountry;
                    contactRecord.MailingPostalCode = accountRecords.get(contactRecord.AccountId).BillingPostalCode;
                    contactRecord.MailingState      = accountRecords.get(contactRecord.AccountId).BillingState;
                    contactRecord.MailingStreet     = accountRecords.get(contactRecord.AccountId).BillingStreet;
                }
            }
        }
    }

    //* Check total Number of contcats allowed for an Account
    public static void maxContactsAllowed(List<Contact> newContacts ) {
        //*Map of AccountId and new contacts
        Map<Id,Contact> accountIdContact = new Map<Id,Contact>();
        //* Map of AccountID and its total Number of contacts associated 
        Map<Id,Integer> accountIdTotalContacts = new Map<Id,Integer>();

        if (newContacts?.size() > 0) {
            for (Contact newContactRecord : newContacts) {
                if (newContactRecord.AccountId != null && String.isNotBlank(newContactRecord.AccountId)) {
                    accountIdContact.put(newContactRecord.AccountId, newContactRecord);
                }
            }   
        }
        //* get the total number of contacts associated to the account
        if (accountIdContact?.size() > 0) {
            
            Map<Id,Account> mapAccount = new Map<Id,Account> ([SELECT Id, Maximum_Contacts__c FROM Account WHERE Id IN : accountIdContact.keySet() WITH USEr_MODE LIMIT 50000]);

            List<AggregateResult> totalNumberOfContacts = [SELECT COUNT(Id) numberOfContacts, AccountId account FROM Contact WHERE AccountId IN : accountIdContact.keySet() WITH USER_MODE GROUP BY AccountID LIMIT 50000];
            
            if (totalNumberOfContacts?.size() > 0) {

                for (AggregateResult aggResult : totalNumberOfContacts) {

                    Integer totalContacts = (Integer) aggResult.get('numberOfContacts'); 
                    Id contactAccountId   = (Id) aggResult.get('account');

                    accountIdTotalContacts.put(contactAccountId, totalContacts);
                }
            }

            //* Loop through the new contact records to validate the max number of accounts allowed
                
            for (Contact newContactRecord : newContacts) {
                    
                if (newContactRecord.AccountId != null && String.isNotBlank(newContactRecord.AccountId)) {
                        
                    if (accountIdTotalContacts.get(newContactRecord.AccountId) ==  mapAccount.get(newContactRecord.AccountId).Maximum_Contacts__c) {
                
                        newContactRecord.addError('The max number of contacts reached for this account');
                    }
                }
                
            }
        }
        
    }
}