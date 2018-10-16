@isTest
private class ClassThatThrowsAnExceptionTest {

    /**
    *
    * A classic example of a test that cannot fail.
    *
    * At first glance it looks like this test will prove that an exception is thrown,
    * but it doesn't.  It *assumes* that an exception is thrown and will only fail if the 
    * wrong exception is thrown.
    *
    * If the method does not throw an exception, the assertion never runs, and for some reason
    * Salesforce allows a test case without any assertions to pass.
    *
    */
    @isTest
    private static void test_throwException_whenPassedAMessage_throwsAnExceptionWithThatMessage() {

        String messagePassed = 'This is the message';

        ClassThatThrowsAnException exceptionThrower = new ClassThatThrowsAnException();
        
        try {
            
            Test.startTest();
	            exceptionThrower.throwException( messagePassed );
            Test.stopTest();

        } catch( Exception e ) {
            System.assertEquals( messagePassed, e.getMessage(), 'throwException, when passed a message, throws an exception with that message' );
        }
    }
}