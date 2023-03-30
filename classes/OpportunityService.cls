public with sharing class OpportunityService {
    public static void updateAccountsAmountFromOpportunityAmount(List<Opportunity> newList) {
        List<Account> accountIds = new  List<Account>([SELECT Id FROM Account]);
        if(!newList.isEmpty() && !accountIds.isEmpty()) {
            for(Opportunity opportunity : newList) {
                if(String.isNotBlank(opportunity.AccountId)) {
                    for(Account accountId : accountIds) {
                        if(opportunity.AccountId == accountId.Id) {
                            accountId.Recent_Opportunity_Amount__c = opportunity.Amount;
                        }
                    }
                }
            }
        }
        update accountIds;  //NOPMD
    }

    public static Task createTask(Opportunity opportunity) {
        Task taskObj = new Task();
        taskObj.Subject = 'Call';
        taskObj.Status = 'Not Started';
        taskObj.Priority = 'Normal';
        taskObj.OwnerId = UserInfo.getUserId();
        taskObj.WhatId = opportunity.Id;  
        return taskObj;
    }
}