## It began with a console.log...

You are probably like me, you always put some dirty logs in your software. You
want to keep them dirty but you want fancy colors in your terminal, not in
production, and you don't want to see this log displayed in your test output.
At last, you don't care much about log level, the classical
info/debug/warn/error is enough for you. Say welcome to printit the dirty
logger with class!

### Display rules

The way printit displays things is changed via environment variable:

* Debug messages are not displayed.
* When NODE_ENV is 'production', it doesn't display colors (it's better when you cat/tail a log file).
* When NODE_ENV is 'test', it doesn't display logs (logs make mocha output 
  looks less messy).
* When DEBUG is 'true', it displays the debug messages.

### Examples

```javascript
var printit = require('printit');

var log = printit({
  prefix: 'my app',
  date: true
});

log.info("Print this with a blue info label and my app prefix and date");
log.debug("Print this with a green debug label and my app prefix and date");
log.warn("Print this with a yellow warn label and my app prefix and date");
log.error("Print this with a red error label and my app prefix and date");

log = printit({
  prefix: 'my app',
  date: false
});
log.error("Print this with a red error label and my app prefix");

log.error("Test 7");
log.error("Print this with a red error label");
```
