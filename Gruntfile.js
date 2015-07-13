/*
* grunt-configero-project-starter
* https://github.com/WiznoForce/grunt-configero-project-starter
*
* Copyright (c) 2015 Andrew Wisniowski
* 
* Email: andrew.wisniowski@configero.com
* Website: http://Configero.com
* Website: http://Wizno.com
* 
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
			'<%= nodeunit.tests %>'
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
			triggers: {
				options: {
					objects: ['Account'] //Add any SObjects you want to generate TriggerHandlers for here. You can run this again in the future if you want to add more.
				}
			}
		},

		configero_tools: {
			tools: {
				options: {}
			}
		},

		// Unit tests.
		nodeunit: {
			tests: ['test/*_test.js']
		},

		copy: {
			options: {},
			main: {
				expand: true,
				src: ['**/*'],
				dest: 'src/',
				cwd: 'tmp'
			}
		},

		antretrieve: {
			options: {
				user: 'BillWiThe@Science.Fi',
				pass: 'iWlliB',
				root: 'src/',
				maxPoll: '20',
				pollWaitMillis: '10000'
			},
			build: {
				pkg: {
					apexclass: ['*'],
					apextrigger: ['*']
				}
			}
		},

		antdeploy: {
			options: {
				user: 'BillWiThe@Science.Fi',
				pass: 'iWlliB',
				root: 'src/',
				apiVersion: "32.0"
			},
			build: {				
				pkg: {					
					apexclass: ['*'],
					apextrigger: ['*']
				}
			}
		},

	});

	// Actually load this plugin's task(s).
	grunt.loadTasks('tasks');

	// These plugins provide necessary tasks.
	grunt.loadNpmTasks('grunt-contrib-jshint');
	grunt.loadNpmTasks('grunt-contrib-clean');
	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-contrib-nodeunit');
	grunt.loadNpmTasks('grunt-ant-sfdc');	

	
	// By default, lint and run all tests.
	grunt.registerTask('default', ['jshint', 'clean', 'configero_project_starter', 'nodeunit', 'write-apex-class-meta', 'write-apex-trigger-meta', 'copy', 'antdeploy','clean']);

	grunt.registerTask('deploy-tools', ['jshint', 'clean', 'configero_tools', 'write-apex-class-meta', 'copy', 'antdeploy', 'clean']);

};
