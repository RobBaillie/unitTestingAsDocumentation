@isTest
public class AccountNeedDataFactory extends DataFactory{
    
    public AccountNeedDataFactory() {
        super( 'AccountNeed' );
    }

    public SObject buildDefault() {
        return build();
    }
    
    public Account_Need__c build() {
        
        AccountDataFactory factory     = new AccountDataFactory();
        Account            thisAccount = (Account)factory.getDefaultInstance();
        
        return build( thisAccount, 'A default Need' );
    }

    public Account_Need__c build( Account account, String needName ) {
        return new Account_Need__c( Account__c = account.Id, Name = needName );
    }

    public Account_Need__c build( Account account, String needName, String needLevel ) {
        return new Account_Need__c( Account__c = account.Id, Name = needName, Need_Level__c = needLevel );
    }
}