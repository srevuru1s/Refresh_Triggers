if (allFeatureRecords?.size() > 0) {
    // Loop through each feature record
    for (Feature__c featureRecord : allFeatureRecords) {
        // Get the deactivation count for the current subscription
        Integer deactivationCount = subIdOldFeatureRecordsDeactivate.get(featureRecord.Subscription__c);

        // Check if deactivation is needed
        if (deactivationCount != null && deactivationCount > 0) {
            // Process only specific records based on additional criteria
            if (/* ADD YOUR CONDITION HERE, e.g., featureRecord.SomeField__c == 'SomeValue' */) {
                // Process this feature record `deactivationCount` times
                for (Integer i = 0; i < deactivationCount; i++) {
                    // Create a new record for deactivation
                    Feature__c newFeatureRecord = new Feature__c();
                    newFeatureRecord.Id = featureRecord.Id;
                    newFeatureRecord.Is_Active__c = false;

                    // Ensure the subscription has an entry in the map
                    if (!deactiveFeatureRecordsMap.containsKey(featureRecord.Subscription__c)) {
                        deactiveFeatureRecordsMap.put(featureRecord.Subscription__c, new List<Feature__c>());
                    }

                    // Add the feature record to the list under the subscription
                    deactiveFeatureRecordsMap.get(featureRecord.Subscription__c).add(newFeatureRecord);
                }
            }
        }
    }
}