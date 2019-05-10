@isTest
private class ExamplePreciselyExpressedTest {

    // Changing the literal strings to Constants allows us to describe what these strings represent.
    // It's now obvious that the strings passed into the createTask methods are Task Types
    static final String LI_EXTENDING_TASK_TYPE     = 'Positive Call';
    static final String NON_LI_EXTENDING_TASK_TYPE = 'Left Message';

    // I also like using variables or constants to reduce boilerplate code like calling System methods for dates
    // I find 'TODAY' much easier to read.
    static final Date   TODAY                      = System.today();

    @testSetup
    static void testSetup() {

        ContactDataFactory contactFactory = new ContactDataFactory();
        contactFactory.create( contactFactory.build() );
    }
    
    // Our test method description is now a little more precise, telling us exactly how much the 
    // expiry date will move out by.
    // If this extension was driven by configuration, we would describe that too
    /**
    * @method updateContactsLegitimateExpiryFromTask
    * @case   when a new task of a type that describes a positive conversation with a contact
    * @result Legitimate Interest Expiry date of contact is updated to the activity date plus 18 months
    */
    @isTest
    static void insertOfTaskDescribingAPositiveConversation_againstContact_willExtendContactsLegitimateInterestExpiryDate() {

        Contact originalContact = getContact();

        Test.startTest();
            // As stated above, the use of the constant hopefully makes it very clear what is being created here,
            // being a test with a type that is expected to extended the legitimate interest of the contact.
            createTask( originalContact, LI_EXTENDING_TASK_TYPE );
        Test.stopTest();

        Contact updatedContact = getContact( originalContact.Id );

        // We now use assertEquals, with the expected value first, stating EXACTLY what we expect the resulting value of the
        // expiry date to be.  This means the test is no longer vague - only exactly this behaviour will pass the test, reducing the
        // chances of the functionality creeping away from the intended.
        //
        // We've also improved the text that goes with it to improve the precise understanding.
        System.assertEquals( TODAY.addMonths(18)
                           , updatedContact.Legitimate_Interest_Expiry__c
                           , 'When a task with a type that describes a positive conversation with a contact is created, the Legitimate Interest Expiry date of the contact will be extended' );
    }

    /**
    * @method updateContactsLegitimateExpiryFromTask
    * @case   when a new task of a type that does NOT describe a positive conversation with a contact
    * @result Legitimate Interest Expiry date of contact will not be updated
    */
    @isTest
    static void insertOfTaskNotDescribingAPositiveConversation_againstContact_willNotExtendContactsLegitimateInterestExpiryDate() {

        Contact originalContact = getContact();

        Test.startTest();
            createTask( originalContact, NON_LI_EXTENDING_TASK_TYPE );
        Test.stopTest();

        Contact updatedContact = getContact( originalContact.Id );

        System.assertEquals( originalContact.Legitimate_Interest_Expiry__c
                           , updatedContact.Legitimate_Interest_Expiry__c
                           , 'When a task with a type that does NOT describe a positive conversation with a contact is created, the Legitimate Interest Expiry date of the contact will NOT be extended' );
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
        return ( (Task) taskFactory.create( (Task) taskFactory.build( 'Test Task', contact, TODAY, type ) ) );
    }
}