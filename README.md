# Simple Logging Library

This logging library mainly focuses on main feature: runtime config reload.

## Runtime Config Reload

For long running programs such as servers,
we usually don't want to set a log too detailedly
because that will generate enormous amount of log files.
However, when something happens and we will need higher verbosity
to investigate the problem. But for various reasons (deploy time, lost of state, etc)
we don't want to restart the server just to change the logging verbosity.
This is where runtime config reload comes to rescue. Just change the settings via
a config file and then send a `SIGHUP` signal to the running process.
Then the logging behaviour will change instantly. After the investigation,
you can update the config again to log less and save some
disk space.

## Log Config File Format (JSON)

```haxe
typedef Config = {
	verbosity:Int,
	formatter:{
		showPosition:Bool, // show trace-like position
		showDate:Bool, // show datetime
		normalizePath:Bool, // normalize source path
		inspect:Bool, // inspect objects (nodejs only)
	}
}
```

## Compiler Flags

- `why.log.disabled`: Disable all why-log features
- `why.log.verbosity=N`: Set a compile-time verbosity (to generate less code)

**TODO**
- Implement `SIGHUP` handling on all sys platforms.