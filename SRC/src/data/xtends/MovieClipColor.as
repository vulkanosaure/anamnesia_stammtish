package data.xtends {
	
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	
		
	public class MovieClipColor extends MovieClip{
		
		//params
		
		
		//private vars
		var _color:uint;
		var _brightness:Number;
		var _colortransform:ColorTransform;
		
		
		//_______________________________________________________________
		//public functions
		
		public function MovieClipColor() 
		{ 
			_colortransform = new ColorTransform();
			_brightness = 0;
			_color = undefined;
		}
		
		
		public function set color(i:uint):void
		{
			_color = i;
			var colorTransform:ColorTransform 	= this.transform.colorTransform;
			colorTransform.color = getColorByBrightness(i, _brightness);
			this.transform.colorTransform = colorTransform;
		}
		
		
		
		public function get color():uint
		{
			return _color;
		}
		
		
		public function set brightness(v:Number):void
		{
			if(v<-1 || v>1) throw new Error("MovieClipColor.brightness must be between -1 and 1");
			_brightness = v;
			var colorTransform:ColorTransform 	= this.transform.colorTransform;
			colorTransform.color = getColorByBrightness(_color, v);
			this.transform.colorTransform = colorTransform;
			
		}
		
		public function get brightness():Number
		{
			return _brightness;
		}
		
		
		
		
		
		
		
		
		
		
		
		//_______________________________________________________________
		//private functions
		
		
		private function getColorByBrightness(_color:uint, _brightness:Number):uint
		{
			var c:Object = hexToRGB(_color);
			var d:Number;
			for (var key:String in c)
			{
				d = ((_brightness>0) ? 255 : 0) - c[key];
				d *= Math.abs(_brightness);
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
	

		
		
		//_______________________________________________________________
		//events handlers
		
	}
	
}