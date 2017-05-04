package data.math 
{
	/**
	 * ...
	 * @author Vincent
	 */
	 
	 
	public class Random extends Object
	{
		//_______________________________________________________________________________
		// properties
		
		var results:Array;
		var min:Number;
		var max:Number;
		var inc:Number;
		var variance:Number;
		
		public function Random() 
		{
			this.reset();
		}
		
		public function reset():void
		{
			results = new Array();
		}
		
		public function setParams(_min:Number, _max:Number, _inc:Number, _variance:Number):void
		{
			if (_variance < 0) throw new Error("arg _variance must be positive");
			min = _min;
			max = _max;
			inc = _inc;
			variance = _variance;
		}
		
		/*
		 * random avec proba
		 * on indique un élement de l'éventail, et un indice
		 * si indice = 1, on est sur de tombe sur cet element
		 * si indice = 0, random normal
		 * 
		 * 
		 * 
		*/
		
		public function get():Number
		{
			var _average:Number;
			var _len:int = results.length;
			
			var _cumul:Number = 0;
			for (var i:int = 0; i < _len; i++) {
				_cumul += results[i];
			}
			if (_len > 0) _average = _cumul / _len;
			else _average = (max - min) / 2;
			
			//find the oposite of average
			//based on min, max
			var _mediane:Number = (max - min) / 2;
			var _oposite:Number = _mediane * 2 - _average;
			
			
			var _result = Math2.random2(min, max, inc, _oposite, variance);
			
			results.push(_result);
			return _result;
		}
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}