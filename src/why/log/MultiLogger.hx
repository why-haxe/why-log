package why.log;

import haxe.PosInfos;

class MultiLogger extends Logger {
	final loggers:Array<Logger>;
	
	public function new(loggers, ?formatter) {
		super(formatter);
		this.loggers = loggers;
	}
	
	public function log(verbosity:Int, headers:Headers, value:Array<Any>):Void {
		for(logger in loggers) logger.log(verbosity, headers, value);
	}
}