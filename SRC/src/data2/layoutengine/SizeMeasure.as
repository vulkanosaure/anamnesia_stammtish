package data2.layoutengine 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class SizeMeasure 
	{
		
		private static var _x1:Number;
		private static var _y1:Number;
		private static var _x2:Number;
		private static var _y2:Number;
		
		public function SizeMeasure() 
		{
			throw new Error("is static");
		}
		
		
		
		
		
		public static function getDimensions(_obj:DisplayObject):Point
		{
			if (!(_obj is DisplayObjectContainer)) return new Point(_obj.width, _obj.height);
			
			//trace("getDimensions_______________________________");
			_x1 = NaN;
			_y1 = NaN;
			_x2 = NaN;
			_y2 = NaN;
			rec(DisplayObjectContainer(_obj), DisplayObjectContainer(_obj));
			
			var _width:Number = _x2 - _x1;
			var _height:Number = _y2 - _y1;
			//trace(_x1 + ", " + _y1 + " - " + _x2 + ", " + _y2);
			//trace("width : " + _width + ", _height : " + _height);
			return new Point(_width, _height);
			
		}
		
		
		
		
		
		private static function rec(_dobjc:DisplayObjectContainer, _base:DisplayObjectContainer):void
		{
			var _numchildrens:int = _dobjc.numChildren;
			for (var i:int = 0; i < _numchildrens; i++) 
			{
				var _child:DisplayObject = _dobjc.getChildAt(i);
				
				//trace("_child : " + _child + ", _mask : " + _child.mask);
				if (_child.mask != null && !(_child.mask is Bitmap)) {
					
					var p1:Point = _base.localToGlobal(new Point(_child.mask.x, _child.mask.y));
					var p2:Point = _base.localToGlobal(new Point(_child.mask.x + _child.mask.width, _child.mask.y + _child.mask.height));
					if (isNaN(_x1) || p1.x < _x1) _x1 = p1.x;
					if (isNaN(_y1) || p1.y < _y1) _y1 = p1.y;
					if (isNaN(_x2) || p2.x > _x2) _x2 = p2.x;
					if (isNaN(_y2) || p2.y > _y2) _y2 = p2.y;
					
					//trace("mask : " + _child.mask + ", p1 : " + p1 + ", p2 : " + p2);
				}
				
				if (_child is DisplayObjectContainer) {
					
					rec(DisplayObjectContainer(_child), _base);
				}
			}
		}
		
		
	}

}