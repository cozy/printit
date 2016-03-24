var logit = require('./main');
var intercept = require("intercept-stdout");
var should = require('should');

var capturedText = "";

function captureText(txt) { capturedText = txt; }
function captureManyText(txt) { capturedText += txt; }

describe('Check that output is proper', function() {

  it('info', function() {
    var unhookIntercept = intercept(captureText);
    var logger = logit({
      prefix: 'my app',
    });

    logger.info("Test 1");
    unhookIntercept();
    capturedText.should.equal('\u001b[34minfo\u001b[39m - my app | Test 1\n');
  });

  it('warn', function() {
    var unhookIntercept = intercept(captureText);
    var logger = logit({
      prefix: 'my app',
    });

    logger.warn("Test 3");
    unhookIntercept();
    capturedText.should.equal('\u001b[33mwarn\u001b[39m - my app | Test 3\n');
  });

  it('error', function() {
    var unhookIntercept = intercept(captureText);
    var logger = logit({
      prefix: 'my app',
    });

    logger.error("Test 4");
    unhookIntercept();
    capturedText.should.equal('\u001b[31merror\u001b[39m - my app | Test 4\n');
  });

  it('obj', function() {
    var unhookIntercept = intercept(captureText);
    var logger = logit({
      prefix: 'my app',
    });

    logger.info({"data": "test", "another data": 2});
    unhookIntercept();
    capturedText.should.equal('\u001b[34minfo\u001b[39m - my app | {\"data\":\"test\",\"another data\":2}\n')
  });

  it('array', function() {
    var unhookIntercept = intercept(captureText);
    var logger = logit({
      prefix: 'my app',
    });

    logger.info(['el1', 'el2']);
    unhookIntercept();
    capturedText.should.equal('\u001b[34minfo\u001b[39m - my app | [\"el1\",\"el2\"]\n');
  });

  it('multiple args', function() {
    var unhookIntercept = intercept(captureText);
    var logger = logit({
      prefix: 'my app',
    });

    logger.info('arg1', 'arg2');
    unhookIntercept();
    capturedText.should.equal('\u001b[34minfo\u001b[39m - my app | arg1 arg2\n');
  });

  it('duplicate stdout', function() {
    var unhookIntercept = intercept(captureManyText);
    var logger = logit({
      prefix: 'my app',
      duplicateToStdout: true
    });

    logger.error('fail');
    unhookIntercept();
    capturedText.should.equal('\u001b[34minfo\u001b[39m - my app | arg1 arg2\n\u001b[31merror\u001b[39m - my app | fail\n\u001b[31merror\u001b[39m - my app | fail\n');
    capturedText = "";
  });


  it('debug', function() {
    process.env.DEBUG = true;
    var unhookIntercept = intercept(captureText);
    var logger = logit({
      prefix: 'my app',
    });

    logger.debug("Test 2");
    unhookIntercept();
    capturedText.should.equal('\u001b[32mdebug\u001b[39m - my app | ./test.js:99 | Test 2\n');
    process.env.DEBUG = false;
  });


});
