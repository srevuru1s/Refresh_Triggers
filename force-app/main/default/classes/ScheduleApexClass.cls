/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 06-11-2025
 * @last modified by  : sagar@salesforce.learning
**/
global with sharing class ScheduleApexClass implements Schedulable{
    
    global static void execute(System.SchedulableContext sc) {
        
        FutureMethodClass.updateAccount(new List<Id>{'001aj00000ruyRRAAY', '001aj00000ruyRSAAY'});
    }
}