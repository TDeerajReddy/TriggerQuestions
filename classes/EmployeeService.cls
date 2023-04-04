public with sharing class EmployeeService {

    public static void updateLeftEmployeeCount(List<Employee__c> oldEmployeeList) {
        Set<Id> accountIds = new Set<Id>();
        for(Employee__c employee : oldEmployeeList) {
            accountIds.add(employee.AccountId__c);
        }
        List<Account> accountList = new List<Account>();

        for(AggregateResult result : [SELECT AccountId__c,
                                        COUNT(Id) employeeCount
                                        FROM Employee__c 
                                        WHERE AccountId__c IN : accountIds 
                                        GROUP BY AccountId__c]) {   //NOPMD

            Account accountToUpdate = new Account(
                Id = (Id)result.get('AccountId__c'),
                Left_Employee_Count__c = (Integer)result.get('employeeCount')
            );
            accountList.add(accountToUpdate);
        }
        update accountList; //NOPMD
    }

    public static void changePresentEmployeeCount(List<Employee__c> employeeList) {
        Set<Id> accountIds = new Set<Id>();
        List<Account> accountsToBeUpdated = new List<Account>();

        for(Employee__c employee : employeeList) {
            accountIds.add(employee.AccountId__c);
        }
        List<Account> accountList = [SELECT Id, Present_Employee_Count__c,
                                        (SELECT Id__c FROM Employees__r) 
                                        FROM Account WHERE Id IN : accountIds];

        for(Account account : accountList) {

            Account accountToUpdate = new Account(
                Id = account.Id,
                Present_Employee_Count__c = account.Employees__r.size()
            );
            accountsToBeUpdated.add(accountToUpdate);
        }
        update accountsToBeUpdated; //NOPMD
    }
}