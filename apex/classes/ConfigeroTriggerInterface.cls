public interface ConfigeroTriggerInterface {

	/**
	 * bulkBefore
	 *
	 * This method is called prior to execution of a BEFORE trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	void bulkBefore();

	/**
	 * bulkAfter
	 *
	 * This method is called prior to execution of an AFTER trigger. Use this to cache
	 * any data required into maps prior execution of the trigger.
	 */
	void bulkAfter();	

	/**
	 * beforeInsert
	 *
	 * This method is called when trigger is executing BEFORE INSERT
	 */
	void beforeInsert();

	/**
	 * beforeUpdate
	 *
	 * This method is called when trigger is executing BEFORE UPDATE
	 */
	void beforeUpdate();

	/**
	 * beforeDelete
	 *
	 * This method is called when trigger is executing BEFORE DELETE
	 */
	void beforeDelete();

	/**
	 * afterInsert
	 *
	 * This method is called when trigger is executing AFTER INSERT
	 */
	void afterInsert();

	/**
	 * afterUpdate
	 *
	 * This method is called when trigger is executing AFTER UPDATE
	 */
	void afterUpdate();

	/**
	 * afterDelete
	 *
	 * This method is called when trigger is executing AFTER DELETE
	 */
	void afterDelete();

	/**
	 * andFinally
	 *
	 * This method is called once all records have been processed by the trigger. Use this 
	 * method to accomplish any final operations such as creation or updates of other records.
	 */
	void andFinally();
}