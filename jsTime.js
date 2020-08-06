/**
 * Do something like:
 * var timer = require('./path/to/jsTime.js).timer;
 */
function timer(func, name=timer, count=10000) {
	if (!func) {
		throw new Error('No function provided');
	}
	console.time(name);
	for (var i = 0; i < count; i++) {
		func();
	}
	console.timeEnd(name);
}
module.exports = { timer };
