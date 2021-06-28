package why.log;

using haxe.io.Path;

class DefaultFormatter implements Formatter {
	public static final INST = new DefaultFormatter();
	
	function new() {}
	
	public function format(headers:Headers, values:Array<Any>):String {
		return formatHeaders(headers) + formatValues(values);
	}
	
	public function formatHeaders(headers:Headers):String {
		final config = why.Log.config.formatter;
		final buf = new StringBuf();
		if(config.showDate) buf.add(headers.date.toString() + ': ');
		if(config.showPosition) buf.add((config.normalizePath ? headers.pos.fileName.normalize() : headers.pos.fileName) + ':' + headers.pos.lineNumber + ': ');
		return buf.toString();
	}
	
	public function formatValues(values:Array<Any>):String {
		final config = why.Log.config.formatter;
		#if nodejs
		if(config.inspect)
			values = values.map(v -> js.node.Util.inspect(v, {colors: true, compact: false}));
		#end
		return values.map(Std.string).join(', ');
	}
	
}