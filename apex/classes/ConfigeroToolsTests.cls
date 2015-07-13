@isTest
private class ConfigeroToolsTests {
	
	@isTest static void testConversionUtility_1() {
		Lead lead = UnitTestObjectCreator.createLead();
		insert lead;

		ConversionUtility.convertLead(lead);
	}

	@isTest static void testConversionUtility_2() {
		Lead lead = UnitTestObjectCreator.createLead();
		insert lead;

		ConversionUtility.convertLead(lead, false, 'Test Opportunity');
	}

	@isTest static void testConversionUtility_3() {
		Lead lead = UnitTestObjectCreator.createLead();
		insert lead;

		ConversionUtility.convertLead(lead, true, null);
	}
	

	@isTest static void testSchemaUtility(){
		Map<String, Schema.SObjectType> objMap = SchemaUtility.getSObjectMap();

		try {
			Id rtTest = SchemaUtility.getRecordTypeByName('Account', 'test');
		} catch(Exception e){

		}

		Map<String, Schema.SObjectField> fieldMap = SchemaUtility.getSObjectFieldMap('Account');

		Boolean hasField = SchemaUtility.sObjectHasField(new Account(), 'Name');

		String SOQL = SchemaUtility.getSQLFieldString('Account');

		Set<String> options = SchemaUtility.getPicklistValues('Account', 'AccountSource');

		try {
			Schema.FieldSetMember[] fs = SchemaUtility.getFieldSets('Account', 'FieldSet');
		} catch( Exception e){

		}
	}
	
}