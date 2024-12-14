/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-11-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class LwcAccountHandler {
    
    @AuraEnabled(Cacheable = true)
    public static List<Account> listOfAccounts() {
        return [SELECT Id, Name, Phone , Industry, Rating FROM Account WITH USER_MODE LIMIT 20];
    }
}