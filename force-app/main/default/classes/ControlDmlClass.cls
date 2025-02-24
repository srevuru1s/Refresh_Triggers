/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 02-08-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class ControlDmlClass {
    
    public static void dmlController() {

        Account acc1 = new Account(Name = 'DML6');
        insert acc1;

        try {
            Account acc2 = new Account(Name = 'DML7');
            insert acc2;

            Contact con = new Contact(AccountId = acc1.Id);
            insert con;

        } catch (Exception e) {
            System.debug('Exception occured' + e.getMessage());
            
        }

    }
}