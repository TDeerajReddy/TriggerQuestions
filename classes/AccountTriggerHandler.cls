public with sharing class AccountTriggerHandler {
    public static void beforeInsert(List<Account> accountList) {
        if(!accountList.isEmpty()) {
            // copyBillingAddressIntoShippingAddress(accountList);
            changeAccountRating(accountList);
        }
    }

    public static void afterInsert(List<Account> newAccountList, Map<Id, Account> newAccountMap) {
        if(!newAccountList.isEmpty()) {
            //AccountService.createContact(newAccountList);
            // createRelatedContactAnd_OrOpportunity(newAccountList);
            // AccountService.createOpportunity(newAccountList);
            AccountService.countPartnerORCustomerCasesOnAccount(newAccountList);    //22
            AccountService.owdSharedStandardUser(newAccountList);    //Q31
        }
    }

    public static void beforeUpdate(List<Account> newAccountList, MAp<Id, Account> newAccountMap ,List<Account> oldAccountList ,Map<Id, Account> oldAccountMap) {   //NOPMD
        if(!newAccountList.isEmpty()) {
            // updatePhone(newAccountList, oldAccountMap);
            // updateBillingIntoShippingAddress(newAccountList, oldAccountMap);
            changeAccountRating(newAccountList);
            // notAllowedToBeEdited(oldAccountList);   //Q10/11
            // AccountService.ifOwnerChangeOnAccount(oldAccountList, newAccountList);  //Q27

        }
    }

    public static void afterUpdate(List<Account> newAccountList, MAp<Id, Account> newAccountMap ,List<Account> oldAccountList ,Map<Id, Account> oldAccountMap) {    //NOPMD
        if(!newAccountList.isEmpty() && !newAccountMap.isEmpty()) {
            // AccountService.updateContactRelatedPhoneUsingMap(newAccountList, newAccountMap);   //Q3
            // AccountService.updateContactMailingAddressUsingMap(newAccountList, newAccountMap); //Q5
            // AccountService.updateContactMailingAddressUsingParentChildSOQL(newAccountList, newAccountMap);  //Q6 //NotWorking
        }
        if(!newAccountList.isEmpty()) {
            // AccountService.updateOpportunityStage(newAccountList);  //Q8
            AccountService.updateContactRelatedHomePhoneUsingParentChildSOQL(newAccountList, oldAccountMap);   //Q4
        }
    }

    public static void beforeDelete(List<Account> oldAccountList, Map<Id, Account> oldAccountMap) {    //NOPMD
        if(!oldAccountList.isEmpty()) {
            // ifActiveNotToBeDeleted(oldAccountList); //Q9
            // checkSystemAdministratorCanDeleteAccount(oldAccountList);   //Q13
            
        }
        if(!oldAccountMap.isEmpty()) {
            AccountService.preventDeletionOfAccountRelatedToOpprtunity(oldAccountList, oldAccountMap); //Q15
            AccountService.preventDeletionOfAccountRelatedToCase(oldAccountList, oldAccountMap); //Q16
        }
    }

    public static void afterDelete(List<Account> oldAccountList, Map<id, Account> oldAccountMap) { //NOPMD

    }

    public static void changeAccountRating(List<Account> accountList) {
        for(Account account : accountList) {
            if(String.isNotBlank(account.Industry) && account.Industry == 'Media') {
                account.Rating = 'Hot';
            } else {
                account.Rating = '';
            }
        }
    }

    public static void copyBillingAddressIntoShippingAddress(List<Account> accountList) {   //NPMD
        for(Account account : accountList) {
            if(account.Copy_Billing_To_Shipping__c) {
                if(String.isNotBlank(account.BillingStreet)) {
                    account.ShippingStreet = account.BillingStreet;
                }

                if(String.isNotBlank(account.BillingCity)) {
                    account.ShippingCity = account.BillingCity;
                }

                if(String.isNotBlank(account.BillingPostalCode)) {
                    account.ShippingPostalCode = account.BillingPostalCode;
                }

                if(String.isNotBlank(account.BillingState)) {
                    account.ShippingState = account.BillingState;
                }

                if(String.isNotBlank(account.BillingCountry)) {
                    account.ShippingCountry = account.BillingCountry;
                }
            }
        }
    }


    public static void updateBillingIntoShippingAddress(List<Account> accountList, Map<Id, Account> oldAccountMap) {
        for(Account account : accountList) {
            if(account.Copy_Billing_To_Shipping__c) {
                if(String.isNotBlank(account.BillingStreet) && oldAccountMap.get(account.Id).BillingStreet != account.BillingStreet) {
                    account.ShippingStreet = account.BillingStreet;
                }

                if(String.isNotBlank(account.BillingCity) && oldAccountMap.get(account.Id).BillingCity != account.BillingCity) {
                    account.ShippingCity = account.BillingCity;
                }

                if(String.isNotBlank(account.BillingPostalCode) && oldAccountMap.get(account.Id).BillingPostalCode != account.BillingPostalCode) {
                    account.ShippingPostalCode = account.BillingPostalCode;
                }

                if(String.isNotBlank(account.BillingState) && oldAccountMap.get(account.Id).BillingState != account.BillingState) {
                    account.ShippingState = account.BillingState;
                }

                if(String.isNotBlank(account.BillingCountry) && oldAccountMap.get(account.Id).BillingCountry != account.BillingCountry) {
                    account.ShippingCountry = account.BillingCountry;
                }
            }
        }
    }

    public static void createRelatedContactAnd_OrOpportunity(List<Account> accountList) {
        AccountService.createRelatedContact(accountList);
        AccountService.createRelatedOpportunity(accountList);
    }

    public static void updatePhone(List<Account> accountList, Map<Id, Account> oldAccountMap) {
        for(Account newAccount : accountList) {
            if(newAccount.Phone != oldAccountMap.get(newAccount.id).Phone) {
                newAccount.Description = 'Phone is Updated! Old Value : '+ oldAccountMap.get(newAccount.id).Phone +' & New Value : '+ newAccount.Phone;
            } else {
                newAccount.Description = '';
            }
        }
    }

    public static void ifActiveNotToBeDeleted(List<Account> oldAccountList) {
        for(Account account : oldAccountList) {
            if(account.Active__c == 'Yes') {
                account.adderror('Account Cannot be Deleted!!!');
            }
        }
    }

    public static void notAllowedToBeEdited(List<Account> oldAccountList) {
        for(Account account : oldAccountList) {
            if(account.CreatedDate  < System.today() - 7) {
                account.adderror('Account Cannot be Edited!!!');
            }
        }
    }

    public static void checkSystemAdministratorCanDeleteAccount(List<Account> oldAccountList) {
        Id profileId = Userinfo.getProfileId();  
        profile profilname = [SELECT Name FROM Profile WHERE Id =: profileId];
          for(Account account : oldAccountList){
              if(profilname.Name != 'System Administrator') {
                    account.adderror('No Access for Deletion!!!');                                    
                }
          }
    }
}