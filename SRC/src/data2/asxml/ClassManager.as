package data2.asxml 
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Vincent
	 */
	public class ClassManager
	{
		//_______________________________________________________________________________
		// properties
		
		
		private static const CLASS_SHORCUTS:Object = { "is" : "InterfaceSprite",
														"img" : "Image",
														"trace" : "ASXMLTracer"
													};
		
		private static const CLASS_CHILD_AS_PROP:Array = [ { "_class":"Text", "_prop":"value" }
														];
		
		
		private static var _classpaths:Array;
		private static var _classnames:Array;
		
		
		
		public function ClassManager() 
		{
			throw new Error("is static");
			
		}
		
		
		
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		
		public static function getClassByName(_classname:String, _caseSensitive:Boolean=true):Class
		{
			if (_classpaths == null) _classpaths = new Array();
			if (_classnames == null) _classnames = new Array();
			
			_classname = convertShorcut(_classname);
			
			if (!_caseSensitive) {
				_classname = correctCaseClassname(_classname);
			}
			
			if (_classpaths == null) _classpaths = new Array();
			var _len:int = _classpaths.length;
			
			var _class:Class = getClassByClassPath(_classname);
			if (_class != null) return _class;
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _classpath:String = _classpaths[i];
				//trace("_classpath : " + _classpath);
				_class = getClassByClassPath(_classpath + "." + _classname);
				if (_class != null) return _class;
			}
			return null;
		}
		
		
		
		
		public static function registerClass(_class:Class):void
		{
			if (_classpaths == null) _classpaths = new Array();
			if (_classnames == null) _classnames = new Array();
			
			
			var _classpath:String = getQualifiedClassName(_class);
			var _ind:int = _classpath.indexOf("::");
			
			var _classname:String = _classpath.substr(_ind + 2, _classpath.length - _ind - 2);
			_classpath = _classpath.substr(0, _ind);
			
			//trace("_classpath : " + _classpath);
			addClasspath(_classpath);
			if (_classnames.indexOf(_classname) == -1) _classnames.push(_classname);
		}
		
		
		
		public static function getListProperties(_instanceChild:*, _types:Array):Array 
		{
			var _xmlList:XMLList = new XMLList(describeType(_instanceChild));
			var _tab:Array = new Array();
			for (var i in _xmlList..accessor) {
				var _xml:XML = _xmlList.accessor[i];
				if (_types.indexOf(String(_xml.@access)) != -1) {
					_tab.push( {"name" : _xml.@name, "type" : _xml.@type } );
				}
			}
			
			_tab.sortOn("name");
			return _tab;
		}
		
		
		
		
		public static function formatListProperties(_list:Array):String
		{
			var _str:String = "";
			for each (var _obj:Object in _list) 
			{
				_str += _obj.name + ":" + _obj.type + "\n";
			}
			return _str;
		}
		
		
		
		
		public static function getSuggestion(_listprop:Array, _prop:String):String
		{
			var _tab:Array = new Array();
			var _scores:Array = new Array();
			var _scoreMax:Number = -9999;
			var _propmax:String;
			
			for each (var _proptest:String in _listprop) 
			{
				var _score:Number = 0;
				var _len:int = _proptest.length;
				var _curprop:String = _prop;
				//trace("__________________ " + _prop + " VS " + _proptest);
				for (var j:int = 0; j < _len; j++) 
				{
					var _char:String = _proptest.charAt(j);
					var _indexof:int = _curprop.indexOf(_char);
					//trace("_curprop : " + _curprop);
					if (_indexof != -1) {
						_score++;
						_curprop = _curprop.substr(0, _indexof) + _curprop.substr(_indexof + 1, _curprop.length - (_indexof + 1));
					}
					else _score --;
				}
				_scores.push(_score);
				if (_score > _scoreMax) {
					_scoreMax = _score;
					_propmax = _proptest;
				}
			}
			return _propmax;
		}
		
		
		
		
		static public function setProperty(_obj:*, _key:String, _value:Object):void
		{
			//trace("ClassManager.setProperty(" + _obj + ", " + _key + ", " + _value + ")");
			//_obj[_key] = _value;
			
			try {
				_obj[_key] = _value;
			}
			catch (e:Error) {
				
				if (!(e is ReferenceError)) throw new Error(e);
				var _listproptype:Array = ClassManager.getListProperties(_obj, ["readwrite", "writeonly"]);
				var _listproptypestr:String = ClassManager.formatListProperties(_listproptype);
				
				var _listprop:Array = new Array();
				for each (var _obj:Object in _listproptype) _listprop.push(_obj.name);
				
				var _suggestion:String = ClassManager.getSuggestion(_listprop, _key);
				throw new Error("Property \"" + _key + "\" doesn't exist for Object " + ObjectSearch.formatObject(_obj) + ", did you mean \"" + _suggestion + "\" ?\n" + _listproptypestr);
				
			}
			
		}
		
		
		static public function getChildAsProp(_object:*):String
		{
			var _len:int = CLASS_CHILD_AS_PROP.length;
			var _prop:String = "";
			for (var i:int = 0; i < _len; i++) 
			{
				var _objdef:Object = CLASS_CHILD_AS_PROP[i];
				if (_object == _objdef._class) {
					_prop = _objdef._prop;
					break;
				}
			}
			return _prop;
		}
		
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		static private function correctCaseClassname(_classname:String):String 
		{
			var _lowerclassname:String = _classname.toLowerCase();
			var _nbclass:int = _classnames.length;
			for (var i:int = 0; i < _nbclass; i++) 
			{
				var _csmodel:String = _classnames[i];
				if (_csmodel.toLowerCase() == _lowerclassname) return _csmodel;
			}
			return "";
		}
		
		
		private static function addClasspath(_classpath:String):void
		{
			if(_classpaths.indexOf(_classpath)==-1) _classpaths.push(_classpath);
		}
		
		
		public static function getClassByClassPath(_classpath:String):Class
		{
			var _class:Class;
			try { _class = getDefinitionByName(_classpath) as Class}
			catch (e) { return null;}
			return _class;
		}
		
		
		private static function convertShorcut(_classname:String):String 
		{
			for (var i:String in CLASS_SHORCUTS) {
				if (_classname == i) return CLASS_SHORCUTS[i];
			}
			return _classname;
		}
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}