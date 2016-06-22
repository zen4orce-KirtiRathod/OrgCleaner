public class ConfigurationCleanUpService {
    
    ConfigurationCleanUpServiceHandler obj = new ConfigurationCleanUpServiceHandler();
    
    public void RetrieveValidationRule(){ //tested and working
        obj.RetrieveValidationRules();
    }
    
    public void ApprovalProcesses(){  //tested and providing o/p of Processbuilder
        obj.RetrieveApprovalProcess();
    }
    
    public void RetrieveWorkflow(){		//tested and working
        obj.RetrieveWorkflows();
    }
        
    public void GetAllObject(){		//tested and working
        obj.GetAllObjects();
    }
    
    public void GetAllVisualforcePage(){		//tested and working
        obj.GetAllVisualforcePages();
    }
    
    public void GetAllDeletableObject(){		//tested and working
        obj.GetAllDeletableObjects();
    }
    
    // All Delete Operations   
    List<String> abc =  new List<String>();
    public void DeleteAllObject(){	
        obj.DeleteObjects(abc);
    }
    
    public static void DeleteFlow(){		
        MetadataService.deleteFlow();
    }
    
    

}