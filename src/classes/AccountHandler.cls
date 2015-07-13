public with sharing class AccountHandler implements ConfigeroTriggerInterface {
	
	private List<Account> newList;
	private Map<Id,Account> oldMap;
	public AccountHandler(){
		this.newList = trigger.new;
		this.oldMap = (Map<Id,Account>)trigger.oldMap;
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
		
		doSomethingExample(); //Example only, can be removed
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
		for(Account a: newList){
			System.debug('Current Account: ' + a.Name);
			if( a.Name != old(a).Name){
				System.debug('The name is not the same');
				accountIds.add(a.Id);
			}
		}

		if(accountIds.isEmpty()) return;

		/* Only gets executed if above logic requires it, not really suitable for a bulkBefore or bulkAfter calll*/
		Contact[] contacts = [SELECT Id FROM Contact WHERE AccountId IN :accountIds];
	}

	private Account old(Account a){
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
		if( AccountHandler.triggerRuns > 1 && !AccountHandler.allowRecursion) return true;
		return false;
	}

	//TODO: Think about better way to handle this
	/**
	 * incrementTriggerRuns
	 *
	 * increments the triggerRuns counter variable
	 */
	private void incrementTriggerRuns(){
		AccountHandler.triggerRuns += 1;
	}
}