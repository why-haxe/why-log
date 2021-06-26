package ;

import haxe.Timer;
import why.Log.*;

class RunTests {

	static function main() {
		why.Log.patchHaxeTrace();
		why.Log.logger = new why.log.AnsiLogger();
		// logger = new why.log.ConsoleLogger();
		
		final int = 10;
		final str = 'foo';
		final date = Date.now();
		final arr = [for(i in 0...10) i];
		final map = [for(i in 0...10) i => i * i];
		final obj = {a: int, b: str, c: date}
		final complex = {obj: obj, arr: arr, map: map}
		
		new haxe.Timer(1000).run = function() {
			trace(1, 2, 3);
			peek(1);
			info('info', int, str, date, obj);
			error('error', int, str, date, obj);
			warn('warn', int, str, date, obj);
			debug('debug', int, str, date, obj);
			// logger.info('info', int, str, date, arr, map, obj, complex);
			// logger.error('error', int, str, date, arr, map, obj, complex);
			// logger.warn('warn', int, str, date, arr, map, obj, complex);
			// logger.debug('debug', int, str, date, arr, map, obj, complex);
		}
	}
	
}