    /**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 11-27-2024
 * @last modified by  : sagar@salesforce.learning
**/
public with sharing class OpportunityTriggerHelper {

    //* Update the trigger Amount field
        public static void updateTriggerAmount(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldMapOpportunities) {
            
            if (newOpportunities?.size() > 0) {

                for (Opportunity opportunityRecord : newOpportunities) {
                    //* condition to check the opp stage is Modified
                    if (opportunityRecord.StageName != oldMapOpportunities.get(opportunityRecord.Id).StageName) {
                        opportunityRecord.Amount  = (opportunityRecord.Probability * opportunityRecord.ExpectedRevenue);
                        opportunityRecord.Description = 'Updated From Trigger';
                        
                    }
                }
            }
        }

}