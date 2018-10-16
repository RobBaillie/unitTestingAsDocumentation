@isTest
private class ClassTheDoesThingsTest {

    @isTest
    private static void test_updateContactsSometimes() {

        ContactDataFactory contactFactory = new ContactDataFactory();
        Contact contact = contactFactory.build();
        contact.FirstName = 'Test';
        contactFactory.create( contact );
        
		List<Contact> contacts = [ SELECT Id, Name, FirstName FROM Contact];
        ClassTheDoesThings.updateContactsSometimes( contacts );
        
		List<Contact> updatedContacts = [ SELECT Id, Name, FirstName FROM Contact];
		
		System.assertEquals( 'Test Yes', updatedContacts[0].FirstName );
    }    
}