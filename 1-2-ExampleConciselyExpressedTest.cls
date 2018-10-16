@isTest
private class ExampleConciselyExpressedTest {

    @testSetup
    static void testSetup() {

        ContactDataFactory contactFactory = new ContactDataFactory();
        contactFactory.create( contactFactory.build() );
    }
    
    /**
    * @method updateContactsLegitimateExpiryFromTask
    * @case   when a new task is created for a contact
    * @result Legitimate Interest Expiry date of contact will be updated
    */
    @isTest
    static void updateContactLegitimateExpiryFromTask_AfterInsertOfTask_ForContact_LiDateWillBeUpdated() {

        List<Contact> originalContacts = getContacts();

        Test.startTest();
            createTask( originalContacts[0], 'Gold Note' );
        Test.stopTest();

        Contact updatedContact = getContact( originalContacts[0].Id );

        System.assert( updatedContact.Legitimate_Interest_Expiry__c != null
                     , 'Legitimate Interest Expiry date of contact will be updated' );
    }

    /**
    * @method updateContactsLegitimateExpiryFromTask
    * @case   when a new task is created for a contact
    * @result Legitimate Interest Expiry date of contact will not be updated
    */
    @isTest
    static void updateContactLegitimateExpiryFromTask_AfterInsertOfTaskForLeftNote_ForContact_LiDateWillBeUpdated() {

        List<Contact> originalContacts = getContacts();

        Test.startTest();
            createTask( originalContacts[0], 'Left Note' );
        Test.stopTest();

        Contact updatedContact = getContact( originalContacts[0].Id );

        System.assert( updatedContact.Legitimate_Interest_Expiry__c == null
                     , 'Legitimate Interest Expiry date of contact will not be updated' );
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
        return ( (Task) taskFactory.create( (Task) taskFactory.build( 'Test Task', contact, Date.today(), type ) ) );
    }
}