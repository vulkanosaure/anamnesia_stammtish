/*
works with VLayout and HLayout
pilot the function 

*/

package data2.behaviours.layout 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class Spacer extends Sprite
	{
		private var _value:Number;
		
		public function Spacer() 
		{
			_value = 0;
			
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = value;
		}
		
		
		
		
		
	}

}