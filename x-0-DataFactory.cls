/**
* The base factory from which all data factories should extend
* 
* Provides base capabilities for creating default objects (for building relationships)
* and inserting data (with clear exceptions thrown)
* 
* Any sub-class should implement as least:
*   A constructor that takes no parameters
*   A buildDefault method that returns an SObject of the relevent type that can be inserted
*   A build method that returns the same as buildDefault, but who's return type is the concrete class
*       (E.g. Account, instead of SObject)
*	Further build methods that return the concrete class, and allowing relationships to be explicitly defined
*
* @date    2018-06-21
* @author  makepositive
*/
public abstract class DataFactory {
    
    class DataFactoryException extends Exception{}

	public String objectType;
    
    /**
     * Main constructor that all sub-classes should call, passing the objectType
     * to use when registering the default object in the register.
     * 
     * Uses a string, rather than an SObjectType, so that alternatives for a given type
     * can be created (e.g. when using PersonAccounts, this enables you to have a factory
     * for the person account, even though it's an Account <-> Contact behind the scenes)
     * 
     * @date    2018-06-21
     * @author  makepositive
     * @param   String - The type of object this factory is for
     */
    public DataFactory( String objectType ) {
        this.objectType = objectType;        
	}
    
    /**
     * To be overridden in every sub-class.
     * 
     * Should provide a 'default' version of the object with all its mandatory fields
     * populated.
     * 
     * Generally, should called the Object specific version named 'build'
     * E.g.
     * 
     *     public SObject buildDefault() {
     *       return build();
     *     }
     * 
     *     public Account build() {
     *       return build( 'My test account' );
     *     }
     * 
     * @date    2018-06-21
     * @author  makepositive
     * @return  SObject - The object that was built
     */
    abstract SObject buildDefault();

     /**
     * Provides an 'default' version of the factory's object, ensuring that only
     * one of such an instance is ever created.
     * 
     * Useful for building an object with multiple relationships when you do not care
     * about the related thing.
     * 
     * E.g.
     * 		You need a Contact to test with, but you do not care about the shape of the Account.
     * 
     * Generally used by build methods of other factories, and not called directly in tests
     * 
     * @date    2018-06-21
     * @author  makepositive
     * @return  SObject - The default object of the given type
     */
	public SObject getDefaultInstance() {
        
        DataFactoryObjectRegister objectRegister = DataFactoryObjectRegister.getInstance();
        
		if ( ! objectRegister.containsKey( objectType ) ) {
			objectRegister.put( objectType, create( buildDefault() ) );
		}
		return objectRegister.get( objectType );
	}
    
     /**
     * Inserts the given object, ensuring that any exceptions thrown clearly state
     * that the exception was during data setup
     * 
     * @date    2018-06-21
     * @author  makepositive
     * @param   SObject - The object to insert
     */
    public SObject create( SObject objectToCreate ) {

        try {
            insert objectToCreate;
        } catch ( Exception e ) {
            throw new DataFactoryException( 'Exception thrown during data setup (' + this.objectType + ')' + e.getMessage() );
        }
        return objectToCreate;
    }
}