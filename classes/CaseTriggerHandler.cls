public with sharing class CaseTriggerHandler {
    public static void beforeInsert(List<Case> newList) {   //NOPMD

    }

    public static void afterInsert(List<Case> newList) {
        // CaseService.updateLatestCaseNumberIntoAccount(newList); //Q22
    }

    public static void beforeUpdate(List<Case> newList, Map<Id, Case> oldMap) { //NOPMD

    }

    public static void afterUpdate(List<Case> newList, Map<Id, Case> oldMap) {  //NOPMD

    }

    public static void beforeDelete(List<Case> oldList) {   //NOPMD

    }

    public static void afterDelete(List<Case> oldList) {    //NOPMD
        
    }
}