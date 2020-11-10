/**
 * Do something like:
 * var timer = require('./path/to/jsTime.js).timer;
 */
function timer(func, name, count=10000) {
	if (!func) {
		throw new Error('No function provided');
	}
	if (!name) {
		name = func.name;
	}
	console.time(name);
	for (var i = 0; i < count; i++) {
		func();
	}
	console.timeEnd(name);
}
module.exports = { timer };
