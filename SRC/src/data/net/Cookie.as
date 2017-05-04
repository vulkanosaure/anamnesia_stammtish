package data.net 
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author vinc
	 */
	public class Cookie 
	{
		private static var _cookie:SharedObject;
		private static var _name:String;
		private static var _simuleValues:Object;
		
		
		public function Cookie() 
		{
			throw new Error("is static");
		}
		
		public static function init(__name:String):void
		{
			_name = __name;
			_cookie = SharedObject.getLocal(_name);
			_simuleValues = new Object();
		}
		
		
		public static function exists():Boolean
		{
			return (_cookie.data.id_user != undefined && _cookie.data.id_user != "");
		}
		
		static public function isset(_key:String):Boolean
		{
			return (_cookie.data[_key] != undefined);
		}
		
		static public function isDefined(_key:String):Boolean 
		{
			return (_cookie.data[_key] != undefined && _cookie.data[_key] != "");
		}
		
		public static function getValue(_key:String):*
		{
			if (_simuleValues[_key] != undefined) return _simuleValues[_key];
			return _cookie.data[_key];
		}
		
		public static function g(_key:String):*
		{
			return getValue(_key);
		}
		
		public static function setValue(_key:String, _value:*):void
		{
			_cookie.data[_key] = _value;
		}
		
		
		static public function addValue(_key:String, _valueadd:Number):void 
		{
			var _val:Number = getValue(_key);
			setValue(_key, _val + _valueadd);
		}
		
		public static function setSimuleValue(_key:String, _value:*):void
		{
			_simuleValues[_key] = _value;
		}
		
		
		public static function save():void
		{
			_cookie.flush();
		}
		
		public static function reset():void 
		{
			for (var _key:String in _cookie.data) 
			{
				_cookie.data[_key] = undefined;
			}
			_cookie.flush();
		}
		
		
		public static function toString():String
		{
			var _str:String = "";
			_str += "Cookies \"" + _name + "\"\n";
			for (var _key:String in _cookie.data) 
			{
				_str += "   - " + _key + " : " + getValue(_key) + "\n";
			}
			return _str;
		}
		
		
	}

}