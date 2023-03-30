trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete) { //NOPMD

    switch on Trigger.operationType {

        when BEFORE_INSERT {
            OpportunityTriggerHandler.beforeInsert(Trigger.new);
        }

        when AFTER_INSERT {
            OpportunityTriggerHandler.afterInsert(Trigger.new);
		}

        when BEFORE_UPDATE {    //NOPMD
            OpportunityTriggerHandler.beforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
		}

        when AFTER_UPDATE { //NOPMD
            OpportunityTriggerHandler.afterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
		}

        when BEFORE_DELETE {    //NOPMD

		}

        when AFTER_DELETE { //NOPMD

		}
    }
}