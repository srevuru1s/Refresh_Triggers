/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-25-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class ErrorHandler {
    
    public static void handleInsertExceptions(List<Sobject> listOfRecords) {

        List<Error_Logger__c> listErrorRecords = new List<Error_Logger__c>();
        Error_Logger__c errorRecord = new Error_Logger__c();
        
            try {
                insert listOfRecords;
            }
            catch (DmlException dmlErrors) {

                for (Integer i = 0; i < dmlErrors.getNumDml(); i++) {

                    errorRecord.Error_Message__c         = dmlErrors.getMessage();
                    Exception causeOfException           = dmlErrors.getCause();
                    errorRecord.Error_Type__c            = dmlErrors.getTypeName();
                    errorRecord.Stack_Trace_Message__c   = dmlErrors.getStackTraceString();
                    errorRecord.Name             = 'Error Record' + String.valueOf(i);

                    listErrorRecords.add(errorRecord);
                }

            }
            catch(Exception error) {

                for (Integer i = 0; i < error.getNumDml(); i++) {
                
                    errorRecord.Error_Message__c         = error.getMessage();
                    Exception causeOfException           = error.getCause();
                    errorRecord.Error_Type__c            = error.getTypeName();
                    errorRecord.Stack_Trace_Message__c   = error.getStackTraceString();
                    errorRecord.Name                     = 'Error Record' + String.valueOf(i);

                    listErrorRecords.add(errorRecord);
                }
                
            }

            insert listErrorRecords;
    }    
        

}