@isTest
private class ClassThatThrowsAnExceptionTest {

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