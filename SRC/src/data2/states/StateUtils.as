package data2.states 
{
	import data2.layoutengine.LayoutSprite;
	import data2.asxml.ObjectSearch;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class StateUtils 
	{
		public static const DOBJ_DEF_CLASS:String = "dobj_def_class";
		public static const DOBJ_DEF_NAME:String = "dobj_def_name";
		public static const DOBJ_DEF_ID:String = "dobj_def_id";
		
		public function StateUtils() 
		{
			throw new Error("is static");
		}
		
		
		
		
		private static var _typedef:String;
		private static var _listdobj:Array;
		private static var _id:String;
		private static var _name:String;
		private static var _classname:String;
		private static var _classFound:Boolean;
		private static var _nameFound:Boolean;
		private static var _dobj:DisplayObject;
		
		private static var _cache:Object;
		
		
		
		
		
		
		
		public static function getDisplayObjectDefValue(_str:String):String
		{
			var _len:int = _str.length;
			return _str.substr(1, _len - 1);
		}
		
		
		
		public static function getDisplayObjectDefType(_str:String):String
		{
			var _firstchar:String = _str.charAt(0);
			if (_firstchar == "#") return DOBJ_DEF_ID;
			else if (_firstchar == ".") return DOBJ_DEF_CLASS;
			else if (_firstchar == "*") return DOBJ_DEF_NAME;
			throw new Error("wrong prefix for DisplayOBjectDef \"" + _str + "\"");
		}
		
		
		static public function getListByDobjdef(_container:DisplayObjectContainer, _dobjdef:String):Array
		{
			var _type:String = StateUtils.getDisplayObjectDefType(_dobjdef);
			var _value:String = StateUtils.getDisplayObjectDefValue(_dobjdef);
			var _listdobj:Array = StateUtils.getDisplayObjectList(_container, _value, _type);
			return _listdobj;
		}
		
		
		
		static public function getDisplayObjectByClass(__basecontainer:DisplayObjectContainer, __classname:String):Array
		{
			_typedef = DOBJ_DEF_CLASS;
			_listdobj = new Array();
			_classname = __classname;
			_id = "";
			_nameFound = false;
			_classFound = false;
			rec(__basecontainer);
			return _listdobj;
		}
		static public function getDisplayObjectByName(__basecontainer:DisplayObjectContainer, __name:String):Array
		{
			_typedef = DOBJ_DEF_NAME;
			_listdobj = new Array();
			_classname = "";
			_name = __name;
			_nameFound = false;
			_classFound = false;
			
			rec(__basecontainer);
			return _listdobj;
		}
		
		
		
		static public function getDisplayObjectList(_container:DisplayObjectContainer, _name:String, _type:String):Array
		{
			var _list:Array;
			
			var _idcache:String = ObjectSearch.getClassName(_container) + _container.name + _name + _type;
			
			if (_cache == null) _cache = new Object();
			if (_cache[_idcache] != undefined) {
				//trace("get list by cache");
				_list = _cache[_idcache];
			}
			else{
				if (_type == StateUtils.DOBJ_DEF_CLASS) {
					_list = StateUtils.getDisplayObjectByClass(_container, _name);
					var _len:int = _list.length;
					//if (_len == 0) throw new Error("DisplayObject class ." + _name + " wasn't found in container " + ObjectSearch.formatObject(_container));
				}
				else if (_type == StateUtils.DOBJ_DEF_NAME) {
					_list = StateUtils.getDisplayObjectByName(_container, _name);
					var _len:int = _list.length;
					//if (_len == 0) throw new Error("DisplayObject name *" + _name + " wasn't found in container " + ObjectSearch.formatObject(_container));
				} 
				else if(_type == StateUtils.DOBJ_DEF_ID) {
					_list = new Array();
					_list.push(ObjectSearch.getID(_name));
				}
				
				var _idcache:String = ObjectSearch.getClassName(_container) + _container.name + _name + _type;
				_cache[_name + _type] = _list;
			}
			return _list;
		}
		
		
		
		
		static private function rec(_dobjc:DisplayObjectContainer):void
		{
			var _len:int = _dobjc.numChildren;
			for (var i:int = 0; i < _len; i++) 
			{
				_classFound = false;
				_nameFound = false;
				
				var _child:DisplayObject = _dobjc.getChildAt(i);
				//trace("test child " + _child + " with name : " + _child.name + ", classname : "+getClassName(_child)+",  against " + _id+_classname);
				
				if (_typedef == DOBJ_DEF_NAME) {
					if (_child.name == _name) {
						_listdobj.push(_child);
						_nameFound = true;
					}
				}
				else if(_typedef == DOBJ_DEF_CLASS) {
					if (ObjectSearch.getClassName(_child) == _classname) {
						_listdobj.push(_child);
						_classFound = true;
					}
				}
				
				if (_child is DisplayObjectContainer) {
					
					if ((_typedef == DOBJ_DEF_NAME && !_nameFound) ||
						(_typedef == DOBJ_DEF_CLASS && !_classFound)) 
						{
						rec(DisplayObjectContainer(_child));
					}
				}
			}
		}
		
		
		
		
	}

}