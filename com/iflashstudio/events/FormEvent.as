/**
 * ...
 * @author Hjupter Cerrud [www.iflashstudio.com]
 * @Form Event for Form Class
 * @version 0.1
 * ...
 */

package com.iflashstudio.events {
	import flash.events.Event;
	public class FormEvent extends Event {
		public static const INVALID:String = "invalid";
		public static const FILLED:String = "filled";
		public static const COMPLETE:String = "complete";
		public var arg:*;
		public function FormEvent(type:String, customArg:*=null,bubbles:Boolean=false,cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.arg = customArg;
		}
		public override function clone():Event {
			return new FormEvent(type, arg, bubbles, cancelable);
		}
		public override function toString():String {
			return formatToString("FormEvent", "type", "arg","bubbles", "cancelable", "eventPhase");
		}
	}
}