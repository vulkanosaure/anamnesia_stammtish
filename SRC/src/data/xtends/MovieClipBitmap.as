/*
créé un bitmap a la place d'elle meme
permet de gérer des propriétés de type luminosité, saturation, noir et blanc

pour l'instant :
le bitmap ne peut pas évoluer une fois qu'il est bitmap (a améliorer)

*/



package data.xtends {
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import flash.display.BlendMode;
	
		
	public class MovieClipBitmap extends MovieClip{
		
		//params
		
		
		//private vars
		var bmp:Bitmap;
		var bmpData:BitmapData;
		var bmpDataTemplate:BitmapData;
		
		var _brightness:Number;
		var _greyscale:Number;
		var _smoothing:Boolean = false;
		
		
		//_______________________________________________________________
		//public functions
		
		public function MovieClipBitmap() 
		{ 
			_brightness = 0;
			_greyscale = 0;
		}
		
		public function setBitmap():void
		{
			setVisible(true);
			if(bmp!=null) bmp.visible = true;
			var bounds:Rectangle = this.getBounds(this);
			bmpData = new BitmapData(this.width, this.height, true, 0);
			bmpData.draw(this, new Matrix(1,0,0,1,-bounds.x,-bounds.y));
			bmpDataTemplate = bmpData.clone();
			if (bmp == null) bmp = new Bitmap(bmpData);
			else bmp.bitmapData = bmpData;
			bmp.x = bounds.x;
			bmp.y = bounds.y;
			if(!this.contains(bmp)) addChild(bmp);
			setVisible(false);
			
			if (bmp != null) bmp.smoothing = _smoothing;
		}
		
		public function setNormal():void
		{
			if(bmp!=null) bmp.visible = false;
			setVisible(true);
		}
		
		
		
		
		
		
		public function set brightness(v:Number):void
		{
			if(v<-1 || v>1) throw new Error("MovieClipColor.brightness must be between -1 and 1");
			_brightness = v;
			processingBitmapData(getBrightness, v);
		}
		
		public function get brightness():Number
		{
			return _brightness;
		}
		
		public function set greyscale(v:Number):void
		{
			if(v<0 || v>1) throw new Error("MovieClipColor.greyscale must be between 0 and 1");
			_greyscale = v;
			processingBitmapData(getGreyscale, v);
		}
		
		public function get greyscale():Number
		{
			return _greyscale;
		}
		
		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
			if (bmp != null) bmp.smoothing = _smoothing;
		}
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		private function setVisible(v:Boolean):void
		{
			var dobj:DisplayObject;
			for(var i:int=0;i<this.numChildren;i++){
				dobj = getChildAt(i);
				if (dobj != bmp) dobj.visible = v;
			}
		}
		
		
		
		
		private function processingBitmapData(_func:Function, v:Number):void
		{
			var col_src:int;
			var col_dst:int;
			
			var _width:Number = bmpDataTemplate.width;
			var _height:Number = bmpDataTemplate.height;
			for(var i:int=0;i<_height;i++){
				for(var j:int=0;j<_width;j++){
					col_src = bmpDataTemplate.getPixel(j, i);
					col_dst = _func(col_src, v);
					bmpData.setPixel(j, i, col_dst);
				}
			}
		}
		
		
		
		
		private function getGreyscale(_color:uint, v:Number):uint
		{
			//todo
			//trace("getGreyscale(" + _color + ", " + v + ")");
			//v=1 -> noir et blanc complet, entre 0 et 1 -> translation
			var c:Object = hexToRGB(_color);
			var _lum:Number = c.r + c.g + c.b;
			var _valueColor:Number = Math.round(_lum / 3);
			
			
			//trace("    _lum : " + _lum + ", _valueColor : " + _valueColor);
			//traceColor("    c", c);
			
			var c2:Object = new Object();
			c2.a = c.a;
			c2.r = (_valueColor - c.r) * v + c.r;
			c2.g = (_valueColor - c.g) * v + c.g;
			c2.b = (_valueColor - c.b) * v + c.b;
			
			//traceColor("    c2", c2);
			
			var _result:int = RGBToHex(c2);
			return _result;
		}
		
		private function getBrightness(_color:uint, v:Number):uint
		{
			var c:Object = hexToRGB(_color);
			var d:Number;
			for (var key:String in c){
				d = ((v>0) ? 255 : 0) - c[key];
				d *= Math.abs(v);
				c[key] += d;
			}
			return RGBToHex(c);
		}
		
		private function hexToRGB(hex:uint):Object
		{
			var c:Object = {};
			c.a = hex >> 24 & 0xFF;
			c.r = hex >> 16 & 0xFF;
			c.g = hex >> 8 & 0xFF;
			c.b = hex & 0xFF;
			return c;
		}
		
		private function RGBToHex(c:Object):uint
		{
			var ct:ColorTransform = new ColorTransform(0, 0, 0, 0, c.r, c.g, c.b, 100);
			return ct.color as uint
		}
		
		private function traceColor(_mention:String, c:Object):void
		{
			trace(_mention+" : " + c.r+", "+c.g+", "+c.b+" // "+c.a);
		}
		
		
		//_______________________________________________________________
		//events handlers
		
	}
	
}