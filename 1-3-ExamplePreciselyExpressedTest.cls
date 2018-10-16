@isTest
private class ExamplePreciselyExpressedTest {

    static final String LI_EXTENDING_TASK_TYPE     = 'Gold Note';
    static final String NON_LI_EXTENDING_TASK_TYPE = 'Left Message';
    static final Date   TODAY                      = System.today();
    static final Date   NEXT_WEEK                  = System.today().addDays( 7 );

    @testSetup
    static void testSetup() {

        ContactDataFactory contactFactory = new ContactDataFactory();
        contactFactory.create( contactFactory.build() );
    }
    
    /**
    * @method updateContactsLegitimateExpiryFromTask
    * @case   when a new task of a type appropriate for legitimate exipiry is created for a contact
    * @result Legitimate Interest Expiry date of contact will be updated to the activity date plus 18 months
    */
    @isTest
    static void updateContactLegitimateExpiryFromTask_AfterInsertOfLiRelatedTask_ForContact_LiDateWillBeUpdateToLastActivityPlus18Months() {

        List<Contact> originalContacts = getContacts();

        Test.startTest();
            createTask( originalContacts[0], LI_EXTENDING_TASK_TYPE );
        Test.stopTest();

        Contact updatedContact = getContact( originalContacts[0].Id );

        System.assertEquals( TODAY.addMonths(18)
                           , updatedContact.Legitimate_Interest_Expiry__c
                           , 'When a task with a type related to Legitimate expiry is created, the Legitimate Interest Expiry date of the contact will be updated to the created date of the last LI relevant task against the contact plus 18 months' );
    }

    /**
    * @method updateContactsLegitimateExpiryFromTask
    * @case   when a new task of a type not appropriate for legitimate exipiry is created for a contact
    * @result Legitimate Interest Expiry date of contact will not be updated
    */
    @isTest
    static void updateContactLegitimateExpiryFromTask_AfterInsertOfNonLiRelatedTask_ForContact_LiDateWillNotBeUpdated() {

        List<Contact> originalContacts = getContacts();

        Test.startTest();
            createTask( originalContacts[0], NON_LI_EXTENDING_TASK_TYPE );
        Test.stopTest();

        Contact updatedContact = getContact( originalContacts[0].Id );

        System.assertEquals( originalContacts[0].Legitimate_Interest_Expiry__c
                           , updatedContact.Legitimate_Interest_Expiry__c
                           , 'When a task with a type not related to Legitimate expiry is created, the Legitimate Interest Expiry date of the contact will not be updated' );
    }
    
    /**
    * Helper function to get the all the available contacts
    */ 
    private static List<Contact> getContacts() {
        return [ SELECT Legitimate_Interest_Expiry__c
                 FROM   Contact ];
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