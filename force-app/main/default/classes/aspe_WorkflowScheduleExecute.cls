public class aspe_WorkflowScheduleExecute {
    public Workflow_Schedule__c workflowSchedule {get; set;}
    public aspe_WorkflowScheduleExecute() {}
    // public class myException extends Exception {}

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
        if (field != null && field != '' && operator != null && operator != '' && value != null && value != '') return 'true';
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
                when 'CURRENCY','DOUBLE','INTEGER','PERCENT','BOOLEAN' {
                    return String.escapeSingleQuotes(value);
                }
            }
            return '\''+String.escapeSingleQuotes(value)+'\'';
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
        String fieldType = fieldDescribe.getDescribe().getType().name();
        if (fieldDescribe != null && fieldType == 'REFERENCE'){
            field = fieldDescribe.getDescribe().getRelationshipName() + '.Name';
        }
        String escapedValue = String.escapeSingleQuotes(value);
        String escapedField = String.escapeSingleQuotes(field);
        System.debug(escapedValue);
        System.debug(escapedField);

        List<String> nonStringTypes = new List<String>{'DATE','TIME','DATETIME','CURRENCY','DOUBLE','INTEGER','PERCENT','BOOLEAN'};

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
               return '(NOT ' + escapedField +' LIKE \'%'+escapedValue+'%\')';
           }
           when 'not_starts_with' {
               return '(NOT ' + escapedField +' LIKE \''+escapedValue+'%\')';
           }
           when 'not_ends_with' {
               return '(NOT ' + escapedField +' LIKE \'%'+escapedValue+'\')';
           }
           when 'is_empty' {
               if (nonStringTypes.contains(fieldType)) return escapedField+' = NULL';
               else return '('+escapedField+' = NULL OR '+escapedField+' = \'\')';
           }
           when 'is_not_empty' {
               if (nonStringTypes.contains(fieldType)) return escapedField+' != NULL';
                else return '('+escapedField+' != NULL AND '+escapedField+' != \'\')';
           }
           when else {
               return escapedField + ' ' + String.escapeSingleQuotes(operator) + ' '+SQLifyValue(field,value);
           }
        }
    }

    private String generateSql() {
        String cleanedFilterLogic = workflowSchedule.Filter_Logic__c.replaceAll('[^() andorANDOR1-5]','');
        String singleCriteria = '';
        if (cleanedFilterLogic != workflowSchedule.Filter_Logic__c) return null;
        cleanedFilterLogic = cleanedFilterLogic.replaceAll('(\\d)', '{$1}');
        String sqlWhere = '';
        for (Integer i = 1; i<=5; i++) {
            // singleCriteria = '';
            switch on validateCriteria(i) {
                when 'true' {
                    if (sqlWhere.length() == 0) sqlWhere = ' WHERE '+cleanedFilterLogic;
                    Integer criteriaPosition = sqlWhere.indexOf('{'+String.valueOf(i)+'}');
                    sqlWhere = sqlWhere.substring(0, criteriaPosition) + SQLifyCriteria(i) + sqlWhere.substring(criteriaPosition+3);
                }
                when 'empty' {
                    cleanedFilterLogic = cleanedFilterLogic.replaceAll('(AND )?\\{'+String.valueOf(i)+'\\}', '');
                    sqlWhere = sqlWhere.replaceAll('(AND )?\\{'+String.valueOf(i)+'\\}', '');
                }
            }
        }
        return 'SELECT Id FROM '+workflowSchedule.Object_Type__c+sqlWhere;
    }

    public Void execute(Workflow_Schedule__c workflowSchedule) {
        this.workflowSchedule = workflowSchedule;

        if (this.workflowSchedule.Parsed_SQL__c != null && this.workflowSchedule.Parsed_SQL__c != '') {
            List<sObject> test = Database.query(this.workflowSchedule.Parsed_SQL__c);
            update test;
        } else {
            String sql = generateSql();
            try {
                List<sObject> test = Database.query(sql);
                update test;
                workflowSchedule.Parsed_SQL__c = sql;
                update workflowSchedule;
            } catch (Exception e) {
                throw e;
            }
        }
    }
}