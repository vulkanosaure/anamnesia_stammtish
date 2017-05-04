package data.utils 
{
	/**
	 * ...
	 * @author Vincent
	 */
	public class DataAssoc
	{
		
		private var items:Array = new Array();
		
		
		public function DataAssoc() 
		{
			
		}
		
		public function register(_key:*, _value:*):void
		{
			var _indkey:int = getIndKey(_key);
			if (_indkey == -1) items.push([_key, _value]);
			else items[_indkey][1] = _value;
		}
		
		public function get(_key:*):*
		{
			var _len:int = items.length;
			for (var i:int = 0; i < _len; i++) {
				if (items[i][0] == _key) return items[i][1];
			}
			throw new Error("DataAssoc, association with key " + _key + " wasn't found");
		}
		
		public function remove(_key:*):void
		{
			var _indkey:int = getIndKey(_key);
			items.splice(_indkey, 1);
		}
		
		
		
		private function getIndKey(_key:*):int
		{
			var _len:int = items.length;
			for (var i:int = 0; i < _len; i++) {
				if (items[i][0] == _key) return i;
			}
			return -1;
		}
		
	}

}