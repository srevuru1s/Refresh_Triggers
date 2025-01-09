/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-06-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class AccountController {
    
    @AuraEnabled
    public static List<Account> getAccounts(Integer limitSize, Integer offSetSize) {

        List<Account> allListRecords = [SELECT Id, Name, Phone, Industry, Active__c, BillingAddress, Rating FROM Account LIMIT :limitSize OFFSET : offSetSize];
        return allListRecords;
    }
}