/**
* An example implementation of a Data Factory
*
* Fully expect this implementation to be superceded in a project, probably with
* multiple overloaded 'build' methods that create Accounts in different shapes
*
* @date    2018-06-21
* @author  makepositive
*/
@isTest
public with sharing class AccountDataFactory extends DataFactory {
    
    /**
     * A parameter-free constructor should be present in every DataFactory, setting the
     * key used to identify the object type in the DataFactoryObjectRegister
     * 
     * @date    2018-06-21
     * @author  makepositive
     */
    public AccountDataFactory() {
        super( 'Account' );
    }

    /**
     * This method should be replicated in every data factory class, with exactly this code.
     * 
     * It needs to be done this way so that all the other build methods can be declared with 
     * the concrete object's class as the return type.
     * 
     * @date    2018-06-21
     * @author  makepositive
     */
    public SObject buildDefault() {
        return build();
    }
    
    /**
     * Every data factory should have an implementation of build that takes no parameters and
     * returns an object of the right type that *could* be inserted into the database with no
     * validation errors.
     * 
     * @date    2018-06-21
     * @author  makepositive
     */
    public Account build() {
        return build( 'My test account' );
    }
    
    /**
     * It is reasonable to add further overloaded build methods with different parameter lists
     * in order to allow for the simple creation of common shapes of object.
     * 
     * An obvious example is a version that sets the name on the object.
     * 
     * Care should be taken not to create too many of these methods, as more uncommon variations
     * will not get re-used and will hide the common and useful versions.
     * Often it is clearer to set the data directly in the tests.
     * 
     * @date    2018-06-21
     * @author  makepositive
     */
    public Account build( String name ) {
        Account acc = new Account(
            Name        = name,
            Description = 'My test account description'
        );        
        return acc; 
    }
}