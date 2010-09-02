/**
 * ...
 * @author Hjupter Cerrud [www.iflashstudio.com]
 * @CustomInput
 * @version 0.4
 * ...
 */

package com.iflashstudio.ui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.text.TextField;
	
	public dynamic class CustomButton extends MovieClip{
		
		public const type:String = "button";
		
		private var Textfield:TextField;
		private var overMC:MovieClip;
		private var downMC:MovieClip;
		private var bgMC:MovieClip;
		//public var autoSizeButtton:String = "LEFT";
		
		public function CustomButton(){			
			for(var i:int = 0; i<numChildren; i++){
				var t:* = getChildAt(i);
				if(t is TextField){
					Textfield = t;
				}
				if(t is MovieClip && t.name.indexOf("over") != -1){
					overMC = t;
				}
				if(t is MovieClip && t.name.indexOf("down") != -1){
					downMC = t;
				}
				if(t is MovieClip && t.name.indexOf("bg") != -1){
					bgMC = t;
				}
			}
			/*if(Textfield){
				autoSize = "left";
			}*/
			enable();
		}
		
		private function btnWidth():void{
			if(autoSize == "left"){
				if(bgMC){
					bgMC.width = 0;
					bgMC.width = Math.round(width+Textfield.x);
					(!overMC)? null : overMC.width = bgMC.width;
					(!downMC)? null : downMC.width = bgMC.width;
				}
			}
		}
		
		// Set Text AutoSize
		public function set autoSize(str:String):void{
			Textfield.autoSize = str;			
		}
		
		// Get Text AutoSize
		public function get autoSize():String{
			return Textfield.autoSize;			
		}
		
		// Set Text
		public function set text(str:String):void{
			if(Textfield){
				Textfield.text = str;
			}
			if(autoSize){
				btnWidth();
			}
		}
		
		// Get Text
		public function get text():String{
			return Textfield.text;
		}
		
		// Get Text Field
		public function get textfield():TextField{
			return Textfield;
		}
		
		// Enable Button
		public function enable():void{		
			buttonMode = true;
			mouseChildren = false;
			mouseEnabled = true;
			addEventListener(MouseEvent.MOUSE_OVER,mouseHandler,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,mouseHandler,false,0,true);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler,false,0,true);	
			addEventListener(MouseEvent.MOUSE_UP,mouseHandler,false,0,true);
			addEventListener(MouseEvent.CLICK,mouseHandler,false,0,true);
			TweenMax.to(this,.3,{colorMatrixFilter:{saturation:1}});
		}
		
		// Disable Button
		public function disable(fx:Boolean = true):void{
			buttonMode = false;
			mouseEnabled = false;
			removeEventListener(MouseEvent.MOUSE_OVER,arguments.callee);
			removeEventListener(MouseEvent.MOUSE_OUT,arguments.callee);
			removeEventListener(MouseEvent.MOUSE_DOWN,arguments.callee);
			removeEventListener(MouseEvent.MOUSE_UP,arguments.callee);
			removeEventListener(MouseEvent.CLICK,arguments.callee);
			if(fx){
				TweenMax.to(this,.3,{colorMatrixFilter:{saturation:0}});
			}
		}	
		
		// Internal Mouse Handler
		private function mouseHandler(e:MouseEvent):void{
			var t:MovieClip = e.currentTarget as MovieClip;
			if(MovieClip(parent).mouseHandler){
				MovieClip(parent).mouseHandler(e);
				//return;
			} else if(MovieClip(parent.parent).mouseHandler){
				MovieClip(parent.parent).mouseHandler(e);
				//return;
			} else if(MovieClip(parent.parent.parent).mouseHandler){
				MovieClip(parent.parent.parent).mouseHandler(e);
				//return;
			}
			switch(e.type){
				case MouseEvent.MOUSE_OVER:
					if(overMC){
						TweenMax.to(overMC,.1,{alpha:1});
					} 					
					break;
				case MouseEvent.MOUSE_OUT:
					if(overMC){
						TweenMax.to(overMC,.3,{alpha:0});
					}				
					break;
				case MouseEvent.MOUSE_DOWN:
					break;
			}
		}
	}
}
