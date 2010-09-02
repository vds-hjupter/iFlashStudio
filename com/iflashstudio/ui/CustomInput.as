/**
 * ...
 * @author Hjupter Cerrud [www.iflashstudio.com]
 * @CustomInput
 * @version 0.3
 * ...
 */

package com.iflashstudio.ui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextFormat;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	public class CustomInput extends MovieClip{
		
		public var _type:String = "input";
		
		private var Textfield:TextField;
		private var overMC:MovieClip;
		private var downMC:MovieClip;
		private var _root:Object;
		private var _defaultText:String;
		private var _enable:Boolean = true;
		private var italicFormat:TextFormat = new TextFormat();
		private var emptyFormat:TextFormat = new TextFormat();
		
		public function CustomInput(){	
            italicFormat.italic = true;           
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
			}			
			if(!Textfield){
				trace("CustomInput Error: you must create a textfield!");
				return;
			}
			Textfield.text = _defaultText = "";
			Textfield.addEventListener(Event.CHANGE, onChange);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage,false,0,true);
		}
		
		// On Added to Stage
		private function onAddedToStage(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
			_root = MovieClip(parent).stage;			
			_root.stageFocusRect = false;
			if(_enable){
				enable();
				if(!overMC){
					if(bg){
						bg.alpha = .9;
					}
				}
			}
		}
		
		// Change
		private function onChange(e:Event):void{
			dispatchEvent(new Event(Event.CHANGE));
		}		
		
		// Enable
		public function enable():void{
			if(_type == "input"){
				_enable = true;
				Textfield.selectable = true;			
				Textfield.type = "input";
				addEventListener(MouseEvent.MOUSE_OVER,mouseHandler,false,0,true);
				addEventListener(MouseEvent.MOUSE_OUT,mouseHandler,false,0,true);
				addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler,false,0,true);					
				addEventListener(FocusEvent.FOCUS_IN, focusHandler,false,0,true);
				addEventListener(FocusEvent.FOCUS_OUT, focusHandler,false,0,true);
			}
			TweenMax.to(this,.3,{colorMatrixFilter:{saturation:1}});
		}
		
		// Disable
		public function disable():void{	
			if(_type == "input"){
				_enable = false;
				Textfield.selectable = false;
				Textfield.type = "dynamic";
				removeEventListener(MouseEvent.MOUSE_OVER,arguments.callee);
				removeEventListener(MouseEvent.MOUSE_OUT,arguments.callee);
				removeEventListener(MouseEvent.MOUSE_DOWN,arguments.callee);					
				removeEventListener(FocusEvent.FOCUS_IN, arguments.callee);
				removeEventListener(FocusEvent.FOCUS_OUT, arguments.callee);
			}
			TweenMax.to(this,.3,{colorMatrixFilter:{saturation:0}});
		}	
		
		// Mouse Handler
		private function mouseHandler(e:MouseEvent):void{
			var t:MovieClip = e.currentTarget as MovieClip;
			switch(e.type){
				case MouseEvent.MOUSE_OVER:
					if(overMC){
						TweenMax.to(overMC,.1,{alpha:1});
					} else {
						TweenMax.to(bg,.1,{alpha:1});
					}
					_root.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler,false,0,true);
					break;
				case MouseEvent.MOUSE_OUT:
					if(overMC){
						TweenMax.to(overMC,.3,{alpha:0});
					} else {
						TweenMax.to(bg,.3,{alpha:.9});
					}
					break;
				case MouseEvent.MOUSE_DOWN:
					if(overMC){
						overMC.alpha = 0;
					}
					if(hitTestPoint(e.stageX, e.stageY, true)){
						if(Textfield.text == _defaultText) {
							Textfield.text = "";
							Textfield.alpha = 1;
							Textfield.defaultTextFormat = emptyFormat;
						}
						if(downMC){
							downMC.alpha = 1;
						} else {
							TweenMax.to(this,.1,{glowFilter:{blurX:5,blurY:5,strength:3,color:0x0099CC,alpha:1}});
						}
					} else {
						if(Textfield.text == "") {
							Textfield.defaultTextFormat = italicFormat;
							Textfield.text = _defaultText;
							Textfield.alpha = .5;							
						}
						if(downMC){
							downMC.alpha = 0;
						} else {
							TweenMax.to(this,.1,{glowFilter:{blurX:0,blurY:0,alpha:0}});
						}
						_root.focus = null;
						_root.removeEventListener(MouseEvent.MOUSE_DOWN, arguments.callee);
					}					
					break;
			}
		}
		
		// Focus Handler
		private function focusHandler(e:FocusEvent):void {
			var t:MovieClip = e.currentTarget as MovieClip;
			switch(e.type){
				case FocusEvent.FOCUS_IN:
				if (Textfield.text == _defaultText) {
					Textfield.text = "";
					Textfield.alpha = 1;
					Textfield.defaultTextFormat = emptyFormat;
				}
				break;
				case FocusEvent.FOCUS_OUT:
				if (Textfield.text == "") {
					Textfield.defaultTextFormat = italicFormat;
					Textfield.text = _defaultText;
					Textfield.alpha = .5;					
				}				
				_root.focus = null;
				break;
			}
		}
		
		//** SETTERS AND GETTERS **//
		// Set Restriction
		public function set restrict(str:String):void{
			Textfield.restrict = str;
		}
		
		// Set MaxChars
		public function set maxChars(i:int):void{
			Textfield.maxChars = i;
		}
		
		// Set MaxChars
		public function set tabindex(i:int):void{
			Textfield.tabIndex = i;
		}
		
		// Set Default Text
		public function set defaultText(str:String):void{
			Textfield.defaultTextFormat = italicFormat;
			_defaultText = Textfield.text = str;
			Textfield.alpha = .5;			
		}
		
		// Get Default Text
		public function get defaultText():String{
			return _defaultText;
		}
		
		// Get Text Field
		public function get textfield():TextField{
			return Textfield;
		}
		
		// Get Text
		public function get text():String{
			return Textfield.text;
		}
		
		// Set Text
		public function set text(str:String):void{
			Textfield.text = str;
		}
		
		// Set Type
		public function set type(str:String):void{
			_type = str;			
		}
		
		// Get Type
		public function get type():String{
			return _type;
		}
	}
}
