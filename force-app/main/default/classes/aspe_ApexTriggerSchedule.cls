global class aspe_ApexTriggerSchedule implements Schedulable  {
    // Apex_Trigger__c apexTrigger {get; set;}

    // public aspe_ApexTriggerSchedule(Apex_Trigger__c apexTrigger) {
    //     this.apexTrigger = apexTrigger;
    // }

    // global void execute(SchedulableContext SC) {
    //     aspe_ApexTriggerExecute AT = new aspe_ApexTriggerExecute(this.apexTrigger);
    // }
    String apexTrigger {get; set;}

    public aspe_ApexTriggerSchedule(String apexTrigger) {
        this.apexTrigger = apexTrigger;
    }

    global void execute(SchedulableContext SC) {
        System.debug(this.apexTrigger);
    }

}
