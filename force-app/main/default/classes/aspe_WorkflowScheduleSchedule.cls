global class aspe_WorkflowScheduleSchedule implements Schedulable  {
    Workflow_Schedule__c workflowSchedule {get; set;}

    public aspe_WorkflowScheduleSchedule(Workflow_Schedule__c workflowSchedule) {
        this.workflowSchedule = workflowSchedule;
    }

    global void execute(SchedulableContext SC) {
        aspe_WorkflowScheduleExecute AT = new aspe_WorkflowScheduleExecute();
        AT.execute(this.workflowSchedule);
    }

}
