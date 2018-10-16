@isTest
private class ExampleMoreExpressiveTest {

    @testSetup
    static void testSetup() {

        ContactDataFactory contactFactory = new ContactDataFactory();
        contactFactory.create( contactFactory.build() );
    }
    
    @isTest
    static void updateContactLegitimateExpiryFromTask_updatesTheLIDate() {

        ContactDataFactory cdf = new ContactDataFactory();
        Contact originalContact = cdf.build();
        cdf.create( originalContact );
        originalContact = [SELECT Legitimate_Interest_Expiry__c FROM Contact LIMIT 1];

        Test.startTest();
        
            TaskDataFactory tdf = new TaskDataFactory();
            Task nonLiExtendingTask = tdf.build( 'Not a Legitimate Interest Extending Task', originalContact, Date.today(), 'Left Note' );
            tdf.create( nonLiExtendingTask );
            
            Contact updatedContact = [SELECT Legitimate_Interest_Expiry__c FROM Contact WHERE Id = :originalContact.Id];
    
            System.assert( updatedContact.Legitimate_Interest_Expiry__c == null, 'Adding a task that does not extend Legitimate Interest, will not update the Legitimate Interest Expiry on the contact' );
            
            Task liExtendingTask = tdf.build( 'Legitimate Interest Extending Task', originalContact, Date.today(), 'Gold Note' );
            tdf.create( liExtendingTask );
            
            updatedContact = [SELECT Legitimate_Interest_Expiry__c FROM Contact WHERE Id = :originalContact.Id];
            
            System.assert( updatedContact.Legitimate_Interest_Expiry__c != null, 'Adding a task that does extend Legitimate Interest, will update the Legitimate Interest Expiry on the contact' );

        Test.stopTest();
    }
}