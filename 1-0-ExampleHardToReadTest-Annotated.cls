@isTest
private class ExampleHardToReadTest {

    // This test might be useful, from the point of checking that the behaviour does what it should.  But it's not clear what's being
    // tested and why.  So, when this test fails (and one day it will), it will be hard for the developer that made it fail to work out
    // what went wrong, and what they should do to fix it.
    // Not only that, but it's a little vague, and because it's vague we may find that it continues to pass when it *should* fail, or
    // that when it does fail, it's possible to get it to pass again by putting back the wrong functionality.
    //
    // This annotated version points out some of the things that are less than perfect, so that we can see it evolve as better
    // practices are applied to it.

    @testSetup
    static void testSetup() {

        // testSetup is very useful for creating data that is used in lots of tests, but only if you use the data
        // in this case we are setting up a contact in the setup, and then we're creating another one in the test itself
        // One or the other can be removed with no effect.
        
        Contact c = new Contact();
        c.LastName = 'Contact';
        c.Requires_P125_Completed__c = false;           // These fields are immaterial to the test but presumably need to be
        c.Last_Revenue_Expected__c = System.now();      // setup in order for the contact to be created.  DataFactories are a great way
                                                        // of hiding this kind of detail from your tests, as well as reducing the maintenance
                                                        // cost when a new mandatory field is created.
        insert c;
    }    
    
    @isTest
    static void test_LiDateUpdates() {                  // The test method doesn't need 'test' in the name - the @isTest annotation tells is this is a test.

        TaskDataFactory tdf = new TaskDataFactory();    // This factory is created, but where is it used?  Generally it's a good idea to put variable
                                                        // declarations near where they are used.
        
        Date liDate = Date.today().addMonths( 18 );     // It looks like this might be important, but it isn't actually used anywhere.
        
        Contact c = new Contact();                      // As with the @testSetup method, there's a lot of noise in here because we haven't used a factory.
        c.LastName = 'Contact';                         // And the question needs to be asked, why is this here anyway?
        c.Requires_P125_Completed__c = false;           // Could we not have used the contact that was inserted in the setup method?
        c.Last_Revenue_Expected__c = System.now();
        insert c;

        c = [SELECT Legitimate_Interest_Expiry__c FROM Contact LIMIT 1];                    // This SOQL isn't too bad to read, but what if we needed 10 columns.
                                                                                            // It doesn't need to be here, it could be in a helper method.
                                                                                            // And why not give the variable a better name that descibes what it is for?

        Task t = tdf.build( 'Test Task 1', c, Date.today(), 'Left Message' );               // The use of a DataFactory is commendable, but this doesn't tell us what it is
                                                                                            // about the Task we're creating that is important to this test.
        tdf.create(t);
        
        Contact c2 = [SELECT Legitimate_Interest_Expiry__c FROM Contact WHERE Id = :c.Id];  // Again, the SOQL isn't that bad, but it would be simpler to read if the SOQL wasn't here
                                                                                            // And what is the contact used for?  "c2" tells us nothing about why it's here.

        System.assert( c2.Legitimate_Interest_Expiry__c == null );                          // At this point we must have done the thing we're testing, but it's not clear
                                                                                            // what from the above was actually under test.
        
        Task t2 = tdf.build( 'Test Task 2', c, Date.today(), 'Positive Call' );             // The standard Unit Test pattern is to test one thing per method.
                                                                                            // Since we're doing something after an assert, it's becoming clear that
                                                                                            // we're testing two things in here.
        tdf.create(t2);
        
        Contact c3 = [SELECT Legitimate_Interest_Expiry__c FROM Contact WHERE Id = :c.Id];  // This SOQL is repeated from the lines above.  Another argument for putting
                                                                                            // it into a helper method.
        
        System.assert( c3.Legitimate_Interest_Expiry__c != null );                          // OK, the Legitimate Interest Expiry has been updated, but what to?
                                                                                            // Unless we only care that it's not null, we should test what it actually is.
                                                                                            // We also don't really know *why* it has changed.
    }    
}