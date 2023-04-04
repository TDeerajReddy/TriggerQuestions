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

    //Not Working
    public static void updateContactRelatedHomePhoneUsingParentChildSOQL(List<Account> newAccountList, Map<Id, Account> oldAccountMap) {
        List<Account> accounts = [SELECT Id, Phone, (SELECT Id, Name, Phone FROM Contacts) FROM Account WHERE Id IN : newAccountList];
        List<Contact> contactList = [SELECT Id, AccountId, HomePhone FROM Contact WHERE AccountId IN : accounts];
        List<Contact> updateContacts = new List<Contact>();

        for(Account account : accounts) {
            for(Contact contactIterator : contactList) {
                if(account.Id == contactIterator.AccountId) {
                    if(account.Phone != contactIterator.HomePhone) {
                        contactIterator.HomePhone = account.Phone;
                        updateContacts.add(contactIterator);
                    }
                }
            }
        }



        if(!updateContacts.isEmpty())
            update updateContacts;
    }

    public static void updateContactMailingAddressUsingMap(List<Account> accountList, Map<Id, Account> newAccountMap) {
        List<Contact> relatedContacts = [SELECT 
                                        Id,
                                        AccountId 
                                        FROM Contact 
                                        WHERE AccountId 
                                        IN : newAccountMap.keySet()];
        
        List<Contact> contactList = new List<Contact>();
        if(!relatedContacts.isEmpty()) {
            for(Id account : newAccountMap.keySet()) {
                for(Contact relatedContact : relatedContacts) {
                    if(account == relatedContact.AccountId) {
                        Contact contact = new Contact(
                            Id = relatedContact.Id,
                            MailingStreet = newAccountMap.get(account).BillingStreet,
                            MailingCity = newAccountMap.get(account).BillingCity,
                            MailingPostalCode = newAccountMap.get(account).BillingPostalCode,
                            MailingState = newAccountMap.get(account).BillingState,
                            MailingCountry = newAccountMap.get(account).BillingCountry
                        );  
                        contactList.add(contact);
                    }
                }
            }
        }
        
        if(!contactList.isEmpty())  
            update contactList;
    }

    //Not Working
    public static void updateContactMailingAddressUsingParentChildSOQL(List<Account> newAccountList, Map<Id, Account> newAccountMap) {
        Map<Id, Account> accountsMap = new Map<Id, Account>([SELECT Id, (SELECT AccountId FROM Contacts) 
                                                            FROM Account WHERE Id IN : newAccountMap.keySet()]);
        Map<Id,Contact> contactList = new Map<Id,Contact>([SELECT AccountId FROM Contact 
                                                            WHERE AccountId IN : accountsMap.keySet()]);
        List<Contact> contactsRelatedToAccount = new List<Contact>();
        if(!accountsMap.isEmpty() && !contactList.isEmpty()) {
            for(Id contact : contactList.keySet()) {
                if(accountsMap.containsKey(contact)) {
                    Contact contactObject = new Contact(
                        Id = contact,
                        MailingStreet = newAccountMap.get(contact).BillingStreet,
                        MailingCity= newAccountMap.get(contact).BillingCity,
                        MailingPostalCode = newAccountMap.get(contact).BillingPostalCode,
                        MailingState = newAccountMap.get(contact).BillingState,
                        MailingCountry = newAccountMap.get(contact).BillingCountry
                    );
                    contactsRelatedToAccount.add(contactObject);
                }
            }
        }
        if(!contactsRelatedToAccount.isEmpty())
            update contactsRelatedToAccount; //NOPMD
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
        if(!contactList.isEmpty())
            update contactList;
    }

    public static void owdSharedStandardUser(List<Account> newAccountList) {
        Id standardUserProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;

        List<AccountShare> accountShares = new List<AccountShare>();
        for (Account account : newAccountList) {
                AccountShare share = new AccountShare();
                share.AccountId = account.Id;
                share.UserOrGroupId = standardUserProfileId;
                // share.AccessLevel = 'Read';  //error
                share.RowCause = Schema.AccountShare.RowCause.Manual;
                accountShares.add(share);
        }

        if(!accountShares.isEmpty())
            insert accountShares;   //NOPMD
    }
}
