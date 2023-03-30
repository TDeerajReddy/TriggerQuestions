public with sharing class UserTriggerHandler {
    public static void beforeInsert(List<User> newUserList) {   //NOPMD

    }

    public static void afterInsert(List<User> newUserList, Map<Id, User> newUserMap) {
        if(!newUserMap.isEmpty()) {
            UserService.addUserToAdminsGroup(newUserMap);   //Q29
        }
    }

    public static void beforeUpdate(List<User> newUserList, MAp<Id, User> newUserMap ,List<User> oldUserList ,Map<Id, User> oldUserMap) {   //NOPMD

    }

    public static void afterUpdate(List<User> newUserList, MAp<Id, User> newUserMap ,List<User> oldUserList ,Map<Id, User> oldUserMap) {    //NOPMD

    }

    public static void beforeDelete(List<User> oldUserList, Map<Id, User> oldUserMap) {    //NOPMD

    }

    public static void afterDelete(List<User> oldUserList, Map<id, User> oldUserMap) { //NOPMD

    }
}