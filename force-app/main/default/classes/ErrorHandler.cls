/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-30-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class ErrorHandler {
    
    public static void handleInsertExceptions(List<Sobject> listOfRecords) {

            try {
            insert as user listOfRecords;
            System.debug('Successfully Record got inserted');
            }
            catch(DmlException dmlError) {
                System.debug('Im into the DMl Exception');
                exceptionHandler(dmlError);
            }
            catch(Exception error) {
                System.debug('Im into the Final Exception');
                exceptionHandler(error);               
            }
    }    
        
    public static void handleUpdateExceptions(List<Sobject> listOfRecords) {
        
        try {
            update as user listOfRecords;
        }
        catch(Exception error) {

            exceptionHandler(error);               
        }
    }    

    public static void exceptionHandler(Exception allErrors) {
        //* collect all the list of errors
        List<Error_Logger__c> listErrorRecords = new List<Error_Logger__c>();
        
         //* Handle DmlException
        if (allErrors != Null && allErrors instanceOf DmlException) {
    
                DmlException dmlErrors = (DmlException) allErrors;

            for (Integer i = 0; i < dmlErrors.getNumDml(); i++) {
                Error_Logger__c errorRecord = new Error_Logger__c();

                    errorRecord.Error_Message__c         = dmlErrors.getMessage();
                    Exception causeOfException           = dmlErrors.getCause();
                    errorRecord.Error_Type__c            = dmlErrors.getTypeName();
                    errorRecord.Stack_Trace_Message__c   = dmlErrors.getStackTraceString().substring(0, 200);
                    errorRecord.Name                     = 'Error Record' + String.valueOf(i); 

                    listErrorRecords.add(errorRecord);
            }
        } else {
            //* Handle Generic Exception
            for (Integer i = 0; i < allErrors.getNumDml(); i++) {

                Error_Logger__c errorRecord = new Error_Logger__c();

                errorRecord.Error_Message__c         = allErrors.getMessage();
                Exception causeOfException           = allErrors.getCause();
                errorRecord.Error_Type__c            = allErrors.getTypeName();
                errorRecord.Stack_Trace_Message__c   = allErrors.getStackTraceString().trim();
                errorRecord.Name                     = 'Error Record' + String.valueOf(i); 

                listErrorRecords.add(errorRecord);
            }
        }
        
        if (listErrorRecords.size() >0) {

            insert as user listErrorRecords;
        }
        
    }    
}