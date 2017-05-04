package utils.virtualkeyboard.geom.color {
	
	public class XColor32 {
		
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		//	STATIC MEMBERS
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		/** Converts separate ARGB channels values to ARGB hexadecimal value */
		public function GetHex(alpha:int, red:uint, green:uint, blue:int):void {
			_hex = (alpha << 32) | (red << 16) | (green << 8) | blue;
		}
		
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		//	INSTANCE MEMBERS
		//	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		
		private var _hex:uint;
		
		/**
		 * Constructor
		 * @param	alpha		red channel value (or complete color definition - see usage comments)
		 * @param	r			red channel value (or complete color definition - see usage comments)
		 * @param	g			green channel value
		 * @param	b			blue channel value
		 * @usage	both instanciations <code>new RGBColor(0xff, 0x0, 0x0, 0x0);</code> and <code>new RGBColor(0xff0000);</code> are equivalent
		 */
		public function XColor32(alpha:uint = 0xFF000000, red:int = -1, green:int = -1, blue:int = -1) {
			reset(alpha, red, green, blue);
		}
		
		/** Returns a clon instance */
		public function clone():XColor32 {
			return new XColor32(_hex);
		}
		
		/** Returns a string representation of the instance */
		public function toString():String {
			return "[XColor32] " + hexString
		}
		
		/** color value as an HTML formatted string (ie: #FF00FF00) */
		public function get hexString():String {
			var hexString:String, alpha:String, red:String, green:String, blue:String;
			
			alpha = this.alpha.toString(16);
			while (alpha.length < 2)
				alpha = "0" + alpha;
				
			red = this.red.toString(16);
			while (red.length < 2)
				red = "0" + red;
			
			green = this.green.toString(16);
			while (green.length < 2)
				green = "0" + green;
			
			blue = this.blue.toString(16);
			while (blue.length < 2)
				blue = "0" + blue;
			
			hexString = "#" + alpha + red + green + blue;
			hexString = hexString.toUpperCase();
			return hexString;
		}
		public function set hexString(hexString:String):void {
			var len:uint;
			
			len = hexString ? hexString.length : 0;
			if (len < 8 || len > 9) {
				trace("[XColor32.hexString] Invalid hexString value: \"" + hexString + "\"");
				hex = 0x0;
				return;
			}
			
			hexString = hexString.substr(-8);
			reset(parseInt(hexString.substr(0, 2), 16), parseInt(hexString.substr(2, 2), 16), parseInt(hexString.substr(4, 2), 16), parseInt(hexString.substr(6, 2), 16));
		}
		
		/** alpha channel value */
		public function get alpha():uint {
			return (_hex >> 24) & 0xFF;
		}
		public function set alpha(alpha:uint):void {
			if(alpha > 0xFF)
				alpha = 0xFF;
			else if (alpha < 0)
				alpha = 0;
			reset(alpha, red, green, blue);
		}
		
		/** red channel value */
		public function get red():uint {
			return (_hex >> 16) & 0xFF;
		}
		public function set red(red:uint):void {
			if(red > 0xFF)
				red = 0xFF;
			else if (red < 0)
				red = 0;
			reset(alpha, red, green, blue);
		}
		
		/** green channel value */
		public function get green():uint {
			return(_hex >> 8) & 0xFF;
		}
		public function set green(green:uint):void {
			if(green > 0xFF)
				green = 0xFF;
			else if (green < 0)
				green = 0;
			reset(alpha, red, green, blue);
		}
		
		/** blue channel value */
		public function get blue():uint {
			return _hex & 0x00FF;
		}
		public function set blue(blue:uint):void {
			if(blue > 0xFF)
				blue = 0xFF;
			else if (blue < 0)
				blue = 0;
			reset(alpha, red, green, blue);
		}
		
		/** ARGB hexadecimal value */
		public function get hex():uint {
			return _hex;
		}
		public function set hex(hex:uint):void {
			if(hex > 0xFFFFFFFF)
				hex = 0xFFFFFFFF;
			_hex = hex;
		}
		
		/** Defines ARGB hexadecimal value from separate channels values */
		public function reset(alpha:uint, red:uint, green:uint, blue:uint):void {
			if (red < 0 && green < 0 && blue < 0)
				_hex = alpha;
			else if (red < 0 || green < 0 || blue < 0)
				throw new Error("[XColor.reset] Illegal call ; reset method accept exactly 4 or 1 parameter.");
			else
				_hex = ((alpha << 24) | ((red << 16) | (green << 8) | blue));
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
			
			reset(alpha, red, green, blue);
		}
		
		/**
		 * Mixes colors according to the passed-in ratio.
		 * @param	color		color to be mixed with
		 * @param	ratio		amount of importance of self color
		 * 	- a value of 0 meaning that tint will be equal to paramater color
		 * 	- a value of 1 meaning that tint will be unchanged
		 */
		public function mix(color:XColor32, ratio:Number = .5):void {
			var ratioAlt:Number = 1 - ratio;
			reset(
				int(((this.alpha * ratio) + (color.alpha * ratioAlt)) * .5),
				int(((this.red * ratio) + (color.red * ratioAlt)) * .5),
				int(((this.green * ratio) + (color.green * ratioAlt)) * .5),
				int(((this.blue * ratio) + (color.blue * ratioAlt)) * .5)
				);
		}
		
		/**
		 * Picks a random color between 0x00000000 and 0xFFFFFFFF.
		 * @param	alpha			defined alpha value
		 */
		public function random(alpha:int = -1):void {
			_hex = (alpha >= 0) ? (alpha << 24) | uint(Math.random() * 0xFFFFFF) : uint(Math.random() * 0xFFFFFFFF);
		}
	}

}
