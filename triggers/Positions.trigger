trigger Positions on Position__c(before insert, before update, before delete, after insert, after update, after delete)  {  //NOPMD
    switch on Trigger.operationType {

        when BEFORE_INSERT {
            PositionHandler.beforeInsert(Trigger.new);
        }

        when AFTER_INSERT { //NOPMD

		}

        when BEFORE_UPDATE {    //NOPMD

		}

        when AFTER_UPDATE { //NOPMD

		}

        when BEFORE_DELETE {    //NOPMD

		}

        when AFTER_DELETE { //NOPMD

		}
    }
}