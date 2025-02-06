/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-28-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class ExtendingAbstractClass extends AbstractClass{
    
    //* Mandatory abstract method
    public override void start() {
        System.debug('I must override the start method');
    }

    //* other methods will be avilabe to use when we creat an object for this class
    //* in our case "action() & stop()" methods will be avilable.

    public override void action() {
        System.debug('Im overriding you to paly insted of dance');
    }
}   
