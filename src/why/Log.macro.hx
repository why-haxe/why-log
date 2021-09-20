package why;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using tink.MacroApi;

abstract Log(Any) {
	static final POS_INFO_TYPE = Context.getType('haxe.PosInfos');
	
	public static macro function debug(rest:Array<Expr>)
		return forward(macro why.Log.DEBUG, rest);
	
	public static macro function info(rest:Array<Expr>)
		return forward(macro why.Log.INFO, rest);
	
	public static macro function warn(rest:Array<Expr>)
		return forward(macro why.Log.WARN, rest);
	
	public static macro function error(rest:Array<Expr>)
		return forward(macro why.Log.ERROR, rest);
	
	public static macro function custom(level:Int, rest:Array<Expr>)
		return forward(macro $v{level}, rest);
	
	public static macro function peek(v:Expr) {
		final pos = Context.currentPos();
		final ct = switch Context.getExpectedType() {
			case null: pos.makeBlankType();
			case type: type.toComplex({ direct: true });
		}
		
		return macro {
			final e:$ct = $v;
			@:pos(pos) why.Log.logger.log(DEBUG, [e]);
			e;
		}
	}
	
	static inline function forward(level:Expr, rest:Array<Expr>) {
		final args = [level];
		final lastArgIsPos = (function isPos(type:Type) {
			return switch type {
				case TAbstract(_.get() => {pack: [], name: 'Null'}, [sub]): isPos(sub);
				case TType(_.get() => {pack: ['haxe'], name: 'PosInfos'}, _): true;
				case _: false;
			}
		})(Context.typeof(rest[rest.length - 1]));
		
		if(lastArgIsPos) {
			final pos = rest.pop();
			args.push(macro $a{pack(rest)});
			args.push(pos);
		} else {
			args.push(macro $a{pack(rest)});
		}
			
		return macro @:pos(Context.currentPos()) why.Log.logger.log($a{args});
	}
	
	static macro function wrap(level:Expr, call:Expr) {
		return 
			if(Context.defined('why.log.disabled')) macro null;
			else switch Context.definedValue('why.log.verbosity') {
				case null: call;
				case max: macro if($level <= $v{Std.parseInt(max)}) $call;
			}
	}
	
	static inline function pack(arr:Array<Expr>)
		return arr.map(e -> macro cast $e);
}