1. Retrieve Accounts where at least two Contacts have the same email domain.
SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Contact WHERE Email Like '%.com%')
2. Fetch Opportunities where the total Amount of related won Opportunities exceeds the Amount of the current Opportunity.
SELECT SUM(Amount) , AccountId opportunityId FROM Opportunity  WHERE StageName = 'Closed Won'  GROUP BY AccountId 
3. List all Accounts that don’t have any Cases, but their related Contacts do.
SELECT Name, Id, (SELECT Id, ContactId, CaseNumber FROM Cases WHERE ContactId != null ) FROM Account WHERE Id NOT IN (SELECT AccountId FROM Case)

4. Find Users who have created more than five records across different objects in the last 24 hours.

5. Identify Opportunities where the related Account has no active Cases but at least one closed Opportunity.

6. Retrieve all Cases where the same Contact is listed as the Contact multiple times in the Case hierarchy (e.g., Parent and Child Cases).

7. List all Accounts with an Opportunity closing in the next 30 days, but no related Tasks due within the same timeframe.

8. Find Contacts who are associated with multiple Accounts, but none of their Accounts have any open Opportunities.

9. Fetch all Opportunities where the related Account's AnnualRevenue is less than the Opportunity Amount.

10. Identify Accounts where all related Opportunities are closed and the total number of Contacts is greater than 10.
SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity WHERE StageName = 'Closed Won' ) 


Develop high quality, reusable and maintainable code using Apex, Visual Force, Apex Triggers, Aura, Lightning Web Components.												
Work on Salesforce Education cloud, Experience Cloud, Data Cloud and Marketing Cloud implementation and provide best customizations.												
Develop Complex and reusable integration framework on force.com systems and integrate with third party systems for enterprise using SOAP, RESTFUL Services.												
Build Salesforce UI components using new Lightning Web Components and Aura Components framework.												
Write new highly complex Salesforce Advanced Apex programming including core design patterns, limits and bulk patterns, efficient and reliable trigger handling, asynchronous operations and effective unit testing.												
Implement additional API techniques such as Salesforce Bulk, REST, SOAP, Streaming and Metadata API.												
Partner with other team members to deliver innovative solutions to our business users through requirements gathering, technical design, development, and quality assurance.												
Work with Salesforce.com administration, end user security, problem solving, triage, and troubleshooting complex Salesforce implementation.												
"Work with technical leads, solution architects, Business users and other development staff to accomplish Salesforce project deliverables.	"												
Perform Salesforce platform configurations, customizations, declarative development, troubleshooting, end-user support, platform updates, enhancements and maintenance.												
Perform Deployments using Continuous Integration/ Deployment (CI/CD) tools – Jenkins, Copado and Salesforce DX.												
Craft Lightning Apps combining Lightning Design System, Lightning App Builder and Lightning Web Component features.												
Perform API Integration between Salesforce, Braze and other third-party systems using REST/SOAP APIs (XML, JSON).												
"Develop custom reusable Lightning components using  Aura, LWC  framework and develop backend logic using Apex (classes/controllers/triggers), SOQL, platform apps, custom apps, design app data models, interfaces, and security.

1. Updated from the local to git 
2. These updates are only in my Local.
3. After the user has been updated with credentials.
4. Updated from feature branch.
5. Updated from Main Branch