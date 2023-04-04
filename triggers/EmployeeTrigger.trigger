trigger EmployeeTrigger on Employee__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    switch on Trigger.operationType {

        when BEFORE_INSERT {
            EmployeeTriggerHandler.beforeInsert(Trigger.new);
        }

        when AFTER_INSERT {
            EmployeeTriggerHandler.afterInsert(Trigger.new, Trigger.newMap);
        }

        when BEFORE_UPDATE {
            EmployeeTriggerHandler.beforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
		}

        when AFTER_UPDATE {
            EmployeeTriggerHandler.afterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
        }

        when BEFORE_DELETE {
            EmployeeTriggerHandler.beforeDelete(Trigger.old, Trigger.oldMap);

		}

        when AFTER_DELETE {
            EmployeeTriggerHandler.afterDelete(Trigger.old, Trigger.oldMap);
		}

        when AFTER_UNDELETE {
            EmployeeTriggerHandler.afterUndelete(Trigger.new, Trigger.newMap);
        }
    }
}