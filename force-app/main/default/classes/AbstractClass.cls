/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-28-2025
 * @last modified by  : sagar@salesforce.learning
**/
//* Defining the class with "abstract" keyword
public abstract class AbstractClass {

    //* abstract method must be implemented, must not have a body
    public abstract void start();

    //* virtual method 
    public virtual void action() {
        System.debug('Let\'s dance for my faviour song');
    }

    //* concreat method
    public void stop() {
        System.debug('Thanks for your entertainment');
    }

}