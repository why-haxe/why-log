package why.log;

using haxe.io.Path;
using sys.FileSystem;
using sys.io.File;

typedef ConfigObject = {
	verbosity:Int,
	formatter:{
		showPosition:Bool,
		showDate:Bool,
		normalizePath:Bool,
		inspect:Bool,
	}
}
@:forward
abstract Config(ConfigObject) from ConfigObject to ConfigObject {
	public static var INST:Config;
	public static inline final CONFIG_FILENAME = 'whylog.json';
	
	public static function listen() {
		#if js
			if(js.Syntax.code('"addEventListener" in {0}', js.Lib.global))
				js.Lib.global.addEventListener('why.log.configChanged', load);
			#if nodejs
			js.Node.process.on('SIGHUP', load);
			#end
		#end
	}
	
	public static function load() {
		final json = 
			#if (sys || nodejs) {
				inline function join(parts:...String) return haxe.io.Path.join(parts.toArray());
				inline function tryRead(path:String) return path.exists() && !path.isDirectory() ? path.getContent() : null;
				function tryReadAll(paths:Array<String>) {
					for(path in paths) switch tryRead(path) {
						case null: // continue
						case v:
							return v;
					}
					return '';
				}
				
				tryReadAll([
					join(Sys.programPath().directory(), CONFIG_FILENAME),
					join(Sys.getCwd(), CONFIG_FILENAME),
					// TODO: global config?
				]);
			}
			#else
			'';
			// TODO: load from localStorage on browser
			#end
			
		final conf:Config = try haxe.Json.parse(json) catch(_) cast {};
		
		if(INST == null) INST = cast {};
		INST.verbosity = switch conf.verbosity {
			case null: 100;
			case v: v;
		}
		
		if(INST.formatter == null) INST.formatter = cast {};
		INST.formatter.showDate = switch conf.formatter {
			case null | {showDate: null}: false;
			case {showDate: v}: v;
		}
		INST.formatter.showPosition = switch conf.formatter {
			case null | {showPosition: null}: true;
			case {showPosition: v}: v;
		}
		INST.formatter.normalizePath = switch conf.formatter {
			case null | {normalizePath: null}: true;
			case {normalizePath: v}: v;
		}
		INST.formatter.inspect = switch conf.formatter {
			case null | {inspect: null}: false;
			case {inspect: v}: v;
		}
	}
}
