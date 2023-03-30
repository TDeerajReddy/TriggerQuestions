trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete) { //NOPMD

	switch on Trigger.operationType {

        when BEFORE_INSERT {
            AccountTriggerHandler.beforeInsert(Trigger.new);
        }

        when AFTER_INSERT {
            AccountTriggerHandler.afterInsert(Trigger.new, Trigger.newMap);
        }

        when BEFORE_UPDATE {    //NOPMD
            AccountTriggerHandler.beforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
		}

        when AFTER_UPDATE { //NOPMD
            AccountTriggerHandler.afterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
        }

        when BEFORE_DELETE {    //NOPMD
            AccountTriggerHandler.beforeDelete(Trigger.old, Trigger.oldMap);

		}

        when AFTER_DELETE { //NOPMD
            AccountTriggerHandler.afterDelete(Trigger.old, Trigger.oldMap);
		}
    }
}