global class TriggerDeleteBatch implements Database.AllowsCallouts, Database.Batchable<sObject>, Database.Stateful {
	
    global final String Query;
    public String sessionId;
    
    global TriggerDeleteBatch(){
        sessionId = UserInfo.getSessionId();
        Query='SELECT Id, Name FROM ApexTrigger';
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC,List<ApexTrigger> scope){
    
        try{
            for (ApexTrigger idKey : scope) 
            {   
                System.debug('IDKEY : '+idKey.ID);
                TriggerDeletehandler.TriggerDelete(idKey.ID, sessionId);
            }
        }catch(Exception e){
            
            System.debug('Exception : '+ e.getMessage());
        }
    }
       global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
       }
}