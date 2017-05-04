package data2.text 
{
	import data2.asxml.ClassManager;
	import data2.parser.ColorDefinitions;
	import data2.parser.StyleSheet2;
	import flash.text.Font;
	import flash.text.StyleSheet;
	/**
	 * ...
	 * @author 
	 */
	public class TextStylesheetConverter 
	{
		private static const GLOBAL_CLASSES:Array = ["body", "*"];
		private static const COLOR_PROPERTIES:Array = ["color"];
		private static const STYLES_BASES:Array = [
													{"type" : "h1", "props" : { "fontSize" : "32px" } },
													{"type" : "h2", "props" : { "fontSize" : "24px" } },
													{"type" : "h3", "props" : { "fontSize" : "18px" } },
													{"type" : "h4", "props" : { "fontSize" : "16px" } },
													{"type" : "h5", "props" : { "fontSize" : "13px" } },
													{"type" : "h6", "props" : { "fontSize" : "10px" } },
													{"type" : "p", "props" : { "fontSize" : "12px" } },
													{"type" : "b", "props" : { "fontWeight" : "bold" } },
													{"type" : "strong", "props" : { "fontWeight" : "bold" } },
													{"type" : "center", "props" : { "textAlign" : "center" } },
													{"type" : "cite", "props" : { "textStyle" : "italic" } },
													{"type" : "em", "props" : { "textStyle" : "italic" } },
													{"type" : "i", "props" : { "textStyle" : "italic" } },
													{"type" : "u", "props" : { "textDecoration" : "underline" } },
													{"type" : "a", "props" : { "color" : "#1122CC", "textDecoration" : "underline" } }
		];
		
		private static var _listFont:Array;
		private static var _ready:Boolean = false;
		
		
		private static var _styleSheetNativeBase:StyleSheet;
		private static var _styleSheetCustom:StyleSheet;
		
		public function TextStylesheetConverter() 
		{
			throw new Error("is static");
			
		}
		
		
		
		public static function init(__styleSheetCustom:StyleSheet2):void
		{
			_styleSheetCustom = __styleSheetCustom;
			
			_styleSheetNativeBase = new StyleSheet();
			//todo : add default styles
			
			for each (var _propbase:Object in STYLES_BASES) 
			{
				var _type:String = _propbase["type"];
				var _props:Object = _propbase["props"];
				_styleSheetNativeBase.setStyle("." + _type, _props );
			}
			
			customToNative(_styleSheetCustom);
			
			//list fonts
			_listFont = Font.enumerateFonts(true);
			
			_ready = true;
		}
		
		
		
		public static function ready():Boolean
		{
			return _ready;
		}
		
		
		
		
		public static function process(_content:String):Object
		{
			var _output:Object = new Object();
			var _styleSheet:StyleSheet = copyStylesheet(_styleSheetNativeBase);
			
			var _newcontent:String = _content;
			
			//global
			_newcontent = "<span class='body_global'>" + _newcontent + "</span>";
			
			
			//replace <div by <br /><span 
			_newcontent = _newcontent.replace(/<div /g, "<br /><span ");
			_newcontent = _newcontent.replace(/<\/div>/g, "</span>");
			
			
			//parcours tous les types natifs
				//cherche ds la string <$style et remplace par <span class='$style'
				//cherche ds la string </$style> et remplace par </span>
				
			var _nbstylebases:int = STYLES_BASES.length;
			for (var i:int = 0; i < _nbstylebases; i++) 
			{
				var _stylename:String = STYLES_BASES[i].type;
				if (_stylename == "a") continue;		//exception pour le <a>
				//pour les "types"
				
				var _regex1:RegExp = new RegExp("<" + _stylename + ">", "g");
				var _regex2:RegExp = new RegExp("</" + _stylename +">", "g");
				_newcontent = _newcontent.replace(_regex1, "<span class='" + _stylename + "'>");
				_newcontent = _newcontent.replace(_regex2, "</span>");
				//trace("transform " + _stylename + ", " + _newcontent);
				
			}
			
			
			//exception pour le <a>
			_newcontent = _newcontent.replace(/<a (.+?)>/g, "<span class='a'><a $1>");
			_newcontent = _newcontent.replace(/<\/a>/g, "</a></span>");
			
			
			
			
			//inline style
			var _regexInline:RegExp = new RegExp(" style=(\"|')(.+?)(\"|')", "g");
			var _tabregexinline:Array = _newcontent.match(_regexInline);
			//trace("_tabregexinline : " + _tabregexinline);
			var _nbinline:int = _tabregexinline.length;
			var _counterinlinestyle:int = 0;
			
			for (var j:int = 0; j < _nbinline; j++) 
			{
				var _inlinestyle:String = _tabregexinline[j];
				//trace("_inlinestyle : " + _inlinestyle);
				var _tab:Array = _inlinestyle.match(/=(\"|')(.+?)(\"|')/);
				//trace(" --- _tab : " + _tab);
				var _liststyle:String = _tab[2];
				var _tabstyle:Array = _liststyle.split(";");
				
				var _objstyle:Object = new Object();
				var _nbstyle:int = _tabstyle.length;
				for (var k:int = 0; k < _nbstyle; k++) 
				{
					var _styledef:String = _tabstyle[k];
					_styledef = _styledef.replace(/ /g, "");
					if (_styledef == "") continue;
					var _tabkeyvalue:Array = _styledef.split(":");
					var _objpropvalue:Object = transformPropValue(_tabkeyvalue[0], _tabkeyvalue[1]);
					_objstyle[_objpropvalue.prop] = _objpropvalue.value;
					//trace("_objstyle[" + _objpropvalue.prop + "] = " + _objpropvalue.value + "/");
				}
				
				var _idstyle:String = "inlinestyle_" + _counterinlinestyle;
				_styleSheet.setStyle("." + _idstyle, _objstyle);
				_newcontent = _newcontent.replace(_inlinestyle, " class='" + _idstyle + "'");
				//trace("_newcontent : " + _newcontent);
				
				_counterinlinestyle++;
			}
			
			
			
			
			//font checking
			var _fontType:String = "device";
			
			var _stylenames:Array = _styleSheet.styleNames;
			var _len:int = _stylenames.length;
			for (var l:int = 0; l < _len; l++) 
			{
				var _stylename:String = _stylenames[l];
				var _obj:Object = _styleSheet.getStyle(_stylename);
				for (var _prop:String in _obj) 
				{
					//trace(" --- _prop : " + _prop+" = "+_obj[_prop]);
					if (_prop == "fontFamily") {
						var _value:String = _obj[_prop];
						
						//existance
						_fontType = getFontType(_value);
						if (_fontType == "") {
							
							//suggestion
							var _list:Array = new Array();
							for each (var _font:Font in _listFont) _list.push(_font.fontName);
							var _suggestion:String = ClassManager.getSuggestion(_list, _value);
							
							throw new Error("fontFamily \"" + _value + "\" doesn't exist, did you mean \"" + _suggestion + "\" ?");
						}
						
					}
				}
				
			}
			
			
			_output["content"] = _newcontent;
			_output["styleSheet"] = _styleSheet;
			_output["fontType"] = _fontType;
			
			//trace("_fontType : " + _fontType);
			
			return _output;
		}
		
		static private function extractFirstPart(_stylename:String):String 
		{
			var _tab:Array = _stylename.split(" ");
			return String(_tab[0]);
		}
		
		
		
		
		
		
		
		//___________________________________________________________________
		//private functions
		
		private static function copyStylesheet(_ss:StyleSheet):StyleSheet
		{
			var _copy:StyleSheet = new StyleSheet();
			var _stylenames:Array = _ss.styleNames;
			var _len:int = _stylenames.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _stylename:String = _stylenames[i];
				var _obj:Object = _ss.getStyle(_stylename);
				_copy.setStyle(_stylename, _obj);
			}
			return _copy;
		}
		
		
		private static function customToNative(_ssCustom:StyleSheet):void
		{
			var _stylenames:Array = _ssCustom.styleNames;
			var _len:int = _stylenames.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _stylename:String = _stylenames[i];
				var _styleObj:Object = _ssCustom.getStyle(_stylename);
				
				//global
				if (GLOBAL_CLASSES.indexOf(_stylename) != -1) {
					_stylename = ".body_global";
				}
				//type
				else if (_stylename.charAt(0) != ".") {
					_stylename = "." + _stylename;
				}
				
				//prop transformation (todo)
				for (var _prop:String in _styleObj) {
					
					//_styleObj[_prop] = transformProp(
					var _objpropvalue:Object = transformPropValue(_prop, _styleObj[_prop]);
					//trace("___________________________");
					_styleObj[_objpropvalue.prop] = _objpropvalue.value;
				}
				
				
				//if style allready exist, combine styles
				var _existingStyleObj:Object = _styleSheetNativeBase.getStyle(_stylename);
				if (_existingStyleObj != null) {
					for (var _prop:String in _existingStyleObj) {
						if (_styleObj[_prop] == undefined) {
							_styleObj[_prop] = _existingStyleObj[_prop];
						}
					}
				}
				
				_styleSheetNativeBase.setStyle(_stylename, _styleObj);
			}
		}
		
		
		
		static private function transformPropValue(_prop:String, _value:String):Object 
		{
			var _output:Object = new Object();
			_prop = _prop.replace(/ /g, "");
			//_value = _value.replace(/ /g, "");
			
			_prop = StyleSheet2.formatProperty(_prop);
			
			//color transform
			if (COLOR_PROPERTIES.indexOf(_prop) != -1) {
				_value = "#" + ColorDefinitions.get(_value, true);
			}
			
			_output["prop"] = _prop;
			_output["value"] = _value;
			return _output;
		}
		
		
		
		
		static private function isStyleBase(_stylename:String):Boolean 
		{
			var _len:int = STYLES_BASES.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _sname:String = STYLES_BASES[i].type;
				if (_sname == _stylename) return true;
			}
			return false;
		}
		
		
		
		private static function getFontType(_fontname:String):String
		{
			for each (var _font:Font in _listFont) 
			{
				if (_font.fontName == _fontname) return _font.fontType;
			}
			return "";
		}
		
	}

}