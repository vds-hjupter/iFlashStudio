package com.iflashstudio.utils {
	
	import flash.display.*;
	import flash.utils.getDefinitionByName;
	import com.iflashstudio.debug.Debug;
	
	public final class Pool {
		
		private static var MAX_VALUE:uint;
		private static var GROWTH_VALUE:uint;
		private static var counter:uint;
		private static var pool:Vector.<*>;
		private static var current:*;
		private static var Item:Class;
		
		public static function init(object:String, maxPoolSize:uint = 2):void {
			Item = getDefinitionByName(object) as Class;
			MAX_VALUE = maxPoolSize;
			GROWTH_VALUE = MAX_VALUE >> 1;
			counter = maxPoolSize;
			var i:uint = maxPoolSize;
			pool = new Vector.<*> (MAX_VALUE);
			while ( --i > -1 ) {
				Debug.log("Pool: item "+i+" created!")
				pool[i] = new Item();
			}
		}
		
		public static function getObject():* {
			if (counter > 0) {
				return current = pool[--counter];
			}
			var i:uint = GROWTH_VALUE;
			while ( --i > -1 ) {
				pool.unshift(new Item());
			}
			counter = GROWTH_VALUE;
			return getObject();
		}
		
		public static function dispose(disposedObject:*):void {
			disposedObject = disposedObject.parent.removeChild(disposedObject);
			Debug.log("Pool: "+disposedObject.name+" Disposed!");
			pool[counter++] = disposedObject;
		}
	}
}