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
    options: {
      // Task-specific options go here.
    },
    your_target: {
      // Target-specific file lists and/or options go here.
    },
  },
});
```

### Options

#### options.objects
Type: `Array`
Default value: `null`

An array containing API Names of Objects to create Trigger Handlers for. If the base Trigger Factory and Trigger Interface is not present in your `src/classes` directory, then those files will also be created.

### Usage Examples

#### Default Options
In this example, `trigger handlers` are created for the `Account`, `Lead`, & `My_Custom_Object__c` objects.
`My_Custom_Object__c` will be prettyfied to `MyCustomObject` i.e. `MyCustomObjectTrigger.trigger` and `MyCustomObjectTriggerHandler.cls`. 

```js
grunt.initConfig({
  configero_project_starter: {
    options: {
    	objects: ['Account', 'Lead', 'My_Custom_Object__c']
    },    
  },
});
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_
=======
Configero Project template
>>>>>>> 95740de827bb3ba76e3ec99579c5590669dde438
