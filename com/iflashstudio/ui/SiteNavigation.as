package com.iflashstudio.ui{
	
	/**
	 * SiteNavigation
	 *
	 * @date 			September 1, 2010
	 * @author			Hjupter Cerrud
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	
	public class SiteNavigation extends MovieClip{
		
		private var container:MovieClip;
		private var list:XMLList;
		private var Item:Class;
		private var xp:int;
		private var yp:int;
		private var mouseHandler:Function;
		
		public var switchItems:Array = [];
		public var items:Array;		

		public function SiteNavigation(list:XMLList) {
			this.list = list;			
			container = new MovieClip();
			items = [];
			addChild(container);
		}
		
		// Build Navigation		
		public function build(movieName:String,mouseHandler:Function):void{
			this.mouseHandler = mouseHandler;
			Item = getDefinitionByName(movieName) as Class;
			for(var i:int = 0; i<list.length(); i++){
				var n = list[i];
				var t:MovieClip = new Item();
				t.src = n.@url;
				t.id = n.@name;
				t.handler = mouseHandler;
				t.name = "nav_"+n.@name;
				if(t.TXT_label) t.TXT_label.text = n.@title;
				if(t.TXT_label2) t.TXT_label2.text = n.@title2;
				t.visible = false;
				t.alpha = 0;
				container.addChild(t);
				items.push(t);
			}
			positionate();
		}
		
		
		public function activate(t:MovieClip):void{
			for(var i:int = 0; i<switchItems.length; i++){
				var tr:MovieClip = switchItems[i] as MovieClip;
				if(tr == t){
					if(tr.disable)tr.disable();
					tr.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
				} else {
					if(tr.enable)tr.enable();
					tr.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
				}
			}
		}
		
		
		public function positionate(space:int = 5, orientation:String = "horizontal"):void{
			xp = 0;
			yp = 0;
			for(var i:int = 0; i<items.length; i++){
				var t:MovieClip = items[i];
				t.x = xp;
				t.y = yp;
				(orientation != "horizonal") ? xp += Math.round(t.width+space) : yp += Math.round(t.height+space);
			}
		}		

	}
	
}
