public with sharing class PositionHandler {

    public static void beforeInsert(List<Position__c> newList) {
        defaultValues(newList);
    }

    public static void afterInsert(List<Position__c> newList) { //NOPMD

    }

    public static void beforeUpdate(List<Position__c> newList, Map<Id, Position__c> oldMap) {   //NOPMD

    }

    public static void afterUpdate(List<Position__c> newList, Map<Id, Position__c> oldMap) {    //NOPMD

    }

    public static void beforeDelete(List<Position__c> oldList) {    //NOPMD

    }

    public static void afterDelete(List<Position__c> oldList) { //NOPMD

    }

    public static void defaultValues(List<Position__c> newList) {
        for(Position__c position : newList) {
            if(position.Open_Date__c == NULL && position.Min_Pay__c == NULL && position.Max_Pay__c == NULL) {
                position.Open_Date__c = date.today();
                position.Min_Pay__c = 10000;
                position.Max_Pay__c = 15000;
            }
        }
        insert newList;
    }
}