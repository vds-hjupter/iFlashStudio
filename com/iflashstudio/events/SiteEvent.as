package com.iflashstudio.events
{
	/**
	 * SiteEvent
	 *
	 * @date 			September 1, 2010
	 * @author			Hjupter Cerrud
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	 
	import flash.events.Event;
	
	public class SiteEvent extends Event {
		public static const COMPLETE:String = "complete";
		public static const PROGRESS:String = "progress";
		public static const ERROR:String = "error";
		public var arg:*;
		public function SiteEvent(type:String, customArg:*=null,bubbles:Boolean=false,cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.arg = customArg;
		}
		public override function clone():Event {
			return new SiteEvent(type, arg, bubbles, cancelable);
		}
		public override function toString():String {
			return formatToString("FormEvent", "type", "arg","bubbles", "cancelable", "eventPhase");
		}
	}
}