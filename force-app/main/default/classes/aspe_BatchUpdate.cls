global class aspe_BatchUpdate implements Database.Batchable<sObject> {
    String query;
    public aspe_BatchUpdate(String query) {
        this.query = query;
    }
    global Iterable<sObject> start(Database.BatchableContext bc) {
        Database.QueryLocator ql = Database.getQueryLocator(this.query);
		return ql;
    }
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        update scope;
    }
    global void finish(Database.BatchableContext bc){}
}