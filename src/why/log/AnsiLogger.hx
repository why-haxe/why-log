package why.log;

import haxe.PosInfos;

class AnsiLogger extends Logger {
	
	public inline static var ESCAPE:String = "\x1B";
	public inline static var CSI:String = ESCAPE+"[";
	
	public inline function log(verbosity:Int, headers:Headers, values:Array<Any>):Void {
		if(verbosity >= why.Log.DEBUG) debug(headers, values);
		else if(verbosity >= why.Log.INFO) info(headers, values);
		else if(verbosity >= why.Log.WARN) warn(headers, values);
		else if(verbosity >= why.Log.ERROR) error(headers, values);
	}
	
	inline function info(headers:Headers, values:Array<Any>):Void
		colored(Cyan, headers, values);
	
	inline function warn(headers:Headers, values:Array<Any>):Void
		colored(Yellow, headers, values);
	
	inline function error(headers:Headers, values:Array<Any>):Void
		colored(Red, headers, values);
	
	inline function debug(headers:Headers, values:Array<Any>):Void
		colored(Off, headers, values);
	
	function colored(color:AnsiValue, headers:Headers, values:Array<Any>):Void {
		final buf = new StringBuf();
		buf.add(csi(color));
		buf.add(formatter.format(headers, values));
		buf.add(csi(Off));
		Sys.println(buf.toString());
	}
	
	inline function csi(v:AnsiValue):String
		return CSI + v + 'm';
}

// https://github.com/SmilyOrg/ansi/blob/b0f43b49d08b76b6b0932ac2256a9b3bdc746548/src/ANSI.hx#L67-L102
private enum abstract AnsiValue(Int) to Int {
	final Off               = 0;
		
	final Bold              = 1;
	final Underline         = 4;
	final Blink             = 5;
	final ReverseVideo      = 7;
	final Concealed         = 8;
	
	final BoldOff           = 22;
	final UnderlineOff      = 24;
	final BlinkOff          = 25;
	final NormalVideo       = 27;
	final ConcealedOff      = 28;
	
	final Black             = 30;
	final Red               = 31;
	final Green             = 32;
	final Yellow            = 33;
	final Blue              = 34;
	final Magenta           = 35;
	final Cyan              = 36;
	final White             = 37;
	final DefaultForeground = 39;
	
	final BlackBack         = 40;
	final RedBack           = 41;
	final GreenBack         = 42;
	final YellowBack        = 43;
	final BlueBack          = 44;
	final MagentaBack       = 45;
	final CyanBack          = 46;
	final WhiteBack         = 47;
	final DefaultBackground = 49;
}