
@isTest
private class ExampleHardToReadTest {

    // Note: an annotated version of this test exists, describing some of the issues with it:
    //          1-0-ExampleHardToReadTest-Annotated.cls

    @testSetup
    static void testSetup() {
        Contact c = new Contact();
        c.LastName = 'Contact';
        c.Requires_P125_Completed__c = false;
        c.Last_Revenue_Expected__c = System.now();
        insert c;
    }    
    
    @isTest
    static void test_LiDateUpdates() {

        TaskDataFactory tdf = new TaskDataFactory();
        
        Date liDate = Date.today().addMonths( 18 );
        
        Contact c = new Contact();
        c.LastName = 'Contact';
        c.Requires_P125_Completed__c = false;
        c.Last_Revenue_Expected__c = System.now();
        insert c;

        c = [SELECT Legitimate_Interest_Expiry__c FROM Contact LIMIT 1];

        Task t = tdf.build( 'Test Task 1', c, Date.today(), 'Left Message' );
        tdf.create(t);
        
        Contact c2 = [SELECT Legitimate_Interest_Expiry__c FROM Contact WHERE Id = :c.Id];

        System.assert( c2.Legitimate_Interest_Expiry__c == null );
        
        Task t2 = tdf.build( 'Test Task 2', c, Date.today(), 'Positive Call' );
        tdf.create(t2);
        
        Contact c3 = [SELECT Legitimate_Interest_Expiry__c FROM Contact WHERE Id = :c.Id];
        
        System.assert( c3.Legitimate_Interest_Expiry__c != null );
    }    
}