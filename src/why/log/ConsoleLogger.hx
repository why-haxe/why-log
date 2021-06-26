package why.log;

import haxe.PosInfos;

class ConsoleLogger extends Logger {
	public function log(verbosity:Int, headers:Headers, value:Array<Any>):Void {
		if(verbosity >= why.Log.DEBUG) debug(headers, value);
		else if(verbosity >= why.Log.INFO) info(headers, value);
		else if(verbosity >= why.Log.WARN) warn(headers, value);
		else if(verbosity >= why.Log.ERROR) error(headers, value);
	}
	
	inline function info(headers:Headers, value:Array<Any>):Void
		(untyped console).info(formatter.format(headers, value));
	
	inline function warn(headers:Headers, value:Array<Any>):Void
		(untyped console).warn(formatter.format(headers, value));
	
	inline function error(headers:Headers, value:Array<Any>):Void
		(untyped console).error(formatter.format(headers, value));
	
	inline function debug(headers:Headers, value:Array<Any>):Void
		(untyped console).debug(formatter.format(headers, value));
}