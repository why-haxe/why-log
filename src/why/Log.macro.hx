package why;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

abstract Log(Any) {
	static final POS_INFO_TYPE = Context.getType('haxe.PosInfos');
	
	public static macro function info(rest:Array<Expr>)
		return forward('INFO', rest);
	
	public static macro function error(rest:Array<Expr>)
		return forward('ERROR', rest);
	
	public static macro function warn(rest:Array<Expr>)
		return forward('WARN', rest);
	
	public static macro function debug(rest:Array<Expr>)
		return forward('DEBUG', rest);
	
	static inline function forward(level:String, rest:Array<Expr>) {
		final args = [macro why.Log.$level];
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