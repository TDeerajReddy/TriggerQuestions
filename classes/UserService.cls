public with sharing class UserService {

    public static void addUserToAdminsGroup(Map<Id, User> newUserMap) {
        List<Profile> systemAdminList = new List<Profile>([SELECT Id FROM Profile 
                                                            WHERE Name =: 'System Administrator']);
        List<GroupMember> adminGroupMembers = new List<GroupMember>();
        for(Profile profile : systemAdminList) {
            GroupMember groupMember = new GroupMember();
            groupMember.UserOrGroupId  = profile.Id;
            adminGroupMembers.add(groupMember);
        }
        insert adminGroupMembers;   //NOPMD
    }
}