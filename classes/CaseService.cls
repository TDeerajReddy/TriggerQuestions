public with sharing class CaseService {
    public static void updateLatestCaseNumberIntoAccount(List<Case> newList) {
        List<Account> accountIds = new  List<Account>([SELECT Id, Name FROM Account]);
        newList = [SELECT CaseNumber, CreatedDate, AccountId, Account.Name FROM Case ORDER BY CreatedDate DESC LIMIT 1];    //NOPDM
            if(String.isNotBlank(newList[0].AccountId) && !accountIds.isEmpty()) {
                for(Account accountId : accountIds) {
                    if(newList[0].AccountId == accountId.Id) {
                        accountId.Latest_Case_Number__c = newList[0].CaseNumber;
                    }
                }
            }
        update accountIds;  //NOPMD
    }
}