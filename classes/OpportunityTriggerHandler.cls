public with sharing class OpportunityTriggerHandler {
    public static void beforeInsert(List<Opportunity> opportunityList) {
        if(!opportunityList.isEmpty()) {
            // changeOpportunityDescriptionForAmmount(opportunityList);
            // changeOpportunityDescriptionForStage(opportunityList);   //Q2
        }
    }

    public static void afterInsert(List<Opportunity> opportunityList) {
        OpportunityService.updateAccountsAmountFromOpportunityAmount(opportunityList);
    }

    public static void beforeUpdate(List<Opportunity> newOpportunityList, Map<Id, Opportunity> newOpportunityMap, List<Opportunity> oldOpportunityList, Map<Id, Opportunity> oldOpportunityMap) {   //NOPMD
        if(!newOpportunityList.isEmpty()) {
            // changeOpportunityDescriptionForStage(newOpportunityList);   //Q2
            errorForClosedLostReason(newOpportunityList); //Q12
            for(Opportunity opportunityObject : oldOpportunityList) {
                // changeOpportunityDescriptionForStageRecursion(opportunityObject, '');   //26
            }
        }
    }

    public static void afterUpdate(List<Opportunity> newOpportunityList, Map<Id, Opportunity> newOpportunityMap, List<Opportunity> oldOpportunityList, Map<Id, Opportunity> oldOpportunityMap) {    //NOPMD
        if(!newOpportunityList.isEmpty()) {
            // updateOpportunityTask(newOpportunityList, oldOpportunityList); //Q7
        }
    }

    public static void beforeDelete(List<Opportunity> oldOpportunityList, Map<Id, Opportunity> oldOpportunityMap) {    //NOPMD   
        if(!oldOpportunityList.isEmpty()) {
            // checkUserCanDeleteOpportunityOrNot(oldOpportunityList);    //Q14
            OpportunityService.updateAccountAnnualRevenue(oldOpportunityList); //Q23
        }
    }

    public static void afterDelete(List<Opportunity> oldOpportunityList) { //NOPMD
        
    }

    public static void afterUndelete(List<Opportunity> newOpportunityList, Map<Id, Opportunity> newOpportunityMap) { //NOPMD
        if(!newOpportunityList.isEmpty()) {
            OpportunityService.updateAccountAnnualRevenue(newOpportunityList); //Q23
        }
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

    public static void changeOpportunityDescriptionForStageRecursion(Opportunity opportunity, String newDescription) {
        if(opportunity.StageName == 'Closed Won') {
            opportunity.Description = 'Opp is Closed Won';
        } else if(opportunity.StageName == 'Closed Lost') {
            opportunity.Description = 'Opp is Closed Lost';
        } else {
            changeOpportunityDescriptionForStageRecursion(opportunity, 'Other than Close Won and Closed Lost');
        }
        update opportunity;
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
            if(opportunity.StageName == 'Closed Lost' && String.isBlank(opportunity.Closed_Lost_Reason__c)) {
                    opportunity.Closed_Lost_Reason__c.adderror('Please populate Closed Lost Reason');
            }
        }
    }

    public static void checkUserCanDeleteOpportunityOrNot(List<Opportunity> oldOpportunityList) {
        Id profileId = Userinfo.getProfileId();  
        Profile profilname = [SELECT Name FROM Profile WHERE Id =: profileId];  //NOPMD
        for(Opportunity opportunity : oldOpportunityList) {
            if(opportunity.CloseDate <= System.today() && profilname.Name != 'System Administrator') {
                opportunity.addError('No Access for Deletion');
                break;
            }
        }
    }
}