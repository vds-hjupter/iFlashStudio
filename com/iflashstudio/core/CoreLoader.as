package com.iflashstudio.core
{
	
	/**
	 * CoreLoader
	 *
	 * @date 			September 1, 2010
	 * @author			Hjupter Cerrud
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	
	import flash.display.*;
	import flash.events.Event;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	import com.greensock.events.LoaderEvent;
	import com.iflashstudio.debug.Debug;
	
	public class CoreLoader extends MovieClip{	
	
		public static var main:*;
		public var lang:String;
		public var xml:String = (!stage.loaderInfo.parameters.xml) ? "xml/site.xml" : stage.loaderInfo.parameters.xml;	
		public var swf:String;
		
		public function CoreLoader(){
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;			
			swf = (!stage.loaderInfo.parameters.swf) ? "main.swf" : stage.loaderInfo.parameters.swf;		
			lang = (!stage.loaderInfo.parameters.lang) ? "en" : stage.loaderInfo.parameters.lang;
			main = this;
			var loader:SWFLoader = new SWFLoader(swf, {name:"mainSWF", container:this, onProgress:_progressHandler, onComplete:_completeHandler, onError:_errorHandler, integrateProgress:true});
			loader.load(true);
		}
		
		// Progress Handler
		public function _progressHandler(e:LoaderEvent):void {
			(!main.root.progressHandler) ? Debug.error("Define 'progressHandler' function on your 'Preloader.as' Class - function progressHandler(n:Number)") : main.root.progressHandler(e.target.progress);
		}
		
		// Complete Handler
		public function _completeHandler(e:LoaderEvent):void {
			(!main.root.completeHandler) ? Debug.error("Define 'completeHandler' function on your 'Preloader.as' Class - function completeHandler(t:MovieClip)") : main.root.completeHandler(e.target.rawContent as MovieClip);
		}
		
		// Error handler
		private function _errorHandler(e:LoaderEvent):void{
       		Debug.error("#Preload ERROR: "+e);
        }
	}
}
