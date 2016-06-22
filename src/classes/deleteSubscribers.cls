global class deleteSubscribers implements Database.AllowsCallouts, Database.Stateful, Database.Batchable<sObject>{
    global final String Query;
     public String sessionId;
    global deleteSubscribers(){
        Query='SELECT Id, Name FROM ApexTrigger';
        sessionId = UserInfo.getSessionId();
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC,List<ApexTrigger> scope){
    
        try{
      /*  String username = 'mehul.makwana@zen4orce.com';
        String password = '1122mehul';
     	string securityToken = 'zNPeIZpViuR0prT7n7yIMYLX';
    	toolingSoapSforceCom.SforceService sp = new toolingSoapSforceCom.SforceService();
        toolingSoapSforceCom.LoginResult lr = sp.login(username, password+securityToken);
    //lr.sessionId;*/
        
    
       for (ApexTrigger idKey : scope) 
        {   
            System.debug('IDKEY : '+idKey.ID);
			String endp = 'https://mehulzen4orce-dev-ed.my.salesforce.com/services/data/v29.0/tooling/sobjects/ApexTrigger/'+ idKey.ID;
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'Bearer ' + sessionId);
            system.debug('sessionId: '+sessionId);
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(endp);
            req.setMethod('DELETE');
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug(res.getBody());

        }
        }catch(Exception e){
            
            System.debug('Exception : '+ e.getMessage());
        }
    }

    global void finish(Database.BatchableContext BC){}
}