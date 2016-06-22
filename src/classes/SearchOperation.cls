public class SearchOperation 
{
    //Search Keyword
    public String SearchKeyword = 'ShippingCountry'; 
    Boolean result= FALSE;
    Public void SearchClass()
    {
        //SOSL Dynamic Query
        String SearchQuery = 'FIND {' +SearchKeyword+ '} RETURNING ApexClass(name), ApexTrigger(name)';
        
        Search.SearchResults searchResults = Search.find(SearchQuery);
        List<Search.SearchResult> ClassSearchResult = searchResults.get('ApexClass');
        List<Search.SearchResult> TriggerSearchResult = searchResults.get('ApexTrigger');
        
        //Retriving Keyword Used in Class
        for (Search.SearchResult searchResult : ClassSearchResult) { 
        ApexClass Classes = (ApexClass) searchResult.getSObject(); 
        System.debug('******************************* Used in Class ' +Classes.Name); 
        }
        
        //Retriving Keyword Used in Triggers
        for (Search.SearchResult TriggersearchResults : TriggerSearchResult) { 
        ApexTrigger Triggers = (ApexTrigger) TriggersearchResults.getSObject(); 
        System.debug('******************************* Used in Triggers ' +Triggers.Name);
		} 
      
    }
    
    Public void SearchforPage(){
        
        //Retriving Keyword Used in Pages
        Map<ID, ApexPage> ApexpageBody = new Map<ID, ApexPage>([SELECT Id,Name,Markup FROM ApexPage]);
        List<String> PageNames = new List<String>();
        for (ID idKey : ApexpageBody.keyset()) 
        {
            ApexPage a = ApexpageBody.get(idKey);
            Boolean PageSearchResult = a.Markup.contains(SearchKeyword);
            if(PageSearchResult)
            {
                PageNames.add(a.Name);
            }  
        }
        System.debug('******************************* Received Page Name '+ PageNames); 
    }

    public void SearchforWorkflow()
    {
        MetadataService.MetadataPort service = createService();
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
        MetadataService.ListMetadataQuery queryWorkflow = new MetadataService.ListMetadataQuery();
        queryWorkflow.type_x = 'WorkflowRule';
        queries.add(queryWorkflow);
       
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        
        for(MetadataService.FileProperties fileProperty : fileProperties)
        {
 			MetadataService.WorkflowRule wRule =
                 (MetadataService.WorkflowRule) service.readMetadata('WorkflowRule',
               	 new String[] { fileProperty.fullName }).getRecords()[0];
				 List<String> WorkflowName = new List<String>();
            
                 List<MetadataService.FilterItem> rul = new List<MetadataService.FilterItem>(wRule.criteriaItems);
                   for(MetadataService.FilterItem r : rul)
                   {  
                       result = r.field.contains(SearchKeyword);
                       if(result)
                        {
                           System.debug('Retrive final workflow Name : '+ wRule.fullName);
                           WorkflowName.add(wRule.fullName); 
                        }  
                   }
        	}    
    }
    
    public void SearchforFlow()
    {
        MetadataService.MetadataPort service = createService();
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
        
        MetadataService.ListMetadataQuery queryFlow = new MetadataService.ListMetadataQuery();
        queryFlow.type_x = 'Flow'; 
        queries.add(queryFlow);
        
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        for(MetadataService.FileProperties fileProperty : fileProperties)
        {
            // Read Flow
            MetadataService.Flow flow =
                (MetadataService.Flow) service.readMetadata('Flow',
                    new String[] {  fileProperty.fullName  }).getRecords()[0];
            //System.debug('fileProperty Name ' +fileProperty);
            // 'Process_related_to_Keyword-14'
            //System.debug('flow' +flow.actionCalls[0].actionName);     
            //System.debug('flow Name ' +flow.fullName);
            System.debug('flow ' +flow);   
        }
    }
    
     public void SearchforValidationRule()
    {
        MetadataService.MetadataPort service = createService();
        
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
        List<String> ValidationRuleName = new List<String>();
        
        MetadataService.ListMetadataQuery queryValidationRule = new MetadataService.ListMetadataQuery();
        queryValidationRule.type_x = 'ValidationRule';
        queries.add(queryValidationRule);
        
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        for(MetadataService.FileProperties fileProperty : fileProperties)
        {   
            MetadataService.ValidationRule Validationrul =
                    (MetadataService.ValidationRule) service.readMetadata('ValidationRule',
                        new String[] {  fileProperty.fullName  }).getRecords()[0];
          		
            String fieldr = ValidationRul.errorConditionFormula;
            if(fieldr.contains(SearchKeyword))
            {
                System.debug('Retrive final Validation Rule Name : '+ ValidationRul.fullName);
                ValidationRuleName.add(ValidationRul.fullName); 
            }  
            System.debug('Validation Rule Name List ' +ValidationRuleName);
        }
    }
    
    public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
}