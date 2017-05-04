package data2.parser 
{
	import flash.text.StyleSheet;
	/**
	 * ...
	 * @author 
	 */
	public class StyleSheet2 extends StyleSheet
	{
		private var _styleNamesCase:Array;
		
		public function StyleSheet2() 
		{
			super();
			_styleNamesCase = new Array();
		}
		
		
		public static function formatProperty(_prop:String):String
		{
			var _regexAfterTiret:RegExp = new RegExp("^[a-zA-Z]$");
			for (var k:int = 0; k < _prop.length; k++) 
			{
				if (_prop.charAt(k) == "-") {
					
					var _nextChar:String = (k < _prop.length - 1) ? _prop.charAt(k + 1) : "";
					if (_regexAfterTiret.test(_nextChar)) {
						//todo : replace -[char] par [CHAR]
						_prop = _prop.substr(0, k) + _prop.charAt(k + 1).toUpperCase() + _prop.substr(k + 2, _prop.length - (k + 2));
						k--;
					}		
				}
			}
			return _prop;
		}
		
		
		override public function parseCSS(CSSText:String):void 
		{
			
			//remove linebreak, tab, spaces
			
			var _str:String = CSSText.replace(/\r\n/g, "");
			_str = _str.replace(/\n/g, "");
			//_str = _str.replace(/ /g, "");
			_str = _str.replace(/\t/g, "");
			
			//trace("css _str : " + _str);
			
			//commentaires
			_str = _str.replace(/\/\*(.*?)\*\//g, "");
			
			
			
			//get all selector data
			
			//var _tabselector:Array = _str.match(/([\w-:\*#\.]+)\{(.*?)}/g);
			var _tabselector:Array = _str.match(/([\w-:\*#\. ;="']+)\{(.*?)}/g);
			
			var _nbselector:int = _tabselector.length;
			for (var i:int = 0; i < _nbselector; i++) 
			{
				var _selectordata:String = _tabselector[i];
				
				var _tab2:Array = _selectordata.match(/^(.+)\{(.*)}$/);
				//trace("_tab2 : " + _tab2);
				var _selectorname:String = _tab2[1];
				var _attributedata:String = _tab2[2];
				
				//trace("_selectorname:" + _selectorname + "/");
				//trace("_attributedata : " + _attributedata);
				
				var _styledef:Object = new Object();
				
				//get attribute from selector
				
				var _attributetab:Array = _attributedata.split(";");
				var _nbattribute:int = _attributetab.length;
				for (var j:int = 0; j < _nbattribute; j++) 
				{
					var _attribute:String = _attributetab[j];
					
					if (_attribute != "") {
						
						//split attribute in key=>value
						
						var _pairkeyvalue:Array = _attribute.split(":");
						if (_pairkeyvalue.length == 2) {
							var _key:String = _pairkeyvalue[0];
							var _value:String = _pairkeyvalue[1];
							
							//transform "-x" into "X"
							_key = StyleSheet2.formatProperty(_key);
							
							//trace(" ---- _key:" + _key + ", _value:" + _value + "/");
							_styledef[_key] = _value;
						}
						
					}
					
				}
				
				this.setStyle(_selectorname, _styledef);
				_styleNamesCase.push(_selectorname);
				
			}
			//trace("_str : " + _str);
			
		}
		
		
		
		
		
		public function get styleNamesCase():Array 
		{
			return _styleNamesCase;
		}
	}

}