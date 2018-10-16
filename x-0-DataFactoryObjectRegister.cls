/**
* A singleton that is used to keep track of the 'default' objects that have been
* created by factories.
*
* This allows DataFactory to ensure that only one of each type is ever created, limiting
* DML and reducing the chances of duplicate rules causing difficulties in test setup.
*
* @date    2018-06-21
* @author  makepositive
*/
@isTest
public class DataFactoryObjectRegister {
    
    public class DataFactoryObjectRegisterException extends Exception{}

    /**
    * Instance of itself, being the singleton that is always referenced
    *
    * @date    2018-06-21
    * @author  makepositive
    */
    private static DataFactoryObjectRegister instance;

    /**
    * The registry of objects
    *
    * @date    2018-06-21
    * @author  makepositive
    */
    private Map<String,SObject>              register = new Map<String,SObject>();
    
    /**
    * The singleton 'constructor'.  Should be used instead of calling the constructor.
    * 
    * Use by calling statically:
    * 	DataFactoryObjectRegister register = DataFactoryObjectRegister.getInstance();
    *
    * @date    2018-06-21
    * @author  makepositive
    */
    public static DataFactoryObjectRegister getInstance() {
        if ( instance == null ) {
            instance = new DataFactoryObjectRegister();
        }
        return instance;
    }
    
    /**
    * Private constructor should not be called.
    * Instead use 'getInstance'
    *
    * @date    2018-06-21
    * @author  makepositive
    */
    private DataFactoryObjectRegister() {}
    
    /**
     * States if the registry contains an entry with the given objectType key
     * 
     * @date    2017-07-06
     * @author  makepositive
     * @param   String - The key to look for
     * @return  Boolean - States if the key exists in the registry
     */
    public Boolean containsKey( String objectType ) {
		return register.containsKey( objectType );        
    }
    
     /**
     * Returns the object in the registry with the given key
     * 
     * @date    2017-07-06
     * @author  makepositive
     * @param   String - The key to look for
     * @return  SObject - The object at that key
     */   
    public SObject get( String objectType ) {
        return register.get( objectType );
    }
    
     /**
     * Puts the given object into the registry at the given key
     * 
     * @date    2017-07-06
     * @author  makepositive
     * @param   String - The key to create the entry at
     * @param   SObject - The object to store
     */ 
    public void put( String objectType, SObject objectToStore ) {
        register.put( objectType, objectToStore );
    }
}