/*
//TODO
	//get behaviours
	//get classname
	
//langage de recherche d'object
on peut chercher soit :
	des displayobject #name ou .classname
	des behaviours
	
on peut utiliser "." et ".." et on sépare par des "/" (comme pour naviguer ds des répertoires)
on peut ajouter [x] apres un dobjdef pour spécifier l'index (défault = 0)

TODO : later, index négatif qui vont compter a l'envers a partir du dernier (peut etre utile pour les liste dynamique)




*/
package data2.asxml 
{
	import data2.layoutengine.LayoutEngine;
	import data2.layoutengine.LayoutSprite;
	import data2.behaviours.Behaviour;
	import data2.InterfaceSprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class ObjectSearch 
	{
		private static var _listInstances:Object;
		private static var _flashvarsObject:Object;
		private static var _constantes:Object;	//todo
		
		private static var _objectByClass:Object;
		
		
		public function ObjectSearch() 
		{
			throw new Error("is static");
		}
		
		
		
		
		
		
		
		
		
		public static function flashvars(_key:String):String
		{
			if (_flashvarsObject[_key] == undefined) {
				trace("WARNING : flashvars \"" + _key + "\" is not defined");
				_flashvarsObject[_key] = "";
			}
			return _flashvarsObject[_key];
		}
		
		static public function set flashvarsObject(value:Object):void { _flashvarsObject = value; }
		
		static public function setDefaultFlashvars(_xmlList:XMLList):void 
		{
			var _children:XMLList = _xmlList.children();
			for each(var _xml:XML in _children) {
				var _namesubnode:String = _xml.name();
				//trace("_namesubnode : " + _namesubnode + ", _xml : " + _xml);
				if (_flashvarsObject[_namesubnode] == undefined) _flashvarsObject[_namesubnode] = String(_xml);
			}
		}
		
		
		
		
		
		
		
		public static function registerID(_object:Object, _id:String, _checkIDdoublons:Boolean):void
		{
			if (_listInstances == null) _listInstances = new Object();
			if (_checkIDdoublons && _listInstances[_id] != null) throw new Error("id #" + _id + " is allready defined for instance " + _listInstances[_id]);
			_listInstances[_id] = _object;
			
		}
		
		public static function resetID():void
		{
			_listInstances = new Object();
		}
		
		public static function registerClass(_object:Object):void
		{
			if (_objectByClass == null) _objectByClass = new Object();
			
			var _classname:String = getClassName(_object);
			
			var _tab:Array = _objectByClass[_classname];
			if (_tab == null) _tab = new Array();
			
			_tab.push(_object);
			_objectByClass[_classname] = _tab;
		}
		
		
		
		
		
		public static function getObjectByClass(_classname:String):Array
		{
			if (_objectByClass == null) {
				_objectByClass = new Object();
			}
			var _tab:Array = _objectByClass[_classname];
			if (_tab == null) _tab = new Array();
			return _tab;
		}
		
		public static function idExists(_id:String):Boolean
		{
			var _object:Object = _listInstances[_id];
			return (_object != null);
		}
		
		public static function getID(_id:String):Object 
		{
			if (_listInstances == null) _listInstances = new Object();
			var _object:Object = _listInstances[_id];
			if (_object == null) throw new Error("id #" + _id + " is not defined");
			return _object;
		}
		
		
		public static function getClass(_dobjc:DisplayObjectContainer, _value:String):Array 
		{
			recursiveSearchResult = new Array();
			recursiveSearch(_dobjc, _value, ".");
			return recursiveSearchResult;
		}
		
		public static function getName(_dobjc:DisplayObjectContainer, _value:String):Array 
		{
			recursiveSearchResult = new Array();
			recursiveSearch(_dobjc, _value, "*");
			return recursiveSearchResult;
		}
		
		private static var recursiveSearchResult:Array;
		private static function recursiveSearch(_container:DisplayObjectContainer, _value:String, _type:String):void
		{
			var _len:int = _container.numChildren;
			for (var i:int = 0; i < _len; i++) 
			{
				var _child:DisplayObject = _container.getChildAt(i);
				if (_type == "." && getClassName(_child) == _value) recursiveSearchResult.push(_child);
				else if (_type == "*" && _child.name == _value) recursiveSearchResult.push(_child);
				
				if (_child is DisplayObjectContainer) {
					recursiveSearch(DisplayObjectContainer(_child), _value, _type);
				}
			}
		}
		
		
		public static function search(_dobjc:Object, _searchstr:String):Object
		{
			if (_searchstr.charAt(_searchstr.length - 1) == "/") 
				_searchstr = _searchstr.substr(0, _searchstr.length - 1);
			
			var _tab:Array = _searchstr.split("/");
			var _len:int = _tab.length;
			var _wrongformats:Array = new Array();
			var _tabsave:Array = new Array();
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _str:String = _tab[i];
				if (!_str.match(/^(\.\.|\.|((#|\.|\*)[\w]+(\[-?\d+\])?)|behaviours)$/)) _wrongformats.push(_str);
			}
			if (_wrongformats.length > 0) throw new Error("ObjectSearch : wrong format for search : \"" + _wrongformats + "\"");
			
			
			
			var _object:Object = _dobjc;
			var _saveobject:Object = _object;
			var _prevstr:String = "";
			for (i = 0; i < _len; i++) {
				var _str:String = _tab[i];
				
				if (_str == ".") _object = _object;
				
				else if (_str == "..") {
					if (!(_object is DisplayObject)) throw new Error("ObjectSearch : " + _prevstr + " must be a DisplayObject if you use .. after (" + _searchstr + ")");
					if (_object is Stage) throw new Error("ObjectSearch : you can't go beyond stage (" + _searchstr + ")");
					_object = DisplayObject(_object).parent;
				}
				
				else if (_str == "behaviours") {
					if (!(_object is InterfaceSprite)) throw new Error("ObjectSearch : " + _prevstr + " must be a InterfaceSprite if you use behaviours after (" + _searchstr + ")");
					if (_prevstr == "behaviours") throw new Error("ObjectSearch : you can't use behaviours 2 times in a row (" + _searchstr + ")");
					
				}
				//# . *
				else {
					
					if (_object is Array) throw new Error("ObjectSearch : if you ask for an array of result, this array must be the last term of the search");
					
					var _type:String = _str.charAt(0);
					
					var _indexCrochet:int = _str.indexOf("[");
					var _indexEndValue:int = (_indexCrochet == -1) ? _str.length : _indexCrochet;
					
					var _value:String = _str.substr(1, _indexEndValue - 1);
					var _index:int;
					
					if (_indexCrochet == -1) _index = 0;
					else {
						var _tabmatch:Array = _str.match(/\[(-?\d+)\]/);
						_index = _tabmatch[1];
					}
					
					//trace("def, _type : " + _type + ", _value : " + _value + ", _index : " + _index);
					
					
					
					//get from behaviours list
					if (_prevstr == "behaviours") {
						if (_type == "*" || _type=="#") throw new Error("ObjectSearch : you can't use * or # def in a behaviours search (" + _searchstr + ")");
						if (_index != 0) throw new Error("ObjectSearch : you can't set an index for behaviours (" + _str + ")");
						//on est sur qu'object est un InterfaceSprite ici (vérif plus haut)
						_object = getBehaviour(InterfaceSprite(_object), _value);
					}
					//get from displaylist
					else {
						//trace("DisplayObjectContainer("+_object+").numChildren : " + DisplayObjectContainer(_object).numChildren);
						if (_object == null) throw new Error("ObjectSearch : object \"" + _str + "\" was not found");
						if (!(_object is DisplayObjectContainer)) throw new Error("ObjectSearch : \"" + _prevstr + "\" ("+_object+") must be a DisplayObjectContainer");
						if (DisplayObjectContainer(_object).numChildren>0 && _index >= DisplayObjectContainer(_object).numChildren) throw new Error("ObjectSearch : \"" + _str + "\", index is out of bound in " + formatObject(_object));
						if (DisplayObjectContainer(_object).numChildren>0 && _index < -DisplayObjectContainer(_object).numChildren) throw new Error("ObjectSearch : \"" + _str + "\", index is out of bound in " + formatObject(_object));
						
						
						if (_type == "#") {
							_object = getID(_value);
						}
						else{
							var _objecttest:Object = getChildAtIndex(DisplayObjectContainer(_object), _type, _value, _index, _indexCrochet);
							if (_objecttest == null && _object is InterfaceSprite) {
								//trace("one more chance in template obj");
								var _tpl:Sprite = InterfaceSprite(_object).objtpl;
								if (_tpl != null) {
									_objecttest = getChildAtIndex(_tpl, _type, _value, _index, _indexCrochet);
								}
							}
							_object = _objecttest;
						}
						
						
						//trace("_object : " + _object);
					}
				}
				
				if (_object == null) {
					var _strerror:String = "ObjectSearch : object " + _str + " was not found in " + formatObject(_saveobject);
					if (_saveobject is DisplayObject) _strerror += " *" + DisplayObject(_saveobject).name;
					_strerror += " (" + _searchstr + ")";
					_strerror += "\n";
					for (var k:int = 0; k < _tabsave.length; k++) {
						_strerror += formatObject(_tabsave[k]);
						_strerror += "\n";
						
					}
					throw new Error(_strerror);
				}
				_prevstr = _str;
				_saveobject = _object;
				_tabsave.push(_object);
			}
			
			return _object;
		}
		
		
		
		
		public static function getClassName(_object:*):String
		{
			if (_object is LayoutSprite) {
				if (LayoutSprite(_object).classname != null) return LayoutSprite(_object).classname;
			}
			
			
			return getOfficialClassName(_object);
		}
		
		public static function getOfficialClassName(_object:*):String
		{
			var _startlen:int = 8;
			var _endlen:int = 1;
			var _strobject:String = String(_object);
			var _str:String = _strobject.substr(_startlen, _strobject.length - _startlen - _endlen);
			return _str;
		}
		
		
		
		
		public static function formatObject(_object:*):String
		{
			var _str:String = "";
			
			//classname
			_str += "." + getClassName(_object);
			_str += " ";
			
			//id
			var _id:String = getIDbyObject(_object);
			if (_id != null) {
				//trace("_id "+_id);
				_str += "#" + _id;
			}
			
			
			_str += " ";
			//name
			if (_object is DisplayObject) {
				var _dobj:DisplayObject = DisplayObject(_object);
				if (_dobj.name.substr(0, 8) != "instance") _str += "*" + _dobj.name;
			}
			
			
			if (_id == null) {
				//template
				var _template:String = getTemplateObject(_object);
				if (_template != null && _template != "") {
					_str += "#tpl:" + _template;
				}
			}
			
			/*
			//default
			else _str += String(_object);
			*/
			return _str;
		}
		
		
		
		
		
		public static function debugDisplayObject(container:DisplayObjectContainer):void 
		{
			trace("########## DEBUG DisplayObject " + ObjectSearch.formatObject(container));
			debugDisplayObjectRec(container, 1);
			trace("##########");
		}
		
		
		private static function debugDisplayObjectRec(container:DisplayObjectContainer, _lvl:int):void 
		{
			var _len:int = container.numChildren;
			for (var i:int = 0; i < _len; i++) 
			{
				var _child:DisplayObject = container.getChildAt(i);
				var _str:String = "";
				for (var j:int = 0; j < _lvl; j++) _str += "   ";
				_str += ObjectSearch.formatObject(_child);
				_str += ", pos : " + _child.x + "," + _child.y;
				var _dims:Point;
				if (_child is DisplayObjectContainer) _dims = LayoutEngine.getObjectDimensions(DisplayObjectContainer(_child));
				else _dims = new Point(_child.width, _child.height);
				_str += ", dims : " + _dims.toString();
				trace(_str);
				if (_child is DisplayObjectContainer) debugDisplayObjectRec(DisplayObjectContainer(_child), _lvl+1);
			}
		}
		
		
		
		
		
		
		
		
		//___________________________________________________________________________________
		//private functions
		
		
		
		static private function getBehaviour(_interfaceSprite:InterfaceSprite, _classname:String):Behaviour 
		{
			var _behaviours:Array = _interfaceSprite.behaviours;
			var _len:int = _behaviours.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _b:Behaviour = Behaviour(_behaviours[i]);
				var _class:String = getClassName(_b);
				if (_class == _classname) return _b;
			}
			return null;
		}
		
		
		
		private static function getChildAtIndex(_dobjc:DisplayObjectContainer, _type:String, _value:String, _index:int, _indexCrochet:int):Object
		{
			var _breverse:Boolean = (_index < 0);
			if (_breverse) _index = -_index - 1;
			
			var _numchildren:int = _dobjc.numChildren;
			var _tabchildren:Array = new Array();
			for (var i:int = 0; i < _numchildren; i++) _tabchildren.push(_dobjc.getChildAt(i));
			if (_breverse) _tabchildren = _tabchildren.reverse();
			
			var _tabresult:Array = new Array();		//only if _indexcrochet ==-1 && plusieurs résults
			var _childresult:DisplayObject;
			
			var _countindex:int = -1;
			for (var i:int = 0; i < _numchildren; i++) 
			{
				var _child:DisplayObject = DisplayObject(_tabchildren[i]);
				var _bok:Boolean = false;
				if (_type == "*" && _child.name == _value) {
					_countindex++;
					_bok = true;
					if (_indexCrochet == -1) _tabresult.push(_child);
				}
				else if (_type == "." && getClassName(_child) == _value) {
					_countindex++;
					_bok = true;
					if (_indexCrochet == -1) _tabresult.push(_child);
				}
				
				if (_bok && _countindex == _index) {
					_childresult = _child;
				}
			}
			if (_tabresult.length > 1 && _indexCrochet == -1) return _tabresult;
			else return _childresult;
		}
		
		
		private static function getIDbyObject(_object:*):String
		{
			for (var _id:String in _listInstances) {
				if (_listInstances[_id] == _object) return _id;
			}
			return null;
		}
		
		
		static private function getTemplateObject(object:*):String 
		{
			if (object is InterfaceSprite) {
				return InterfaceSprite(object).template;
			}
			return "";
		}
		
		
		
		
	}

}