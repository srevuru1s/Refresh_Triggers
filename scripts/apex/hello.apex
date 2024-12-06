List<Opportunity> deletedRecords = [SELECT Id, Name FROM Opportunity WHERE isDeleted = true ALL ROWS];
System.debug('The deleted @@:' + deletedRecords.size());

Map<Id, Contact> oldContact = new Map<Id, Contact>([SELECT Id, Name FROM Contact]);
List<Contact> newCon = [SELECT Id, NAME FROM Contact WHERE Id IN: oldContact.values()];
System.debug('The query size:'+ newCon.size());