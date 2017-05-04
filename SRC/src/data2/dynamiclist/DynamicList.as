package data2.dynamiclist 
{
	import data2.math.Math2;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author 
	 */
	public class DynamicList extends EventDispatcher
	{	
		public static const NORMAL:String = "normal";
		public static const REVERSE:String = "reverse";
		public static const RANDOM:String = "random";
		
		private var _data:Array;
		private var _xmlList:XMLList;
		private var _xmlroot:String;
		private var _xmlitem:String;
		private var _classDynamicItem:Class;
		private var _classSeparator:Class;
		private var _index:int = -1;
		private var _order:String;
		
		public function DynamicList() 
		{
			_xmlroot = "";
			_order = DynamicList.NORMAL;
		}
		
		
		
		public function set data(value:Array):void 
		{
			_data = value;
		}
		
		
		public function get data():Array 
		{
			if (_data == null) _data = xml2array(_xmlList, _xmlroot, _xmlitem, _order);
			return _data;
		}
		
		
		
		public function set xmlList(value:Object):void 
		{
			if (value == null) {
				_xmlList = new XMLList();	//set empty xmllist if not defined
				return;
			}
			
			var __xmllist:XMLList;
			if (value is String) __xmllist = new XMLList(value);
			else if (value is XMLList) __xmllist = XMLList(value);
			else throw new Error("wrong format for property xmlList");
			_xmlList = __xmllist;
		}
		
		
		
		
		public function set xmlitem(value:String):void 
		{
			_xmlitem = value;
		}
		
		public function set xmlroot(value:String):void 
		{
			//trace("DynamicList.xmlroot = " + value);
			_xmlroot = value;
		}
		
		public function set classDynamicItem(value:Class):void 
		{
			_classDynamicItem = value;
		}
		
		public function set classSeparator(value:Class):void 
		{
			_classSeparator = value;
		}
		
		public function get classSeparator():Class 
		{
			return _classSeparator;
		}
		
		public function get length():int
		{
			if (_index != -1) return 1;
			if (_data == null) _data = xml2array(_xmlList, _xmlroot, _xmlitem, _order);
			return _data.length;
		}
		
		public function set index(value:int):void 
		{
			if (value < 0) throw new Error("DynamicList : index must be positive (" + value + ")");
			_index = value;
		}
		
		public function set order(value:String):void 
		{
			_order = value;
		}
		
		
		
		
		public function getDataByKey(_key:String, __index:int):String
		{
			if (_index != -1) __index = _index;
			
			if (_data == null) _data = xml2array(_xmlList, _xmlroot, _xmlitem, _order);
			if (__index >= _data.length) throw new Error("error DynamicList, " + _xmlroot + ", " + _xmlitem + ", _key : " + _key + ", _index : " + __index +"\nxmlList : \n" + _xmlList);
			
			
			var _obj:Object = _data[__index];
			
			var _tabkey:Array = _key.split(".");
			var _len:int = _tabkey.length;
			var _value:* = _obj;
			for (var j:int = 0; j < _len; j++) 
			{
				var _key:String = _tabkey[j];
				try { _value = _value[_key]; }
				catch (e:Error) {
					_value = "";
					break;
				}
			}
			
			return _value;
			
		}
		
		public function getData(__index:int):Object
		{
			if (_index != -1) __index = _index;
			
			if (_data == null) _data = xml2array(_xmlList, _xmlroot, _xmlitem, _order);
			if (__index >= _data.length) throw new Error("__index " + __index + " is out of bounds");
			var _obj:Object = _data[__index];
			return _obj;
			
		}
		
		private static function extractIndexValue(_str:String):Object
		{
			var _value:String;
			var _index:int;
			var _tabmatch:Array = _str.match(/(\w+)(\[(-?\d+)\])?/);
			//_tabmatch : city[0],city,[0],0
			//_tabmatch : city,city,,
			_value = _tabmatch[1];
			if (_tabmatch[3] != undefined) _index = int(_tabmatch[3]);
			else _index = -1;
			return {"value" : _value, "index" : _index};
		}
		
		
		
		public static function xml2array(_xmllist:XMLList, _xmlroot:String, _xmlitem:String, _order:String = "normal"):Array
		{
			if (_xmlitem == null) throw new Error("property xmlitem must be set");
			
			var _tab:Array = new Array();
			
			var _tabpath:Array = _xmlroot.split(".");
			var _lenpath:uint = (_xmlroot != "") ? _tabpath.length : 0;
			var _subxml:XMLList = _xmllist;
			for (var j:int = 0; j < _lenpath; j++) {
				
				var _indexValue:Object = extractIndexValue(_tabpath[j]);
				
				if (_indexValue.index == -1) _subxml = _subxml[_indexValue.value];
				else {
					_subxml = _subxml.children();
					var _count:int = 0;
					for (var _k:* in _subxml) {
						if (_count == _indexValue.index) {
							_subxml = new XMLList(_subxml[_k]);
							break;
						}
						_count++;
					}
					
				}
				
			}
			//trace("_subxml : " + _subxml);
			
			for (var i in _subxml[_xmlitem]) {
				var _xml:XMLList = XMLList(_subxml[_xmlitem][i]);
				//trace("_xml : ");
				var _obj:Object = new Object();
				
				var _children:XMLList = _xml.children();
				for each(var _x:XML in _children) {
					//trace("_xml.name : " + _x.name() + " _xml : " + _x);
					_obj[_x.name()] = _x;
				}
				_tab.push(_obj);
			}
			
			
			if (_order != DynamicList.NORMAL) {
				
				if (_order == DynamicList.REVERSE) {
					throw new Error("todo reverse");
				}
				else if (_order == DynamicList.RANDOM) {
					
					_tab = shuffleArray(_tab);
					
				}
			}
			
			
			return _tab;
		}
		
		
		
		public static function shuffleArray(_tabsrc:Array):Array
		{
			var _newtab:Array = new Array();
			
			
			var _len:int = _tabsrc.length;
			var _tabsrccopy:Array = new Array();
			for (var i:int = 0; i < _len; i++) _tabsrccopy.push(_tabsrc[i]);
			
			for (var i:int = 0; i < _len; i++) 
			{
				var _randsrc:int = Math2.random(0, _tabsrccopy.length - 1);
				var _itemrand:* = _tabsrccopy[_randsrc];
				_newtab.push(_itemrand);
				_tabsrccopy.splice(_randsrc, 1);
			}
			return _newtab;
		}
		
		
		
		static public function selectRandArray(_tab:Array, _nb:int):Array 
		{
			var _output:Array = new Array();
			var _tablen:int = _tab.length;
			var _proba:Number = 1 / _tablen;
			
			var _tabcopy:Array = new Array();
			for (var i:int = 0; i < _tablen; i++) _tabcopy.push(_tab[i]);
			
			var _nbselected:int = 0;
			var _counter:int = 0;
			while (_nbselected < _nb)
			{
				if (Math2.getRandProbability(_proba)) {
					_output.push(_tabcopy[_counter]);
					_tabcopy.splice(_counter, 1);
					_nbselected++;
					_tablen = _tabcopy.length;
				}
				
				_counter++;
				if (_counter >= _tablen) _counter = 0;
			}
			
			return _output;
			
		}
		
		
		
	}

}