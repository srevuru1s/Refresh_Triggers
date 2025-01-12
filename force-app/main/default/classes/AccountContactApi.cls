/**
 * @description       : 
 * @author            : sagar@salesforce.learning
 * @group             : 
 * @last modified on  : 01-12-2025
 * @last modified by  : sagar@salesforce.learning
**/
@RestResource (Urlmapping = '/AccountContactApi')
global with sharing class AccountContactApi {
    
    @httpPost
    global static void saveAccContFromExtSys() {

        RestRequest req  = RestContext.request;
        RestResponse res = RestContext.response;

        String body = req.requestBody.toString();
        MyJsonClass result = (MyJsonClass) JSON.deserialize(body, MyJsonClass.class);

        if (result.isAccount == true) {
            
            Account acc = new Account (Name = result.CustomerName);
            Insert acc;
        } else if (result.isAccount == false) {
            Contact con = new Contact(LastName = result.CustomerName);
            Insert con;
        }

    }
}