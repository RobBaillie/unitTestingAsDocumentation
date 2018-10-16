public class ClassTheDoesThings {

    public static void updateContactsSometimes( List<Contact> contacts ) {
        
        List<Contact> contactsToUpdate = new List<Contact>();

        for( Contact thisContact : contacts ) {
            if ( thisContact.Name.contains( 'Test' ) ) {
                thisContact.FirstName = thisContact.FirstName + ' Yes';
            }
            contactsToUpdate.add( thisContact );
        }

		update contactsToUpdate;
    }
}