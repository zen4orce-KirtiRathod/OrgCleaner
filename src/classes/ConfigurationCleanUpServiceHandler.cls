public class ConfigurationCleanUpServiceHandler { 
    
    public List<String> WorkflowsToBeDeleted = new List<String>();
    public List<String> ValidationRulesToBeDeleted = new List<String>();
    public List<String> ApprovalProcessToBeDeleted = new List<String>();
    public Map<String,List<String>> ParnetChildMap = new Map<String,List<String>>();
    public Map<String,String> TempDependantMap = new Map<String,String>();
    public List<String> ChildToParentListToBeDeleted = new List<String>();
    public static Integer CounterFlag = 0;
    
    public void RetrieveWorkflows(){
    	MetadataService.FileProperties[] fileproperties = MetadataService.listWorkflowMetadata();
    	WorkflowsToBeDeleted = new List<String>();
    	for(MetadataService.FileProperties fileProperty : fileProperties)
    	{
    		if(fileProperty.fullName != null && fileProperty.fullName != '' && Schema.describeSObjects(new String[]{fileProperty.fullName.split('\\.')[0]})[0].isCustom())
            {
    				WorkflowsToBeDeleted.add(fileProperty.ID);
    		}
    	}
    }
        
    public void RetrieveApprovalProcess(){
    	MetadataService.FileProperties[] fileproperties = MetadataService.listApprovalProcessMetadata();
    	ApprovalProcessToBeDeleted = new List<String>();
    	for(MetadataService.FileProperties fileProperty : fileProperties)
    	{
    		if(fileProperty.fullName != null && fileProperty.fullName != '' && Schema.describeSObjects(new String[]{fileProperty.fullName.split('\\.')[0]})[0].isCustom())
            {
  					System.debug(fileProperty.fullName);
    				ApprovalProcessToBeDeleted.add(fileProperty.ID);
    		}
    	}
    }
      public void RetrieveValidationRules(){
    	MetadataService.FileProperties[] fileproperties = MetadataService.listValidationRuleMetadata();
    	ValidationRulesToBeDeleted = new List<String>();
    	for(MetadataService.FileProperties fileProperty : fileProperties)
    	{
    		if(fileProperty.fullName != null && fileProperty.fullName != '' && Schema.describeSObjects(new String[]{fileProperty.fullName.split('\\.')[0]})[0].isCustom())
            {
  					System.debug(fileProperty.fullName);
    				ValidationRulesToBeDeleted.add(fileProperty.ID);
    		}
    	}
    }
    
    public List<String> GetAllObjects(){
        List<String> supportedObject = new List<String>();
        try{
        	Map<String,Schema.SObjectType> objectsMap = Schema.getGlobalDescribe();
        	for(Schema.SObjectType target : objectsMap.values()) {
	            supportedObject.add(String.valueOf(target));
                //System.debug('List : '+ String.valueOf(target) );
    	    }
        }
        catch(Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Error Occurred - '+e.getMessage());
            ApexPages.addMessage(errormsg);
        }  
        return supportedObject;
    }
    
    public List<String> GetAllVisualforcePages(){
        List<String> visualforcePages = new List<String>();
       for(ApexPage obj : VisualForcePageSelector.queryPage()){
            visualforcePages.add(obj.Name);
         //  System.debug('list : '+obj.Name);
        }
     
        return visualforcePages;
    }
    
    public List<String> GetAllDeletableObjects(){
        List<String> supportedObject = new List<String>();
        for(Schema.SObjectType item : ProcessInstance.TargetObjectId.getDescribe().getReferenceTo())
        {
            if(item.getDescribe().isCustom()) //Returns true if the object is a custom object, false if it is a standard object.
            {
                supportedObject.add(item.getDescribe().getLocalName().toLowerCase());
            }
        }
        System.debug('list : '+supportedObject);
        return supportedObject;
    }

	// Delete Part
	
      public void DeleteMetadata(List<String> ToBeDeleted){
    	ToolingAPI tAPI = new ToolingAPI();
    	//List<String> some = new List<String>();
    	//some.add('06628000004yuddAAA'); //VF PAGE
    	//some.add('01q28000000BPTVAA4'); //TRIGGER
    	//some.add('01p28000008Na7qAAC'); //CLASS
    	//some.add('01Q280000001O9aEAE'); //Workflow
    	System.debug(ToBeDeleted);
    	tAPI.deleteByIds(ToBeDeleted);
    }
    
    public void DeleteObjects(List<String> objectList){
        //List<String> objectList = GetAllDeletableObjects();
        if(objectList.size() > 10){
            List<String> objectToDelete = new List<String>();
            for(Integer iCount = 0; iCount < objectList.size(); iCount++){
                objectToDelete.add(objectList[iCount]);
                if(math.mod(iCount, 10) == 0){//Returns the remainder of integerValue1 divided by integerValue2.
                   //// System.debug('iCount ' + iCount);
                    //Limit: 10. (For CustomMetadata only, the limit is 200.)
                    MetadataService.deleteObject(objectToDelete);
                    objectToDelete = new List<String>();
                }
            }
        }
        else{
            MetadataService.deleteObject(objectList);
        }
    }
    
    // Relationships
    
     public void ParnetChildRelationshipMap(String[] objects){
   		Schema.DescribeSobjectResult[] describeObjResult = Schema.describeSObjects(objects);
        try{
        	for(Schema.DescribeSobjectResult parentObj : describeObjResult) {
            	if(parentObj.isCustom() && !IsManagedObject(parentObj.getName())){
                	Schema.ChildRelationship[] childObjs = parentObj.getChildRelationships();
                	for(Schema.ChildRelationship childObj: childObjs){
                		//CHECK FOR SELF LOOKUP RELATIONSHIP
                    	if(parentObj.getName() != String.valueOf(childObj.getChildSObject())){
                        	Schema.DescribeSobjectResult[] chilObjDescribe = Schema.describeSObjects(new String[]{String.valueOf(childObj.getChildSObject())});
                        	if(chilObjDescribe[0].isCustom() && !IsManagedObject(parentObj.getName())){
                            	TempDependantMap.put(String.valueOf(childObj.getChildSObject()),String.valueOf(childObj.getChildSObject()));
                        	}
                    	}
                	}
                    List<string> tempValues = TempDependantMap.values();
                    ParnetChildMap.put(parentObj.getName(), tempValues);
                	TempDependantMap = new Map<String,String>();
                }
            }
        }
        catch(Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Error Occurred - '+e.getMessage());
            ApexPages.addMessage(errormsg);
        }  
  	}
    
    public void PrepareDependentObjectList(){
    	try{
        	if(CounterFlag == 0){
        		ChildToParentListToBeDeleted = new List<String>();	
        	}
        	CounterFlag++;
            for(String objectName : ParnetChildMap.keySet()){
                if(ParnetChildMap.get(objectName) != null && ParnetChildMap.get(objectName).size() > 0){
                    continue;
                }
                else{
                    ChildToParentListToBeDeleted.add(objectName);
                    ParnetChildMap.remove(objectName);
                    for(String objectNeedToUpdate : ParnetChildMap.keySet()){
                        List<String> ChildListNeedToUpdate = ParnetChildMap.get(objectNeedToUpdate);
                        for(Integer iCount = 0; iCount < ChildListNeedToUpdate.size(); iCount++){
                            if(ChildListNeedToUpdate[iCount] == objectName){
                                ChildListNeedToUpdate.remove(iCount);
                            }
                        }
                        ParnetChildMap.put(objectNeedToUpdate, ChildListNeedToUpdate);
                    }
                }
            }
            if(ParnetChildMap.size() > 0){
                PrepareDependentObjectList();
            }
           }
        catch(Exception e){
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Error Occurred - '+e.getMessage());
            ApexPages.addMessage(errormsg);
        }  
    }
    
     public Boolean IsManagedObject(String ObjectName){
    	Boolean flag = false;
    	List<Organization> OrganizationDetails =  [SELECT Id,NamespacePrefix FROM Organization];
		if(OrganizationDetails.size() > 0){
			for(Organization orgObj : OrganizationDetails){
				if(orgObj.NamespacePrefix != null && ObjectName.startsWith(orgObj.NamespacePrefix+'__')){
					flag = false;
					break;
				}
				if(orgObj.NamespacePrefix == null && ObjectName.countMatches('__') > 1){
					flag = true;
					break;
				}
				else{
					flag = false;
				}
			}
		}
		return flag;
    }    
}