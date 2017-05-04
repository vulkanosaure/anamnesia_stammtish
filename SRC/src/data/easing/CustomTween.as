package data.easing 
{
	import fl.motion.easing.Back;
	/**
	 * ...
	 * @author Vincent
	 */
	public class CustomTween
	{
		//_______________________________________________________________________________
		// properties
		
		public function CustomTween() 
		{
			throw new Error("is static");
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		public static function backOutReverse(t:Number, b:Number, c:Number, d:Number):Number
		{
			/*
			 * t = tps courant
			 * b = value depart
			 * c = delta fin - depart
			 * d = tps total
			 * */
			
			var v:Number = Back.easeOut(d - t, b, c, d);
			return (b + c) - v + b;
		}
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}