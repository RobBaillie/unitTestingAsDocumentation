public class ClassThatDoesThings {

    /*
    * This method will update the first name of the contact, only if the name
    * contains the string 'Test'
    *
    * Code coverage would guide us to only test when this method performs
    * the update, and not guide us to test when the name DOES NOT contain
    * the string 'Test'.
    *
    * But that IF statement is there for a reason...
    *
    */
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