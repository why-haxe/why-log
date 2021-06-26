package why;

import haxe.macro.Context;
import haxe.macro.Expr;

abstract Log(Any) {
	public static macro function info(rest:Array<Expr>)
		return macro @:pos(Context.currentPos()) why.Log.logger.log(why.Log.INFO, ${macro $a{rest}});
	
	public static macro function error(rest:Array<Expr>)
		return macro @:pos(Context.currentPos()) why.Log.logger.log(why.Log.ERROR, ${macro $a{rest}});
	
	public static macro function warn(rest:Array<Expr>)
		return macro @:pos(Context.currentPos()) why.Log.logger.log(why.Log.WARN, ${macro $a{rest}});
	
	public static macro function debug(rest:Array<Expr>)
		return macro @:pos(Context.currentPos()) why.Log.logger.log(why.Log.DEBUG, ${macro $a{rest}});
	
}