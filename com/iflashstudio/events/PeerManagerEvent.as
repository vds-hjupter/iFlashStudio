/**
 * ...
 * @author Hjupter Cerrud [www.iflashstudio.com]
 * @Form Event for PeerManager Class
 * @version 0.1
 * ...
 */

package com.iflashstudio.events {
	import flash.events.Event;
	public class PeerManagerEvent extends Event {
		public static const ON_CONNECT:String = "onConnect";
		public static const ON_START:String = "onStart";
		public static const ON_PUBLISH:String = "onPublish";
		public static const ADD_PEER:String = "addPeer";
		public static const REMOVE_PEER:String = "removePeer";
		public static const ERROR:String = "onError";
		public var arg:*;
		public function PeerManagerEvent(type:String, customArg:*=null,bubbles:Boolean=false,cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			this.arg = customArg;
		}
		public override function clone():Event {
			return new PeerManagerEvent(type, arg, bubbles, cancelable);
		}
		public override function toString():String {
			return formatToString("PeerManagerEvent", "type", "arg","bubbles", "cancelable", "eventPhase");
		}
	}
}