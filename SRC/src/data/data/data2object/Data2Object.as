package data.data.data2object 
{
	/**
	 * ...
	 * @author Vincent
	 */
	public class Data2Object
	{
		//_______________________________________________________________________________
		// properties
		
		
		private var _items:Array;
		private var _childrenClass:Class;
		private var _dataProvider:Object;
		private var _listProperties:Array;
		
		
		public function Data2Object() 
		{
			
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		
		public function set childrenClass(_value:Class):void
		{
			_childrenClass = _value;
		}
		
		public function set dataProvider(_value:Object):void
		{
			_items = new Array();
			
			if (_childrenClass == null) throw new Error("you must set childrenClass before setting dataProvider property");
			if (_listProperties == null) throw new Error("todo : listProperties auto");
			if (!_value is Array && !_value is XMLList) throw new Error("property dataProvider must be of type Array or XMLList");
			_dataProvider = _value;
			
			
			if(_value is XMLList) {
				//trace("xmllist type");
				var _childrens:XMLList = XMLList(_dataProvider).children();
				var _tabValues:Array
				for each(var _dataitem:XML in _childrens){
					
					_tabValues = new Array();
					
					//trace("_dataProvider[] : " + item);
					for (var _prop in _listProperties) {
						//trace("_prop : " + _listProperties[_prop]);
						
						var _value:* = getValue(_dataitem,  _listProperties[_prop]);
						//trace("_value : " + _value);
						_tabValues.push(_value);
						
					}
					
					//instancie Clas
					//l'objet résultant doit etre de type IData2Object
					var _item:IData2ObjectItem = new _childrenClass() as IData2ObjectItem;
					if (_item == null) throw new Error("class "+_childrenClass+" must implement IData2ObjectItem");
					//trace("_item : " + _item);
					_item.setProperties(_tabValues);
					_items.push(_item);
					
				}
			}
			else if (_value is Array) {
				throw new Error("todo array");
				
			}
		}
		
		public function get items():Array
		{
			return _items;
		}
		
		public function set listProperties(value:Array):void 
		{
			_listProperties = value;
			
		}
		
		
		
		//_______________________________________________________________________________
		// private functions
		
		private function getValue(_item:*, _prop:String):*
		{
			var _value:*;
			
			//handle "." in prop
			var _tabsplit:Array = _prop.split(".");
			_value = _item;
			var _len:int = _tabsplit.length;
			
			for (var i:int = 0; i < _len; i++) {
				
				var _subprop:String = _tabsplit[i];
				//trace("_subprop : " +_subprop);
				
				//handle [x] in prop
				var regex:RegExp = /\[:?(\d+)\]/;
				var _tabmatch:Array = regex.exec(_subprop);
				//trace("_tabmatch : " + _tabmatch);
				
				if (_tabmatch != null) {
					var _num:int = int(_tabmatch[1]);
					var _lenhook:int = _tabmatch[0].length;
					_subprop = _subprop.substr(0, _subprop.length - _lenhook);
					_value = _value[_subprop][_num];
				}
				else {
					_value = _value[_subprop];
				}
			}
			return _value;
		}
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}