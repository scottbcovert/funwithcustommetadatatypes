/**
* @author Scott Covert - Tython Co.
* @date 12/20/2015
* @description This class serves as a test data factory for test methods to utilize
*/
public class TestDataFactory {
    
    /** Schema Map for Current Org */
    private static Map<String,String> SchemaMap
    {
        get 
        {
            if (SchemaMap!=null) return SchemaMap;
            SchemaMap = new Map<String,String>();
            Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
            for(String sObj : gd.keySet())
            {
                Schema.DescribeSObjectResult sObjResult = gd.get(sObj).getDescribe(); 
                if (sObjResult.getKeyPrefix()!=null)
                {
                    SchemaMap.put(sObjResult.getName().toLowerCase(),sObjResult.getKeyPrefix());
                }
            }
            return SchemaMap;
        }
    }
        
    /** 
    * @author Scott Covert - Tython Co.
    * @date 12/20/2015
    * @param String API Name for given SObject
    * @param Integer Number of records to generate
    * @return List A list of SObject records
    * @description This method generates records for test methods
    */
    public static list<SObject> build(String objectAPIName, Integer numRecords)
    {

        // Generate list of SObject records based on SObjectType defaults and predetermined number of records
        list<SObject> records = new list<SObject>();
        for (Integer i=0; i<numRecords; i++)
        {
            SObject record = Schema.getGlobalDescribe().get(objectAPIName).newSObject(null,true);
            record.put('Name','Test' + String.valueOf(i));
            records.add( record );
        }
        
        // Check for any org-specific field requirements by dynamically querying custom metadata
        if (SchemaMap.containsKey('fieldrequirement__mdt'))
        {
            for ( SObject fieldRequirement : Database.query('SELECT DeveloperName, SObject__c, Field__c, RequiredValue__c FROM FieldRequirement__mdt WHERE SObject__c = \'' + objectAPIName + '\'') )
            {
                for (SObject record : records)
                {
                    record.put( String.valueOf( fieldRequirement.get('Field__c') ) , String.valueOf( fieldRequirement.get('RequiredValue__c') ) );
                }
            }
        }
        
        return records;
    }
}