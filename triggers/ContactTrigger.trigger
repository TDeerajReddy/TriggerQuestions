trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete) {   //NOPMD

    switch on Trigger.operationType {

        when BEFORE_INSERT {    //NOPMD
            ContactTriggerHandler.beforeInsert(Trigger.new);
        }

        when AFTER_INSERT {
            ContactTriggerHandler.afterInsert(Trigger.new, Trigger.newMap);
        }

        when BEFORE_UPDATE {    //NOPMD
            ContactTriggerHandler.beforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
		}

        when AFTER_UPDATE { //NOPMD
            ContactTriggerHandler.afterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
		}

        when BEFORE_DELETE {    //NOPMD
            ContactTriggerHandler.beforeDelete(Trigger.old, Trigger.oldMap);
		}

        when AFTER_DELETE { //NOPMD
            ContactTriggerHandler.afterDelete(Trigger.old, Trigger.oldMap);
		}
    }
}