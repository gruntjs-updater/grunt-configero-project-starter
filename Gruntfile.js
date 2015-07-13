/*
* grunt-configero-project-starter
* https://github.com/WiznoForce/grunt-configero-project-starter
*
* Copyright (c) 2015 Andrew Wisniowski
* Licensed under the MIT license.
*/

'use strict';

module.exports = function(grunt) {

	// Project configuration.
	grunt.initConfig({
		jshint: {
			all: [
			'Gruntfile.js',
			'tasks/*.js',
			// '<%= nodeunit.tests %>'
			],
			options: {
				jshintrc: '.jshintrc'
			}
		},

		// Before generating any new files, remove any previously-created files.
		clean: {
			tests: ['tmp']
		},

		// Configuration to be run (and then tested).
		configero_project_starter: {
			default_options: {
				options: {
					objects: ['Lead', 'My_Customized_Object__c']
				},
				files: {
					'tmp/default_options': ['test/fixtures/testing', 'test/fixtures/123']
				}
			},
			custom_options: {
				options: {
					separator: ': ',
					punctuation: ' !!!',
					objects: ['Account', 'My_Custom_Object__c']
				},
				files: {
					'tmp/custom_options': ['test/fixtures/testing', 'test/fixtures/123']
				}				
			},
			triggers: {
				options: {
					objects: ['Account', 'My_Object__c']
				},
				files: {}				
			}

		},

		// Unit tests.
		nodeunit: {
			// tests: ['test/*_test.js']
		}

	});

	// Actually load this plugin's task(s).
	grunt.loadTasks('tasks');

	// These plugins provide necessary tasks.
	grunt.loadNpmTasks('grunt-contrib-jshint');
	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-nodeunit');

	// Whenever the "test" task is run, first clean the "tmp" dir, then run this
	// plugin's task(s), then test the result.
	grunt.registerTask('test', ['clean', 'configero_project_starter']);

	// By default, lint and run all tests.
	grunt.registerTask('default', ['jshint', 'test']);

};
