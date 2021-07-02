package why;

import haxe.PosInfos;
import why.log.Config;

using haxe.io.Path;

// @:forward
abstract Log(why.log.Logger) from why.log.Logger to why.log.Logger {
	
	// constants
	public static inline final DEBUG = 40;
	public static inline final INFO = 30;
	public static inline final WARN = 20;
	public static inline final ERROR = 10;
	
	// confg
	public static var config(get, never):Config;
	static inline function get_config() return Config.INST;
	
	// global instance
	public static var logger:Log;
	
	// forward calls
	public static macro function info();
	public static macro function error();
	public static macro function warn();
	public static macro function debug();
	
	/**
	 * Log a value and return it
	 */
	public inline static function peek<T>(v:T, ?pos:PosInfos):T {
		logger.log(DEBUG, [v], pos);
		return v;
	}
	
	/**
	 * For those who want to replace stock trace
	 */
	public inline static function patchHaxeTrace() {
		#if (!why.log.disabled)
		haxe.Log.trace = why.Log.trace;
		#end
	}
	
	static function trace(v:Dynamic, ?pos:PosInfos) {
		why.Log.wrap(DEBUG, logger.log(DEBUG, switch pos.customParams {
			case null: [v];
			case params: [v].concat(params);
		}, pos));
	}
	
	public static inline function timer(name:String) {
		return new why.log.Timer(name);
	}
	
	static macro function wrap();
	public inline function log(verbosity:Int, value:Array<Any>, ?pos:PosInfos):Void {
		why.Log.wrap(verbosity, _log(verbosity, value, pos));
	}
	
	public function _log(verbosity:Int, value:Array<Any>, ?pos:PosInfos):Void {
		if(config.verbosity >= verbosity) {
			this.log(verbosity, {pos: pos, date: Date.now()}, value);
		}
	}
	
	#if (!why.log.disabled)
	static function __init__() {
		Config.load();
		Config.listen();
	}
	#end
}
