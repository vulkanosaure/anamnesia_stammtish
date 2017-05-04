package data2.layoutengine 
{
	/**
	 * ...
	 * @author Vincent
	 */
	public class MarginObject
	{
		public static const TYPE_PIXEL:String = "typePixel";
		public static const TYPE_PERCENT:String = "typePercent";
		
		private var _value:Number;
		private var _type:String;
		private var _defaultType:String = TYPE_PIXEL;
		
		
		public function MarginObject() 
		{
			
		}
		
		
		public function set(_str:*):void
		{
			//trace("MarginObject.set : " + _str);
			//todo : améliorer, doit terminer par px ou % (ici : "0px%" marche)
			
			if (_str == "") {
				_value = NaN;
				_type == null;
				return;
			}
			
			if (!(_str is Number) && !_str.match(/[\d\.]+(px|%)/)) throw new Error("format of layout property must be px or % (" + _str + ")");
			
			if (_str is Number) {
				_value = _str;
				_type = _defaultType;
			}
			else{
				var lastChar:String = _str.substr(_str.length - 1, 1);
				var strnum:String;
				if (lastChar == "x") {
					_type = TYPE_PIXEL;
					strnum = _str.substr(0, _str.length - 2);
				}
				else {
					_type = TYPE_PERCENT;
					strnum = _str.substr(0, _str.length - 1);
				}
				_value = Number(strnum);
			}
		}
		
		
		
		
		
		public function get type():String { return _type; }
		
		public function get value():Number { return _value; }
		
		public function set defaultType(value:String):void {_defaultType = value;}
		
		public function toString():String
		{
			if (isNaN(_value)) return null;
			var _str:String = _value + "";
			_str += (_type == TYPE_PIXEL) ? "px" : "%";
			return _str;
		}
		
		
		
		
		public static function getType(_str:String):String
		{
			if (!_str.match(/[\d\.]+(px|%)/)) throw new Error("format of layout property must be px or % (" + _str + ")");
			
			var lastChar:String = _str.substr(_str.length - 1, 1);
			var strnum:String;
			if (lastChar == "x") return TYPE_PIXEL;
			else return TYPE_PERCENT;
		}
		
		public static function getValue(_str:String):Number
		{
			if (!_str.match(/[\d\.]+(px|%)/)) throw new Error("format of layout property must be px or % (" + _str + ")");
			
			var lastChar:String = _str.substr(_str.length - 1, 1);
			var strnum:String;
			if (lastChar == "x") strnum = _str.substr(0, _str.length - 2);
			else strnum = _str.substr(0, _str.length - 1);
			var _value:Number = Number(strnum);
			return _value;
		}
		
		
		//__________________________________________________________
		//private functions
		
	}

}