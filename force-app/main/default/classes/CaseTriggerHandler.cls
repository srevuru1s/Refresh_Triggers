/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 02-28-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class CaseTriggerHandler {
    
    //* Handle Before Insert
    public static void handleBeforeInsert(List<Case> newCases) {

        if (newCases.size()>0) {
            
            for (Case caseRecord: newCases) {
                if (caseRecord.Origin == 'Phone') {
                    caseRecord.Priority = 'High';
                } else {
                caseRecord.Priority = 'Low';
                }
            }
        } 
        //* Search for the contact to update the contact Name 
        //* Collect the email from the cases
        Set<String> webEmails = new Set<String>();
        //* Map of contact with email as key
        Map<String,Contact> emailMapKeyContact = new Map<String,Contact>();

        if (newCases?.size() > 0) {

            for (case caseRecord : newCases) {
                //* Check for the Web Email field
                if (caseRecord.SuppliedEmail != null && String.isNotBlank(caseRecord.SuppliedEmail)) {
                    webEmails.add(caseRecord.SuppliedEmail);
                }
            }
        }
        if (webEmails?.size() > 0) {
            //* Query the contact records with the emails
            List<Contact> contactWithMatchingEmail = [SELECT Id, Email FROM Contact WHERE Email IN : webEmails WITH USER_MODE LIMIT 50000];

            if (contactWithMatchingEmail?.size() > 0) {
                //* Loop through the list to create a map
                for (Contact conRecord : contactWithMatchingEmail) {
                    
                    emailMapKeyContact.put(conRecord.Email, conRecord);
                }
                //* Loop through the case records
                for (Case caseRecord : newCases) {
                    
                    if (caseRecord.SuppliedEmail != null && String.isNotBlank(caseRecord.SuppliedEmail)) {
                        
                        caseRecord.ContactId = emailMapKeyContact.get(caseRecord.SuppliedEmail).Id;
                    }
                }
            }

        }
    }   
    //* Handle Before Delete
    public static void handleBeforeDelete(List<Case> oldCases) {
        
        //systemAdminCanDelete(oldCases);
        stopDeleteingCasesWithNotesOrAttachments(oldCases);
        
    } 

    //* only system admins can delete the records
    public static void systemAdminCanDelete(List<Case> oldCases) {

        Id currentUserProfileId = UserInfo.getProfileId();
        
        Id systemAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' WITH USER_MODE LIMIT 1].Id;

        if (oldCases?.size() > 0) {
            for (Case caseRecord : oldCases) {
                //* check the condition for the id
                if (currentUserProfileId != systemAdminProfileId) {
                    caseRecord.addError('Only system admins can delete the case records');
                }
            }
        }
    }
    //* case with Notes or Attachments on the case are not deleted
    public static void stopDeleteingCasesWithNotesOrAttachments(List<Case> oldCases) {

        Set<Id> caseIds = new Set<Id>();

        if (oldCases?.size() > 0) {
            for (Case caseRecord : oldCases) {
                caseIds.add(caseRecord.Id);
            }
        }

        Set<Id> caseIdsWithNoteOrAttachments = new Set<Id>();

        if (caseIds?.size() > 0) {
            
            for (Note n : [SELECT ParentId FROM Note WHERE ParentId IN : caseIds WITH USER_MODE]) {
                caseIdsWithNoteOrAttachments.add(n.ParentId);
            }

            for (Attachment a : [SELECT ParentId FROM Attachment WHERE ParentId IN : caseIds WITH USER_MODE]) {
                caseIdsWithNoteOrAttachments.add(a.ParentId);
            }
        }
    }
}