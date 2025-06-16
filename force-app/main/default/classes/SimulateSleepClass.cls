/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 06-04-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class SimulateSleepClass {
    
    
        public static void addDelay(Integer setTime) {
        
        Long start = DateTime.now().getTime();
        System.debug('Start Time' + start);

            while (DateTime.now().getTime() - start < setTime) {
                // busy wait (consumes CPU time)
                System.debug('This is the consumed Time');
            }    
        }
        
}