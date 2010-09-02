package com.iflashstudio.utils{
	import flash.display.*;
	import com.greensock.TweenMax;
	
	dynamic public class SuperMovie extends MovieClip {
		
		private var i:int;
		public var test:String = "34534";
		public var mouseHandlers:Array = ["rollOver","rollOut","mouseDown","mouseUp","mouseOver","mouseOut","click","mouseWheel","mouseMove"];

		public function SuperMovie(){
			// constructor code
		}
		
		// Destroy MovieClip and any added event
		public function destroy():void{			
			disable();
			parent.removeChild(this);
		}
		
		// Enable MovieClip as Button
		public function enable(handler:Function, fx:Boolean = true):void{
			trace("enable "+handler); 
			/*mouseEnabled = true;
			buttonMode = true;
			mouseChildren = false;
			for(i = 0; i<mouseHandlers.length; i++){
				addEventListener(mouseHandlers[i],handler,false,0,true);
			}
			TweenMax.to(this,.3,{colorMatrixFilter:{saturation:1}});*/
		}
		
		// Disable MovieClip
		public function disable():void{
			mouseEnabled = false;
			for(i = 0; i<mouseHandlers.length; i++){
				removeEventListener(mouseHandlers[i],arguments.callee);
			}
			TweenMax.to(this,.3,{colorMatrixFilter:{saturation:0}});
		}
		

	}
	
}
