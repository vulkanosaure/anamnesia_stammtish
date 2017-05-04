package data2.text 
{
	import data2.parser.StyleSheet2;
	/**
	 * ...
	 * @author 
	 */
	public class TextParser 
	{
		private static var _value:String;
		
		public function TextParser() 
		{
			
		}
		
		static public function parse(__value:String, _ss:StyleSheet2):String 
		{
			var _str:String = "";
			var _value = __value;
			
			var _stylenames:Array = _ss.styleNamesCase;
			trace("_stylenames : " + _stylenames);
			
			
			var _xmllist:XMLList = new XMLList(_value);
			trace("_xmllist : " + _xmllist);
			scan_recursive(_xmllist);
			
			return _str;
		}
		
		
		static public function scan_recursive(_xmllist:Object):void
		{
			if (_xmllist.name() == null) return;
			trace("scan_recursive " + _xmllist.name());
			
			var _attributes:Object = new Object();
			var _attributesxmllist:XMLList = _xmllist.attributes();
			for (var _k:* in _attributesxmllist) {
				var _att:String = _attributesxmllist[_k].name();
				_attributes[_att] = _attributesxmllist[_k];
				trace("   -- _att : " + _att + ", " + _k + ", " + _attributes[_att]);
			}
			
			var _children:XMLList = _xmllist.children();
			for each(var _xml:Object in _children){
				scan_recursive(_xml);
			}
		}
	}

}