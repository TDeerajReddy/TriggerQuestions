public with sharing class AccountService {

    public static void createContact(List<Account> accountList) {
        if(!accountList.isEmpty()) {
            List<Contact> contactList = new List<Contact>();
            for(Account account : accountList) {
                Contact contact = new Contact();
                contact.AccountId = account.Id;
                contact.LastName = account.Name;
                contact.Phone = account.Phone;
                contact.CleanStatus = account.CleanStatus;
                // contact.Jigsaw = account.Jigsaw;
                contact.Fax = account.Fax;
                contact.Description = account.Description;
                contactList.add(contact);
            }
            if(!contactList.isEmpty())   insert contactList; //NOPMD
        }
    }

    public static void createOpportunity(List<Account> accountList) {
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Account account : accountList) {
            Opportunity opportunity = new Opportunity(
                AccountId = account.Id,
                Description = account.Description,
                Name = account.Name,
                StageName = 'Value Proposition',
                CloseDate = System.today() + 30
            );
            opportunityList.add(opportunity);
        }
        if(!opportunityList.isEmpty())   insert opportunityList; //NOPMD
    }

    public static void createRelatedContact(List<Account> accountList) {
        List<Contact> contactList = new List<Contact>();
        for(Account account : accountList) {
            if(account.Contact__c) {
                Contact contact = new Contact(
                    AccountId = account.Id,
                    LastName = account.Name,
                    CleanStatus = account.CleanStatus,
                    Phone = account.Phone,
                    Fax = account.Fax,
                    Description = account.Description
                );
                contactList.add(contact);
            }
        }
        if(!contactList.isEmpty())   insert contactList; //NOPMD
    }

    public static void createRelatedOpportunity(List<Account> accountList) {
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Account account : accountList) {
            if(account.Opportunity__c && account.Active__c == 'Yes') {
                Opportunity opportunity = new Opportunity(
                    AccountId = account.Id,
                    Description = account.Description,
                    Name = account.Name,
                    StageName = 'Value Proposition',
                    CloseDate = System.today() + 30
                );
                opportunityList.add(opportunity);
            }
        }
        if(!opportunityList.isEmpty())   insert opportunityList; //NOPMD
    }

    public static void updateContactRelatedPhoneUsingMap(List<Account> accountList, Map<Id, Account> newAccountMap) {
        List<Contact> relatedContacts = [SELECT 
                                        Id,
                                        AccountId 
                                        FROM Contact 
                                        WHERE AccountId 
                                        IN : newAccountMap.keySet()];
    
        Map<Id, String> accountPhoneMap = new Map<Id, String>();
        for(Account updatedAccount : accountList) {
            if (newAccountMap.keySet().contains(updatedAccount.Id)) {
                accountPhoneMap.put(updatedAccount.Id, updatedAccount.Phone);
            }
        }
    
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact relatedContact : relatedContacts) {
            if (accountPhoneMap.containsKey(relatedContact.AccountId)) {
                relatedContact.HomePhone = accountPhoneMap.get(relatedContact.AccountId);
                contactsToUpdate.add(relatedContact);
            }
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;    //NOPMD
        }
    }

    // public static void updateContactRelatedPhoneUsingParentChildSOQL(List<Account> accountList, Map<Id, Account> newAccountMap) {
    //     List<Contact> contactList = new List<Contact>([SELECT Id, AccountId, Name FROM Contact]);
    //     List<Account> accounts = new List<Account>([SELECT Id,
    //                                 (SELECT AccountId FROM Contacts) 
    //                                 FROM Account WHERE Name IN : contactList]);
    //     List<Contact> contacts = new List<Contact>();
    //     for(Account account : accounts) {
    //         for(Id contacts : contactList.AccountId) {
    //             if(account.Id == contacts.AccountId) {
    //                 Contact contact = new Contact();
    //                 contact.HomePhone = account.Phone;
    //                 contacts.add(contact);
    //             }
    //         }
    //     }

    //     if (!contacts.isEmpty()) {
    //         update contacts;
    //     }
    // }

    public static void updateContactMailingAddressUsingMap(List<Account> accountList, Map<Id, Account> newAccountMap) {
        List<Contact> relatedContacts = [SELECT 
                                        Id,
                                        AccountId 
                                        FROM Contact 
                                        WHERE AccountId 
                                        IN : newAccountMap.keySet()];
        
        List<Contact> contactList = new List<Contact>();
        for(Id account : newAccountMap.keySet()) {
            if(!relatedContacts.isEmpty()) {
                for(Contact relatedContact : relatedContacts) {
                    if(account == relatedContact.AccountId) {
                        Contact contact = new Contact();
                        contact.MailingStreet = newAccountMap.get(account).BillingStreet;
                        contact.MailingCity= newAccountMap.get(account).BillingCity;
                        contact.MailingPostalCode = newAccountMap.get(account).BillingPostalCode;
                        contact.MailingState = newAccountMap.get(account).BillingState;
                        contact.MailingCountry = newAccountMap.get(account).BillingCountry;
                        contactList.add(contact);
                    }
                }
            }
        }
        if(!contactList.isEmpty()) {
            update contactList; //NOPMD
        }
    }

    public static void updateOpportunityStage(List<Account> newAccountList) {
        List<Opportunity> opportunityList = new List<Opportunity>();
        for(Account account : newAccountList) {
            List<Opportunity> opportunityAccountIdList = [SELECT AccountId FROM Opportunity WHERE AccountId =: account.Id];
            for(Opportunity oppotunityIterator : opportunityAccountIdList) {
                if(oppotunityIterator.AccountId == account.Id) {
                    if(account.Active__c == 'No') {
                        Opportunity opportunity = new Opportunity();
                        opportunity.StageName = 'Closed Lost';
                        opportunityList.add(opportunity);
                    } else {
                        Opportunity opportunity = new Opportunity();
                        opportunity.StageName = 'Closed Won';
                        opportunityList.add(opportunity);
                    }
                }
            }
        }
        if(!opportunityList.isEmpty()) {
            update opportunityList; //NOPMD
        }
    }

    public static void preventDeletionOfAccountRelatedToOpprtunity(List<Account> oldAccountList, Map<Id, Account> oldAccountMap) {
        // List<Opportunity> opportunity = [SELECT Id, AccountId FROM Oppertunity WHERE AccountId IN : oldAccountList];
        List<Opportunity> opportunities = [SELECT AccountId FROM Opportunity WHERE AccountId =: oldAccountMap.keySet()];
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opportunity : opportunities)
            accountIds.add(opportunity.Accountid);

        for(Account account : oldAccountList) {
            if(accountIds.contains(account.id)) {
                account.adderror('Account has related with Opportunity, you can not delete it!!!');
            }
        }
    }

	public static void preventDeletionOfAccountRelatedToCase(List<Account> oldAccountList, Map<Id,Account> oldAccountMap){
        List<Case> cases = [SELECT AccountId FROM Case WHERE AccountId =: oldAccountMap.keySet()];
        Set<Id> accountIds = new Set<Id>();
        for(Case caseIterator : cases)
            accountIds.add(caseIterator.AccountId);

        for(Account account : oldAccountList) {
            if(accountIds.contains(account.id)) {
                account.adderror('Account has related with Case, you can not delete it!!!');
            }
        }
	} 

    public static void countPartnerORCustomerCasesOnAccount(List<Account> newAccountList) {
        Set<Case> casesId = new Set<Case>();
        List<Case> caseId = new List<Case>();
        for(Account account : newAccountList) {
            caseId.add([SELECT AccountId FROM Case WHERE (AccountId =: account.Id AND (ContactId =: 'Customer Case' OR ContactId =: 'Partner Case'))]);
            casesId.addAll(caseId);
        }

        Integer countPartner = 0;
        Integer countCustomer = 0;
        
        for(Account account : newAccountList) {
            if(casesId.equals(account.Id) && casesId.equals('Customer Case')) {
                account.Total_Customer_Case__c = ++countCustomer; //3
            } else {
                account.Total_Partner_Case__c = ++countPartner; //2
            }
        }
    }

    public static void ifOwnerChangeOnAccount(List<Account> oldAccountList, List<Account> newAccountList) {
        
        List<Contact> contactList = new List<Contact>();
        Set<Id> accountId = new Set<Id>();
        for(Account newAccount : newAccountList) {
            for(Account oldAccount : oldAccountList) {
                if(newAccount.Id == oldAccount.Id) {
                    if(newAccount.OwnerId != oldAccount.OwnerId) {
                        accountId.add(newAccount.Id);
                    }
                    for(Contact contacts : [SELECT AccountId FROM Contact]) {
                        if(newAccount.Id == contacts.AccountId) {
                            Contact newOwner = new Contact();
                            newOwner.OwnerId = newAccount.OwnerId;
                            contactList.add(newOwner);
                        }
                    }
                }
            }
        }
        update contactList;
    }
}
