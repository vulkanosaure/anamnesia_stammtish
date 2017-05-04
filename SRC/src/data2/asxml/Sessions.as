package data2.asxml 
{
	/**
	 * ...
	 * @author 
	 */
	public class Sessions
	{
		private static var _data:Object;
		private static var _bindings:Array;
		
		public function Sessions() 
		{
			throw new Error("is static");
			
		}
		
		
		public static function set(_key:String, _value:*):void
		{
			if (_data == null) _data = new Object();
			_data[_key] = _value;
			
			updateBindings(_key);
		}
		
		
		public static function get(_key:String):*
		{
			if (_data == null) _data = new Object();
			if (_data[_key] == undefined) throw new Error("session \"" + _key + "\" doesn't exist");
			return _data[_key];
		}
		
		public static function isset(_key:String):Boolean
		{
			if (_data == null) _data = new Object();
			return (_data[_key] != undefined);
		}
		
		
		
		public static function addBinding(_sessionkey:String, _object:*, _prop:String, _strbefore:String, _strafter:String):void
		{
			
			if (_bindings == null) _bindings = new Array();
			_bindings.push( { "sessionkey" : _sessionkey, "object" : _object, "prop" : _prop, "strbefore" : _strbefore, "strafter" : _strafter } );
			if (isset(_sessionkey)) updateBindings(_sessionkey);
		}
		
		
		
		
		//______________________________________________________________________
		//private functions
		
		static private function updateBindings(_sessionkey:String):void 
		{
			var _len:int = (_bindings == null) ? 0 : _bindings.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _binding:Object = _bindings[i];
				if (_binding.sessionkey == _sessionkey) {
					var _obj:* = _binding.object;
					var _prop:String = _binding.prop;
					var _strbefore:String = _binding.strbefore;
					var _strafter:String = _binding.strafter;
					
					var _value:* = _data[_sessionkey];
					
					if (_strbefore == "" && _strafter == "") {
						//trace("sessions : " + _obj + "[" + _prop + "] = "+ _value);
						_obj[_prop] = _value;	//pour pas qu'il convertisse en string si pas besoin
					}
					else {
						//trace("sessions : " + _obj + "[" + _prop + "] = " + _strbefore + " + " + _value + " + " + _strafter);
						_obj[_prop] = _strbefore + _value + _strafter;
					}
				}
			}
		}
		
		
	}

}