'use strict';

var grunt = require('grunt');

/*
  ======== A Handy Little Nodeunit Reference ========
  https://github.com/caolan/nodeunit

  Test methods:
    test.expect(numAssertions)
    test.done()
  Test assertions:
    test.ok(value, [message])
    test.equal(actual, expected, [message])
    test.notEqual(actual, expected, [message])
    test.deepEqual(actual, expected, [message])
    test.notDeepEqual(actual, expected, [message])
    test.strictEqual(actual, expected, [message])
    test.notStrictEqual(actual, expected, [message])
    test.throws(block, [error], [message])
    test.doesNotThrow(block, [error], [message])
    test.ifError(value)
*/

exports.configero_project_starter = {
  setUp: function(done) {
    // setup here if necessary
    done();
  },
  triggers: function(test) {
    test.expect(2);

    var actualHandler = grunt.file.read('tmp/classes/AccountHandler.cls');
    var expectedHandler = grunt.file.read('test/expected/AccountHandler.cls');
    test.equal(actualHandler, expectedHandler, 'AccountHandler should now be successfully generated.');

    var actualTrigger = grunt.file.read('tmp/triggers/AccountTrigger.trigger');
    var expectedTrigger = grunt.file.read('test/expected/AccountTrigger.trigger');
    test.equal(actualTrigger, expectedTrigger, 'AccountTrigger should now be successfully generated.');

    test.done();
  }
};
