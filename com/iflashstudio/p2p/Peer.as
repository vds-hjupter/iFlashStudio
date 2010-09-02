package com.iflashstudio.p2p
{
	import flash.display.MovieClip;
	
	public class Peer extends MovieClip{		
	
		public var id:int;
		public var peerId:String;		
		public var stamp:Date;
		public var ip:String;
		public var roomId:int;
		
		public function Peer($peerid, $name, $stamp){
			peerId = $peerid;
			name = $name;
			stamp = $stamp;
		}		
	}
}
