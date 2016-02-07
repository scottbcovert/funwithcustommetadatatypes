/**
* @author Scott Covert - Tython Co.
* @date 12/20/2015
* @description This class provides unit tests
*/
@IsTest(seealldata=false)
public with sharing class TestClass { 
    
    @testSetup
    /** 
    * @author Scott Covert - Tython Co.
    * @date 12/20/2015
    * @description This method creates test records for all other test methods in this class
    */
    private static void testSetup()
    {
        // Generate account records from factory
        list<Account> testAccounts = (list<Account>)TestDataFactory.build('Account',1);
        // Insert test accounts
        insert testAccounts;
    }
    
    @IsTest(oninstall=true seealldata=false)
    /** 
    * @author Scott Covert - Tython Co.
    * @date 12/20/2015
    * @description This method tests the test data factory
    */
    private static void testDataFactory() {
        // Calling TestDataFactory during the @testSetup method does not count for code coverage
        list<Account> testAccounts = (list<Account>)TestDataFactory.build('Account',1);
        insert testAccounts;
    }
    
    @IsTest(oninstall=true seealldata=false)
    /** 
    * @author Scott Covert - Tython Co.
    * @date 12/20/2015
    * @description This method tests the installation class
    */
    private static void testInstallation() {

        Test.startTest();

        PostInstallClass postInstallClassInstance = new PostInstallClass();
        Test.testInstall(postInstallClassInstance, null);

        Test.stopTest();

    }

}