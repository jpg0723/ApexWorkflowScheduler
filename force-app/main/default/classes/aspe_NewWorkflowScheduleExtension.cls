public class aspe_NewWorkflowScheduleExtension {
    public Workflow_Schedule__c workflowSchedule {get; set;}
    public String objectType {get; set;}
    public String minuteSelect;
    public String hourSelect;
    public String dayWeekSelect;
    public String dayMonthSelect;
    public String monthSelect;
    
    public String getMinuteSelect() {
        return this.workflowSchedule.Minute__c;
    }

    public Void setMinuteSelect(String so) {
        so = so.replaceAll(',.+','').replaceAll('[\\[\\]]','');
        this.workflowSchedule.Minute__c = so;
    }
    
    public List<String> getHourSelect() {
        List<String> stringReturn = new List<String>();
        if (this.workflowSchedule.Hour__c != null) {
            for (String stringItem: this.workflowSchedule.Hour__c.replaceAll('[\\[\\]]','').split(';')) {
                stringReturn.add(stringItem);
            }
        }
        return stringReturn;
    }

    public Void setHourSelect(String so) {
        so = so.replaceAll(', ',';');
        this.workflowSchedule.Hour__c = so;
    }

    public List<String> getDayWeekSelect() {
        List<String> stringReturn = new List<String>();
        if (this.workflowSchedule.Day_of_Week__c != null) {
            for (String stringItem: this.workflowSchedule.Day_of_Week__c.replaceAll('[\\[\\]]','').split(';')) {
                stringReturn.add(stringItem);
            }
        }
        return stringReturn;
    }

    public Void setDayWeekSelect(String so) {
        so = so.replaceAll(', ',';');
        this.workflowSchedule.Day_of_Week__c = so;
    }

    public List<String> getDayMonthSelect() {
        List<String> stringReturn = new List<String>();
        if (this.workflowSchedule.Day_of_Month__c != null) {
            for (String stringItem: this.workflowSchedule.Day_of_Month__c.replaceAll('[\\[\\]]','').split(';')) {
                stringReturn.add(stringItem);
            }
        }
        return stringReturn;
    }

    public Void setDayMonthSelect(String so) {
        so = so.replaceAll(', ',';');
        this.workflowSchedule.Day_of_Month__c = so;
    }

    public List<String> getMonthSelect() {
        List<String> stringReturn = new List<String>();
        if (this.workflowSchedule.Month__c != null) {
            for (String stringItem: this.workflowSchedule.Month__c.replaceAll('[\\[\\]]','').split(';')) {
                stringReturn.add(stringItem);
            }
        }
        return stringReturn;
    }

    public Void setMonthSelect(String so) {
        so = so.replaceAll(', ',';');
        this.workflowSchedule.Month__c = so;
    }
    
    public aspe_NewWorkflowScheduleExtension(ApexPages.StandardController stdController) {
        this.workflowSchedule = (Workflow_Schedule__c)stdController.getRecord();
        this.workflowSchedule.Minute__c = getDefaultValueAsString(Schema.SObjectType.Workflow_Schedule__c.fields.Minute__c);
        this.workflowSchedule.Hour__c = getDefaultValueAsString(Schema.SObjectType.Workflow_Schedule__c.fields.Hour__c);
        this.workflowSchedule.Day_of_Week__c = getDefaultValueAsString(Schema.SObjectType.Workflow_Schedule__c.fields.Day_of_Week__c);
        this.workflowSchedule.Day_of_Month__c = getDefaultValueAsString(Schema.SObjectType.Workflow_Schedule__c.fields.Day_of_Month__c);
        this.workflowSchedule.Month__c = getDefaultValueAsString(Schema.SObjectType.Workflow_Schedule__c.fields.Month__c);
        this.workflowSchedule.Filter_Logic__c = '1 AND 2 AND 3 AND 4 AND 5';
    }
    
    private String getDefaultValueAsString(Schema.DescribeFieldResult field) {
        List<Schema.PicklistEntry> pickVals = field.getPicklistValues();
        for (Schema.PicklistEntry pv: pickVals) {
            if (pv.isDefaultValue() && pv.isActive()) {
                return pv.getValue();
            }    
        }
        return '';
    }
    
	public static List<SelectOption> sortSelectOptionList(List<SelectOption> source) {
        List<string> sortable = new List<string>();
        for(SelectOption so: source) {
            // replace blank with '_!' so we know the final split will have two components
            sortable.Add((string.isblank(so.getLabel())?'_!':so.getLabel()) + '@!@' + (string.isblank(so.getValue())?'_!':so.getValue()));
        }
        // sort the list
        sortable.sort();
        List<SelectOption> targetList = new  List<SelectOption>();
        // split the value/name components and re create the list
        for(string s: sortable) {
                targetList.Add(new  SelectOption(s.split('@!@')[1].replace('_!',''), s.split('@!@')[0].replace('_!','')));
        }
        return targetList;
    }
    
    public List<SelectOption> getObjectTypeOptions() {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        List<SelectOption> typeOptions = new List<SelectOption>();
        typeOptions.add(new SelectOption('','-Choose an object type-'));
        for (String key : gd.keySet()) {
            DescribeSObjectResult objectDescribe = gd.get(key).getDescribe();
            if (objectDescribe.isAccessible() && objectDescribe.isQueryable()) {
            	typeOptions.add(new SelectOption(key,objectDescribe.getLabel()+' ('+objectDescribe.getName()+')'));
            }
        }
        typeOptions = sortSelectOptionList(typeOptions);
        return typeOptions;
    }
    
    public Boolean getNoSelectedObject() {
        if (workflowSchedule.Object_Type__c == '' || workflowSchedule.Object_Type__c == null) return true;
        else return false;
    }
    
    public List<SelectOption> getFieldOptions() {
    	List<SelectOption> fieldOptions = new List<SelectOption>();
        fieldOptions.add(new SelectOption('','-Select a field-'));
        
        if (!getNoSelectedObject()) {
            Map<String, Schema.SObjectField> fields = Schema.describeSObjects(
                new List<String>{workflowSchedule.Object_Type__c}
            	)[0].fields.getMap();
            for (String key : fields.keySet()) {
                DescribeFieldResult fieldDescribe = fields.get(key).getDescribe();
                if (fieldDescribe.isAccessible()) {
                    fieldOptions.add(new SelectOption(fieldDescribe.getName(),fieldDescribe.getLabel()+' ('+fieldDescribe.getName()+')'));
                }
            }
        } else {
            fieldOptions.add(new SelectOption('','Select an object type first'));
        }
        
        fieldOptions = sortSelectOptionList(fieldOptions);
        return fieldOptions;
    }
    public List<SelectOption> getOperatorOptions1() {
        return operatorOptions(1);
    }
    public List<SelectOption> getOperatorOptions2() {
        return operatorOptions(2);
    }
    public List<SelectOption> getOperatorOptions3() {
        return operatorOptions(3);
    }
    public List<SelectOption> getOperatorOptions4() {
        return operatorOptions(4);
    }
    public List<SelectOption> getOperatorOptions5() {
        return operatorOptions(5);
    }
    
    public List<SelectOption> operatorOptions(Integer num) {
        String criteriaField;
        if (num == 1) criteriaField = workflowSchedule.Criteria_Field_1__c;
        if (num == 2) criteriaField = workflowSchedule.Criteria_Field_2__c;
        if (num == 3) criteriaField = workflowSchedule.Criteria_Field_3__c;
        if (num == 4) criteriaField = workflowSchedule.Criteria_Field_4__c;
        if (num == 5) criteriaField = workflowSchedule.Criteria_Field_5__c;
        
    	List<SelectOption> operatorOptions = new List<SelectOption>();
        operatorOptions.add(new SelectOption('','-Select an operator-'));
        operatorOptions.add(new SelectOption('=','Equals'));
        operatorOptions.add(new SelectOption('!=','Does Not Equal'));
        operatorOptions.add(new SelectOption('is_empty','Is Empty'));
        operatorOptions.add(new SelectOption('is_not_empty','Is Not Empty'));
        
        String fieldType = '';
        
        if (!getNoSelectedObject() && criteriaField != null && criteriaField != '') {
            Schema.SObjectField field = Schema.describeSObjects(
                new List<String>{workflowSchedule.Object_Type__c}
            	)[0].fields.getMap().get(criteriaField);
            if (field != null) fieldType = field.getDescribe().getType().name();
            switch on fieldType {
                when 'COMBOBOX' {
                    
                }
                when 'ID' {
                    
                }
                when 'MULTIPICKLIST' {
                    
                }
                when 'CURRENCY','DATE','DATETIME','DOUBLE','INTEGER','PERCENT','TIME' {
        			operatorOptions.add(new SelectOption('>','Greater Than'));
        			operatorOptions.add(new SelectOption('>=','Greater Than or Equal To'));
        			operatorOptions.add(new SelectOption('<','Less Than'));
        			operatorOptions.add(new SelectOption('<=','Less Than or Equal To'));
                }
                when 'EMAIL','PHONE','PICKLIST','STRING','TEXTAREA','URL','REFERENCE' {
        			operatorOptions.add(new SelectOption('contains','Contains'));
        			operatorOptions.add(new SelectOption('starts_with','Starts With'));
        			operatorOptions.add(new SelectOption('ends_with','Ends With'));
        			operatorOptions.add(new SelectOption('not_contains','Does not Contain'));
        			operatorOptions.add(new SelectOption('not_starts_with','Does not Start With'));
        			operatorOptions.add(new SelectOption('not_ends_with','Does not End With'));
                }
            }
        }
        
        return operatorOptions;
    }
    
    public List<SelectOption> getMinuteOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(PicklistEntry option: Workflow_Schedule__c.Minute__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(option.getValue(),option.getLabel()));
        }
        
        return options;
    }
    
    public List<SelectOption> getHourOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(PicklistEntry option: Workflow_Schedule__c.Hour__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(option.getValue(),option.getLabel()));
        }
        
        return options;
    }
    
    public List<SelectOption> getDayWeekOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(PicklistEntry option: Workflow_Schedule__c.Day_of_Week__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(option.getValue(),option.getLabel()));
        }
        
        return options;
    }
    
    public List<SelectOption> getDayMonthOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(PicklistEntry option: Workflow_Schedule__c.Day_of_Month__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(option.getValue(),option.getLabel()));
        }
        
        return options;
    }
    
    public List<SelectOption> getMonthOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(PicklistEntry option: Workflow_Schedule__c.Month__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(option.getValue(),option.getLabel()));
        }
        
        return options;
    }

    private String validateCriteria(Integer num) {
        String field = '';
        String operator = '';
        String value = '';
        if (num == 1) {
            field = workflowSchedule.Criteria_Field_1__c;
            operator = workflowSchedule.Criteria_Operator_1__c;
            value = workflowSchedule.Criteria_Value_1__c;
        }
        if (num == 2) {
            field = workflowSchedule.Criteria_Field_2__c;
            operator = workflowSchedule.Criteria_Operator_2__c;
            value = workflowSchedule.Criteria_Value_2__c;
        }
        if (num == 3) {
            field = workflowSchedule.Criteria_Field_3__c;
            operator = workflowSchedule.Criteria_Operator_3__c;
            value = workflowSchedule.Criteria_Value_3__c;
        }
        if (num == 4) {
            field = workflowSchedule.Criteria_Field_4__c;
            operator = workflowSchedule.Criteria_Operator_4__c;
            value = workflowSchedule.Criteria_Value_4__c;
        }
        if (num == 5) {
            field = workflowSchedule.Criteria_Field_5__c;
            operator = workflowSchedule.Criteria_Operator_5__c;
            value = workflowSchedule.Criteria_Value_5__c;
        }
        if ((field == null || field == '') && (operator == null || operator == '') && ( value == null || value == '')) return 'empty';
        if (field != null && field != '' && operator != null && operator != '' && value != null && value != '') {
            Boolean listContainsOperator = false;
            for (SelectOption so: operatorOptions(num)) {
                if (so.getValue() == operator) listContainsOperator = true;
            }
            if (!listContainsOperator) return 'false';
            return 'true';
        }
        return 'false';
    }

    private String SQLifyValue(String criteriaField, String value) {
            String fieldType = '';
            Schema.SObjectField field = Schema.describeSObjects(
                new List<String>{workflowSchedule.Object_Type__c}
            	)[0].fields.getMap().get(criteriaField);
            if (field != null) fieldType = field.getDescribe().getType().name();
            switch on fieldType {
                when 'REFERENCE' {

                }
                when 'DATE' {
                    Datetime dt = Date.parse(value);
                    return dt.format('yyyy-MM-dd');
                }
                when 'DATETIME' {
                    Datetime dt = DateTime.parse(value);
                    return dt.format('yyyy-MM-dd\'T\'HH:mm:ssXXX');
                }
                when 'TIME' {
                    Datetime dt = DateTime.parse('1/1/2000 '+value);
                    return dt.format('HH:mm:ss');
                }
                when 'MULTIPICKLIST' {
                    
                }
            }
            return '\''+String.escapeSingleQuotes(value)+'\'';
            // return '\''+value+'\'';
    }

    private String SQLifyCriteria(Integer num) {
        String field = '';
        String operator = '';
        String value = '';
        if (num == 1) {
            field = workflowSchedule.Criteria_Field_1__c;
            operator = workflowSchedule.Criteria_Operator_1__c;
            value = workflowSchedule.Criteria_Value_1__c;
        }
        if (num == 2) {
            field = workflowSchedule.Criteria_Field_2__c;
            operator = workflowSchedule.Criteria_Operator_2__c;
            value = workflowSchedule.Criteria_Value_2__c;
        }
        if (num == 3) {
            field = workflowSchedule.Criteria_Field_3__c;
            operator = workflowSchedule.Criteria_Operator_3__c;
            value = workflowSchedule.Criteria_Value_3__c;
        }
        if (num == 4) {
            field = workflowSchedule.Criteria_Field_4__c;
            operator = workflowSchedule.Criteria_Operator_4__c;
            value = workflowSchedule.Criteria_Value_4__c;
        }
        if (num == 5) {
            field = workflowSchedule.Criteria_Field_5__c;
            operator = workflowSchedule.Criteria_Operator_5__c;
            value = workflowSchedule.Criteria_Value_5__c;
        }
        Schema.SObjectField fieldDescribe = Schema.describeSObjects(
            new List<String>{workflowSchedule.Object_Type__c}
            )[0].fields.getMap().get(field);
        if (fieldDescribe != null && fieldDescribe.getDescribe().getType().name() == 'REFERENCE'){
            field = fieldDescribe.getDescribe().getRelationshipName() + '.Name';
        }
        String escapedValue = String.escapeSingleQuotes(value);
        String escapedField = String.escapeSingleQuotes(field);
        System.debug(escapedValue);
        System.debug(escapedField);
        switch on operator {
           when 'contains' {
               return escapedField +' LIKE \'%'+escapedValue+'%\'';
           }
           when 'starts_with' {
               return escapedField +' LIKE \''+escapedValue+'%\'';
           }
           when 'ends_with' {
               return escapedField +' LIKE \'%'+escapedValue+'\'';
           }
           when 'not_contains' {
               return 'NOT (' + escapedField +' LIKE \'%'+escapedValue+'%\')';
           }
           when 'not_starts_with' {
               return 'NOT (' + escapedField +' LIKE \''+escapedValue+'%\')';
           }
           when 'not_ends_with' {
               return 'NOT (' + escapedField +' LIKE \'%'+escapedValue+'\')';
           }
           when 'is_empty' {
               return '('+escapedField+' = NULL OR '+escapedField+' = \'\')';
           }
           when 'is_not_empty' {
               return '('+escapedField+' != NULL AND '+escapedField+' != \'\')';
           }
           when else {
               return escapedField + ' ' + String.escapeSingleQuotes(operator) + ' '+SQLifyValue(field,value);
           }
        }
    }

    private String cronifySelect(String selected) {
        selected = selected.replaceAll('[\\[\\]]','').replaceAll(';', ',');
        return ' ' + selected;
    }

    private Boolean validate() {
        String cleanedFilterLogic = workflowSchedule.Filter_Logic__c.replaceAll('[^() andorANDOR1-5]','');
        String singleCriteria = '';
        if (workflowSchedule.Day_of_Month__c != '[*]' && workflowSchedule.Day_of_Week__c != '[*]') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Day of the Week and Day of the Month may not both be specified.'));
            return false;
        }
        if (cleanedFilterLogic != workflowSchedule.Filter_Logic__c) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'There is an invalid character in the criteria logic.'));
            return false;
        }
        cleanedFilterLogic = cleanedFilterLogic.replaceAll('(\\d)', '{$1}');
        String sqlWhere = '';
        if (!this.workflowSchedule.Active__c) return true;
        if (getNoSelectedObject()) return false;
        for (Integer i = 1; i<=5; i++) {
            // singleCriteria = '';
            switch on validateCriteria(i) {
                when 'false' {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Criteria '+i+' is missing at least one component.'));
                    return false;
                }
                when 'true' {
                    if (sqlWhere.length() == 0) sqlWhere = ' WHERE '+cleanedFilterLogic;
                    Integer criteriaPosition = sqlWhere.indexOf('{'+String.valueOf(i)+'}');
                    sqlWhere = sqlWhere.substring(0, criteriaPosition) + SQLifyCriteria(i) + sqlWhere.substring(criteriaPosition+3);
                    // sqlWhere = sqlWhere.replaceAll('\\{'+String.valueOf(i)+'\\}', SQLifyCriteria(i));
                }
                when 'empty' {
                    cleanedFilterLogic = cleanedFilterLogic.replaceAll('(AND )?\\{'+String.valueOf(i)+'\\}', '');
                    sqlWhere = sqlWhere.replaceAll('(AND )?\\{'+String.valueOf(i)+'\\}', '');
                }
            }
        }
        String sql = 'SELECT Id FROM '+workflowSchedule.Object_Type__c+sqlWhere;
        try {
            System.debug(sql);
            List<sObject> test = Database.query(sql);
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Generated SOQL statement failed with the following error: "'+e.getMessage()+'".'));
            return false;
        }
        workflowSchedule.Parsed_SQL__c = sql;
        return true;
    }

    public PageReference save() {
        Boolean valid = validate();
        if (!valid) return null;
        String cronSched = '0' +
            cronifySelect(workflowSchedule.Minute__c) +
            cronifySelect(workflowSchedule.Hour__c) +
            cronifySelect(workflowSchedule.Day_of_Month__c) +
            cronifySelect(workflowSchedule.Month__c) +
            cronifySelect(workflowSchedule.Day_of_Week__c);
        cronSched = cronSched.replaceAll('(([\\d,]+ [\\d,]+ )\\*)$|(\\*( [\\d,]+ [\\d,]+))$', '\\2?\\4');
        System.debug(cronSched);
        return null;
        // upsert this.workflowSchedule;
        // CronTrigger existingTrigger = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = :this.workflowSchedule.id];
        // try {
        //     aspe_WorkflowScheduleSchedule triggerSchedule = new aspe_WorkflowScheduleSchedule(this.workflowSchedule);
        //     String sch = '20 30 8 10 2 ?';
        //     String newTrigger = system.schedule(this.workflowSchedule.id, sch, triggerSchedule);

        // } catch (Exception e) {
            
        // }
        // PageReference pageRef = new PageReference('/'+this.workflowSchedule.id);
        // return pageRef;
    }
}