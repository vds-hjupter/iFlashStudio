package com.iflashstudio.debug{
	
	/**
	 * ButtonItem
	 *
	 * @date 			September 1, 2010
	 * @author			Hjupter Cerrud
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	 
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.system.Security;
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class Debug
	{	
		private static var isBrowser:Boolean = (Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn");
		private static var isConsole:Boolean = ExternalInterface.available && (Security.sandboxType == "remote" || Security.sandboxType == "localTrusted");
		
		public static function log(...args):void
		{
			try
			{
				MonsterDebugger.trace(Debug, args.join(", "));
				if (isBrowser && isConsole) ExternalInterface.call("console.log" , args);
			}
			catch (error:Error)
			{
				//
			}
			trace.apply(null, args);
		}
		public static function error(...args):void
		{
			try
			{
				MonsterDebugger.trace(Debug, args.join(", "), 0xCC0000);
				if (isBrowser && isConsole) ExternalInterface.call("console.error" , args);
			}
			catch (error:Error)
			{
				//
			}
			trace.apply(null, args);
		}
		public static function warn(...args):void
		{
			try
			{
				MonsterDebugger.trace(Debug, args.join(", "), 0xFF8800);
				if (isBrowser && isConsole) ExternalInterface.call("console.warn" , args);
			}
			catch (error:Error)
			{
				//
			}
			trace.apply(null, args);
		}
	}
}