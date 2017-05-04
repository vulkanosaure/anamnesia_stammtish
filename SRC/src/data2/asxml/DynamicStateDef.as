package data2.asxml 
{
	/**
	 * ...
	 * @author 
	 */
	public dynamic class DynamicStateDef 
	{
		private var _index:int;
		private var _htmltitle:String;
		
		
		public function StateDef() 
		{
			
			
			
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void 
		{
			_index = value;
		}
		
		public function get htmltitle():String 
		{
			return _htmltitle;
		}
		
		public function set htmltitle(value:String):void 
		{
			_htmltitle = value;
		}
		
	}

}