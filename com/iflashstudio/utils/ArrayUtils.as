package com.iflashstudio.utils{
 
	 /**
	 * ArrayUtils
	 *
	 * @date 			June 18, 2010
	 * @author			Hjupter Cerrud, Francisco Chong
	 * @version			1.0
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class ArrayUtils{	
	
		// Get Index Position from Array
		public static function getIndex(array:Array,target:*):int {
			var res:int;
			for (var i:int=0; i<array.length; i++) {
				if (array[i] == target) {
					res = i;
					break;
				}
			}
			return res;
		}
		
		// Remove from array by item
		public static function removeByItem(array:Array,target:*):Array {
			for (var i:int=0; i<array.length; i++) {
				if (array[i]==target) {
					removeByIndex(array,i);
					break;
				}
			}
			return array;
		}

		// Remove from array by index
		public static function removeByIndex(array:Array,removeValue:Number):Array {
			if(removeValue > array.length){
				trace("###ARRAY UTILS ALERT###: removeValue cannot be higher than array length");
			}
			array.splice(removeValue,1);
			return array;
		}

		// Returns true or false if an Item is in Array
		public static function inArray(array:Array, target:*):Boolean {
			for (var i:int=0; i<array.length; i++) {
				if (array[i]==target) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * The <code>shuffle</code> returns a shuffled array. The passed array itself does not change.
		 *  
		 * @param 	$array	Array that needs to bew shuffled.
		 * @return 			Array A new Array that contains the original values in a random order.
		 * 
		 */		
		public static function shuffle($array:Array):Array{
			//copy array:
			var a:Array = [].concat($array)
			//return shuffled array:
			return a.sort(__shuffleSort);;
		}

		private static function __shuffleSort($a:*,$b:*):Number{ 
			var random:int;
			while(random==0){
				random = MathUtils.getRandomInt(-1,1);
			}
			return random; 
		}


		/**
	     *  The <code>swap()</code> method swaps out two Objects within the same array.
		 * 	This Method doesn't create a copy of the passed array but changes it directly.
	     *
	     *  @param 	$array	Array	Specifies the Array to swap.
	     *  @param	$a		int 	Specifies the first index.
	     *  @param	$b 		int 	Specifies the second index.
	     *  @return 		Array 	Swapped Array.
	     */
		public static function swap($array:Array, $a:int, $b:int):Array{
			var temp:int = $array[$a];
			$array[$a] = $array[$b];
			$array[$b] = temp;
			return $array;
		}


		/**
	     *  The <code>unique()</code> method 
	     *	
		 * 	!! This Method currently might only work for Strings and Numbers !!
		 * 
	     *  @param $array 	Array	Specifies the Array from which to remove the duplicates.
	     *  @return 		Array	unique Array.
	     */
		public static function unique($array:Array):Array{
			var obj:Object = new Object;
			var i:Number = $array.length;
			var a:Array = new Array();
			var t:*;

			while(i--){
				t = $array[i];
				obj[t] = t;
			}

			for each(var item:* in obj){ a.push(item); }
			return a;
		}
	}
}