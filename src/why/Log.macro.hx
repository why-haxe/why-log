package why;

import haxe.macro.Context;
import haxe.macro.Expr;

abstract Log(Any) {
	public static macro function info(rest:Array<Expr>)
		return forward('INFO', rest);
	
	public static macro function error(rest:Array<Expr>)
		return forward('ERROR', rest);
	
	public static macro function warn(rest:Array<Expr>)
		return forward('WARN', rest);
	
	public static macro function debug(rest:Array<Expr>)
		return forward('DEBUG', rest);
	
	static inline function forward(level:String, rest:Array<Expr>)
		return macro @:pos(Context.currentPos()) why.Log.logger.log(why.Log.$level, $a{pack(rest)});
	
	static inline function pack(arr:Array<Expr>)
		return arr.map(e -> macro cast $e);
}