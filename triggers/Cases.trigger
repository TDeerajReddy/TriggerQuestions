trigger Cases on Case (before insert, before update, before delete, after insert, after update, after delete) { //NOPMD
    
    switch on Trigger.operationType {
        when BEFORE_INSERT { //NOPMD

        }
        when AFTER_INSERT {
            CaseHandler.afterInsert(Trigger.new);
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