trigger UserTrigger on User (before insert, before update, before delete, after insert, after update, after delete) {
    
    switch on Trigger.operationType {

        when BEFORE_INSERT {
            UserTriggerHandler.beforeInsert(Trigger.new);
        }

        when AFTER_INSERT {
            UserTriggerHandler.afterInsert(Trigger.new, Trigger.newMap);
        }

        when BEFORE_UPDATE {    //NOPMD
            UserTriggerHandler.beforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
		}

        when AFTER_UPDATE { //NOPMD
            UserTriggerHandler.afterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
        }

        when BEFORE_DELETE {    //NOPMD
            UserTriggerHandler.beforeDelete(Trigger.old, Trigger.oldMap);

		}

        when AFTER_DELETE { //NOPMD
            UserTriggerHandler.afterDelete(Trigger.old, Trigger.oldMap);
		}
    }
}