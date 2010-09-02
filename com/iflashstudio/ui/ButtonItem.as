package com.iflashstudio.ui{
	
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
	
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.MouseEvent;
	
	public dynamic class ButtonItem extends MovieClip {
		
		public var url:String;
		public var title:String;
		public var id:String;
		public var mouseHandler:Function;
		private var field:TextField;
		private var main:Object;

		public function ButtonItem() {
			for(var i:int = 0; i<numChildren; i++){
				if(getChildAt(i) is TextField){
					var textFormat:TextFormat = new TextFormat();
					textFormat.rightMargin = 2;
					field = getChildAt(i) as TextField;
					field.antiAliasType = AntiAliasType.ADVANCED;
					field.gridFitType = GridFitType.SUBPIXEL;
					field.defaultTextFormat = textFormat;
					field.setTextFormat(textFormat);
				}
			}
			main = Object(this.root);
			if(main.mouseHandler) handler = main.mouseHandler;
		}
		
		public function set handler(f:Function):void{
			mouseHandler = f;
			enable();
		}
		
		public function set text(s:String):void{
			if(field){				
				field.text = s;
			}			
		}
		
		public function set autoSize(s:String):void{
			if(field){
				field.autoSize = s;
			}
		}

		public function enable():void{
			buttonMode = true;
			mouseChildren = false;
			enabled = true;
			addEventListener(MouseEvent.CLICK,mouseHandler,false,0,true);
			addEventListener(MouseEvent.ROLL_OUT,mouseHandler,false,0,true);
			addEventListener(MouseEvent.ROLL_OVER,mouseHandler,false,0,true);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler,false,0,true);
			addEventListener(MouseEvent.MOUSE_UP,mouseHandler,false,0,true);
		}

		public function disable():void{
			buttonMode = false;
			enabled = false;
			removeEventListener(MouseEvent.CLICK,mouseHandler);
			removeEventListener(MouseEvent.ROLL_OUT,mouseHandler);
			removeEventListener(MouseEvent.ROLL_OVER,mouseHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
			removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
		}
		
	}
	
}
