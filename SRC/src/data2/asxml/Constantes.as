package data2.asxml 
{
	/**
	 * ...
	 * @author 
	 */
	public class Constantes 
	{
		private static var _data:Object;
		private static var _cache:Object;
		
		public function Constantes() 
		{
			throw new Error("is static");
			
		}
		
		
		public static function get(_key:String, _objbase:Object = null, _optional:Boolean = false):Object
		{
			if (_cache == null) _cache = new Object();
			else {
				if (_objbase == null) {
					if (_cache[_key] != undefined) {
						return _cache[_key];
					}
				}
			}
			
			
			if (_data == null) _data = new Object();
			
			var _tabkey:Array = _key.split(".");
			var _len:int = _tabkey.length;
			var _result:String;
			var _base:Object = _data;
			if (_objbase != null) _base = _objbase;
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _subkey:String = _tabkey[i];
				_base = _base[_subkey];
				if (!_optional && (_base == null || _base == undefined)) throw new Error("node \"" + _subkey + "\" doesn't exist in constantes");
				
			}
			
			
			if (!_optional && _base == null) throw new Error("constante \"" + _key + "\" doesn't exist");
			if (_objbase == null) {
				_cache[_key] = _base;
			}
			return _base;
		}
		
		
		
		
		
		
		
		static public function addXML(_xmlList:Object):void
		{
			if (_data == null) _data = new Object();
			//_data.push(_xmlList);
			
			var _d:Object = rec_addXML(XMLList(_xmlList), null);
			trace("_d : " + _d);
			
			/*
			d
				config
				fr
				fr
				...
				
			*/
			
			for (var _key:String in _d) 
			{
				//trace("_data[_key] : " + _data[_key]);
				
				if (_data[_key] == undefined) {
					_data[_key] = _d[_key];
				}
				else {
					var _obj:Object = _d[_key];
					for (var name:String in _obj) 
					{
						_data[_key][name] = _obj[name];
					}
				}	
			}
			
		}
		
		
		
		
		static private function rec_addXML(_xmlList:XMLList, _obj:Object):Object
		{
			var _namenode:String = _xmlList.name();
			
			var _newobj:Object = new Object();
			
			var _attributesxmllist:XMLList = _xmlList.attributes();
			for (var _k:* in _attributesxmllist) {
				var _att:String = _attributesxmllist[_k].name();
				var _value:String = _attributesxmllist[_k];
				_newobj["@" + _att] = _value;
			}
			
			var _children:XMLList = _xmlList.children();
			var _countchildren:int = 0;
			for each(var _xml:XML in _children) {
				var _namesubnode:String = _xml.name();
				
				if (_namesubnode == null) {
					_newobj = rec_addXML(XMLList(_xml), _newobj);
				}
				else {
					
					if (_newobj[_namesubnode] != undefined) {
						
						var _tab:Array;
						if (_newobj[_namesubnode] is Array) {
							_tab = _newobj[_namesubnode];
						}
						else {
							_tab = new Array();
							_tab.push(_newobj[_namesubnode]);
							_newobj[_namesubnode] = _tab;
						}
						
						_tab.push(rec_addXML(XMLList(_xml), _newobj));
					}
					else {
						_newobj[_namesubnode] = rec_addXML(XMLList(_xml), _newobj);
					}
					
					
				}
				
				_countchildren++;
			}
			if (_countchildren == 0) {
				_newobj = String(_xmlList);
			}
			
			return _newobj
		}
		
		
		
	}

}