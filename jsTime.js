/**
 * Do something like:
 * var timer = require('./path/to/jsTime.js).timer;
 */
function timer(func, count=10000, name) {
	if (!func) {
		throw new Error('No function provided, call as timer(func, [count], [name])');
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
exports.timer = timer;
