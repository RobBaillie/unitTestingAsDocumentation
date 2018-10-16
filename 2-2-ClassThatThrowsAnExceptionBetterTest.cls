@isTest
private class ClassThatThrowsAnExceptionBetterTest {

    @isTest
    private static void test_throwException_whenPassedAMessage_throwsAnExceptionWithThatMessage() {

        String messagePassed = 'This is the message';

        ClassThatThrowsAnException exceptionThrower = new ClassThatThrowsAnException();
        
        Boolean exceptionThrown = false;
        String  exceptionMessage;
                
        try {
            
            Test.startTest();
	            exceptionThrower.throwException( messagePassed );
            Test.stopTest();
            
        } catch( Exception e ) {
            exceptionThrown  = true;
            exceptionMessage = e.getMessage();
        }

        System.assert( exceptionThrown, 'throwException, when passed a message, throws an exception' );
        System.assertEquals( messagePassed, exceptionMessage, 'throwException, when passed a message, throws an exception with that message' );

    }
}