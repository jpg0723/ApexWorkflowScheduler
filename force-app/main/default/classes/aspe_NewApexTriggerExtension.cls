public class aspe_NewApexTriggerExtension {
    public Apex_Trigger__c apexTrigger {get; set;}
    public String objectType {get; set;}
    public String minuteSelect;
    public String hourSelect;
    public String dayWeekSelect;
    public String dayMonthSelect;
    public String monthSelect;
    
    public String getMinuteSelect() {
        return this.apexTrigger.Minute__c;
    }

    public Void setMinuteSelect(String so) {
        so = so.replaceAll(',.+','');
        this.apexTrigger.Minute__c = so;
    }
    
    public List<String> getHourSelect() {
        List<String> stringReturn = new List<String>();
        if (this.apexTrigger.Hour__c != null) {
            for (String stringItem: this.apexTrigger.Hour__c.replaceAll('[\\[\\]]','').split(';')) {
                stringReturn.add(stringItem);
            }
        }
        return stringReturn;
    }

    public Void setHourSelect(String so) {
        so = so.replaceAll(', ',';');
        this.apexTrigger.Hour__c = so;
    }

    public List<String> getDayWeekSelect() {
        List<String> stringReturn = new List<String>();
        if (this.apexTrigger.Day_of_Week__c != null) {
            for (String stringItem: this.apexTrigger.Day_of_Week__c.replaceAll('[\\[\\]]','').split(';')) {
                stringReturn.add(stringItem);
            }
        }
        return stringReturn;
    }

    public Void setDayWeekSelect(String so) {
        so = so.replaceAll(', ',';');
        this.apexTrigger.Day_of_Week__c = so;
    }

    public List<String> getDayMonthSelect() {
        List<String> stringReturn = new List<String>();
        if (this.apexTrigger.Day_of_Month__c != null) {
            for (String stringItem: this.apexTrigger.Day_of_Month__c.replaceAll('[\\[\\]]','').split(';')) {
                stringReturn.add(stringItem);
            }
        }
        return stringReturn;
    }

    public Void setDayMonthSelect(String so) {
        so = so.replaceAll(', ',';');
        this.apexTrigger.Day_of_Month__c = so;
    }

    public List<String> getMonthSelect() {
        List<String> stringReturn = new List<String>();
        if (this.apexTrigger.Month__c != null) {
            for (String stringItem: this.apexTrigger.Month__c.replaceAll('[\\[\\]]','').split(';')) {
                stringReturn.add(stringItem);
            }
        }
        return stringReturn;
    }

    public Void setMonthSelect(String so) {
        so = so.replaceAll(', ',';');
        this.apexTrigger.Month__c = so;
    }
    
    public aspe_NewApexTriggerExtension(ApexPages.StandardController stdController) {
        this.apexTrigger = (Apex_Trigger__c)stdController.getRecord();
        this.apexTrigger.Minute__c = getDefaultValueAsString(Schema.SObjectType.Apex_Trigger__c.fields.Minute__c);
        this.apexTrigger.Hour__c = getDefaultValueAsString(Schema.SObjectType.Apex_Trigger__c.fields.Hour__c);
        this.apexTrigger.Day_of_Week__c = getDefaultValueAsString(Schema.SObjectType.Apex_Trigger__c.fields.Day_of_Week__c);
        this.apexTrigger.Day_of_Month__c = getDefaultValueAsString(Schema.SObjectType.Apex_Trigger__c.fields.Day_of_Month__c);
        this.apexTrigger.Month__c = getDefaultValueAsString(Schema.SObjectType.Apex_Trigger__c.fields.Month__c);
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
        if (apexTrigger.Object_Type__c == '' || apexTrigger.Object_Type__c == null) return true;
        else return false;
    }
    
    public List<SelectOption> getFieldOptions() {
    	List<SelectOption> fieldOptions = new List<SelectOption>();
        fieldOptions.add(new SelectOption('','-Select a field-'));
        
        if (!getNoSelectedObject()) {
            Map<String, Schema.SObjectField> fields = Schema.describeSObjects(
                new List<String>{apexTrigger.Object_Type__c}
            	)[0].fields.getMap();
            for (String key : fields.keySet()) {
                DescribeFieldResult fieldDescribe = fields.get(key).getDescribe();
                if (fieldDescribe.isAccessible()) {
                    fieldOptions.add(new SelectOption(key,fieldDescribe.getLabel()+' ('+fieldDescribe.getName()+')'));
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
        if (num == 1) criteriaField = apexTrigger.Criteria_Field_1__c;
        if (num == 2) criteriaField = apexTrigger.Criteria_Field_2__c;
        if (num == 3) criteriaField = apexTrigger.Criteria_Field_3__c;
        if (num == 4) criteriaField = apexTrigger.Criteria_Field_4__c;
        if (num == 5) criteriaField = apexTrigger.Criteria_Field_5__c;
        
    	List<SelectOption> operatorOptions = new List<SelectOption>();
        operatorOptions.add(new SelectOption('','-Select an operator-'));
        operatorOptions.add(new SelectOption('=','Equals'));
        operatorOptions.add(new SelectOption('!=','Does Not Equal'));
        operatorOptions.add(new SelectOption('IS NULL','Is Empty'));
        operatorOptions.add(new SelectOption('IS NOT NULL','Is Not Empty'));
        
        String fieldType = '';
        
        if (!getNoSelectedObject() && criteriaField != null && criteriaField != '') {
            Schema.SObjectField field = Schema.describeSObjects(
                new List<String>{apexTrigger.Object_Type__c}
            	)[0].fields.getMap().get(criteriaField);
            if (field != null) fieldType = field.getDescribe().getType().name();
            switch on fieldType {
                when 'COMBOBOX' {
                    
                }
                when 'CURRENCY' {
        			operatorOptions.add(new SelectOption('>','Greater Than'));
        			operatorOptions.add(new SelectOption('>=','Greater Than or Equal To'));
        			operatorOptions.add(new SelectOption('<','Less Than'));
        			operatorOptions.add(new SelectOption('<=','Less Than or Equal To'));
                }
                when 'DATE' {
        			operatorOptions.add(new SelectOption('>','Greater Than'));
        			operatorOptions.add(new SelectOption('>=','Greater Than or Equal To'));
        			operatorOptions.add(new SelectOption('<','Less Than'));
        			operatorOptions.add(new SelectOption('<=','Less Than or Equal To'));
                    
                }
                when 'DATETIME' {
        			operatorOptions.add(new SelectOption('>','Greater Than'));
        			operatorOptions.add(new SelectOption('>=','Greater Than or Equal To'));
        			operatorOptions.add(new SelectOption('<','Less Than'));
        			operatorOptions.add(new SelectOption('<=','Less Than or Equal To'));
                    
                }
                when 'DOUBLE' {
        			operatorOptions.add(new SelectOption('>','Greater Than'));
        			operatorOptions.add(new SelectOption('>=','Greater Than or Equal To'));
        			operatorOptions.add(new SelectOption('<','Less Than'));
        			operatorOptions.add(new SelectOption('<=','Less Than or Equal To'));
                    
                }
                when 'EMAIL' {
        			operatorOptions.add(new SelectOption('contains','Contains'));
        			operatorOptions.add(new SelectOption('starts_with','Starts With'));
        			operatorOptions.add(new SelectOption('ends_with','Ends With'));
                    
                }
                when 'ID' {
                    
                }
                when 'INTEGER' {
        			operatorOptions.add(new SelectOption('>','Greater Than'));
        			operatorOptions.add(new SelectOption('>=','Greater Than or Equal To'));
        			operatorOptions.add(new SelectOption('<','Less Than'));
        			operatorOptions.add(new SelectOption('<=','Less Than or Equal To'));
                    
                }
                when 'MULTIPICKLIST' {
                    
                }
                when 'PERCENT' {
        			operatorOptions.add(new SelectOption('>','Greater Than'));
        			operatorOptions.add(new SelectOption('>=','Greater Than or Equal To'));
        			operatorOptions.add(new SelectOption('<','Less Than'));
        			operatorOptions.add(new SelectOption('<=','Less Than or Equal To'));
                    
                }
                when 'PHONE' {
        			operatorOptions.add(new SelectOption('contains','Contains'));
        			operatorOptions.add(new SelectOption('starts_with','Starts With'));
        			operatorOptions.add(new SelectOption('ends_with','Ends With'));
                    
                }
                when 'PICKLIST' {
        			operatorOptions.add(new SelectOption('contains','Contains'));
        			operatorOptions.add(new SelectOption('starts_with','Starts With'));
        			operatorOptions.add(new SelectOption('ends_with','Ends With'));
                    
                }
                when 'STRING' {
        			operatorOptions.add(new SelectOption('contains','Contains'));
        			operatorOptions.add(new SelectOption('starts_with','Starts With'));
        			operatorOptions.add(new SelectOption('ends_with','Ends With'));
                    
                }
                when 'TEXTAREA' {
        			operatorOptions.add(new SelectOption('contains','Contains'));
        			operatorOptions.add(new SelectOption('starts_with','Starts With'));
        			operatorOptions.add(new SelectOption('ends_with','Ends With'));
                    
                }
                when 'TIME' {
        			operatorOptions.add(new SelectOption('>','Greater Than'));
        			operatorOptions.add(new SelectOption('>=','Greater Than or Equal To'));
        			operatorOptions.add(new SelectOption('<','Less Than'));
        			operatorOptions.add(new SelectOption('<=','Less Than or Equal To'));
                    
                }
                when 'URL' {
        			operatorOptions.add(new SelectOption('contains','Contains'));
        			operatorOptions.add(new SelectOption('starts_with','Starts With'));
        			operatorOptions.add(new SelectOption('ends_with','Ends With'));
                    
                }
            }
        }
        
        return operatorOptions;
    }
    
    public List<SelectOption> getMinuteOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(PicklistEntry option: Apex_Trigger__c.Minute__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(option.getValue(),option.getLabel()));
        }
        
        return options;
    }
    
    public List<SelectOption> getHourOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(PicklistEntry option: Apex_Trigger__c.Hour__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(option.getValue(),option.getLabel()));
        }
        
        return options;
    }
    
    public List<SelectOption> getDayWeekOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(PicklistEntry option: Apex_Trigger__c.Day_of_Week__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(option.getValue(),option.getLabel()));
        }
        
        return options;
    }
    
    public List<SelectOption> getDayMonthOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(PicklistEntry option: Apex_Trigger__c.Day_of_Month__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(option.getValue(),option.getLabel()));
        }
        
        return options;
    }
    
    public List<SelectOption> getMonthOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for(PicklistEntry option: Apex_Trigger__c.Month__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(option.getValue(),option.getLabel()));
        }
        
        return options;
    }

    private Boolean validateCriteria(Integer num) {
        String field = '';
        String operator = '';
        String value = '';
        if (num == 1) {
            field = apexTrigger.Criteria_Field_1__c;
            operator = apexTrigger.Criteria_Operator_1__c;
            value = apexTrigger.Criteria_Value_1__c;
        }
        if (num == 2) {
            field = apexTrigger.Criteria_Field_2__c;
            operator = apexTrigger.Criteria_Operator_2__c;
            value = apexTrigger.Criteria_Value_2__c;
        }
        if (num == 3) {
            field = apexTrigger.Criteria_Field_3__c;
            operator = apexTrigger.Criteria_Operator_3__c;
            value = apexTrigger.Criteria_Value_3__c;
        }
        if (num == 4) {
            field = apexTrigger.Criteria_Field_4__c;
            operator = apexTrigger.Criteria_Operator_4__c;
            value = apexTrigger.Criteria_Value_4__c;
        }
        if (num == 5) {
            field = apexTrigger.Criteria_Field_5__c;
            operator = apexTrigger.Criteria_Operator_5__c;
            value = apexTrigger.Criteria_Value_5__c;
        }
        if ((field == null || field == '') && (operator == null || operator == '') && ( value == null || value == '')) return true;
        if (field != null && field != '' && operator != null && operator != '' && value != null && value != '') {
            Boolean listContainsOperator = false;
            for (SelectOption so: operatorOptions(num)) {
                if (so.getValue() == operator) listContainsOperator = true;
            }
            if (!listContainsOperator) return false;
            return true;
        }
        return false;
    }

    private Boolean validate() {
        if (!this.apexTrigger.Active__c) return true;
        if (getNoSelectedObject()) return false;
        for (Integer i = 1; i<=5; i++) {
            if (!validateCriteria(i)) return false;
        }
        return true;
    }

    public PageReference save() {
        Boolean valid = validate();
        if (!valid) return null;
        upsert this.apexTrigger;
        PageReference pageRef = new PageReference('/'+this.apexTrigger.id);
        return pageRef;
    }
}