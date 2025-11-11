/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 07-07-2025
 * @last modified by  : sagar@salesforce.learning
**/
@RestResource(urlMapping = '/api/invokeWebhook/*')
global with sharing class WebHookHandler {
    
    @HttpPost
        global static String handlePost() {

            RestRequest requestContext = RestContext.request;
            RestResponse responseContext = RestContext.response;

            Account newAcc = new Account(Name = 'WebhookAccount');
            insert newAcc;

            return newAcc.Id;
        }
    @HttpGet
        global static List<Account> handleGet() {

            return [SELECT Id, Name FROM Account LIMIT 10];
        }
}