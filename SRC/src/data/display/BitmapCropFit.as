package data.display 
{
	import data.math.ResizeCalculation;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Vincent
	 */
	public class BitmapCropFit extends Bitmap
	{
		//_______________________________________________________________________________
		// properties
		
		public function BitmapCropFit(_dimensions:Point, _model:Bitmap) 
		{
			
			
			
			var _dims:Point = ResizeCalculation.getResize(ResizeCalculation.BORDER, _dimensions, new Point(_model.width, _model.height));
			
			this.bitmapData = new BitmapData(_dims.x, _dims.y);
			
			var _startX:Number = _model.width / 2 - _dims.x / 2;
			var _startY:Number = _model.height / 2 - _dims.y / 2;
			
			for (var x:int = 0; x < _dims.x; x++){
				for (var y:int = 0; y < _dims.y; y++) {
					
					var _col:uint = _model.bitmapData.getPixel(x + _startX, y + _startY);
					this.bitmapData.setPixel(x, y, _col);
					
				}
			}
			
			this.width = _dimensions.x;
			this.height = _dimensions.y;
			
			this.smoothing = true;
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}