package why.log;

typedef Config = {
	verbosity:Int,
	formatter:{
		showPosition:Bool,
		showDate:Bool,
		normalizePath:Bool,
		inspect:Bool,
	}
}