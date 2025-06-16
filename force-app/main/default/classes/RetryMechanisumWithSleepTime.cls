/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 06-04-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class RetryMechanisumWithSleepTime {
    
    public static void sleepTime() {

        Integer initialCall = 0;
        Integer maxAttempts = 2;

        do {
            try{
                Account myAcc = new Account(Industry = 'Energy');
                insert myAcc;
                break;
            } catch(System.Exception ex) {
                initialCall ++;
                if(initialCall < maxAttempts) {
                    SimulateSleepClass.addDelay(20);
                } else {
                    throw new CustomException('Maximum Tries Reached');
                }
            }
        } while (initialCall < maxAttempts);
    }
}