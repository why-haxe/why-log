package why;

import haxe.macro.Context;
import haxe.macro.Expr;

abstract Log(Any) {
	public macro function info(ethis, rest:Array<Expr>)
		return macro @:pos(Context.currentPos()) $ethis.log(why.Log.INFO, ${macro $a{rest}});
	
	public macro function error(ethis, rest:Array<Expr>)
		return macro @:pos(Context.currentPos()) $ethis.log(why.Log.ERROR, ${macro $a{rest}});
	
	public macro function warn(ethis, rest:Array<Expr>)
		return macro @:pos(Context.currentPos()) $ethis.log(why.Log.WARN, ${macro $a{rest}});
	
	public macro function debug(ethis, rest:Array<Expr>)
		return macro @:pos(Context.currentPos()) $ethis.log(why.Log.DEBUG, ${macro $a{rest}});
	
}