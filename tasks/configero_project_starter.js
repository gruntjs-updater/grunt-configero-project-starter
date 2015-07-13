/*
* grunt-configero-project-starter
* https://github.com/WiznoForce/grunt-configero-project-starter
*
* Copyright (c) 2015 Andrew Wisniowski
* Licensed under the MIT license.
*/

'use strict';

var path = require('path');

var localApex = path.resolve(__dirname, '../apex');
var localTmp = path.resolve(__dirname, '../tmp');
var CONFIGERO_TRIGGER_INTERFACE = path.join(localApex, '/classes/ConfigeroTriggerInterface.cls');
var CONFIGERO_TRIGGER_FACTORY = path.join(localApex, '/classes/ConfigeroTriggerFactory.cls');

String.prototype.makePretty = function(){
	var objectParts = this.replace('__c','').split('_');
	var prettyName = '';
	for(var s in objectParts){
		prettyName += (objectParts[s].charAt(0).toUpperCase() + objectParts[s].slice(1));
	}
	return prettyName;
};

module.exports = function(grunt) {

	// Please see the Grunt documentation for more information regarding task
	// creation: http://gruntjs.com/creating-tasks
	
	var createDependentClasses = function(){
		var hasInterface = grunt.file.exists(path.join(localTmp, '/apex/classes/ConfigeroTriggerInterface.cls'));
		var hasFactory = grunt.file.exists(path.join(localTmp, '/apex/classes/ConfigeroTriggerFactory.cls'));

		if(!hasInterface){
			grunt.log.writeln('Trigger Interface NOT FOUND! Copying into directory.');
			grunt.file.copy(CONFIGERO_TRIGGER_INTERFACE, path.join(localTmp, '/classes/ConfigeroTriggerInterface.cls'));
		}
		if(!hasFactory){
			grunt.log.writeln('Trigger Factory NOT FOUND! Copying into directory.');
			grunt.file.copy(CONFIGERO_TRIGGER_FACTORY, path.join(localTmp, '/classes/ConfigeroTriggerFactory.cls'));
		}
	};

	grunt.registerMultiTask('configero_project_starter', 'Configero project template starter kit', function() {
		// Merge task-specific and/or target-specific options with these defaults.
		var options = this.options();

		if(options.objects === undefined || options.objects == null || options.objects.length === 0){
			grunt.fail.fatal('Objects array is empty. You must specify at least 1 SObject to continue.', 'NSF');
		}

		var triggerTemplate = grunt.file.read(path.join(localApex,'/triggers/Trigger.trigger'));
		var handlerTemplate = grunt.file.read(path.join(localApex,'/classes/Handler.cls'));

		grunt.log.writeln('Triggers to generate: ' + options.objects);
		
		createDependentClasses();

		for(var index in options.objects){
			var o = options.objects[index];
			grunt.log.writeln('Writing Trigger & Handler for: '+o);
			var data = {
				triggerObject: o,
				triggerObjectPretty: o.makePretty()
			};
			grunt.log.writeln(data);
			var buildTriggerFile = grunt.template.process(triggerTemplate, {data: data});
			var buildHandlerFile = grunt.template.process(handlerTemplate, {data: data});
			grunt.file.write(path.join(localTmp, '/triggers/'+data.triggerObjectPretty+'Trigger.trigger'), buildTriggerFile);
			grunt.file.write(path.join(localTmp, '/classes/'+data.triggerObjectPretty+'Handler.cls'), buildHandlerFile);
		}
	});

};
