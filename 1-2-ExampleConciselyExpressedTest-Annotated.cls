@isTest
private class ExampleConciselyExpressedTest {

    @testSetup
    static void testSetup() {

        // Now we're using factories across the board.  We hide the immaterial mandatory fields, that have no effect
        // on this test behind the default 'build' method on the factory.
        // This tells us that there is *nothing* special about the contact for this test.  This test would
        // presumably work on any contact.  Their state at the start is not important.
        ContactDataFactory contactFactory = new ContactDataFactory();
        contactFactory.create( contactFactory.build() );
    }
    
    // We've also split the test cases into their own methods and added descriptions of the test cases.
    // We use a JavaDoc style comment because we *may* want to extract this and generate real documentation from it.
    // If we word things consistently and clearly, we certainly *could*
    //
    // Importantly, each method only tests for one thing.  And because of that, each test is much clearer and easier to read.
    /**
    * @method updateContactsLegitimateExpiryFromTask
    * @case   when a new task is created for a contact
    * @result Legitimate Interest Expiry date of contact will be updated
    */
    @isTest
    static void insertOfTaskDescribingAPositiveConversation_againstContact_willExtendContactsLegitimateInterestExpiryDate() {

        // We've pushed the SOQL to get a contact into a method - the SOQL was OK to read, but this is much easier.
        Contact originalContact = getContact();

        // Because we have only one test case in this method, the startTest and stopTest can now be around the
        // creation of the task  that is the thing actually under test.
        //
        // We've also pushed the creation into a method so we can see which bit of the task was important
        // It's still not clear what 'Positive Call' actually is, but we now know the rest of the fields were not important
        Test.startTest();
            createTask( originalContact, 'Positive Call' );
        Test.stopTest();

        // Again, the use of a helper method makes the retrieval of the data to check much clearer.
        Contact updatedContact = getContact( originalContact.Id );

        System.assert( updatedContact.Legitimate_Interest_Expiry__c != null
                     , 'Legitimate Interest Expiry date of contact will be updated' );
    }

    /**
    * @method updateContactsLegitimateExpiryFromTask
    * @case   when a new task is created for a contact
    * @result Legitimate Interest Expiry date of contact will not be updated
    */
    @isTest
    static void insertOfTaskNotDescribingAPositiveConversation_againstContact_willNotExtendContactsLegitimateInterestExpiryDate() {

        Contact originalContact = getContact();

        Test.startTest();
            createTask( originalContact, 'Left Message' );
        Test.stopTest();

        Contact updatedContact = getContact( originalContact.Id );

        System.assert( updatedContact.Legitimate_Interest_Expiry__c == null
                     , 'Legitimate Interest Expiry date of contact will not be updated' );
    }
    
    /**
    * Helper function to get one of the available contacts
    */ 
    private static Contact getContact() {
        return [ SELECT Legitimate_Interest_Expiry__c
                 FROM   Contact
                 ORDER BY Id
                 LIMIT 1 ];
    }

    /**
    * Helper function to get a particular contact
    */ 
    private static Contact getContact( Id contactId ) {
        return [ SELECT Legitimate_Interest_Expiry__c
                 FROM   Contact
                 WHERE  Id = :contactId ];
    }

    /**
    * Helper function to create task for contact passed.
    */
    private static Task createTask( Contact contact, String type  ) {
        TaskDataFactory taskFactory = new TaskDataFactory();
        return ( (Task) taskFactory.create( (Task) taskFactory.build( 'Test Task', contact, Date.today(), type ) ) );
    }
}