@isTest
private class ClassTheDoesThingsTest2 {

    /*
    *
    * This is the aditional test that thinking about more than just code coverage could have us build
    *
    */

    @isTest
    private static void test_updateContactsSometimes_whenItDoesNotUpdate() {

        ContactDataFactory contactFactory = new ContactDataFactory();
        Contact contact = contactFactory.build();
        contact.FirstName = 'Real';
        contactFactory.create( contact );
        
		List<Contact> contacts = [ SELECT Id, Name, FirstName FROM Contact];
        ClassTheDoesThings.updateContactsSometimes( contacts );
        
		List<Contact> updatedContacts = [ SELECT Id, Name, FirstName FROM Contact];
		
		System.assertEquals( 'Real', updatedContacts[0].FirstName );
    }        
    
}