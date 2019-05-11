# unitTestingAsDocumentation

The files in this repo forms part of the Unit Testing as Documentation presentations.

Some files may have been used in the presentation directly, some are included as supporting examples in case some questions arise that merit their use - or for later examination.

As these files don't form part of a complete Salesforce repository, they do not necesserily compile in a sandbox without work to make them compatible with the objects in that sandbox.

The files are free to be used as guides and aids in learning, but are not to be used directly in production systems.  They come with no warranty or support.

Comments are welcomed.

## 1-n Files

The 1-n files are intended to be read in order, ideally the unannotated versions first.

[1-0-ExampleHardToReadTest.cls](1-0-ExampleHardToReadTest.cls)

A starting point for looking at how a test's readability can be improved.

The annotated version ([1-0-ExampleHardToReadTest-Annotated.cls](1-0-ExampleHardToReadTest-Annotated.cls)) includes comments on the issues.

[1-1-ExampleMoreExpressiveTest.cls](1-1-ExampleMoreExpressiveTest.cls)

A functionally identical version of the first test, with improvements to make the test more expressive.

The annotated version ([1-1-ExampleMoreExpressiveTest-Annotated.cls](1-1-ExampleMoreExpressiveTest-Annotated.cls)) includes comments describing the changes made.

[1-2-ExampleConciselyExpressedTest.cls](1-2-ExampleConciselyExpressedTest.cls)

A second round of improvements to the test, making the test code more concise.

The annotated version ([1-2-ExampleConciselyExpressedTest-Annotated.cls](1-2-ExampleConciselyExpressedTest-Annotated.cls)) includes comments describing the changes made.


[1-3-ExamplePreciselyExpressedTest.cls](1-3-ExamplePreciselyExpressedTest.cls)

The final version of the improving test, making it more precisely define the test cases.

The annotated version ([1-3-ExamplePreciselyExpressedTest-Annotated.cls](1-3-ExamplePreciselyExpressedTest-Annotated.cls)) includes comments describing the changes made.

## 2-n Files

These are examples of how a test can be 'not a test', that is:

[2-0-ClassThatThrowsAnException.cls](2-0-ClassThatThrowsAnException.cls)

Is a simple class that has a method that throws an exception.  This is the class that is under test.

[2-1-ClassThatThrowsAnExceptionTest.cls](2-1-ClassThatThrowsAnExceptionTest.cls)

A test class that only *looks* like a test case.  In reality, the test can never fail.  This illustrates the point that it's important to make sure your tests can fail before you rely on them.

[2-2-ClassThatThrowsAnExceptionBetterTest.cls](2-2-ClassThatThrowsAnExceptionBetterTest.cls)

A better version of the test class that *can* fail.

## 3-n Files

Examples of how sometimes you need to test when things *don't* happen, an illustration of why "100% code complete" does not mean "100% tested".

[3-0-ClassThatDoesThings.cls](3-0-ClassThatDoesThings.cls)

The class under test, which performs an action under a particular circumstance.

[3-1-ClassThatDoesThingsTest.cls](3-1-ClassThatDoesThingsTest.cls)

A test that meets 100% code coverage of the class under test - but which only checks the situation where the method being tested *does* something, but never checks the situation where the class *doesn't* do something.

[3-2-ClassThatDoesThingsTest2.cls](3-2-ClassThatDoesThingsTest2.cls)

Contains an additional test method that proves the method under test skips the functionality in a certain circumstance.

## x-0 Files

Examples of a set of simple data factories, showing how you might simplify the creation of objects in your test methods.

As stated at the top of the file - these are examples, and really shouldn't be used as-is.  Read them, understand them, and implement your own versions that fulfil your needs.




