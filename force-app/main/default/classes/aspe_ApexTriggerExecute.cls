public class aspe_ApexTriggerExecute {
    // Basic variable declaration
    
    public Apex_Trigger__c apexTrigger {get; set;}
    List<String> apiNames =  new List<String>();
    String newApiName = '';

    
    
    // Used to control the fields that don't contain data
    Integer numOfFields = apiNames.size();
    
    // Constructor to pass the apextrigger object into class

    public aspe_ApexTriggerExecute(Apex_Trigger__c apexTrigger) {
        this.apexTrigger = apexTrigger;
    
        // Adds all the field names into a list without the other data fields

        Schema.DescribeSObjectResult r = Apex_Trigger__c.sObjectType.getDescribe();
        for(string apiName : r.fields.getMap().keySet())
        {
            if(apiName.indexOf('criteria_field') != -1){
                String fieldnum = apiName.replaceAll('\\D+','');
                String newApiName = 'Criteria_Field_'+fieldnum+'__c';
                apiNames.add(newApiName);
            }
        }
    }
    
    // Executes the update on the selected fields
    public Void executeUpdates() {
        // Loop tests if each field is filled to only update fields that have data
        for(String fieldTest : apiNames) {
            boolean fieldResult = checkfieldData(fieldTest);
            if(fieldResult == false)
            numOfFields--;
        }

        // Loops through the remaining fields that contain data and simulates an "update"
        for(Integer i = 0; i < numOfFields; i++) {
            // ADD UPDATING CODE BLOCK
        }
    }
    
    // Checks if field has data provided
    public Boolean checkFieldData(string fieldname) {
        if(fieldname == NULL || fieldname == '')
            return false;
        else
            return true;
    }
}