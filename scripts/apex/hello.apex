

BatchApex scheduleClass = new BatchApex('Batch Apex');
scheduleClass.execute(null);

List<AggregateResult> totalAccounts = [SELECT COUNT(), Industry FROM Account GROUP BY Industry];
System.debug('Total Accounts :' + totalAccounts);

List<AggregateResult> totalNumberOfRecordsWithValue = [SELECT COUNT(AnnualRevenue) FROM Account];
System.debug('Total number of records with value :' + totalNumberOfRecordsWithValue);

List<AggregateResult> aggResults = [SELECT COUNT(Id) oppId, StageName oppStage FROM Opportunity WHERE StageName != 'Open' GROUP BY StageName  HAVING COUNT(Id) > 1];
for (AggregateResult aggRecord : aggResults) {
    
    Integer numberOfOppRecords        = (Integer) aggRecord.get('oppId');
    String opportunityStageName       = (String) aggRecord.get('oppStage');

    System.debug('The Opp Id :' + numberOfOppRecords);
    System.debug('The Opp stage name :' + opportunityStageName);
}
