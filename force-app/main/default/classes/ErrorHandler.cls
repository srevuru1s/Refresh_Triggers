/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-09-2025
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
    
    public static void handleDeleteExceptions(List<Sobject> listOfRecords) {
        
        try {
            delete as user listOfRecords;
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

    public static void dataBaseInsert(List<Sobject> listOfRecords) {
        
        //* collect all the list of errors
        List<Error_Logger__c> listErrorRecords = new List<Error_Logger__c>();

        if (listOfRecords?.size() > 0) {
            
            List<Database.SaveResult> listRecords = Database.insert(listOfRecords, false);
            //* loop through the list of records
            for (Database.SaveResult dataBaseRecord : listRecords) {
                
                if (!dataBaseRecord.isSuccess()) {
                    
                    List<Database.Error> listErrors = dataBaseRecord.getErrors();
                    for (Database.Error errorDetails : listErrors) {
                        
                        Error_Logger__c errorRecord = new Error_Logger__c();

                        errorRecord.Error_Message__c         = errorDetails.message + dataBaseRecord.id;
                        errorRecord.Error_Type__c            = String.valueOf(errorDetails.getStatusCode());
                        errorRecord.Stack_Trace_Message__c   = errorDetails.getMessage() ;
                        errorRecord.Name                     = String.valueOf(errorDetails.statuscode) + errorDetails.fields;

                        listErrorRecords.add(errorRecord);
                    }
                }
            }
        }
        if (listErrorRecords?.size() > 0) {
            
            insert as user listErrorRecords;
        }
    }
}