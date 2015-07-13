public with sharing class <%= triggerObject %>Handler implements ConfigeroTriggerInterface {
	
	private List<<%= triggerObject %>> newList;
	private Map<Id,<%= triggerObject %>> oldMap;
	public <%= triggerObject %>Handler(){
		this.newList = trigger.new;
		this.oldMap = (Map<Id,<%= triggerObject %>>)trigger.oldMap;
	}

	public static Integer triggerRuns = 0;
	public static Boolean allowRecursion = false;

	//Routing

	/*
		Handle any bulk operations that may apply to all BEFORE operations.
		I.E. getting user or org details, getting record types
	 */
	public void bulkBefore(){
		
	}

	/*
		Handle any bulk operations that may apply to all AFTER operations.
		I.E. getting user or org details, getting record types
	 */
	public void bulkAfter(){

	}

	/*
		Do any wrap up or logging here.
	 */
	public void andFinally(){

	}

	public void beforeInsert(){

	}

	public void beforeUpdate(){
		if(preventRecursion()) return;
		incrementTriggerRuns();
		
		doSomething(); //Example only, can be removed
	}

	public void beforeDelete(){

	}

	public void afterInsert(){

	}

	public void afterUpdate(){
		if(preventRecursion()) return;
		incrementTriggerRuns();

		doSomethingExample(); //Example only, can be removed
	}

	public void afterDelete(){

	}

	//Method
	
	 //Example only, can be removed
	private void doSomethingExample(){
		//Assumes this handler was for Account
		Set<Id> accountIds = new Set<Id>();
		System.debug('trigger runs: '+triggerRuns);
		for(<%= triggerObject %> a: newList){
			System.debug('Current <%= triggerObject %>: ' + a.Name);
			if( a.Name != old(a).Name){
				System.debug('The name is not the same');
				accountIds.add(a.Id);
			}
		}

		if(accountIds.isEmpty()) return;

		/* Only gets executed if above logic requires it, not really suitable for a bulkBefore or bulkAfter calll*/
		Contact[] contacts = [SELECT Id FROM Contact WHERE AccountId IN :accountIds];
	}

	private <%= triggerObject %> old(<%= triggerObject %> a){
		if( oldMap == null ) return a;
		return oldMap.get(a.Id);
	}

	//TODO: Think about better way to handle this
	/**
	 * preventRecursion
	 *
	 * Stores trigger runs in a STATIC INTEGER variable so you can see if recursion is happening.
	 */
	private Boolean preventRecursion(){
		if( triggerRuns > 1 && !allowRecursion) return true;
		return false;
	}

	//TODO: Think about better way to handle this
	/**
	 * incrementTriggerRuns
	 *
	 * increments the triggerRuns counter variable
	 */
	private void incrementTriggerRuns(){
		this.triggerRuns += 1;
	}
}