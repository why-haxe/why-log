package ;

import haxe.PosInfos;
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
		
		final timer = new haxe.Timer(1000);
		var count = 0;
		timer.run = function() {
			if(count++ > 3) timer.stop();
			
			trace(1, 2, 3);
			peek(1);
			info('info', int, str, date, obj);
			error('error', int, str, date, obj);
			warn('warn', int, str, date, obj);
			debug('debug', int, str, date, obj);
			retainPos(int);
			// logger.info('info', int, str, date, arr, map, obj, complex);
			// logger.error('error', int, str, date, arr, map, obj, complex);
			// logger.warn('warn', int, str, date, arr, map, obj, complex);
			// logger.debug('debug', int, str, date, arr, map, obj, complex);
		}
	}
	
	static function retainPos(v:Dynamic, ?pos:PosInfos) {
		why.Log.debug(v, pos);
	}
	
}