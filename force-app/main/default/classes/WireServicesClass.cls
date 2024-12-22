/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-21-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class WireServicesClass {
    
    //* Get the list of accounts where Industry
    @AuraEnabled (cacheable = true)
    public static List<Account> getAccountRecords(String value) {

        if (String.isBlank(value)) {
            return [SELECT Id, Name, Industry FROM Account WITH USER_MODE LIMIT 20];
        } else {
            return [SELECT Id, Name, Industry FROM Account WHERE Industry != : value AND Industry != null WITH USER_MODE LIMIT 20];
        }
        
    }
    //* Insert account from wire 
    @AuraEnabled (cacheable = false)
    public static Account insertAccountRecords(String accname, String accphone, String accindustry) {

            Account newWireAccount = new Account(Name = accname,Phone = accphone,Industry = accindustry);
            insert newWireAccount;
    
            return newWireAccount;        
    }
}