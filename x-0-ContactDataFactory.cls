/**
* An example implementation of a Data Factory
*
* Fully expect this implementation to be superceded in a project, probably with
* multiple overloaded 'build' methods that create Accounts in different shapes.
*
* For more examples in the documentation, see AccountDataFactory
*
* @date    2018-06-21
* @author  makepositive
*/
@isTest
public with sharing class ContactDataFactory extends DataFactory {
	
	public ContactDataFactory() {
        super( 'Contact' );
    }

    public SObject buildDefault() {
        return build();
    }
    
    /**
     * Every data factory should have an implementation of build that takes no parameters and
     * returns an object of the right type that *could* be inserted into the database with no
     * validation errors.
     * 
     * For objects that have "required" relationships to other objects, you should use the 
     * method 'getDefaultInstance' against the related object's factory in order to get a 
     * generic version of that object.
     * This is particularly useful when the related object is entirely incidental to the test.
     * 
     * The build method can be overridden to allow for the capability to set the relationships
     * to specific objects when they are important to the tests. 
     * 
     * @date    2018-06-21
     * @author  makepositive
     */
    public Contact build() {
		AccountDataFactory adf = new AccountDataFactory();
    	return build( (Account)adf.getDefaultInstance() );
    }

    public Contact build( Account acc ) {
    	Contact con = new Contact(
    	   LastName  = 'My test contact',
    	   AccountId = (acc != null) ? acc.Id : null
    	);    	
    	return con;
    }
}