package why.log;

import haxe.PosInfos;

abstract class Logger {
	final formatter:Formatter;
	
	public function new(?formatter)
		this.formatter = formatter == null ? DefaultFormatter.INST : formatter;
	
	abstract public function log(verbosity:Int, headers:Headers, values:Array<Any>):Void;
	
}