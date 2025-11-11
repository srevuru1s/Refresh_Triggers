/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 07-15-2025
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
                        
                    if (accountIdTotalContacts.get(newContactRecord.AccountId) ==  mapAccount.get(newContactRecord.AccountId).Maximum_Contacts__c && mapAccount.get(newContactRecord.AccountId).Maximum_Contacts__c != null) {
                
                        newContactRecord.addError('The max number of contacts reached for this account');
                    }
                }
                
            }
        }
        
    }
    //* Create N location field on the contact gets updated
    public static void updateNlocationsRecords( Map<Id,Contact> newMapContacts, Map<Id,Contact> oldMapContacts) {
        
        // Map to track the number of locations to add and remove
        Map<Id, Decimal> locationsToAdd = new Map<Id, Decimal>();
        Map<Id, Decimal> locationsToRemove = new Map<Id, Decimal>();

        // Lists to store place records for insert and delete operations
        List<Place__c> placesToInsert = new List<Place__c>();
        List<Place__c> placesToDelete = new List<Place__c>();

            // Ensure newMapContacts is not null or empty
            if (newMapContacts != null && !newMapContacts.isEmpty()) {
                for (Contact newContact : newMapContacts.values()) {
                    Contact oldContact = oldMapContacts.get(newContact.Id);

                    // Check if the N location field was updated
                    if (newContact.Create_N_Locations__c != oldContact.Create_N_Locations__c) {
                        Decimal locationDifference = newContact.Create_N_Locations__c - oldContact.Create_N_Locations__c;

                        if (locationDifference > 0) {
                            locationsToAdd.put(newContact.Id, locationDifference);
                        } else if (locationDifference < 0) {
                        locationsToRemove.put(newContact.Id, -locationDifference);
                        }
                    }
                }
            }

        // Add new locations
        if (!locationsToAdd.isEmpty()) {
            for (Id contactId : locationsToAdd.keySet()) {
                Decimal numberOfLocations = locationsToAdd.get(contactId);

                for (Decimal i = 1; i <= numberOfLocations; i++) {
                    Place__c place = new Place__c();
                    place.ContactId__c = contactId;
                    place.Country__c = 'USA';
                    place.Visited__c = true;
                    place.Name = 'My Place ' + i;
                    placesToInsert.add(place);
                }
            }

            if (!placesToInsert.isEmpty()) {
                ErrorHandler.handleInsertExceptions(placesToInsert);
            }
        }

    // Remove locations
        if (!locationsToRemove.isEmpty()) {
            Map<Id, List<Place__c>> existingPlacesMap = new Map<Id, List<Place__c>>();

            // Query existing places for the contacts to remove locations
            for (Place__c place : [SELECT Id, ContactId__c FROM Place__c WHERE ContactId__c IN :locationsToRemove.keySet() ORDER BY CreatedDate ASC]) {
                if (!existingPlacesMap.containsKey(place.ContactId__c)) {
                    existingPlacesMap.put(place.ContactId__c, new List<Place__c>());
                }
                existingPlacesMap.get(place.ContactId__c).add(place);
            }

            // Determine which places to delete
            for (Id contactId : locationsToRemove.keySet()) {
                Decimal numberOfLocationsToRemove = locationsToRemove.get(contactId);
                List<Place__c> existingPlaces = existingPlacesMap.get(contactId);

                if (existingPlaces != null && !existingPlaces.isEmpty()) {
                    for (Integer i = 0; i < numberOfLocationsToRemove && i < existingPlaces.size(); i++) {
                        placesToDelete.add(existingPlaces[i]);
                    }
                }
            }

            if (!placesToDelete.isEmpty()) {
                delete placesToDelete;
            }
        }
    }
    //* Stop Deleting the contacts if contact is associated with account
    public static void validateContactDeletion(Map<Id,Contact> oldMapContacts) {

        //* Collect the map of account Id with contact
        Map<Id,Contact> accountIdContacts = new Map<Id,Contact>();

        if (oldMapContacts?.size() > 0) {
            
            for (Contact conRecord : oldMapContacts.values()) {
                
                if (conRecord.AccountId != null) {
                    
                    accountIdContacts.put(conRecord.AccountId, conRecord);
                }
            }
        }

        if (accountIdContacts?.size() > 0) {
            
            Map<Id,Contact> queryaccIdContacts = new Map<Id,Contact>([SELECT Id, FirstName FROM Contact WHERE AccountId IN: accountIdContacts.keySet() WITH USER_MODE LIMIT 50000]); 

            for (Contact deleteContact : oldMapContacts.values()) {
                
                if (queryaccIdContacts.containsKey(deleteContact.Id)) {
                    
                    // deleteContact.addError('You can\'t Deleted the contact associated with Account');
                    deleteContact.AccountId.addError('Account Name should be removed before delete');
                }
            }
        }
    }
    //* Send welcome email to the contacts
    public static void sendWelcomeEmail(Map<Id,Contact> newMapContacts) {
        //Collect the list of email to addresses
        List<String> contactEmailAddress = new List<String>();

        if (newMapContacts?.size() > 0) {
            
            for (Contact newConRecord : newMapContacts.values()) {
                
                if (!String.isEmpty(newConRecord.Email)) {
                    contactEmailAddress.add(newConRecord.Email);
                }
            }
        }
        List<Messaging.SingleEmailMessage> listOfEmails = new List<Messaging.SingleEmailMessage>();

        if (contactEmailAddress?.size()> 0) {
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(contactEmailAddress);
            email.setSubject('Welcome to World of Salesforce');
            email.setPlainTextBody('Thanks for knowing email class');
            
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {email});
        }
    }
    
    //* Update the Account Industry based on the contact Title
    public static void updateAccountIndustry(Map<Id,Contact> newMapContacts) {
        Map<Id,Contact> accIdToContact = new Map<Id,Contact>();

        if (newMapContacts?.size() > 0) {
            
            for (Contact newContactRecord : newMapContacts.values()) {
                
                String accId = newContactRecord.AccountId;
                if (String.isNotBlank(newContactRecord.Title) & accId.contains('001')) {
                    
                    //* Collect the account id's to update the industries
                    accIdToContact.put(newContactRecord.AccountId, newContactRecord);
                }
            }
        }
        //* Collect account records that needs to be updated
        List<Account> listAccountToUpdate = new List<Account>();

        if (accIdToContact?.size() > 0) {
            
            for (Id accId : accIdToContact.keySet()) {
                
                Account updateAccount   = new Account();
                updateAccount.Id        = accId;
                updateAccount.Industry  = accIdToContact.get(accId).Title.contains('Manager') ? 'Management' :  accIdToContact.get(accId).Title.contains('Engineer') ? 'Engineering' : 'Education';

                listAccountToUpdate.add(updateAccount);
            }
        }

        //*Update accounts
        if (listAccountToUpdate?.size() > 0) {
        
            ErrorHandler.handleUpdateExceptions(listAccountToUpdate);
        }
    }    

    //* Check the number of times contcat email got updated
    public static void limitContactEmailUpdate(List<Contact> newContacts, Map<Id,Contact> oldMapContact) {

        if (newContacts?.size() > 0) {
            
            for (Contact contactRecord : newContacts) {
                
                if (contactRecord.Email != oldMapContact.get(contactRecord.Id).Email) {
                    
                    contactRecord.Email_Update_Count__c = (contactRecord.Email_Update_Count__c == null) ? 0 : (contactRecord.Email_Update_Count__c <= 3) ? contactRecord.Email_Update_Count__c += 1 : 4;
                    
                    if (contactRecord.Email_Update_Count__c >  3) {
                        contactRecord.Email_Update_Count__c.addError('Email Updated Max times');
                    }
                }
            }
        }
    } 
    //* Update account with all the contact First and Last Name 
    
    public static void updateAccountContactsField(Map<Id,Contact> newMapContacts) {
        
        //* Collect account Ids
        Map<Id,Contact> mapAccountIdWithContact = new Map<Id,Contact>();

        List<Account> listAccount = new List<Account>();


        if (newMapContacts?.size() > 0) {
            
            for (Contact contactRecord : newMapContacts.values()) {
                
                mapAccountIdWithContact.put(contactRecord.AccountId, contactRecord);
            }
        }
        //* Query the account field if it has any old contacts associated with it
        if (mapAccountIdWithContact?.size() > 0) {
            
            Map<Id,Account> accountMapDetails = new Map<Id,Account>([SELECT Id,Contact_Names__c FROM Account WHERE Id IN: mapAccountIdWithContact.keySet() WITH USER_MODE LIMIT 50000]);
            
            for (Contact newConRecord : newMapContacts.values()) {
                
                if (accountMapDetails.containsKey(newConRecord.AccountId) && !String.isEmpty(accountMapDetails.get(newConRecord.AccountId).Contact_Names__c)) {
                    
                    accountMapDetails.get(newConRecord.AccountId).Contact_Names__c += ' '+newConRecord.FirstName +' '+ newConRecord.LastName; 
                } else {
                    accountMapDetails.get(newConRecord.AccountId).Contact_Names__c = newConRecord.FirstName + ' ' + newConRecord.LastName;
                }
            }

            //* Create a new account instance to update the account
                if (accountMapDetails?.size() > 0) {
                    
                    ErrorHandler.handleUpdateExceptions(accountMapDetails.values());
                }
        }

    }
}