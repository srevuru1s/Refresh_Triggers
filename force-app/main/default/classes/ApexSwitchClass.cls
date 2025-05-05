/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 02-28-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class ApexSwitchClass {

    public Integer numberToSwitch;
    public String stringToSwitch;

    public ApexSwitchClass(Integer myNumber, String myName) {
        this.numberToSwitch = myNumber;
        this.stringToSwitch = myName;
    }

    public void switchMethod() {

        switch on numberToSwitch {
            when 0,1 {
                System.debug('Switch when 0 or 1');
            }
            when null {
                System.debug('Switch when it is NULL');
            }
            when else {
                System.debug('Switch when ELSE');
            }
        }
    }

    
}