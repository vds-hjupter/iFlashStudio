package com.iflashstudio.core{
	
	/**
	 * SiteCore
	 *
	 * @date 			September 1, 2010
	 * @author			Hjupter Cerrud
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	
	import flash.display.*;
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	import com.greensock.events.LoaderEvent;
	
	import com.iflashstudio.utils.*;
	import com.iflashstudio.core.*;
	import com.iflashstudio.events.*;
	import com.iflashstudio.debug.Debug;
	import com.iflashstudio.ui.*;
	
	//import com.google.analytics.AnalyticsTracker; 
	//import com.google.analytics.GATracker; 
	
	public class SiteCore extends MovieClip {
		
		// Version
		private const VERSION:Number = 0.3;
		public static var test:SiteCore;
		public static var main:*;
		public var xml:XML;
		public var pageContainer:MovieClip;
		public var pagesXMLList:XMLList;
		public var navXMLList:XMLList;
		public var defaultPageName:String;
		public var defaultPageLoader:SWFLoader;
		public var currentPageName:String;
		public var currentPage:ContentDisplay;
		public var lastPageName:String;
		public var lastPage:ContentDisplay;
		public var nav:SiteNavigation;
		public var tracing:Boolean = true;
		//public var tracker:AnalyticsTracker;
		
		private var mainLoaded:Boolean;
		private var pagesLoaded:Array = [];
		private var queue:LoaderMax;		

		public function SiteCore() {
			main = this;
			//tracing = new GATracker(this, "window.pageTracker", "AS3", false);
			LoaderMax.activate([ImageLoader, SWFLoader, DataLoader, MP3Loader]);			
			pageContainer = new MovieClip();
			addChild(pageContainer);			
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);			
			
			(!main.root.preloader) ? Debug.error("'preloader' MovieClip not found!") : main.root.preloader.alpha = 0;
			queue = new LoaderMax({name:"pageQueue", container:pageContainer,onOpen:openHandler,onComplete:_completeHandler,onProgress:_progressHandler, integrateProgress:true});
		}
		
		//*****************************//
		//***** PRIVATE FUNCTIONS *****//
		//*****************************//
		
		// onAdded to Stage
		private function onAdded(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);		
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Debug.log("FlashSite Framework "+version);
			var mainQueue:LoaderMax = new LoaderMax({onComplete:xmlCompleteHandler, onError:errorHandler, requireWithRoot:this.root});
			var loader:XMLLoader = new XMLLoader((!CoreLoader.main) ? "xml/site.xml" : CoreLoader.main.xml, {name:"xmlSite", requireWithRoot:main.root});
			mainQueue.append(loader);
			mainQueue.load();
		}
		
		// Init Handler
		private function openHandler(e:LoaderEvent):void {			
			TweenMax.to(main.root.preloader,.3,{autoAlpha:1,delay:.3});
		}
		
		// Progress Handler
		private function _progressHandler(e:LoaderEvent):void {
			(!main.root.progressHandler) ? Debug.error("Define 'progressHandler' function on your 'Main.as' Class - function progressHandler(n:Number)") : main.root.progressHandler(e.target.progress);
		}
		
		// Error Handler
		private function errorHandler(e:LoaderEvent):void{
			Debug.error("Error occured with " + e.target + ": " + e.text);
			dispatchEvent(new SiteEvent(SiteEvent.ERROR,{target:e.target,text:e.text}));
		}
		
		// XML Complete Handler
		private function xmlCompleteHandler(e:LoaderEvent):void {
			xml = LoaderMax.getContent("xmlSite");
			pagesXMLList = xml.menu.SWFLoader;					
			navXMLList = xml.menu.SWFLoader.(@menu != "false");	
			nav = new SiteNavigation(navXMLList);
			defaultPageName = getDefaultPageName();
			if(tracing)Debug.log("Main load Completed!");
			(!main.root.completeHandler) ? Debug.error("Define 'completeHandler' function on your 'Main.as' Class - public function completeHandler():void") : main.root.completeHandler();
			setPage(defaultPageName);
		}	
		
		// Complete Handler
		private function _completeHandler(e:LoaderEvent):void {
			TweenMax.to(main.root.preloader,.3,{autoAlpha:0,overwrite:1});
			TweenMax.to(this,.3,{onComplete:setPage,onCompleteParams:[currentPageName]});
		}	
		
		// Set Page
		private function setPage(n:String):void{
			while(pageContainer.numChildren){
				pageContainer.removeChildAt(0);
			}
			currentPageName = n;
			currentPage = LoaderMax.getContent(currentPageName);
			if(currentPage){
				if(!ArrayUtils.inArray(pagesLoaded,currentPage)){
					if(tracing)Debug.log(currentPageName+" Page Loaded!");	
					pagesLoaded.push(currentPage);
					currentPage.rawContent.addEventListener(PageEvent.TRANSITION_IN_COMPLETE, pageHandler);
					currentPage.rawContent.addEventListener(PageEvent.TRANSITION_OUT_COMPLETE, pageHandler);
					currentPage.rawContent.api = this;
				}
				pageContainer.addChild(currentPage);
				(!currentPage.rawContent.transitionIn) ? Debug.error("There is no transitionIn function on "+currentPage.name+" page") : currentPage.rawContent.transitionIn(this);
				
				lastPage = currentPage;
				lastPageName = currentPageName;
			}
		}
		
		// Get Default Page
		private function getDefaultPageName():String{
			var s:String;
			for(var i:int = 0; i<pagesXMLList.length(); i++){
				var n = pagesXMLList[i];
				if(n.@load){
					if(n.@load == "true"){
						s = n.@name;
					}
				}
			}
			return s;
		}
		
		// Get URL by page name
		private function getPageUrl(name:String):String{
			var s:String;
			for(var i:int = 0; i<pagesXMLList.length(); i++){
				var n = pagesXMLList[i];
				if(n.@name == name){
					s = n.@url;
				}
			}
			return s;
		}
		
		// Page Handler
		private function pageHandler(e:*):void{	
			switch(e.type){
				case PageEvent.TRANSITION_OUT_COMPLETE:
					if(tracing)Debug.log(lastPageName+" Transition Out Complete!");
					ArrayUtils.removeByItem(pagesLoaded,lastPage);					
					lastPage.dispose();
					lastPage = null;
					gotoPage(currentPageName);
					break;
				case PageEvent.TRANSITION_IN_COMPLETE:
					if(tracing)Debug.log(currentPageName+" Transition In Complete!");
					break;
			}
		}
		
		//*****************************//
		//***** PUBLIC FUNCTIONS ******//
		//*****************************//
		
		// Go to Page		
		public function gotoPage(n:String):void{
			if(queue.status != 2){
				queue.cancel();
			}
			currentPageName = n;
			if(lastPage){				
				if(tracing)Debug.log("Unloading page: "+lastPage.name);
				(!lastPage.rawContent.transitionOut) ? Debug.error("There is no transitionOut function on "+lastPage.name+" page") : lastPage.rawContent.transitionOut();
			} else {								
				if(ArrayUtils.inArray(pagesLoaded,LoaderMax.getContent(n))){
				    if(tracing)Debug.log("Page already loaded: "+n+" / "+LoaderMax.getLoader(n));		
					setPage(currentPageName);
				} else {
					if(tracing)Debug.log("Loading page: "+n+" / "+LoaderMax.getLoader(n));
					if(!LoaderMax.getLoader(n)){
						queue.append(new SWFLoader(getPageUrl(n),{name:n}));
					} else {
						queue.append(LoaderMax.getLoader(n));	
					}									
					queue.load(true);
				}
			}
		}
		
		// Get Asset
		public function getAsset(s:String):MovieClip{
			var t:MovieClip = new MovieClip();
			t.name = s;
			t.addChild(LoaderMax.getContent(s).rawContent);
			return t;
		}
		
		
		//*****************************//
		//******** GETTERS ************//
		//*****************************//
		
		// Get Version
		public function get version():Number {
			return VERSION;
		}
		
		// Get Site Core Instances
		public static function get api():SiteCore{
			return main;
		}

	}
	
}
