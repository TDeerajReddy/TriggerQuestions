trigger TriggerDemo on Position__c (before insert) {    //Q32

    if (Trigger.isExecuting) {
        System.debug('Trigger is executing.');
    } else {
        System.debug('Trigger is not executing.');
    }
}