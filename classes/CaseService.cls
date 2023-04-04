public with sharing class CaseService {
    //NOT WORKIG
    public static void updateLatestCaseNumberIntoAccount(List<Case> newCaseList) {
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Integer> partnerCases = new Map<Id, Integer>();
        Map<Id, Integer> customerCases = new Map<Id, Integer>();
        
        for (Case caseIterator : newCaseList) {
            accountIds.add(caseIterator.AccountId);
            if (caseIterator.RecordTypeId == 'Partner Case') {
                if (partnerCases.containsKey(caseIterator.AccountId)) {
                    partnerCases.put(caseIterator.AccountId, partnerCases.get(caseIterator.AccountId) + 1);
                } else {
                    partnerCases.put(caseIterator.AccountId, 1);
                }
            } else if (caseIterator.RecordTypeId == 'Customer Case') {
                if (customerCases.containsKey(caseIterator.AccountId)) {
                    customerCases.put(caseIterator.AccountId, customerCases.get(caseIterator.AccountId) + 1);
                } else {
                    customerCases.put(caseIterator.AccountId, 1);
                }
            }
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            Account a = new Account(Id = accountId);
            if (partnerCases.containsKey(accountId)) {
                a.Total_Partner_Case__c = partnerCases.get(accountId);
            }
            if (customerCases.containsKey(accountId)) {
                a.Total_Customer_Case__c = customerCases.get(accountId);
            }
            accountsToUpdate.add(a);
        }
        if(!accountsToUpdate.isEmpty())
            update accountsToUpdate;    //NOPMD
        
        // List<Account> accountIds = new  List<Account>([SELECT Id, Name FROM Account]);
        // newCaseList = [SELECT CaseNumber, CreatedDate, AccountId, Account.Name FROM Case ORDER BY CreatedDate DESC LIMIT 1];    //NOPDM
        //     if(String.isNotBlank(newCaseList[0].AccountId) && !accountIds.isEmpty()) {
        //         for(Account accountId : accountIds) {
        //             if(newCaseList[0].AccountId == accountId.Id) {
        //                 accountId.Latest_Case_Number__c = newCaseList[0].CaseNumber;
        //             }
        //         }
        //     }
        // update accountIds;  //NOPMD
    }
}