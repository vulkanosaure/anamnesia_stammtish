package model.translation
{
	import assets.LabelYear;
	import data2.asxml.Constantes;
	import data2.asxml.ObjectSearch;
	import data2.debug.profiler.Profiler;
	import data2.display.scrollbar.Scrollbar;
	import data2.InterfaceSprite;
	import data2.text.Text;
	/**
	 * ...
	 * @author Vinc
	 */
	public class Translation 
	{
		private static var _data:Array;
		private static var _dynamicIndexes:Object;
		private static var _contentVariables:Object;
		private static var _callbacks:Object;
		private static var _curlang:String;
		
		
		public function Translation() 
		{
			throw new Error("is static");
		}
		
		
		
		public static function translate(_lang:String = "", _filters:Array = null):void
		{
			if (_lang != "") _curlang = _lang;
			else _lang = _curlang;
			
			var _len:int = _data.length;
			trace("Translation._len : " + _len);
			
			var _nbapply:int = 0;
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _item:TranslationItem = TranslationItem(_data[i]);
				if (_filters != null && _filters.indexOf(_item.iditem) == -1) continue;
				apply(_item, _lang);
				_nbapply++;
			}
			trace("_nbapply : " + _nbapply);
			
		}
		
		
		
		static public function addDynamic(_iditem:String, _keyxmltab:String, _keyxmlobj:String, _keyparam:String, _style:String, _optional:Boolean = false):void 
		{
			var _item:TranslationItem;
			
			if (_data == null) _data = new Array();
			
			var _testitem:TranslationItem = getItemByID(_iditem);
			if (_testitem == null) {
				_item = new TranslationItem();
				_data.push(_item);
			}
			else {
				_item = _testitem;
			}
			
			_item.iditem = _iditem;
			_item.keyxmltab = _keyxmltab;
			_item.keyxmlobj = _keyxmlobj;
			_item.keyparam = _keyparam;
			_item.style = _style;
			_item.optional = _optional;
			
			_item.is_dynamic = true;
		}
		
		
		
		public static function add(_iditem:String, _keyxml:String, _style:String, _styleAdd:String = "", _optional:Boolean = false, _hasVar:Boolean = false):void
		{
			var _item:TranslationItem;
			
			if (_data == null) _data = new Array();
			
			var _testitem:TranslationItem = getItemByID(_iditem);
			if (_testitem == null) {
				_item = new TranslationItem();
				_data.push(_item);
			}
			else {
				_item = _testitem;
			}
			
			_item.iditem = _iditem;
			_item.keyxml = _keyxml;
			_item.style = _style;
			_item.styleAdd = _styleAdd;
			_item.optional = _optional;
			_item.hasVar = _hasVar;
			
			_item.is_dynamic = false;
			
			
		}
		
		static private function getItemByID(_id:String):TranslationItem 
		{
			var _len:int = _data.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _item:TranslationItem = TranslationItem(_data[i]);
				if (_item.iditem == _id) return _item;
			}
			return null;
		}
		
		
		
		
		static public function setDynamicIndex(_key:String, _value:int):void
		{
			if (_dynamicIndexes == null) _dynamicIndexes = new Object();
			_dynamicIndexes[_key] = _value;
		}
		
		static public function setContentVariable(_key:String, _value:String):void
		{
			if (_contentVariables == null) _contentVariables = new Object();
			_contentVariables[_key] = _value;
		}
		
		static public function addCallback(_iditem:String, _callback:Function):void 
		{
			if (_callbacks == null) _callbacks = new Object();
			_callbacks[_iditem] = _callback;
		}
		
		
		
		
		static public function apply(_item:TranslationItem, _lang:String):void 
		{
			var _text:Text = Text(ObjectSearch.getID(_item.iditem));
			var _str:String;
			if (_dynamicIndexes == null) _dynamicIndexes = new Object();
			
			if (!_item.is_dynamic) {
				_str = String(Constantes.get(_lang + "." + _item.keyxml));
			}
			else {
				if (_dynamicIndexes[_item.keyparam] == undefined) return;
				var _valueparam:int = int(_dynamicIndexes[_item.keyparam]);
				//trace("_valueparam : " + _valueparam);
				
				var _obj:Object =  Constantes.get(_lang + "." + _item.keyxmltab);
				if (_obj is Array) { } else throw new Error("xml node '" + _item.keyxmltab + "' must be a list (item must be specified)");
				
				var _tab:Array = _obj as Array;
				//trace("_tab : " + _tab);
				
				if (_valueparam >= _tab.length) throw new Error("index " + _valueparam + " is bigger then tab length : " + _tab.length);
				var _it:Object = _tab[_valueparam];
				
				try {
					_str = String(Constantes.get(_item.keyxmlobj, _it));
				}
				catch (e:Error) {
					if (!_item.optional) throw new Error("xml element " + _item.keyxmlobj + " not found");
				}
				
				//trace("_str : " + _str);
				
			}
			
			if (_item.hasVar && _contentVariables != null) {
				var _matches:Array = _str.match(/%%(.+)%%/);
				var _keyvar:String = _matches[1];
				var _value:String = _contentVariables[_keyvar];
				_str = _str.replace("%%" + _keyvar + "%%", _value);
			}
			
			
			var _valuestr:String = '';
			if (_item.style != '') _valuestr += '<span class="' + _item.style + '">';
			
			if (_item.styleAdd != "") _valuestr += "<span style='" + _item.styleAdd + "'>";
			
			_valuestr += _str;
			
			if (_item.styleAdd != "") _valuestr += '</span>';
			if (_item.style != '') _valuestr += '</span>';
			
			
			
			Profiler.start("updateText", "Translation");
			_text.value = _valuestr;
			_text.updateText();
			Profiler.end("updateText", "Translation");
			
			if (_callbacks != null && _callbacks[_item.iditem] != null) {
				_callbacks[_item.iditem](_text);
			}
			
			
		}
		
		
		
		
		
	}

}