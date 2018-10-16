@isTest
private class ExampleHardToReadTest {

    @testSetup
    static void testSetup() {

        ContactDataFactory contactFactory = new ContactDataFactory();
        contactFactory.create( contactFactory.build() );
    }    
    
    @isTest
    static void updateContactLegitimateExpiryFromTask_updatesTheLIDate() {

        TaskDataFactory tdf = new TaskDataFactory();
        
        Date liDate = Date.today().addMonths( 18 );
        
        ContactDataFactory cdf = new ContactDataFactory();
        Contact c = cdf.build();
        cdf.create(c);
        c = [SELECT Legitimate_Interest_Expiry__c FROM Contact LIMIT 1];

        Task t = tdf.build( 'Test Task 1', c, Date.today(), 'Left Note' );
		tdf.create(t);
        
        Contact c2 = [SELECT Legitimate_Interest_Expiry__c FROM Contact WHERE Id = :c.Id];

        System.assert( c2.Legitimate_Interest_Expiry__c == null );
        
        Task t2 = tdf.build( 'Test Task 2', c, Date.today(), 'Gold Note' );
		tdf.create(t2);
        
        Contact c3 = [SELECT Legitimate_Interest_Expiry__c FROM Contact WHERE Id = :c.Id];
        
        System.assert( c3.Legitimate_Interest_Expiry__c != null );
    }    
}