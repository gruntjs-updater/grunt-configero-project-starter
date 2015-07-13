public with sharing class ConfigeroTriggerFactory {
	public static void createAndExecuteHandler(Type t){
		ConfigeroTriggerInterface handler = getHandler(t);

		if( handler == null ){
			throw new TriggerException('No Trigger Handler found named: ' + t.getName());
		}

		execute(handler);
	}

	/**
	 * Modified version of the Trigger Pattern posted on Developer.Force.com (http://developer.force.com/cookbook/recipe/trigger-pattern-for-tidy-streamlined-bulkified-triggers)
	 * The bulkBefore and bulkAfter methods are a great idea in concept, but I'm not sold on them being the best way to distribute the logic. 
	 * I think it may work for certain situations... i.e. on triggers where you will have to query a set of records 100% of the time, but in other situations, 
	 * I prefer to isolate SOQL queries to individual methods when and only when the data is required. See the doSomethingExample() in the <ObjectName>Handler.cls
	 */
	private static void execute(ConfigeroTriggerInterface handler){
		if( Trigger.isBefore ){
			handler.bulkBefore();

			if( Trigger.isDelete ){
				handler.beforeDelete();
			} else if( Trigger.isInsert ){
				handler.beforeInsert();
			} else if( Trigger.isUpdate) {
				handler.beforeUpdate();
			}
		} else {
			handler.bulkAfter();

			if( Trigger.isDelete ){
				handler.afterDelete();
			} else if( Trigger.isInsert ){
				handler.afterInsert();
			} else if( Trigger.isUpdate) {
				handler.afterUpdate();
			}
		}

		handler.andFinally();
	}

	private static ConfigeroTriggerInterface getHandler(Type t){
		Object o = t.newInstance();
		if( !(o instanceOf ConfigeroTriggerInterface) ){
			return null;
		}

		return (ConfigeroTriggerInterface)o;
	}

	public class TriggerException extends Exception{}
}