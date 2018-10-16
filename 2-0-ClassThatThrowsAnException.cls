public class ClassThatThrowsAnException extends Exception {

    class CustomException extends Exception{}

    /**
    *
    * This method throws an exception, it's all it does.
    * It's not useful, but what are you going to do - it exists.
    *
    */
    public void throwException( String message ) {
		throw new CustomException( message );
    }
}