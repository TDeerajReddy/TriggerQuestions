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

    public static void updateAccountAnnualRevenue(List<Opportunity> opportunityList) {
        Set<Id> accountIds = new Set<Id>();
        if(Trigger.isDelete && Trigger.isBefore) {
            for (Opportunity opportunity : opportunityList) {
                accountIds.add(opportunity.AccountId);
            }
        }

        if(Trigger.isUndelete && Trigger.isAfter) {
            for (Opportunity opportunity : opportunityList) {
                accountIds.add(opportunity.AccountId);
            }
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            Account accountObject = new Account();
                // accountObject.Id = accountId;
                // accountObject.AnnualRevenue = [SELECT SUM(Amount) FROM Opportunity WHERE AccountId =: accountId AND IsDeleted = FALSE];
            accountsToUpdate.add(accountObject);
        }

        if(!accountsToUpdate.isEmpty())
            update accountsToUpdate;    //NOPMD
    }
}