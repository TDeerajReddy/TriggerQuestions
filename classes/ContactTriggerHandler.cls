public with sharing class ContactTriggerHandler {

    public static void beforeInsert(List<Contact> newContactList) {    //NOPMD
        if(!newContactList.isEmpty()) {
            ContactService.sendEmailWhenContactCreated(newContactList);    //Q21
            duplicateRecordBasedOnEmail(newContactList);    //30
        }

    }

    public static void afterInsert(List<Contact> newContactList, Map<Id, Contact> newContactMap) { //NOPMD

    }

    public static void beforeUpdate(List<Contact> newContactList, Map<Id, Contact> newContactMap, List<Contact> oldContactList, Map<Id, Contact> oldContactMap) {   //NOPMD

    }

    public static void afterUpdate(List<Contact> newContactList, Map<Id, Contact> newContactMap, List<Contact> oldContactList, Map<Id, Contact> oldContactMap) {    //NOPMD

    }

    public static void beforeDelete(List<Contact> oldContactList, Map<Id, Contact> oldContactMap) {    //NOPMD

    }

    public static void afterDelete(List<Contact> oldContactList, Map<Id, Contact> oldContactMap) { //NOPMD

    }

    public static void duplicateRecordBasedOnEmail(List<Contact> newContactList) {
        List<Contact> contactOldEmail = [SELECT Email FROM Contact WHERE Email != NULL];
        List<String> contactOldEmailList = new List<String>();
        for(Contact contacts : contactOldEmail) {
            contactOldEmailList.add(contacts.Email);
        }
            for(Contact newEmail : newContactList) {
                if(contactOldEmailList.contains(newEmail.Email)) {
                    newEmail.Email.addError('Can not insert this Email Address, this Email is previously used!!!');
                }
            }
    }
}