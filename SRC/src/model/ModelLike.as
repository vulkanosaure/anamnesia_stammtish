package model 
{
	/**
	 * ...
	 * @author Vinc
	 */
	public class ModelLike 
	{
		private static var _list:Array;
		
		public function ModelLike() 
		{
			
		}
		
		
		public static function reset():void
		{
			_list = new Array();
		}
		
		public static function add(_index:int):void 
		{
			if (_list == null) reset();
			_list.push(_index);
			
		}
		
		public static function getList():Array
		{
			return _list;
		}
		
		public static function getLength():int
		{
			if (_list == null) return 0;
			return _list.length;
		}
		
		static public function contains(_indexXML:int):Boolean 
		{
			return (_list.indexOf(_indexXML) != -1);
		}
		
		
	}

}