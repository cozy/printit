var logit = require('./main');

var logger = logit({
  prefix: 'my app',
  date: true
});

logger.info("Test 1");
logger.debug("Test 2");
logger.warn("Test 3");
logger.error("Test 4");

logger = logit({
  prefix: 'my app',
  date: false
});
logger.error("Test 5");

logger = logit({
  prefix: 'my new app',
  date: false
});
logger.error("Test 6");

logger = logit();
logger.error("Test 7");

var obj = {"data": "test", "another data": 2};
logger.info(obj);

var tab = ["el1", "el2"];
logger.info(tab);

logger.info('arg1', 'arg2');

fs = require('fs');

fs.lstat('notexist', function(err) {
  logger.error(err);
});
