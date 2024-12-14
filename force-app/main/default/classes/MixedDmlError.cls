/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-09-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class MixedDmlError {

    public static void mixedError() {
        
        //* Insert Account
        Account acc = new Account (Name = 'Mixed-DML', Industry = 'Education', Phone = '585-566-0969');
        Insert acc;
        //* Insert User Record
        User newUser = new User (Username = '3121099+Dml@salesforce.com', FirstName = 'New', LastName = 'DML User', Email = 'Salesforce@mail.com', 
                                Alias = 'MXDML', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', 
                                ProfileId = '00eaj000009cQqlAAE', LanguageLocaleKey = 'en_US', UserRoleId = '00Eaj000008bNqmEAE');
        insert newUser;
    }
}