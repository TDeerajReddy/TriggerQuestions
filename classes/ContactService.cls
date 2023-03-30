public with sharing class ContactService {

    public static void sendEmailWhenContactCreated(List<Contact> newContactList) {
        List<id> accId = new List<id>();
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        for(Contact contact : newContactList){
            if(String.isNotBlank(contact.Email)) {
                // List<account> acclist = [SELECT Owner.Email from Account where Id =:contact.AccountId];
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> sendTo = new List<String>();

                sendTo.add(contact.Email);
                mail.setToAddresses(sendTo);
                
                mail.setReplyTo('pappu@gmail.com');
                mail.setSenderDisplayName('Welcome '+contact.FirstName+' '+contact.LastName);
                
                mail.setSubject('Welcome to Salesforce');
                String body = 'Dear '+contact.FirstName+' '+contact.LastName;
                body += ', thank you for giving us your valuable data. ';
                mail.setHtmlBody(body);
                mails.add(mail);
            }
        }
        Messaging.sendEmail(mails);
    }
}