# grunt-configero-project-starter

> Configero project template starter kit

## Getting Started
This plugin requires Grunt `~0.4.5`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-configero-project-starter --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-configero-project-starter');
```

## The "configero_project_starter" task

### Overview
In your project's Gruntfile, add a section named `configero_project_starter` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
	configero_project_starter: {
		your_target: { //Your Target
			options: {
				objects: []	//Desired SObjects to create Trigger Handlers for
			},      
		},
	},
});
```

### Options

#### options.objects
Type: `Array`
Default value: `null`
Required: `yes`

An array containing API Names of Objects to create Trigger Handlers for. If the base Trigger Factory and Trigger Interface is not present in your `src/classes` directory, then those files will also be created.

### Usage Examples

#### Default Options
In this example, `trigger handlers` are created for the `Account`, `Lead`, & `My_Custom_Object__c` objects.
`My_Custom_Object__c` will be prettyfied to `MyCustomObject` i.e. `MyCustomObjectTrigger.trigger` and `MyCustomObjectTriggerHandler.cls`. 

```js
grunt.initConfig({
	configero_project_starter: {
		triggers:{
			options: {
				objects: ['Account', 'Lead', 'My_Custom_Object__c']
			},    
		}
	},
});
```

#### TriggerHandler Example

This is a modified version of the Trigger Pattern posted on Developer.Force.com (http://developer.force.com/cookbook/recipe/trigger-pattern-for-tidy-streamlined-bulkified-triggers)

```java
public with sharing class AccountHandler implements ConfigeroTriggerInterface {
	private List<Account> newList;
	private Map<Id,Account> oldMap;
	public AccountHandler(){
		this.newList = trigger.new;
		this.oldMap = (Map<Id,Account>)trigger.oldMap;
	}

	...

	public void beforeInsert(){
		//Could loop through `newList` here which is a `List<Account>` in this Handler.
	}

	public void beforeUpdate(){
		if(preventRecursion()) return;
		incrementTriggerRuns();
		
		doSomethingExample(); //Example only, can be removed
		//Handy if you need to run updates in a certain order.
		//doSomethinElse();
		//ThenSomeOtherProcess();
	}

	public void beforeDelete(){

	}		

	...

	//Called from beforeUpdate() above
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

		/* Only gets executed if above logic requires it, not really suitable for a bulkBefore or bulkAfter call*/
		Contact[] contacts = [SELECT Id FROM Contact WHERE AccountId IN :accountIds];
	}
}
````

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_
=======
Configero Project template
>>>>>>> 95740de827bb3ba76e3ec99579c5590669dde438
