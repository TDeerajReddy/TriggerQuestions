public with sharing class EmployeeTriggerHandler {
    public static void beforeInsert(List<Employee__c> newEmployeeList) {
        if(!newEmployeeList.isEmpty()) { //NOPMD

        }
    }

    public static void afterInsert(List<Employee__c> newEmployeeList, Map<Id, Employee__c> newEmployeeMap) {
        if(!newEmployeeList.isEmpty()) { //NOPMD
            EmployeeService.changePresentEmployeeCount(newEmployeeList); //20
        }
    }

    public static void beforeUpdate(List<Employee__c> newEmployeeList, MAp<Id, Employee__c> newEmployeeMap ,List<Employee__c> oldEmployeeList ,Map<Id, Employee__c> oldEmployeeMap) {   //NOPMD
        if(!newEmployeeList.isEmpty()) { //NOPMD

        }
    }

    public static void afterUpdate(List<Employee__c> newEmployeeList, MAp<Id, Employee__c> newEmployeeMap, List<Employee__c> oldEmployeeList ,Map<Id, Employee__c> oldEmployeeMap) {    //NOPMD
        if(!newEmployeeList.isEmpty() && !newEmployeeMap.isEmpty()) { //NOPMD

        }
        if(!newEmployeeList.isEmpty()) { //NOPMD

        }
    }

    public static void beforeDelete(List<Employee__c> oldEmployeeList, Map<Id, Employee__c> oldEmployeeMap) {    //NOPMD
        if(!oldEmployeeList.isEmpty()) { //NOPMD
                        
        }
        if(!oldEmployeeMap.isEmpty()) { //NOPMD

        }
    }

    public static void afterDelete(List<Employee__c> oldEmployeeList, Map<id, Employee__c> oldEmployeeMap) { //NOPMD
        if(!oldEmployeeList.isEmpty()) {
            EmployeeService.updateLeftEmployeeCount(oldEmployeeList);    //17
            EmployeeService.changePresentEmployeeCount(oldEmployeeList); //20
        }
    }
    
    public static void afterUndelete(List<Employee__c> newEmployeeList, MAp<Id, Employee__c> newEmployeeMap) { //NOPMD
        if(!newEmployeeList.isEmpty()) {
            setActiveTrueWhenUndeleteEmployee(newEmployeeList); //18
            EmployeeService.updateLeftEmployeeCount(newEmployeeList);    //19
            EmployeeService.changePresentEmployeeCount(newEmployeeList); //20
        }
    }

        public static void setActiveTrueWhenUndeleteEmployee(List<Employee__c> newEmployeeList) {
        Set<String> employeeIds = new Set<String>();
        List<Employee__c> employeeActiveList = new List<Employee__c>();
        for(Employee__c employee : newEmployeeList) {
            employeeIds.add(employee.Id__c);
        }

        List<Employee__c> employeeList = [SELECT Active__c 
                                            FROM Employee__c 
                                            WHERE Id__c IN : employeeIds]; //NOPMD
            
        for(Employee__c employee : employeeList) {
            employee.Active__c = 'True';
            employeeActiveList.add(employee);
        }
        update employeeActiveList;   //NOPMD
    }
}