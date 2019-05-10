@isTest
private class ExampleMoreExpressiveTest {

    @testSetup
    static void testSetup() {
        Contact contact = new Contact();
        contact.LastName = 'Contact';
        contact.Requires_P125_Completed__c = false;
        contact.Last_Revenue_Expected__c = System.now();
        insert contact;
    }
    
    @isTest
    static void test_LiDateUpdates() {

        // Changing the name of a few variables helps to express what the variables represent in the test
        // By calling this the 'originalContact' we know in the rest of the test that we are referring
        // to the state that the contact was in at the start of the test.
        //
        Contact originalContact = new Contact();
        originalContact.LastName = 'Contact';
        originalContact.Requires_P125_Completed__c = false;
        originalContact.Last_Revenue_Expected__c = System.now();
        insert originalContact;

        // Re-using the variable is fine - this is still the 'original' contact, as far as the test is concerned
        // It tells us that the state the contact is in, *once it has been inserted*, is the starting point
        // for our test case.
        //
        originalContact = [SELECT Legitimate_Interest_Expiry__c FROM Contact ORDER BY Id LIMIT 1];

        // This still isn't *that* expressive, but the use of 'startTest' here is at least telling us
        // that we've finished setting up the test, and now we're into the test itself.
        // Other practices will improve the expressive nature of the test in later iterations.
        Test.startTest();
        
            // We are now creating the TaskDataFactory near where we first use it
            // OK, we don't have a great name for it, but maybe we have standards for the factory variable names
            // in tests, so that the factories don't get in the way of reading the test itself
            TaskDataFactory tdf = new TaskDataFactory();

            // By naming the task that we are creating, and giving it a more meaningful text, we're expressing what
            // we expect this task to do before we perform any of the test itself.
            // It's now clear that this task should not extend the legitimate interest expiry date.
            Task nonLiExtendingTask = tdf.build( 'Not a Legitimate Interest Extending Task', originalContact, Date.today(), 'Left Message' );
            tdf.create( nonLiExtendingTask );
            
            // We can also see that we expect the contact to be updated, and that *this* variable is the
            // one that contains the updated version of it.  We can also see how it relates to the original one more clearly.
            Contact updatedContact = [SELECT Legitimate_Interest_Expiry__c FROM Contact WHERE Id = :originalContact.Id];
    
            // We've added text to the assertion to explain what the assertion is saying in plain english.  Hopefully, when this
            // fails in the future we'll have more of an immediate understanding of what has gone wrong.
            System.assert( updatedContact.Legitimate_Interest_Expiry__c == null, 'Adding a task that does not extend Legitimate Interest, will not update the Legitimate Interest Expiry on the contact' );
            
            Task liExtendingTask = tdf.build( 'Legitimate Interest Extending Task', originalContact, Date.today(), 'Positive Call' );
            tdf.create( liExtendingTask );
            
            updatedContact = [SELECT Legitimate_Interest_Expiry__c FROM Contact WHERE Id = :originalContact.Id];
            
            System.assert( updatedContact.Legitimate_Interest_Expiry__c != null, 'Adding a task that does extend Legitimate Interest, will update the Legitimate Interest Expiry on the contact' );

        Test.stopTest();
    }
}