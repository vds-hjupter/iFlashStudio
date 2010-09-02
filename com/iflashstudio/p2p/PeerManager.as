package com.iflashstudio.p2p
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.Timer;
	import org.bytearray.remoting.Service;
	import org.bytearray.remoting.PendingCall;
	import org.bytearray.remoting.events.ResultEvent;
	import org.bytearray.remoting.events.FaultEvent;
	import com.iflashstudio.events.PeerManagerEvent;
	
	public class PeerManager extends MovieClip
	{	
		public var SERVER:String;
		public var DEV_KEY:String;
		public var GATE_WAY:String;
		public var TIME_OUT:int;
		public var GETPEERS_DELAY:int;
		public var KEEPALIVE_DELAY:int;		
					
		private var rpc:PendingCall;
		private var peerName:String;		

		public static var service:Service;	
		public static var stream:NetStream;		
		public static var connection:NetConnection;
		
		protected var currPeer:Peer;
		protected var currentPeers:Array = new Array();
		protected var aliveTimer:Timer;
		protected var peersTimer:Timer;
		
		//*** CONSTUCTOR ***//
		public function PeerManager(gateWay:String = "http://www.iflashstudio.com/amfphp/gateway.php",key:String = "5528df00cb2d563e4946e4c2-a9013114ff51",server:String = "rtmfp://stratus.adobe.com",timeOut:int = 10000,getPeersDelay:int = 10000,keepAliveDelay:int = 2000)
		{
			SERVER = server;
			DEV_KEY = key;
			GATE_WAY = gateWay;
			TIME_OUT = timeOut;
			GETPEERS_DELAY = getPeersDelay;
			KEEPALIVE_DELAY = keepAliveDelay;
			
			aliveTimer = new Timer(KEEPALIVE_DELAY,0);
			peersTimer = new Timer(GETPEERS_DELAY,0);
			
			service = Service.getInstance();		
			service.setRemoteInfos(GATE_WAY,"PeerManager",ObjectEncoding.AMF3);
			
			aliveTimer.addEventListener(TimerEvent.TIMER,updatePeer);
			peersTimer.addEventListener(TimerEvent.TIMER,getPeers);
		}		
		
		//*** STATUS CONNECTION ***//
		public function connect(str:String):void{
			peerName = str;
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncErr);
			connection.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);		
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(SERVER + "/" + DEV_KEY);
		}
		
		// Connections success
		private function connectSuccess(nearID : String):void{
			currPeer = new Peer(nearID,peerName,new Date());			
			trace("#PeerManager# Saving data...");
			rpc = service.register(currPeer.name,currPeer.peerId);			
			rpc.addEventListener(ResultEvent.RESULT, createPeerResultHandler);			
			rpc.addEventListener(FaultEvent.FAULT, errorHandler);
			rpc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,asyncErr);
			rpc.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			rpc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			rpc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		protected function createPeerResultHandler(r:ResultEvent):void{			
			currPeer.peerId = r.result.peerId;
			
			if(!currPeer.peerId){
				trace("#PeerManager# Peer name is been used.. Try another name!");
				dispatchEvent(new PeerManagerEvent(PeerManagerEvent.ERROR, "exists"));
			} else {
				trace("#PeerManager# Created as Peer ID# "+currPeer.peerId+"... Fetching All Active Peers");		
	
				rpc = service.allActive();			
				rpc.addEventListener(ResultEvent.RESULT, getPeersResult);			
				rpc.addEventListener(FaultEvent.FAULT, errorHandler);
	
				aliveTimer.start();
				peersTimer.start();
				
				dispatchEvent(new PeerManagerEvent(PeerManagerEvent.ON_START, currPeer));
				
				stream = new NetStream(connection, NetStream.DIRECT_CONNECTIONS);
				stream.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
				stream.publish("media");				
			}		
		}	
		
		// NetConnection Event Handler
		private function netStatusHandler(e:NetStatusEvent):void{
			var currFarID:String;
			for each(var obj:* in e.info){
				if(obj is NetStream){
					currFarID = obj.farID;
				}
			}
			trace("#PeerManager# netStatus - "+e.info.code);
			switch (e.info.code){
				case "NetConnection.Connect.Success":
					connectSuccess(e.target.nearID);
					dispatchEvent(new PeerManagerEvent(PeerManagerEvent.ON_CONNECT, currPeer));
					break;
				case "NetStream.Connect.Success":
					getPeers(null);
					break;
				case "NetConnection.Call.BadVersion":
					trace("BadVersion "+e);
					break;
				case "NetConnection.Call.Failed":
				case "NetConnection.Connect.Failed":
					break;	
				case "NetConnection.Connect.Closed":
				case "NetConnection.Connect.Failed":
				case "NetConnection.Connect.Rejected":
				case "NetConnection.Connect.AppShutdown":
				case "NetConnection.Connect.InvalidApp":
				case "NetStream.Connect.Rejected":
				case "NetStream.Connect.Failed":
				case "NetStream.Connect.Closed":
					for(var i:int = 0; i<currentPeers.length; i++){
						var p:* = currentPeers[i];
						if(p.peerId == currFarID){
							removePeer(p);
						}
					}
					break;
				case "NetStream.Publish.Start":
				case "NetStream.Play.Start":
				case "NetStream.Play.Reset":
					if(currPeer.name){
						dispatchEvent(new PeerManagerEvent(PeerManagerEvent.ON_PUBLISH, currPeer));
						trace("Send initial peer info..");
					}
					break;	
			}
		}		
			
		/**
		 * This timer handler is called every few seconds when the timer fires
		 * It will call the remote object update peer method.
		 */
		protected function updatePeer(e:TimerEvent):void{
			//trace("Touching server...");
			rpc = service.update(currPeer.name);			
		}
		
		protected function getPeers(e:TimerEvent):void{
			trace("#PeerManager# Getting all peers...");
			rpc = service.allActive();			
			rpc.addEventListener(ResultEvent.RESULT, getPeersResult);			
			rpc.addEventListener(FaultEvent.FAULT, errorHandler);
		}	
		
		/**
		 * This remote object handler slaps all the active peers into an arraycollection,
		 * and then I pull out the current user from the list.
		 */
		protected function getPeersResult(e:ResultEvent):void{
			var activePeers:Array = e.result as Array;			
			var i:int;
			for(i = 0; i<activePeers.length; i++){
				var p:* = activePeers[i];						
				if(p.peerId == currPeer.peerId){
					continue;
				}
				if(currentPeersContains(p)){
					continue;
				} else {
					addPeer(p);
				}
			}
			var found:Boolean = false;
			for(i = 0; i<currentPeers.length; i++){
				var p1:* = currentPeers[i];
				found = false;
				for(var f:int = 0; f<activePeers.length; f++){
					var p2:* = activePeers[f];
					if(p1.name == p2.name){
						found = true;
						break;
					}
				}
				if(!found){
					removePeer(p1);
				}
			}
		}
		
		// Check if Peer exist on currentPeers array
		private function currentPeersContains(peer:*):Boolean{
			for(var i:int = 0; i<currentPeers.length; i++){
				var p:* = currentPeers[i];
				if(p.name == peer.name){
					return true;
				}
			}
			return false;
		}
		
		// Add New Peer
		private function addPeer(peer:*):void{
			trace("#PeerManager# New peer added: "+peer.name+" - peerId: "+peer.peerId);
			dispatchEvent(new PeerManagerEvent(PeerManagerEvent.ADD_PEER, peer));
			/*var player:MovieClip = new Player(peer,{nc:connection,initialHealth:peer.health,level:peer.level,experience:peer.experience,nextLevelExp:peer.nextLevelExp});
			player.x = -100;
			player.y = -100;
			enableButton(player);
			mainMC.addChild(player);*/
			currentPeers.push(peer);
		}
		
		// Remove Peer
		private function removePeer(peer:*):void{			
			trace("#PeerManager# Removing peer: "+peer.name);
			currentPeers = removeByItem(currentPeers,peer);		
			rpc = service.unRegister();
			dispatchEvent(new PeerManagerEvent(PeerManagerEvent.REMOVE_PEER, peer));
			/*
			var t:MovieClip = mainMC.getChildByName("player_"+peer.name) as MovieClip;
			if(targetInfo.t == t){
				targetInfo.t = null;
				targetInfo.visible = false;				
			}
			TweenMax.to(t,1.5,{overwrite:2,delay:.2,autoAlpha:0,colorMatrixFilter:{brightness:-2,contrast:-2},ease:Expo.easeOut,onComplete:function(){
				mainMC.removeChild(t);
			}});*/	
			
		}
		
		// Remove an item from array
		public function removeByItem(array:Array, target:*):Array{
			for(var i:int = 0; i<array.length; i++){
				if(array[i] == target){
					removeByIndex(array,i);
					break;
				}
			}
			return array;
		}
		
		// Remove from array by index
		public function removeByIndex(array:Array, removeValue:Number):Array{
			array.splice(removeValue,1);
			return array;
		}
		
		//*** ERROR HANDLERS ***//	
		
		// AMFPHP Error Handler
		private function errorHandler(r:FaultEvent):void{			
			for(var test in r.fault){
				trace("AMFPHP ERROR: "+r.fault[test]);
			}
		}		
		// Async error handler
		private function asyncErr(e:AsyncErrorEvent):void{
       		trace("ASYNC ERROR: "+e);
        }
		// IO error handler
		private function ioErrorHandler(e:IOErrorEvent):void{
       		trace("IO ERROR: "+e);
        }
		// Security error handler
		private function securityErrorHandler(e:SecurityErrorEvent):void{
       		trace("SECURITY ERROR: "+e);
        }
		
		//*** GETTERS ***//
		
		// Get Total Peers
		public function get totalPeers():int{
			return int(currentPeers.length+1);
		}
	}
}
