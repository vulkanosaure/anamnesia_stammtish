package data.xtends {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.events.Event;
	
	public class SpriteCopy extends Sprite{
		
		//params
		
		
		//private vars
		var bmp:Bitmap;
		var bmpData:BitmapData;
		
		
		
		//_______________________________________________________________
		//public functions
		
		public function SpriteCopy() 
		{ 
			bmp = new Bitmap();
			addChild(bmp);
		}
		
		
		public function copy(_dobj:DisplayObject):void
		{
			var bounds:Rectangle = _dobj.getBounds(_dobj);
			bmpData = new BitmapData(_dobj.width, _dobj.height);
			bmp.x = bounds.x;
			bmp.y = bounds.y;
			bmp.bitmapData = bmpData;
			var _matrix:Matrix = new Matrix();
			_matrix.scale(_dobj.scaleX, _dobj.scaleY);
			_matrix.translate(-bounds.x, -bounds.y);
			bmpData.draw(_dobj, _matrix);
			this.x = _dobj.x;
			this.y = _dobj.y;
		}
		
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		
		
		
		//_______________________________________________________________
		//events handlers
		
	}
	
}