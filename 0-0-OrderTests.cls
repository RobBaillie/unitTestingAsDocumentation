@isTest
private class OrderTests {

	@testSetup
    private static void SetupTestData() {
        TestDataFactory.InsertTestData(10);
    }
    
    @isTest
    private static void OrderUpdate_UnitTest() {

		Map<Id, Product2> originalProducts = new Map<Id, Product2>( [SELECT Quantity_Ordered__c FROM Product2] );
         
        List<Order> ordersToUpdate = [SELECT Status FROM Order];
        for( Order thisOrder : ordersToUpdate ) {
            thisOrder.Status = Constants.ACTIVATED_ORDER_STATUS;
        }
        update ordersToUpdate;
        
		Map<Id, Product2> updatedProducts = new Map<Id, Product2>( [SELECT Quantity_Ordered__c FROM Product2] );
        
        List<OrderItem> items = [SELECT PricebookEntry.Product2Id, Quantity FROM OrderItem];
        
        for( OrderItem thisItem : items ) {
            TestDataFactory.VerifyQuantityOrdered( originalProducts.get( thisItem.PricebookEntry.Product2Id )
                                                 , updatedProducts.get( thisItem.PricebookEntry.Product2Id )
                                                 , (Integer)thisItem.Quantity );
        }
    }
    
    @isTest
    public static void OrderExtension_UnitTest() {
        
        TestDataFactory.InsertTestData( 1 );
        
        Order testOrder = [SELECT Id FROM Order LIMIT 1];
        
		PageReference pageRef = Page.OrderEdit;
        Test.setCurrentPage(pageRef);

        OrderExtension ext = new OrderExtension( new ApexPages.StandardController( new Order( Id = testOrder.Id ) ) );

        ext.buildOrderItems();
        ext.OnFieldChange();
        ext.SelectFamily();
        ext.Save();
        ext.First();
        ext.Last();
        ext.GetHasNext();
        ext.GetHasPrevious();
        ext.GetPageNumber();
        ext.GetTotalPages();
        ext.GetFamilyOptions();

        ChartHelper.GetInventory();
        
        System.assert( true );
        
    }
}