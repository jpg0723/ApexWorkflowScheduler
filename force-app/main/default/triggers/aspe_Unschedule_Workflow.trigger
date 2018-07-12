trigger aspe_Unschedule_Workflow on Workflow_Schedule__c (after delete) {
    List<String> triggerIds = new List<String>();
    List<CronTrigger> existingTriggers = null;
    for (Workflow_Schedule__c oldSchedule: Trigger.old) {
        System.debug(oldSchedule);
        System.debug(oldSchedule.Id);
        System.debug((String)oldSchedule.Id);
        triggerIds.add((String)oldSchedule.Id);
    }
    try {
        existingTriggers = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name IN :triggerIds];
    } catch (Exception e) {
    }
    if (existingTriggers != null) {
        for (CronTrigger toDelete: existingTriggers) {
            System.abortJob(toDelete.Id);
        }
    }
}