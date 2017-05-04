package data2.fx.delay 
{
	/**
	 * ...
	 * @author 
	 */
	public class DelayManager 
	{
		
		public function DelayManager() 
		{
			throw new Error("is static");
		}
		
		private static var _items:Array;
		
		public static function add(_group:String, t:Number, f:Function, ...args):void
		{
			if (_items == null) _items = new Array();
			var _d:Delay = new Delay(t, f, args);
			_d.group = _group;
			_items.push(_d);
		}
		
		public static function reset():void
		{
			if (_items == null) _items = new Array();
			var _len:int = _items.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _d:Delay = Delay(_items[i]);
				if (_d != null && _d.waiting) _d.stop();
			}
			_items = new Array();
		}
		
		public static function resetGroup(_group:String):void
		{
			if (_items == null) _items = new Array();
			var _len:int = _items.length;
			for (var i:int = 0; i < _len; i++) 
			{
				var _d:Delay = Delay(_items[i]);
				if (_d != null && _d.group == _group && _d.waiting) _d.stop();
			}
			_items = new Array();
		}
	}

}