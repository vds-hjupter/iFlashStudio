package com.iflashstudio.utils{

	/**
	 * Environment
	 *
	 * @date 			September 1, 2010
	 * @author			Hjupter Cerrud
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */

	import flash.system.Security;
	import flash.system.Capabilities;
	import flash.net.LocalConnection;

	public class Environment{

		public static function get IS_IN_BROWSER():Boolean {
			return (Capabilities.playerType == "PlugIn" || Capabilities.playerType == "ActiveX");
		}

		public static function get DOMAIN():String{
			return new LocalConnection().domain;
		}

		public static function get IS_DOMAIN(domain:String):Boolean{
			return (DOMAIN == domain);
		}

		public static function get IS_IN_AIR():Boolean {
			return Capabilities.playerType == "Desktop";
		}
		public static function get IS_ON_SERVER():Boolean {
			//ds: 'remote' (Security.REMOTE) — This file is from an Internet URL and operates under domain-based sandbox rules.
			return Security.sandboxType == Security.REMOTE;
		}
	}
}