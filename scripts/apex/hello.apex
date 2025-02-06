List <Account> acc1 = [SELECT Id, Name FROM Account WHERE Name LIKE '%Spirit%'];
System.debug(acc1.size());

if(acc1.size() > 0) {
    merge acc1[0] acc1[1];
    merge acc1[0] acc1[2];
}