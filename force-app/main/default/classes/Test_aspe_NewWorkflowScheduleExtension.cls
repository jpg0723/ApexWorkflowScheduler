@isTest
private class Test_aspe_NewWorkflowScheduleExtension {
    static aspe_NewWorkflowScheduleExtension ext;

    private static void init() {

    }

    static testMethod void testWorkflowSchedules() { 
        Workflow_Schedule__c schedule = new Workflow_Schedule__c(Name='Test Schedule 1');
        ApexPages.StandardController con = new ApexPages.StandardController(schedule);

        init();
        
        Test.startTest();
        ext = new aspe_NewWorkflowScheduleExtension(con);
        ext.setMinuteSelect('[0]');
        ext.setHourSelect('[0-23]');
        ext.setDayWeekSelect('*');
        ext.setDayMonthSelect('*');
        ext.setMonthSelect('[*]');
        ext.getMinuteSelect();
        ext.getHourSelect();
        ext.getDayWeekSelect();
        ext.getDayMonthSelect();
        ext.getMonthSelect();

        ext.getIsScheduled();
        ext.getObjectTypeOptions();
        ext.getFieldOptions();

        ext.getOperatorOptions1();
        ext.getOperatorOptions2();
        ext.getOperatorOptions3();
        ext.getOperatorOptions4();
        ext.getOperatorOptions5();

        ext.getMinuteOptions();
        ext.getHourOptions();
        ext.getDayWeekOptions();
        ext.getDayMonthOptions();
        ext.getMonthOptions();

        ext.workflowSchedule.Object_Type__c = 'Opportunity';
        ext.getFieldOptions();
        ext.workflowSchedule.Name = 'Test';
        ext.save();
        ext.workflowSchedule.Active__c = true;
        ext.workflowSchedule.Object_Type__c = '';
        ext.save();
        ext.setDayWeekSelect('[*]');
        ext.setDayMonthSelect('[*]');
        ext.workflowSchedule.Filter_Logic__c = 'kfajhekfjhae';
        ext.save();
        ext.workflowSchedule.Filter_Logic__c = '1 AND 2 AND 3 AND 4 AND 5';
        ext.workflowSchedule.Object_Type__c = 'Opportunity';

        ext.workflowSchedule.Criteria_Field_1__c = 'CloseDate';
        ext.workflowSchedule.Criteria_Operator_1__c = '>=';
        ext.workflowSchedule.Criteria_Value_1__c = '11/25/2018';

        ext.workflowSchedule.Criteria_Field_2__c = 'TotalOpportunityQuantity';
        ext.workflowSchedule.Criteria_Operator_2__c = '=';
        ext.workflowSchedule.Criteria_Value_2__c = '2';

        ext.workflowSchedule.Criteria_Field_3__c = 'AccountId';
        ext.workflowSchedule.Criteria_Operator_3__c = 'not_contains';
        ext.workflowSchedule.Criteria_Value_3__c = 'Bleh';

        ext.workflowSchedule.Criteria_Field_4__c = 'Name';
        ext.workflowSchedule.Criteria_Operator_4__c = 'starts_with';
        ext.workflowSchedule.Criteria_Value_4__c = 'Hello';

        ext.workflowSchedule.Criteria_Field_5__c = 'IsPrivate';
        ext.workflowSchedule.Criteria_Operator_5__c = 'Bogus';
        ext.workflowSchedule.Criteria_Value_5__c = 'Nah, Brah';
        ext.save();
        ext.workflowSchedule.Criteria_Operator_5__c = '=';
        ext.workflowSchedule.Criteria_Value_5__c = 'false';
        ext.save();

        aspe_WorkflowScheduleExecute scheduledJob = new aspe_WorkflowScheduleExecute();
        scheduledJob.execute(schedule);

        schedule.Parsed_SQL__c = '';
        update schedule;
        scheduledJob.execute(schedule);

        delete schedule;
        Test.stopTest();
    }
}