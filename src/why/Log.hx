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
	public static var config:Config;
	
	// global instance
	public static var logger:Log;
	
	// forward calls
	public macro function info();
	public macro function error();
	public macro function warn();
	public macro function debug();
	
	// configure
	public function log(verbosity:Int, value:Array<Any>, ?pos:PosInfos):Void {
		if(config.verbosity >= verbosity) {
			this.log(verbosity, {pos: pos, date: Date.now()}, value);
		}
	}
	
	// for those who want to replace stock trace
	public static function trace(v:Dynamic, ?pos:PosInfos) {
		logger.log(DEBUG, switch pos.customParams {
			case null: [v];
			case params: [v].concat(params);
		}, pos);
	}
	
	static function __init__() {
		loadConfig();
		listen();
	}
	
	static function listen() {
		#if js
			if(js.Syntax.code('"addEventListener" in {0}', js.Lib.global))
				js.Lib.global.addEventListener('why.log.configChanged', loadConfig);
			#if nodejs
			js.Node.process.on('SIGHUP', loadConfig);
			#end
		#end
	}
	
	static function loadConfig() {
		final conf:Config = try haxe.Json.parse(sys.io.File.getContent('.whylogrc')) catch(_) cast {};
		// TODO: load from localStorage on browser
		
		if(config == null) config = cast {};
		config.verbosity = switch conf.verbosity {
			case null: 100;
			case v: v;
		}
		
		if(config.formatter == null) config.formatter = cast {};
		config.formatter.showDate = switch conf.formatter {
			case null | {showDate: null}: true;
			case {showDate: v}: v;
		}
		config.formatter.showPosition = switch conf.formatter {
			case null | {showPosition: null}: true;
			case {showPosition: v}: v;
		}
		config.formatter.normalizePath = switch conf.formatter {
			case null | {normalizePath: null}: true;
			case {normalizePath: v}: v;
		}
		config.formatter.inspect = switch conf.formatter {
			case null | {inspect: null}: true;
			case {inspect: v}: v;
		}
	}
}