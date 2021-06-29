package why.log;

import haxe.PosInfos;

abstract Timer(()->String){
	
	public inline function new(name:String) {
		#if (!why.log.disabled && !why.log.no_timer)
		final start = haxe.Timer.stamp();
		this = () -> {
			final dt = haxe.Timer.stamp() - start;
			'$name took ${Std.int(dt * 1000)}ms';
		}
		#else
		this = null;
		#end
	}
	
	public inline function end(?pos:PosInfos) {
		#if (!why.log.disabled && !why.log.no_timer) why.Log.debug(this(), pos); #end
	}
}


#if tink_core
class PromiseTools {
	public static inline function measure<T>(promise:tink.core.Promise<T>, name:String, ?pos:PosInfos):tink.core.Promise<T> {
		#if (!why.log.disabled && !why.log.no_timer) 
		final timer = new Timer(name);
		return promise.map(v -> {
			timer.end(pos);
			v;
		});
		#else
		return promise;
		#end
	}
}

class FutureTools {
	public static inline function measure<T>(future:tink.core.Future<T>, name:String, ?pos:PosInfos):tink.core.Future<T> {
		#if (!why.log.disabled && !why.log.no_timer) 
		final timer = new Timer(name);
		return future.map(v -> {
			timer.end(pos);
			v;
		});
		#else
		return future;
		#end
	}
}

#end