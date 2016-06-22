@isTest
public class ServicePortalTest 
{
    //AFTER RE-VAMPING THE CODE AS PER OUR DISCUSSION, YOU NEED TO WRITE TEST CLASSESS FOR MULTIPLE CONDITIONS AS DISCUSSED
    //INSTED OF CREATING A TEST DATA IN EVERY METHOD YOU CAN OUT THE SAME CODE IN A @testSetup METHOD
	
    @testSetup static void setup()
    { 
        SMSConfiguration__c data = new SMSConfiguration__c();
        data.Confirmation_Keyword__c = 'Yes';
        data.Follow_up_keyword__c = 'Maybe';
        data.Name='test data';
        data.Service_Appointment_Confirmation__c=true;
        data.Service_Appointment_Reminder__c = True;
        data.X1_Hour_Reminder__c = true;
        data.X24_Hour_Reminder__c = true;
        insert data;     
    }
    
    public static testMethod void AllTrueAndNullTest()
    { 
        SMSConfiguration__c Configuration=[select id, Service_Appointment_Reminder__c,X24_Hour_Reminder__c, X1_Hour_Reminder__c, Confirmation_Keyword__c,Follow_up_keyword__c,Service_Appointment_Confirmation__c from SMSConfiguration__c Limit 1];
        System.assertEquals(true,Configuration.Service_Appointment_Reminder__c);
        System.assertEquals(true,Configuration.X24_Hour_Reminder__c);
        System.assertEquals(true,Configuration.X1_Hour_Reminder__c);
        System.assertEquals('Yes',Configuration.Confirmation_Keyword__c);
        System.assertEquals('Maybe',Configuration.Follow_up_keyword__c);
        System.assertEquals(true,Configuration.Service_Appointment_Confirmation__c);
        
        ServiceController.UpdateDetails(Null, Null, False, False, False, False);
        
        SMSConfiguration__c Configuration1=[select id, Service_Appointment_Reminder__c,X24_Hour_Reminder__c, X1_Hour_Reminder__c, Confirmation_Keyword__c,Follow_up_keyword__c,Service_Appointment_Confirmation__c from SMSConfiguration__c Limit 1];
        System.assertEquals(False,Configuration1.Service_Appointment_Reminder__c);
        System.assertEquals(False,Configuration1.X24_Hour_Reminder__c);
        System.assertEquals(False,Configuration1.X1_Hour_Reminder__c);
        System.assertEquals(Null,Configuration1.Confirmation_Keyword__c);
        System.assertEquals(Null,Configuration1.Follow_up_keyword__c);
        System.assertEquals(False,Configuration1.Service_Appointment_Confirmation__c); 
    }
    
    public static testMethod void SendAppointmentTest()
    { 
	    ServiceController.UpdateDetails(Null, Null, True, Null, Null, Null);
        SMSConfiguration__c Configuration=[select id, Service_Appointment_Reminder__c,X24_Hour_Reminder__c, X1_Hour_Reminder__c, Confirmation_Keyword__c,Follow_up_keyword__c,Service_Appointment_Confirmation__c from SMSConfiguration__c Limit 1];
        
        System.assertEquals(true,Configuration.Service_Appointment_Confirmation__c);
        System.assertEquals(False,Configuration.Service_Appointment_Reminder__c);
        System.assertEquals(False,Configuration.X24_Hour_Reminder__c);
        System.assertEquals(False,Configuration.X1_Hour_Reminder__c);
        System.assertEquals(Null,Configuration.Confirmation_Keyword__c);
        System.assertEquals(Null,Configuration.Follow_up_keyword__c);         
    }
    
    public static testMethod void SendRemainderTest()
    { 
        ServiceController.UpdateDetails(Null, Null, Null, Null, Null, True);
        SMSConfiguration__c Configuration=[select id, Service_Appointment_Reminder__c,X24_Hour_Reminder__c, X1_Hour_Reminder__c, Confirmation_Keyword__c,Follow_up_keyword__c,Service_Appointment_Confirmation__c from SMSConfiguration__c Limit 1];
        
        System.assertEquals(True,Configuration.Service_Appointment_Reminder__c);
        System.assertEquals(False,Configuration.X24_Hour_Reminder__c);
        System.assertEquals(False,Configuration.X1_Hour_Reminder__c);         
    }
    
     public static testMethod void SendRemainderTestFalseCheck()
    {
        ServiceController.UpdateDetails(Null, Null, False, True, True, False);
        SMSConfiguration__c Configuration=[select id, Service_Appointment_Reminder__c,X24_Hour_Reminder__c, X1_Hour_Reminder__c, Confirmation_Keyword__c,Follow_up_keyword__c,Service_Appointment_Confirmation__c from SMSConfiguration__c Limit 1];
        
        System.assertEquals(False,Configuration.Service_Appointment_Reminder__c);
        System.assertEquals(False,Configuration.X24_Hour_Reminder__c);
        System.assertEquals(False,Configuration.X1_Hour_Reminder__c);
    }
  
  
}