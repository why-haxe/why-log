package ;

import haxe.PosInfos;
import haxe.Timer;
import why.Log.*;

class RunTests {

	static function main() {
		trace(why.Log.config);
		why.Log.patchHaxeTrace();
		why.Log.logger = new why.log.AnsiLogger();
		// logger = new why.log.ConsoleLogger();
		
		final int = 10;
		final str = 'foo';
		final date = Date.now();
		final arr = [for(i in 0...10) i];
		final map = [for(i in 0...10) i => i * i];
		final obj = {a: int, b: str, c: date}
		final enm = haxe.ds.Option.Some(obj);
		final complex = {obj: obj, arr: arr, map: map}
		
		final timer = new haxe.Timer(1000);
		var count = 0;
		timer.run = function() {
			if(count++ > 3) timer.stop();
			
			trace(1, 2, 3);
			peek(1);
			object(peek({foo: 'foo'}));
			info('info', int, str, date, enm);
			error('error', int, str, date, enm);
			warn('warn', int, str, date, enm);
			debug('debug', int, str, date, enm);
			retainPos(int);
			normal(int, str);
			dyn(int, str);
			// logger.info('info', int, str, date, arr, map, obj, complex);
			// logger.error('error', int, str, date, arr, map, obj, complex);
			// logger.warn('warn', int, str, date, arr, map, obj, complex);
			// logger.debug('debug', int, str, date, arr, map, obj, complex);
			why.Log.custom(100, 'foo');
		}
	}
	
	static function retainPos(v:Dynamic, ?pos:PosInfos) {
		why.Log.debug(v, pos);
	}
	
	static function normal(i:Int, s:String) {
		why.Log.debug(i, s);
	}
	
	static function dyn(i:Int, s:Dynamic) {
		why.Log.debug(i, s);
	}
	
	static function object(o:{final foo:String;}) {
		trace(o.foo);
	}
	
}