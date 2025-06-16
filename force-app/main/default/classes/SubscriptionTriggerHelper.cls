/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 05-23-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class SubscriptionTriggerHelper {
    
    //* Deselect the old Subscriber Recent check box and add for the new one
    public static void verifyRecentCheckBoxField(List<Subscription__c> newSubscriptions) {

        //* Collect the account Id for the sub
        Map<Id,Subscription__c> mapAccountIdSub = new Map<Id,Subscription__c>();
        //*List of sub's toupdate
        List<Subscription__c> listSubToUpdated = new List<Subscription__c>();

        if (newSubscriptions?.size() > 0) {
            //* loop through the records to collect the account Id and verify the recent field
            for (Subscription__c subRecord : newSubscriptions) {
                
                if (subRecord.Recent__c != true && String.isNotBlank(subRecord.Account_Name__c)) {
                    
                    subRecord.Recent__c = true;
                }
                mapAccountIdSub.put(subRecord.Account_Name__c, subRecord);
            }
        }

        if (mapAccountIdSub?.size() > 0) {
            //*Query the account and related sub records 

            for (Subscription__c subRecord : [SELECT Id FROM Subscription__c WHERE Recent__c = true AND Account_Name__c IN :mapAccountIdSub.keySet()  WITH USER_MODE LIMIT 50000]) {
                
                Subscription__c updateSub = new Subscription__c(Id = subRecord.Id, Recent__c = false);
                listSubToUpdated.add(updateSub);
            }
        }

        if (listSubToUpdated?.size() > 0) {
            ErrorHandler.handleUpdateExceptions(listSubToUpdated);
        }
    }
    public static void createFeatureRecords(List<Subscription__c> newSubscriptions, Map<Id, Subscription__c> newMapSubscriptions) {

        //* collect the Map of Feature records to be inserted
        List<Feature__c> newFeatureList = new List<Feature__c>();

        //* Map of plan and its feature records to be created
        Map<Id,Integer> numberOfFeatureRecordsToCreated = new Map<Id,Integer>();
        //* get the new map records
        if (newMapSubscriptions?.size() > 0) {
            
            //* loop through the records Basic = 2, Advance = 3, Premium = 5
            for (Subscription__c newSubRecord : newMapSubscriptions.values()) {
                
                //* condition to check for the plan 
                switch on newSubRecord.Plans__c {
                    when 'Basic' {
                        numberOfFeatureRecordsToCreated.put(newSubRecord.Id, 2);
                    }
                    when 'Advance' {
                        numberOfFeatureRecordsToCreated.put(newSubRecord.Id, 3);
                    }
                    when 'Premium' {
                        numberOfFeatureRecordsToCreated.put(newSubRecord.Id, 5);
                    }
                }
    
            }
        }

        //* Create a new Feature records
        if (numberOfFeatureRecordsToCreated?.size() > 0) {
            
            for (Id subId : numberOfFeatureRecordsToCreated.keySet()) {

                for (Integer i = 0; i <  numberOfFeatureRecordsToCreated.get(subId); i++) {
                    
                    Feature__c newFeatureRecord                = new Feature__c();
                    newFeatureRecord.Name                      = subId + String.valueOf(i);
                    newFeatureRecord.Subscription__c           = subId;
                    newFeatureRecord.Number_Devices_Support__c = numberOfFeatureRecordsToCreated.get(subId);
                    newFeatureRecord.Quality__c                = numberOfFeatureRecordsToCreated.get(subId) == 2 ? '1080PI' :
                                                                numberOfFeatureRecordsToCreated.get(subId) == 3 ? '4K HD; Dolby Atmos' : 'Dolby Atmos; Dolby Vison';
                    newFeatureRecord.Is_Active__c              = true;

                    newFeatureList.add(newFeatureRecord);
                }
            }
        
        }

        //* Insert new feature records
        if (newFeatureList?.size() > 0) {
            
            ErrorHandler.dataBaseInsert(newFeatureList);
        }
    }

    //* update feature records based on the plan
    public static void updateFeatureRecords(Map<Id,Subscription__c> newMapSubscriptions,Map<Id,Subscription__c> oldMapSubscriptions) {

        Map<Id,Integer> subIdNewFeatureRecordsToCreate = new Map<Id,Integer>();
        Map<Id,Integer> subIdOldFeatureRecordsDeactivate = new Map<Id,Integer>();

        if(newMapSubscriptions.size() > 0) {
            //* loop through the record to check the plan updated?
            for (Subscription__c newSubRecord : newMapSubscriptions.values()) {
                
                if (newSubRecord.Plans__c != oldMapSubscriptions.get(newSubRecord.Id).Plans__c) {

                    Integer newPlan = newSubRecord.Plans__c == 'Basic' ? 2 : newSubRecord.Plans__c == 'Advance' ? 3 : 5;
                    Integer oldPlan = oldMapSubscriptions.get(newSubRecord.Id).Plans__c == 'Basic' ? 2 :
                                                    oldMapSubscriptions.get(newSubRecord.Id).Plans__c == 'Advance' ? 3 : 5;
                    
                    if (newPlan > oldPlan) {
                        
                        Integer featureRecordsToCreate = newPlan - oldPlan;
                        subIdNewFeatureRecordsToCreate.put(newSubRecord.Id, featureRecordsToCreate);
                    } else {
                        //* we have one 1 record in plan difference for basic is handled 
                        Integer featureRecordsToDeactivate = oldPlan - newPlan ;
                        subIdOldFeatureRecordsDeactivate.put(newSubRecord.Id, featureRecordsToDeactivate);
                    }
                }
            }
        }
        //* collect Map of new feature records to create
        Map<Id, List<Feature__c>> newFeatureRecordsMap = new Map<Id,List<Feature__c>>();
        //* collect list of feature records that need to be passed into the Map
        List<Feature__c> listFeatureRecords = new List<Feature__c>();

        //* Query the records to create
        if (subIdNewFeatureRecordsToCreate?.size() > 0) {
            List<Feature__c> allFeatureRecords =  queryFeatureRecords(subIdNewFeatureRecordsToCreate, true);
            
            if (allFeatureRecords?.size() > 0) {
                
                //* Loop through the feature records
                for (Feature__c featureRecord : allFeatureRecords) {
                    
                    if (!newFeatureRecordsMap.containsKey(featureRecord.Subscription__c)) {
                        
                        for (Integer i=0; i < subIdNewFeatureRecordsToCreate.get(featureRecord.Subscription__c); i++) {

                            Feature__c creteNewFeature                = new Feature__c();
                            creteNewFeature.Subscription__c           = featureRecord.Subscription__c;
                            creteNewFeature.Is_Active__c              = true;
                            creteNewFeature.Number_Devices_Support__c = featureRecord.Number_Devices_Support__c;
                            creteNewFeature.Quality__c                = featureRecord.Quality__c;
                            
                            listFeatureRecords.add(creteNewFeature);
                            
                        }
                        newFeatureRecordsMap.put(featureRecord.Subscription__c, listFeatureRecords);
                    }
                }
            }
        }

        //* insert the new feature records
        if (newFeatureRecordsMap.size() > 0) {
            //* collect all the feature records into the list 
            List<Feature__c> allFeatureRecords = new List<Feature__c>();

            //* loop through list<list> feature records
            for (List<Feature__c> featureRecordsList : newFeatureRecordsMap.values()) {
                allFeatureRecords.addAll(featureRecordsList);    
            }

            if (allFeatureRecords?.size() > 0) {
                
                ErrorHandler.handleInsertExceptions(allFeatureRecords);
            }
        }

        //* collect Map of deactivate feature records 
        Map<Id, List<Feature__c>> deactiveFeatureRecordsMap = new Map<Id,List<Feature__c>>();
        //* collect list of feature records that need to be passed into the Map
        Map<Id, Feature__c> mapDeactivateFeatureRecords = new Map<Id, Feature__c>();

        //* Query the records to be deactivated 
        if (subIdOldFeatureRecordsDeactivate?.size() > 0) {
            List<Feature__c> allFeatureRecords =  queryFeatureRecords(subIdOldFeatureRecordsDeactivate, true);

            if (allFeatureRecords?.size() > 0) {
                
                for (Feature__c  featureRecord : allFeatureRecords) {
                    
                        for (Integer i=0; i <= subIdOldFeatureRecordsDeactivate.get(featureRecord.Subscription__c); i++) {
                            
                            System.debug('Key :' + subIdOldFeatureRecordsDeactivate.get(featureRecord.Subscription__c));
                            //* check the feature record isActive or not
                            if (featureRecord.Is_Active__c != false) {
                                
                                Feature__c updateFeatureRecord                = new Feature__c();
                                updateFeatureRecord.Id                        = featureRecord.Id;
                                updateFeatureRecord.Is_Active__c              = false;
    
                                //* decreasing the map of deactivation records by 1 every time loop runs
                                    
                                subIdOldFeatureRecordsDeactivate.put(featureRecord.Subscription__c, subIdOldFeatureRecordsDeactivate.get(featureRecord.Subscription__c) - 1);
                                
                                if (!mapDeactivateFeatureRecords.containsKey(featureRecord.Id)) {
                                    
                                    mapDeactivateFeatureRecords.put( featureRecord.Id, updateFeatureRecord);
                                    System.debug('The size of the list :' + mapDeactivateFeatureRecords.size());
                                }
                            }

                        }
                        deactiveFeatureRecordsMap.put(featureRecord.Subscription__c, mapDeactivateFeatureRecords.values());
                        System.debug('Count of the map records: ' + deactiveFeatureRecordsMap.size());
                    
                }
            }
        }

        //* update the feature records
        if (deactiveFeatureRecordsMap.size() > 0) {
            //* collect all the feature records into the list 
            List<Feature__c> allFeatureRecords = new List<Feature__c>();
        
            //* loop through list<list> feature records
            for (List<Feature__c> featureRecordsList : deactiveFeatureRecordsMap.values()) {
                        allFeatureRecords.addAll(featureRecordsList);    
            }
        
            if (allFeatureRecords?.size() > 0) {
            
                System.debug('List of all records :'+ allFeatureRecords.size());
                System.debug('List of all records :'+ allFeatureRecords);
                update as user allFeatureRecords;
                //ErrorHandler.handleUpdateExceptions(allFeatureRecords);
            }
        }
    }

    public static List<Feature__c> queryFeatureRecords(Map<Id,Integer> mapOfSubIdToFeatureRecords, Boolean isActive) {

        if (mapOfSubIdToFeatureRecords?.size() > 0) {
            
            //* Query the records
            List<Feature__c> featureRecordList = [SELECT Id, Is_Active__c, Subscription__c, Number_Devices_Support__c, Quality__c FROM Feature__c WHERE Subscription__c IN : mapOfSubIdToFeatureRecords.keySet() AND Is_Active__c =: isActive
                                                    WITH USER_MODE ORDER BY CreatedDate ASC LIMIT 50000];

            return featureRecordList;
        } else {
            return new List<Feature__c>();
        }
    }
    
    public static void afterDeleteUpdateSubRecord(Map<Id,Subscription__c> mapOfSubscriptions) {
    
        //* Collect the account Id for the sub
        Map<Id,Subscription__c> mapAccountIdSub = new Map<Id,Subscription__c>();
        //* collect the Map of subs to get updated
        Map<Id,Subscription__c> mapSubsToUpdate = new Map<Id,Subscription__c>();

        if (mapOfSubscriptions?.size() > 0) {
            
            //* get the account id from  the subs
            //* loop through the records to collect the account Id and verify the recent field
            for (Subscription__c subRecord : mapOfSubscriptions.values()) {
                
                if (subRecord.Recent__c == true && String.isNotBlank(subRecord.Account_Name__c)) {
                    
                    mapAccountIdSub.put(subRecord.Account_Name__c, subRecord);
                }
            }
        }
        if (mapAccountIdSub?.size() > 0) {
            //* Query the latest sub to update the Recent field
            for(Subscription__c subRecord : [SELECT Id, Account_Name__c FROM Subscription__c WHERE Account_Name__c IN: mapAccountIdSub.keySet() AND Id NOT IN: mapOfSubscriptions.keySet() WITH USER_MODE
                                                        ORDER BY Id DESC LIMIT 50000]) {
                
                //* check the map if it got the sub record or not?
                if (!mapSubsToUpdate?.containsKey(subRecord.Account_Name__c)) {
                    subRecord.Recent__c = true;
                    mapSubsToUpdate.put(subRecord.Account_Name__c, subRecord);
                }
                
            }
        }

        if (mapSubsToUpdate?.size() > 0) {
            ErrorHandler.handleUpdateExceptions(mapSubsToUpdate.values());
        }
    
    }
}