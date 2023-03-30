public with sharing class OpportunityTriggerHandler {
    public static void beforeInsert(List<Opportunity> opportunityList) {
        if(!opportunityList.isEmpty()) {
            // changeOpportunityDescriptionForAmmount(opportunityList);
            // changeOpportunityDescriptionForStage(opportunityList);
        }
    }

    public static void afterInsert(List<Opportunity> opportunityList) {
        OpportunityService.updateAccountsAmountFromOpportunityAmount(opportunityList);
    }

    public static void beforeUpdate(List<Opportunity> newOpportunityList, Map<Id, Opportunity> newOpportunityMap, List<Opportunity> oldOpportunityList, Map<Id, Opportunity> oldOpportunityMap) {   //NOPMD
        if(!newOpportunityList.isEmpty()) {
            // changeOpportunityDescriptionForStage(newOpportunityList);
        }
        if(!oldOpportunityList.isEmpty()) { 
            // errorForClosedLostReason(oldOpportunityList); //Q12
        }
        changeOpportunityDescriptionForStageRecursion(newOpportunityList);   //26    //Not Working
    }

    public static void afterUpdate(List<Opportunity> newOpportunityList, Map<Id, Opportunity> newOpportunityMap, List<Opportunity> oldOpportunityList, Map<Id, Opportunity> oldOpportunityMap) {    //NOPMD
        if(!newOpportunityList.isEmpty()) {
            // updateOpportunityTask(newOpportunityList, oldOpportunityList); //Q7
        }

    }

    public static void beforeDelete(List<Opportunity> oldList) {    //NOPMD   
        // checkUserCanDeleteOpportunityOrNot(oldList);    //Q14
    }

    public static void afterDelete(List<Account> oldList) { //NOPMD
        
    }

    public static void changeOpportunityDescriptionForAmmount(List<Opportunity> opportunityList) {
        for(Opportunity opportunity : opportunityList) {
			if(opportunity.Amount != NULL && opportunity.Amount > 100000) {
				opportunity.Description = 'Hot Opportunity';
			}
        }
    }

    public static void changeOpportunityDescriptionForStage(List<Opportunity> opportunityList) {
        for(Opportunity opportunity : opportunityList) {
            if(opportunity.StageName == 'Closed Won') {
                opportunity.Description = 'Opp is Closed Won';
            } else if(opportunity.StageName == 'Closed Lost') {
                opportunity.Description = 'Opp is Closed Lost';
            } else {
                opportunity.Description = 'Opp is Open';
            }
        }
    }

    //Not Working
    public static void changeOpportunityDescriptionForStageRecursion(List<Opportunity> newOpportunityList) {
        for(Opportunity opportunity : newOpportunityList) {
            if(opportunity.StageName == 'Closed Won') {
                opportunity.Description = 'Opp is Closed Won';
            } else if(opportunity.StageName == 'Closed Lost') {
                opportunity.Description = 'Opp is Closed Lost';
            } else {
                // List<Opportunity> opportunityList = new List<Opportunity>(newOpportunityList);
                // opportunityList.remove(0);
                // List<Opportunity> newOpportunityListAfterRemove = new List<Opportunity>(opportunityList);
                // changeOpportunityDescriptionForStageRecursion(newOpportunityListAfterRemove);
            }
        }
    }


    public static void updateOpportunityTask(List<Opportunity> newOpportunityList, List<Opportunity> oldOpportunityList) {
        List<Task> createTaskForOpportunity = new List<Task>();
        for(Integer iterator = 0; iterator < newOpportunityList.size(); iterator++) {
            if(newOpportunityList.get(iterator).Id == oldOpportunityList.get(iterator).Id) {
                if(newOpportunityList.get(iterator).StageName != oldOpportunityList.get(iterator).StageName) {
                    createTaskForOpportunity.add(OpportunityService.createTask(oldOpportunityList.get(iterator)));
                }
            }
        }
        insert createTaskForOpportunity;
    }

    public static void errorForClosedLostReason(List<Opportunity> oldOpportunityList) {
        for(Opportunity opportunity : oldOpportunityList) {
            if(opportunity.StageName == 'Closed Lost') {
                if(String.isBlank(opportunity.Closed_Lost_Reason__c)) {
                    // opportunity.Closed_Lost_Reason__c = 'Please populate Closed Lost Reason';
                    // Opportunity actualRecord = opportunity.Id; 
                    opportunity.adderror('Please populate Closed Lost Reason');
                }
            }
        }
    }

    public static void checkUserCanDeleteOpportunityOrNot(List<Opportunity> oldList) {
        Id profileId = Userinfo.getProfileId();  
        Profile profilname = [SELECT Name FROM Profile WHERE Id =: profileId];  //NOPMD
        for(Opportunity opportunity : oldList) {
            if(opportunity.CloseDate <= System.today() && profilname.Name != 'System Administrator') {
                opportunity.addError('No Access for Deletion');
                break;
            }
        }
    }
}