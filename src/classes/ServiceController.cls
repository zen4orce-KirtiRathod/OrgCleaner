public with sharing class ServiceController 
{
    //AS DISCUSSED THERE IS NO USE OF MULTIPLE METHODS ON SERVER SIDE IT CAN BE OPTIMIZED TO ONE
    //variable nameshould be meaningful  for ex. configuration         
    //NO NEED OF CONDITIONAL STATEMENT AS DISCUSSED YOU CAN USE THIS - con.Confirmation_Keyword__c = confirm;

    @AuraEnabled
    public static void UpdateDetails(String confirm, String followUp, Boolean SendAppointmentCheck, Boolean x1hr, Boolean x24hr,Boolean ServiceAReminder)
    {
        try{
        	SMSConfiguration__c Configuration=[select id, Service_Appointment_Reminder__c,X24_Hour_Reminder__c, X1_Hour_Reminder__c, Confirmation_Keyword__c,Follow_up_keyword__c,Service_Appointment_Confirmation__c from SMSConfiguration__c Limit 1];
                
                if(SendAppointmentCheck==null)
                {
                    SendAppointmentCheck = false;
                }
                if(x1hr==null)
                {
                    x1hr = false;                
                }
                if(x24hr==null)
                {
                    x24hr = false; 
                       
                }
                if(ServiceAReminder==null)
                {
                    ServiceAReminder=false; 
                }
                
            Configuration.Confirmation_Keyword__c = confirm;
            Configuration.Follow_up_keyword__c=followUp;
            Configuration.Service_Appointment_Confirmation__c=SendAppointmentCheck;
            Configuration.X1_Hour_Reminder__c=x1hr;
            Configuration.X24_Hour_Reminder__c=x24hr;           
            Configuration.Service_Appointment_Reminder__c=ServiceAReminder;
            
            if(!ServiceAReminder)
            {
                Configuration.X24_Hour_Reminder__c=False;
                Configuration.X1_Hour_Reminder__c=False;
            }   
            update Configuration; 
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    } 
}