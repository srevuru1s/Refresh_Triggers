/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 05-14-2025
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class MarketPlaceTriggerHandler {


    //* Handle After Insert
    public static void handleAfterInsert(List<Market_Place__c> newMarketPlaceList, Map<Id,Market_Place__c> newMarketPlaceMap) {

        addActiveMarkerPlaceField(newMarketPlaceMap);

    }
    //*  Handle After Update
    public static void handleAfterUpdate(Map<Id,Market_Place__c> oldMarketPlaceMap, Map<Id,Market_Place__c> newMarketPlaceMap) {

        //* updated map records for market place
        Map<Id,Market_Place__c> updatedMarketPlaceMapRecords = new Map<Id,Market_Place__c>();

        if (newMarketPlaceMap?.size() > 0) {
            
            for (Market_Place__c marketPlaceRecords : newMarketPlaceMap.values()) {
                
                if (marketPlaceRecords.Name != oldMarketPlaceMap.get(marketPlaceRecords.Id).Name) {
                    
                    updatedMarketPlaceMapRecords.put(marketPlaceRecords.Id, marketPlaceRecords);
                }
            }
        }

        if (updatedMarketPlaceMapRecords?.size() > 0) {
            
            addActiveMarkerPlaceField(updatedMarketPlaceMapRecords);
        }
    }
    //* Handle After Delete
    public static void handleAfterDelete(Map<Id,Market_Place__c> oldMarketPlaceMap) {

        //* Map asset id and deleted record
        Map<Id,Market_Place__c> assetIdKey = new Map<Id,Market_Place__c>();

        //* list of accrecords to update after delete
        List<Account> listAccRecords = new List<Account>();

        if (oldMarketPlaceMap?.size() > 0) {
            
            for (Market_Place__c deletedRecord : oldMarketPlaceMap.values()) {
                
                assetIdKey.put(deletedRecord.Asset__c, deletedRecord);
            }
        }

        //* lets query the account Id associated with Asset record
        if (assetIdKey?.size() > 0) {
            //* Query the account records to update
            for (Asset assRecord : [SELECT Account.Active_Marketplace__c, AccountId FROM Asset WHERE Id IN: assetIdKey.keySet() WITH USER_MODE LIMIT 50000]) {
                
                String accActiveMarketPlaces = assRecord.Account.Active_Marketplace__c;
                String deletedMarketPlace    = assetIdKey.get(assRecord.Id).Name;

                Account accRecord = new Account();
                accRecord.Id      = assRecord.AccountId;
                accRecord.Active_Marketplace__c = accActiveMarketPlaces.contains(deletedMarketPlace) ?  accActiveMarketPlaces.remove(deletedMarketPlace) : accActiveMarketPlaces;

                listAccRecords.add(accRecord);
            }
        }

        if (listAccRecords?.size() > 0) {
            
            ErrorHandler.handleUpdateExceptions(listAccRecords);
        }
    }
    //* Utility class for account field update
    public static void addActiveMarkerPlaceField(Map<Id, Market_Place__c> mapMarketPlaceRecords) {
        //* List of account records to update
        List<Account> accList = new List<Account>();

        if (mapMarketPlaceRecords?.size() > 0) {
            
            //* get the account fields that need to updated/added
            for (Market_Place__c marketPlaceRecord : [SELECT Id, Name, Asset__r.AccountId, Asset__r.Account.Active_Marketplace__c FROM Market_Place__c WHERE Id IN : mapMarketPlaceRecords.keySet() WITH USER_MODE LIMIT 50000]) {
                
                String accMarketPlace = marketPlaceRecord.Asset__r.Account.Active_Marketplace__c;
                Boolean checkValue = (accMarketPlace).contains(marketPlaceRecord.Name);

                Account acc = new Account();
                acc.Id      = marketPlaceRecord.Asset__r.AccountId;
                acc.Active_Marketplace__c = accMarketPlace == null ? marketPlaceRecord.Name : (checkValue) ? accMarketPlace : (accMarketPlace + ',' + marketPlaceRecord.Name) ;
                
                accList.add(acc);
            }
        }

        if (accList?.size() > 0) {
            
            ErrorHandler.handleUpdateExceptions(accList);
        }
    }
}