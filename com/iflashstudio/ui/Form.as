/**
 * ...
 * @author Hjupter Cerrud [www.iflashstudio.com]
 * @CustomInput
 * @version 0.1
 * ...
 */

package com.iflashstudio.ui
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	import flash.utils.*;
	import flash.net.*;
	import flash.text.TextField;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.iflashstudio.events.FormEvent;
	
	public class Form extends MovieClip{

		private var stageRef:Stage;
		private var error_label:MovieClip;
		private var fields:Array;
		private var warnings:Array;
		private var variables:Array;
		private var checkList:Array = new Array();
		private var _defaultWarning:String = "All fields are required!";
		private var _defaultError:String = "Error sending data!";
		private var _defaultSuccess:String = "Succesfully sent!";
		private var _url:String;
		private var _type:String = "request";
		private var variableHolder:URLVariables = new URLVariables();
		
		public function Form(_stageRef:Stage,arr:Array,args:Object = null){	
			fields = arr;
			stageRef = _stageRef;			
			if(args){
				variables = args.variables;
				warnings = args.warnings;
				error_label = args.errorLabel;
				_url = args.url;
				_type = args.type;
			}
			if(warnings){
				if(fields.length != warnings.length || warnings.length != fields.length){
					throw new Error("INPUT GROUP ERROR: inputs and warnings arrays must have same length");
					return;
				}
			}
			if(variables){
				if(fields.length != variables.length || variables.length != fields.length){
					throw new Error("INPUT GROUP ERROR: inputs and variables arrays must have same length");
					return;
				}
			}
			if(error_label){
				error_label.visible = false;
				error_label.alpha = 0;
			}			
			stageRef.stageFocusRect = false;
			for(var i:int = 0; i<fields.length; i++){
				var t:* = fields[i];
				if(t.type == "input" || t.type == "dynamic"){
					checkList.push(t);
					t.addEventListener(Event.CHANGE,formChangeHandler);
				}
			}
		}
		
		// Check if forms is filled
		private function formChangeHandler(e:Event):void{
			var t:* = e.currentTarget;
			if(t.text != "" || t.text != t.defaultText){
				checkList = removeByItem(checkList,t);
				t.removeEventListener(Event.CHANGE,arguments.callee);
			} else {
				if(!inArray(checkList,t)){
					checkList.push(t);
					t.addEventListener(Event.CHANGE,formChangeHandler);
				}
			}
			if(checkList.length == 1){
				dispatchEvent(new FormEvent(FormEvent.FILLED, true));
			}
		}
		
		// Returns true or false if an Item is in Array
		public function inArray(array:Array,target:*):Boolean {
		   for(var i:int = 0; i<array.length; i++) {
			  if(array[i] == target) {
				 return true;
			  }
		   }
		   return false;
		}	
		
		// Remove from array by item
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
		
		// Validate Group
		public function validate():Boolean{
			var res:Boolean = true;
			disable();
			for(var i:int = 0; i<fields.length; i++){
				var t:* = fields[i];
				if(t.type == "input"){
					if(t.text == "" || t.text == t.defaultText){						
						stageRef.focus = t.textfield;
						t.textfield.setSelection(0,t.textfield.length);
						error((!warnings) ? _defaultWarning : warnings[i],t);
						res = false;
						break;
					}
				} else {
					error((!warnings) ? _defaultWarning : warnings[i],t);
					res = false;
					break;
				}
			}
			return res;
		}
		
		// Show Error
		private function error(str:String,t:* = null):void{
			enable();
			if(t){
				TweenMax.to(t,.4,{yoyo:true,repeat:5,glowFilter:{blurX:5,blurY:5,color:0xFF0000,strength:3,alpha:1}});
			}
			if(error_label){
				for(var i:int = 0; i<numChildren; i++){
					var t:* = getChildAt(i);
					if(t is TextField){
						error_label.field = t;
					}
				}
				error_label.field.text = str;
				TweenMax.to(error_label,.3,{autoAlpha:1,onComplete:function(){
					TweenMax.to(error_label,.3,{delay:5,autoAlpha:0});
				}});
			} else {
				dispatchEvent(new FormEvent(FormEvent.INVALID, str));
			}			
		}	
		
		// Enable Group
		public function enable():void{		
			for(var i:int = 0; i<fields.length; i++){
				var t:* = fields[i];
				t.enable();
			}
		}
		
		// Disable Group
		public function disable():void{	
			for(var i:int = 0; i<fields.length; i++){
				var t:* = fields[i];
				t.disable();
			}
		}		
		
		// Send Data Handler
		private function sendHandler():void{
			switch(_type){
				case "request":
					for(var i:int = 0; i<variables.length; i++){
						variableHolder[variables[i]] = fields[i].text;
					}
					var entryURL:URLRequest = new URLRequest(_url);
					var loader:URLLoader = new URLLoader();
					loader.dataFormat = URLLoaderDataFormat.TEXT;
					entryURL.data = variableHolder;
					entryURL.method = URLRequestMethod.POST;
					loader.addEventListener(Event.COMPLETE, completeHandler);
					loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorSubmit);
					loader.load(entryURL);
					break;
				case "amfphp":
					trace("AMFPHP");
					break;
				default:
					trace("Send Handler Default Case");
					break;
			}
		}
		
		// Complete Handler
		private function completeHandler(e:Event):void{
			trace ("success: " + e.target.data);
			if(e.target.data){
				dispatchEvent(new FormEvent(FormEvent.COMPLETE,e.target.data));
			} else {
				trace(_defaultError);
			}
		}

		// IO Error Handler
		private function onIOErrorSubmit(e:IOErrorEvent):void{
			trace(_defaultError);
		}
		
		//** SETTERS AND GETTERS **//
		
		// Set Default Warning
		public function set defaultWarning(str:String):void{
			_defaultWarning = str;
		}
		
		// Set Request Type
		public function set type(str:String):void{
			_type = str;
		}
		
		// Set Request URL
		public function set url(str:String):void{
			_url = str;
		}
	}	
}


