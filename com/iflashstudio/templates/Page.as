package com.iflashstudio.templates{
	
	/**
	 * Page
	 *
	 * @date 			September 1, 2010
	 * @author			Hjupter Cerrud
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */

	import flash.display.MovieClip;
	import com.iflashstudio.events.PageEvent;
	import com.iflashstudio.core.SiteCore;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	import flash.events.Event;

	public class Page extends MovieClip {

		public var url:String;
		public var title:String;
		public var params:*;
		public var main:Object;
		private var _api:Object;

		public function Page() {
			LoaderMax.activate([ImageLoader, SWFLoader, DataLoader, MP3Loader, VideoLoader]);
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);			
			main = Object(this.root);
		}
		
		private function onAdded(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);				
		}
		
		public function get assets():Object{
			return {};
		}
		
		public function set api(o:Object):void{
			_api = o;
		}
		
		public function get api():Object{
			return _api;
		}

		public function transitionInComplete():void {
			dispatchEvent(new PageEvent(PageEvent.TRANSITION_IN_COMPLETE));
		}
		public function transitionOutComplete():void {
			dispatchEvent(new PageEvent(PageEvent.TRANSITION_OUT_COMPLETE));
		}

	}

}