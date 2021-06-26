package why.log;

interface Formatter {
	function format(headers:Headers, values:Array<Any>):String;
	function formatHeaders(headers:Headers):String;
	function formatValues(values:Array<Any>):String;
}