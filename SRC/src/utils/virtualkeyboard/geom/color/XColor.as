package utils.virtualkeyboard.geom.color {
	
	public class XColor {
		
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		//	STATIC MEMBERS
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		/** Converts separate RGB channels values to RGB hexadecimal value */
		public function GetHex(red:uint, green:uint, blue:int):void {
			_hex = (red << 16) | (green << 8) | blue;
		}
		
		
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		//	INSTANCE MEMBERS
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		private var _hex:uint;
		
		/**
		 * Constructor
		 * @param	r		red channel value (or complete color definition - see usage comments)
		 * @param	g		green channel value
		 * @param	b		blue channel value
		 * @usage	both instanciations <code>new RGBColor(0xff, 0x0, 0x66);</code> and <code>new RGBColor(0xff0066);</code> are equivalent
		 */
		public function XColor(red:uint = 0x0, green:int = -1, blue:int = -1) {
			reset(red, green, blue);
		}
		
		/** Returns a clon instance */
		public function clone():XColor {
			return new XColor(_hex);
		}
		
		/** Returns a string representation of the instance */
		public function toString():String {
			return "[XColor] " + hexString;
		}
		
		/** color value as an HTML formatted string (ie: #FFFFFF) */
		public function get hexString():String {
			var hexString:String, red:String, green:String, blue:String;
			
			red = this.red.toString(16);
			while (red.length < 2)
				red = "0" + red;
			
			green = this.green.toString(16);
			while (green.length < 2)
				green = "0" + green;
			
			blue = this.blue.toString(16);
			while (blue.length < 2)
				blue = "0" + blue;
			
			hexString = "#" + red + green + blue;
			hexString = hexString.toUpperCase();
			return hexString;
		}
		public function set hexString(hexString:String):void {
			var len:uint;
			
			len = hexString ? hexString.length : 0;
			if (len < 6 || len > 7) {
				trace("[XColor.hexString] Invalid hexString value: \"" + hexString + "\"");
				hex = 0x0;
				return;
			}
			
			hexString = hexString.substr(-6);
			reset(parseInt(hexString.substr(0, 2), 16), parseInt(hexString.substr(2, 2), 16), parseInt(hexString.substr(4, 2), 16));
		}
		
		/** red channel value */
		public function get red():uint {
			return _hex >> 16 & 0xFF;
		}
		public function set red(red:uint):void {
			if(red > 255)
				red = 255;
			else if (red < 0)
				red = 0;
			reset(red, green, blue);
		}
		
		/** green channel value */
		public function get green():uint {
			return(_hex >> 8) & 0xFF;
		}
		public function set green(green:uint):void {
			if(green > 255)
				green = 255;
			else if (green < 0)
				green = 0;
			reset(red, green, blue);
		}
		
		/** blue channel value */
		public function get blue():uint {
			return _hex & 0xFF;
		}
		public function set blue(blue:uint):void {
			if(blue > 255)
				blue = 255;
			else if (blue < 0)
				blue = 0;
			reset(red, green, blue);
		}
		
		/** RGB hexadecimal value */
		public function get hex():uint {
			return _hex;
		}
		public function set hex(hex:uint):void {
			if(hex > 0xFFFFFF)
				hex = 0xFFFFFF;
			_hex = hex;
		}
		
		/** Defines RGB hexadecimal value from separate channels values */
		public function reset(red:int, green:int = -1, blue:int = -1):void {
			if (green < 0 && blue < 0)
				_hex = red;
			else if (green < 0 || blue < 0)
				throw new Error("[XColor.reset] Illegal call ; reset method accept exactly 3 or 1 parameter.");
			else
				_hex = ((red << 16) | (green << 8) | blue);
		}
		
		/** Returns a clone with brightness modified of the passed-in amount */
		public function shiftBrightness(amount:Number):void{
			var red:int, green:int, blue:int;
			
			red = this.red + (0xff * amount);
			if (red < 0)
				red = 0;
			else if (red > 0xff)
				red = 0xff;
				
			green = this.green + (0xff * amount);
			if (green < 0)
				green = 0;
			else if (green > 0xff)
				green = 0xff;
			
			blue = this.blue + (0xff * amount);
			if (blue < 0)
				blue = 0;
			else if (blue > 0xff)
				blue = 0xff;
			
			reset(red, green, blue);
		}
		
		/**
		 * Mixes colors according to the passed-in ratio
		 * @param	color		color to be mixed with
		 * @param	ratio		amount of importance of self color
		 * 	- a value of 0 meaning that tint will be equal to paramater color
		 * 	- a value of 1 meaning that tint will be unchanged
		 */
		public function mix(color:XColor, ratio:Number = .5):void {
			reset(int((this.red + color.red) * .5), int((this.green + color.green) * .5), int((this.blue + color.blue) * .5));
		}
		
		
		/** Picks a random color between 0x000000 and 0xffffff */
		public function random():void {
			_hex = uint(Math.random() * 0xffffff);
		}
	}
}
