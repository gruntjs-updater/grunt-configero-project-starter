global with sharing class SchemaUtility {
	//SCHEMA
	global static Map<String, Schema.SObjectType> sObjectMap;
	global static Map<String, Id> recordTypes;

	public static Map<String, Schema.SObjectType> getSObjectMap(){
		if( sObjectMap == NULL ){
			sObjectMap = Schema.getGlobalDescribe();
		}

		return sObjectMap;
	}

	public static Id getRecordTypeByName(String sObjectName, String recordTypeName){
		if(recordTypes == NULL){
			Schema.DescribeSObjectResult DESCRIBE_RESULT = getSObjectMap().get(sObjectName).getDescribe();
			recordTypes = new Map<String, Id>();
			for( Schema.RecordTypeInfo r : DESCRIBE_RESULT.getRecordTypeInfos() ){
				recordTypes.put(r.getName(), r.getRecordTypeId());
			}
		}
		if( recordTypes.containsKey(recordTypeName) )
			return recordTypes.get(recordTypeName);
		else
			return null;
	}

	public static Map<String,Schema.SObjectField> getSObjectFieldMap(String sObjectName){
		if( getSObjectMap().containsKey(sObjectName) ){
			return getSObjectMap().get(sObjectName).getDescribe().fields.getMap();
		} else {
			return NULL;
		}
	}

	public static Boolean sObjectHasField(sObject sObj, String field){
		String sObjectType = String.valueOf(sObj.getSObjectType());
		if( getSObjectFieldMap(sObjectType).containsKey(field) ) return true;
		return false;
	}

	private static Map<String, Set<String>> fieldExclusions {
		get{
			Map<String, Set<String>> f = new Map<String, Set<String>>();
			f.put('Lead', new Set<String>{'Address'}); //Exclude the address field as it's really not useful.
			return f;
		}
	}

	public static String getSQLFieldString(String sObjectName){
		Set<String> exclusions = new Set<String>();
		if( fieldExclusions.containsKey(sObjectName) ){
			exclusions.addAll(fieldExclusions.get(sObjectName));
		}

		if( getSObjectMap().containsKey(sObjectName) ){
			Map<String, Schema.SObjectField> fieldMap = getSObjectMap().get(sObjectName).getDescribe().fields.getMap();
			List<String> fieldList = new List<String>();
			for(Schema.SObjectField fields : fieldMap.Values()) {
				String fieldName = fields.getDescribe().getName();
				if( exclusions.contains(fieldName)) continue; //Exclude it if in the list
				fieldList.add(fieldName);
			}
			return String.join(fieldList, ',');
		} else {
				return NULL;
		}
	}

	public static Set<String> getPicklistValues(String sObj, String field){
		Set<String> options = new Set<String>();
		List<Schema.PicklistEntry> ple = getSObjectMap().get(sObj).getDescribe().fields.getMap().get(field).getDescribe().getPicklistValues();
		for(Schema.PicklistEntry p : ple){
			options.add(p.getLabel());
		}
		return options;
	}

   //Get Field Sets
   public static Schema.FieldSetMember[] getFieldSets(String sObjectName, String fieldSetName){
   		return getSObjectMap().get(sObjectName).getDescribe().FieldSets.getMap().get(fieldSetName).getFields();
   }
}