package data.math.functions 
{
	/**
	 * ...
	 * @author Vincent
	 */
	public class LinearFunction
	{
		//_______________________________________________________________________________
		// properties
		
		
		private var _a:Number;
		private var _b:Number;
		
		public function LinearFunction(__a:Number, __b:Number) 
		{
			_a = __a;
			_b = __b;
		}
		
		public function get a():Number { return _a; }
		
		public function get b():Number { return _b; }
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		public function toString():String 
		{
			return "LinearFunction : " + _a + "x + " + _b;
		}
		
	}

}