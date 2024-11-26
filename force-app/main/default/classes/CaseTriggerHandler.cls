/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-25-2024
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
}