public class ClassThatThrowsAnException extends Exception {

    class CustomException extends Exception{}
    
    public void throwException( String message ) {
		throw new CustomException( message );
    }
}