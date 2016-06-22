public with sharing class MetaDataAPIExamples {

// Create Object and field in my org	
 public static void dynamicCreation(String objectName)
    {      
        // Define Metadata item to create a Custom Object
        MetadataService.CustomObject customObject = new MetadataService.CustomObject();
        customObject.fullName = objectName + '__c';
        customObject.label = objectName;
        customObject.pluralLabel = objectName+'s';
        customObject.nameField = new MetadataService.CustomField();
        customObject.nameField.type_x = 'Text';    
        customObject.nameField.label = 'Test Record';
        customObject.deploymentStatus = 'Deployed';
        customObject.sharingModel = 'ReadWrite';

        // Define Metadata item to create a Custom Field on the above object
        MetadataService.CustomField customField1 = new MetadataService.CustomField();
        customField1.fullName = objectName+'__c.TestField1__c';
        customField1.label = 'Test Field 1';
        customField1.type_x = 'Text';
        customField1.length = 42;

        // Define Metadata item to create a Custom Field on the above object
        MetadataService.CustomField customField2 = new MetadataService.CustomField();
        customField2.fullName = objectName+'__c.TestField2__c';
        customField2.label = 'Test Field 2';
        customField2.type_x = 'Text';
        customField2.length = 42;

        // Define Metadata item to create a Visualforce page to display the above field
        MetadataService.ApexPage apexPage = new MetadataService.ApexPage();
        apexPage.apiVersion = 25;
        apexPage.fullName = objectName.toLowercase();
        apexPage.label = objectName + ' Page';
        apexPage.content = EncodingUtil.base64Encode(Blob.valueOf(
            '<apex:page standardController=\''+objectName+'__c\'>'+
                '{!' + objectName + '__c.TestField1__c}' +
                '{!' + objectName + '__c.TestField2__c}' +
            '</apex:page>'));

        // Create components in the correct order
        MetadataService.MetadataPort service = createService();
        List<MetadataService.SaveResult> results =
            service.createMetadata(
                new MetadataService.Metadata[] { customObject });
        handleSaveResults(results[0]);
        results =
            service.createMetadata(
                new MetadataService.Metadata[] { customField1, customField2 });
        handleSaveResults(results[0]);
        handleSaveResults(results[1]);
        results =
            service.createMetadata(
                new MetadataService.Metadata[] { apexPage });
        handleSaveResults(results[0]);
    }

       
  public static void getbuttons()
    {
    /*	 MetadataService.MetadataPort service = createService();
     MetadataService.Layout layout =
            (MetadataService.Layout) service.readMetadata('Layout',
                new String[] { 'Test__c-Test Layout' }).getRecords()[0];
      */          
                
        MetadataService.MetadataPort service = createService();
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();

       
        MetadataService.ListMetadataQuery queryCustomField = new MetadataService.ListMetadataQuery();
        queryCustomField.type_x = 'Layout';
        queries.add(queryCustomField);
       
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        for(MetadataService.FileProperties fileProperty : fileProperties)
        System.debug(fileProperty);         
    }
    
    	public static void createotherFields(String oName,String fLabel,String fAPIName,String fType)
		{
			MetadataService.CustomField customField1 = new MetadataService.CustomField();
        	customField1.fullName = 'test__c.'+fAPIName;  
        	customField1.label = fLabel;
        	customField1.type_x = fType;
        	
        	customField1.length = 300; // min 256
        	
        	
        	// for auto number 
        //	customField1.displayFormat='sb-{000}';
        
         // For Rich text area 
        //	customField1.length = 300; // min 256
       // 	customField1.visibleLines=10; // min 10
        	
         //  customField1.summarizedField='test__c.EmpSalary__c';//test__c
         //  customField1.summaryForeignKey='test__c.mdetail__c';
         //   customField1.summaryOperation='count';
        	MetadataService.MetadataPort service = createService();    
         	List<MetadataService.SaveResult> results =
            service.createMetadata(
                new MetadataService.Metadata[] { customField1 });
        	handleSaveResults(results[0]);
	}
    
    
  public static void createWebLink()
    {
        MetadataService.MetadataPort service = createService();
        MetadataService.WebLink webLink = new MetadataService.WebLink();
        webLink.fullName = 'Test__c.googleButton';
        webLink.availability = 'online';
        webLink.displayType = 'link';
        webLink.encodingKey = 'UTF-8';
        webLink.hasMenubar = false;
        webLink.hasScrollbars = true;
        webLink.hasToolbar = false;
        webLink.height = 600;
        webLink.isResizable = true;
        webLink.linkType = 'url';
        webLink.masterLabel = 'google';
        webLink.openType = 'newWindow';
        webLink.position = 'none';
        webLink.protected_x = false;
        webLink.showsLocation = false;
        webLink.showsStatus = false;
        webLink.url = 'http://www.google.com';
        webLink.width = 600;
        List<MetadataService.SaveResult> results =
            service.createMetadata(
                new MetadataService.Metadata[] { webLink });
        handleSaveResults(results[0]);
    }
  
    
    // update fields
    public static void updateField()
    {
        MetadataService.MetadataPort service = createService();
        MetadataService.CustomField customField = new MetadataService.CustomField();
        customField.fullName = 'Test__c.TestField__c';
        customField.label='New Test Field Label';
        customField.type_x = 'Text';
        customField.length = 52;
        List<MetadataService.SaveResult> results =
            service.updateMetadata(
                new MetadataService.Metadata[] { customField });
        handleSaveResults(results[0]);
    }
    
    
    public static void createTask()
    { 	
			List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
            MetadataService.MetadataPort service = createService();
            
         		 MetadataService.Workflow wFlow = new MetadataService.Workflow(); 
         		   wFlow.fullName = 'Account.TestNewWFLOW90';
                
               /*  List<MetadataService.WorkflowTask> wTask = new List<MetadataService.WorkflowTask>();
                
                 MetadataService.WorkflowTask wTask1 = new MetadataService.WorkflowTask();
                 wTask1.fullName = 'Account.Test2';
                 wTask1.assignedToType = 'owner';
                 wTask1.description = 'Task';
                 wTask1.dueDateOffset = 20;
                 wTask1.notifyAssignee = true;
                 wTask1.priority = 'High';
                 wTask1.protected_x = false;
                 wTask1.status='Not Started';
                 wTask1.subject = 'Yupp';
               handleSaveResults(service.createMetadata(new List<MetadataService.Metadata> { wTask })[0]);
               */   
                  
                  
                  MetadataService.WorkflowTask wTask1 = new MetadataService.WorkflowTask();
                 wTask1.fullName = 'contact.Test5';
                 wTask1.assignedToType = 'owner';
                 wTask1.description = 'Task';
                 wTask1.dueDateOffset = 20;
                 wTask1.notifyAssignee = true;
                 wTask1.priority = 'High';
                 wTask1.protected_x = false;
                 wTask1.status='Not Started';
                 wTask1.subject = 'Test_task_Account';
                 
                  
              handleSaveResults(service.createMetadata(new List<MetadataService.Metadata> { wTask1 })[0]);
                 
           //    System.debug('result '+service.createMetadata(new List<MetadataService.Metadata> { wTask1 })); 
                 //wFlow.tasks = new List<MetadataService.WorkflowTask> {wTask};
                 
              
		 
		    	
		    	
    }
    
    
     public static void updatenewWorkflow() 
       {
       		List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
            MetadataService.MetadataPort service = createService();

 			MetadataService.WorkflowRule wRule =
                 (MetadataService.WorkflowRule) service.readMetadata('WorkflowRule',
               	 new String[] { 'Account.Testwflow1.wFlowrule1' }).getRecords()[0];
           		System.debug('Retrive : '+ wRule.active);
				 wRule.active = true;
				 wRule.description='test data';

  			MetadataService.FilterItem ruleCrit = new MetadataService.FilterItem ();
                ruleCrit.field = 'Account.Phone';
                ruleCrit.operation = 'equals';
                ruleCrit.value = '50000';
 			wRule.criteriaItems = new List<MetadataService.FilterItem> {ruleCrit};  
                
    		handleSaveResults(service.updateMetadata(new List<MetadataService.Metadata> { wRule })[0]);  		  
      }
    
     public static void updateworkflow()
    {
        MetadataService.MetadataPort service = createService();
      
          MetadataService.Workflow wFlow =
            (MetadataService.Workflow) service.readMetadata('Workflow',
                new String[] { 'Testwflow1.wFlowrule1' }).getRecords()[0];    
                
                //wflow.type=FieldUpdate;
                MetadataService.WorkflowRule wRule = new MetadataService.WorkflowRule();
                wRule.active=false;
                wRule.description ='';
                wRule.triggerType='onAllChanges';
                wflow.rules = new List<MetadataService.WorkflowRule> {wRule};
                
                
                
       			handleSaveResults(service.updateMetadata(new List<MetadataService.Metadata> { wflow })[0]);
                
                System.debug('flow'+wFlow);
   
    }
    
    
    public static void createWorkflow()
    {
        MetadataService.MetadataPort service = createService();
      
		        MetadataService.Workflow wFlow = new MetadataService.Workflow(); 
		        wFlow.fullName = 'Account.Testwflow1';
 
                MetadataService.WorkflowRule wRule = new MetadataService.WorkflowRule();
                wRule.active=true;
                wRule.description ='from metadata';
                wRule.triggerType='onAllChanges';
                wRule.fullName = 'wFlowrule1'; 
               
               
               
                
                MetadataService.FilterItem ruleCrit = new MetadataService.FilterItem ();
                ruleCrit.field = 'Account.Phone';
                ruleCrit.operation = 'equals';
                ruleCrit.value = '500';
                wRule.criteriaItems = new List<MetadataService.FilterItem> {ruleCrit};
                
                
                MetadataService.WorkflowActionReference wa = new MetadataService.WorkflowActionReference();
                wa.name='Test5';
                wa.type_x='Task';
                wRule.actions = new List<MetadataService.WorkflowActionReference>{wa};
                 
                 
                 
                wflow.rules = new List<MetadataService.WorkflowRule> {wRule};  
              //  wFlow.tasks = new List<MetadataService.WorkflowTask> {wTask};
                handleSaveResults(service.createMetadata(new List<MetadataService.Metadata> { wflow })[0]);       
                
          
       			 
    }
    
    
    
    public static void listMetadata()
    {
        MetadataService.MetadataPort service = createService();
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
       // MetadataService.ListMetadataQuery queryWorkflow = new MetadataService.ListMetadataQuery();
       // queryWorkflow.type_x = 'Workflow';
       // queries.add(queryWorkflow);
       // MetadataService.ListMetadataQuery queryValidationRule = new MetadataService.ListMetadataQuery();
       // queryValidationRule.type_x = 'ValidationRule';
       // queries.add(queryValidationRule);
       // MetadataService.ListMetadataQuery queryCustomField = new MetadataService.ListMetadataQuery();
       // queryCustomField.type_x = 'CustomField';
       // queries.add(queryCustomField);
       
        MetadataService.ListMetadataQuery queryCustomField = new MetadataService.ListMetadataQuery();
        System.debug('types 0'+queryCustomField.type_x);
        queryCustomField.type_x = 'CustomField';
        System.debug('types'+queryCustomField.type_x);
        queries.add(queryCustomField);
        
       
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        for(MetadataService.FileProperties fileProperty : fileProperties)
        {
            System.debug(fileProperty.fullName);
            
        }
    }
    
     public static void readWorkflowAlert()
    {
        MetadataService.MetadataPort service = createService();

        // Read Workflow Alert
        MetadataService.WorkflowAlert wfa =
            (MetadataService.WorkflowAlert) service.readMetadata('WorkflowAlert',
                new String[] { 'Test__c.Test' }).getRecords()[0];
        System.debug('Description ' + wfa.description);
        System.debug('Sender Address ' + wfa.senderAddress);
    }
    
    
      public static void createFlow() {

        MetadataService.MetadataPort service = createService();

        // Create Flow
        MetadataService.Flow flow = new MetadataService.Flow();
        flow.fullName = 'NewFlow-1';
        flow.description = 'New Flow';
        flow.label = 'New Flow';
        flow.processType = 'Flow';
        MetadataService.FlowRecordCreate recordCreate = new MetadataService.FlowRecordCreate();
        recordCreate.name = 'RecordCreate';
        recordCreate.label = 'Record Create';
        recordCreate.object_x = 'Account';
        recordCreate.locationX = 10;
        recordCreate.locationY = 10;
        recordCreate.inputAssignments = new List<MetadataService.FlowInputFieldAssignment>();
        recordCreate.inputAssignments.add(new MetadataService.FlowInputFieldAssignment());
        recordCreate.inputAssignments[0].field = 'AccountNumber';
        recordCreate.inputAssignments[0].value = new MetadataService.FlowElementReferenceOrValue();
        recordCreate.inputAssignments[0].value.stringValue = '1234';
        flow.recordCreates = new List<MetadataService.FlowRecordCreate> { recordCreate };
        flow.startElementReference = 'RecordCreate';
        handleSaveResults(service.createMetadata(new List<MetadataService.Metadata> { flow })[0]);
    }
    
     public static void readFlow()
    {
        MetadataService.MetadataPort service = createService();
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
        
        MetadataService.ListMetadataQuery queryFlow = new MetadataService.ListMetadataQuery();
        queryFlow.type_x = 'Flow';
        queries.add(queryFlow);
	    MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
     
        for(MetadataService.FileProperties fileProperty : fileProperties)
        {
           

                MetadataService.Flow flow =
                (MetadataService.Flow) service.readMetadata('Flow',
                    new String[] { fileProperty.fullName}).getRecords()[0];
                System.debug('flow ' +flow.actionCalls[0].actionName);

          //  System.debug('flow ' +flow.actionCalls[0].actionName);
            
        }
        
       /* // Read Flow
        MetadataService.Flow flow =
            (MetadataService.Flow) service.readMetadata('Flow',
                new String[] { 'Process_related_to_Keyword-14' }).getRecords()[0];*/
        

        
       
    }    

    public static void updateFlow() {
        
        MetadataService.MetadataPort service = createService();

        // Read Flow
        MetadataService.Flow flow =
            (MetadataService.Flow) service.readMetadata('Flow',
                new String[] { 'NewFlow-1' }).getRecords()[0];

        // Add a new step
        MetadataService.FlowScreen flowScreen = new MetadataService.FlowScreen();
        flowScreen.name = 'NewScreen';
        flowScreen.label = 'New Screen';
        flowScreen.locationX = 100;
        flowScreen.locationY = 100;
        flowScreen.allowBack = true;
        flowScreen.allowFinish = true;
        flowScreen.fields = new List<MetadataService.FlowScreenField>();
        flowScreen.fields.add(new MetadataService.FlowScreenField());
        flowScreen.fields[0].name = 'Test_Box';
        flowScreen.fields[0].dataType = 'String';
        flowScreen.fields[0].fieldText = 'Test Box';
        flowScreen.fields[0].fieldType = 'InputField';
        flowScreen.fields[0].isRequired = true;
        flow.screens = new List<MetadataService.FlowScreen> { flowScreen };

        // Link it with the previous one
        flow.recordCreates[0].connector = new MetadataService.FlowConnector();
        flow.recordCreates[0].connector.targetReference = 'NewScreen';

        // Update
        handleSaveResults(service.updateMetadata(new List<MetadataService.Metadata> { flow })[0]);
    }

    public static void deleteFlow() {

        MetadataService.MetadataPort service = createService();

        // Delete Flow
        handleDeleteResults(
            service.deleteMetadata('Flow', new String[] { 'NewFlow-1' })[0]);
    }


  public static void addFields(MetadataService.FlowScreen flowScreen, List<SObjectField> fieldsToAdd) {
        for(SObjectField field : fieldsToAdd) {
            // Construct a FlowScreenField based on the SObjectField metadata
            DescribeFieldResult fieldDescribe = field.getDescribe();
            // https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_visual_workflow.htm#FlowScreenField
            MetadataService.FlowScreenField flowScreenField = new MetadataService.FlowScreenField();
            flowScreenField.name = fieldDescribe.getName();
            flowScreenField.dataType = FLOWTYPEBYDISPLAYTYPE.get(fieldDescribe.getType());
            flowScreenField.fieldText = fieldDescribe.getLabel();
            flowScreenField.fieldType = 'InputField';
            flowScreenField.isRequired = flowScreenField.dataType == 'Boolean' ? true : fieldDescribe.isNillable();            
            flowScreenField.helpText = fieldDescribe.getInlineHelpText();
            if(flowScreenField.dataType == 'Number') {
                flowScreenField.scale = fieldDescribe.getScale();
            }
            // Add to Screen field list
            if(flowScreen.fields==null)
                flowScreen.fields = new List<MetadataService.FlowScreenField>();
            flowScreen.fields.add(flowScreenField);
        }
    }

    public static void createFlowAdvanced() {
        
        MetadataService.MetadataPort service = createService();

        // Create Flow
        MetadataService.Flow flow = new MetadataService.Flow();
        flow.fullName = 'NewFlow-1';
        flow.description = 'New Flow';
        flow.label = 'New Flow';
        flow.processType = 'Flow';
        flow.startElementReference = 'NewScreen';        

        // Add a new step
        MetadataService.FlowScreen flowScreen = new MetadataService.FlowScreen();
        flowScreen.name = 'NewScreen';
        flowScreen.label = 'New Screen';
        flowScreen.locationX = 100;
        flowScreen.locationY = 100;
        flowScreen.allowBack = true;
        flowScreen.allowFinish = true;       
        addFields(flowScreen, 
            new List<SObjectField> { 
                Account.AccountNumber, 
                Account.Description, 
                Account.Fax,
                Account.AnnualRevenue });
        flow.screens = new List<MetadataService.FlowScreen> { flowScreen };

        // Create
        handleSaveResults(service.createMetadata(new List<MetadataService.Metadata> { flow })[0]);
    }

 public class MetaDataAPIExamplesException extends Exception { }

    public static MetadataService.MetadataPort createService()
    {
    	
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
    
     /**
     * Example helper method to interpret a SaveResult, throws an exception if errors are found
     **/
    public static void handleSaveResults(MetadataService.SaveResult saveResult)
    {
        // Nothing to see?
        if(saveResult==null || saveResult.success)
            return;
        // Construct error message and throw an exception
        if(saveResult.errors!=null)
        {
            List<String> messages = new List<String>();
            messages.add(
                (saveResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                    'occured processing component ' + saveResult.fullName + '.');
            for(MetadataService.Error error : saveResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0)
                throw new MetaDataAPIExamplesException(String.join(messages, ' '));
        }
        if(!saveResult.success)
            throw new MetaDataAPIExamplesException('Request failed with no specified error.'+saveResult);
    }
    
     public static void handleDeleteResults(MetadataService.DeleteResult deleteResult)
    {
        // Nothing to see?
        if(deleteResult==null || deleteResult.success)
            return;
        // Construct error message and throw an exception
        if(deleteResult.errors!=null)
        {
            List<String> messages = new List<String>();
            messages.add(
                (deleteResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                    'occured processing component ' + deleteResult.fullName + '.');
            for(MetadataService.Error error : deleteResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0)
                throw new MetaDataAPIExamplesException(String.join(messages, ' '));
        }
        if(!deleteResult.success)
            throw new MetaDataAPIExamplesException('Request failed with no specified error.');
    }
    
     public static void handleUpsertResults(MetadataService.UpsertResult upsertResult)
    {
        // Nothing to see?
        if(upsertResult==null || upsertResult.success)
            return;
        // Construct error message and throw an exception
        if(upsertResult.errors!=null)
        {
            List<String> messages = new List<String>();
            messages.add(
                (upsertResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                    'occured processing component ' + upsertResult.fullName + '.');
            for(MetadataService.Error error : upsertResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0)
                throw new MetaDataAPIExamplesException(String.join(messages, ' '));
        }
        if(!upsertResult.success)
            throw new MetaDataAPIExamplesException('Request failed with no specified error.');
    }
    
    
      public static final Map<DisplayType, String> FLOWTYPEBYDISPLAYTYPE = 
            new Map<DisplayType, String>{ 
                DisplayType.anytype => 'String',
                DisplayType.base64 => 'String',
                DisplayType.Boolean => 'Boolean', 
                DisplayType.Combobox => 'String',
                DisplayType.Currency => 'Currency',
                DisplayType.Date => 'Date',
                DisplayType.DateTime => 'DateTime', 
                DisplayType.Double => 'Number',
                DisplayType.Email => 'String',
                DisplayType.EncryptedString => 'String',
                DisplayType.Id => 'String',
                DisplayType.Integer => 'Number',
                DisplayType.MultiPicklist => 'Multipicklist',
                DisplayType.Percent => 'Number', 
                DisplayType.Phone => 'String',
                DisplayType.Picklist => 'Picklist',
                DisplayType.Reference => 'Reference',
                DisplayType.String => 'String',
                DisplayType.TextArea => 'String',
                DisplayType.Time => 'String',
                DisplayType.URL => 'String'};
  
}