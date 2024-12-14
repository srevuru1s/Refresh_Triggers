/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-06-2024
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
    }   
    //* Handle Before Delete
    public static void handleBeforeDelete(List<Case> oldCases) {
        
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
}