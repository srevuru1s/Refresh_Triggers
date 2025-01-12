/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-09-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class PaginationDemoController {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        List<Contact> contacts = [SELECT Id, Name, Email, Phone, Department FROM Contact WITH USER_MODE LIMIT 5000];
        return contacts;
    }

    @AuraEnabled
    public static List<Account> getAccounts( Integer pageSize, String lastRecordId) {
        String query = 'SELECT Id, Name, Type, Rating FROM Account ';
        if (String.isNotBlank(lastRecordId)) {
            query += 'WHERE Id >: lastRecordId';
        } else {
            query += 'ORDER BY Id LIMIT :pageSize';
        }

        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getTotalAccountsCount(){
        return [SELECT COUNT(ID) FROM Account WITH USER_MODE];
    }
    
}