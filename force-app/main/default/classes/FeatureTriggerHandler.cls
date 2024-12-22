/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 12-22-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class FeatureTriggerHandler {
 

    //* After Create = Update the Subscription record field 
    public static void updateSubscriptionRecord(Map<Id,Feature__c> newMapFeatures) {
        //* Map of subscription id's
        Map<Id,Feature__c> mapSubIdFeature = new Map<Id,Feature__c>(); 

        //* List of Feature records to update
        List<Subscription__c> listSubscriptionRecords = new List<Subscription__c>();

        //* loop through the records
        if (newMapFeatures.size() > 0) {
            
            //* loop through the map values
            for (Feature__c featureRecord : newMapFeatures.values()) {
            
                if (!(String.isBlank(featureRecord.Subscription__c)) && featureRecord.Subscription__c != null) {
                    
                    mapSubIdFeature.put(featureRecord.Subscription__c, featureRecord);
                }
            }
        }

        //* Query the number feature records associate with sub
        if (mapSubIdFeature?.size() > 0) {
            
            List<AggregateResult> aggRecords = [SELECT COUNT(ID) numberOfFeatureRecord, Subscription__c subscriptionId FROM Feature__c WHERE Subscription__c IN: mapSubIdFeature.keySet() 
                                                WITH USER_MODE GROUP BY Subscription__c LIMIT 50000];
            for (AggregateResult aggRec : aggRecords) {
                
                Integer allRecords = (Integer) aggRec.get('numberOfFeatureRecord');
                String subId       = (String) aggRec.get('subscriptionId');
                
                //* update the records
                Subscription__c updateRecord  = new Subscription__c();
                updateRecord.Id               = subId;
                updateRecord.Feature_Count__c = allRecords;

                listSubscriptionRecords.add(updateRecord);
            }
        }

        //* update the records
        if (listSubscriptionRecords?.size() > 0) {
            ErrorHandler.handleUpdateExceptions(listSubscriptionRecords);
        }
    }
    //* After Update = Update the Subscription record field

    public static void handleAfterUpdate(Map<Id,Feature__c> newMapFeature, Map<Id,Feature__c> oldMapFeature) {

        //* collect the record Id of feature records to got deactivate
        Map<Id,Feature__c> mapDeactivatedFeatureRecords =  new Map<Id,Feature__c>();
        //* Collect the list of sub record to be updated
        Map<Id,Subscription__c> mapSubRecordToUpdate = new Map<Id,Subscription__c>();

        if (newMapFeature?.size() > 0) {
            
            //* loop through the records to check the isActive field updated?
            for (Feature__c newFeatureRecord : newMapFeature.values()) {
                
                if (newFeatureRecord.Is_Active__c != true) {
                    
                    mapDeactivatedFeatureRecords.put(newFeatureRecord.Subscription__c, newFeatureRecord);
                }
            }
        }

        //* Query the records to update the subscription records
        if (mapDeactivatedFeatureRecords?.size() > 0) {
            
            List<AggregateResult> listAggResult = [SELECT COUNT(Id) numberofActiveRecords, Subscription__c subId FROM Feature__c WHERE Is_Active__c = true AND Subscription__c IN:mapDeactivatedFeatureRecords.keySet()
                                                    WITH USER_MODE GROUP BY Subscription__c LIMIT 50000];
            
            //* Loop through the aggregate results
            for (AggregateResult aggRecord : listAggResult) {
                
                Integer activeRecords = (Integer) aggRecord.get('numberofActiveRecords');
                Id subscriptionId     = (Id) aggRecord.get('subId');

                Subscription__c updateSubRecord   = new Subscription__c();
                updateSubRecord.Id                = subscriptionId;
                updateSubRecord.Feature_Count__c  = activeRecords;

                mapSubRecordToUpdate.put(subscriptionId, updateSubRecord);
            }
        }

        //* update the sub records 
        if (mapSubRecordToUpdate?.size() > 0) {

            ErrorHandler.handleUpdateExceptions(mapSubRecordToUpdate.values());
        }
    }
}