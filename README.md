## It began with a console.log...

You are probably like me, you always put some dirty logs in your software. You
want to keep them dirty but you want fancy colors in your terminal, not in
production, and you don't want to see this log displayed in your test output.
At last, you don't care much about log level, the classical
info/debug/warn/error is enough for you. Say welcome to printit the dirty
logger with class!

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
