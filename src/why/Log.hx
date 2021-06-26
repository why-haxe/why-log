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
		logger.log(DEBUG, switch pos.customParams {
			case null: [v];
			case params: [v].concat(params);
		}, pos);
	}
	
	#if why.log.disabled inline #end
	public function log(verbosity:Int, value:Array<Any>, ?pos:PosInfos):Void {
		#if (!why.log.disabled)
		if(config.verbosity >= verbosity) {
			this.log(verbosity, {pos: pos, date: Date.now()}, value);
		}
		#end
	}
	
	#if (!why.log.disabled)
	static function __init__() {
		Config.load();
		Config.listen();
	}
	#end
	
}