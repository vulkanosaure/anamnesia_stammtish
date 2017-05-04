package data.math 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Vincent
	 */
	public class ResizeCalculation
	{
		//_______________________________________________________________________________
		// properties
		
		public static const FIT:String = "resizeCalculationFit";
		public static const BORDER:String = "resizeCalculationBorder";
		
		public function ResizeCalculation() 
		{
			throw new Error("is static, can't instanciate");
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public static function getResize(_mode:String, _dimSRC:Point, _dimDST:Point):Point
		{
			if (_mode != FIT && _mode != BORDER) throw new Error("wrong value for argument _mode ("+FIT+", "+BORDER+")");
			
			var _border:Boolean = (_mode == BORDER);
			var _ratioSRC:Number = _dimSRC.x / _dimSRC.y;
			var _ratioDST:Number = _dimDST.x / _dimDST.y;
			
			var w:Number = 0;
			var h:Number = 0;
			
			if (_ratioSRC > _ratioDST && _border) w = _dimDST.x;
			else if(_ratioSRC > _ratioDST && !_border) h = _dimDST.y;
			else if (_border) h = _dimDST.y;
			else w = _dimDST.x;
			
			if (h == 0) h = w * _dimSRC.y / _dimSRC.x;
			else w = h * _dimSRC.x / _dimSRC.y;
			
			return new Point(w, h);
		}
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}