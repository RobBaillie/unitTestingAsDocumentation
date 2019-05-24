@isTest
private class ExamplePreciselyExpressedTest {

    // Note: an annotated version of this test exists, describing some of the changes made:
    //          1-2-ExamplePreciselyExpressedTest-Annotated.cls
    
    static final String LI_EXTENDING_TASK_TYPE     = 'Positive Call';
    static final String NON_LI_EXTENDING_TASK_TYPE = 'Left Message';
    static final Date   TODAY                      = System.today();

    @testSetup
    static void testSetup() {

        ContactDataFactory contactFactory = new ContactDataFactory();
        contactFactory.create( contactFactory.build() );
    }
    
    /**
    * @method updateContactsLegitimateExpiryFromTask
    * @case   when a new task of a type that describes a positive conversation with a contact
    * @result Legitimate Interest Expiry date of contact is updated to the activity date plus 18 months
    */
    @isTest
    static void insertOfTaskDescribingAPositiveConversation_againstAContact_willExtendContactsLegitimateInterestExpiryDate() {

        Contact originalContact = getContact();

        Test.startTest();
            createTask( originalContact, LI_EXTENDING_TASK_TYPE );
        Test.stopTest();

        Contact updatedContact = getContact( originalContact.Id );

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
    static void insertOfTaskNotDescribingAPositiveConversation_againstAContact_willNotExtendContactsLegitimateInterestExpiryDate() {

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