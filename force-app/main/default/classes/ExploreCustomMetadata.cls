/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-08-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class ExploreCustomMetadata {
    
    public static Decimal retievePricingParity (String regionName) {
        Decimal pricingParityIndex;
        
        if (String.isNotBlank(regionName)) {
            List<Inventory_Pricing__mdt> pricingMdt = [SELECT Id, DeveloperName, MasterLabel, Pricing_Parity__c, Region__c FROM Inventory_Pricing__mdt WHERE Region__c =: regionName LIMIT 1];

            if (pricingMdt?.size() > 0) {
                pricingParityIndex = pricingMdt[0].Pricing_Parity__c;
            }
            
        }
        return pricingParityIndex; 
    }
}