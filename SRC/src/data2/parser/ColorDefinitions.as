package data2.parser 
{
	/**
	 * ...
	 * @author 
	 */
	public class ColorDefinitions 
	{
		private static const _colordef:Object = {
			
			"aqua" : [0x00FFFF, "00FFFF"],
			"beige" : [0xF5F5DC, "F5F5DC"],
			"black" : [0x000000, "000000"],
			"blue" : [0x0000ff, "0000ff"],
			"brown" : [0xA52A2A, "A52A2A"],
			"chocolate " : [0xD2691E, "D2691E"],
			"cyan" : [0x00ffff, "00ffff"],
			"darkblue" : [0x00008b, "00008b"],
			"darkcyan" : [0x008B8B, "008B8B"],
			"darkgrey " : [0xA9A9A9, "A9A9A9"],
			"darkgray" : [0xA9A9A9, "A9A9A9"],
			"darkgreen" : [0x006400, "006400"],
			"darkred" : [0x8B0000, "8B0000"],
			"DarkSalmon" : [0xE9967A, "E9967A"],
			"Fuchsia" : [0xFF00FF, "FF00FF"],
			"Gold" : [0xFFD700, "FFD700"],
			"Gray" : [0x808080, "808080"],
			"Grey" : [0x808080, "808080"],
			"Green" : [0x008000, "008000"],
			"GreenYellow" : [0xADFF2F, "ADFF2F"],
			"Indigo  " : [0x4B0082, "4B0082"],
			"Ivory" : [0xFFFFF0, "FFFFF0"],
			"Khaki" : [0xF0E68C, "F0E68C"],
			"LightBlue" : [0xADD8E6, "ADD8E6"],
			"Lime" : [0x00FF00, "00FF00"],
			"Maroon" : [0x800000, "800000"],
			"Navy" : [0x000080, "000080"],
			"Olive" : [0x808000, "808000"],
			"Orange" : [0xFFA500, "FFA500"],
			"Pink" : [0xFFC0CB, "FFC0CB"],
			"Purple" : [0x800080, "800080"],
			"Red" : [0xFF0000, "FF0000"],
			"Salmon" : [0xFA8072, "FA8072"],
			"Silver" : [0xC0C0C0, "C0C0C0"],
			"SkyBlue" : [0x87CEEB, "87CEEB"],
			"Teal" : [0x008080, "008080"],
			"Tomato" : [0xFF6347, "FF6347"],
			"Turquoise" : [0x40E0D0, "40E0D0"],
			"White" : [0xFFFFFF, "FFFFFF"],
			"Yellow" : [0xFFFF00, "FFFF00"]
			
			
		};
		
		public function ColorDefinitions() 
		{
			throw new Error("is static");
		}
		
		public static function get(_str:String, _stringFormat:Boolean=false):*
		{
			var _output:*;
			
			//#RRGGBB
			if (_str.charAt(0) == "#") _str = "0x" + _str.substr(1, _str.length - 1);
			
			//0xRRGGBB
			if (_str.substr(0, 2) == "0x") {
				_output = _stringFormat ? _str.substr(2, _str.length-2) : int(_str);
			}
			else {
				//COLOR NAME
				_output = getColorByName(_str, _stringFormat);
				//trace("_output : " + _output);
				
				//RRVVBB
				if (_output == null) {
					_output = _stringFormat ? _str : int("0x" + _str);
				}
			}
			
			return _output
		}
		
		
		
		
		private static function getColorByName(_name:String, _stringFormat:Boolean):*
		{
			var _str:String = _name.toLowerCase();
			var _color:*;
			var _found:Boolean = false;
			
			for (var i in _colordef) {
				if (String(i).toLowerCase() == _str) {
					_color = _stringFormat ? _colordef[i][1] : _colordef[i][0];
					_found = true;
				}
			}
			
			//if (!_found) throw new Error("ColorDefinitions : color \"" + _name + "\"doesn't exist");
			return _color;
		}
		
	}

}