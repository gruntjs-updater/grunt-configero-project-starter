module.exports = function(grunt){
	var writeMetaFile = function(directory, template){
		grunt.file.recurse(directory, function(abspath, rootdir, subdir, filename){
			if( filename.indexOf('.cls') < 0 && filename.indexOf('.trigger') < 0) { return; }

			var metaFileName = rootdir +'/'+filename+'-meta.xml';
			var metaFile = grunt.template.process(metaFileName);
			grunt.log.writeln('Writing meta for: '+metaFileName);
			grunt.file.write(metaFile, template.join('\n'));
		});
	};

	grunt.registerTask('write-apex-class-meta', 'Write the required salesforce metadata for an Apex Class', function(){
		var meta = [
			'<?xml version="1.0" encoding="UTF-8"?>',
			'<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">',
			'	<apiVersion>32.0</apiVersion>',
			'	<status>Active</status>',
			'</ApexClass>'
		];

		writeMetaFile('tmp/classes', meta);

	});

	grunt.registerTask('write-apex-trigger-meta', 'Write the required salesforce metadata for an Apex Class', function(){
		var meta = [
			'<?xml version="1.0" encoding="UTF-8"?>',
			'<ApexTrigger xmlns="http://soap.sforce.com/2006/04/metadata">',
			'	<apiVersion>32.0</apiVersion>',
			'	<status>Active</status>',
			'</ApexTrigger>',
		];

		writeMetaFile('tmp/triggers', meta);

	});
};