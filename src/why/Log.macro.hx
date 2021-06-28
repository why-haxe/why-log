package why;

import haxe.macro.Context;
import haxe.macro.Expr;

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
		final pos = 
			if(Context.unify(Context.typeof(rest[rest.length - 1]), POS_INFO_TYPE)) {
				final pos = rest.pop();
				args.push(macro $a{pack(rest)});
				args.push(pos);
			} else {
				args.push(macro $a{pack(rest)});
			}
			
		return macro @:pos(Context.currentPos()) why.Log.logger.log($a{args});
	}
	
	static inline function pack(arr:Array<Expr>)
		return arr.map(e -> macro cast $e);
}