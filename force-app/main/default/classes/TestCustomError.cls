/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 06-01-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class TestCustomError {
    
    public static void getError(Boolean isError) {

        try {
            if (isError) {
            throw new CustomException('This is the error message');
            }
    
        } catch (CustomException ex) {
            
            System.debug('This is the catch block :' + ex.getMessage());
        }
    }
}