package data2.layoutengine 
{
	import data2.asxml.ObjectSearch;
	/**
	 * ...
	 * @author Vincent
	 */
	public class LayoutQueue extends Object
	{
		//_______________________________________________________________________________
		// properties
		
		
		private var _list:Array;
		
		public function LayoutQueue() 
		{
			_list = new Array();
		}
		
		
		
		//_______________________________________________________________________________
		// public functions
		
		public function add(_obj:Object, _nodoublon:Boolean=true):void
		{
			if (!_nodoublon || _list.indexOf(_obj) == -1) _list.push(_obj);
		}
		
		public function getChildAt(_index:int):Object
		{
			return _list[_index];
		}
		
		public function contains(_obj):Boolean
		{
			return (_list.indexOf(_obj)!=-1);
		}
		public function get length():int
		{
			return _list.length;
		}
		public function reset():void
		{
			_list = new Array();
		}
		public function toString():String
		{
			var _str:String = "";
			var len:int = _list.length;
			var _tab:Array = new Array();
			for (var i:int = 0; i < len; i++) 
			{
				var _item:* = _list[i];
				_tab.push(ObjectSearch.formatObject(_item));
			}
			
			return _tab.join(", ");
		}
		
		
		//_______________________________________________________________________________
		// private functions
		
		
		
		
		
		
		//_______________________________________________________________________________
		// events
		
		
		
	}

}